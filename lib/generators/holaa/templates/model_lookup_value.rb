class AppLookupValue < ActiveRecord::Base

  records_with_operator_on :create

	belongs_to :app_lookup_key

	acts_as_list

  acts_as_paranoid

	has_ancestry

	validates :code, :app_lookup_key, presence: true
	validates :code, uniqueness: true

  # searchable do 
  #   text :code, :description, :original_code
  #   text :app_lookup_key do 
  #     app_lookup_key.name
  #   end
  # end

	def self.import_values
    rows = Array.new
    doc = Spreadsheet.open ("#{Rails.root}/public/Master_LookupValues.xls")
    sheet1 = doc.worksheet 0
    sheet1.each do |row|
       rows << row.to_a
    end

    rows.each_with_index do |row,ind|
      if ind > 0
      	lookup_key = LookupKey.where(name: row[0].try(:strip)).first
      	if lookup_key
      		lv_code = row[2].try(:downcase).try(:strip) ? lookup_key.code.try(:downcase) +"_"+ row[2].squish.downcase.tr(" ","_") : nil
      		lv_parent = row[1] ? self.where(original_code: row[1]).first : nil
          lookup_value = self.new(code: lv_code, original_code: row[2],
      														lookup_key: lookup_key, parent: lv_parent)
      	  lookup_value.save
      	end 
       end

    end
  end
	
end