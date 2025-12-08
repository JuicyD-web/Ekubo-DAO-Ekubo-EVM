# Contributing to Ekubo Protocol EVM

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Important Legal Notice

⚠️ **This is a derivative work licensed under the Ekubo DAO Shared Revenue License 1.0.**

By contributing, you acknowledge:
- Your contributions become part of this derivative work
- All contributions are subject to the revenue-sharing obligations
- You have read and understood DERIVATIVE_COMPLIANCE.md

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Report unacceptable behavior to [aksels.laivenieks@outlook.com]

## How to Contribute

### Reporting Bugs

**Before submitting:**
1. Check existing issues
2. Verify it's reproducible
3. Collect relevant information

**Bug Report Template:**
```
**Description**: Clear description of the bug

**Steps to Reproduce**:
1. Step one
2. Step two
3. ...

**Expected Behavior**: What should happen

**Actual Behavior**: What actually happens

**Environment**:
- Solidity version:
- Foundry version:
- Network:

**Additional Context**: Logs, screenshots, etc.
```

### Suggesting Features

1. Open an issue with `[Feature]` prefix
2. Describe the problem it solves
3. Propose implementation approach
4. Discuss with maintainers before coding

### Submitting Pull Requests

#### Before You Start

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Review existing code style
4. Set up development environment (see DEVELOPMENT.md)

#### Development Process

```bash
# Install dependencies
forge install

# Run tests
forge test

# Run with verbosity
forge test -vvv

# Check gas usage
forge test --gas-report

# Format code
forge fmt

# Static analysis
slither .
```

#### PR Requirements

Your PR must include:

✅ **Code Quality**
- [ ] Follows existing code style
- [ ] Includes inline comments for complex logic
- [ ] No compiler warnings
- [ ] Gas-optimized where appropriate

✅ **Testing**
- [ ] Unit tests for new functionality
- [ ] Tests pass: `forge test`
- [ ] Gas benchmarks if applicable
- [ ] Edge cases covered

✅ **Documentation**
- [ ] NatSpec comments for public functions
- [ ] README updated if needed
- [ ] CHANGELOG.md updated

✅ **Security**
- [ ] No obvious vulnerabilities
- [ ] Follows Solidity best practices
- [ ] Considers reentrancy, overflow, etc.

#### PR Template

```markdown
## Description
[Clear description of changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] All tests pass
- [ ] New tests added
- [ ] Gas impact assessed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] CHANGELOG.md updated

## Related Issues
Closes #[issue number]
```

## Development Guidelines

### Solidity Style Guide

- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Use 4 spaces for indentation (not tabs)
- Maximum line length: 120 characters
- Use descriptive variable names
- Prefer explicit over implicit

### Code Organization

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Imports organized: external, then internal
import {ExternalContract} from "external/path";
import {InternalContract} from "./InternalContract.sol";

/// @title Contract Title
/// @author Author Name
/// @notice Explanation for end users
/// @dev Technical details for developers
contract ContractName {
    // State variables: public, then private
    
    // Events
    
    // Errors
    
    // Modifiers
    
    // Constructor
    
    // External functions
    
    // Public functions
    
    // Internal functions
    
    // Private functions
}
```

### Testing Standards

```solidity
// Test file structure
contract ContractNameTest is Test {
    // Setup
    function setUp() public { }
    
    // Happy path tests
    function test_FunctionName_Success() public { }
    
    // Edge cases
    function test_FunctionName_EdgeCase() public { }
    
    // Failure cases
    function testFail_FunctionName_Reverts() public { }
    function test_FunctionName_RevertsIf() public {
        vm.expectRevert(ErrorSelector);
        // call
    }
    
    // Fuzz tests
    function testFuzz_FunctionName(uint256 x) public { }
}
```

### Security Practices

1. **Always consider:**
   - Reentrancy attacks
   - Integer overflow/underflow
   - Access control
   - Front-running
   - Flash loan attacks

2. **Use secure patterns:**
   - Checks-Effects-Interactions
   - Pull over push
   - Rate limiting where appropriate

3. **Review checklist:**
   - [ ] No `tx.origin` usage
   - [ ] Proper access controls
   - [ ] Safe external calls
   - [ ] Validated inputs
   - [ ] Protected against reentrancy

## Review Process

1. **Automated Checks**: CI runs tests, linters, static analysis
2. **Code Review**: Maintainer reviews code quality and logic
3. **Security Review**: Security-focused review for sensitive changes
4. **Approval**: At least one maintainer approval required
5. **Merge**: Squash and merge to main

## Recognition

Significant contributions will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Recognized in project communications

## Questions?

- Open an issue with `[Question]` prefix
- Join discussions in existing issues
- Contact maintainers: [aksels.laivenieks@outlook.com or open an issue at https://github.com/Ekubo-DAO/Ekubo-EVM/issues]

---

**Thank you for contributing to Ekubo Protocol EVM!**

**Last Updated:** November 29, 2025