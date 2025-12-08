# Changelog

All notable changes to the Ekubo Protocol EVM implementation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial EVM implementation of Ekubo Protocol
- Core contracts ported from Starknet Cairo implementation
- Foundry testing framework
- Comprehensive test suite
- Documentation structure

### Changed
- Architecture adapted for EVM compatibility
- Storage layout optimized for EVM gas costs
- Math operations using Solidity libraries

### Security
- Initial security review pending
- Slither static analysis configured
- Test coverage targets set (>80%)

---

## [0.1.0] - 2025-11-25

### Added
- **Project Structure**
  - Initial repository setup
  - Foundry configuration
  - Git submodules for dependencies (Solady, Forge-Std)

- **Core Contracts** (Initial Implementation)
  - `PoolManager.sol` - Pool management logic
  - `PositionManager.sol` - LP position tracking
  - `Router.sol` - User-facing swap router
  - Core libraries for math and utilities

- **Testing Infrastructure**
  - Unit test framework
  - Integration test setup
  - Fuzz testing configuration
  - Gas reporting tools

- **Documentation**
  - LICENSE - Ekubo DAO Shared Revenue License 1.0
  - README.md - Project overview
  - DERIVATIVE_COMPLIANCE.md - License compliance documentation
  - THIRD_PARTY_LICENSES.md - Dependency licenses
  - CONTRIBUTORS.md - Contributor recognition
  - CONTRIBUTING.md - Contribution guidelines
  - DEVELOPMENT.md - Developer guide
  - ARCHITECTURE.md - Technical architecture
  - SECURITY.md - Security policy
  - CHANGELOG.md - This file

- **CI/CD**
  - GitHub Actions workflow for testing
  - Automated Slither analysis
  - Gas reporting on PRs
  - Coverage reporting

### Changed
- N/A (Initial release)

### Deprecated
- N/A (Initial release)

### Removed
- N/A (Initial release)

### Fixed
- N/A (Initial release)

### Security
- Initial security considerations documented
- Vulnerability reporting process established
- Audit schedule planned

---

## Version Guidelines

### Version Format: MAJOR.MINOR.PATCH

- **MAJOR**: Incompatible API changes
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

### Categories

- **Added**: New features
- **Changed**: Changes to existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security vulnerabilities and fixes

---

## Example Future Entry

```markdown
## [1.0.0] - YYYY-MM-DD

### Added
- Multi-hop routing functionality
- Advanced fee tier configurations
- Protocol fee collection mechanism
- Emergency pause functionality

### Changed
- Optimized gas usage in swap operations (-15% gas)
- Updated position NFT metadata
- Enhanced oracle TWAP accuracy

### Fixed
- [Critical] Fixed rounding error in liquidity calculations (#123)
- [High] Corrected tick spacing validation (#124)
- [Medium] Resolved edge case in position transfers (#125)

### Security
- Completed audit by [Audit Firm] - See audits/2025-Q2-Firm/
- Fixed reentrancy vulnerability in position manager
- Added additional access controls to admin functions
- Implemented emergency shutdown mechanism
```

---

## Release Process

1. **Update CHANGELOG.md** with all changes
2. **Update version** in relevant files
3. **Run full test suite**: `forge test`
4. **Generate gas report**: `forge test --gas-report`
5. **Create git tag**: `git tag -a v1.0.0 -m "Release v1.0.0"`
6. **Push tag**: `git push origin v1.0.0`
7. **Create GitHub release** with changelog excerpt
8. **Announce** on communication channels

---

## Communication Channels

Release announcements:
- GitHub Releases: https://github.com/Ekubo-DAO/Ekubo-EVM/releases
- Twitter/X: [N/A]
- Discord: [N/A]
- Blog: [N/A]

---

## Useful Links

- **Repository**: https://github.com/Ekubo-DAO/Ekubo-EVM
- **Issues**: https://github.com/Ekubo-DAO/Ekubo-EVM/issues
- **Documentation**: See docs/ directory
- **Security**: See SECURITY.md
- **Contributing**: See CONTRIBUTING.md

---

**Note**: This changelog focuses on the EVM implementation. For the original Starknet protocol changelog, see the [original repository](https://github.com/EkuboProtocol/core).

[Unreleased]: https://github.com/Ekubo-DAO/Ekubo-EVM/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Ekubo-DAO/Ekubo-EVM/releases/tag/v0.1.0