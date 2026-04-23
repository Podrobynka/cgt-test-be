# frozen_string_literal: true

class PromptsController < ApplicationController
  # GET /prompts or /prompts.json
  def index
    @query = params[:q]

    @prompts = Prompts::Search.call(query: @query)
  end
end
