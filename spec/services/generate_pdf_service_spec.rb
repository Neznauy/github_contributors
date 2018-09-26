require 'rails_helper'

RSpec.describe GeneratePdfService do
  let(:service) do
    described_class.new(params)
  end

  after { Rails.cache.clear }

  describe '#call' do
    context "when retrieve first" do
      let(:params) { {source: 'hanami/hanami', position: 0} }

      before { Rails.cache.write('hanami/hanami', ["jodosha", "joneslee85", "davydovanton"]) }
      
      it do
        service.call

        text_analysis = PDF::Inspector::Text.analyze(service.file)
        expect(text_analysis.strings).to include('jodosha')
      end
    end

    context "when retrieve second" do
      let(:params) { {source: 'hanami/hanami', position: 1} }

      before { Rails.cache.write('hanami/hanami', ["jodosha", "joneslee85", "davydovanton"]) }
      
      it do
        service.call

        text_analysis = PDF::Inspector::Text.analyze(service.file)
        expect(text_analysis.strings).to include('joneslee85')
      end
    end

    context "when retrieve third" do
      let(:params) { {source: 'hanami/hanami', position: 2} }

      before { Rails.cache.write('hanami/hanami', ["jodosha", "joneslee85", "davydovanton"]) }
      
      it do
        service.call

        text_analysis = PDF::Inspector::Text.analyze(service.file)
        expect(text_analysis.strings).to include('davydovanton')
      end
    end

    context "when retrieve invalid" do
      let(:params) { {source: 'hanami/hanami', position: 1} }
      
      it do
        service.call

        expect(service.file).to be_nil
      end
    end
  end
end
