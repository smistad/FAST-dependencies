# FAST - Dependency build

This project is a CMake super build for dependencies of [FAST](https://github.com/smistad/FAST/).

## Dependency list
* zlib
* zip
* dcmtk
* hdf5
* OpenIGTLink
* OpenVINO
* qt5
* tensorflow
* realsense
* jkqtplotter
* (OpenSlide)
* (libtiff)
* (libjpeg)

## Usage

### Requirements - Ubuntu Linux
**Install the following tools (On Ubuntu 20.04 use GCC 8, not 9 or 10 as OpenVINO fails to build):**
```bash
sudo snap install cmake --classic # Use snap to get more recent version of cmake on Ubuntu 18.04
sudo apt install g++ git patchelf
sudo apt install '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev
sudo apt install pkgconf libusb-1.0-0-dev # Needed for realsense
```

**Install TensorFlow build tools:**
* Install java if you don't already have it
* Install bazel 3.1.0: https://github.com/bazelbuild/bazel/releases/tag/3.1.0
* Install Python 3 with numpy 1.19.0
* Install CUDA toolkit 	(if GPU build)
* Install cuDNN 	(if GPU build)

### Requirements - Windows

**Install the following tools:**
* [Git](https://git-scm.com/downloads)
* [CMake](https://cmake.org/)
* [Visual Studio 2019 Community](https://visualstudio.microsoft.com/downloads/)

**Install TensorFlow build tools:**
* Install java if you don't already have it
* Install bazel 3.1.0: https://github.com/bazelbuild/bazel/releases/tag/3.1.0
  Put bazel.exe in path
* Install msys2 and some packages: https://docs.bazel.build/versions/master/install-windows.html#installing-compilers-and-language-runtimes
* Install Python 3 with numpy 1.19.0
* Install CUDA toolkit 	(if GPU build)
* Install cuDNN 	(if GPU build)

### Setup
```bash
git clone https://github.com/smistad/FAST-dependencies.git
cd FAST-dependencies
mkdir build
cd build
cmake ..
```

### Build all
```bash
cmake --build . --config Release -j8
```
Warning: This will take a very long time.  
All packages will be located in the build/dist/ folder.

### Build a specific dependency
To build dependency _name_:
```bash
cmake --build . -t <name>_package --config Release -j8
```
The package will be located in the build/dist/ folder.

### Generate SHA for all files
SHA hashes can be generated with:
```bash
cmake --build . -t hash_all
```

### Clean the build of a specific dependency
```bash
rm -Rf build_output/<name>/
```
