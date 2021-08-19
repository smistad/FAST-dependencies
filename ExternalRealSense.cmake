# Build RealSense

create_package_target(realsense 2.40.0)


if(WIN32)
create_package_code(
	"
	file(COPY ${INSTALL_DIR}/include/librealsense2 DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${BUILD_DIR}/src/${NAME}/LICENSE ${BUILD_DIR}/src/${NAME}/NOTICE 
		DESTINATION ${POST_INSTALL_DIR}/licences/${NAME}/)
	file(COPY ${INSTALL_DIR}/lib/realsense2.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
	file(COPY ${INSTALL_DIR}/bin/realsense2.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
	"
)
ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/IntelRealSense/librealsense.git"
	GIT_TAG "v${VERSION}"
	GIT_PROGRESS 1
        CMAKE_ARGS
        -DBUILD_EXAMPLES:BOOL=OFF
        -DBUILD_GRAPHICAL_EXAMPLES:BOOL=OFF
        -DBUILD_EASYLOGGINGPP:BOOL=OFF
        -DBUILD_WITH_TM2:BOOL=OFF
        -DBUILD_WITH_OPENMP:BOOL=ON
        CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
        -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	-DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
)
else()
create_package_code(
	"
	file(COPY ${INSTALL_DIR}/include/librealsense2 DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${BUILD_DIR}/src/${NAME}/LICENSE ${BUILD_DIR}/src/${NAME}/NOTICE 
		DESTINATION ${POST_INSTALL_DIR}/licences/${NAME}/)
	file(COPY ${INSTALL_DIR}/lib/librealsense2.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	"
)
ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/IntelRealSense/librealsense.git"
	GIT_TAG "v${VERSION}"
	GIT_PROGRESS 1
	INSTALL_COMMAND make install/strip
        CMAKE_ARGS
        -DBUILD_EXAMPLES:BOOL=OFF
        -DBUILD_GRAPHICAL_EXAMPLES:BOOL=OFF
        -DBUILD_EASYLOGGINGPP:BOOL=OFF
        -DBUILD_WITH_TM2:BOOL=OFF
        -DBUILD_WITH_OPENMP:BOOL=ON
        CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
        -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	-DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
        )
endif()
list(APPEND LIBRARIES ${CMAKE_SHARED_LIBRARY_PREFIX}realsense2${CMAKE_SHARED_LIBRARY_SUFFIX})
