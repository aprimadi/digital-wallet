class LandingController < ApplicationController
  def index
    @entities = Entity.all
  end
end
