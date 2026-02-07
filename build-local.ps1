# Local build script for curl-impersonate on Windows
# This script automates the local build process

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('chrome', 'firefox', 'both')]
    [string]$Variant = 'both',
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipDependencies = $false
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "curl-impersonate Local Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for administrator privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "WARNING: This script should be run as Administrator for best results." -ForegroundColor Yellow
    Write-Host "Some dependencies may fail to install without admin privileges." -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne 'y') {
        exit 1
    }
}

# Function to check if a command exists
function Test-Command {
    param($CommandName)
    $null -ne (Get-Command $CommandName -ErrorAction SilentlyContinue)
}

# Install Chocolatey if not present
if (-not $SkipDependencies) {
    if (-not (Test-Command choco)) {
        Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # Refresh environment
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    }

    Write-Host "Installing build dependencies..." -ForegroundColor Yellow
    choco install nasm strawberryperl cmake ninja golang git -y --no-progress
    
    # Update PATH
    $env:Path = "C:\Program Files\NASM;" + $env:Path
    $env:Path = "C:\Strawberry\perl\bin;" + $env:Path
    $env:Path = "C:\Program Files\Go\bin;" + $env:Path
    $env:Path = "C:\Program Files\CMake\bin;" + $env:Path
}

# Verify required tools
Write-Host "Verifying build tools..." -ForegroundColor Yellow
$requiredTools = @('git', 'cmake', 'ninja', 'go', 'perl', 'nasm')
$missingTools = @()

foreach ($tool in $requiredTools) {
    if (-not (Test-Command $tool)) {
        $missingTools += $tool
    }
}

if ($missingTools.Count -gt 0) {
    Write-Host "ERROR: Missing required tools: $($missingTools -join ', ')" -ForegroundColor Red
    Write-Host "Please install missing tools and try again." -ForegroundColor Red
    exit 1
}

Write-Host "All required tools are available!" -ForegroundColor Green

# Create build directory
$buildDir = Join-Path $PSScriptRoot "build"
if (Test-Path $buildDir) {
    Write-Host "Cleaning existing build directory..." -ForegroundColor Yellow
    Remove-Item $buildDir -Recurse -Force
}
New-Item -ItemType Directory -Path $buildDir | Out-Null

Push-Location $buildDir

try {
    # Clone curl-impersonate
    Write-Host ""
    Write-Host "Cloning curl-impersonate repository..." -ForegroundColor Yellow
    git clone --depth 1 https://github.com/lwthiker/curl-impersonate.git
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to clone curl-impersonate repository"
    }
    
    Set-Location curl-impersonate
    
    Write-Host "Initializing submodules..." -ForegroundColor Yellow
    git submodule update --init --depth 1
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to initialize submodules"
    }

    # Build Chrome variant
    if ($Variant -eq 'chrome' -or $Variant -eq 'both') {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "Building Chrome variant (BoringSSL)" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        
        # Build BoringSSL
        Write-Host "Building BoringSSL..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path "build-boringssl" -Force | Out-Null
        Set-Location build-boringssl
        
        $boringsslPath = "..\boringssl"
        if (-not (Test-Path $boringsslPath)) {
            $boringsslPath = "..\curl-impersonate\boringssl"
        }
        
        cmake -GNinja -DCMAKE_BUILD_TYPE=Release $boringsslPath
        ninja crypto ssl
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to build BoringSSL"
        }
        
        Set-Location ..
        
        # Build nghttp2
        Write-Host "Building nghttp2..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path "build-nghttp2" -Force | Out-Null
        Set-Location build-nghttp2
        
        cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_LIB_ONLY=ON -DENABLE_STATIC_LIB=ON ..\nghttp2
        ninja
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to build nghttp2"
        }
        
        Set-Location ..
        
        # Build curl
        Write-Host "Building curl with impersonation patches..." -ForegroundColor Yellow
        Set-Location curl
        
        if (Test-Path "buildconf.bat") {
            & .\buildconf.bat
        }
        
        New-Item -ItemType Directory -Path "build" -Force | Out-Null
        Set-Location build
        
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
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to build curl"
        }
        
        Set-Location ..\..
        
        Write-Host "Chrome variant built successfully!" -ForegroundColor Green
    }
    
    # Collect artifacts
    Write-Host ""
    Write-Host "Collecting build artifacts..." -ForegroundColor Yellow
    $artifactsDir = Join-Path $buildDir "artifacts"
    New-Item -ItemType Directory -Path $artifactsDir -Force | Out-Null
    
    # Find and copy curl executables
    Get-ChildItem -Path . -Recurse -Filter "curl.exe" -ErrorAction SilentlyContinue | ForEach-Object {
        $destName = "curl-impersonate-chrome.exe"
        Copy-Item $_.FullName -Destination (Join-Path $artifactsDir $destName)
        Write-Host "Copied: $($_.FullName) -> $destName" -ForegroundColor Green
    }
    
    # Find and copy DLLs
    Get-ChildItem -Path . -Recurse -Filter "*.dll" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item $_.FullName -Destination $artifactsDir -ErrorAction SilentlyContinue
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Build Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Artifacts location: $artifactsDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Built files:" -ForegroundColor Yellow
    Get-ChildItem $artifactsDir | ForEach-Object {
        Write-Host "  - $($_.Name)" -ForegroundColor Cyan
    }
    
} catch {
    Write-Host ""
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    Pop-Location
    exit 1
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "Build script completed successfully!" -ForegroundColor Green
