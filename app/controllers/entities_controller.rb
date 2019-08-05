class EntitiesController < ApplicationController
  def index
    @entities = Entity.all
    api_success(@entities)
  end

  def create
    if !['User', 'Team', 'Stock'].include?(entity_params[:type])
      return api_error('Invalid entity type')
    end

    @entity = Entity.create(entity_params)
    if @entity.persisted?
      api_success
    else
      api_error(@entity)
    end
  end

  private

  def entity_params
    params.require(:entity).permit(:type, :name)
  end
end