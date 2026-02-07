# Usage Guide

This guide explains how to use curl-impersonate after building or downloading it.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Impersonation Options](#impersonation-options)
- [Common Use Cases](#common-use-cases)
- [Advanced Features](#advanced-features)
- [Comparison with Regular curl](#comparison-with-regular-curl)

## Basic Usage

### Simple GET Request

```cmd
curl-impersonate-chrome.exe https://example.com
```

### Save Output to File

```cmd
curl-impersonate-chrome.exe https://example.com -o output.html
```

### View Headers Only

```cmd
curl-impersonate-chrome.exe -I https://example.com
```

### Verbose Output (Debug)

```cmd
curl-impersonate-chrome.exe -v https://example.com
```

## Impersonation Options

### Chrome Variants

Impersonate specific Chrome versions:

```cmd
# Latest Chrome (default)
curl-impersonate-chrome.exe https://example.com

# Chrome 110
curl-impersonate-chrome.exe --impersonate chrome110 https://example.com

# Chrome 107
curl-impersonate-chrome.exe --impersonate chrome107 https://example.com

# Chrome 104
curl-impersonate-chrome.exe --impersonate chrome104 https://example.com
```

### Firefox Variants

Impersonate specific Firefox versions (if using Firefox variant):

```cmd
# Latest Firefox (default)
curl-impersonate-firefox.exe https://example.com

# Firefox 109
curl-impersonate-firefox.exe --impersonate firefox109 https://example.com

# Firefox 102
curl-impersonate-firefox.exe --impersonate firefox102 https://example.com
```

### Edge Variants

```cmd
curl-impersonate-chrome.exe --impersonate edge101 https://example.com
```

### Safari Variants

```cmd
curl-impersonate-chrome.exe --impersonate safari15_5 https://example.com
```

## Common Use Cases

### Web Scraping

```cmd
# Scrape a page that blocks curl
curl-impersonate-chrome.exe https://website.com -o page.html

# Scrape with custom user agent (in addition to impersonation)
curl-impersonate-chrome.exe -H "User-Agent: Custom UA" https://website.com
```

### API Testing

```cmd
# Test API endpoint as if from a browser
curl-impersonate-chrome.exe https://api.example.com/endpoint

# POST request with JSON data
curl-impersonate-chrome.exe -X POST https://api.example.com/endpoint ^
  -H "Content-Type: application/json" ^
  -d "{\"key\":\"value\"}"
```

### Download Files

```cmd
# Download file with browser-like behavior
curl-impersonate-chrome.exe https://example.com/file.zip -o file.zip

# Download with progress bar
curl-impersonate-chrome.exe https://example.com/large-file.zip -o file.zip --progress-bar
```

### Session Management

```cmd
# Save cookies
curl-impersonate-chrome.exe https://example.com -c cookies.txt

# Use saved cookies
curl-impersonate-chrome.exe https://example.com -b cookies.txt

# Follow redirects
curl-impersonate-chrome.exe -L https://example.com
```

## Advanced Features

### Custom Headers

```cmd
# Add custom headers
curl-impersonate-chrome.exe https://example.com ^
  -H "Accept-Language: en-US,en;q=0.9" ^
  -H "Referer: https://google.com"
```

### Proxy Support

```cmd
# Use HTTP proxy
curl-impersonate-chrome.exe --proxy http://proxy.example.com:8080 https://example.com

# Use SOCKS5 proxy
curl-impersonate-chrome.exe --proxy socks5://proxy.example.com:1080 https://example.com

# Proxy with authentication
curl-impersonate-chrome.exe --proxy http://user:pass@proxy.example.com:8080 https://example.com
```

### SSL/TLS Options

```cmd
# Ignore SSL certificate errors (use with caution!)
curl-impersonate-chrome.exe -k https://self-signed.example.com

# Use specific TLS version
curl-impersonate-chrome.exe --tlsv1.2 https://example.com

# View SSL certificate info
curl-impersonate-chrome.exe -v https://example.com 2>&1 | findstr /C:"SSL"
```

### Rate Limiting

```cmd
# Limit download speed
curl-impersonate-chrome.exe --limit-rate 100K https://example.com/file.zip -o file.zip

# Set connection timeout
curl-impersonate-chrome.exe --connect-timeout 10 https://example.com
```

### Multiple Requests

```cmd
# Download multiple files
curl-impersonate-chrome.exe https://example.com/file[1-5].zip -o "file#1.zip"

# Use URL list from file
curl-impersonate-chrome.exe -K urls.txt
```

### Authentication

```cmd
# Basic authentication
curl-impersonate-chrome.exe -u username:password https://example.com

# OAuth or Bearer token
curl-impersonate-chrome.exe -H "Authorization: Bearer YOUR_TOKEN" https://api.example.com
```

## Comparison with Regular curl

### What's Different?

| Feature | Regular curl | curl-impersonate |
|---------|-------------|------------------|
| TLS Fingerprint | Generic curl | Browser-specific |
| HTTP/2 Settings | Standard | Browser-matched |
| Header Order | Standard | Browser-matched |
| Cipher Suites | OpenSSL default | Browser-matched |
| Detection Rate | High | Very Low |

### When to Use curl-impersonate

✅ **Use curl-impersonate when:**
- Website blocks standard curl requests
- Need to bypass bot detection
- Testing browser-specific behavior
- Scraping sites with strict client checks
- Need realistic browser fingerprinting

❌ **Use regular curl when:**
- Simple API calls that don't check client
- Internal/trusted services
- Performance is critical (curl-impersonate has slight overhead)
- You don't need browser impersonation

## PowerShell Integration

### Basic Script

```powershell
# PowerShell script using curl-impersonate
$url = "https://example.com"
$output = "output.html"

& curl-impersonate-chrome.exe $url -o $output

if ($LASTEXITCODE -eq 0) {
    Write-Host "Download successful: $output"
} else {
    Write-Host "Download failed with code: $LASTEXITCODE"
}
```

### Loop Through URLs

```powershell
$urls = @(
    "https://example.com/page1",
    "https://example.com/page2",
    "https://example.com/page3"
)

foreach ($url in $urls) {
    $filename = [System.IO.Path]::GetFileName($url) + ".html"
    Write-Host "Downloading: $url"
    & curl-impersonate-chrome.exe $url -o $filename
}
```

### Error Handling

```powershell
try {
    & curl-impersonate-chrome.exe https://example.com -o output.html -f
    if ($LASTEXITCODE -ne 0) {
        throw "curl failed with exit code: $LASTEXITCODE"
    }
    Write-Host "Success!"
} catch {
    Write-Error "Error: $_"
}
```

## Batch Script Examples

### Simple Batch Script

```batch
@echo off
REM Download a file using curl-impersonate

set URL=https://example.com
set OUTPUT=output.html

curl-impersonate-chrome.exe %URL% -o %OUTPUT%

if %ERRORLEVEL% EQU 0 (
    echo Download successful
) else (
    echo Download failed
)
```

### Multiple URLs

```batch
@echo off
REM Download multiple URLs

for %%U in (
    https://example.com/page1
    https://example.com/page2
    https://example.com/page3
) do (
    echo Downloading %%U
    curl-impersonate-chrome.exe %%U -o %%~nxU.html
)
```

## Best Practices

1. **Choose the Right Variant**: Use Chrome for most cases, Firefox for sites that work better with Firefox

2. **Respect robots.txt**: Even with impersonation, follow website guidelines

3. **Rate Limiting**: Add delays between requests to avoid overloading servers
   ```cmd
   curl-impersonate-chrome.exe https://example.com && timeout /t 5
   ```

4. **Error Handling**: Always check exit codes and handle failures

5. **Keep Updated**: Regularly update curl-impersonate to get latest browser fingerprints

6. **Use Appropriate Headers**: While impersonation handles most headers, add context-specific ones when needed

7. **Test First**: Always test on a small scale before running large scraping jobs

8. **Legal Compliance**: Ensure your use case complies with the website's terms of service and applicable laws

## Troubleshooting Usage

### Issue: Connection Refused

```cmd
# Try with verbose output
curl-impersonate-chrome.exe -v https://example.com

# Check if regular curl works
curl https://example.com
```

### Issue: SSL Errors

```cmd
# Update CA certificates
curl-impersonate-chrome.exe --cacert path\to\cacert.pem https://example.com
```

### Issue: Still Getting Blocked

- Try a different browser variant: `--impersonate firefox109`
- Add more browser-like headers
- Use with legitimate cookies from a browser session
- Check if website has other blocking mechanisms (IP-based, rate-based)

## Further Reading

- [curl Documentation](https://curl.se/docs/)
- [curl-impersonate GitHub](https://github.com/lwthiker/curl-impersonate)
- [Build Guide](BUILD.md) - How to build curl-impersonate
- [Troubleshooting Guide](TROUBLESHOOTING.md) - Common issues and solutions
