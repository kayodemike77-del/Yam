# Build Guide

This guide provides detailed instructions for building curl-impersonate on Windows.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Using GitHub Actions (Recommended)](#using-github-actions-recommended)
- [Local Build](#local-build)
- [Build Variants](#build-variants)
- [Build Output](#build-output)

## Prerequisites

### For GitHub Actions Build
- A GitHub account
- Access to this repository

### For Local Build
- Windows 10 or later
- At least 10GB free disk space
- Administrator privileges (recommended)
- Internet connection

## Using GitHub Actions (Recommended)

The easiest way to build curl-impersonate is using GitHub Actions:

1. **Navigate to Actions Tab**
   - Go to the repository on GitHub
   - Click the "Actions" tab at the top

2. **Select the Workflow**
   - Click on "Build curl-impersonate for Windows" from the left sidebar

3. **Run the Workflow**
   - Click the "Run workflow" button (right side)
   - Select the branch (usually `main`)
   - Click "Run workflow" to start the build

4. **Wait for Completion**
   - The build typically takes 30-60 minutes
   - You can watch the progress in real-time
   - Both variants (Chrome and Firefox) build in parallel

5. **Download Artifacts**
   - Once complete, scroll to the bottom of the workflow run
   - Download the artifact packages:
     - `curl-impersonate-windows` - Chrome variant
     - `curl-impersonate-windows-msys2` - Firefox variant

6. **Extract and Use**
   - Extract the downloaded ZIP files
   - The executables are ready to use

## Local Build

### Automated Local Build

Use the provided PowerShell script for an automated build:

```powershell
# Basic build (both variants)
.\build-local.ps1

# Build only Chrome variant
.\build-local.ps1 -Variant chrome

# Skip dependency installation (if already installed)
.\build-local.ps1 -SkipDependencies
```

The script will:
1. Install Chocolatey (if needed)
2. Install all required dependencies
3. Clone curl-impersonate repository
4. Build the selected variant(s)
5. Collect artifacts in the `build/artifacts` directory

### Manual Local Build

If you prefer to build manually:

#### Step 1: Install Dependencies

```powershell
# Install Chocolatey (if not installed)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install build tools
choco install nasm strawberryperl cmake ninja golang git -y
```

#### Step 2: Update PATH

```powershell
$env:Path = "C:\Program Files\NASM;" + $env:Path
$env:Path = "C:\Strawberry\perl\bin;" + $env:Path
$env:Path = "C:\Program Files\Go\bin;" + $env:Path
```

#### Step 3: Clone Repository

```powershell
git clone --depth 1 https://github.com/lwthiker/curl-impersonate.git
cd curl-impersonate
git submodule update --init --depth 1
```

#### Step 4: Build BoringSSL

```powershell
mkdir build-boringssl
cd build-boringssl
cmake -GNinja -DCMAKE_BUILD_TYPE=Release ..\boringssl
ninja crypto ssl
cd ..
```

#### Step 5: Build nghttp2

```powershell
mkdir build-nghttp2
cd build-nghttp2
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_LIB_ONLY=ON -DENABLE_STATIC_LIB=ON ..\nghttp2
ninja
cd ..
```

#### Step 6: Build curl

```powershell
cd curl
mkdir build
cd build

cmake -GNinja -DCMAKE_BUILD_TYPE=Release `
  -DCURL_USE_OPENSSL=ON `
  -DOPENSSL_ROOT_DIR=..\..\build-boringssl `
  -DUSE_NGHTTP2=ON `
  -DNGHTTP2_LIBRARY=..\..\build-nghttp2\lib `
  -DNGHTTP2_INCLUDE_DIR=..\..\nghttp2\lib\includes `
  -DBUILD_SHARED_LIBS=OFF `
  -DCURL_DISABLE_LDAP=ON `
  -DCURL_STATICLIB=ON `
  ..

ninja
```

## Build Variants

### Chrome Variant (BoringSSL)

**What it does:**
- Uses BoringSSL (Google's fork of OpenSSL)
- Impersonates Chrome browser behavior
- Best for websites that specifically check for Chrome

**Build components:**
- BoringSSL
- nghttp2 (HTTP/2 support)
- curl with Chrome impersonation patches

**Typical use cases:**
- Scraping Google services
- Accessing sites that prefer Chrome
- Testing Chrome-specific behaviors

### Firefox Variant (MSYS2)

**What it does:**
- Built using MSYS2/MinGW toolchain
- Impersonates Firefox browser behavior
- Alternative SSL implementation

**Build components:**
- Standard OpenSSL or NSS
- nghttp2 (HTTP/2 support)
- curl with Firefox impersonation patches

**Typical use cases:**
- Scraping sites that work better with Firefox
- Testing Firefox-specific behaviors
- Environments where BoringSSL isn't suitable

## Build Output

### Artifact Contents

After a successful build, you'll have:

```
artifacts/
├── curl-impersonate-chrome.exe  (or curl-impersonate-firefox.exe)
└── [optional DLL files]
```

### File Sizes

Typical file sizes:
- Chrome variant: ~8-12 MB
- Firefox variant: ~6-10 MB

(Sizes may vary based on build configuration and dependencies)

### Testing the Build

Verify your build works correctly:

```powershell
# Test basic functionality
.\curl-impersonate-chrome.exe --version

# Test HTTPS connection
.\curl-impersonate-chrome.exe https://httpbin.org/get

# Test impersonation
.\curl-impersonate-chrome.exe -I https://www.google.com
```

## Build Troubleshooting

### Common Issues

**Issue: CMake not found**
```
Solution: Ensure CMake is installed and in PATH
choco install cmake -y
```

**Issue: Ninja not found**
```
Solution: Install Ninja build system
choco install ninja -y
```

**Issue: NASM not found**
```
Solution: Install NASM assembler
choco install nasm -y
```

**Issue: BoringSSL build fails**
```
Solution: 
1. Verify Go is installed (required for BoringSSL)
2. Check that NASM is in PATH
3. Ensure you have enough disk space
```

**Issue: Linking errors**
```
Solution:
1. Clean build directory and rebuild
2. Verify all dependencies built successfully
3. Check that library paths are correct
```

### Build Environment

For best results:
- Use a clean Windows installation
- Close unnecessary applications during build
- Ensure antivirus doesn't interfere with build process
- Use SSD for faster build times

## Advanced Configuration

### Custom Build Options

You can customize the build by modifying CMake options:

```powershell
# Enable debug symbols
cmake -DCMAKE_BUILD_TYPE=Debug ...

# Build shared libraries
cmake -DBUILD_SHARED_LIBS=ON ...

# Enable specific curl features
cmake -DCURL_ENABLE_FEATURE=ON ...
```

### Optimizing Build Time

- Use `/MP` flag for parallel compilation (MSVC)
- Increase Ninja parallel jobs: `ninja -j 8`
- Use RAM disk for build directory
- Close resource-intensive applications

## Next Steps

After building successfully:
- Read the [Usage Guide](USAGE.md) to learn how to use curl-impersonate
- Check [Troubleshooting](TROUBLESHOOTING.md) for runtime issues
- See [CONTRIBUTING.md](../CONTRIBUTING.md) to contribute improvements
