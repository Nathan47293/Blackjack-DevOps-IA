# Contributing to Blackjack DevOps Project

Thank you for your interest in contributing to this project! This guide will help you get started.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct. Please report unacceptable behavior to [conduct@yourcompany.com].

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you are creating a bug report, please include as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps to reproduce the problem
- Provide specific examples to demonstrate the steps
- Describe the behavior you observed and what behavior you expected
- Include screenshots if applicable
- Include system information (OS, Python version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- Use a clear and descriptive title
- Provide a detailed description of the suggested enhancement
- Explain why this enhancement would be useful
- Include mockups or examples if applicable

### Pull Requests

1. Fork the repo and create your branch from `main`
2. If you've added code that should be tested, add tests
3. Ensure the test suite passes
4. Make sure your code lints
5. Update documentation as needed
6. Issue the pull request

## Development Process

### Setting Up Development Environment

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Blackjack-DevOps-IA
   ```

2. **Set up Python environment**
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. **Install development dependencies**
   ```bash
   pip install pytest pytest-cov bandit safety
   ```

### Running Tests

```bash
# Run all tests
make test

# Run specific test categories
pytest tests/test_blackjack.py::TestCard -v

# Run with coverage
pytest --cov=. --cov-report=html
```

### Code Style

- Follow PEP 8 style guide
- Use meaningful variable and function names
- Add docstrings to functions and classes
- Keep functions small and focused

### Security

- Run security checks before submitting:
  ```bash
  bandit -r .
  safety check
  ```
- Never commit secrets or sensitive data
- Use environment variables for configuration

## Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write tests for new functionality
   - Ensure existing tests pass
   - Update documentation

3. **Test your changes**
   ```bash
   make test
   make lint
   ```

4. **Commit your changes**
   ```bash
   git commit -m "feat: add your feature description"
   ```
   
   Use conventional commit format:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation
   - `test:` for tests
   - `refactor:` for code refactoring

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Use a clear title and description
   - Reference any related issues
   - Include screenshots for UI changes

## Review Process

1. **Automated Checks**: CI/CD pipeline runs tests and security scans
2. **Code Review**: Maintainers review code for quality and style
3. **Testing**: Changes are tested in development environment
4. **Merge**: Approved changes are merged to main branch

## Commit Guidelines

### Commit Message Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect code meaning
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvements
- `test`: Adding missing tests
- `chore`: Changes to build process or auxiliary tools

### Examples
```
feat(api): add new game statistics endpoint

fix(game): resolve ace value calculation bug

docs(readme): update deployment instructions

test(card): add tests for face card values
```

## Documentation

- Update README.md for significant changes
- Add inline comments for complex logic
- Update API documentation for endpoint changes
- Include examples in documentation

## Questions?

If you have questions about contributing, please:
- Check existing documentation
- Search through issues
- Create a new issue with the `question` label
- Contact maintainers

Thank you for contributing to this project!