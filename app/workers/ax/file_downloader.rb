class AX::FileDownloader
  include Sidekiq::Worker

  def perform(filename)
    if filename.present?
      Net::SFTP.start(
        ENV['AX_HOSTNAME'],
        ENV['AX_USERNAME'],
        password: ENV['AX_PASSWORD']
      ) do |sftp|
        data = sftp.download!("/data/#{ENV['AX_DOWNLOAD_DIR']}/#{filename}")
        Ax::Download.call(data, filename)
      end
    end
  end
end
