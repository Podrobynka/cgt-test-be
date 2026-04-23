# frozen_string_literal: true

module Prompts
  class Search < BaseService
    def initialize(params = {})
      @query = params[:query]&.strip
      @limit = params[:limit] || 10
    end

    def call
      @query.presence ? fuzzy_search : base_query("*")
    end

    private

    def fuzzy_search
      base_query(@query)
        .match(:word_middle)
        .misspellings(below: 3)
        .order(_score: :desc)
        .highlight(tag: '<mark class="bg-yellow-200 font-bold">')
    end

    def base_query(query)
      Prompt.search(query)
            .limit(@limit)
            .load(true)
    end
  end
end
