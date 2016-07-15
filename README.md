# GoldenRose

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/PGSSoft/golden_rose/blob/master/LICENSE)

A tool for generating reports from Xcode results bundle.

## Installation

```bash
sudo gem install golden_rose
```

## Quick start

GoldenRose creates UI Automation tests report from "results" bundle created by the Xcode during execution.

- Run UI Tests and save results bundle using `-resultBundlePath`:

```bash
xcodebuild -workspace MyProject.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPad Air 2,OS=9.2' \
  -resultBundlePath 'MyApp.test_result' test
```

- Generate reports with GoldenRose:

```bash
golden_rose generate MyApp.test_result
```

The tool will generate a report in html format in the current directory.

## Features

- [x] UI Automation tests
- [x] Reading from ZIP files
- [ ] Unit tests reports
- [ ] Build logs
- [ ] Code coverage
- [ ] Fastlane integration
- [ ] JUnit reports
- [ ] And more

## Development

After checking out the repo, run `./bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` to start an interactive prompt that, which will enable you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/PGSSoft/golden_rose](https://github.com/PGSSoft/golden_rose).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
