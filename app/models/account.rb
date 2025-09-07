# Account represents an end user of the site/application. It is the primary owner of login
# identities and may be associated with activation events created while authenticated.
# Accounts are identified by a unique email address.
#
# Associations:
# - has_many ActivationEvent (optional association on the event)
#
# Authentication:
# - See Identity for credential records tied to an Account
class Account < ApplicationRecord
  has_many :activation_events, dependent: :nullify

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  def display_name
    email
  end
end
