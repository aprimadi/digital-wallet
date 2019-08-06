require 'rails_helper'

describe LandingController do
  describe 'GET index' do
    it 'returns all entities' do
      user = create(:user)
      team = create(:team)
      stock = create(:stock)

      get :index

      expect(response.status).to eq 200
      expect(assigns(:entities).to_a).to eq [user, team, stock]
    end
  end
end