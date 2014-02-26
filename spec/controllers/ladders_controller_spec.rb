require 'spec_helper'

describe LaddersController do
  describe 'GET show' do
    it 'should return 404 for an invalid region' do
      expect {
        get :show, region: 'fake', page: 1
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
