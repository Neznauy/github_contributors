require 'rails_helper'

RSpec.describe GenerateZipService do
  let(:service) do
    described_class.new(params)
  end

  after { Rails.cache.clear }

  describe '#call' do
    context "when retrieve valid" do
      let(:params) { {source: 'hanami/hanami'} }

      before { Rails.cache.write('hanami/hanami', ["jodosha", "joneslee85", "davydovanton"]) }
      
      it do
        service.call

        Zip::InputStream.open(StringIO.new(service.file)) do |io|
          while (entry = io.get_next_entry)
            expect(entry.name).to match(/diploma\d.pdf/)
          end
        end
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
