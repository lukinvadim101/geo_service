module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
  end

  private

  def record_not_found(error)
    render json: { error: 'Record not found', message: error.full_message }, status: :not_found
  end

  def parameter_missing(error)
    render json: { error: 'Missing parameter', message: error.full_message }, status: :unprocessable_entity
  end

  def faraday_error(error)
    render json: { error: 'Error fetching data', message: error.full_message }, status: :unprocessable_entity
  end
end
