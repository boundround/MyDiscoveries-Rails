namespace :ax do
  desc "Fetch new transactions from Innovations ftp"
  task fetch: :environment do
    if Rails.env.production?
      Net::SFTP.start(
        ENV['AX_HOSTNAME'],
        ENV['AX_USERNAME'],
        password: ENV['AX_PASSWORD']
      ) do |sftp|
        extn = '.xml'
        all_files      = sftp.dir.entries("/#{ENV['AX_DOWNLOAD_DIR']}").map { |e| e.name }
        xml_files      = all_files.select{ |f| f.ends_with?(extn) }
        xml_file_names = xml_files.map{ |f| File.basename(f, extn)  }

        xml_file_names.each do |ax_sales_id|
          if !Order.exists?(ax_sales_id: ax_sales_id)
            data = sftp.download!("/from_ax/#{ax_sales_id}#{extn}")
            Ax::Download.call data
          end
        end
      end
    end
  end
end
