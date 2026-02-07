# Quick Start Guide

Get curl-impersonate running on Windows!

## Option 1: Download Pre-built Binaries (Recommended)

### Step 1: Trigger a Build

1. **Go to Actions**
   - Visit: https://github.com/kayodemike77-del/Yam/actions/workflows/build-curl-impersonate.yml
   - Click on "Build curl-impersonate for Windows"

2. **Start the Build**
   - Click the green "Run workflow" button on the right
   - Select branch: `main`
   - Click "Run workflow"

3. **Wait for Completion** ⏱️
   - **Build time**: 30-60 minutes per variant
   - Two builds run in parallel (Firefox and Chrome)
   - You'll see ✅ green checkmarks when complete
   - You can close the tab and come back later

### Step 2: Download Artifacts

1. **Open the completed workflow run**
   - Click on the completed run (green checkmark)
   
2. **Scroll to Artifacts section**
   - Go to the bottom of the page
   - Look for "Artifacts" section
   
3. **Download what you need**
   - `curl-impersonate-firefox-windows.zip` - Firefox variants (curl_ff*.exe)
   - `curl-impersonate-chrome-windows.zip` - Chrome/Edge/Safari variants (curl_chrome*.exe, curl_edge*.exe)

### Step 3: Extract and Use

```cmd
# Extract the ZIP file
# You'll find multiple executables like:
# - curl_chrome116.exe
# - curl_ff109.exe
# - curl_edge101.exe
# etc.

# Test it:
curl_chrome116.exe https://httpbin.org/get
```

## Option 2: Build Locally (Advanced)

> ⚠️ **Warning**: Local builds on Windows are complex and not officially supported by curl-impersonate. GitHub Actions builds are recommended.

1. **Prerequisites**
   - Windows 10/11
   - MSYS2 installed
   - Significant build time (1+ hour)

2. **Use MSYS2**
   ```bash
   # Inside MSYS2 MinGW64 shell:
   git clone https://github.com/lwthiker/curl-impersonate.git
   cd curl-impersonate
   mkdir build && cd build
   ../configure
   make firefox-build  # or chrome-build
   ```

For detailed local build instructions, see [Build Guide](docs/BUILD.md).

## First Request Examples

**Firefox variant:**
```cmd
# Basic request
curl_ff109.exe https://example.com

# Save to file
curl_ff109.exe https://example.com -o page.html

# Show headers
curl_ff109.exe -I https://example.com

# With cookies
curl_ff109.exe -b cookies.txt https://example.com
```

**Chrome variant:**
```cmd
# Basic request
curl_chrome116.exe https://example.com

# POST request
curl_chrome116.exe -X POST -d "key=value" https://example.com/api

# Use proxy
curl_chrome116.exe --proxy http://proxy:8080 https://example.com

# Download file
curl_chrome116.exe https://example.com/file.zip -o file.zip
```

## Available Executables

After downloading artifacts, you'll have these executables:

**Firefox Variants:**
- `curl_ff109.exe` - Firefox 109
- `curl_ff102.exe` - Firefox 102
- `curl_ff100.exe` - Firefox 100
- `curl_ff98.exe` - Firefox 98
- `curl_ff95.exe` - Firefox 95
- `curl_ff91esr.exe` - Firefox 91 ESR

**Chrome/Edge/Safari Variants:**
- `curl_chrome116.exe` - Chrome 116
- `curl_chrome110.exe` - Chrome 110
- `curl_chrome107.exe` - Chrome 107
- `curl_chrome104.exe` - Chrome 104
- `curl_chrome101.exe` - Chrome 101
- `curl_chrome100.exe` - Chrome 100
- `curl_chrome99.exe` - Chrome 99
- `curl_edge101.exe` - Edge 101
- `curl_edge99.exe` - Edge 99
- `curl_safari15_5.exe` - Safari 15.5
- `curl_safari15_3.exe` - Safari 15.3

## Next Steps

- 📖 Read the [full README](README.md)
- 🔧 Check [Usage Guide](docs/USAGE.md) for more examples
- 🏗️ See [Build Guide](docs/BUILD.md) for detailed build instructions
- ❓ Visit [Troubleshooting](docs/TROUBLESHOOTING.md) if you have issues

## Need Help?

- [Open an issue](../../issues/new)
- [Check existing issues](../../issues)
- [Read the docs](docs/)

---

**That's it!** You're ready to use curl-impersonate on Windows. 🎉
