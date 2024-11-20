# Build JPEG XL library

create_package_target(jpegxl 0.11.0)
if(WIN32)
file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(COPY ${INSTALL_DIR}/include/jxl DESTINATION ${POST_INSTALL_DIR}/include/)
	file(GLOB FILES ${BUILD_DIR}/LICENSE.*)
	foreach(ARG $\{FILES\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/jpegxl/)
	endforeach()

	file(GLOB LIBS ${INSTALL_DIR}/lib/*.lib)
	foreach(ARG $\{LIBS\})
	    if(NOT $\{ARG\} MATCHES \"hwy.lib$\") # Static lib, no need
	         file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/)
	    endif()
	endforeach()
	file(GLOB DLLS ${INSTALL_DIR}/bin/*.dll)
	foreach(ARG $\{DLLS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/bin/)
	endforeach()
	")
elseif(APPLE)
else()
file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(COPY ${INSTALL_DIR}/include/jxl DESTINATION ${POST_INSTALL_DIR}/include/)
	file(GLOB FILES ${BUILD_DIR}/LICENSE.*)
	foreach(ARG $\{FILES\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/jpegxl/)
	endforeach()

	file(GLOB LIBS ${INSTALL_DIR}/lib/*.so)
	foreach(ARG $\{LIBS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	endforeach()
	file(GLOB installedSOs ${POST_INSTALL_DIR}/lib/*.so*)
	foreach(SO $\{installedSOs\})
		message(\"-- Setting runtime path of $\{SO\}\")
		execute_process(COMMAND patchelf --set-rpath \"$ORIGIN/../lib\" $\{SO\})
	endforeach()
	")
endif()

ExternalProject_Add(jpegxl
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
	GIT_REPOSITORY "https://github.com/libjxl/libjxl"
	GIT_PROGRESS 1
	GIT_TAG "v${VERSION}"
	CMAKE_ARGS
		-DJPEGXL_ENABLE_BENCHMARK=OFF
		-DJPEGXL_ENABLE_DOXYGEN=OFF
		-DJPEGXL_ENABLE_EXAMPLES=OFF
		-DJPEGXL_ENABLE_JNI=OFF
		-DJPEGXL_ENABLE_TOOLS=OFF
		-DJPEGXL_ENABLE_OPENEXR=OFF
		-DJPEGXL_ENABLE_WASM_THREADS=OFF
		-DJPEGXL_ENABLE_JPEGLI=OFF
		-DJPEGXL_ENABLE_JPEGLI_LIBJPEG=OFF
		-DJPEGXL_ENABLE_MANPAGES=OFF
		-DJPEGXL_ENABLE_SJPEG=OFF
		-DBUILD_TESTING=OFF
		-DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
	CMAKE_CACHE_ARGS
		-DCMAKE_BUILD_TYPE:STRING=Release
		-DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
		-DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
		-DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
)
