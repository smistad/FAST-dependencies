# Download and set up LibJPEG library


if(WIN32)
create_package_target(libjpeg 9)
ExternalProject_Add(libjpeg
        PREFIX ${TOP_BUILD_DIR}/libjpeg
        URL "https://github.com/smistad/FAST-dependencies/releases/download/v4.0.0/LibJPEG-9d-Win-pc064.zip"
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
)
endif()
