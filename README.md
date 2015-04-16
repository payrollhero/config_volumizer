# config_volumizer

[![Build Status](https://travis-ci.org/payrollhero/config_volumizer.svg)](https://travis-ci.org/payrollhero/config_volumizer)
[![Code Climate](https://codeclimate.com/github/payrollhero/config_volumizer/badges/gpa.svg)](https://codeclimate.com/github/payrollhero/config_volumizer)
[![Coverage Status](https://coveralls.io/repos/payrollhero/config_volumizer/badge.svg?branch=master)](https://coveralls.io/r/payrollhero/config_volumizer?branch=master)

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

### Parsing

You can parse a flattened config via `ConfigVolumizer.parse(ENV, 'some')`

For example if your ENV was:

```
some.setting[0] = one
some.setting[1] = two
some.setting[2] = three
some.with.another = setting
```

This would yield a {Hash} like the following:

```yaml
some:
  setting:
    - one
    - two
    - three
  with:
    another: setting
```

### Generation

You can generate a flat list of configs (mostly as examples for your actual config) via:
`ConfigVolumizer.generate(data_hash)`

For example, given a hash simillar to:
```yaml
some:
  setting:
    - one
    - two
    - three
  with:
    another: setting
```

You would get back a hash looking like this:

```yaml
"some.setting[0]": one
"some.setting[1]": two
"some.setting[2]": three
"some.with.another": setting
```

## Install

Add it to your gemfile and use it.

```ruby
gem 'config_volumizer'
```

## Copyright

Copyright (c) 2015 PayrollHero Pte. Ltd.

See LICENSE.txt for details.
