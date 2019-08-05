require 'rails_helper'

describe EntitiesController do
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

  describe 'POST create' do
    it 'creates entities successfully' do
      test_cases = [
        { type: 'User', name: 'Armin' },
        { type: 'Team', name: 'HCL Holding' },
        { type: 'Stock', name: 'AAPL' },
      ]
      test_cases.each do |tc|
        post :create, {
          params: {
            entity: {
              type: tc[:type],
              name: tc[:name]
            }
          }
        }

        expect(response.status).to eq 200
        expect(Entity.find_by(name: tc[:name])).to_not be_nil
      end
    end

    it 'does not allow creation of entity without name' do
      test_cases = [
        { type: 'User' },
        { type: 'User', name: '' },
      ]
      test_cases.each do |tc|
        post :create, { params: { entity: tc } }

        expect(response.status).to eq 400
        expect(Entity.count).to eq 0
      end
    end

    it 'does not allow creation of entity with type other than User, Team, and Stock' do
      test_cases = [
        { type: 'Company', name: 'BCI Holdings' },
        { type: ' Team', name: 'Manchester United' },
        { type: 'User ', name: 'John Doe' },
        { type: '', name: 'Wahyu' },
        { name: 'Zero Cool' },
      ]
      test_cases.each do |tc|
        post :create, { params: { entity: tc } }

        expect(response.status).to eq 400
        expect(Entity.count).to eq 0
      end
    end
  end
end