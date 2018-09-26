require 'rails_helper'

RSpec.describe GetContributorsService do
  let(:service) do
    described_class.new(params)
  end

  describe '#call' do
    context "when valid params" do
      let(:params) { {contributors: {str: 'hanami/hanami'}} }

      it do
        service.call

        expect(service.error).to be_nil
        expect(service.value[:source]).to eq 'hanami/hanami'
        expect(service.value[:result]).to eq ["jodosha", "joneslee85", "davydovanton"]
        expect(Rails.cache.read('hanami/hanami')).to eq ["jodosha", "joneslee85", "davydovanton"]
      end
    end

    context "when invalid params" do
      let(:params) { {contributors: {str: 'hanami/hanami222'}} }

      it do
        service.call

        expect(service.error).to eq "Not Found"
        expect(service.value).to be_nil
        expect(Rails.cache.read('hanami/hanami222')).to be_nil
      end
    end
  end
end
