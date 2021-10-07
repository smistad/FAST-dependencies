# Build HDF5

create_package_target(hdf5 1.10.6)
if(WIN32)
create_package_code("
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
file(COPY ${BUILD_DIR}/src/hdf5/COPYING DESTINATION ${POST_INSTALL_DIR}/licenses/hdf5/)
file(COPY ${INSTALL_DIR}/lib/hdf5.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
file(COPY ${INSTALL_DIR}/lib/hdf5_cpp.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
file(COPY ${INSTALL_DIR}/bin/hdf5.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
file(COPY ${INSTALL_DIR}/bin/hdf5_cpp.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
")
elseif(APPLE)
create_package_code("
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
file(COPY ${BUILD_DIR}/src/hdf5/COPYING DESTINATION ${POST_INSTALL_DIR}/licenses/hdf5/)
file(COPY ${INSTALL_DIR}/lib/libhdf5.dylib DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
file(COPY ${INSTALL_DIR}/lib/libhdf5_cpp.dylib DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")

else()
create_package_code("
file(COPY ${INSTALL_DIR}/include/ DESTINATION ${POST_INSTALL_DIR}/include/)
file(COPY ${BUILD_DIR}/src/hdf5/COPYING DESTINATION ${POST_INSTALL_DIR}/licenses/hdf5/)
file(COPY ${INSTALL_DIR}/lib/libhdf5.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
file(COPY ${INSTALL_DIR}/lib/libhdf5_cpp.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
")
endif()

ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://bitbucket.hdfgroup.org/scm/hdffv/hdf5.git"
        GIT_TAG "5b9cf732caab9daa6ed1e00f2df4f5a792340196" #"hdf5-1_10_6"
	GIT_PROGRESS 1
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
          -DHDF5_NO_PACKAGES:BOOL=ON
          -DONLY_SHARED_LIBS:BOOL=ON
          -DBUILD_TESTING:BOOL=OFF
          -DHDF5_BUILD_TOOLS:BOOL=OFF
          -DHDF5_BUILD_EXAMPLES:BOOL=OFF
          -DHDF5_BUILD_CPP_LIB:BOOL=ON
          -DHDF5_BUILD_HL_LIB:BOOL=OFF
        CMAKE_CACHE_ARGS
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
)
