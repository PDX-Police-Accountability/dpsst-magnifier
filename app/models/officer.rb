class Officer < ApplicationRecord
  has_many :transcripts

  validates_presence_of :dpsst_identifier
end
