# Build OpenIGTLink

create_package_target(OpenIGTLink 3.1)
if(WIN32)
create_package_code("
	file(COPY ${INSTALL_DIR}/include/igtl DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${BUILD_DIR}/src/${NAME}/LICENSE.txt DESTINATION ${POST_INSTALL_DIR}/licenses/OpenIGTLink/)
	file(COPY ${INSTALL_DIR}/lib/OpenIGTLink.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
	file(COPY ${INSTALL_DIR}/bin/OpenIGTLink.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
")
elseif(APPLE)
create_package_code("
	file(COPY ${INSTALL_DIR}/include/igtl DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${BUILD_DIR}/src/${NAME}/LICENSE.txt DESTINATION ${POST_INSTALL_DIR}/licenses/OpenIGTLink/)
	file(COPY ${INSTALL_DIR}/lib/libOpenIGTLink.dylib DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")

else()
create_package_code("
	file(COPY ${INSTALL_DIR}/include/igtl DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${BUILD_DIR}/src/${NAME}/LICENSE.txt DESTINATION ${POST_INSTALL_DIR}/licenses/OpenIGTLink/)
	file(COPY ${INSTALL_DIR}/lib/libOpenIGTLink.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")
endif()

ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/openigtlink/OpenIGTLink.git"
	GIT_PROGRESS 1
	GIT_TAG "3a2297d173d20596f53d5b5c84600ed4fa51c07c"
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS=ON
            -DBUILD_TESTING=OFF
            -DBUILD_EXAMPLES=OFF
	    -DLIBRARY_OUTPUT_PATH=${INSTALL_DIR}/lib/
            -DCMAKE_MACOSX_RPATH=ON
	    -DOpenIGTLink_INSTALL_LIB_DIR=${INSTALL_DIR}/lib/
	    -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
            -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	    -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
)
