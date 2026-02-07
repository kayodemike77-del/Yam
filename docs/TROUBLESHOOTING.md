# Troubleshooting Guide

This guide covers common issues and their solutions for building and using curl-impersonate on Windows.

## Table of Contents

- [Build Issues](#build-issues)
- [Runtime Issues](#runtime-issues)
- [GitHub Actions Issues](#github-actions-issues)
- [Performance Issues](#performance-issues)
- [Getting Help](#getting-help)

## Build Issues

### Dependencies Not Found

**Symptom**: Error messages about missing tools (cmake, ninja, nasm, etc.)

**Solution**:
```powershell
# Reinstall all dependencies
choco install nasm strawberryperl cmake ninja golang git -y --force

# Verify installation
cmake --version
ninja --version
nasm --version
go version
```

**Prevention**: Always run the build script as Administrator

---

### BoringSSL Build Fails

**Symptom**: Errors during BoringSSL compilation

**Common causes**:
1. Missing Go installation
2. NASM not in PATH
3. Insufficient disk space

**Solution**:
```powershell
# Check Go installation
go version

# Check NASM
nasm --version

# Add to PATH if needed
$env:Path = "C:\Program Files\NASM;" + $env:Path
$env:Path = "C:\Program Files\Go\bin;" + $env:Path

# Check disk space
Get-PSDrive C
```

**Alternative**: Try cleaning the build directory and rebuilding:
```powershell
Remove-Item -Recurse -Force build
.\build-local.ps1
```

---

### CMake Configuration Fails

**Symptom**: CMake errors about missing libraries or paths

**Solution**:
```powershell
# Verify paths exist
Test-Path .\build-boringssl
Test-Path .\build-nghttp2

# Clean CMake cache
Remove-Item -Recurse CMakeCache.txt, CMakeFiles

# Reconfigure with verbose output
cmake -GNinja -DCMAKE_BUILD_TYPE=Release --trace-expand ...
```

---

### Ninja Build Errors

**Symptom**: Compilation errors during `ninja` step

**Solution**:
```powershell
# Clean and rebuild
ninja clean
ninja -v  # Verbose output

# Try single-threaded build
ninja -j 1
```

**Common fixes**:
- Ensure Visual Studio Build Tools are installed
- Check that all source files are present
- Verify submodules are initialized: `git submodule update --init --depth 1`

---

### Permission Denied Errors

**Symptom**: Access denied when creating directories or files

**Solution**:
1. Run PowerShell as Administrator
2. Check antivirus isn't blocking operations
3. Ensure the build directory isn't open in another program

```powershell
# Run as admin
Start-Process powershell -Verb RunAs

# Temporarily disable Windows Defender for build directory
Add-MpPreference -ExclusionPath "C:\path\to\build"
```

---

### Out of Memory Errors

**Symptom**: Build fails with memory allocation errors

**Solution**:
```powershell
# Use fewer parallel jobs
ninja -j 2

# Close other applications
# Increase page file size in Windows settings
# Use a machine with more RAM (8GB minimum recommended)
```

---

### Submodule Initialization Fails

**Symptom**: Git submodule errors

**Solution**:
```powershell
# Reinitialize submodules
git submodule deinit -f --all
git submodule update --init --depth 1 --force

# If still failing, clone fresh
cd ..
Remove-Item -Recurse -Force curl-impersonate
git clone --depth 1 https://github.com/lwthiker/curl-impersonate.git
cd curl-impersonate
git submodule update --init --depth 1
```

---

## Runtime Issues

### Missing DLL Errors

**Symptom**: Error when running curl-impersonate about missing DLLs

**Solution**:
```powershell
# Copy required DLLs to the same directory as the .exe
# Common DLLs needed:
# - libcrypto-*.dll
# - libssl-*.dll
# - nghttp2.dll

# Find DLLs in build directory
Get-ChildItem -Recurse -Filter "*.dll" | Copy-Item -Destination .\artifacts\
```

---

### SSL Certificate Errors

**Symptom**: SSL certificate verification failed

**Solutions**:

1. **Use system CA bundle**:
```cmd
curl-impersonate-chrome.exe --cacert C:\path\to\ca-bundle.crt https://example.com
```

2. **Download latest CA bundle**:
```powershell
Invoke-WebRequest https://curl.se/ca/cacert.pem -OutFile cacert.pem
curl-impersonate-chrome.exe --cacert cacert.pem https://example.com
```

3. **Skip verification** (not recommended for production):
```cmd
curl-impersonate-chrome.exe -k https://example.com
```

---

### Connection Timeouts

**Symptom**: Requests timeout or hang

**Solution**:
```cmd
# Increase timeout
curl-impersonate-chrome.exe --connect-timeout 30 --max-time 300 https://example.com

# Use IPv4 only (sometimes faster)
curl-impersonate-chrome.exe -4 https://example.com

# Check DNS resolution
curl-impersonate-chrome.exe -v https://example.com 2>&1 | findstr "Trying"
```

---

### "Could not resolve host" Errors

**Symptom**: DNS resolution failures

**Solution**:
```cmd
# Test with public DNS
curl-impersonate-chrome.exe --dns-servers 8.8.8.8 https://example.com

# Verify internet connection
ping google.com

# Check Windows DNS settings
ipconfig /all
```

---

### Still Getting Blocked/Detected

**Symptom**: Website still detects and blocks requests despite impersonation

**Solutions**:

1. **Try different browser variant**:
```cmd
curl-impersonate-chrome.exe --impersonate firefox109 https://example.com
```

2. **Add more headers**:
```cmd
curl-impersonate-chrome.exe https://example.com ^
  -H "Accept-Language: en-US,en;q=0.9" ^
  -H "Accept: text/html,application/xhtml+xml" ^
  -H "Referer: https://www.google.com"
```

3. **Use real cookies**:
```cmd
# Export cookies from browser to cookies.txt
curl-impersonate-chrome.exe -b cookies.txt https://example.com
```

4. **Check other detection methods**:
- IP-based blocking (try using a VPN/proxy)
- Rate limiting (add delays between requests)
- JavaScript challenges (curl can't execute JavaScript)
- Behavioral analysis (vary your patterns)

---

### HTTP 403 Forbidden Errors

**Symptom**: Server returns 403 even with impersonation

**Solutions**:
```cmd
# Add Referer header
curl-impersonate-chrome.exe -H "Referer: https://www.google.com/" https://example.com

# Try with cookies
curl-impersonate-chrome.exe -b cookies.txt https://example.com

# Check if you're being rate limited
curl-impersonate-chrome.exe -v https://example.com 2>&1 | findstr "429\|403"
```

---

## GitHub Actions Issues

### Workflow Doesn't Start

**Symptom**: Workflow doesn't run when triggered

**Solution**:
1. Check if workflow is enabled in repository settings
2. Verify you have workflow dispatch permission
3. Check Actions tab for any errors

---

### Build Timeout

**Symptom**: GitHub Actions build times out

**Solution**:
The workflow is configured for manual trigger only. If builds consistently timeout:

1. Check if upstream dependencies are accessible
2. Review build logs for hanging steps
3. Consider reducing parallel builds
4. May need to increase timeout in workflow:

```yaml
jobs:
  build-chrome:
    timeout-minutes: 120  # Increase from default
```

---

### Artifact Upload Fails

**Symptom**: Built files don't appear as artifacts

**Solution**:
1. Check the "Collect artifacts" step completed successfully
2. Verify files were actually built:
```yaml
- name: Verify files
  run: |
    Get-ChildItem -Recurse -Filter "curl.exe"
    Get-ChildItem artifacts
```

3. Check artifact path is correct in workflow file

---

### Dependencies Installation Fails

**Symptom**: Chocolatey installation errors in GitHub Actions

**Solution**:
The workflow should retry failed installations. If persistent:
1. Check if packages are available on Chocolatey
2. Pin specific package versions in workflow
3. Use alternative installation methods

---

## Performance Issues

### Slow Build Times

**Typical times**:
- Local build: 15-30 minutes
- GitHub Actions: 30-60 minutes

**Optimization tips**:
```powershell
# Use more parallel jobs
ninja -j 8  # Adjust based on CPU cores

# Use SSD for build directory
# Close resource-intensive applications
# Disable real-time antivirus scanning for build directory
```

---

### Slow Runtime Performance

**Solutions**:
```cmd
# Disable verbose output
curl-impersonate-chrome.exe https://example.com -s

# Use HTTP/1.1 instead of HTTP/2 if faster
curl-impersonate-chrome.exe --http1.1 https://example.com

# Enable HTTP/2 multiplexing
curl-impersonate-chrome.exe --http2 https://example.com
```

---

## Getting Help

### Before Asking for Help

1. **Check existing documentation**:
   - [README.md](../README.md)
   - [Build Guide](BUILD.md)
   - [Usage Guide](USAGE.md)

2. **Search existing issues**:
   - [Project Issues](../../issues)
   - [curl-impersonate Issues](https://github.com/lwthiker/curl-impersonate/issues)

3. **Gather information**:
   ```powershell
   # System info
   systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
   
   # Tool versions
   cmake --version
   ninja --version
   git --version
   
   # Build logs
   # Save complete output of failed command
   ```

### How to Report Issues

When creating an issue, include:

1. **Clear description** of the problem
2. **Steps to reproduce**
3. **Expected vs actual behavior**
4. **Environment details**:
   - Windows version
   - Build variant (Chrome/Firefox)
   - Tool versions
5. **Relevant logs** (use code blocks)
6. **What you've tried** already

**Good issue example**:
```
Title: BoringSSL build fails with NASM error on Windows 11

Description:
Building Chrome variant fails during BoringSSL compilation.

Environment:
- Windows 11 Pro 22H2
- cmake 3.27.1
- ninja 1.11.1
- NASM 2.16.01
- Go 1.21.0

Steps to reproduce:
1. Run .\build-local.ps1
2. Build fails at BoringSSL step

Error message:
[paste error here]

What I've tried:
- Reinstalled NASM
- Verified Go installation
- Tried with fresh clone

Expected: Build completes successfully
Actual: Fails with NASM error
```

### Where to Get Help

1. **General questions**: [Discussions](../../discussions)
2. **Bug reports**: [Issues](../../issues)
3. **curl-impersonate questions**: [Original repo](https://github.com/lwthiker/curl-impersonate)
4. **curl questions**: [curl mailing list](https://curl.se/mail/)

### Community Support

- Be patient and respectful
- Provide complete information
- Follow up if you solve your own issue
- Help others when you can

---

## Known Limitations

1. **JavaScript execution**: curl-impersonate cannot execute JavaScript
2. **WebSocket**: Limited WebSocket support
3. **Browser plugins**: Cannot emulate browser plugins
4. **Canvas fingerprinting**: Does not handle canvas-based detection
5. **Cookies**: Manual cookie management required for complex scenarios

---

## Advanced Debugging

### Enable Debug Logging

```cmd
# Full verbose output
curl-impersonate-chrome.exe -v https://example.com 2>&1 | tee debug.log

# Trace resolution
curl-impersonate-chrome.exe --trace-ascii trace.txt https://example.com

# Show timing
curl-impersonate-chrome.exe -w "@curl-format.txt" https://example.com
```

### curl-format.txt example:
```
time_namelookup:  %{time_namelookup}\n
time_connect:  %{time_connect}\n
time_starttransfer:  %{time_starttransfer}\n
time_total:  %{time_total}\n
```

### Network Capture

Use Wireshark or Fiddler to compare:
- Real browser traffic
- curl-impersonate traffic
- Regular curl traffic

This can help identify what's different and being detected.

---

## Still Having Issues?

If this guide didn't solve your problem:
1. Create a [new issue](../../issues/new)
2. Include all relevant information
3. Be patient - this is a community project
4. Consider sponsoring development if you need priority support
