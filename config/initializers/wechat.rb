if Rails.env != 'qa'
  WECHAT_CONFIG = YAML.load_file("#{Rails.root}/config/wechat.yml")[Rails.env]
else
  env = ENV['HOSTBASE']
  WECHAT_CONFIG = YAML.load_file("#{Rails.root}/config/wechat.yml")[env]
end

WECHAT_CONFIG.each do |k,v| k.freeze; v.freeze end
WECHAT_CONFIG.freeze

puts 'WECHAT_CONFIG'; puts JSON.pretty_generate WECHAT_CONFIG

redis = Redis.new(host: "127.0.0.1", port: "6379")

namespace = "qy_wechat_api:redis_storage"

# cleanup keys in the current namespace when restart server everytime.
exist_keys = redis.keys("#{namespace}:*")
exist_keys.each{|key|redis.del(key)}

redis_with_ns = Redis::Namespace.new("#{namespace}", redis: redis)

QyWechatApi.configure do |config|
  config.redis = redis_with_ns
end