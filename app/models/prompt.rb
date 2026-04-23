# frozen_string_literal: true

class Prompt < ApplicationRecord
  validates :body, presence: true
  searchkick searchable: [ :body ],
             word_middle: [ :body ],
             highlight: [ :body ]

  def search_data
    { body: body }
  end
end
