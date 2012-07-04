module Storehouse

  autoload :VERSION, 'storehouse/version'
  autoload :Config, 'storehouse/config'
  autoload :Middleware, 'storehouse/middleware'

  module Adapter
    autoload :Base, 'storehouse/adapter/base'
    autoload :Dalli, 'storehouse/adapter/dalli'
  end

  class << self

    cattr_accessor :config
    cattr_accessor :store

    delegate :read, :write, :to => :data_store, :allow_nil => true

    def configure
      self.config ||= ::Storehouse::Config.new
      yield self.config if block_given?
      self.config
    end

    def data_store
      self.store ||= begin
        class_name = (self.config.adapter || 'Base').to_s.classify
        "Storehouse::Adapter::#{class_name}".constantize.new(self.config.adapter_options || {})
      end
    end
  end

end
