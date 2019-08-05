require 'rails_helper'

describe Entity do
  describe "on_create" do
    it "create wallet" do
      [:user, :team, :stock].each do |entity_type|
        entity = create(entity_type)
        expect(user.wallet).to_not be_nil
      end
    end
  end
end
