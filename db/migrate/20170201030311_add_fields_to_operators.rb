class AddFieldsToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :contact_job_title, :text, default: ""
    add_column :operators, :contact_field_office, :text, default: ""
    add_column :operators, :terms_and_conditions, :text, default: ""
    add_column :operators, :contract_pdf_file, :string
    add_column :operators, :payment_conditions, :text, default: ""
  end
end
