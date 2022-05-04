# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PerformanceAlertJob, type: :job do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    before { allow(SlackClient).to receive(:create_message) }

    context 'when there have been TRN requests in the last 7 days' do
      before { create(:trn_request) }

      it 'sends the latest performance data as a Slack message' do
        perform
        expect(SlackClient).to have_received(:create_message).with(
          'There have been 1 TRN request started in the last 7 days on https://find-a-lost-trn.education.gov.uk/performance',
        )
      end
    end

    context 'when there have been no TRN requests in the last 7 days' do
      it 'sends the latest performance data as a Slack message' do
        perform
        expect(SlackClient).to have_received(:create_message).with(
          'There have been 0 TRN requests started in the last 7 days on https://find-a-lost-trn.education.gov.uk/performance',
        )
      end
    end
  end
end
