# frozen_string_literal: true

class CreatePrompts < ActiveRecord::Migration[8.1]
  def change
    create_table :prompts do |t|
      t.text :body, null: false

      t.timestamps
    end
  end
end
