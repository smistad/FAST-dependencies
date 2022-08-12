# Download and build Qt5

create_package_target(qt5 5.15.2)

# List of modules can be found in git repo here: github.com/qt/qt5
set(MODULES_TO_EXCLUDE
        -skip qt3d
        #-skip qtactiveqt
        -skip qtandroidextras
        -skip qtcanvas3d
        -skip qtcharts
        -skip qtconnectivity
        -skip qtdatavis3d
        -skip qtdeclarative
        -skip qtdoc
        #-skip qtdocgallery
        -skip qtfeedback
        -skip qtgamepad
        -skip qtgraphicaleffects
        #-skip qtimageformats
        -skip qtlocation
        -skip qtlottie
        -skip qtmacextras
        -skip qtnetworkauth
        -skip qtpim
        -skip qtpurchasing
        -skip qtqa
        -skip qtquick3d
        -skip qtquickcontrols
        -skip qtquickcontrols2
        -skip qtquicktimeline
        -skip qtremoteobjects
        -skip qtrepotools
        -skip qtscript
        -skip qtscxml
        -skip qtsensors
        -skip qtserialbus
        #-skip qtserialport
        -skip qtspeech
        #-skip qtsvg
        -skip qtsystems
        -skip qttools
        -skip qttranslations
        -skip qtvirtualkeyboard
        -skip qtwayland
        -skip qtwebchannel
        -skip qtwebengine
        -skip qtwebglplugin
        -skip qtwebsockets
        -skip qtwebview
        -skip qtwinextras
        -skip qtx11extras
        -skip qtxmlpatterns
        )
