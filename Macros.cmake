# - Check glibc version
# CHECK_GLIBC_VERSION()
# 
# Once done this will define
#
#   GLIBC_VERSION - glibc version
#
MACRO (CHECK_GLIBC_VERSION)
    EXECUTE_PROCESS (
        COMMAND ${CMAKE_C_COMPILER} -print-file-name=libc.so.6
	OUTPUT_VARIABLE GLIBC
	OUTPUT_STRIP_TRAILING_WHITESPACE)

    GET_FILENAME_COMPONENT (GLIBC ${GLIBC} REALPATH)
    GET_FILENAME_COMPONENT (GLIBC_VERSION ${GLIBC} NAME)
    STRING (REPLACE "libc-" "" GLIBC_VERSION ${GLIBC_VERSION})
    STRING (REPLACE ".so" "" GLIBC_VERSION ${GLIBC_VERSION})
    IF (NOT GLIBC_VERSION MATCHES "^[0-9.]+$")
        MESSAGE (FATAL_ERROR "Unknown glibc version: ${GLIBC_VERSION}")
    ENDIF (NOT GLIBC_VERSION MATCHES "^[0-9.]+$")
ENDMACRO (CHECK_GLIBC_VERSION)

macro(create_package_target NAME VERSION)
	set(NAME ${NAME})
	set(VERSION ${VERSION})
	set(BUILD_DIR ${TOP_BUILD_DIR}/${NAME}/)
	set(INSTALL_DIR ${BUILD_DIR}/install/)
	set(POST_INSTALL_DIR ${BUILD_DIR}/post_install/${NAME}/)
	add_custom_target(${NAME}_package ALL 
		COMMAND ${CMAKE_COMMAND} -P ${INSTALL_DIR}/package.cmake 
		COMMAND ${CMAKE_COMMAND} -E tar "cfJ" "${PACKAGE_DIR}/${NAME}_${VERSION}_${TOOLSET}.tar.xz" "${POST_INSTALL_DIR}"
		COMMENT "Packaging ${NAME}"
		DEPENDS ${NAME}
	)
	list(APPEND ALL_TARGETS ${NAME}_package)
	list(APPEND ALL_PACKAGES ${PACKAGE_DIR}/${NAME}_${VERSION}_${TOOLSET}.tar.xz)
	#set(ALL_TARGETS ${ALL_TARGETS} PARENT_SCOPE)
	#set(ALL_PACKAGES ${ALL_PACKAGES} PARENT_SCOPE)
endmacro()

macro(create_package_code CODE)
	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT ${CODE})
endmacro()
