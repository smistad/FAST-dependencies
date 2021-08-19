# FAST - Dependency build

This project is a CMake super build for dependencies of [FAST](https://github.com/smistad/FAST/).

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
All packages will be located in the build/dist/ folder.

### Build a specific dependecy <name>
```bash
cmake --build . -t <name>_package --config Release -j8
```
The package will be located in the build/dist/ folder.

### Generate SHA for all files
SHA hashes can be generated with:
```bash
cmake --build . -t hash_all
```
