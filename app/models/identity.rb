# Identity represents login credentials (email/password, via OmniAuth Identity) for an Account.
# The Account is the user entity; Identity stores the authenticatable fields and is linked to the
# Account. The auth_key is the email.
#
# Associations:
# - belongs_to Account
class Identity < OmniAuth::Identity::Models::ActiveRecord
  self.table_name = "identities"

  auth_key :email

  belongs_to :account

  validates :email, presence: true, uniqueness: {case_sensitive: false}
end
