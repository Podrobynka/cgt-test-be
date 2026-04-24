# frozen_string_literal: true

class Prompt < ApplicationRecord
  validates :body, presence: true
  searchkick searchable: [ :body ],
             word: [ :body ],
             word_start: [ :body ],
             word_middle: [ :body ],
             highlight: [ :body ],
             deep_paging: true

  def search_data
    { body: body }
  end
end
