class Api::V1::ThemesController < Api::V1::BaseController
  # GET /api/v1/themes
  def index
    @themes = Theme.active.order(title: :asc)
    render json: @themes, status: :ok
  end

  # POST /api/v1/themes
  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      render json: @theme, status: :created
    else
      render json: { errors: @theme.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong Parameters
  def theme_params
    params.require(:theme).permit(:title, :description)
  end
end