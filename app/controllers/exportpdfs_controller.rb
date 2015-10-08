class ExportpdfsController < ApplicationController

  def index
  @exportpdfs = Article.all

  respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(@exportpdfs)
        send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
    end
  end

end

end
