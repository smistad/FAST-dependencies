cmake_minimum_required(VERSION 3.16)
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13" CACHE STRING "Minimum OS X deployment version")
set(ENV{OSX_DEPLOYMENT_TARGET} "10.13")
project(FAST-dependencies)

set(FAST_TensorFlow_JOBS "4" CACHE STRING "Nr of parallel jobs to use for bazel build of TensorFlow. Increasing this will use more RAM.")
option(FAST_TensorFlow_CPU_ONLY "Do not use CUDA for building TensorFlow" OFF)

include(ExternalProject)
include(Macros.cmake)

set(TOP_BUILD_DIR ${PROJECT_BINARY_DIR}/build_output/) # Where to build the dependencies
set(PACKAGE_DIR ${PROJECT_BINARY_DIR}/dist/) # Where to put packages
file(MAKE_DIRECTORY ${PACKAGE_DIR})

if(WIN32)
set(TOOLSET msvc${MSVC_TOOLSET_VERSION})
elseif(APPLE)
set(TOOLSET mac${CMAKE_OSX_DEPLOYMENT_TARGET})
else()
CHECK_GLIBC_VERSION()
set(TOOLSET glibc${GLIBC_VERSION})
endif()

# List all dependencies to build
include(ExternalOpenCL.cmake)
include(ExternalDCMTK.cmake)
include(ExternalHDF5.cmake)
include(ExternalZip.cmake)
include(ExternalOpenIGTLink.cmake)
include(ExternalRealSense.cmake)
include(ExternalOpenVINO.cmake)
include(ExternalZlib.cmake)
include(ExternalQt5.cmake)
include(ExternalJKQTPlotter.cmake)
include(ExternalTensorflow.cmake)
include(ExternalLibJPEG.cmake)
include(ExternalTIFF.cmake)
include(ExternalOpenSlide.cmake)

file(GENERATE OUTPUT ${PROJECT_BINARY_DIR}/hasher.cmake CONTENT "
	foreach(ARG ${ALL_PACKAGES})
		execute_process(COMMAND ${CMAKE_COMMAND} -E sha256sum $\{ARG\})
	endforeach()
")
add_custom_target(hash_all COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/hasher.cmake)
