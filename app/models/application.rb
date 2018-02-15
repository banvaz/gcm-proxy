# == Schema Information
#
# Table name: applications
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  api_key    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Application < ApplicationRecord
  
  has_many :auth_keys, :dependent => :destroy
  has_many :notifications, :through => :auth_keys
  has_many :devices, :dependent => :destroy

  validates :name, :presence => true, :length => {:maximum => 100}
  
  scope :asc, -> { order(:name) }
  
end
