class GeneratePdfService
  attr_reader :file

  def initialize(params)
    @params = params
    @file = nil
  end

  def call
    return unless records.present?

    @file = raw_pdf.render
  end

  private

  attr_reader :params

  def source
    @source ||= params[:source]
  end

  def position
    @position ||= params[:position].to_i
  end

  def records
    @records ||= Rails.cache.read(source)
  end

  def raw_pdf
    Prawn::Document.new do |pdf|
      pdf.move_down 100
      pdf.text "PDF \##{position+1}", align: :center, styles: [:bold], size: 50
      pdf.text "The awards goes to", valign: :center, align: :center, size: 20
      pdf.move_down 100
      pdf.text "#{records[position]}", valign: :center, align: :center, size: 20
    end
  end
end
