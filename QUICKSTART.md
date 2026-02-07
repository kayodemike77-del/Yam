# Quick Start Guide

Get curl-impersonate running on Windows in minutes!

## Option 1: Download Pre-built Binaries (Easiest)

1. **Go to Actions**
   - Visit: https://github.com/kayodemike77-del/Yam/actions
   - Click "Build curl-impersonate for Windows"

2. **Trigger Build**
   - Click "Run workflow" → "Run workflow"
   - Wait 30-60 minutes for build to complete

3. **Download & Use**
   ```cmd
   # Download artifacts from completed workflow
   # Extract the ZIP file
   # Run:
   curl-impersonate-chrome.exe https://example.com
   ```

## Option 2: Build Locally (Advanced)

1. **Prerequisites**
   - Windows 10/11
   - PowerShell (as Administrator)
   - 10GB free space

2. **Clone Repository**
   ```powershell
   git clone https://github.com/kayodemike77-del/Yam.git
   cd Yam
   ```

3. **Run Build Script**
   ```powershell
   # As Administrator
   .\build-local.ps1
   ```

4. **Wait & Use**
   - Build takes 15-30 minutes
   - Find executables in `build/artifacts/`

## First Request

```cmd
# Basic usage
curl-impersonate-chrome.exe https://httpbin.org/get

# Save to file
curl-impersonate-chrome.exe https://example.com -o page.html

# With headers
curl-impersonate-chrome.exe -I https://example.com
```

## Common Commands

```cmd
# Impersonate specific browser
curl-impersonate-chrome.exe --impersonate chrome110 https://example.com

# Use with cookies
curl-impersonate-chrome.exe -b cookies.txt https://example.com

# POST request
curl-impersonate-chrome.exe -X POST -d "data=value" https://example.com

# Use proxy
curl-impersonate-chrome.exe --proxy http://proxy:8080 https://example.com
```

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
