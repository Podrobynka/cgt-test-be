# frozen_string_literal: true

RSpec.describe Prompts::Search, search: true do
  describe "#call" do
    let!(:prompt1) { create(:prompt, body: SEED_PROMPT_BODIES[0]) }
    let!(:prompt2) { create(:prompt, body: SEED_PROMPT_BODIES[1]) }
    let!(:prompt3) { create(:prompt, body: SEED_PROMPT_BODIES[2]) }

    before do
      Prompt.reindex
    end

    subject { described_class.call(query: query) }

    context "with a search query" do
      let(:query) { "portrait" }

      it "returns matching prompts" do
        expect(subject.map(&:id)).to contain_exactly(prompt2.id)
      end
    end

    context "with an empty search query" do
      let(:query) { "" }

      it "returns all prompts" do
        expect(subject.map(&:id)).to contain_exactly(prompt1.id, prompt2.id, prompt3.id)
      end
    end

    context "with wildcard search query" do
      let(:query) { "*" }

      it "returns all prompts" do
        expect(subject.map(&:id)).to contain_exactly(prompt1.id, prompt2.id, prompt3.id)
      end
    end
  end
end
