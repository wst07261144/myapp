require 'aliyun/oss'
class ApplicationController < ActionController::Base
  protect_from_forgery



  def aaa
    client = Aliyun::OSS::Client.new(
        :endpoint => 'https://oss-cn-beijing.aliyuncs.com',
        :access_key_id => 'LTAIwh6U6uxyaFtb',
        :access_key_secret => 'IZcHFCSlOC9BFzMGSdxtqYaxB8ic6i')
  end
end
