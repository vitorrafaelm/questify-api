class UserAuthorizationInteractor
  def login(user_login_params)
    email = user_login_params[:email]
    password = user_login_params[:password]

    user_authorization = UserAuthorization.find_for_database_authentication(email: email)

    raise ActiveRecord::RecordNotFound.new("Usuário não encontrado") if user_authorization.blank?
    raise ExceptionHandler::UserNotActiveError.new unless user_authorization.state == "active"

    if user_authorization.valid_password?(password)
      # Prepara a resposta para o utilizador
      response_hash = Questify::SessionSerializer.new(user_authorization).sanitized_hash
      
      # Cria um payload simples para o token, apenas com o ID
      payload = { user_id: user_authorization.id }
      jwt_token = JsonWebToken.encode(payload)

      # Adiciona o token à resposta final
      response_hash[:access_token] = jwt_token
      response_hash
    else
      raise ExceptionHandler::InvalidCredentialsError.new("Invalid password")
    end
  end

  def create_user_authorization!(user_create_params)
    # Usar um nome de variável de instância diferente para evitar confusão.
    @user_params = user_create_params
    
    user_record = nil

    ActiveRecord::Base.transaction do
      user_record = build_user_by_type
      user_record.build_user_authorization(
        email: @user_params[:email],
        password: @user_params[:password],
        state: :active
      )

      user_record.save!
    end

    user_record
  end

  private

  def build_user_by_type
    if @user_params[:user_type].to_sym == :student
      Student.new(
        name: @user_params[:name],
        institution: @user_params[:institution],
        username: @user_params.dig(:student, :username),
        document_type: @user_params[:document_type],
        document_number: @user_params[:document_number],
        grade: @user_params.dig(:student, :grade)
      )
    else
      Educator.new(
        name: @user_params[:name],
        institution: @user_params[:institution],
        document_type: @user_params[:document_type],
        document_number: @user_params[:document_number]
      )
    end
  end

end
