require 'zip'

class GenerateZipService
  attr_reader :file

  def initialize(params)
    @params = params
    @file = nil
  end

  def call
    return unless records.present?

    zip = Zip::OutputStream.write_buffer do |zio|
      records.each_with_index do |r, i|
        zio.put_next_entry("diploma#{i+1}.pdf")

        service = GeneratePdfService.new(source: source, position: i)
        service.call

        zio.write(service.file)
      end
    end
    zip.rewind
    @file = zip.sysread
  end

  private

  attr_reader :params

  def source
    @source ||= params[:source]
  end

  def records
    @records ||= Rails.cache.read(source)
  end
end
