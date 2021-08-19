# Build DCMTK

set(MODULES ofstd oflog dcmdata dcmimgle)
set(NAME dcmtk)
set(VERSION 3.6.3)

ExternalProject_Add(dcmtk
        PREFIX ${BUILD_DIR}/dcmtk
        BINARY_DIR ${BUILD_DIR}/dcmtk
        GIT_REPOSITORY "https://github.com/DCMTK/dcmtk.git"
	GIT_TAG "DCMTK-${VERSION}"
        CMAKE_ARGS
            -DCMAKE_MACOSX_RPATH=ON
            -DBUILD_SHARED_LIBS=ON
            -DBUILD_APPS=OFF
            -DDCMTK_ENABLE_BUILTIN_DICTIONARY=ON
            -DDCMTK_WITH_DOXYGEN=OFF
            -DDCMTK_WITH_ICU=OFF
            -DCMAKE_INSTALL_RPATH:STRING=$ORIGIN/../lib
        CMAKE_CACHE_ARGS
            -DDCMTK_MODULES:STRING=${MODULES}
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
            -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	    -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}/${NAME}/
)

# Collect files 
file(GENERATE OUTPUT ${INSTALL_DIR}/${NAME}/package.cmake CONTENT "
	file(COPY ${INSTALL_DIR}/${NAME}/include/dcmtk DESTINATION ${POST_INSTALL_DIR}/${NAME}/include/)
	file(COPY ${BUILD_DIR}/${NAME}/src/dcmtk/COPYRIGHT DESTINATION ${POST_INSTALL_DIR}/${NAME}/licences/dcmtk/)
	file(COPY ${INSTALL_DIR}/${NAME}/lib/libdcmdata.so DESTINATION ${POST_INSTALL_DIR}/${NAME}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/${NAME}/lib/libdcmimgle.so DESTINATION ${POST_INSTALL_DIR}/${NAME}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/${NAME}/lib/liboflog.so DESTINATION ${POST_INSTALL_DIR}/${NAME}/lib/ FOLLOW_SYMLINK_CHAIN)
	file(COPY ${INSTALL_DIR}/${NAME}/lib/libofstd.so DESTINATION ${POST_INSTALL_DIR}/${NAME}/lib/ FOLLOW_SYMLINK_CHAIN)
	"
)

create_package_target(dcmtk ${VERSION})
