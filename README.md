# FAST - Dependency build

This project is a CMake super build for depdencies of [FAST](https://github.com/smistad/FAST/).

## Usage
Setup:
```bash
mkdir build
cd build
cmake ..
```

Build all:
```bash
cmake --build . --config Release -j8
```

Build a specific dependecy <name>:
```bash
cmake --build . -t <name>_package --config Release -j8
```

All packages will be located in the build/dist/ folder.
SHA hashes can be generated with:
```bash
cmake --build . -t hash_all
```
