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
        expect(subject.body.scan(/<li class="shadow-md p-2">/).count).to eq(Prompt.count)
      end
    end

    context "with search query" do
      let(:params) { { q: "portrait" } }

      it "returns a successful response" do
        expect(subject).to have_http_status(:success)
      end

      it "filters prompts via Searchkick" do
        expect(subject.body.scan(/<li class="shadow-md p-2">/).count).to eq(2)
      end
    end

    context "with non-matching search query" do
      let(:params) { { q: "nonexistent" } }

      it "returns empty results for non-matching query" do
        expect(subject.body).to include("No prompts found")
      end
    end

    context "with empty query parameter" do
      let(:params) { { q: "" } }

      it "renders all prompts" do
        expect(subject.body.scan(/<li class="shadow-md p-2">/).count).to eq(Prompt.count)
      end
    end
  end
end
