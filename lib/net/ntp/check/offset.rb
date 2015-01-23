require 'net/ntp'

module Net
  module NTP
    ###
    # = Overview
    #
    # Contains Net::NTP::Check offset checks
    module Check
      # Default servers to check against
      DEFAULT_SERVERS = [
        '0.pool.ntp.org',
        '1.pool.ntp.org',
        '2.pool.ntp.org',
        '3.pool.ntp.org'
      ]

      # Default timeout for the NTP requests
      TIMEOUT = Net::NTP::TIMEOUT

      # Get the time offsets against the given host list with a
      # bandpass filter applied
      def self.get_offsets_filtered(hosts = DEFAULT_SERVERS, timeout = TIMEOUT)
        offsets = []
        hosts_multiplier = (9.0 / hosts.length).ceil
        Net::NTP::Check.logger.debug("Hosts given: #{hosts}")
        Net::NTP::Check.logger.debug("Hosts multiplier: #{hosts_multiplier}")
        hosts_multiplier.times do
          offsets.push(get_offsets(hosts, timeout))
          sleep(0.01) # sleep to keep from getting rate limted
        end
        AutoBandPass.filter(offsets.flatten.shuffle[0...9])
      end

      # Get the time offsets against the given host list
      def self.get_offsets(hosts = DEFAULT_SERVERS, timeout = TIMEOUT)
        offsets = []

        Net::NTP::Check.logger.debug("Host list: #{hosts}")

        hosts.each do |host|
          offsets.push(get_offset(host, timeout))
        end
        offsets
      end

      # Get the time offset against the given host
      def self.get_offset(host = DEFAULT_SERVERS[0], timeout = TIMEOUT)
        get_host_data(host, timeout).offset
      end

      private

      # Do the NTP request and catch exceptions
      def self.get_host_data(host, timeout = TIMEOUT)
        t = Net::NTP.get(host, 'ntp', timeout)
        Net::NTP::Check.logger.debug("Received NTP data for #{host}")
        t
      rescue SocketError
        err_msg = "Unable to resolve #{host}"
        Net::NTP::Check.logger.debug(err_msg)
        raise SocketError, err_msg
      rescue NoMethodError, Timeout::Error
        # need to catch NoMethodError pending bug fix
        # https://github.com/zencoder/net-ntp/pull/9
        err_msg = "Connection timed out to #{host}"
        Net::NTP::Check.logger.debug(err_msg)
        raise Timeout::Error, err_msg
      end

      # The filtering works like this:
      # This assumes you are passing in a 9 length Array. Other lengths
      # may work, but YMMV. This then gets the average of the middle three
      # of the sorted Array. Using this average, and an arbitrary range
      # (+/- 200ms), we delete any values outside of that range. This
      # effectively is a lazy-man's band-pass filter.
      class AutoBandPass
        FILTER_RANGE = 0.2

        def self.filter(values)
          v = values.sort
          Net::NTP::Check.logger.debug("AutoBandPass values: #{v}")
          avg = average(v[3..5])
          Net::NTP::Check.logger.debug("AutoBandPass mid 3 values avg: #{avg}")
          v = apply_band(v, avg)
          Net::NTP::Check.logger.debug("AutoBandPass values with filter: #{v}")
          average(v)
        end

        def self.apply_band(values, average)
          values.dup.each do |o|
            upper_bound = (average + FILTER_RANGE)
            lower_bound = (average - FILTER_RANGE)
            values.delete(o) if o < lower_bound || o > upper_bound
          end
          values
        end

        def self.average(values)
          values.reduce { |a, e| a + e } / values.length.to_f
        end
      end
    end
  end
end
