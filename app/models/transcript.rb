class Transcript < ApplicationRecord
  has_one :source_transcript
  belongs_to :officer
end
