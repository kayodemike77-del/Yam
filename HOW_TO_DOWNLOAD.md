# How to Download Your curl-impersonate Artifacts

## 🎯 Quick Answer

Your build will take **30-60 minutes**. Here's how to download the artifacts when it's done:

### Step 1: Go to the Workflow Run

1. Visit: https://github.com/kayodemike77-del/Yam/actions/workflows/build-curl-impersonate.yml
2. Click on your workflow run (look for the one with a green ✅ checkmark)

### Step 2: Find the Artifacts

1. **Scroll all the way down** to the bottom of the page
2. Look for a section titled **"Artifacts"**
3. You'll see two ZIP files:
   - `curl-impersonate-firefox-windows` (Firefox variants)
   - `curl-impersonate-chrome-windows` (Chrome/Edge/Safari variants)

### Step 3: Download and Extract

1. Click on the artifact name to download the ZIP file
2. Extract the ZIP file to a folder on your computer
3. You'll find multiple `.exe` files inside

### Step 4: Use Them!

```cmd
# Example: Use Chrome 116
curl_chrome116.exe https://httpbin.org/get

# Example: Use Firefox 109
curl_ff109.exe https://httpbin.org/get

# Save to file
curl_chrome116.exe https://example.com -o page.html
```

## 📝 What's Included

### Firefox Artifact (`curl-impersonate-firefox-windows.zip`)
- `curl_ff109.exe` - Firefox 109
- `curl_ff102.exe` - Firefox 102
- `curl_ff100.exe` - Firefox 100
- `curl_ff98.exe` - Firefox 98
- `curl_ff95.exe` - Firefox 95
- `curl_ff91esr.exe` - Firefox 91 ESR

### Chrome Artifact (`curl-impersonate-chrome-windows.zip`)
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

## ⚠️ Common Issues

### "I don't see the Artifacts section!"

**Possible reasons:**
1. **Build is still running** - Look for a yellow/orange circle icon (⚠️). Wait for it to finish!
2. **Build failed** - Look for a red X (❌). Click on it to see errors, then try running again
3. **Wrong page** - Make sure you clicked on the actual workflow RUN, not just the workflow name
4. **Need to scroll** - The Artifacts section is at the BOTTOM of the page

### "Build is taking forever!"

**This is normal!** Each variant takes 30-60 minutes. You can:
- Close the tab and check back later
- Watch the progress in real-time (optional)
- Both builds run in parallel, so total time is still just 30-60 minutes

### "Build failed!"

Try these steps:
1. Click "Re-run all jobs" button
2. Wait for it to complete
3. If it fails again, check the error logs
4. Open an issue if you need help

## 🚀 You're All Set!

The workflow is now fixed and ready to use. Just trigger a build and wait patiently!

For more details, see:
- [FAQ](docs/FAQ.md) - Common questions
- [QUICKSTART](QUICKSTART.md) - Quick start guide  
- [BUILD_STATUS](BUILD_STATUS.md) - What was fixed

Happy impersonating! 🎭
