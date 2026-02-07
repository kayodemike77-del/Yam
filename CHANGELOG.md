# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup with GitHub Actions workflow for building curl-impersonate on Windows
- Comprehensive README.md with project overview and quick start guide
- Local build script (build-local.ps1) for building curl-impersonate on Windows locally
- Detailed documentation in /docs:
  - BUILD.md - Complete build instructions for both GitHub Actions and local builds
  - USAGE.md - Usage examples and best practices
  - TROUBLESHOOTING.md - Common issues and solutions
  - README.md - Documentation index
- CONTRIBUTING.md with contribution guidelines
- LICENSE file (MIT License)
- .gitignore to exclude build artifacts and temporary files

### Features
- Two build variants:
  - Chrome variant with BoringSSL
  - Firefox variant with MSYS2/MinGW
- Automated dependency installation
- Artifact collection and upload
- Manual workflow trigger for on-demand builds

## [1.0.0] - 2026-02-07

### Initial Release
- GitHub Actions workflow for building curl-impersonate for Windows
- Support for Chrome and Firefox variants
- Automated builds with artifact uploads

---

[Unreleased]: https://github.com/kayodemike77-del/Yam/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/kayodemike77-del/Yam/releases/tag/v1.0.0
