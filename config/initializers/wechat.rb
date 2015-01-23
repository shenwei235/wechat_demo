if Rails.env != 'qa'
  WECHAT_CONFIG = YAML.load_file("#{Rails.root}/config/wechat.yml")[Rails.env]
else
  env = ENV['HOSTBASE']
  WECHAT_CONFIG = YAML.load_file("#{Rails.root}/config/wechat.yml")[env]
end

WECHAT_CONFIG.each do |k,v| k.freeze; v.freeze end
WECHAT_CONFIG.freeze