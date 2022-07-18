# CMake generated Testfile for 
# Source directory: /home/suhasdissa/Documents/KDE/WattaMark
# Build directory: /home/suhasdissa/Documents/KDE/WattaMark/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(appstreamtest "/usr/bin/cmake" "-DAPPSTREAMCLI=/usr/bin/appstreamcli" "-DINSTALL_FILES=/home/suhasdissa/Documents/KDE/WattaMark/build/install_manifest.txt" "-P" "/usr/share/ECM/kde-modules/appstreamtest.cmake")
set_tests_properties(appstreamtest PROPERTIES  _BACKTRACE_TRIPLES "/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;162;add_test;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;180;appstreamtest;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;0;;/home/suhasdissa/Documents/KDE/WattaMark/CMakeLists.txt;18;include;/home/suhasdissa/Documents/KDE/WattaMark/CMakeLists.txt;0;")
subdirs("src")
