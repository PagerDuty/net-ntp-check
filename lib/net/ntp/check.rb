require 'logger'

require 'net/ntp/check/version'
require 'net/ntp/check/offset'
require 'net/ntp/check/statsd'

module Net
  module NTP
    ###
    # = Overview
    #
    # Net::NTP::Check checks NTP offset against several NTP servers
    module Check
      def self.logger
        @logger ||= Logger.new(STDOUT).tap do |l|
          l.level = Logger::INFO
        end
      end
    end
  end
end
