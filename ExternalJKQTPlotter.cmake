# Build JKQTPlotter

create_package_target(jkqtplotter 2020.10)
if(WIN32)
create_package_code(
	"
	file(COPY ${INSTALL_DIR}/include/jkqtplotter DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtmathtext DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtfastplotter DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtcommon DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${SOURCE_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licences/${NAME}/)
	file(COPY ${INSTALL_DIR}/lib/JKQTCommonSharedLib_Release.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
	file(COPY ${INSTALL_DIR}/lib/JKQTPlotterSharedLib_Release.so DESTINATION ${POST_INSTALL_DIR}/lib/)
	file(COPY ${INSTALL_DIR}/lib/JKQTFastPlotterSharedLib_Release.so DESTINATION ${POST_INSTALL_DIR}/lib/)
	file(COPY ${INSTALL_DIR}/bin/JKQTCommonSharedLib_Release.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
	file(COPY ${INSTALL_DIR}/bin/JKQTPlotterSharedLib_Release.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
	file(COPY ${INSTALL_DIR}/bin/JKQTFastPlotterSharedLib_Release.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
	file(COPY ${INSTALL_DIR}/bin/JKQTMathTextSharedLib_Release.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
	"
)
else()
create_package_code(
	"
	file(COPY ${INSTALL_DIR}/include/jkqtplotter DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtmathtext DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtfastplotter DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtcommon DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${SOURCE_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licences/${NAME}/)
	file(COPY ${INSTALL_DIR}/lib/libJKQTCommonSharedLib_Release.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/lib/libJKQTPlotterSharedLib_Release.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/lib/libJKQTFastPlotterSharedLib_Release.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/lib/libJKQTMathTextSharedLib_Release.so DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	"
)
endif()

ExternalProject_Add(${NAME}
        DEPENDS qt5
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/jkriege2/JKQtPlotter.git"
        GIT_TAG "fc7622e901cec7ed68abe6b2d95ea20ce30490ed"
	GIT_PROGRESS 1
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
          -DJKQtPlotter_BUILD_EXAMPLES:BOOL=OFF
          -DJKQtPlotter_BUILD_STATIC_LIBS=OFF
          -DJKQtPlotter_BUILD_SHARED_LIBS=ON
        CMAKE_CACHE_ARGS
          -DQt5_DIR:STRING=${TOP_BUILD_DIR}/qt5/install/lib/cmake/Qt5/
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
  )
