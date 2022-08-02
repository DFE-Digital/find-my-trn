# frozen_string_literal: true
class HaveTrnForm
  include ActiveModel::Model
  include LogErrors

  attr_accessor :has_trn

  validates :has_trn, inclusion: { in: %w[true false] }

  def has_trn?
    ActiveModel::Type::Boolean.new.cast(has_trn)
  end

  def trn_request
    TrnRequest.new
  end

  def valid?
    super.tap { |result| log_errors unless result }
  end
end
