#include "backend.h"
#include <iostream>
#include <Magick++.h>

using namespace Magick;
Backend::Backend(QObject *parent)
    : QObject(parent)
{
}

void Backend::applyWatermark(int watermarkX, int watermarkY, QString watermarkG, QString watermarkPath, QString imagePath, QString filename)
{

    InitializeMagick("");
    Image alpha, beta;
    alpha.read(imagePath.toStdString());
    beta.read(watermarkPath.toStdString());
    beta.resize(Geometry(watermarkG.toStdString()));
    alpha.composite(beta, watermarkX, watermarkY, OverCompositeOp);
    alpha.write(filename.toStdString());
}
