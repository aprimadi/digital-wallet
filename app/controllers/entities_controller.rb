class EntitiesController < ApplicationController
  def index
    @entities = Entity.all
    api_success(@entities)
  end

  def create
    @entity = Entity.create(entity_params)
    api_success
  end

  private

  def entity_params
    params.require(:entity).permit(:type, :name)
  end
end