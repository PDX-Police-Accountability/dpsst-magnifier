class Transcript < ApplicationRecord
  has_one :source_transcript
  belongs_to :officer

  accepts_nested_attributes_for :source_transcript
end
