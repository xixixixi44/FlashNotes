# Contributing to FlashNotes

Thank you for your interest in contributing to FlashNotes! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

Please be respectful and considerate of others when contributing to this project.

## Development Workflow

### 1. Find or Create an Issue

All work should be tracked through GitHub issues:

- Search for existing issues that you'd like to work on
- If none exists, create a new issue describing the bug or feature

### 2. Branching Strategy

We use the following branch naming convention:

- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/XXX` - For new features (where XXX is the issue number or short description)
- `bugfix/XXX` - For bug fixes
- `release/X.X.X` - For preparing new releases

### 3. Development Process

1. Fork the repository (if you're not a maintainer)
2. Create a new branch from `develop`
3. Commit your changes with clear, descriptive commit messages
4. Write or update tests as necessary
5. Update documentation if needed

### 4. Commit Message Guidelines

We follow a simplified version of the Conventional Commits standard:

- `feat: add new feature X`
- `fix: resolve issue with Y`
- `docs: update README with new information`
- `test: add tests for feature Z`
- `refactor: improve code structure`

### 5. Pull Request Process

1. Create a Pull Request (PR) to the `develop` branch
2. Fill out the PR template with all required information
3. Request a code review from at least one maintainer
4. Address any feedback from code reviews
5. Once approved, a maintainer will merge your PR

### 6. Testing

- All new features should include appropriate unit tests
- All bug fixes should include a test that verifies the bug is fixed
- Run the test suite locally before submitting your PR

## Development Environment Setup

1. Ensure you have the following installed:
   - Xcode 14.0+
   - macOS 12.0+
   - Git

2. Clone the repository
   ```bash
   git clone https://github.com/xixixixi44/FlashNotes.git
   cd FlashNotes
   ```

3. Open the project in Xcode
   ```bash
   open FlashNotes.xcodeproj
   ```

## Coding Standards

- Follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use Swift's built-in formatting where possible
- Comment your code where necessary, especially for complex logic
- Write self-documenting code with clear variable and function names

## Versioning

We use Semantic Versioning (SemVer):

- MAJOR version for incompatible API changes
- MINOR version for backward-compatible functionality additions
- PATCH version for backward-compatible bug fixes

## Questions?

If you have any questions about contributing, please open an issue for discussion.
