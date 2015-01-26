class HomeController < ApplicationController

  def initialize
    @group_client = QyWechatApi::Client.new(WECHAT_CONFIG['WECHAT_APP_ID'], WECHAT_CONFIG['WECHAT_APP_SECRET'])
  end

  def index
    if @group_client.is_valid?
      @auth_url = @group_client.oauth.authorize_url("http://viduapp.com/qy_wechat_auth_callback", Digest::MD5.hexdigest(Time.now.to_s))
    end
  end

  def callback
    if params[:code]
      @user_info = @group_client.oauth.get_user_info(params[:code], '1')
      Rails.logger.info @user_info.to_json
    end
  end

end