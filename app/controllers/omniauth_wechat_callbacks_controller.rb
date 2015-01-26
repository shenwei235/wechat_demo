require 'net/http'
class OmniauthWechatCallbacksController < ApplicationController

  def failure
    Rails.logger.info "xxxxx"
    Rails.logger.info request.headers
    Rails.logger.info request.env["omniauth.auth"]
    Rails.logger.info "xxxxx"
    # redirect_to "/qy_apps"
  end

  def setup
    request.env['omniauth.strategy'].options[:client_secret] = get_access_token
  end

  private

    def get_access_token
      res = Net::HTTP.get_response(URI("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=#{WECHAT_CONFIG['WECHAT_APP_ID']}&corpsecret=#{WECHAT_CONFIG['WECHAT_APP_SECRET']}"))
      puts res
    end

end