set(LIBS
	Qt5Core
	Qt5Gui
	Qt5Widgets
	Qt5OpenGL
	Qt5Multimedia
	Qt5MultimediaWidgets
	Qt5PrintSupport
	Qt5SerialPort
	Qt5Network
)
if(WIN32)
  set(OPENSSL_DIR "" CACHE PATH "OpenSSL dir")
  if(OPENSSL_DIR STREQUAL "")
    message( FATAL_ERROR "You must set OPENSSL_DIR when building Qt5 on windows" )
  endif()
	#set(BUILD_COMMAND set CL=/MP; nmake)
	set(BUILD_COMMAND nmake)
	set(CONFIGURE_COMMAND ${SOURCE_DIR}/configure.bat)
	set(URL "http://download.qt.io/archive/qt/5.15/5.15.5/single/qt-everywhere-opensource-src-5.15.5.zip")
	set(URL_HASH SHA256=08ed914924330b99412068eb66301c455291af9eba33e499acff97ef474e5309)
	set(OPTIONS
            -opensource;
            -confirm-license;
            -release;
            -no-compile-examples;
            -no-libproxy;
            -nomake tools;
            -nomake tests;
            -opengl desktop;
            -qt-zlib;
            -qt-libpng;
            -qt-libjpeg;
            -qt-freetype;
            ${MODULES_TO_EXCLUDE};
            -openssl-linked OPENSSL_PREFIX=${OPENSSL_DIR};
	)
  message(${OPTIONS})
	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(GLOB FILES ${SOURCE_DIR}/LICENSE.*)
	foreach(ARG $\{FILES\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/qt5/)
	endforeach()
	file(COPY ${INSTALL_DIR}/include DESTINATION ${POST_INSTALL_DIR}/)
	file(GLOB LIBS ${INSTALL_DIR}/lib/*.lib)
	foreach(ARG $\{LIBS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/)
	endforeach()
	file(GLOB DLLS ${INSTALL_DIR}/bin/*.dll)
	foreach(ARG $\{DLLS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/bin/)
	endforeach()
	file(COPY ${INSTALL_DIR}/plugins/ DESTINATION ${POST_INSTALL_DIR}/plugins/)
	file(COPY ${INSTALL_DIR}/bin/moc.exe DESTINATION ${POST_INSTALL_DIR}/bin/)
	file(COPY ${INSTALL_DIR}/bin/rcc.exe DESTINATION ${POST_INSTALL_DIR}/bin/)
	file(COPY ${INSTALL_DIR}/bin/idc.exe DESTINATION ${POST_INSTALL_DIR}/bin/)
	")
else()
	set(BUILD_COMMAND make -j4)
	set(CONFIGURE_COMMAND ${SOURCE_DIR}/configure)
	set(URL "https://download.qt.io/archive/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz")
	set(URL_HASH SHA256=3a530d1b243b5dec00bc54937455471aaa3e56849d2593edb8ded07228202240)
    if(APPLE)
        set(OPTIONS
            -opensource;
            -confirm-license;
            -release;
            -no-compile-examples;
            -no-libproxy;
            -nomake tools;
            -nomake tests;
            -opengl desktop;
            -qt-zlib;
            -qt-libpng;
            -qt-libjpeg;
            -qt-freetype;
            -qt-harfbuzz;
            -qt-pcre;
            -no-directfb;
            -no-framework;
            -no-icu;
            ${MODULES_TO_EXCLUDE}
        )

	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(GLOB FILES ${SOURCE_DIR}/LICENSE.*)
	foreach(ARG $\{FILES\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/qt5/)
	endforeach()
	file(COPY ${INSTALL_DIR}/include DESTINATION ${POST_INSTALL_DIR}/)
	file(GLOB LIBS ${INSTALL_DIR}/lib/*.dylib*)
	foreach(ARG $\{LIBS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	endforeach()
	file(COPY ${INSTALL_DIR}/plugins/ DESTINATION ${POST_INSTALL_DIR}/plugins/)
	file(COPY ${INSTALL_DIR}/bin/moc DESTINATION ${POST_INSTALL_DIR}/bin/)
	file(COPY ${INSTALL_DIR}/bin/rcc DESTINATION ${POST_INSTALL_DIR}/bin/)
	")

    else()
	# Linux
        set(OPTIONS
            -opensource;
            -confirm-license;
            -release;
            -no-compile-examples;
            -no-libproxy;
            -nomake tools;
            -nomake tests;
            -opengl desktop;
            -qt-zlib;
            -qt-libpng;
            -qt-libjpeg;
            -qt-freetype;
            -qt-harfbuzz;
            -qt-pcre;
            -bundled-xcb-xinput
            -no-directfb;
            -no-linuxfb;
            -no-icu;
            ${MODULES_TO_EXCLUDE};
            -openssl-linked;
        )

	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(GLOB FILES ${SOURCE_DIR}/LICENSE.*)
	foreach(ARG $\{FILES\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/qt5/)
	endforeach()
	file(COPY ${INSTALL_DIR}/include DESTINATION ${POST_INSTALL_DIR}/)
	file(GLOB LIBS ${INSTALL_DIR}/lib/*.so*)
	foreach(ARG $\{LIBS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	endforeach()
	file(COPY ${INSTALL_DIR}/plugins/ DESTINATION ${POST_INSTALL_DIR}/plugins/)
	file(COPY ${INSTALL_DIR}/bin/moc DESTINATION ${POST_INSTALL_DIR}/bin/)
	file(COPY ${INSTALL_DIR}/bin/rcc DESTINATION ${POST_INSTALL_DIR}/bin/)
    file(GLOB installedSOs ${POST_INSTALL_DIR}/lib/*.so*)
    foreach(SO $\{installedSOs\})
        message(\"-- Setting runtime path of $\{SO\}\")
        execute_process(COMMAND patchelf --set-rpath \"$ORIGIN/../lib\" $\{SO\})
    endforeach()
	")
    endif()
endif()

ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        URL ${URL}
        URL_HASH ${URL_HASH}
        CONFIGURE_COMMAND
            ${CONFIGURE_COMMAND}
	    -prefix ${INSTALL_DIR};
            ${OPTIONS}
        BUILD_COMMAND
            ${BUILD_COMMAND}
        INSTALL_COMMAND
            ${BUILD_COMMAND} install

)
