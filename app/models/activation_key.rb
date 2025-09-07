# ActivationKey represents a unique activation key issued for a specific library (and optionally a project)
# within a given package ecosystem (e.g., RubyGems, PyPI). It is the central entity recorded when
# an activation occurs. Keys are namespaced (namespace/key) and can be flagged as featured or
# free for open source, which enables badge generation linking a project to the library it supports.
#
# Associations:
# - belongs_to Namespace (as namespace_record) and Library; both required
# - belongs_to Project; optional (primarily used when free_for_open_source is enabled)
# - has_many ActivationEvent; cannot be destroyed once created
#
# Key fields (selected):
# - namespace, key: textual identity of the activation key (unique per namespace)
# - ecosystem: enumeration describing the language ecosystem for the key
# - library_name, project_name, project_url: denormalized strings used to auto-link associations
# - activation_event_count: counter cache of associated events
#
# Behavior highlights:
# - .search and .sort_by_param support simple searching/sorting in the UI
# - before_validation hooks ensure associations are created/linked from denormalized names
# - badge_markdown builds an OSS support badge when appropriate
class ActivationKey < ApplicationRecord
  has_many :activation_events, dependent: :restrict_with_error

  belongs_to :project, optional: true
  belongs_to :library, optional: false
  belongs_to :namespace_record, class_name: "Namespace", foreign_key: "namespace_id", optional: false

  include FlagShihTzu
  has_flags 1 => :featured,
    2 => :free_for_open_source

  # Named scope for non-retired records (do not use default scopes)
  scope :active, -> { where(retired: false) }

  # Simple search across common identifying fields
  scope :search, ->(q) do
    next all if q.blank?
    pattern = "%#{q.to_s.strip.downcase}%"
    where(
      "LOWER(namespace) LIKE :p OR LOWER(key) LIKE :p OR LOWER(library_name) LIKE :p OR LOWER(project_name) LIKE :p",
      p: pattern,
    )
  end

  # Deterministic sorting based on param
  class << self
    def sort_by_param(param)
      case param.to_s
      when "old"
        order(created_at: :asc)
      when "a_z"
        order(Arel.sql("LOWER(namespace) ASC, LOWER(key) ASC"))
      when "z_a"
        order(Arel.sql("LOWER(namespace) DESC, LOWER(key) DESC"))
      when "language"
        order(Arel.sql("LOWER(namespace) ASC, LOWER(key) ASC")) # 'language' sort removed; fallback to name-based
      else
        # default: new to old
        order(created_at: :desc)
      end
    end
  end

  validates :namespace, presence: true
  validates :key, presence: true, uniqueness: {scope: :namespace, case_sensitive: false}
  validates :ecosystem, presence: true
  validates :library_name, presence: true

  validates :project_name, presence: true, if: :free_for_open_source?
  validates :project_name, length: {minimum: 2, maximum: 100}, format: {with: /\A[[:alnum:]][[:alnum:] ._\-+\/]{1,99}\z/, message: "must be 2-100 characters with letters, numbers, spaces, and ._-+/"}, allow_blank: true
  validates :project_url, presence: true, if: :free_for_open_source?

  has_enumeration_for :ecosystem, with: Ecosystem, create_helpers: true, required: true

  before_validation :ensure_associations_from_names
  before_destroy :prevent_destroy

  def badge_markdown
    # Show badge only when both fields are present and OSS is enabled
    return unless free_for_open_source? && project_name.present? && project_url.present?

    label = "#{project_name} ❤️ #{library_name}"
    encoded_label = ERB::Util.url_encode(label)

    logo = badge_logo_for(ecosystem)
    # Build shields URL with logo when available
    image_url = "https://img.shields.io/badge/#{encoded_label}-brightgreen" + (logo ? "?logo=#{ERB::Util.url_encode(logo)}&logoColor=white" : "")
    alt_text = label

    "[![#{alt_text}](#{image_url})](#{project_url})"
  end

  private

  def ensure_associations_from_names
    # Namespace
    if namespace.present?
      ns = Namespace.where("LOWER(name) = ? AND ecosystem = ?", namespace.to_s.downcase, ecosystem).first || Namespace.create!(name: namespace, ecosystem: ecosystem)
      self.namespace_id = ns.id
    end

    # Library
    if library_name.present?
      lib = Library.where("LOWER(name) = ? AND ecosystem = ?", library_name.to_s.downcase, ecosystem).first || Library.create!(name: library_name, ecosystem: ecosystem)
      self.library_id = lib.id
    end

    # Project (nullable)
    if project_name.present?
      proj = Project.where("LOWER(name) = ? AND ecosystem = ?", project_name.to_s.downcase, ecosystem).first || Project.create!(name: project_name, ecosystem: ecosystem)
      self.project_id = proj.id
    elsif will_save_change_to_project_name?
      self.project_id = nil
    end
  end

  def badge_logo_for(ecosystem)
    case ecosystem.to_s
    when "ruby" then "rubygems"
    when "python" then "pypi"
    when "javascript" then "npm"
    when "php" then "packagist"
    when "perl" then "cpan"
    when "bash" then "gnubash"
    when "go" then "go"
    when "java" then "java"
    when "lua" then "lua"
    end
  end

  def prevent_destroy
    errors.add(:base, "Activation keys cannot be deleted")
    throw(:abort)
  end
end
