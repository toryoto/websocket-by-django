class Task < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def self.ransackable_attributes(auth_objects = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_objects = nil)
    []
  end

  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  scope :recent, -> { order(created_at: :desc)}

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end
end


#bundle exec rspec -f d spec/system/tasks_spec.rb