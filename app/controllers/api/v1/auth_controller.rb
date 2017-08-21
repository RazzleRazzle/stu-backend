class Api::V1::AuthController < ApplicationController
  before_action :authorize_user, only: [:show]

  def show
    render json: {
      id: current_user.id,
      email: current_user.email,
      name: current_user.name
    }
  end

  def create
    user = Seller.find_by(email: params[:email]) || Collector.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      created_jwt = issue_token({id: user.id})
      render json: {id: user.id, name: user.name, jwt: created_jwt}
    else
      render json: {
        error: 'Username or password incorrect'
      }, status: 422
    end
  end
end
