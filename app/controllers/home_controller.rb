class HomeController < ApplicationController

  def initialize
    @group_client = QyWechatApi::Client.new(WECHAT_CONFIG['WECHAT_APP_ID'], WECHAT_CONFIG['WECHAT_APP_SECRET'])
  end

  def index
    # is_valid? will re-generate new token if expired.
    if @group_client.is_valid?
      redirect_to @group_client.oauth.authorize_url("http://viduapp.com/qy_wechat_auth_callback", Digest::MD5.hexdigest(Time.now.to_s))
    end
  end

  def callback
    if params[:code]
      # get_user_info need APP ID.
      user_info = @group_client.oauth.get_user_info(params[:code], '1')
      user_profile = @group_client.user.get(user_info.result[:UserId])
      Rails.logger.info user_info.to_json
      Rails.logger.info user_profile.to_json
      create_or_update user_profile
      render text: [user_info, user_profile].to_json, status: 200
    else
      render text: 'Auth failed, please try again.', status: 200
    end
  end

  private

    def create_or_update user
      user_ex = User.where(userid: user.result[:userid]).first
      qy_group_id = user.result[:department].to_a.join(',')
      if user_ex
        user_ex.update_attributes!({
           :name => user.result[:name].to_s,
           :avatar => user.result[:avatar].to_s,
           :position => user.result[:position].to_s,
           :department => qy_group_id,
           :mobile => user.result[:mobile].to_s,
           :gender => user.result[:gender].to_i,
           :email => user.result[:email].to_s,
           :status => user.result[:status].to_i
        })
      else
        user_cu = User.new({
          :userid => user.result[:userid].to_s,
          :name => user.result[:name].to_s,
          :avatar => user.result[:avatar].to_s,
          :position => user.result[:position].to_s,
          :department => qy_group_id,
          :mobile => user.result[:mobile].to_s,
          :gender => user.result[:gender].to_i,
          :email => user.result[:email].to_s,
          :weixinid => user.result[:weixinid].to_s,
          :status => user.result[:status].to_i
        })
        user_cu.save!
      end
    end

    def create_permit_attrs result
      keepers = [:userid, :name, :position, :mobile, :gender, :email, :weixinid, :status, :avatar]
      validate_res = result.keep_if {|k,_| keepers.include? k }
      validate_res
    end

    def update_permit_attrs result
      keepers = [:name, :position, :mobile, :gender, :email, :status, :avatar]
      validate_res = result.keep_if {|k,_| keepers.include? k }
      validate_res
    end

end