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
        select: :body,
        highlight: { tag: '<mark class="bg-yellow-200 font-bold">' }
      )
    else
      Prompt.limit(10)
    end
  end
end
