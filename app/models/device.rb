# == Schema Information
#
# Table name: devices
#
#  id                        :integer          not null, primary key
#  application_id            :integer
#  token                     :string(255)
#  usage                     :integer          default(0)
#  last_sent_notification_at :datetime
#  unsubscribed_at           :datetime
#  created_at                :datetime
#  last_registered_at        :datetime
#  label                     :string(255)
#
# Indexes
#
#  index_devices_on_auth_key_id  (application_id)
#

class Device < ActiveRecord::Base
  
  belongs_to :application
  has_many :notifications, :dependent => :destroy
  
  validates :application_id, :presence => true
  validates :token, :presence => true
  
  def unsubscribed?
    !!unsubscribed_at
  end
  
  def self.touch_device(application, token)
    device = self.where(:application_id => application.id, :token => token).first
    if device.nil?
      device = self.new
      device.application = application
      device.token = token
      device.last_registered_at = Time.now
    end
    device.usage += 1
    device.last_sent_notification_at = Time.now
    device.save!
    device
  end
  
end
