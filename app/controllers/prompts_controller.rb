# frozen_string_literal: true

class PromptsController < ApplicationController
  # GET /prompts or /prompts.json
  def index
    @prompts = Prompt.all
  end
end
