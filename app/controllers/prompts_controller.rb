# frozen_string_literal: true

class PromptsController < ApplicationController
  # GET /prompts or /prompts.json
  def index
    @query = search_params[:query]
    @prompts = Prompts::Search.call(search_params)
    @pagy = pagy(:searchkick, @prompts)
  end

  private

  def search_params
    params.permit(:query, :page, :strategy, :operator)
  end
end
