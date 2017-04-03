namespace :fetch do
  desc "Update all orders ax_data field"
  task :ax_data => :environment do
    Net::SFTP.start(
      ENV['AX_HOSTNAME'],
      ENV['AX_USERNAME'],
      password: ENV['AX_PASSWORD']
    ) do |sftp|
      extn = '.XML'
      all_files      = sftp.dir.entries("/data/#{ENV['AX_DOWNLOAD_DIR']}").map { |e| e.name }
      xml_files      = all_files.select{ |f| f.upcase.ends_with?(extn) }
      xml_file_names = xml_files.map{ |f| File.basename(f, extn) }

      xml_files.each do |file_name|
        data = sftp.download!("/data/from_ax/#{file_name}")
        json_data = Hash.from_xml(data)
        ax_sales_id = json_data["Envelope"]["Order"]["SalesId"]

        order = Order.find_by(ax_sales_id: ax_sales_id)
        order.update_column(:ax_data, json_data) if order
      end
    end
  end
end
