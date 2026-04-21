# frozen_string_literal: true

class Prompt < ApplicationRecord
  validates :body, presence: true
end
