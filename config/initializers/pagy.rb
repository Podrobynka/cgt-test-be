# frozen_string_literal: true

Pagy::OPTIONS[:adapter] = :searchkick
Pagy::OPTIONS[:limit] = 10
Pagy::OPTIONS.freeze

Searchkick.extend Pagy::Search
