require 'rails_helper'

RSpec.describe ContributorsController, type: :controller do
  describe '#search' do
    before { get :search }

    it do
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("text/html")
      expect(response).to render_template(:search)
    end
  end

  describe '#index' do
    before { post :index, params: params }

    context "when full valid name" do
      let(:params) { {contributors: {str: 'https://github.com/hanami/hanami'}} }

      it do
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("text/html")
        expect(response).to render_template(:index)
        expect(Rails.cache.read('hanami/hanami')).not_to be_nil
        expect(assigns(:value)[:source]).to eq 'hanami/hanami'
        expect(assigns(:value)[:result]).to eq ["jodosha", "joneslee85", "davydovanton"]
      end
    end

    context "when short valid name" do
      let(:params) { {contributors: {str: 'hanami/hanami'}} }

      it do
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("text/html")
        expect(response).to render_template(:index)
        expect(Rails.cache.read('hanami/hanami')).not_to be_nil
        expect(assigns(:value)[:source]).to eq 'hanami/hanami'
        expect(assigns(:value)[:result]).to eq ["jodosha", "joneslee85", "davydovanton"]
      end
    end

    context "when invalid name" do
      let(:params) { {contributors: {str: 'https://github.com/hanami/invalid_hanami'}} }

      it do
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("text/html")
        expect(response).to render_template(:search)
      end
    end
  end

  describe '#send_pdf' do
    after { Rails.cache.clear }

    context "when retrieve first" do
      let(:params) { {source: 'hanami/hanami', position: 0} }
      
      before do
        Rails.cache.write('hanami/hanami', ["jodosha", "joneslee85", "davydovanton"])
        get :send_pdf, params: params
      end

      it do
        text_analysis = PDF::Inspector::Text.analyze(response.body)
        
        expect(response).to have_http_status(200)
        expect(response.header['Content-Type']).to eq 'application/pdf'
        expect(text_analysis.strings).to include('jodosha')
      end
    end

    context "when retrieve second" do
      let(:params) { {source: 'hanami/hanami', position: 1} }
      
      before do
        Rails.cache.write('hanami/hanami', ["jodosha", "joneslee85", "davydovanton"])
        get :send_pdf, params: params
      end

      it do
        text_analysis = PDF::Inspector::Text.analyze(response.body)
        
        expect(response).to have_http_status(200)
        expect(response.header['Content-Type']).to eq 'application/pdf'
        expect(text_analysis.strings).to include('joneslee85')
      end
    end

    context "when retrieve third" do
      let(:params) { {source: 'hanami/hanami', position: 2} }
      
      before do
        Rails.cache.write('hanami/hanami', ["jodosha", "joneslee85", "davydovanton"])
        get :send_pdf, params: params
      end

      it do
        text_analysis = PDF::Inspector::Text.analyze(response.body)
        
        expect(response).to have_http_status(200)
        expect(response.header['Content-Type']).to eq 'application/pdf'
        expect(text_analysis.strings).to include('davydovanton')
      end
    end

    context "when retrieve invalid" do
      let(:params) { {source: 'hanami/hanami', position: 0} }
      
      before do
        get :send_pdf, params: params
      end

      it do
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("text/html")
        expect(response).to render_template(:search)
      end
    end
  end

  describe '#send_zip' do
    after { Rails.cache.clear }

    context "when valid" do
      let(:params) { {source: 'hanami/hanami'} }

      before do
        Rails.cache.write('hanami/hanami', ["jodosha", "joneslee85", "davydovanton"])
        get :send_zip, params: params
      end

      it do
        expect(response).to have_http_status(200)
        expect(response.header['Content-Type']).to eq 'application/zip'
      end
    end

    context "when invalid" do
      let(:params) { {source: 'hanami/hanami'} }
      
      before do
        get :send_zip, params: params
      end

      it do
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("text/html")
        expect(response).to render_template(:search)
      end
    end
  end
end
