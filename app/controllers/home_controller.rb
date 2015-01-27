class HomeController < ApplicationController

  def initialize
    @group_client = QyWechatApi::Client.new(WECHAT_CONFIG['WECHAT_APP_ID'], WECHAT_CONFIG['WECHAT_APP_SECRET'])
  end

  def index
    if @group_client.is_valid?
      redirect_to @group_client.oauth.authorize_url("http://viduapp.com/qy_wechat_auth_callback", Digest::MD5.hexdigest(Time.now.to_s))
    end
  end

  def callback
    if params[:code] && @group_client.is_valid?
      Rails.logger.info params[:code]
      @user_info = @group_client.oauth.get_user_info(params[:code], '1')
      Rails.logger.info @user_info["result"]["UserId"]
      @user_profile = @group_client.user.get(@user_info["result"]["UserId"])
      Rails.logger.info @user_info.to_json
      Rails.logger.info @user_profile.to_json
      render text: [@user_info, @user_pofile].to_json, status: 200
    end
  end

end