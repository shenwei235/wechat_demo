class OmniauthWechatCallbacksController < ApplicationController

  def failure
    puts request.headers
    puts request.env["omniauth.auth"]
    redirect_to "/qy_apps"
  end

end
