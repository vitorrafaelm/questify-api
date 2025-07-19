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
    # --- LINHAS DE DEPURAÇÃO ---
    puts "--- DECODED TOKEN PAYLOAD ---"
    puts decoded_payload.inspect
    # --- FIM DAS LINHAS DE DEPURAÇÃO ---
    
    user_id = decoded_payload[:user_id]
    
    # --- LINHAS DE DEPURAÇÃO ---
    puts "--- EXTRACTED USER ID ---"
    puts user_id.inspect
    # --- FIM DAS LINHAS DE DEPURAÇÃO ---
    
    @current_user = UserAuthorization.find(user_id)

  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Token inválido ou expirado' }, status: :unauthorized
  end
end