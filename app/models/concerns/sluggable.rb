module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug

    validates :slug, presence: true, uniqueness: true
  end

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize if name.present?
  end
end
