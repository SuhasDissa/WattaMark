#pragma once

#include <QObject>

class Backend : public QObject
{
    Q_OBJECT

public:
    explicit Backend(QObject *parent = nullptr);
    Q_INVOKABLE void applyWatermark(int watermarkX, int watermarkY, QString watermarkG, QString watermarkPath, QString imagePath, QString filename);
};
