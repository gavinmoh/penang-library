class ApplicationController < ActionController::API
  include Pundit

  rescue_from ActionController::RoutingError, with: :render_route_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from Pundit::NotAuthorizedError, with: :render_not_authorized

  before_action :set_paper_trail_whodunnit

  def render_route_not_found
    render json: {
      message: "Route not found."
    }, status: :not_found
  end

  def render_record_not_found
    render json: {
      message: "Record not found."
    }, status: :not_found
  end

  def render_unprocessable_entity_response(exception)
    render json: {
      message: "Record invalid.",
      error: exception.record.errors
    }, status: :unprocessable_entity
  end

  def render_not_authorized
    render json: {
      message: "You don't have permission to perform this action."
    }, status: :unauthorized
  end

end
