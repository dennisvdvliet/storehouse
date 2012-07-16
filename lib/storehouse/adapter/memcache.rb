require 'memcache'

module Storehouse
  module Adapter
    class Memcache < Base

      def initialize(options = {})
        super
        @client_options = options[:client] || {:host => 'localhost', :port => '11211'}
        connect!
      end

      def connect!
        @client ||= begin
          ::Memcache.new(:server => self.server)
        end
      end

      def read(key)
        @client.get(key)
      end

      def write(key, content)
        @client.set(key, content)
      end

      def delete(key)
        @client.delete(key)
      end

      def clear!
        @client.flush_all
      end

      protected

      def server
        "#{@client_options[:host]}:#{@client_options[:port]}"
      end

    end
  end
end