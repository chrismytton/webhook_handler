# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.4.0] - 2015-11-26

### Changed

- Removed the dependency on Sinatra, it now operates as a simple Rack app.

## [0.3.1] - 2015-11-26

### Fixed

- Fix issue with Ruby < 2.1 where we called `Module#include` as a public method. (It was only made public in 2.1.)

## [0.3.0] - 2015-11-23

### Added

- There is now an app generator that can be used to create a new app. This can be accessed via the `webhook_handler` binary.

## [0.2.0] - 2015-11-23

### Changed

- Specified versions of sinatra and sidekiq the gem works with in the gemspec.

## 0.1.0 - 2015-11-23

- Initial release

[0.2.0]: https://github.com/chrismytton/webhook_handler/compare/v0.1.0...v0.2.0
[0.3.0]: https://github.com/chrismytton/webhook_handler/compare/v0.2.0...v0.3.0
[0.3.1]: https://github.com/chrismytton/webhook_handler/compare/v0.3.0...v0.3.1
[0.3.1]: https://github.com/chrismytton/webhook_handler/compare/v0.3.1...v0.4.0
