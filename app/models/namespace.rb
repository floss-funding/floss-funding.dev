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

  # Simple case-insensitive search by name
  scope :search, ->(q) do
    next all if q.blank?
    pattern = "%#{q.to_s.strip.downcase}%"
    where("LOWER(name) LIKE ?", pattern)
  end

  # Deterministic sorting based on param (matches Activation Keys page options)
  class << self
    def sort_by_param(param)
      case param.to_s
      when "old"
        order(created_at: :asc)
      when "a_z"
        order(Arel.sql("LOWER(name) ASC"))
      when "z_a"
        order(Arel.sql("LOWER(name) DESC"))
      else
        # default: new to old
        order(created_at: :desc)
      end
    end
  end

  validates :name, presence: true, length: {minimum: 1, maximum: 100}
  validates :ecosystem, presence: true
  validates :name, uniqueness: {scope: :ecosystem, case_sensitive: false}

  after_create :link_matching_activation_keys

  private

  def link_matching_activation_keys
    ActivationKey.where(namespace: name, ecosystem: ecosystem).update_all(namespace_id: id)
  end
end
