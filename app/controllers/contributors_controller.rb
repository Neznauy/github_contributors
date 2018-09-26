class ContributorsController < ApplicationController
  def search; end

  def index
    service = GetContributorsService.new(params)
    service.call

    if service.error.nil?
      @value = service.value
      render :index
    else
      flash.now[:error] = service.error
      render :search
    end
  end

  def send_pdf
    service = GeneratePdfService.new(params)
    service.call

    if service.file
      send_data(service.file, filename: "diploma.pdf")
    else
      flash.now[:error] = I18n.t('errors.empty_cache')
      render :search
    end
  end

  def send_zip
    service = GenerateZipService.new(params)
    service.call

    if service.file
      send_data(service.file, filename: "diplomas.zip")
    else
      flash.now[:error] = I18n.t('errors.empty_cache')
      render :search
    end
  end
end
