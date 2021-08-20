# Build TensorFlow

create_package_target(tensorflow 2.4.0)
create_package_code(" ")

if(WIN32)
    # Use CMake to build tensorflow on windows
    file(TO_NATIVE_PATH ${BUILD_DIR} BUILD_DIR_WIN)
    file(TO_NATIVE_PATH ${POST_INSTALL_DIR} POST_INSTALL_DIR_WIN)
    file(TO_NATIVE_PATH ${SOURCE_DIR} SOURCE_DIR_WIN)
    if(FAST_TensorFlow_CPU_ONLY)
        set(CONFIGURE_SCRIPT ${PROJECT_SOURCE_DIR}/TensorflowConfigureCPU.bat)
        set(BUILD_COMMAND echo "Building tensorflow with bazel for CPU only" &&
		cd ${SOURCE_DIR} &&
                bazel build --config=opt --jobs=${FAST_TensorFlow_JOBS} //tensorflow:tensorflow_cc.dll
        )
    else()
        find_package(CUDA)
        set(CONFIGURE_SCRIPT ${PROJECT_SOURCE_DIR}/TensorflowConfigureCUDA.bat ${CUDA_TOOLKIT_ROOT_DIR}  ${CUDA_VERSION_STRING})
        set(BUILD_COMMAND echo "Building tensorflow with bazel and CUDA GPU support" &&
		cd ${SOURCE_DIR} &&
                bazel build --config opt --config=cuda --jobs=${FAST_TensorFlow_JOBS} //tensorflow:tensorflow_cc.dll
	)
    endif()
    ExternalProject_Add(${NAME}
     	    PREFIX ${BUILD_DIR}
	    BINARY_DIR ${BUILD_DIR}
	    GIT_REPOSITORY "https://github.com/smistad/tensorflow.git"
	    GIT_TAG "c1dbfb67dfdffad3b3bc2f4fc538139a830fe6c0"
	    GIT_PROGRESS 1
	    #DOWNLOAD_COMMAND ""
            UPDATE_COMMAND ""
            CONFIGURE_COMMAND
                echo "Configuring TensorFlow..." COMMAND
		cd ${SOURCE_DIR} COMMAND
                ${CONFIGURE_SCRIPT} COMMAND
                echo "Done TF configure"
            BUILD_COMMAND
                ${BUILD_COMMAND}
            INSTALL_COMMAND
                echo "Installing tensorflow binary"  COMMAND
		${CMAKE_COMMAND} -E copy ${SOURCE_DIR}/bazel-bin/tensorflow/tensorflow_cc.dll.if.lib ${POST_INSTALL_DIR}/lib/tensorflow_cc.lib COMMAND
		#${CMAKE_COMMAND} -E copy ${SOURCE_DIR}/bazel-bin/external/protobuf_archive/protobuf.lib ${FAST_EXTERNAL_INSTALL_DIR}/lib/protobuf.lib COMMAND
		${CMAKE_COMMAND} -E copy ${SOURCE_DIR}/bazel-bin/tensorflow/tensorflow_cc.dll ${POST_INSTALL_DIR}/bin/tensorflow_cc.dll COMMAND
                echo "Installing tensorflow headers"  COMMAND
		xcopy "${SOURCE_DIR_WIN}\\tensorflow\\*.h" "${POST_INSTALL_DIR_WIN}\\include\\tensorflow\\" /syi COMMAND
                echo "Installing tensorflow generated headers" COMMAND
		xcopy "${SOURCE_DIR_WIN}\\bazel-bin\\tensorflow\\*.h" "${POST_INSTALL_DIR_WIN}\\include\\tensorflow\\" /syi COMMAND
                echo "Installing tensorflow third party headers"  COMMAND
		xcopy "${SOURCE_DIR_WIN}\\third_party\\" "${POST_INSTALL_DIR_WIN}\\include\\third_party\\" /syi  COMMAND
                echo "Installing protobuf headers"  COMMAND
		xcopy "${SOURCE_DIR_WIN}\\bazel-tensorflow_download\\external\\com_google_protobuf\\src\\google\\*.h" "${POST_INSTALL_DIR_WIN}\\include\\google\\" /syi COMMAND
		xcopy "${SOURCE_DIR_WIN}\\bazel-tensorflow_download\\external\\com_google_protobuf\\src\\google\\*.inc" "${POST_INSTALL_DIR_WIN}\\include\\google\\" /syi COMMAND
                echo "Installing absl headers"  COMMAND
		xcopy "${SOURCE_DIR_WIN}\\bazel-tensorflow_download\\external\\com_google_absl\\absl\\*.h" "${POST_INSTALL_DIR_WIN}\\include\\absl\\" /syi COMMAND
		xcopy "${SOURCE_DIR_WIN}\\bazel-tensorflow_download\\external\\com_google_absl\\absl\\*.inc" "${POST_INSTALL_DIR_WIN}\\include\\absl\\" /syi
    )
