#pragma once

#include <QObject>

class Backend : public QObject
{
    Q_OBJECT

public:
    explicit Backend(QObject *parent = nullptr);
    Q_INVOKABLE void applyWatermark(int imgWidth,int imgHeight,int watermarkX,int watermarkY, int watermarkWidth,int watermarkHeight,QString watermarkPath) const;
};

