class LaddersController < ApplicationController
  def show
    @ladder = Ladder.new(page: page, region: region).fetch
  end

  private

  def page
    params.fetch(:page, 1)
  end

  def region
    params.fetch(:region, "all")
  end
end
