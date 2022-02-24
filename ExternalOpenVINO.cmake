# Build OpenVINO

create_package_target(openvino 2021.4.2)

if(WIN32)
set(DLLs
	inference_engine
	inference_engine_legacy
	inference_engine_transformations
	inference_engine_lp_transformations
	inference_engine_ir_reader
	inference_engine_ir_v7_reader
	inference_engine_onnx_reader
	onnx_importer
	clDNNPlugin
	MKLDNNPlugin
	myriadPlugin
	ngraph
)
set(LIBs
	inference_engine
	inference_engine_legacy
	inference_engine_transformations
	inference_engine_lp_transformations
	inference_engine_ir_reader
	inference_engine_ir_v7_reader
	inference_engine_onnx_reader
	onnx_importer
	ngraph
)
file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
file(COPY ${SOURCE_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
file(COPY ${SOURCE_DIR}/inference-engine/thirdparty/ade/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/ade/)
file(COPY ${SOURCE_DIR}/inference-engine/thirdparty/mkl-dnn/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/mkl-dnn/)
file(COPY ${SOURCE_DIR}/inference-engine/temp/tbb/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/tbb/)
file(COPY ${SOURCE_DIR}/inference-engine/include/ DESTINATION ${POST_INSTALL_DIR}/include/openvino/)
file(COPY ${SOURCE_DIR}/ngraph/core/include/ngraph/ DESTINATION ${POST_INSTALL_DIR}/include/ngraph/)
foreach(ARG ${DLLs})
	file(COPY ${SOURCE_DIR}/bin/intel64/Release/$\{ARG\}.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
endforeach()
foreach(ARG ${LIBs})
	file(COPY ${SOURCE_DIR}/bin/intel64/Release/$\{ARG\}.lib DESTINATION ${POST_INSTALL_DIR}/lib/)
endforeach()
file(COPY ${SOURCE_DIR}/inference-engine/temp/tbb/bin/tbb.dll DESTINATION ${POST_INSTALL_DIR}/bin/)
file(COPY ${SOURCE_DIR}/bin/intel64/Release/plugins.xml DESTINATION ${POST_INSTALL_DIR}/bin/)
file(COPY ${SOURCE_DIR}/bin/intel64/Release/cache.json DESTINATION ${POST_INSTALL_DIR}/bin/)
"
)
ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/openvinotoolkit/openvino.git"
				GIT_TAG "${VERSION}"
				GIT_PROGRESS 1
        UPDATE_COMMAND
            git submodule update --init --recursive
        CMAKE_ARGS
            -DENABLE_BEH_TESTS=OFF
            -DENABLE_C=OFF
            -DENABLE_FUNCTIONAL_TESTS=OFF
            -DENABLE_OPENCV:BOOL=OFF
            -DENABLE_PROFILING_ITT:BOOL=OFF
            -DENABLE_SAMPLES:BOOL=OFF
						-DENABLE_SPEECH_DEMO:BOOL=OFF
            -DENABLE_CPPCHECK:BOOL=OFF
            -DENABLE_CPPLINT:BOOL=OFF
            -DBUILD_TESTING:BOOL=OFF
            #-DBUILD_SHARED_LIBS:BOOL=ON
            -DENABLE_VPU:BOOL=ON
				    -DNGRAPH_UNIT_TEST_ENABLE:BOOL=OFF
				    -DNGRAPH_UNIT_TEST_OPENVINO_ENABLE:BOOL=OFF
						-DTREAT_WARNING_AS_ERROR:BOOL=OFF
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
            -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	    -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
        BUILD_COMMAND
            ${CMAKE_COMMAND} --build . --config Release --target inference_engine COMMAND
            ${CMAKE_COMMAND} --build . --config Release --target clDNNPlugin COMMAND
            ${CMAKE_COMMAND} --build . --config Release --target myriadPlugin COMMAND
            ${CMAKE_COMMAND} --build . --config Release --target MKLDNNPlugin
        INSTALL_COMMAND ""
)
elseif(APPLE)
set(SO_FILES
	libinference_engine.dylib
	libinference_engine_legacy.dylib
	libinference_engine_transformations.dylib
	libinference_engine_lp_transformations.dylib
	libinference_engine_ir_reader.so
	libinference_engine_ir_v7_reader.so
	libinference_engine_onnx_reader.so
	libonnx_importer.dylib
	libMKLDNNPlugin.so
	libmyriadPlugin.so
	libngraph.dylib
)
file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
file(COPY ${SOURCE_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
file(COPY ${SOURCE_DIR}/inference-engine/thirdparty/ade/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/ade/)
file(COPY ${SOURCE_DIR}/inference-engine/thirdparty/mkl-dnn/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/mkl-dnn/)
file(COPY ${SOURCE_DIR}/inference-engine/temp/tbb/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/tbb/)
file(COPY ${SOURCE_DIR}/inference-engine/include/ DESTINATION ${POST_INSTALL_DIR}/include/openvino/)
file(COPY ${SOURCE_DIR}/ngraph/core/include/ngraph/ DESTINATION ${POST_INSTALL_DIR}/include/ngraph/)
foreach(ARG ${SO_FILES})
   file(COPY ${SOURCE_DIR}/bin/intel64/Release/lib/$\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/)
endforeach()
file(COPY ${SOURCE_DIR}/inference-engine/temp/tbb/lib/libtbb.dylib DESTINATION ${POST_INSTALL_DIR}/lib/)
#file(COPY ${SOURCE_DIR}/bin/intel64/Release/lib/cache.json DESTINATION ${POST_INSTALL_DIR}/lib/)
file(COPY ${SOURCE_DIR}/bin/intel64/Release/lib/plugins.xml DESTINATION ${POST_INSTALL_DIR}/lib/)
")
ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/openvinotoolkit/openvino.git"
	GIT_TAG "${VERSION}"
	GIT_PROGRESS 1
        UPDATE_COMMAND
            git submodule update --init --recursive
        CMAKE_ARGS
            -DENABLE_BEH_TESTS=OFF
            -DENABLE_C=OFF
            -DENABLE_FUNCTIONAL_TESTS=OFF
            -DENABLE_OPENCV:BOOL=OFF
            -DENABLE_PROFILING_ITT:BOOL=OFF
            -DENABLE_SAMPLES:BOOL=OFF
            -DENABLE_CPPCHECK:BOOL=OFF
            -DENABLE_CPPLINT:BOOL=OFF
	    -DENABLE_SPEECH_DEMO:BOOL=OFF
            -DBUILD_TESTING:BOOL=OFF
            #-DBUILD_SHARED_LIBS:BOOL=ON
	    -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
            -DENABLE_VPU:BOOL=ON
	    -DNGRAPH_UNIT_TEST_ENABLE:BOOL=OFF
	    -DNGRAPH_UNIT_TEST_OPENVINO_ENABLE:BOOL=OFF
	    -DTREAT_WARNING_AS_ERROR:BOOL=OFF
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
            -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	    -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
        BUILD_COMMAND
            make -j4 inference_engine myriadPlugin MKLDNNPlugin
        INSTALL_COMMAND ""
)
else()
set(SO_FILES
	libinference_engine.so
	libinference_engine_legacy.so
	libinference_engine_transformations.so
	libinference_engine_lp_transformations.so
	libinference_engine_ir_reader.so
	libinference_engine_ir_v7_reader.so
	libinference_engine_onnx_reader.so
	libonnx_importer.so
	libclDNNPlugin.so
	libMKLDNNPlugin.so
	libmyriadPlugin.so
	libngraph.so
)
file(GENERATE OUTPUT ${INSTALL_DIR}package.cmake CONTENT "
file(COPY ${SOURCE_DIR}/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/${NAME}/)
file(COPY ${SOURCE_DIR}/inference-engine/thirdparty/ade/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/ade/)
file(COPY ${SOURCE_DIR}/inference-engine/thirdparty/mkl-dnn/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/mkl-dnn/)
file(COPY ${SOURCE_DIR}/inference-engine/temp/tbb/LICENSE DESTINATION ${POST_INSTALL_DIR}/licenses/tbb/)
file(COPY ${SOURCE_DIR}/inference-engine/include/ DESTINATION ${POST_INSTALL_DIR}/include/openvino/)
file(COPY ${SOURCE_DIR}/ngraph/core/include/ngraph/ DESTINATION ${POST_INSTALL_DIR}/include/ngraph/)
foreach(ARG ${SO_FILES})
   file(COPY ${SOURCE_DIR}/bin/intel64/Release/lib/$\{ARG\} DESTINATION ${POST_INSTALL_DIR}/lib/)
endforeach()
file(COPY ${SOURCE_DIR}/inference-engine/temp/tbb/lib/libtbb.so.2 DESTINATION ${POST_INSTALL_DIR}/lib/)
file(COPY ${SOURCE_DIR}/bin/intel64/Release/lib/cache.json DESTINATION ${POST_INSTALL_DIR}/lib/)
file(COPY ${SOURCE_DIR}/bin/intel64/Release/lib/plugins.xml DESTINATION ${POST_INSTALL_DIR}/lib/)
file(GLOB installedSOs ${POST_INSTALL_DIR}/lib/*.so*)
foreach(SO $\{installedSOs\})
    message(\"-- Setting runtime path of $\{SO\}\")
    execute_process(COMMAND patchelf --set-rpath \"$ORIGIN/../lib\" $\{SO\})
endforeach()
")
ExternalProject_Add(${NAME}
	PREFIX ${BUILD_DIR}
        GIT_REPOSITORY "https://github.com/openvinotoolkit/openvino.git"
	GIT_TAG "${VERSION}"
	GIT_PROGRESS 1
        UPDATE_COMMAND
            git submodule update --init --recursive
        CMAKE_ARGS
            -DENABLE_BEH_TESTS=OFF
            -DENABLE_C=OFF
            -DENABLE_FUNCTIONAL_TESTS=OFF
            -DENABLE_OPENCV:BOOL=OFF
            -DENABLE_PROFILING_ITT:BOOL=OFF
            -DENABLE_SAMPLES:BOOL=OFF
            -DENABLE_CPPCHECK:BOOL=OFF
            -DENABLE_CPPLINT:BOOL=OFF
						-DENABLE_SPEECH_DEMO:BOOL=OFF
            -DBUILD_TESTING:BOOL=OFF
            #-DBUILD_SHARED_LIBS:BOOL=ON
            -DENABLE_VPU:BOOL=ON
	    -DNGRAPH_UNIT_TEST_ENABLE:BOOL=OFF
	    -DNGRAPH_UNIT_TEST_OPENVINO_ENABLE:BOOL=OFF
	    -DTREAT_WARNING_AS_ERROR:BOOL=OFF
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
            -DCMAKE_INSTALL_MESSAGE:BOOL=LAZY
	    -DCMAKE_INSTALL_PREFIX:STRING=${INSTALL_DIR}
        BUILD_COMMAND
            make -j4 inference_engine clDNNPlugin myriadPlugin MKLDNNPlugin
        INSTALL_COMMAND ""
)
endif()
