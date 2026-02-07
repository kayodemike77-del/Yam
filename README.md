# Yam - curl-impersonate for Windows

This repository provides automated builds of [curl-impersonate](https://github.com/lwthiker/curl-impersonate) for Windows using GitHub Actions.

## What is curl-impersonate?

curl-impersonate is a special build of curl that can impersonate the four major browsers: Chrome, Edge, Safari & Firefox. It does this by:
- Using the same TLS/SSL cipher suites and extensions
- Using the same HTTP/2 settings and headers
- Matching the browser's behavior as closely as possible

This makes it useful for web scraping and automation tasks where websites might block standard curl requests.

## Features

- Automated builds using GitHub Actions via MSYS2
- Two build variants:
  - **Chrome variant**: Includes curl_chrome*, curl_edge*, and curl_safari* executables
  - **Firefox variant**: Includes curl_ff* executables (Firefox impersonation)
- Pre-compiled Windows executables available as artifacts
- No local build environment required
- Builds take approximately 30-60 minutes

## Getting Started

### Download Pre-built Binaries

> **⏱️ Build Time**: Each variant takes approximately 30-60 minutes to build. Please be patient!

1. Go to the [Actions tab](../../actions/workflows/build-curl-impersonate.yml)
2. Click on the "Build curl-impersonate for Windows" workflow
3. Click the green "Run workflow" button to trigger a new build
4. Wait for the build to complete (you'll see a green checkmark when done)
5. Click on the completed workflow run
6. Scroll down to the **"Artifacts"** section at the bottom of the page
7. Download the artifacts you need:
   - `curl-impersonate-chrome-windows` - Chrome/Edge/Safari variants
   - `curl-impersonate-firefox-windows` - Firefox variants

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

After downloading and extracting the artifact ZIP files, you'll have multiple curl executables:

**Chrome Variant:**
```cmd
# Impersonate Chrome 116
curl_chrome116.exe https://example.com

# Impersonate Chrome 110
curl_chrome110.exe https://example.com

# Impersonate Edge 101
curl_edge101.exe https://example.com

# Impersonate Safari 15.5
curl_safari15_5.exe https://example.com
```

**Firefox Variant:**
```cmd
# Impersonate Firefox 109
curl_ff109.exe https://example.com

# Impersonate Firefox 102
curl_ff102.exe https://example.com

# Impersonate Firefox 98
curl_ff98.exe https://example.com
```

For more options and examples, see the [Usage Guide](docs/USAGE.md).

## Build Process

The GitHub Actions workflow uses MSYS2 (a Unix-like environment for Windows) to build curl-impersonate using the official build method:

### Firefox Variant Build
1. Sets up MSYS2 with MinGW64 toolchain
2. Installs dependencies (NSS, Python, gyp-next, etc.)
3. Clones curl-impersonate repository  
4. Runs `configure` and `make firefox-build`
5. Collects all `curl_ff*` executables
6. Packages as `curl-impersonate-firefox-windows` artifact

### Chrome Variant Build
1. Sets up MSYS2 with MinGW64 toolchain
2. Installs dependencies (Go, NASM, etc.)
3. Clones curl-impersonate repository
4. Runs `configure` and `make chrome-build`
5. Collects all `curl_chrome*`, `curl_edge*`, `curl_safari*` executables
6. Packages as `curl-impersonate-chrome-windows` artifact

**⚠️ Note**: Building on Windows is complex and time-consuming. The process uses MSYS2 because curl-impersonate doesn't have native Windows build scripts - it requires a Unix-like build environment.

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
