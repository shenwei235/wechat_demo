require 'net/http'
class HomeController < ApplicationController

  def index
    group_client = QyWechatApi::Client.new(WECHAT_CONFIG['WECHAT_APP_ID'], WECHAT_CONFIG['WECHAT_APP_SECRET'])
    group_client.is_valid?
    val = group_client.oauth.authorize_url("http://viduapp.com", "state")
    Rails.logger.info "xxxx"
    Rails.logger.info Net::HTTP.get(URI(val))
    Rails.logger.info "xxxx"
  end

end