module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from StandardError, with: :handle_exception
  end

  private

  def handle_exception(error)
    logger.error { "#{error}: #{error.message}" }
    logger.error error.backtrace.join("\n")

    render json: { error: 'An unexpected error occurred', message: error.full_message }, status: :internal_server_error
  end

  def record_not_found(error)
    render json: { error: 'Record not found', message: error.full_message }, status: :not_found
  end

  def parameter_missing(error)
    render json: { error: 'Missing parameter', message: error.full_message }, status: :unprocessable_entity
  end
end
