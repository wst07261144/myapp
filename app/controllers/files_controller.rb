require 'fileutils'
class FilesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :create_aliyun_client, only: [:create, :download]

  AcessKeyId     = 'LTAIwh6U6uxyaFtb'
  AcessKeySecret = 'IZcHFCSlOC9BFzMGSdxtqYaxB8ic6i'
  EndPoint       = 'https://oss-cn-beijing.aliyuncs.com'

  def index
    @files = MyFile.all
  end

  def new
  end

  def create
    file = params[:upload][:files]
    file_path = File.join("public", file.original_filename)
    FileUtils.cp file.path, file_path

    file_name = "#{Time.current.strftime("%Y-%m-%d")}-#{file.original_filename}"
    if @bucket.put_object(file_name, :file => file_path)
      MyFile.create(name: file_name)
    end

    File.delete(file_path)

    redirect_to files_path, notice: "上传成功"
  end

  def download
    name = MyFile.find_by(id: params[:id]).try(:name)
    if name
      @bucket.get_object(name, :file => "/Users/wangsuting/Desktop/#{name}")
    end
    render text: 'ok'
  end

  private
  def create_aliyun_client
    @client = Aliyun::OSS::Client.new(
        :endpoint => EndPoint,
        :access_key_id => AcessKeyId,
        :access_key_secret => AcessKeySecret
    )
    @bucket = @client.get_bucket('wsttest-001')
  end
end