else(WIN32)
    # Use bazel to build tensorflow on linux
    if(FAST_TensorFlow_CPU_ONLY)
        set(CONFIGURE_SCRIPT ${PROJECT_SOURCE_DIR}/TensorflowConfigureCPU.sh)
        set(BUILD_COMMAND echo "Building tensorflow with bazel for CPU only" &&
	    cd ${SOURCE_DIR} &&
            bazel build -c opt --config=opt --copt=-mfpmath=both --copt=-march=core-avx2 --jobs=${FAST_TensorFlow_JOBS} //tensorflow:libtensorflow_cc.so
        )
    else()
        set(CONFIGURE_SCRIPT ${PROJECT_SOURCE_DIR}/TensorflowConfigureCUDA.sh)
        set(BUILD_COMMAND echo "Building tensorflow with bazel and CUDA GPU support" &&
	    cd ${SOURCE_DIR} &&
            bazel build -c opt --config=cuda --copt=-mfpmath=both --copt=-march=core-avx2 --jobs=${FAST_TensorFlow_JOBS} //tensorflow:libtensorflow_cc.so
        )
    endif()
	ExternalProject_Add(${NAME}
	    PREFIX ${BUILD_DIR}
	    BINARY_DIR ${BUILD_DIR}
	    GIT_REPOSITORY "https://github.com/smistad/tensorflow.git"
	    GIT_TAG "c1dbfb67dfdffad3b3bc2f4fc538139a830fe6c0"
	    GIT_PROGRESS 1
	    #DOWNLOAD_COMMAND ""
            UPDATE_COMMAND ""
            # Run TF configure in the form of a shell script. CUDA should be installed in /usr/local/cuda
            CONFIGURE_COMMAND
	        cd ${SOURCE_DIR} && sh ${CONFIGURE_SCRIPT}
            # Build using bazel
            BUILD_COMMAND
                ${BUILD_COMMAND}
            INSTALL_COMMAND
                echo "Installing tensorflow binary" &&
		cp -f ${SOURCE_DIR}/bazel-bin/tensorflow/libtensorflow_cc.so.2.4.0 ${POST_INSTALL_DIR}/lib/ &&
		cp -fP ${SOURCE_DIR}/bazel-bin/tensorflow/libtensorflow_cc.so.2 ${POST_INSTALL_DIR}/lib/ &&
		cp -fP ${SOURCE_DIR}/bazel-bin/tensorflow/libtensorflow_cc.so ${POST_INSTALL_DIR}/lib/ &&
		cp -f ${SOURCE_DIR}/bazel-bin/tensorflow/libtensorflow_framework.so.2.4.0 ${POST_INSTALL_DIR}/lib/ &&
		cp -fP ${SOURCE_DIR}/bazel-bin/tensorflow/libtensorflow_framework.so.2 ${POST_INSTALL_DIR}/lib/ &&
		chmod a+w ${POST_INSTALL_DIR}/lib/libtensorflow_cc.so.2.4.0 &&
		chmod a+w ${POST_INSTALL_DIR}/lib/libtensorflow_framework.so.2.4.0 &&
		strip -s ${POST_INSTALL_DIR}/lib/libtensorflow_cc.so.2.4.0 &&
		strip -s ${POST_INSTALL_DIR}/lib/libtensorflow_framework.so.2.4.0 &&
                echo "Installing tensorflow headers" &&
		cp -rf ${SOURCE_DIR}/tensorflow/ ${POST_INSTALL_DIR}/include/ &&
                echo "Installing tensorflow generated headers" &&
		cd ${SOURCE_DIR}/bazel-bin/ &&
		bash -c "find tensorflow/ -name '*.h' | xargs cp -f --parents -t ${POST_INSTALL_DIR}/include/" &&
                echo "Installing tensorflow third_party headers" &&
		cp -rf ${SOURCE_DIR}/third_party/ ${POST_INSTALL_DIR}/include/ &&
                echo "Installing protobuf headers" &&
		bash -c "cp $(readlink -f ${SOURCE_DIR}/bazel-out/)/../../../external/com_google_protobuf/src/google/ ${POST_INSTALL_DIR}/include/ -Rf" &&
                echo "Installing absl headers" &&
		bash -c "cp $(readlink -f ${SOURCE_DIR}/bazel-out/)/../../../external/com_google_absl/absl/ ${POST_INSTALL_DIR}/include/ -Rf"
    )
endif(WIN32)
