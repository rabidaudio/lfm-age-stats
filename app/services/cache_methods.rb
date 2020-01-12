
module CacheMethods
  extend ActiveSupport::Concern
  
  class_methods do
    def cache(*method_names)
      method_names.each do |method_name|
        proxy = Module.new do
          define_method(method_name) do |*args|
            Rails.cache.fetch("#{method_name}:#{Base64.urlsafe_encode64(Marshal.dump(args))}") do
              super(*args) #.yield_self { |v| v || :nil }
            end #.yield_self { |v| v == :nil ? nil : v }
          end
        end
        self.prepend proxy
      end
    end
  end
end
