class Api::V1::BaseController < ActionController::API
  attr_reader :current_user

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    unless token
      render json: { error: 'Token não fornecido' }, status: :unauthorized
      return
    end

    decoded_payload = JsonWebToken.decode(token)

    user_identifier = decoded_payload[:user][:identifier]

    @current_user = UserAuthorization.find_by(identifier: user_identifier)

  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Token inválido ou expirado' }, status: :unauthorized
  end
end
