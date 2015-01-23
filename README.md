# Net::Ntp::Check

[![Build Status](https://travis-ci.org/pagerduty/net-ntp-check.svg?branch=master)](https://travis-ci.org/pagerduty/net-ntp-check)
[![Gem Version](http://img.shields.io/gem/v/net-ntp-check.svg)](https://rubygems.org/gems/net-ntp-check)
[![Coverage Status](https://img.shields.io/coveralls/pagerduty/net-ntp-check/master.svg)](https://coveralls.io/r/pagerduty/net-ntp-check?branch=master)
[![Code Climate](https://codeclimate.com/github/pagerduty/net-ntp-check/badges/gpa.svg)](https://codeclimate.com/github/pagerduty/net-ntp-check)

Checks NTP offset against several NTP servers and allows pushing of offset stats via statsd

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'net-ntp-check'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install net-ntp-check

## Usage

### Get NTP offsets based on several servers
```ruby
require 'net/ntp/check'
offsets = Net::NTP::Check.get_offsets
```

### Get NTP offset based on several servers with a 200ms bandpass filter applied
```ruby
require 'net/ntp/check'
offsets = Net::NTP::Check.get_offsets_filtered
```

### Send NTP offset to statsd
```ruby
require 'net/ntp/check'
client = Net::NTP::Check::StatsdClient.new
client.send_offset_stats
```

## Contributing

1. Fork it ( https://github.com/shortdudey123/net-ntp-check/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
