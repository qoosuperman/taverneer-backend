# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ResponseHelper
  include Authentication::HelperMethods

  class AccessDeniedError < StandardError; end

  rescue_from AccessDeniedError, with: :respond_access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :respond_not_found
  rescue_from ActiveRecord::RecordInvalid do |error|
    record_errors = error.record.errors || '儲存失敗，請檢查並完成填寫'
    render json: { message: record_errors }, status: :unprocessable_entity
  end

  rescue_from ActionController::ParameterMissing do |error|
    message = Rails.env.development? ? error.full_message : '參數錯誤'
    render json: { message: }, status: :unprocessable_entity
  end

  def respond_access_denied
    render json: { message: '由於缺少權限，無法進行此操作' }, status: :forbidden
  end

  def respond_not_found
    render json: { message: 'Not Found' }, status: :not_found
  end
end
