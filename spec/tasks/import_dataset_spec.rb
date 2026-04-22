# frozen_string_literal: true

RSpec.describe "import:dataset", type: :task do
  subject { Rake::Task["import:dataset"].invoke(file_path) }

  before do
    Rake::Task["import:dataset"].reenable
  end

  let(:batch_size) { 3 }

  subject { Rake::Task["import:dataset"].invoke(file_path, batch_size) }

  context "when file exists" do
    let(:file_path) { "spec/fixtures/data/test_dataset.parquet" }

    it "creates prompts" do
      expect { subject }.to change(Prompt, :count).by(5)
    end
  end

  context "when file does not exist" do
    let(:file_path) { "spec/fixtures/data/unexistent.parquet" }

    it "raises an error" do
      expect { subject }.to raise_error(SystemExit)
    end
  end
end
