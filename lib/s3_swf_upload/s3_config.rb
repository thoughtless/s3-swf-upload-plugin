module S3SwfUpload
  class S3Config
    require 'yaml'

    cattr_reader :access_key_id, :secret_access_key
    cattr_accessor :bucket, :max_file_size, :acl

    def self.load_config

      @@access_key_id     = ENV['AMAZON_ACCESS_KEY_ID'] || config[RAILS_ENV]['access_key_id']
      @@secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY'] || config[RAILS_ENV]['secret_access_key']
      @@bucket            = ENV['AMAZON_S3_SWF_UPLOAD_BUCKET'] || config[RAILS_ENV]['bucket_name']
      @@max_file_size     = ENV['AMAZON_S3_SWF_MAX_FILE_SIZE'].try(:to_i) || config[RAILS_ENV]['max_file_size'] # .try(:to_i) returns nil when the receiver is nil. Using just .to_i would return 0.
      @@acl               = ENV['AMAZON_S3_SWF_UPLOAD_ACL'] || config[RAILS_ENV]['acl'] || 'private'
      
      unless @@access_key_id && @@secret_access_key
        raise "Please configure your S3 settings in #{filename}."
      end
    end
    
    # Having this as a method means that we don't have to have the file if all 
    # settings are set in ENV variables.
    def self.config
      return @config if @config
      
      filename = "#{RAILS_ROOT}/config/amazon_s3.yml"
      file = File.open(filename)
      @config = YAML.load(file)
    end
  end
end
