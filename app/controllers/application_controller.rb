class ApplicationController < ActionController::API
  before_action :authenticate_user!, except: %i[test]

  def test
    render json: { message: 'Success' }, status: :ok
  end
  
end
