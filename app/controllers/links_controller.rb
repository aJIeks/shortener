class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  include Authentificator

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  def angular
    render text: '', layout: 'application'
  end

  # GET /links/1
  # GET /links/1.json
  def show

  end

  def shorten
    require_oauth! unless params[:url].to_s.match(/(?:.*)?\.?vmp\.(?:ru|az|io)\/?/)
    key = authorized? ? params[:key] : nil
    @link = Link.new url: params.fetch(:url), key: key

    render_link
  rescue KeyError
    render text: '', status: :unprocessable_entity
  rescue UnAuthorized
    respond_to do |format|
      format.json { render json: { message: ['You can not short this url.']}, status: :forbidden }
    end
  end

  # POST /links
  # POST /links.json
  def create
    require_oauth! unless link_params[:url].to_s.match(/(?:.*)?\.?vmp\.(?:ru|az|io)\/?/)

    @link = Link.new(link_params)

    render_link
  rescue ActionController::ParameterMissing
    respond_to do |format|
      format.json { render text: '', status: :unprocessable_entity }
    end
  rescue UnAuthorized
    respond_to do |format|
      format.json { render json: { message: ['You can not short this url.']}, status: :forbidden }
    end
  end

  def link
    @link = Link.where(key: params[:key]).limit(1).first

    return render text: '', status: :not_found unless @link
    @link.track env
    redirect_to @link.url, status: :permanent_redirect
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def render_link
      if !@link.valid? && @link.errors.include?(:digest)
        @link = Link.where(digest: @link[:digest]).first
      end

      respond_to do |format|
        if @link.save
          format.json { render :show, status: :created, location: shorted_url(@link.key) }
        else
          format.json { render json: { message: @link.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def set_link
      id = params[:id]
      if is.to_i > 0
        @link = Link.find(id)
      else
        @link = Link.find_by_key(id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      authorized? ? params.require(:link).permit(:url, :key) : params.require(:link).permit(:url)
    end
end
