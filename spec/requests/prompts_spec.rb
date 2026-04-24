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

    context "without search query" do
      let(:params) { {} }

      it "returns a successful response" do
        expect(subject).to have_http_status(:success)
      end

      it "renders all prompts" do
        expect(subject.body.scan(/<li id="prompt_\d+"/).count).to eq(Prompt.count)
      end
    end

    context "with search query" do
      let(:params) { { query: "portrait" } }

      it "returns a successful response" do
        expect(subject).to have_http_status(:success)
      end

      it "displays matching prompts" do
        expect(subject.body.scan(/<li id="prompt_\d+"/).count).to eq(2)
      end
    end

    context "with search query and strategy parameter" do
      let(:params) { { query: "portrait", strategy: :word_start } }

      it "returns a successful response" do
        expect(subject).to have_http_status(:success)
      end

      it "displays matching prompts" do
        expect(subject.body.scan(/<li id="prompt_\d+"/).count).to eq(2)
      end

      context "with a partial word query at the middle of a word" do
        let(:params) { { query: "ortraits", strategy: :word_start } }

        it "displays no prompts" do
          expect(subject.body).to include("No prompts found")
        end
      end
    end

    context "with non-matching search query" do
      let(:params) { { query: "nonexistent" } }

      it "returns empty results for non-matching query" do
        expect(subject.body).to include("No prompts found")
      end
    end

    context "with empty query parameter" do
      let(:params) { { query: "" } }

      it "renders all prompts" do
        expect(subject.body.scan(/<li id="prompt_\d+"/).count).to eq(Prompt.count)
      end
    end

    context "with pagination" do
      let(:params) { { page: 2 } }

      before { stub_const("Prompts::Search::DEFAULT_LIMIT", 2) }

      it "renders prompts for the second page" do
        expect(subject.body.scan(/<li id="prompt_\d+"/).count).to eq(2)
      end

      it "renders current page number" do
        expect(subject.body).to include("aria-current=\"page\">2<\/a>")
      end

      it "renders pagination controls" do
        expect(subject.body).to include("Displaying items 3-4 of 4 in total")
      end
    end
  end
end
