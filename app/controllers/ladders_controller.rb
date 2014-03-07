class LaddersController < ApplicationController
  before_action :prepare_params

  def show
    fail ActionController::RoutingError.new('Not Found') if !Region.available?(params[:id])
    @players = Ladder.new(params[:id]).find_by_page(params[:page])
  end

  private

  def prepare_params
    params[:page] = params[:page].to_i
    params[:page] = 1 if params[:page] < 1
    params[:id] = params[:id].downcase
  end
end
