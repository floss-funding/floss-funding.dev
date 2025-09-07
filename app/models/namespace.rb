# Namespace represents the owner scope or organization part of an activation key, paired with a key
# to form a unique identifier (namespace/key) within an ecosystem. It typically maps to an
# organization, account, or publisher in the package registry.
#
# Associations:
# - has_many ActivationKey
#
# Behavior:
# - After creation, attempts to link any existing ActivationKeys that reference this name/ecosystem
class Namespace < ApplicationRecord
  has_many :activation_keys

  validates :name, presence: true, length: {minimum: 1, maximum: 100}
  validates :ecosystem, presence: true
  validates :name, uniqueness: {scope: :ecosystem, case_sensitive: false}

  after_create :link_matching_activation_keys

  private

  def link_matching_activation_keys
    ActivationKey.where(namespace: name, ecosystem: ecosystem).update_all(namespace_id: id)
  end
end
