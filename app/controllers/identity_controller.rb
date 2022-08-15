# frozen_string_literal: true
class IdentityController < ApplicationController
  skip_forgery_protection

  include EnforceQuestionOrder

  def create
    unless FeatureFlag.active?(:identity_open)
      raise IdentityEndpointOffError,
            "Could not access the get an identity endpoint because the " \
              ":identity_open feature flag is off"
    end

    unless valid_identity_params?
      raise IdentityDataError,
            "Could not continue because the " \
              "data from Identity was unable to be verified"
    end

    # To allow initial testing with the Identity server - seed a new TrnRequest
    # with fake user data and add it to the session
    @trn_request =
      TrnRequest.create!(
        awarded_qts: false,
        first_name: "Kevin",
        email: "kevin.e@example.com",
        from_get_an_identity: true,
        itt_provider_enrolled: false,
        last_name: "E",
        ni_number: "AA123456A",
        has_ni_number: true,
        date_of_birth: Date.parse("1990-01-01")
      )

    session[:trn_request_id] = @trn_request.id

    redirect_requests_from_identity
  end

  private

  def allowed_create_params
    params.permit(:email, :redirect_uri, :client_title, :journey_id, :sig)
  end

  # Compare the signature provided by Identity with the signature calcuated
  # using the recieved params. If they match then data has not been tampered with.
  def valid_identity_params?
    return false if expected_signature.blank? || new_signature.blank?

    expected_signature.upcase == new_signature.upcase
  end

  # Retrieve the list of params required for the paramater check. The keys
  # must be in alphabetical order.
  def sorted_identity_params
    params_without_signature = allowed_create_params.except("sig")

    params_without_signature.to_hash.sort
  end

  # Encode each of the hash values and return a url paramter string, url_encode ensures
  # spaces are encoded as '%20' rather than '+' to match the encoding used by Identity.
  # Skip the email attribute to avoid encoding the '@' character.
  def encoded_identity_params
    encoded_params =
      sorted_identity_params.flat_map do |k, v|
        encoded_value = k == "email" ? v : ERB::Util.url_encode(v)
        "#{k}=#{encoded_value}"
      end

    encoded_params.join("&")
  end

  # Retrieve the signature provided by Identity
  def expected_signature
    allowed_create_params.key?("sig") ? allowed_create_params["sig"] : ""
  end

  # Calculate a new signature from the params supplied by Identity
  def new_signature
    digest = OpenSSL::Digest.new("sha256")
    OpenSSL::HMAC.hexdigest(
      digest,
      ENV["IDENTITY_SHARED_SECRET_KEY"],
      encoded_identity_params
    )
  end

  class IdentityEndpointOffError < StandardError
  end

  class IdentityDataError < StandardError
  end
end
