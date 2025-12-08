# Contributing to Ekubo Protocol EVM

Thank you for your interest in contributing to the Ekubo Protocol!

## ⚠️ Important Notice

This is a **licensed repository** under the Ekubo DAO Shared Revenue License 1.0. All contributions:
- Do not grant you ownership rights
- Do not reduce revenue sharing obligations
- Are subject to the same license terms
- Must comply with all license requirements

By contributing, you agree to these terms.

---

## 🤝 How to Contribute

### 1. Types of Contributions

We welcome:
- 🐛 Bug reports
- 💡 Feature suggestions
- 📝 Documentation improvements
- 🧪 Test additions
- 🔧 Bug fixes
- ⚡ Performance optimizations

### 2. Before Contributing

- Review the [LICENSE](./LICENSE)
- Read [VERIFICATION.md](./VERIFICATION.md)
- Check existing issues and PRs
- Ensure tests pass locally

---

## 📋 Contribution Process

### Step 1: Fork & Clone

```bash
git clone https://github.com/YOUR_USERNAME/Ekubo-EVM.git
cd Ekubo-EVM
```

### Step 2: Create Branch

```bash
git checkout -b feature/your-feature-name
```

### Step 3: Make Changes

- Write clean, documented code
- Follow existing code style
- Add tests for new functionality
- Update documentation

### Step 4: Test

```bash
# Run all tests
forge test

# Check coverage
./scripts/check_coverage.sh

# Check contract sizes
./scripts/check_sizes.sh

# Run all verifications
./scripts/verify_all.sh
```

### Step 5: Commit

```bash
git add .
git commit -m "feat: add new feature"
```

**Commit Message Format:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `test:` Test additions/changes
- `refactor:` Code refactoring
- `perf:` Performance improvements

### Step 6: Push & PR

```bash
git push origin feature/your-feature-name
```

Create a Pull Request with:
- Clear description of changes
- Reference to related issues
- Test results
- Breaking changes (if any)

---

## 📝 Code Style Guidelines

### Solidity

- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Use 4 spaces for indentation
- Maximum line length: 120 characters
- Comprehensive NatSpec comments
- Descriptive variable names

Example:
```solidity
/// @notice Swaps tokens in the pool
/// @param amountIn The amount of input tokens
/// @return amountOut The amount of output tokens
function swap(uint256 amountIn) external returns (uint256 amountOut) {
    // Implementation
}
```

### Testing

- Test all new functionality
- Include edge cases
- Add fuzz tests where applicable
- Maintain 80%+ coverage
- Use descriptive test names

Example:
```solidity
function test_Swap_RevertsWhenInsufficientBalance() public {
    // Test implementation
}

function testFuzz_Swap_WorksWithAnyAmount(uint256 amount) public {
    // Fuzz test implementation
}
```

---

## ✅ Quality Requirements

All contributions must meet:

### 1. Testing
- ✅ All existing tests pass
- ✅ New tests added for new functionality
- ✅ Coverage remains ≥ 80%
- ✅ Fuzz tests where applicable

### 2. Contract Size
- ✅ All contracts < 24kb
- ✅ No significant size increases

### 3. Gas Optimization
- ✅ No significant gas increases
- ✅ Optimization considered

### 4. Documentation
- ✅ NatSpec comments for all public functions
- ✅ README updated if needed
- ✅ Technical docs updated

### 5. Security
- ✅ No known vulnerabilities
- ✅ Input validation
- ✅ Access control
- ✅ Reentrancy protection

---

## 🔍 Review Process

1. **Automated Checks:** CI/CD runs tests, coverage, size checks
2. **Code Review:** Maintainers review code quality
3. **Testing:** Functionality verification
4. **Security Review:** Security implications assessed
5. **Approval:** Maintainer approves and merges

---

## 🐛 Reporting Bugs

### Security Vulnerabilities

**DO NOT create public issues for security vulnerabilities!**

Email: aksels.laivenieks@outlook.com

Include:
- Description of vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Non-Security Bugs

Create a GitHub issue with:
- Clear title
- Detailed description
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Relevant logs/errors

---

## 💡 Suggesting Features

Create a GitHub issue with:
- Feature description
- Use case / problem it solves
- Proposed implementation (if any)
- Alternative solutions considered

---

## 📞 Questions?

- **Email:** aksels.laivenieks@outlook.com
- **GitHub Issues:** Use label `question`
- **Documentation:** Check [docs/](./docs/)

---

## 📜 License Agreement

By contributing, you agree that:
- Your contributions are licensed under the Ekubo DAO Shared Revenue License 1.0
- You do not gain ownership or reduced revenue share obligations
- Ekubo DAO retains all rights
- You have the right to submit the contribution

---

Thank you for contributing to Ekubo Protocol! 🚀