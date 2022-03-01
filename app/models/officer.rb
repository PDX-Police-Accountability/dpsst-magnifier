class Officer < ApplicationRecord
  has_many :transcripts

  validates :dpsst_identifier, presence: true, uniqueness: { case_sensitive: true }
end
