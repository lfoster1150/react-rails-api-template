class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def test
    render json: { message: 'Success' }, status: :ok
  end
  
end
