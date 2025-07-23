class Api::V1::ThemesController < Api::V1::BaseController
  before_action :authenticate_user!

  # GET /api/v1/themes/:id
  def show
    @theme = Theme.find(params[:id])
    render json: Questify::ThemeSerializer.new(@theme).sanitized_hash, status: :ok
  end

  # GET /api/v1/themes
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    @themes = Theme.active
                   .order(title: :asc)
                   .page(page)
                   .per(per_page)

    render json: Questify::ThemeSerializer.new(@themes).sanitized_hash, status: :ok
  end

  # GET /api/v1/themes/all
  def all_themes
    @themes = Theme.active.order(title: :asc)
    render json: Questify::ThemeSerializer.new(@themes).sanitized_hash, status: :ok
  end

  # POST /api/v1/themes
  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      render json: Questify::ThemeSerializer.new(@theme).sanitized_hash, status: :created
    else
      render json: { errors: @theme.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/themes/:id
  def update
    @theme = Theme.find(params[:id])
    if @theme.update(theme_params)
      render json: Questify::ThemeSerializer.new(@theme).sanitized_hash, status: :ok
    else
      render json: { errors: @theme.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/themes/:id
  def destroy
    @theme = Theme.find(params[:id])
    if @theme.destroy
      head :no_content
    else
      render json: { errors: @theme.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong Parameters
  def theme_params
    params.permit(:title, :description)
  end
end
