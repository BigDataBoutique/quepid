# frozen_string_literal: true

class SecureController < ApplicationController
  force_ssl if: :ssl_enabled?
  skip_before_action :require_login

  def index
    @user_decorator = CurrentUserDecorator.new current_user
  end
  
  # Call this API endpoint to test this service is up
  # @return 200 if successful
  def healthz
    head 200
  end
end
