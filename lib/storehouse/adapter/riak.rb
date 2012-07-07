require 'riak'

module Storehouse
  module Adapter
    class Riak < Base

      def initialize(options = {})
        super
        @bucket_name = options[:bucket] || '_page_cache'
        @client_options = options[:client] || {}
        connect!
      end

      def connect!
        @bucket = ::Riak::Client.new(@client_options).bucket(@bucket_name)
      end

      def read(path)
        @bucket.get(path).data
      rescue ::Riak::FailedRequest => e
        raise e unless e.not_found?
        nil
      end

      def write(path, content)
        object = @bucket.get_or_new(path)
        object.content_type = 'text/plain'
        object.data = content
        object.store
      end

      def delete(path)
        @bucket.delete(path)
      end

      def clear!
        @bucket.keys do |k|
          delete(k)
        end
      end

    end
  end
end