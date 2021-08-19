# Build zip library

create_package_target(zip 0.2.0)
if(WIN32)
create_package_code("
	file(COPY ${INSTALL_DIR}/include/zip DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${BUILD_DIR}/src/zip/UNLICENSE DESTINATION ${POST_INSTALL_DIR}/licences/zip/)
	file(COPY ${INSTALL_DIR}/lib/zip.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
")
else()
create_package_code("
	file(COPY ${INSTALL_DIR}/include/zip DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${BUILD_DIR}/src/zip/UNLICENSE DESTINATION ${POST_INSTALL_DIR}/licences/zip/)
	file(COPY ${INSTALL_DIR}/lib/libzip.a DESTINATION ${POST_INSTALL_DIR}/lib/)
")
endif()

ExternalProject_Add(zip
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/kuba--/zip.git"
	GIT_PROGRESS 1
	GIT_TAG "v${VERSION}"
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS=OFF
            -DCMAKE_DISABLE_TESTING=ON
        CMAKE_CACHE_ARGS
            -DDCMTK_MODULES:STRING=${MODULES}
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
            -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	    -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
)
