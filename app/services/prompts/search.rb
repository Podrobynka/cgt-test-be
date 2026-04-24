# frozen_string_literal: true

module Prompts
  class Search < BaseService
    DEFAULT_LIMIT = 10
    DEFAULT_PAGE = 1
    MISSPELLINGS = 3

    def initialize(params = {})
      @query = params[:query]&.strip
      @limit = params[:limit] || DEFAULT_LIMIT
      @page = params[:page] || DEFAULT_PAGE
    end

    def call
      @query.presence ? fuzzy_search : base_query("*")
    end

    private

    def fuzzy_search
      base_query(@query)
        .match(:word_middle)
        .misspellings(below: MISSPELLINGS)
        .order(_score: :desc)
        .highlight(tag: '<mark class="bg-yellow-200 font-bold">')
    end

    def base_query(query)
      Prompt.search(query)
            .page(@page)
            .per_page(@limit)
    end
  end
end
