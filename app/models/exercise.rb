class Exercise < ApplicationRecord
  extend FriendlyId
  friendly_id do |fid|
    fid.use [:history, :scoped]
    fid.scope = :track_id
  end

  belongs_to :track
  belongs_to :unlocked_by, class_name: "Exercise", optional: true

  has_many :exercise_topics
  has_many :topics, through: :exercise_topics

  has_many :unlocks, class_name: "Exercise", foreign_key: :unlocked_by_id
  has_many :solutions
  has_many :iterations, through: :solutions

  default_scope -> { order('position ASC, title ASC') }
  scope :active, -> { where(active: true) }
  scope :core, -> { where(core: true) }
  scope :side, -> { where(core: false) }

  # BETA
  def download_command
    "mentorcism download #{slug} --track=#{track.slug}"
  end

  def side?
    !core
  end

  def topic_names
    @topic_names ||= topics.pluck(:name).map(&:downcase)
  end

  def description
    ParsesMarkdown.parse(super)
  rescue
    ""
  end

  # TODO
  def white_icon_url
    super || 'tmp/exercise-icon-white.png'
  end

  # TODO
  def dark_icon_url
    super || 'tmp/exercise-icon-dark.png'
  end

  # TODO
  def turquoise_icon_url
    super || 'tmp/exercise-icon-turquoise.png'
  end

  # TODO
  def icon_url
    raise "Deprecated"
  end
end
