# Build OpenCL

create_package_target(opencl 3.0.8)
if(WIN32)
create_package_code("
file(COPY ${BUILD_DIR}/src/${NAME}_headers/CL/ DESTINATION ${POST_INSTALL_DIR}/include/)
file(COPY ${BUILD_DIR}/src/${NAME}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
file(COPY ${INSTALL_DIR}/lib/OpenCL.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
file(COPY ${INSTALL_DIR}/bin/OpenCL.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
")
else()
create_package_code("
file(COPY ${BUILD_DIR}/src/${NAME}_headers/CL/ DESTINATION ${POST_INSTALL_DIR}/include/)
file(COPY ${BUILD_DIR}/src/${NAME}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
file(COPY ${INSTALL_DIR}/lib/libOpenCL.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")
endif()

ExternalProject_Add(${NAME}_headers
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
	GIT_REPOSITORY "https://github.com/KhronosGroup/OpenCL-Headers.git"
	GIT_TAG "v2021.06.30"
	GIT_PROGRESS 1
	UPDATE_COMMAND ""
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ""
)


ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git"
        GIT_TAG "v2021.06.30"
	GIT_PROGRESS 1
	DEPENDS ${NAME}_headers
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
	  -DOPENCL_ICD_LOADER_HEADERS_DIR=${BUILD_DIR}/src/${NAME}_headers/
        CMAKE_CACHE_ARGS
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
)
