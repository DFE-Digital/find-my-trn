# frozen_string_literal: true
class DateOfBirthController < ApplicationController
  def edit; end

  def update
    if date_of_birth_form.update(date_of_birth_params)
      session[:trn_request_id] = date_of_birth_form.trn_request.id
      redirect_to date_of_birth_form.email? ? check_answers_url : have_ni_number_url
    else
      render :edit
    end
  end

  private

  def date_of_birth_form
    @date_of_birth_form ||= DateOfBirthForm.new(trn_request: trn_request)
  end
  helper_method :date_of_birth_form

  def date_of_birth_params
    params.require(:date_of_birth_form).permit('date_of_birth(3i)', 'date_of_birth(2i)', 'date_of_birth(1i)')
  end

  def trn_request
    @trn_request ||= TrnRequest.find_or_initialize_by(id: session[:trn_request_id])
  end
end
