class LaddersController < ApplicationController
  before_action :prepare_params

  def show
    @players = Ladder.new(params[:region]).find_by_page(params[:page])
  end

  private

  def prepare_params
    params[:page] = params[:page].to_i
    params[:page] = 1 if params[:page] < 1
    params[:region] = params[:region].downcase
  end
end
