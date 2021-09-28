# Build zlib

create_package_target(zlib 1.2.9)
if(WIN32)
create_package_code("
file(COPY ${SOURCE_DIR}/README DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/zlib/)
file(COPY ${INSTALL_DIR}/bin/zlib.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
file(COPY ${INSTALL_DIR}/lib/zlib.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
")
elseif(APPLE)
create_package_code("
file(COPY ${SOURCE_DIR}/README DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/zlib/)
file(COPY ${INSTALL_DIR}/lib/libz.dylib DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")
else()
create_package_code("
file(COPY ${SOURCE_DIR}/README DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/zlib/)
file(COPY ${INSTALL_DIR}/lib/libz.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")
endif()

ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/madler/zlib.git"
	GIT_TAG "v${VERSION}"
        CMAKE_ARGS
            -DCMAKE_MACOSX_RPATH=ON
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
            -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	    -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
)
