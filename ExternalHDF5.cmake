# Build HDF5 (static)

create_package_target(hdf5 1.10.11)
if(WIN32)
create_package_code("
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
file(COPY ${BUILD_DIR}/src/hdf5/COPYING DESTINATION ${POST_INSTALL_DIR}/licenses/hdf5/)
file(COPY ${INSTALL_DIR}/lib/libhdf5.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
file(COPY ${INSTALL_DIR}/lib/libhdf5_cpp.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
")
elseif(APPLE)
create_package_code("
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
file(COPY ${BUILD_DIR}/src/hdf5/COPYING DESTINATION ${POST_INSTALL_DIR}/licenses/hdf5/)
file(COPY ${INSTALL_DIR}/lib/libhdf5.a DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
file(COPY ${INSTALL_DIR}/lib/libhdf5_cpp.a DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")

else()
create_package_code("
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
file(COPY ${BUILD_DIR}/src/hdf5/COPYING DESTINATION ${POST_INSTALL_DIR}/licenses/hdf5/)
file(COPY ${INSTALL_DIR}/lib/libhdf5.a DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
file(COPY ${INSTALL_DIR}/lib/libhdf5_cpp.a DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")
endif()

ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
	GIT_REPOSITORY "https://github.com/HDFGroup/hdf5"
        GIT_TAG "55565382d2a6ae444ec5bc039f83b6b3bfb6730c" #"hdf5-1_10_11"
	GIT_PROGRESS 1
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
          -DHDF5_NO_PACKAGES:BOOL=ON
	  -DBUILD_SHARED_LIBS:BOOL=OFF
          -DBUILD_TESTING:BOOL=OFF
          -DHDF5_BUILD_TOOLS:BOOL=OFF
          -DHDF5_BUILD_EXAMPLES:BOOL=OFF
          -DHDF5_BUILD_CPP_LIB:BOOL=ON
          -DHDF5_BUILD_HL_LIB:BOOL=OFF
	  -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
	  #-DCMAKE_C_FLAGS="-Wno-error=implicit-function-declaration"
        CMAKE_CACHE_ARGS
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
)
