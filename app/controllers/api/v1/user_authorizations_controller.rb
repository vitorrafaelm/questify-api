class Api::V1::UserAuthorizationsController < ApplicationController

  before_action :set_interator

  # Post /api/v1/user_authorization/login
  def login
    user_login_params = user_authorization_login_params.to_h.with_indifferent_access
    user  = @interactor.login(user_login_params)

    render json: user, status: :created
  end

  # Post /api/v1/user_authorization
  def create
    user_create_params = user_authorization_params_create.to_h.with_indifferent_access

    user = @interactor.create_user_authorization!(user_create_params)
    render json: user.to_json, status: :created
  end

  private

  def set_interator
    @interactor ||= UserAuthorizationInteractor.new
  end

  def user_authorization_params_create
    params.permit(
      :email,
      :password,
      :user_type,
      :document_number,
      :document_type,
      :institution,
      :name,
      student: [:grade, :username]
    )
  end

  def user_authorization_login_params
    params.permit(
      :email,
      :password
    )
  end

end
