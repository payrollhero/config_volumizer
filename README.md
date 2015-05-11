# config_volumizer

[![Build Status](https://travis-ci.org/payrollhero/config_volumizer.svg)](https://travis-ci.org/payrollhero/config_volumizer)
[![Code Climate](https://codeclimate.com/github/payrollhero/config_volumizer/badges/gpa.svg)](https://codeclimate.com/github/payrollhero/config_volumizer)
[![Coverage Status](https://coveralls.io/repos/payrollhero/config_volumizer/badge.svg?branch=master)](https://coveralls.io/r/payrollhero/config_volumizer?branch=master)
[![Dependency Status](https://gemnasium.com/payrollhero/config_volumizer.svg)](https://gemnasium.com/payrollhero/config_volumizer)

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
some_setting = one,two,three
some_with_another = setting
```

... and then just give it some volume with the volumizer to turn it back to the original rich structure

```ruby
mapping = { "some" => { "setting" => :value, "with" => { "another" => :value } } }
ConfigVolumizer.parse(ENV, mapping)
```

## Features

### Parsing

You can parse a flattened config via `ConfigVolumizer.parse(ENV, mapping)`

For example if your ENV was:

```
some_setting = one,two,three
some_with_another = setting
```

And you created a map like so:
```ruby
mapping = {
  "some" => {
    "setting" => :value,
    "with" => {
      "another" => :value
    }
  }
}
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

### Fetching values (shorthand for parse)

You can fetch a specific key from the given source

For example:

```ruby
env = {
  "some_setting" => "one,two,three",
  "some_with_another" => "setting",
}

mapping = {
  "setting" => [:value],
  "with" => {
    "another" => :value
  }
}

ConfigVolumizer.fetch(env, "some", mapping)

# returns:
{
 "setting" => [
   "one","two","three"
 ],
 "with" => {
   "another" => "setting",
 }
}
```

fetch works much like Hash#fetch, so you can pass an additional
parameter for the default value, as well as use a block default value.

eg:

```ruby
ConfigVolumizer.fetch(env, "another", mapping, "default_value")
# => "default_value"

ConfigVolumizer.fetch(env, "another", mapping) { |key| "default_#{key}" }
# => "default_another"
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

You would get back the data and mapping looking like this:

```yaml
some:
  setting: :value
  with:
    another: :value
```

```yaml
"some_setting": one,two,three
"some_with_another": setting
```

## Deployment

In order to deploy a new version of the gem into the wild ...

You will need to configure your github api token for the changelog.

Generate a new token for changelogs [here](https://github.com/settings/tokens/new).

add:

```bash
export CHANGELOG_GITHUB_TOKEN=YOUR_CHANGELOG_API_TOKEN
```

somewhere in your shell init. (ie .zshrc or simillar)


```bash
vim lib/config_volumizer/version.rb
# set the new version
# commit the changed version file
# name your commit with the version number eg: "1.8.0"
rake release
# to push the gem to rubygems.org
rake changelog
# commit the changed changelog
# name your commit with the version again eg: "changelog for 1.8.0"
git push
```

## Install

Add it to your gemfile and use it.

```ruby
gem 'config_volumizer'
```

## Copyright

Copyright (c) 2015 PayrollHero Pte. Ltd.

See LICENSE.txt for details.
