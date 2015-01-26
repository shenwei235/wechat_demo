class OmniauthWechatCallbacksController < ApplicationController

  def failure
    puts "xxxxx"
    puts request.headers
    puts request.env["omniauth.auth"]
    puts "xxxxx"
    # redirect_to "/qy_apps"
  end

end
