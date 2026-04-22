# frozen_string_literal: true

RSpec.describe Prompt, type: :model, search: true do
  before { Prompt.reindex }

  describe "validations" do
    let(:prompt) { build(:prompt, :reindex) }

    it { should validate_presence_of(:body) }
  end

  describe "search" do
    let!(:prompt) { create(:prompt) }

    before do
      create_seed_prompts
      Prompt.search_index.refresh
    end

    subject { Prompt.search("d&d sci fi") }

    it "returns the correct results" do
      expect(subject.map(&:body)).to contain_exactly(prompt.body)
    end
  end
end
