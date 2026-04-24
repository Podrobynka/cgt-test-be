# frozen_string_literal: true

RSpec.describe Prompts::Search, search: true do
  describe "#call" do
    let!(:prompt1) { create(:prompt, body: SEED_PROMPT_BODIES[0]) }
    let!(:prompt2) { create(:prompt, body: SEED_PROMPT_BODIES[1]) }
    let!(:prompt3) { create(:prompt, body: SEED_PROMPT_BODIES[2]) }

    before { Prompt.reindex }

    subject { described_class.call(query: query) }

    context "with a search query" do
      let(:query) { "potrait" }

      it "returns almost matching prompt" do
        expect(subject.map(&:id)).to contain_exactly(prompt2.id)
      end

      it "returns matching prompts with highlights" do
        expect(subject.first.search_highlights[:body]).to include('<mark class="bg-yellow-200 font-bold">potrait</mark>')
      end

      context "with one extra letter" do
        let(:query) { "portrait" }

        it "returns almost matching prompt" do
        expect(subject.map(&:id)).to contain_exactly(prompt2.id)
        end
      end

      context "with misspelled word" do
        let(:query) { "portraits" }

        it "returns empty array" do
          expect(subject.map(&:id)).to be_empty
        end
      end

      context "when :word_start strategy is used" do
        subject { described_class.call(query: query, strategy: :word_start) }

        context "with a partial word query at the beginning of a word" do
          let(:query) { "potrai" }

          it "returns matching prompts" do
            expect(subject.map(&:id)).to contain_exactly(prompt2.id)
          end
        end

        context "with a partial word query at the middle of a word" do
          let(:query) { "ortrait" }

          it "returns empty array" do
            expect(subject.map(&:id)).to be_empty
          end
        end
      end

      context "when :word strategy is used" do
        subject { described_class.call(query: query, strategy: :word) }

        context "with almost matching word query" do
          let(:query) { "portraits" }

          it "returns matching prompts" do
            expect(subject.map(&:id)).to contain_exactly(prompt2.id)
          end
        end

        context "with a partial word query at the middle of a word" do
          let(:query) { "ortrai" }

          it "returns empty array" do
            expect(subject.map(&:id)).to be_empty
          end
        end
      end
    end

    context "with an empty search query" do
      let(:query) { "" }

      it "returns all prompts" do
        expect(subject.map(&:id)).to contain_exactly(prompt3.id, prompt1.id, prompt2.id)
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
