# rubyzip-deflate64

[![Gem Version](https://badge.fury.io/rb/rubyzip-deflate64.svg)](http://badge.fury.io/rb/rubyzip-deflate64)
[![Tests](https://github.com/rubyzip/rubyzip-deflate64/actions/workflows/tests.yml/badge.svg)](https://github.com/rubyzip/rubyzip-deflate64/actions/workflows/tests.yml)
[![Linter](https://github.com/rubyzip/rubyzip-deflate64/actions/workflows/lint.yml/badge.svg)](https://github.com/rubyzip/rubyzip-deflate64/actions/workflows/lint.yml)
[![Maintainability](https://qlty.sh/gh/rubyzip/projects/rubyzip-deflate64/maintainability.svg)](https://qlty.sh/gh/rubyzip/projects/rubyzip-deflate64)
[![Coverage Status](https://coveralls.io/repos/github/rubyzip/rubyzip-deflate64/badge.svg?branch=main)](https://coveralls.io/github/rubyzip/rubyzip-deflate64?branch=main)

The rubyzip-deflate64 gem provides an extension of the rubyzip gem for reading zip files compressed with deflate64 compression.

## Website and Project Home
http://github.com/rubyzip/rubyzip-deflate64

## Requirements

* Ruby 3.0 or greater
* Rubyzip 3.0 or greater
* libinflatelib.so.0 / inflatelib.dll v0.3.0

## Installation

**This is a work in progress.**

**The gem is not yet published on Rubygems (TODO).**

The rubyzip-deflate64 gem is available on RubyGems:

```
gem install rubyzip-deflate64
```

Or in your Gemfile:

```ruby
gem 'rubyzip-deflate64'
```

## About InflateLib
This gem requires a C based library called InflateLib
(from https://github.com/microsoft/inflatelib) to be available
on your system.

The InflateLib libray is currently considered "prerelease".
Its API and ABI should not be considered stable.

Binaries of this library are not yet generally available for
Linux distributions.

For Ubuntu, a binary is made available in a Person Package Archive (PPA).
It can be installed with:
```
sudo add-apt-repository ppa:jspanjers/inflatelib
sudo apt update
sudo apt install libinflatelib0
```

## Usage
Reading a zip file with deflate64 compression is no different from reading
any other zip file using rubyzip:

```ruby
require 'rubyzip/deflate64'

Zip::File.open('foo.zip') do |zipfile|
  zipfile.each do |entry|
    content = zipfile.read(entry.name)
  end
end

```

## License
Rubyzip-deflate64 is distributed under the same license as Ruby. In practice
this means you can use it under the terms of the Ruby License or the
2-Clause BSD License.
See https://www.ruby-lang.org/en/about/license.txt and LICENSE.md for details.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/rubyzip/rubyzip-deflate64.

## Development
You can run the tests with:

```
bundle install
bundle exec rake
```

## Authors

See https://github.com/rubyzip/rubyzip-deflate64/graphs/contributors for a comprehensive list.

### Current maintainers

* TBD

### Original author
Jan-Joost Spanjers ( oss at hiberis.nl )
