# frozen_string_literal: true

class Prompt < ApplicationRecord
  searchkick

  validates :body, presence: true
end
