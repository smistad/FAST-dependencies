# Download and build Qt5

create_package_target(qt5 5.14.0)

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
        -skip qtdocgallery
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
	#set(BUILD_COMMAND set CL=/MP; nmake)
	set(BUILD_COMMAND nmake)
	set(CONFIGURE_COMMAND ${SOURCE_DIR}/configure.bat)
	set(URL "http://download.qt.io/archive/qt/5.14/5.14.0/single/qt-everywhere-src-5.14.0.zip")
	set(URL_HASH SHA256=0e4a3f096a3f331393240570fb4271f3f1f5a3b9c041252f6245e8dd789c96df)
	set(OPTIONS
            -opensource;
            -confirm-license;
            -release;
            -no-compile-examples;
            -no-openssl;
            -no-libproxy;
            -nomake tools;
            -nomake tests;
            -opengl desktop;
            -qt-zlib;
            -qt-libpng;
            -qt-libjpeg;
            -qt-freetype;
            ${MODULES_TO_EXCLUDE}
	)
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
	file(COPY ${INSTALL_DIR}/bin/idc.exe DESTINATION ${POST_INSTALL_DIR}/bin/)
	")
else()
	set(BUILD_COMMAND make -j4)
	set(CONFIGURE_COMMAND ${SOURCE_DIR}/configure)
	set(URL "http://download.qt.io/archive/qt/5.14/5.14.0/single/qt-everywhere-src-5.14.0.tar.xz")
	set(URL_HASH SHA256=be9a77cd4e1f9d70b58621d0753be19ea498e6b0da0398753e5038426f76a8ba)
    if(APPLE)
        set(OPTIONS
            -opensource;
            -confirm-license;
            -release;
            -no-compile-examples;
            -no-openssl;
            -no-libproxy;
            -nomake tools;
            -nomake tests;
            -opengl desktop;
            -qt-zlib;
            -qt-libpng;
            -qt-libjpeg;
            -no-directfb;
            -no-framework;
            ${MODULES_TO_EXCLUDE}
        )
    else()
	# Linux
        set(OPTIONS
            -opensource;
            -confirm-license;
            -release;
            -no-compile-examples;
	    -no-openssl;
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
            -qt-xcb;
            -no-directfb;
            -no-linuxfb;
            -no-icu;
            ${MODULES_TO_EXCLUDE}
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
