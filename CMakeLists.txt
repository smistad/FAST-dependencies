cmake_minimum_required(VERSION 3.16)
project(FAST-dependencies)

include(ExternalProject)
include(Macros.cmake)

set(BUILD_DIR ${PROJECT_BINARY_DIR}/build/) # Where to build the dependencies
set(INSTALL_DIR ${PROJECT_BINARY_DIR}/install/) # Where to install the dependencies
set(POST_INSTALL_DIR ${PROJECT_BINARY_DIR}/post_install/) # Where to create structure files before packaging
set(PACKAGE_DIR ${PROJECT_BINARY_DIR}/dist/) # Where to put package
file(MAKE_DIRECTORY ${PACKAGE_DIR})

if(WIN32)
set(TOOLSET msvc${MSVC_TOOLSET_VERSION})
else(WIN32)
CHECK_GLIBC_VERSION()
set(TOOLSET glibc${GLIBC_VERSION})
endif()

# List all dependencies to build
set(ALL_PACKAGES "")
set(ALL_TARGETS "")
include(ExternalDCMTK.cmake)

#file(GENERATE OUTPUT ${PROJECT_BINARY_DIR}/hasher.cmake CONTENT "
#execute_process(COMMAND ${CMAKE_COMMAND} -E echo \"weee${LIST}\")
#	foreach(ARG ${LIST})
#		execute_process(COMMAND ${CMAKE_COMMAND} -E echo \"weee${ARG}\")
#		execute_process(COMMAND ${CMAKE_COMMAND} -E sha256sum ${ARG})
#	endforeach()
#")
#add_custom_target(hash_all COMMAND ${CMAKE_COMMAND} -DLIST=${ALL_PACKAGES} -P ${PROJECT_BINARY_DIR}/hasher.cmake DEPENDS ${ALL_TARGETS})
