# PasswordResetToken represents a single-use, time-bound token used to authorize password reset
# flows for an Identity. Only usable tokens (unused and unexpired) should permit a reset.
#
# Associations:
# - belongs_to Identity
#
# Behavior:
# - .issue_for issues a new token with configurable TTL
# - #mark_used! marks the token as consumed
# - #expired? and #used? provide state checks
class PasswordResetToken < ApplicationRecord
  belongs_to :identity

  scope :usable, -> { where(used_at: nil).where("expires_at > ?", Time.current) }

  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  def self.issue_for(identity, ttl: 15.minutes)
    create!(identity: identity, token: SecureRandom.urlsafe_base64(32), expires_at: Time.current + ttl)
  end

  def used?
    used_at.present?
  end

  def expired?
    expires_at <= Time.current
  end

  def mark_used!
    update!(used_at: Time.current)
  end
end
