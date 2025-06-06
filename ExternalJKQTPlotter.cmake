# Build JKQTPlotter

create_package_target(jkqtplotter 4.0.3)
if(WIN32)
create_package_code(
	"
	file(COPY ${INSTALL_DIR}/include/jkqtplotter DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtmathtext DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtfastplotter DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${INSTALL_DIR}/include/jkqtcommon DESTINATION ${POST_INSTALL_DIR}/include/)
	file(COPY ${SOURCE_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
	file(COPY ${INSTALL_DIR}/lib/JKQTCommonSharedLib_Release.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
	file(COPY ${INSTALL_DIR}/lib/JKQTPlotterSharedLib_Release.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
	file(COPY ${INSTALL_DIR}/lib/JKQTFastPlotterSharedLib_Release.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
	file(COPY ${INSTALL_DIR}/lib/JKQTMathTextSharedLib_Release.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
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
	file(COPY ${SOURCE_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
	file(COPY ${INSTALL_DIR}/lib/libJKQTCommonSharedLib_Release${CMAKE_SHARED_LIBRARY_SUFFIX} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/lib/libJKQTPlotterSharedLib_Release${CMAKE_SHARED_LIBRARY_SUFFIX} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/lib/libJKQTFastPlotterSharedLib_Release${CMAKE_SHARED_LIBRARY_SUFFIX} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/lib/libJKQTMathTextSharedLib_Release${CMAKE_SHARED_LIBRARY_SUFFIX} DESTINATION ${POST_INSTALL_DIR}/lib/ FOLLOW_SYMLINK_CHAIN)
	"
)
endif()

ExternalProject_Add(${NAME}
        DEPENDS qt6
	PREFIX ${BUILD_DIR}
	BINARY_DIR ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/jkriege2/JKQtPlotter.git"
        GIT_TAG "v4.0.3"
	GIT_PROGRESS 1
        UPDATE_COMMAND "" # Hack to avoid rebuild all the time on linux
        CMAKE_ARGS
          -DCMAKE_MACOSX_RPATH=ON
	  -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
          -DJKQtPlotter_BUILD_EXAMPLES:BOOL=OFF
          -DJKQtPlotter_BUILD_STATIC_LIBS=OFF
          -DJKQtPlotter_BUILD_SHARED_LIBS=ON
        CMAKE_CACHE_ARGS
          -DQt6_DIR:STRING=${TOP_BUILD_DIR}/qt6/install/lib/cmake/Qt6/
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
          -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	  -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
  )
