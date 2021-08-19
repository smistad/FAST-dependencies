# FAST - Dependency build

This project is a CMake super build for dependencies of [FAST](https://github.com/smistad/FAST/).

## Dependency list
* Zlib
* Zip
* DCMTK
* HDF5
* OpenIGTLink
* OpenVINO
* Qt5
* TensorFlow
* OpenSlide
* libtiff
* libjpeg
* RealSense
* JKQTPlotter

## Usage

### Setup
```bash
git clone https://github.com/smistad/FAST-dependencies.git
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
