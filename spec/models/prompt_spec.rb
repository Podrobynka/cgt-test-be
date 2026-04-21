# frozen_string_literal: true

require "rails_helper"

RSpec.describe Prompt, type: :model do
  describe "validations" do
    let(:prompt) { build(:prompt) }

    it { should validate_presence_of(:body) }
  end
end
