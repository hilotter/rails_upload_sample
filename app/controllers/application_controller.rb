class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from Exception,      with: :render_500
  rescue_from ArgumentError,  with: :render_400

  private

  def render_400(e = nil)
    error_handler(400, e ? e.message : nil)
  end

  def render_500(e = nil)
    if e
      logger.error "Rendering 500 with exception: #{e.message}"
    end
    error_handler(500)
  end

  def error_handler(code, response = '')
    render json: {
      message: response
    }, status: code
  end
end
