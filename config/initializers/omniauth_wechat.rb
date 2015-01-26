Rails.application.config.middleware.use OmniAuth::Builder do
  puts WECHAT_CONFIG
  provider :wechat, WECHAT_CONFIG["WECHAT_APP_ID"], WECHAT_CONFIG["WECHAT_APP_SECRET"]
end