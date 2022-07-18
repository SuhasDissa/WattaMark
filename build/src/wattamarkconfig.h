// This file is generated by kconfig_compiler_kf5 from wattamarkconfig.kcfg.
// All changes you do to this file will be lost.
#ifndef WATTAMARKCONFIG_H
#define WATTAMARKCONFIG_H

#include <kconfigskeleton.h>
#include <QCoreApplication>
#include <QDebug>

class WattaMarkConfig : public KConfigSkeleton
{
  Q_OBJECT
  public:

    static WattaMarkConfig *self();
    ~WattaMarkConfig() override;

    /**
      Set Some setting description
    */
    static
    void setSomeSetting( bool v )
    {
      if (v != self()->mSomeSetting && !self()->isSomeSettingImmutable()) {
        self()->mSomeSetting = v;
        Q_EMIT self()->someSettingChanged();
      }
    }

    Q_PROPERTY(bool someSetting READ someSetting WRITE setSomeSetting NOTIFY someSettingChanged)
    Q_PROPERTY(bool isSomeSettingImmutable READ isSomeSettingImmutable CONSTANT)
    /**
      Get Some setting description
    */
    static
    bool someSetting()
    {
      return self()->mSomeSetting;
    }

    /**
      Is Some setting description Immutable
    */
    static
    bool isSomeSettingImmutable()
    {
      return self()->isImmutable( QStringLiteral( "someSetting" ) );
    }

    /**
      Get Some setting description default value
    */
    static
    bool defaultSomeSettingValue()
    {
        return defaultSomeSettingValue_helper();
    }


    enum {
      signalSomeSettingChanged = 0x1
    };

  Q_SIGNALS:
    void someSettingChanged();

  private:
    void itemChanged(quint64 flags);

  protected:
    WattaMarkConfig(QObject *parent = nullptr);
    friend class WattaMarkConfigHelper;


    // General
    bool mSomeSetting;
    static bool defaultSomeSettingValue_helper();

  private:
};

#endif
