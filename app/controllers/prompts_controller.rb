# frozen_string_literal: true

class PromptsController < ApplicationController
  # GET /prompts or /prompts.json
  def index
    @query = params[:q].to_s.strip

    @prompts = if @query.present?
      Prompt.search(
        @query,
        fields: [ :body ],
        match: :word_middle,
        misspellings: { below: 3 },
        load: true,
        order: { _score: :desc },
        limit: 10,
        select: :body
      )
    else
      Prompt.limit(10)
    end
  end
end
