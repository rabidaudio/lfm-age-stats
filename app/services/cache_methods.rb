# frozen_string_literal: true

# Helper module for automatically wrapping a method behind Rails.cache
module CacheMethods
  extend ActiveSupport::Concern

  class_methods do
    def cache(*method_names)
      method_names.each do |method_name|
        proxy = Module.new do
          define_method(method_name) do |*args|
            Rails.cache.fetch("#{method_name}:#{Base64.urlsafe_encode64(Marshal.dump(args))}") do
              super(*args)
            end
          end
        end
        prepend proxy
      end
    end
  end
end
