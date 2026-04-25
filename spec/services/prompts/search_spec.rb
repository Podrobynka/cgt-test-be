# frozen_string_literal: true

RSpec.describe Prompts::Search, search: true do
  describe "#call" do
    SEED_PROMPT_BODIES.first(3).each_with_index do |body, index|
      let!("prompt#{index + 1}".to_sym) { create(:prompt, body: body) }
    end

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

      context "with multiple words" do
        let(:query) { "colorful factory" }

        it "returns empty array" do
          expect(subject.map(&:id)).to be_empty
        end

        context "and 'or' operator" do
          subject { described_class.call(query: query, operator: :or) }

          it "returns prompts matching any of the words" do
            expect(subject.map(&:id)).to contain_exactly(prompt1.id, prompt3.id)
          end
        end
      end

      context "with exclude parameter" do
        let(:query) { "style" }
        let(:exclude) { "style of" }

        subject { described_class.call(query: query, exclude: exclude) }

        it "returns prompts matching the query except prompts with the excluded word" do
          expect(subject.map(&:id)).to contain_exactly(prompt2.id)
        end
      end
    end

    context "with an empty search query" do
      let(:query) { "" }

      it "returns all prompts" do
        expect(subject.map(&:id)).to contain_exactly(*Prompt.pluck(:id))
      end
    end

    context "with wildcard search query" do
      let(:query) { "*" }

      it "returns all prompts" do
        expect(subject.map(&:id)).to contain_exactly(*Prompt.pluck(:id))
      end
    end
  end
end
