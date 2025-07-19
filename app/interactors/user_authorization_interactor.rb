class UserAuthorizationInteractor
  def login(user_login_params)
    email = user_login_params[:email]
    password = user_login_params[:password]

    user_authorization = UserAuthorization.find_for_database_authentication(email: email)

    raise ActiveRecord::RecordNotFound.new("Usuário não encontrado") if user_authorization.blank?
    raise ExceptionHandler::UserNotActiveError.new unless user_authorization.state == "active"

    if user_authorization.valid_password?(password)
      user_serialized = Questify::SessionSerializer.new(user_authorization).sanitized_hash
      jwt_token = JWT.encode(user_serialized, Rails.application.secret_key_base, 'HS256')

      user_serialized[:access_token] = jwt_token
      user_serialized
    else
      raise ExceptionHandler::InvalidCredentialsError.new("Invalid password")
    end
  end

  def create_user_authorization!(user_create_params)!
    @user = user_create_params

    ActiveRecord::Base.transaction do
      user = create_user_by_type
      @user = save_user_authorization(user)
    end

    @user
  end

  private

  def create_user_by_type
    user_created = nil

    if @user[:user_type].to_sym == :student
      user_created = Student.create!(
        name: @user[:name],
        institution: @user[:institution],
        username: @user.dig(:student, :username),
        document_type: @user[:document_type],
        document_number: @user[:document_number],
        grande: @user.dig(:student, :grade)
      )
      return user_created
    end

    user_created = Educator.create!(
      name: @user[:name],
      institution: @user[:institution],
      document_type: @user[:document_type],
      document_number: @user[:document_number],
    )
  end

  def save_user_authorization(user)
    user_authorization = UserAuthorization.create!(
      email: @user[:email],
      user_authorizable_type: user.class.name,
      user_authorizable_id: user.id,
      password: @user[:password],
    )

    if user_authorization.save
      user_authorization.activate!
      user_authorization
    else
      raise ActiveRecord::Rollback, "Failed to save UserAuthorization"
    end
  end

end
