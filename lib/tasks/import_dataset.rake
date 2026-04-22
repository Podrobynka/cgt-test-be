# frozen_string_literal: true

namespace :import do
  desc "Import dataset from a parquet file"
  task :dataset, [ :file_path ] => :environment do |_t, args|
    require "parquet"

    file_path = args[:file_path] || "lib/data/train.parquet"

    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit(1)
    end

    table = Arrow::Table.load(file_path)

    batch_size = 1000
    rows = []

    puts "Processing #{table.n_rows} rows"

    table.each_record do |record|
      rows << { body: record["Prompt"] }

      if rows.size >= batch_size
        Prompt.insert_all(rows)
        rows.clear
      end
    end

    Prompt.insert_all(rows) unless rows.empty?

    puts "Dataset imported successfully"
  end
end
