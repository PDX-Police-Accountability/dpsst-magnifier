class SourceTranscript < ApplicationRecord
  belongs_to :transcript

  serialize :data_hash, Hash
end
