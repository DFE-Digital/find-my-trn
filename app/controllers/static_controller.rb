# frozen_string_literal: true

class StaticController < ApplicationController
  layout "two_thirds"

  def accessibility
    case session[:identity_client_id]
    when "register-for-npq"
      render "register_for_npq_accessibility"
    end
  end

  def privacy
    case session[:identity_client_id]
    when "register-for-npq"
      render "register_for_npq_privacy"
    end
  end
end
