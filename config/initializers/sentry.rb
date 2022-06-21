# frozen_string_literal: true
Sentry.init do |config|
  config.environment = HostingEnvironment.environment_name
  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

  config.before_send = lambda { |event, _hint| filter.filter(event.to_hash) }

  config.inspect_exception_causes_for_exclusion = true

  config.excluded_exceptions += [
    # The following exceptions are user-errors that aren't actionable, and can
    # be safely ignored.
    'ActionController::BadRequest',
    'ActionController::UnknownFormat',
    'ActionController::UnknownHttpMethod',
    'ActionDispatch::Http::Parameters::ParseError',
    'Mime::Type::InvalidMimeType',
  ]
end
