# == Schema Information
#
# Table name: auth_keys
#
#  id             :integer          not null, primary key
#  application_id :integer
#  name           :string(255)
#  key            :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_auth_keys_on_application_id  (application_id)
#

class AuthKey < ApplicationRecord
  
  belongs_to :application
  has_many :notifications, :dependent => :destroy
  has_many :devices, :dependent => :destroy
  
  validates :application_id, :presence => true
  validates :name, :presence => true, :length => {:maximum => 100}
  validates :key, :presence => true, :uniqueness => true
  
  scope :asc, -> { order(:name) }
  
  before_validation :generate_unique_key
  
  def generate_unique_key
    while self.key.blank?
      proposed_key = SecureRandom.uuid
      unless self.class.where(:key => proposed_key).exists?
        self.key = proposed_key
      end
    end
  end
  
  def touch_device(token)
    Device.touch_device(self.application, token)
  end
  
end
