# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  auth_key_id :integer
#  device_id   :integer
#  pushed_at   :datetime
#  created_at  :datetime
#  data        :text(65535)
#  error       :text(65535)
#  locked      :boolean          default(FALSE)
#
# Indexes
#
#  index_notifications_on_auth_key_id  (auth_key_id)
#  index_notifications_on_device_id    (device_id)
#  index_notifications_on_pushed_at    (pushed_at)
#

class Notification < ApplicationRecord
  
  belongs_to :auth_key
  belongs_to :device

  serialize :data, Hash

  validate do
    if device
      if device.unsubscribed?
        errors.add :device, "unsubscribed"
      end
    else
      errors.add :device, "missing"
    end
  end
  
  scope :asc, -> { order(:id => :desc) }
  scope :requires_pushing, -> { where(:pushed_at => nil, :error => nil) }
  scope :unlocked, -> { where(:locked => false) }
  
  #
  # Has this been pushed?
  #
  def pushed?
    !!self.pushed_at
  end
  
  #
  # Mark as resendable
  #
  def mark_as_repushable!
    self.pushed_at = nil
    self.error = nil
    self.locked = false
    self.save!
  end
  
  #
  # Mark this notification as pushed
  #
  def mark_as_pushed!
    self.pushed_at = Time.now
    self.save!
  end
  
  #
  # Mark this notification as failed
  #
  def mark_as_failed!(error)
    self.error = error
    self.save!
    if error == "InvalidRegistration" or error == "NotRegistered"
      self.device.update_attribute(:unsubscribed_at, Time.now)
    end
  end

  #
  # Return a JSON hash for this notification
  #
  def to_hash
    {"registration_ids" => [self.device.token], "data" => self.data}
  end

  #
  # Build a new payload from the data expected from an API call
  #
  def self.build_from_payload(auth_key, payload)
    n = self.new
    n.auth_key = auth_key
    if payload[:device].is_a?(String)
      n.device = n.auth_key.touch_device(payload[:device])
    end

    n.data = payload[:data]

    n
  end
end
