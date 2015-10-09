class Article < ActiveRecord::Base
  require 'roo'
  require 'csv'
  require 'spreadsheet'
  require 'rubygems'
  require 'iconv'
    validates :title, presence: true,

                        length: { minimum: 5 }

    validates :content, presence: true,

                        length: { minimum: 10 }

    validates :status, presence: true

    scope :status_active, -> {where(status: 'active')}

    has_many :comments, dependent: :destroy


    def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |article|
        csv << article.attributes.values_at(*column_names)
      end
    end
end



def self.open_spreadsheet(file)
case File.extname(file.original_filename)
when '.csv' then Roo::Csv.new(file.path,csv_options: {encoding: "iso-8859-1:utf-8"})
when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
when ".xls" then Roo::Excel2003XML.new(file.path, packed: nil, file_warning: :ignore)
when  '.ods' then Roo::OpenOffice.new(file.path, :password => "password")
else raise "Unknown file type: #{file.original_filename}"
end
end

end
