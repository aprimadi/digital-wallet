require 'rails_helper'

describe ApplicationController do
  describe '#json_for' do
    it 'returns correct json serialization' do
      entity = create(:user)
      json = controller.json_for(entity)
      parsed_json = JSON.parse(json)
      expect(parsed_json['id']).to eq entity.id
      expect(parsed_json['type']).to eq 'User'
      expect(parsed_json['name']).to eq entity.name
      expect(parsed_json['balance']).to eq 0
      expect(Set.new(parsed_json.keys)).to eq Set.new(['id', 'type', 'name', 'balance'])
    end
  end
end