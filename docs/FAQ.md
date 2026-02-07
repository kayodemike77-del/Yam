# Frequently Asked Questions (FAQ)

## Build and Download Questions

### Q: How long does the build take?

**A:** Each build variant (Firefox and Chrome) takes approximately **30-60 minutes**. The workflow runs both variants in parallel, so:
- Total wall clock time: 30-60 minutes
- You can download artifacts as soon as each variant completes
- Don't worry if you see the workflow "in progress" for a while - this is normal!

### Q: I triggered a build but don't see any artifacts. What's wrong?

**A:** Check the following:

1. **Is the build still running?**
   - Look for the yellow/orange circle icon (⚠️) next to the workflow run
   - This means it's still in progress - be patient!

2. **Did the build fail?**
   - Look for a red X (❌) next to the workflow run
   - Click on the failed run to see error logs
   - Common causes: upstream repository issues, temporary network problems
   - Solution: Try running the workflow again

3. **Did you scroll down?**
   - Artifacts appear at the **bottom** of the workflow run page
   - You need to scroll past all the job logs

4. **Did the build just finish?**
   - Refresh the page (F5) if you had it open during the build
   - Artifacts should appear within a few seconds of completion

### Q: The build failed. What should I do?

**A:** First, try running it again:
1. Go to the failed workflow run
2. Click "Re-run failed jobs" or "Re-run all jobs"
3. Wait for it to complete

If it fails repeatedly:
1. Check if there are any GitHub status issues
2. Open an issue in this repository with the error logs
3. As a last resort, try building locally with MSYS2

### Q: Can I download artifacts from someone else's build?

**A:** No, GitHub Actions artifacts are only available to:
- The person who triggered the workflow
- Repository collaborators
- People with appropriate access to the repository

If you can't access artifacts, trigger your own build!

### Q: How do I know which variant (Firefox or Chrome) to use?

**A:**

**Use Firefox variant when:**
- The website works better with Firefox
- You want NSS-based TLS (Mozilla's SSL library)
- You're testing Firefox-specific behavior
- curl_ff*.exe executables

**Use Chrome variant when:**
- The website works better with Chrome/Chromium browsers
- You want BoringSSL-based TLS (Google's SSL library)
- You need Chrome, Edge, or Safari impersonation
- curl_chrome*.exe, curl_edge*.exe, curl_safari*.exe executables

**Try both** if one doesn't work - different sites may check for different browsers!

### Q: The executables in the artifact don't have a `.exe` extension. What should I do?

**A:** The curl-impersonate build process creates wrapper scripts (without .exe) and actual executables (with .exe). When you download and extract the artifacts:

1. **Look for files with `.exe` extension** - these are the actual Windows executables
2. **Files without `.exe`** are usually shell scripts - you can ignore them on Windows

If you only see files without `.exe` extension:
1. The build may not have completed correctly
2. Try re-running the workflow
3. Check the build logs for errors

**Important:** On Windows, you must use the `.exe` files. The shell scripts won't work in Command Prompt or PowerShell.

### Q: Do I need to download both artifacts?

**A:** No! Download only what you need:
- If you only need Firefox impersonation → download `curl-impersonate-firefox-windows.zip`
- If you only need Chrome/Edge/Safari → download `curl-impersonate-chrome-windows.zip`
- If you want all variants → download both

## Usage Questions

### Q: How do I use the downloaded executables?

**A:** Simple! Just extract the ZIP and run the exe file:

```cmd
# Example with Firefox variant
curl_ff109.exe https://example.com

# Example with Chrome variant
curl_chrome116.exe https://example.com
```

No installation required - they're standalone executables.

### Q: Which browser version should I use?

**A:** Generally, use the **newest version** available (e.g., curl_chrome116.exe or curl_ff109.exe) as they have the latest TLS and HTTP/2 fingerprints.

Use older versions only if:
- The website specifically detects newer browsers
- You're testing against a specific browser version
- The newer version doesn't work for your use case

### Q: Can these executables detect JavaScript or run JavaScript code?

**A:** **No.** curl-impersonate only mimics the TLS and HTTP/2 handshake of browsers. It cannot:
- Execute JavaScript
- Render HTML/CSS
- Handle dynamic content loaded by JavaScript
- Interact with WebSocket connections (beyond basic support)

For JavaScript-heavy sites, you need a full browser automation tool like Puppeteer or Playwright.

### Q: The website still detects me / blocks me. Why?

**A:** curl-impersonate only handles TLS and HTTP/2 fingerprinting. Websites may also use:

1. **JavaScript challenges** - curl can't execute JavaScript
2. **IP-based blocking** - use a proxy/VPN
3. **Rate limiting** - add delays between requests
4. **Cookie/session tracking** - use cookies from a real browser session
5. **Behavioral analysis** - vary your request patterns
6. **CAPTCHA** - you'll need to solve these separately

curl-impersonate is a powerful tool but not a complete anti-detection solution.

### Q: Can I use this with Python/Node.js/other languages?

**A:** Yes! You can call the executables from any programming language using subprocess/exec commands:

**Python example:**
```python
import subprocess
result = subprocess.run(['curl_chrome116.exe', 'https://example.com'], 
                       capture_output=True, text=True)
print(result.stdout)
```

**Node.js example:**
```javascript
const { execSync } = require('child_process');
const output = execSync('curl_chrome116.exe https://example.com');
console.log(output.toString());
```

## Technical Questions

### Q: Why does the build use MSYS2 instead of native Windows builds?

**A:** curl-impersonate was developed for Linux and uses:
- autotools (configure/make) build system
- Unix-style compilation
- Linux-specific libraries and tools

MSYS2 provides a Unix-like environment on Windows, allowing the official build process to work without significant modifications.

Native Windows builds would require:
- Rewriting the entire build system
- Porting all dependencies
- Extensive testing and maintenance

Using MSYS2 ensures we get builds that work and are closest to the official Linux versions.

### Q: Why aren't the Windows builds officially supported by curl-impersonate?

**A:** The curl-impersonate project focuses on Linux builds because:
- Most servers and automation tools run on Linux
- Windows introduces additional complexity
- The maintainer primarily develops for Linux

This repository (Yam) provides a community solution for Windows users using MSYS2.

### Q: Are these builds safe to use?

**A:** The builds are created by:
1. Cloning the official curl-impersonate repository
2. Building using the official build instructions
3. Running in GitHub's infrastructure (not on personal machines)
4. Using well-known, trusted tools (MSYS2, MinGW, GCC)

You can review the [workflow file](../.github/workflows/build-curl-impersonate.yml) to see exactly what happens during the build. Everything is transparent and open source.

### Q: Can I see the build logs?

**A:** Yes! Click on any workflow run and expand the job steps to see detailed logs of:
- What packages were installed
- How the build progressed
- What files were created
- Any errors or warnings

## Contributing

### Q: I found a bug / have a suggestion. What should I do?

**A:** Please open an issue in this repository with:
- Clear description of the problem/suggestion
- Steps to reproduce (for bugs)
- Your environment details (Windows version, etc.)
- Any relevant error messages or logs

### Q: Can I contribute to this project?

**A:** Absolutely! See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines. We especially welcome:
- Build improvements and optimizations
- Better documentation
- Testing on different Windows versions
- Fixing bugs

### Q: How can I support this project?

**A:** You can help by:
- ⭐ Star the repository
- 📢 Share it with others who might need it
- 🐛 Report bugs and issues
- 📝 Improve documentation
- 💡 Suggest improvements
- 🧪 Test builds and provide feedback

---

**Still have questions?** [Open an issue](../../issues/new) and we'll help!
