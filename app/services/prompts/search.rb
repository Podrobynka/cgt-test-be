# frozen_string_literal: true

module Prompts
  class Search < BaseService
    DEFAULT_LIMIT = 10
    DEFAULT_PAGE = 1
    MISSPELLINGS_BELOW_POINT = 3
    OPERATORS = %i[and or].freeze

    HIGHLIGHT_OPTIONS = {
      tag: '<mark class="bg-yellow-200 font-bold">',
      fields: { body: { number_of_fragments: 0 } }
    }.freeze

    STRATEGIES = %i[
      word_middle
      word_start
      word
    ].freeze

    def initialize(params = {})
      @query = params[:query]&.strip
      @limit = params[:limit] || DEFAULT_LIMIT
      @page = params[:page] || DEFAULT_PAGE
      @strategy = params[:strategy]&.to_sym.presence_in(STRATEGIES) || STRATEGIES.first
      @operator = params[:operator]&.to_sym.presence_in(OPERATORS) || OPERATORS.first
    end

    def call
      return base_query("*") unless @query.present?

      base_query(@query, **query_options)
    end

    private

    def base_query(query, **query_options)
      Prompt.search(query, **query_options)
            .select(:body)
            .page(@page)
            .per_page(@limit)
    end

    def query_options
      {
        match: @strategy,
        misspellings: { below: MISSPELLINGS_BELOW_POINT },
        highlight: HIGHLIGHT_OPTIONS,
        order: { _score: :desc },
        operator: @operator
      }.compact
    end
  end
end
