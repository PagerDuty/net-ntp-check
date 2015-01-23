require 'statsd'
require 'net/ntp/check/offset'

module Net
  module NTP
    module Check
      ###
      # = Overview
      #
      # Sends Net::NTP::Check offset data to statsd
      class StatsdClient
        DEFAULT_STATSD_HOST = 'localhost'
        DEFAULT_STATSD_PORT = 8125
        DEFAULT_STATSD_GAUGE_BASE = 'net.ntp.check'
        DEFAULT_TIMEOUT = 5

        def initialize(opts = {})
          @stats = {}
          @statsd_host = opts.fetch(:statsd_host, DEFAULT_STATSD_HOST)
          @statsd_port = opts.fetch(:statsd_port, DEFAULT_STATSD_PORT)
          @statsd_gauge_base = opts.fetch(:statsd_gauge_base,
                                          DEFAULT_STATSD_GAUGE_BASE)
          @ntp_timeout = opts.fetch(:ntp_timeout, DEFAULT_TIMEOUT)
          @ntp_hosts = opts.fetch(:ntp_hosts,
                                  Net::NTP::Check::DEFAULT_SERVERS)
          @statsd = Statsd.new(@statsd_host, @statsd_port)
        end

        def send_offset_stats
          err_code = 0
          offset_stats!
          @statsd.gauge("#{@statsd_gauge_base}.offset_s",
                        @stats[:offset])
          @statsd.gauge("#{@statsd_gauge_base}.offset_ms",
                        @stats[:offset_in_ms])

          rescue SocketError => e
            err_code = 3

          rescue Timeout::Error => e
            err_code = 2

          rescue StandardError => e
            err_code = 1
          ensure
            @statsd.gauge("#{@statsd_gauge_base}.err", err_code)
            warn 'Problem running Net::NTP::Check::StatsdClient stats '\
              "gathering: #{e.message} (error code #{err_code})" unless
              err_code == 0
            warn e.backtrace.join("\n") if err_code == 1
            exit err_code unless err_code == 0
        end

        private

        def offset_stats!
          stats_data_filtered = Net::NTP::Check.get_offsets_filtered(
            @ntp_hosts, @ntp_timeout)
          msg = "stats_data_filtered: #{stats_data_filtered}"
          Net::NTP::Check.logger.debug(msg)
          @stats[:offset] = stats_data_filtered
          @stats[:offset_in_ms] = @stats[:offset] * 1000
          Net::NTP::Check.logger.debug("stats: #{@stats}")
        end
      end
    end
  end
end
