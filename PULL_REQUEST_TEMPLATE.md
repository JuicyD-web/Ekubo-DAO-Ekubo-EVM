## Description

<!-- Provide a clear and concise description of your changes -->

## Type of Change

<!-- Check all that apply -->

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📝 Documentation update
- [ ] ⚡ Performance improvement
- [ ] 🔧 Configuration change
- [ ] ♻️ Code refactoring

## Related Issues

<!-- Link to related issues -->

Closes #<!-- issue number -->
Related to #<!-- issue number -->

## Changes Made

<!-- Detailed list of changes -->

- Change 1
- Change 2
- Change 3

## Testing

### Test Coverage

- [ ] All existing tests pass
- [ ] New tests added for new functionality
- [ ] Edge cases covered
- [ ] Fuzz tests added (if applicable)
- [ ] Integration tests updated (if applicable)

### Test Results

```bash
# Paste test results here
forge test -vvv
```

### Gas Impact

- [ ] Gas usage analyzed
- [ ] Gas optimization considered
- [ ] Gas report attached (if significant changes)

```bash
# Paste gas report comparison here
forge test --gas-report
```

## Security Considerations

<!-- Describe any security implications -->

- [ ] No new security vulnerabilities introduced
- [ ] Access control properly implemented
- [ ] Input validation added
- [ ] Reentrancy protection considered
- [ ] Integer overflow/underflow handled
- [ ] External calls handled safely

### Security Checklist

- [ ] No use of `tx.origin`
- [ ] Safe external calls (checks-effects-interactions)
- [ ] Proper access modifiers
- [ ] Safe math operations
- [ ] No unprotected selfdestruct or delegatecall

## Code Quality

### Standards Compliance

- [ ] Code follows Solidity style guide
- [ ] NatSpec comments added for public/external functions
- [ ] Complex logic documented with inline comments
- [ ] Code formatted with `forge fmt`
- [ ] No compiler warnings

### Review Checklist

- [ ] Self-review completed
- [ ] Code is self-documenting or well-commented
- [ ] No dead code or commented-out code
- [ ] Error messages are descriptive
- [ ] Magic numbers replaced with named constants

## Documentation

<!-- Check all documentation that was updated -->

- [ ] Code comments (NatSpec)
- [ ] README.md updated (if needed)
- [ ] CHANGELOG.md updated
- [ ] Architecture docs updated (if needed)
- [ ] Migration guide added (if breaking change)

## Deployment Considerations

<!-- For changes that affect deployment -->

- [ ] Deployment script updated
- [ ] Migration path documented (if needed)
- [ ] Contract verification considered
- [ ] Initialization parameters documented

## Breaking Changes

<!-- List any breaking changes -->

**Does this PR introduce breaking changes?**

- [ ] Yes
- [ ] No

**If yes, describe the breaking changes and migration path:**

<!-- Describe what breaks and how to migrate -->

## Revenue Sharing Compliance

<!-- For significant protocol changes -->

- [ ] Changes maintain revenue tracking accuracy
- [ ] No impact on revenue sharing obligations
- [ ] Revenue calculation logic verified (if modified)

## Screenshots/Recordings

<!-- If applicable, add screenshots or recordings to demonstrate changes -->

## Additional Context

<!-- Add any other context about the PR here -->

## Pre-Submission Checklist

<!-- Ensure all items are checked before submitting -->

### Code Quality
- [ ] Code compiles without errors: `forge build`
- [ ] All tests pass: `forge test`
- [ ] Code formatted: `forge fmt`
- [ ] No new compiler warnings

### Documentation
- [ ] Changes documented in code comments
- [ ] CHANGELOG.md updated
- [ ] README.md updated (if needed)

### Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Gas usage acceptable
- [ ] Edge cases tested

### Security
- [ ] Security implications considered
- [ ] No obvious vulnerabilities
- [ ] Follows best practices

### Review
- [ ] Self-review completed
- [ ] Ready for maintainer review

## Reviewer Notes

<!-- Notes for reviewers -->

### Areas Needing Special Attention

- Area 1
- Area 2

### Questions for Reviewers

- Question 1
- Question 2

---

**By submitting this PR, I confirm that:**

- [ ] I have read and agree to the [Contributing Guidelines](../CONTRIBUTING.md)
- [ ] I understand this is a derivative work under Ekubo DAO Shared Revenue License 1.0
- [ ] My contributions are subject to the revenue-sharing obligations
- [ ] I have the right to submit this contribution
- [ ] I have added myself to CONTRIBUTORS.md (if this is my first contribution)

<!-- Thank you for contributing to Ekubo Protocol EVM! -->