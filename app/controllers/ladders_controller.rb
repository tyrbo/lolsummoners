class LaddersController < ApplicationController
  def show
    fail ActionController::RoutingError.new('Not Found') if !Region.available?(params[:region].downcase)
    @players = Ladder.new(params[:region]).find_by_page(params[:page].to_i)
  end
end
