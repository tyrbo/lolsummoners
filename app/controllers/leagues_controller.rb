class LeaguesController < ApplicationController
  def show
    @league = League.id_and_region(params[:id], params[:region]).first
  end
end
