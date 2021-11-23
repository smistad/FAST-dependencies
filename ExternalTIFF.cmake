# Download and set up TIFF library

create_package_target(tiff 4.3.0)
if(WIN32)
ExternalProject_Add(tiff
        PREFIX ${BUILD_DIR}
        BINARY_DIR ${BUILD_DIR}
        DEPENDS libjpeg zlib
        GIT_REPOSITORY "https://gitlab.com/libtiff/libtiff/"
        GIT_TAG "v4.3.0"
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
          -Djpeg=ON
          -Dold-jpeg=ON
          -Dzlib=ON
	  -Djbig=OFF # JBIG is GPL
	  -DJPEG_INCLUDE_DIR=${TOP_BUILD_DIR}/libjpeg/src/libjpeg/LibJPEG/9d/include/
	  -DJPEG_LIBRARY_RELEASE=${TOP_BUILD_DIR}/libjpeg/src/libjpeg/LibJPEG/9d/lib/libjpeg.lib
	  -DZLIB_INCLUDE_DIR=${TOP_BUILD_DIR}/zlib/install/include/
	  -DZLIB_LIBRARY_RELEASE=${TOP_BUILD_DIR}/zlib/Release/zlib.lib
        CMAKE_CACHE_ARGS
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
        )
else()
create_package_code("
	file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/lib/libtiff.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${SOURCE_DIR}/COPYRIGHT DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
")
ExternalProject_Add(tiff
        PREFIX ${BUILD_DIR}
        BINARY_DIR ${BUILD_DIR}
        DEPENDS zlib
        GIT_REPOSITORY "https://gitlab.com/libtiff/libtiff/"
        GIT_TAG "v4.3.0"
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
          -Djpeg=ON
          -Dold-jpeg=ON
	  -Djbig=OFF # JBIG is GPL
          -Dzlib=ON
	  -DZLIB_INCLUDE_DIR=${TOP_BUILD_DIR}/zlib/install/include/
	  -DZLIB_LIBRARY_RELEASE=${TOP_BUILD_DIR}/zlib/install/lib/libz.so
        CMAKE_CACHE_ARGS
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
        )
endif()
