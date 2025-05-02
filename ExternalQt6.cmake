# Download and build Qt6

create_package_target(qt6 6.9.0)

set(MODULES 
	qtbase
	qtactiveqt
	qtimageformats
	qtmultimedia
	qtsvg # Needed for jkqtplotter
	#qtdeclarative # Quick is needed by ffmpeg backend, why?? Only if egls is enabled
)
string(JOIN "," MODULES_STRING ${MODULES})

set(MODULES_TO_EXCLUDE
        -skip qt3d
        #-skip qtactiveqt
        -skip qtandroidextras
        -skip qtcanvas3d
        -skip qtcharts
        -skip qtconnectivity
        -skip qtdatavis3d
	-skip qtdeclarative
        -skip qtgraphs
        -skip qtmqtt
	-skip qtopcua
        -skip qtdoc
	-skip qtquick3dphysics
	-skip qtquickeffectmaker
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
        -skip qtserialport
        -skip qtspeech
	#-skip qtsvg # Needed for jkqtplotter
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
	-no-feature-spatialaudio
	-no-feature-testlib
	#-no-feature-printsupport # Needed for jkqtplotter
	-no-feature-sql
	-no-feature-eglfs
	#-feature-gstreamer
)

if(WIN32)
  set(OPENSSL_DIR "" CACHE PATH "OpenSSL dir")
  if(OPENSSL_DIR STREQUAL "")
    message( FATAL_ERROR "You must set OPENSSL_DIR when building Qt6 on windows" )
  endif()
	#set(BUILD_COMMAND set CL=/MP; nmake)
	set(BUILD_COMMAND nmake)
	set(CONFIGURE_COMMAND ${SOURCE_DIR}/configure.bat)
	set(URL "https://download.qt.io/archive/qt/6.9/6.9.0/single/qt-everywhere-src-6.9.0.zip")
	set(URL_HASH SHA256=94e83ee099e644bb89fe84557551bdba917c50bb1e441eb768f98741e5ddb4b8)
	set(OPTIONS
            -opensource;
            -confirm-license;
            -release;
            -no-libproxy;
            -nomake tools;
            -nomake tests;
            -opengl desktop;
            -qt-zlib;
            -qt-libpng;
            -qt-libjpeg;
            -qt-freetype;
	    -submodules ${MODULES_STRING};
	    ${MODULES_TO_EXCLUDE};
            -openssl-linked OPENSSL_PREFIX=${OPENSSL_DIR};
	    -feature-ffmpeg;
	    -ffmpeg-dir ${TOP_BUILD_DIR}/ffmpeg/install/;
	    -DQT_BUILD_EXAMPLES_BY_DEFAULT=OFF;
	    -DQT_BUILD_TESTS_BY_DEFAULT=OFF;
	    -DQT_BUILD_TOOLS_BY_DEFAULT=OFF;
	)
  message(${OPTIONS})
	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(GLOB FILES ${SOURCE_DIR}/LICENSES/*.txt)
	foreach(ARG $\{FILES\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/qt6/)
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
	set(URL "https://download.qt.io/archive/qt/6.9/6.9.0/single/qt-everywhere-src-6.9.0.tar.xz")
	set(URL_HASH SHA256=4f61e50551d0004a513fefbdb0a410595d94812a48600646fb7341ea0d17e1cb)
    if(APPLE)
	if("${CMAKE_OSX_ARCHITECTURES}" STREQUAL "arm64")
		set(OPTIONS
		    QMAKE_APPLE_DEVICE_ARCHS=arm64;
		    -opensource;
		    -confirm-license;
		    -release;
		    -no-compile-examples;
		    -securetransport;
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
		    -submodules ${MODULES_STRING};
		    ${MODULES_TO_EXCLUDE};
		    -feature-ffmpeg;
		    -ffmpeg-dir ${TOP_BUILD_DIR}/ffmpeg/install/;
		    -DQT_BUILD_EXAMPLES_BY_DEFAULT=OFF;
		    -DQT_BUILD_TESTS_BY_DEFAULT=OFF;
		    -DQT_BUILD_TOOLS_BY_DEFAULT=OFF;
		)
	else()
		set(OPTIONS
		    -opensource;
		    -confirm-license;
		    -release;
		    -securetransport;
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
		    -submodules ${MODULES_STRING};
		    ${MODULES_TO_EXCLUDE};
		    -feature-ffmpeg;
		    -ffmpeg-dir ${TOP_BUILD_DIR}/ffmpeg/install/;
		    -DQT_BUILD_EXAMPLES_BY_DEFAULT=OFF;
		    -DQT_BUILD_TESTS_BY_DEFAULT=OFF;
		    -DQT_BUILD_TOOLS_BY_DEFAULT=OFF;
		)
	endif()

	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(GLOB FILES ${SOURCE_DIR}/LICENSES/*.txt)
	foreach(ARG $\{FILES\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/qt6/)
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
            -no-libproxy;
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
	    -submodules ${MODULES_STRING};
            ${MODULES_TO_EXCLUDE};
            -openssl-linked;
	    #-feature-pulseaudio;
	    -feature-ffmpeg;
	    -ffmpeg-dir ${TOP_BUILD_DIR}/ffmpeg/install/;
	    -DQT_BUILD_EXAMPLES_BY_DEFAULT=OFF;
	    -DQT_BUILD_TESTS_BY_DEFAULT=OFF;
	    -DQT_BUILD_TOOLS_BY_DEFAULT=OFF;
        )

	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(GLOB FILES ${SOURCE_DIR}/LICENSES/*.txt)
	foreach(ARG $\{FILES\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/qt6/)
	endforeach()
	file(COPY ${INSTALL_DIR}/include DESTINATION ${POST_INSTALL_DIR}/)
	file(GLOB LIBS ${INSTALL_DIR}/lib/*.so*)
	foreach(ARG $\{LIBS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	endforeach()
	file(COPY ${INSTALL_DIR}/plugins/ DESTINATION ${POST_INSTALL_DIR}/plugins/)
	file(COPY ${INSTALL_DIR}/libexec/moc DESTINATION ${POST_INSTALL_DIR}/bin/)
	file(COPY ${INSTALL_DIR}/libexec/rcc DESTINATION ${POST_INSTALL_DIR}/bin/)
    file(GLOB installedSOs ${POST_INSTALL_DIR}/lib/*.so*)
    foreach(SO $\{installedSOs\})
        message(\"-- Setting runtime path of $\{SO\}\")
        execute_process(COMMAND patchelf --set-rpath \"$ORIGIN/../lib\" $\{SO\})
    endforeach()
	")
    endif()
endif()

ExternalProject_Add(${NAME}
	DEPENDS ffmpeg
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
