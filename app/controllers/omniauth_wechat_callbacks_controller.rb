require 'net/http'
class OmniauthWechatCallbacksController < ApplicationController

  def start
    redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{WECHAT_CONFIG['WECHAT_APP_ID']}&redirect_uri=http%3A%2F%2Fviduapp.com%2Fauth%2Fwechat%2Fcallback&response_type=code&scope=snsapi_userinfo&state=8e55d93c2a3fe584c14382def8a99bcff15131db64cbba58&connect_redirect=1#wechat_redirect"
  end

  def callback
    Rails.logger.info "zzzzz"
    Rails.logger.info request
    Rails.logger.info "zzzzz"
  end

  def failure
    Rails.logger.info "xxxxx"
    Rails.logger.info request.headers.to_json
    #Rails.logger.info request.env.to_json
    Rails.logger.info "xxxxx"
    # redirect_to "/qy_apps"
  end

  def setup
    request.env['omniauth.strategy'].options[:client_secret] = ''
    render :text => "Setup complete.", :status => 404
  end

  private

    def get_access_token
      res = Net::HTTP.get_response(URI("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=#{WECHAT_CONFIG['WECHAT_APP_ID']}&corpsecret=#{WECHAT_CONFIG['WECHAT_APP_SECRET']}"))
      puts res
    end

end
