# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2020-02-05
### Added
- Do not resize SVG or GIF files.
- Added this changelog 🎊.
- Customizable cache directory by [@pantajosef](https://github.com/pantajosef)
- Preserve jpg quality when resizing.
- Ignore original image files by [@pmk1c](https://github.com/pmk1c) and [@TimMoser92](https://github.com/TimMoser92).
- Support for `image_path` helper by [@juls](https://github.com/juls).
- Added a README.
- Image optimization by [@pmk1c](https://github.com/pmk1c).
- Initial image resizing by [@juls](https://github.com/juls).

### Changed
- `image_optim` removed as a dependency by [@pantajosef](https://github.com/pantajosef).
  Make sure to include `image_optim` in your Gemfile if you need to optimize images.
- `mini_magick` removed as a dependency.
  Make sure to include `mini_magick` in you Gemfile if you need to resize images.
- Images are not optimized by default anymore.

### Removed
- Removed support for Ruby < 2.5

[Unreleased]: https://github.com/zweitag/middleman-images/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/zweitag/middleman-images/releases/tag/v0.1.0
