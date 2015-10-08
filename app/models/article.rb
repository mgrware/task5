class Article < ActiveRecord::Base
  require 'roo'
  require 'csv'
  require 'spreadsheet'
  require 'rubygems'
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

      def self.import(file)
        accessible_attributes = ["id","title","content","status"]
        spreadsheet = open_spreadsheet(file)
        header = Array.new
        spreadsheet.row(1).each { |row| header << row.downcase.tr(' ', '_') }
        (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        article = find_by_id(row["id"]) || new
        article.attributes = row.to_hash.slice(*accessible_attributes)
        article.save!
      end
    end

    def self.open_spreadsheet(file)
       case File.extname(file.original_filename)
       when ".csv" then Roo::CSV.new(file.path, csv_options: {col_sep: ";"})
       when ".xls" then Roo::Excel.new(file.path)
       when ".xlsx" then Roo::Excelx.new(file.path)
       else raise "Unknown file type: #{file.original_filename}"
       end
end

end
