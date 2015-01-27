class Group < ActiveRecord::Base
  has_many :users
  validates :qy_group_id, presence: true
end
