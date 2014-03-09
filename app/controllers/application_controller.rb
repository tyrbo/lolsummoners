class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :valid_region?

  private

  def valid_region?
    if !params[:region].nil?
      params[:region] = params[:region].downcase
      if !Region.available?(params[:region])
        fail ActionController::RoutingError.new('Not Found')
      end
    end
  end
end
