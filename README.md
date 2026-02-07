# Yam - curl-impersonate for Windows

This repository provides automated builds of [curl-impersonate](https://github.com/lwthiker/curl-impersonate) for Windows using GitHub Actions.

## What is curl-impersonate?

curl-impersonate is a special build of curl that can impersonate the four major browsers: Chrome, Edge, Safari & Firefox. It does this by:
- Using the same TLS/SSL cipher suites and extensions
- Using the same HTTP/2 settings and headers
- Matching the browser's behavior as closely as possible

This makes it useful for web scraping and automation tasks where websites might block standard curl requests.

## Features

- Automated builds using GitHub Actions
- Two build variants:
  - **Chrome variant**: Built with BoringSSL (Chrome's SSL library)
  - **Firefox variant**: Built with MSYS2/MinGW
- Pre-compiled Windows executables available as artifacts
- No local build environment required

## Getting Started

### Download Pre-built Binaries

1. Go to the [Actions tab](../../actions)
2. Click on the "Build curl-impersonate for Windows" workflow
3. Click "Run workflow" to trigger a new build
4. Once complete, download the artifacts:
   - `curl-impersonate-windows` - Chrome variant
   - `curl-impersonate-windows-msys2` - Firefox variant

### Local Build (Advanced)

If you want to build curl-impersonate locally on Windows, you can use the provided build script:

```powershell
.\build-local.ps1
```

This script will install the necessary dependencies and build curl-impersonate on your local machine.

#### Prerequisites for Local Build

- Windows 10/11
- PowerShell 5.1 or later
- Chocolatey package manager (will be installed by the script if not present)
- At least 10GB of free disk space

## Usage

After downloading the built executable:

```cmd
# Basic usage (impersonate Chrome)
curl-impersonate-chrome.exe https://example.com

# Save output to file
curl-impersonate-chrome.exe https://example.com -o output.html

# Include headers
curl-impersonate-chrome.exe -I https://example.com

# Use with specific Chrome version
curl-impersonate-chrome.exe --impersonate chrome110 https://example.com
```

For more information on available options, see the [curl-impersonate documentation](https://github.com/lwthiker/curl-impersonate).

## Build Process

The GitHub Actions workflow performs the following steps:

### Chrome Variant (BoringSSL)
1. Installs build tools (NASM, Perl, CMake, Ninja, Go)
2. Clones curl-impersonate repository
3. Builds BoringSSL
4. Builds nghttp2
5. Builds curl with impersonation patches
6. Packages the executable

### Firefox Variant (MSYS2)
1. Sets up MSYS2 environment
2. Installs MinGW toolchain
3. Clones curl-impersonate repository
4. Builds using available build system
5. Packages the executable

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

The curl-impersonate project itself is licensed under its own terms. See the [original repository](https://github.com/lwthiker/curl-impersonate) for details.

## Acknowledgments

- [curl-impersonate](https://github.com/lwthiker/curl-impersonate) by lwthiker
- [curl](https://curl.se/) - The original curl project
- [BoringSSL](https://boringssl.googlesource.com/boringssl/) - Google's SSL library
- [MSYS2](https://www.msys2.org/) - Software distribution and building platform for Windows

## Troubleshooting

### Build Failures

If the GitHub Actions build fails:
1. Check the workflow logs for specific error messages
2. Ensure all dependencies are available
3. Try running the workflow again (sometimes temporary network issues can cause failures)

### Local Build Issues

If local builds fail:
1. Ensure you have administrator privileges
2. Check that all dependencies installed correctly
3. Verify you have enough disk space
4. Check your internet connection (required for downloading source code)

## Support

For issues related to:
- **This build automation**: Open an issue in this repository
- **curl-impersonate itself**: Visit the [original repository](https://github.com/lwthiker/curl-impersonate/issues)
