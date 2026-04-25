# frozen_string_literal: true

RSpec.describe "Prompts", type: :request, search: true do
  describe "GET /prompts" do
    before do
      create_seed_prompts
      Prompt.reindex
    end

    subject do
      get(prompts_path, params: params)
      response
    end

    shared_examples "a successful response" do
      it "returns a successful response" do
        expect(subject).to have_http_status(:success)
      end
    end

    shared_examples "a response with required prompts" do
      it "renders correct number of prompts" do
        expect(subject.body.scan(/<li id="prompt_\d+"/).count).to eq(expected_count)
      end
    end

    context "without search query" do
      let(:params) { {} }
      let(:expected_count) { Prompt.count }

      it_behaves_like "a successful response"
      it_behaves_like "a response with required prompts"
    end

    context "with search query" do
      let(:params) { { query: "portrait" } }
      let(:expected_count) { 2 }

      it_behaves_like "a successful response"
      it_behaves_like "a response with required prompts"

      context "and strategy parameter" do
        let(:params) { { query: "portrait", strategy: :word_start } }

        it_behaves_like "a successful response"
        it_behaves_like "a response with required prompts"

        context "with a partial word query at the middle of a word" do
          let(:params) { { query: "ortraits", strategy: :word_start } }

          it_behaves_like "a successful response"

          it "displays no prompts" do
            expect(subject.body).to include("No prompts found")
          end
        end
      end

      context "and operator parameter" do
        let(:params) { { query: "colorful factory", operator: :or } }

        it_behaves_like "a successful response"
        it_behaves_like "a response with required prompts"
      end

      context "and exclude parameter" do
        let(:params) { { query: "style", exclude: "style of" } }
        let(:expected_count) { 1 }

        it_behaves_like "a successful response"
        it_behaves_like "a response with required prompts"
      end
    end

    context "with non-matching search query" do
      let(:params) { { query: "nonexistent" } }

      it_behaves_like "a successful response"

      it "returns empty results for non-matching query" do
        expect(subject.body).to include("No prompts found")
      end
    end

    context "with empty query parameter" do
      let(:params) { { query: "" } }
      let(:expected_count) { Prompt.count }

      it_behaves_like "a successful response"
      it_behaves_like "a response with required prompts"
    end

    context "with pagination" do
      let(:params) { { page: 2 } }
      let(:expected_count) { 2 }

      before { stub_const("Prompts::Search::DEFAULT_LIMIT", 2) }

      it_behaves_like "a successful response"
      it_behaves_like "a response with required prompts"

      it "renders current page number" do
        expect(subject.body).to include("aria-current=\"page\">2<\/a>")
      end

      it "renders pagination controls" do
        expect(subject.body).to include("Displaying items 3-4 of 4 in total")
      end
    end
  end
end
