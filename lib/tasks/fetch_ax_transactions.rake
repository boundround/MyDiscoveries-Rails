namespace :ax do
  desc "Fetch new transactions from Innovations ftp"
  task fetch: :environment do
    if Rails.env.production?
      Net::SFTP.start(
        ENV['AX_HOSTNAME'],
        ENV['AX_USERNAME'],
        password: ENV['AX_PASSWORD']
      ) do |sftp|
        extn = '.XML'
        all_files      = sftp.dir.entries("/data/#{ENV['AX_DOWNLOAD_DIR']}").map { |e| e.name }
        xml_files      = all_files.select{ |f| f.upcase.ends_with?(extn) }

        xml_files.each do |filename|
          if !Spree::Order.exists?(ax_filename: filename)
            data = sftp.download!("/data/#{ENV['AX_DOWNLOAD_DIR']}/#{filename}")
            Ax::Download.call(data, filename)
          end
        end
      end
    end
  end
end
