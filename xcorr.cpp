#include "xcorr.h"

xcorr::xcorr(QWidget *parent)
    : QWidget(parent)
{
// Create needed objects
    player = new QMediaPlayer(this);
    probe = new QVideoProbe(this);

// Connect objects
    // 'probe' will eavesdrop the frames "displayed" by 'player'
    probe->setSource(player);
    // when 'probe' eavesdropped a frame call 'processFrame'
    connect(probe, SIGNAL(videoFrameProbed(QVideoFrame)), this, SLOT(processFrame(QVideoFrame)));

// Do heavy stuff on a new Thread
    m_processor.moveToThread(&m_processorThread);
    qRegisterMetaType<QVector<qreal> >("QVector<qreal>");
    connect(&m_processor, SIGNAL(dataReady(int,int)), SLOT(addData(int,int)));
    m_processorThread.start(QThread::HighPriority);

}

xcorr::~xcorr()
{
    m_processorThread.quit();
    m_processorThread.wait(10000);
}


int xcorr::startParsing( QString file ){
// Reset internal variables;
    m_numFrames = 0;
    m_numFrames_ref = 0;
    m_dropped   = 0;
    m_isBusy    = false;
    m_parsing_finished = false;

// Start game!
    player->setMedia(QUrl(file));
    player->play();
    player->setPlaybackRate(32);

    return 1;
}

void xcorr::processFrame(QVideoFrame frame){

    if (m_isBusy){ //drop frame
        m_dropped++;
        return;
    }

    m_isBusy = true;
    QMetaObject::invokeMethod(&m_processor, "processFrame",
                              Qt::QueuedConnection, Q_ARG(QVideoFrame, frame) );
}

void xcorr::addData( int timestamp, int mean ){

    m_isBusy = false;
    m_mean[m_numFrames] = mean;
    m_timestamp[m_numFrames] = timestamp;
    m_numFrames++;

    if( m_numFrames%500 == 0 && timestamp > 180000 ){
        tryToCorr(m_numFrames);
        if( timestamp > 250000 ){
            videoParsingFinished();
        }
    }
}

void xcorr::publishVideoData(){
    if( !m_parsing_finished ) return;
    QString time = "[";
    QString mean = "[";

    for( int i=0; i< m_numFrames; i++ ){
        QTextStream(&mean) << m_mean[i] << ",";
        QTextStream(&time) << m_timestamp[i] << ",";
    }
    emit videoDataReady(time+"0]",mean+"0]");
}

void xcorr::videoParsingFinished(){
    tryToCorr(m_numFrames);
    m_parsing_finished = true;
    publishVideoData();
}


void xcorr::tryToCorr(int N){
    if( m_numFrames_ref == 0 ){
        emit corrResult(-1,0,1);
        return;
    }
    if( N == 0 ){
        emit corrResult(-2,0,1);
        return;
    }
// Init variables
    int step = 100; //ms
    float offset_vector[10000];
    for(int i = 0; i<10000; i++){
        offset_vector[i] = 0;
    }

// Normalize signals (zero mean) FIXME we are assuming both have same energy (which is not true)
    // FIXME mean are int values!??
    int tot = 0;
    for(int i = 0; i<N; i++) tot+= m_mean[i];

    int tot_ref = 0;
    for(int i = 0; i<m_numFrames_ref; i++) tot_ref+= m_mean_ref[i];


// Compute cross correlation
    qDebug() << "Processor stats: dropped "<< m_dropped << " out of " << m_numFrames+m_dropped << " frames.";
    qDebug() << "Computing xcorr bt " << N << " and " << m_numFrames_ref << " points. Being tot "<<tot/N<<" and tot_ref "<<tot_ref/m_numFrames_ref;
    for( int c = 0; c< N; c++ ){
        for( int r = 0; r< m_numFrames_ref; r++){
            int offset = ( m_timestamp[c] - m_timestamp_ref[r] )/step + 5000;
            offset_vector[offset] += ( m_mean[c] -tot/N ) * ( m_mean_ref[r] - tot_ref/m_numFrames_ref );
        }
    }

// Find max
    int max = 0;
    int max_i = 0;
    for(int i = 0; i<10000; i++){
        //qDebug() << offset_vector[i];
        if( offset_vector[i] > max ){
            max_i = i;
            max = offset_vector[i];
        }
    }

    qDebug() << "Stimated offset: " << -(max_i-5000)*step/1000 << "s. Step: " << step << "ms.";
    emit corrResult(1,-(max_i-5000)*step/1000,1);
}

int xcorr::setRef (QVariantList mean, QVariantList time)
{
    if (mean.size() && mean.size() == time.size() )
    {
        int size = mean.size();
        for (int i = 0; i < size; ++i) {
            m_mean_ref[i]      = mean[i].toInt();
            m_timestamp_ref[i] = time[i].toInt();
        }
        m_numFrames_ref = size;
        qDebug() << "Values "<< m_numFrames_ref << " set! ";
        tryToCorr(m_numFrames);
        return 1;
    }
    qDebug() << "Fatal error setting arguments!! VideoCalib will fail because mean.size() = "<< mean.size();
    return 0;
}


void FrameProcessor::processFrame(QVideoFrame frame )
{
    double tot = 0;

    do {

        if (!frame.map(QAbstractVideoBuffer::ReadOnly)){
            qDebug() << "Unable to map frame!";
            break;
        }

        if (frame.pixelFormat() == QVideoFrame::Format_YUV420P ||
            frame.pixelFormat() == QVideoFrame::Format_NV12) {
            // Process YUV data
            uchar *b = frame.bits();
            for (int y = 0; y < frame.height(); y++) {
                uchar *lastPixel = b + frame.width();
                for (uchar *curPixel = b; curPixel < lastPixel; curPixel++){
                    if(*curPixel != 16 ) tot += *curPixel;
                    //histogram[(*curPixel * levels) >> 8] += 1.0;
                }
                b += frame.bytesPerLine();
            }
        } else {
            QImage::Format imageFormat = QVideoFrame::imageFormatFromPixelFormat(frame.pixelFormat());
            if (imageFormat != QImage::Format_Invalid) {
                // Process RGB data
                QImage image(frame.bits(), frame.width(), frame.height(), imageFormat);
                image = image.convertToFormat(QImage::Format_RGB32);

                const QRgb* b = (const QRgb*)image.bits();
                for (int y = 0; y < image.height(); y++) {
                    const QRgb *lastPixel = b + frame.width();
                    for (const QRgb *curPixel = b; curPixel < lastPixel; curPixel++){
                        //histogram[(qGray(*curPixel) * levels) >> 8] += 1.0;
                        if(*curPixel != 16 ) tot+= qGray(*curPixel);
                    }
                    b = (const QRgb*)((uchar*)b + image.bytesPerLine());
                }
            }
        }

        frame.unmap();
    } while (false);

    // Compute mean
    int mean = tot/frame.width()/frame.height();
    int timestamp = frame.startTime()/1000;
    emit dataReady(timestamp,mean);
}

