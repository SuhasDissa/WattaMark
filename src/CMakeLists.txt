# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2022 Suhas Dissanayake <suhasdissa@protonmail.com>

add_executable(wattamark
    main.cpp
    about.cpp
    app.cpp
    backend.cpp
    resources.qrc)

target_link_libraries(wattamark
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Svg
    KF5::I18n
    KF5::CoreAddons
    KF5::ConfigCore
    KF5::ConfigGui
    ${ImageMagick_LIBRARIES})

if (ANDROID)
    kirigami_package_breeze_icons(ICONS
        list-add
        help-about
        application-exit
        applications-graphics
    )
endif()

kconfig_add_kcfg_files(wattamark GENERATE_MOC wattamarkconfig.kcfgc)
install(TARGETS wattamark ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
