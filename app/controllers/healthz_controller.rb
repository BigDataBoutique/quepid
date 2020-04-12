# frozen_string_literal: true

class HealthzController < ApplicationController
  skip_before_action :require_login

  # Call this API endpoint to test this service is up
  # @return 200 if successful
  def index
    head 200
  end
end
