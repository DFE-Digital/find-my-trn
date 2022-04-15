# frozen_string_literal: true
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe DqtApi do
  before { FeatureFlag.activate(:use_dqt_api) }

  describe '.find_trn!' do
    subject(:find_trn!) { described_class.find_trn!(trn_request) }

    let(:trn_request) do
      TrnRequest.new(date_of_birth: '1990-01-01', email: 'kevin@kevin.com', first_name: 'kevin', ni_number: '1000000')
    end

    context 'with a matching TRN request', vcr: true do
      it { is_expected.to match(hash_including('trn' => '1275362')) }
      it { is_expected.to match(hash_including('emailAddresses' => ['anonymous@anonymousdomain.org.net.co.uk'])) }
      it { is_expected.to match(hash_including('firstName' => 'Kevin')) }
      it { is_expected.to match(hash_including('lastName' => 'Evans')) }
      it { is_expected.to match(hash_including('dateOfBirth' => '1990-01-01')) }
      it { is_expected.to match(hash_including('nationalInsuranceNumber' => 'AA123456A')) }
      it { is_expected.to match(hash_including('uid' => 'f7891223-7661-e411-8047-005056822391')) }
    end

    context 'when the API returns a timeout error' do
      it 'raises a timeout error' do
        VCR.turned_off do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError) # rubocop:disable RSpec/AnyInstance
          expect { find_trn! }.to raise_error(Faraday::TimeoutError)
        end
      end
    end

    context 'when the API returns multiple results', vcr: true do
      let(:trn_request) do
        TrnRequest.new(
          date_of_birth: '1990-01-01',
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Smith',
          ni_number: 'QQ123456C',
        )
      end

      it 'raises an error' do
        expect { find_trn! }.to raise_error(DqtApi::TooManyResults)
      end
    end

    context 'when the API returns no results', vcr: true do
      let(:trn_request) do
        TrnRequest.new(
          date_of_birth: '1990-01-01',
          email: 'no@results.com',
          first_name: 'No',
          last_name: 'Results',
          ni_number: 'QQ123456C',
        )
      end

      it 'raises an error' do
        expect { find_trn! }.to raise_error(DqtApi::NoResults)
      end
    end
  end
end
