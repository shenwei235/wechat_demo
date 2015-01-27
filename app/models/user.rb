class User < ActiveRecord::Base
  belongs_to :group
  validates :userid, presence: true, uniqueness: true
  validates :weixinid, presence: true, uniqueness: true
end
