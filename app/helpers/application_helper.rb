# frozen_string_literal: true

module ApplicationHelper
  def back_link_url(back = url_for(:back))
    if session[:form_complete] && [check_answers_path, itt_provider_path].exclude?(request.path)
      return check_answers_path
    end

    back
  end

  def pretty_ni_number(ni_number)
    ni_number.scan(/..?/).join(' ').upcase
  end

  def current_namespace
    section = request.path.split('/').second
    section == 'support' ? 'support_interface' : 'find_interface'
  end

  # S-oftly hy-phenated email
  # john     .doe     @digital     .education     .gov     .uk ->
  # john&shy;.doe&shy;@digital&shy;.education&shy;.gov&shy;.uk
  #
  # We're using `sanitize`, so `html_safe` should be okay here.
  # rubocop:disable Rails/OutputSafety
  def shy_email(email)
    sanitize(email).scan(/\W?\w+/).join('&shy;').html_safe
  end

  # rubocop:enable Rails/OutputSafety

  # 1234567 -> '1,234,567'
  def number_with_delimiter(number)
    number.to_s.chars.reverse.each_slice(3).map(&:join).join(',').reverse
  end
end
