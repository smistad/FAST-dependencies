# Build FFmeg library for Qt 6
# See https://doc.qt.io/qt-6.9/qtmultimedia-building-ffmpeg-linux.html

create_package_target(ffmpeg 7.1.1)

set(CONFIGURE_OPTIONS --disable-autodetect --disable-doc --enable-network --enable-shared)
list(JOIN CONFIGURE_OPTIONS " " CONFIGURE_OPTIONS_STR)

if(WIN32)
	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(COPY ${BUILD_DIR}/src/ffmpeg/LICENSE.md DESTINATION ${POST_INSTALL_DIR}/licenses/ffmpeg/)
	file(GLOB FILES ${BUILD_DIR}/src/ffmpeg/COPYING.*)
	foreach(ARG $\{FILES\})
		file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/ffmpeg/)
	endforeach()

	file(GLOB LIBS ${INSTALL_DIR}/lib/*.dll)
	foreach(ARG $\{LIBS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/bin/)
	endforeach()
	# Copy entire source and create a separate package for the source
	file(COPY ${BUILD_DIR}/src/ffmpeg DESTINATION ${POST_INSTALL_DIR}/src PATTERN \".git*\" EXCLUDE)
	file(WRITE ${POST_INSTALL_DIR}/src/BUILD_NOTES.txt \"FFmpeg ${VERSION} used with Qt6 in FAST was compiled in the following way:\ncd src/ffmpeg/\n./configure ${CONFIGURE_OPTIONS_STR}\nmake -j4\nmake -j4 install\")
	execute_process(COMMAND ${CMAKE_COMMAND} -E tar cfJ ${PACKAGE_DIR}/ffmpeg_source_${VERSION}.tar.xz ${POST_INSTALL_DIR}/src/)
")
elseif(APPLE)
	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(COPY ${BUILD_DIR}/src/ffmpeg/LICENSE.md DESTINATION ${POST_INSTALL_DIR}/licenses/ffmpeg/)
	file(GLOB FILES ${BUILD_DIR}/src/ffmpeg/COPYING.*)
	foreach(ARG $\{FILES\})
		file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/ffmpeg/)
	endforeach()

	file(GLOB LIBS ${INSTALL_DIR}/lib/*.dylib)
	foreach(ARG $\{LIBS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	endforeach()
	# Copy entire source and create a separate package for the source
	file(COPY ${BUILD_DIR}/src/ffmpeg DESTINATION ${POST_INSTALL_DIR}/src PATTERN \".git*\" EXCLUDE)
	file(WRITE ${POST_INSTALL_DIR}/src/BUILD_NOTES.txt \"FFmpeg ${VERSION} used with Qt6 in FAST was compiled in the following way:\ncd src/ffmpeg/\n./configure ${CONFIGURE_OPTIONS_STR}\nmake -j4\nmake -j4 install\")
	execute_process(COMMAND ${CMAKE_COMMAND} -E tar cfJ ${PACKAGE_DIR}/ffmpeg_source_${VERSION}.tar.xz ${POST_INSTALL_DIR}/src/)
")
else()
	file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
	file(COPY ${BUILD_DIR}/src/ffmpeg/LICENSE.md DESTINATION ${POST_INSTALL_DIR}/licenses/ffmpeg/)
	file(GLOB FILES ${BUILD_DIR}/src/ffmpeg/COPYING.*)
	foreach(ARG $\{FILES\})
		file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/licenses/ffmpeg/)
	endforeach()

	file(GLOB LIBS ${INSTALL_DIR}/lib/*.so*)
	foreach(ARG $\{LIBS\})
	    file(COPY $\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	endforeach()
	file(GLOB installedSOs ${POST_INSTALL_DIR}/lib/*.so*)
	foreach(SO $\{installedSOs\})
		message(\"-- Setting runtime path of $\{SO\}\")
		execute_process(COMMAND patchelf --set-rpath \"$ORIGIN/../lib\" $\{SO\})
	endforeach()
	# Copy entire source and create a separate package for the source
	file(COPY ${BUILD_DIR}/src/ffmpeg DESTINATION ${POST_INSTALL_DIR}/src PATTERN \".git*\" EXCLUDE)
	file(WRITE ${POST_INSTALL_DIR}/src/BUILD_NOTES.txt \"FFmpeg ${VERSION} used with Qt6 in FAST was compiled in the following way:\ncd src/ffmpeg/\n./configure ${CONFIGURE_OPTIONS_STR}\nmake -j4\nmake -j4 install\")
	execute_process(COMMAND ${CMAKE_COMMAND} -E tar cfJ ${PACKAGE_DIR}/ffmpeg_source_${VERSION}.tar.xz ${POST_INSTALL_DIR}/src/)
")
endif()

ExternalProject_Add(ffmpeg
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
	GIT_REPOSITORY "https://git.ffmpeg.org/ffmpeg.git"
	GIT_PROGRESS 1
	GIT_TAG "n${VERSION}"
	CONFIGURE_COMMAND
		echo "Configuring FFmpeg with the following options: ${CONFIGURE_OPTIONS}" COMMAND
		${BUILD_DIR}/src/ffmpeg/configure ${CONFIGURE_OPTIONS} --prefix=${INSTALL_DIR}
	BUILD_COMMAND
		make -j4
	INSTALL_COMMAND
		make -j4 install
)
