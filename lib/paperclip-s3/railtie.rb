module Paperclip
  module S3
    if defined? Rails::Railtie # Don't break rails 2.x
      require 'rails'
      class Railtie < Rails::Railtie
        initializer 'paperclip.force_s3_attachment_on_production' do
          ActiveSupport.on_load :active_record do
            Paperclip::S3::Railtie.insert
          end
        end
      end
    end

    class Railtie
      def self.insert
        using_s3 = ENV.select {|k,_| k =~ /^S3_/}.length == 3
        ActiveRecord::Base.send(:include, Paperclip::S3::Glue) if using_s3
      end
    end
  end
end
