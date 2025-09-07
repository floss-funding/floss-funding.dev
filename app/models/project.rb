# Project represents an open-source or software project that may publicly support a Library
# via an activation key (especially when free_for_open_source is enabled). Projects are
# ecosystem-scoped and used for attribution and badge generation.
#
# Associations:
# - has_many ActivationKey
#
# Behavior:
# - After creation, attempts to link any existing ActivationKeys that reference this name/ecosystem
class Project < ApplicationRecord
  has_many :activation_keys

  # Simple case-insensitive search by name
  scope :search, ->(q) do
    next all if q.blank?
    pattern = "%#{q.to_s.strip.downcase}%"
    where("LOWER(name) LIKE ?", pattern)
  end

  validates :name, presence: true, length: {minimum: 2, maximum: 100}
  validates :ecosystem, presence: true
  validates :name, uniqueness: {scope: :ecosystem, case_sensitive: false}

  after_create :link_matching_activation_keys

  private

  def link_matching_activation_keys
    ActivationKey.where(project_name: name, ecosystem: ecosystem).update_all(project_id: id)
  end
end
