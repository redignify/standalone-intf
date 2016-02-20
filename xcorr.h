#ifndef XCORR_H
#define XCORR_H

#include <QWidget>
#include <QMediaPlayer>
#include <QVideoProbe>
#include <QVideoFrame>
#include <QThread>
#include <QDebug>

class FrameProcessor: public QObject
{
    Q_OBJECT
public slots:
    void processFrame(QVideoFrame frame);

signals:
    void dataReady(int timestamp, int mean);
};


class xcorr : public QWidget
{
    Q_OBJECT

private:
    QMediaPlayer *player;
    QVideoProbe *probe;

    int m_mean[10000];
    int m_timestamp[10000];
    int m_numFrames;

    int m_mean_ref[10000];
    int m_timestamp_ref[10000];
    int m_numFrames_ref;

    int m_dropped;
    bool m_parsing_finished;

    void tryToCorr(int n);
    void videoParsingFinished();

    FrameProcessor m_processor;
    QThread m_processorThread;
    bool m_isBusy;

public slots:
    void processFrame(QVideoFrame frame);
    void addData( int timestamp, int mean );

signals:
    void corrResult(int status, float offset, float speed );
    void videoDataReady(QString timestamp, QString mean );

public:
    explicit xcorr(QWidget *parent = 0);
    ~xcorr();
    Q_INVOKABLE int startParsing( QString );
    Q_INVOKABLE int setRef(QVariantList mean, QVariantList time);
    Q_INVOKABLE void publishVideoData();
};

#endif // XCORR_H
