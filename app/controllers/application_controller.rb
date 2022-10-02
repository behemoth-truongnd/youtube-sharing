class ApplicationController < ActionController::Base
  include Pagy::Backend

  private

  def set_current_user
    Current.user = current_user
  end
end
