# ActivationEvent records an occurrence of an activation key being used, typically by an Account.
# It captures signals about the activation, such as donation intent/currency, and increments a
# counter cache on the ActivationKey. Events are immutable in the sense that they cannot be deleted.
#
# Associations:
# - belongs_to ActivationKey (required, with counter cache)
# - belongs_to Account (optional)
#
# Flags:
# - donation_affirmed: whether the user affirmed making or intending a donation
class ActivationEvent < ApplicationRecord
  belongs_to :activation_key, counter_cache: :activation_event_count
  belongs_to :account, optional: true

  include FlagShihTzu
  has_flags 1 => :donation_affirmed

  validates :activation_key, presence: true
  validates :donation_currency, presence: true

  before_destroy :prevent_destroy

  private

  def prevent_destroy
    errors.add(:base, "Activation events cannot be deleted")
    throw(:abort)
  end
end
