# Changelog

All noteworthy changes to this project will be documented in this file.

The format is based on [Keep a Changelog][changelog-1].

Versioning semi-adheres to [Semantic Versioning][changelog-2], accordingly:
*Ubuntu-Minor.Box-Major.Box-Minor*.

A new Ubuntu release will bump the first digit (which will never happen because
the year 2017 is over lol). A new version of this Vagrant box will bump either
or both of the last two digits.

Box updates do not add additional software unless strictly necessary for bug
fixes and system stability. Box updates are most likely new Guest Additions, a
new Linux kernel, upgraded software packages and so on. Having that said, the
*Box-Major* part of the version string is unlikely to change.

[changelog-1]: http://keepachangelog.com/en/1.0.0/
[changelog-2]: http://semver.org/spec/v2.0.0.html

## [Unreleased][unreleased-1]

- Nothing, yet.

[unreleased-1]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/compare/v10.0.1...HEAD

## [10.0.2][1002-1] - 2018-01-30

### Changed

- Linux Kernel `4.13.0-32-generic` (was 4.13.0-21-generic).
- VirtualBox Guest Additions `5.2.6r120293` (was 5.2.4r119785).

[1002-1]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/compare/v10.0.1...v10.0.2

## [10.0.1][1001-1] - 2018-01-07

### Added

- This changelog.

### Improved

- [issue #3][1001-2]

[1001-1]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/compare/v10.0.0...v10.0.1
[1001-2]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/issues/3

## 10.0.0 - 2018-01-02

Initial release.