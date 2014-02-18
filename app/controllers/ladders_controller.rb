class LaddersController < ApplicationController
  def show
    @players = Ladder.new(params[:region]).find_by_page(params[:page])
  end
end
