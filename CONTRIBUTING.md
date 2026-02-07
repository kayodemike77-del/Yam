# Contributing to Yam

Thank you for your interest in contributing to the Yam project! This document provides guidelines and instructions for contributing.

## How to Contribute

### Reporting Issues

If you encounter any problems with the build process or have suggestions:

1. Check if the issue already exists in the [Issues](../../issues) section
2. If not, create a new issue with:
   - A clear, descriptive title
   - Detailed description of the problem or suggestion
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment details (Windows version, build variant, etc.)
   - Relevant logs or error messages

### Improving the Build Process

We welcome contributions to improve the build automation:

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/Yam.git
   cd Yam
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**
   - Follow the existing code style
   - Test your changes thoroughly
   - Update documentation as needed

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your fork and branch
   - Provide a clear description of your changes

### Areas for Contribution

We particularly welcome contributions in these areas:

- **Build optimization**: Making the build process faster or more efficient
- **Additional variants**: Adding support for more browser types or versions
- **Cross-platform support**: Extending support to other operating systems
- **Documentation**: Improving guides, adding examples, fixing typos
- **Testing**: Adding automated tests for the build process
- **Error handling**: Improving error messages and recovery

### Code Style Guidelines

- **PowerShell scripts**: 
  - Use 4 spaces for indentation
  - Include comments for complex logic
  - Use meaningful variable names
  - Follow PowerShell best practices

- **GitHub Actions workflows**:
  - Use clear step names
  - Add comments for non-obvious steps
  - Keep jobs focused and modular
  - Include error handling

- **Documentation**:
  - Use clear, concise language
  - Include code examples where appropriate
  - Keep formatting consistent with existing docs

### Testing Your Changes

Before submitting a pull request:

1. **Test the GitHub Actions workflow**:
   - Push your changes to your fork
   - Manually trigger the workflow
   - Verify it completes successfully
   - Check the artifacts are generated correctly

2. **Test local build script** (if modified):
   - Run the script on a clean Windows environment
   - Test with different parameters
   - Verify error handling works correctly

3. **Test documentation**:
   - Ensure all links work
   - Check formatting renders correctly
   - Verify instructions are accurate

### Pull Request Process

1. Update the README.md with details of changes if applicable
2. Update the CHANGELOG.md (if present) with notable changes
3. Ensure your PR description clearly describes the problem and solution
4. Link any related issues
5. Wait for review and address any feedback

### Code of Conduct

- Be respectful and constructive
- Welcome newcomers and help them learn
- Focus on what is best for the project
- Show empathy towards other community members

### Questions?

If you have questions about contributing:

- Open a [Discussion](../../discussions) for general questions
- Create an [Issue](../../issues) for specific problems
- Check existing documentation and closed issues first

## Recognition

Contributors will be recognized in:
- The project's README (for significant contributions)
- Release notes
- The contributors page

Thank you for helping make Yam better!
