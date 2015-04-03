# config_volumizer

[![Build Status](https://travis-ci.org/payrollhero/config_volumizer.svg)](https://travis-ci.org/payrollhero/config_volumizer)
[![Code Climate](https://codeclimate.com/github/payrollhero/config_volumizer/badges/gpa.svg)](https://codeclimate.com/github/payrollhero/config_volumizer)

* [Homepage](https://rubygems.org/gems/config_volumizer)
* [Documentation](http://rubydoc.info/gems/config_volumizer/frames)
* [Email](mailto:piotr.banasik at gmail.com)

## Description

Ever wanted to move to ENV based 12 Factor config but are stuck with somewhat complex yaml (or simillar) files
holding all your settings?

Been scratching your head how to convert your deeply nested config to ENV?

Config Volumizer comes to the rescue.

## Examples

Convert this:
```yaml
some:
  setting:
    - one
    - two
    - three
  with:
    another: setting
```

info a series of ENV variables like so:

```
some.setting[0] = one
some.setting[1] = two
some.setting[2] = three
some.with.another = setting
```

... and then just give it some volume with the volumizer to turn it back to the original rich structure

```ruby
ConfigVolumizer.parse(ENV, 'some')
```

## Features

The gem basically smartly parses all keys within the passed in Hash that match the prefix specified.

It allows to nest either arrays or hashes inside eachother, basically any reasonable combination of hash/array notation should work.

## Install

Add it to your gemfile and use it.

```ruby
gem 'config_volumizer'
```

## Copyright

Copyright (c) 2015 PayrollHero Pte. Ltd.

See LICENSE.txt for details.
