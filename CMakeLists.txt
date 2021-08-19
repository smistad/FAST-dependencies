cmake_minimum_required(VERSION 3.16)
project(FAST-dependencies)

include(ExternalProject)
include(Macros.cmake)

set(TOP_BUILD_DIR ${PROJECT_BINARY_DIR}/build_output/) # Where to build the dependencies
set(PACKAGE_DIR ${PROJECT_BINARY_DIR}/dist/) # Where to put packages
file(MAKE_DIRECTORY ${PACKAGE_DIR})

if(WIN32)
set(TOOLSET msvc${MSVC_TOOLSET_VERSION})
else(WIN32)
CHECK_GLIBC_VERSION()
set(TOOLSET glibc${GLIBC_VERSION})
endif()

# List all dependencies to build
include(ExternalDCMTK.cmake)
include(ExternalHDF5.cmake)

file(GENERATE OUTPUT ${PROJECT_BINARY_DIR}/hasher.cmake CONTENT "
	foreach(ARG ${ALL_PACKAGES})
		execute_process(COMMAND ${CMAKE_COMMAND} -E sha256sum $\{ARG\})
	endforeach()
")
add_custom_target(hash_all COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/hasher.cmake)
