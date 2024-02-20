# Download and set up TIFF library

create_package_target(openslide 3.4.1)
if(WIN32)
elseif(APPLE)
create_package_code("
	file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
	file(GLOB SOs ${INSTALL_DIR}/lib/*.dylib*)
	file(COPY $\\{SOs\\} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
        file(COPY ${SOURCE_DIR}/LICENSE.txt DESTINATION ${POST_INSTALL_DIR}/licenses/openslide/)
	#file(COPY ${INSTALL_DIR}/licenses/ DESTINATION ${POST_INSTALL_DIR}/licenses/)
")
ExternalProject_Add(openslide
        PREFIX ${BUILD_DIR}
        BINARY_DIR ${BUILD_DIR}
        DEPENDS tiff
        GIT_REPOSITORY "https://github.com/smistad/openslide"
        GIT_TAG "5157bf030255eb17d5c1df63e774b2a75a495a52"
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
	  -DTIFF_INCLUDE_DIR=${TOP_BUILD_DIR}/tiff/install/include/
	  -DTIFF_LIBRARY_RELEASE=${TOP_BUILD_DIR}/tiff/install/lib/libtiff.dylib
	  -DZLIB_INCLUDE_DIR=${TOP_BUILD_DIR}/zlib/install/include/
	  -DZLIB_LIBRARY_RELEASE=${TOP_BUILD_DIR}/zlib/install/lib/libz.dylib
        CMAKE_CACHE_ARGS
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
        )

else()
create_package_code("
	file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
	file(GLOB SOs ${INSTALL_DIR}/lib/*.so*)
	file(COPY $\\{SOs\\} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
        file(COPY ${SOURCE_DIR}/LICENSE.txt DESTINATION ${POST_INSTALL_DIR}/licenses/openslide/)
	file(COPY ${INSTALL_DIR}/licenses/ DESTINATION ${POST_INSTALL_DIR}/licenses/)
")
ExternalProject_Add(openslide
        PREFIX ${BUILD_DIR}
        BINARY_DIR ${BUILD_DIR}
        DEPENDS tiff
        GIT_REPOSITORY "https://github.com/smistad/openslide"
        GIT_TAG "5157bf030255eb17d5c1df63e774b2a75a495a52"
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
	  -DTIFF_INCLUDE_DIR=${TOP_BUILD_DIR}/tiff/install/include/
	  -DTIFF_LIBRARY_RELEASE=${TOP_BUILD_DIR}/tiff/install/lib/libtiff.so
	  -DZLIB_INCLUDE_DIR=${TOP_BUILD_DIR}/zlib/install/include/
	  -DZLIB_LIBRARY_RELEASE=${TOP_BUILD_DIR}/zlib/install/lib/libz.so
        CMAKE_CACHE_ARGS
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
        )
endif()
