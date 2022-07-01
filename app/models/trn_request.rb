# frozen_string_literal: true
class TrnRequest < ApplicationRecord
  has_many :trn_responses, dependent: :destroy

  scope :with_zendesk_ticket, -> { where.not(zendesk_ticket_id: nil) }

  def answers_checked=(value)
    return unless value

    self.checked_at = Time.current
  end

  def itt_provider_answered?
    !itt_provider_enrolled.nil? && !itt_provider_enrolled_was.nil?
  end

  def previous_name?
    previous_first_name.present? || previous_last_name.present?
  end

  def previous_name
    [
      previous_first_name.presence || first_name,
      previous_last_name.presence || last_name
    ].join(" ")
  end

  def name
    [first_name, last_name].compact.join(" ")
  end

  def ni_number_answered?
    return ni_number.present? if has_ni_number

    !has_ni_number.nil? && !has_ni_number_was.nil?
  end
end
