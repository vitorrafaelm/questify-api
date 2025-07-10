class Api::V1::BaseController < ActionController::API
  before_action :authenticate_user!

  private

  attr_reader :current_user

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    unless token
      render json: { error: 'Token não fornecido' }, status: :unauthorized
      return
    end

    decoded_payload = JsonWebToken.decode(token)
    # Encontra o UserAuthorization pelo ID que está dentro do token
    @current_user = UserAuthorization.find(decoded_payload[:id])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Token inválido ou expirado' }, status: :unauthorized
  end
end