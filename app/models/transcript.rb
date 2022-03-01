class Transcript < ApplicationRecord
  has_one :source_transcript, dependent: :destroy
  belongs_to :officer

  accepts_nested_attributes_for :source_transcript

  validates :scraped_on, presence: true
end
