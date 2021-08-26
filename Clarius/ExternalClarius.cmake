# Download clarius cast API
include(GenerateExportHeader)

create_package_target(clarius 8.0.1)
if(WIN32)
    create_package_code(
        "
        file(COPY ${INSTALL_DIR}/include/cast DESTINATION ${POST_INSTALL_DIR}/include/)
        file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/Clarius/ClariusCast.hpp DESTINATION ${POST_INSTALL_DIR}/include/cast/)
        file(COPY ${INSTALL_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licences/clarius/)
        "
    )

else()
    create_package_code(
        "
        file(COPY ${INSTALL_DIR}/include/cast DESTINATION ${POST_INSTALL_DIR}/include/)
        file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/Clarius/ClariusCast.hpp DESTINATION ${POST_INSTALL_DIR}/include/cast/)
        file(COPY ${INSTALL_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licences/clarius/)
        "
    )
endif()

ExternalProject_Add(clarius_headers
    PREFIX ${BUILD_DIR}
    URL https://github.com/clariusdev/cast/archive/refs/tags/8.0.1.zip #v8.0.1 with export header fix
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory ${TOP_BUILD_DIR}/clarius/src/clarius_headers/src/include ${INSTALL_DIR}/include/ &&
                ${CMAKE_COMMAND} -E copy ${TOP_BUILD_DIR}/clarius/src/clarius_headers/LICENSE ${INSTALL_DIR}/
)

if(WIN32)
    set(URL "https://github.com/clariusdev/cast/releases/download/8.0.1/clarius-cast-v801-windows.zip")
else()
    set(URL "https://github.com/clariusdev/cast/releases/download/8.0.1/clarius-cast-v801-linux.zip")
endif()

if(WIN32)
ExternalProject_Add(clarius
        PREFIX ${BUILD_DIR} # The folder in which the package will downloaded to
        URL ${URL}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy ${SOURCE_DIR}/cast.lib ${POST_INSTALL_DIR}/lib/ COMMAND
        ${CMAKE_COMMAND} -E copy ${SOURCE_DIR}/cast.dll ${POST_INSTALL_DIR}/bin/
        DEPENDS clarius_headers

)
else()
ExternalProject_Add(clarius
        PREFIX ${BUILD_DIR} # The folder in which the package will downloaded to
        URL ${URL}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy ${SOURCE_DIR}/libcast.so ${POST_INSTALL_DIR}/lib/
        DEPENDS clarius_headers
)
endif()

set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
if(APPLE)
    set(CMAKE_MACOSX_RPATH ON)
    set(CMAKE_INSTALL_RPATH "@loader_path/../lib")
else()
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
endif()
add_library(clariusCastWrapper SHARED Clarius/ClariusCastImpl.hpp Clarius/ClariusCastImpl.cpp)
set_target_properties(clariusCastWrapper PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${POST_INSTALL_DIR}/lib)
set_target_properties(clariusCastWrapper PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${POST_INSTALL_DIR}/bin)
target_link_directories(clariusCastWrapper PRIVATE ${POST_INSTALL_DIR}/lib/)
generate_export_header(clariusCastWrapper EXPORT_FILE_NAME ${INSTALL_DIR}/include/cast/ClariusCastExport.hpp)
target_include_directories(clariusCastWrapper PRIVATE ${INSTALL_DIR}/include/)
target_link_libraries(clariusCastWrapper cast)
add_dependencies(clariusCastWrapper clarius)
add_dependencies(clarius_package clariusCastWrapper)

