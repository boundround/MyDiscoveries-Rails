require 'rubygems'
require 'unirest'

class VimeoDownloader

  def test
    response = Unirest.get "https://api.vimeo.com/me/videos",
                            headers:{ Authorization: "bearer dbaf0e4862e6f89ad2ebe9c36434cfc0" }
    puts response.body['data'].first['pictures'][3]['link']
  end

  def get_videos
    videos_total = 0
    response = Unirest.get "https://api.vimeo.com/me/videos?per_page=50",
                            headers:{ Authorization: "bearer dbaf0e4862e6f89ad2ebe9c36434cfc0" }

    pages = response.body['paging']['last'].match(/\d+$/)[0].to_i

    current_page = 1
    while current_page <= pages
      response = Unirest.get "https://api.vimeo.com/me/videos?page=#{current_page}&per_page=50",
                              headers:{ Authorization: "bearer dbaf0e4862e6f89ad2ebe9c36434cfc0" }

      response.body['data'].each do |video|
        i = 0
        download_url = ''
        while i < video['files'].length
          if video['files'][i]['quality'] == 'mobile'
            download_url = video['files'][i]['link']
          end
          i += 1
#          puts i
        end

        puts video['name']
        vimeo_id = video['uri'].match(/\d+$/)[0]
        puts "downloading #{vimeo_id}"
        download_video(download_url, vimeo_id)
        videos_total += 1
      end
      current_page += 1
    end

    puts videos_total
  end

  def download_video(url, vimeo_id)
    vid_file = "./videos/bigvideos/#{vimeo_id}.mp4"
    puts "Checking for #{vid_file}, will download if not found"
    if not File.file?(vid_file)
      `wget -O #{vid_file} #{url}`
    end
  end

  def get_thumbs
    thumbs_total = 0
    response = Unirest.get "https://api.vimeo.com/me/videos?per_page=50",
                            headers:{ Authorization: "bearer dbaf0e4862e6f89ad2ebe9c36434cfc0" }

    pages = response.body['paging']['last'].match(/\d+$/)[0].to_i

    current_page = 1
    while current_page <= pages
      response = Unirest.get "https://api.vimeo.com/me/videos?page=#{current_page}&per_page=50",
                              headers:{ Authorization: "bearer dbaf0e4862e6f89ad2ebe9c36434cfc0" }

      response.body['data'].each do |video|
        download_url = video['pictures'][3]['link']
        vimeo_id = video['uri'].match(/\d+$/)[0]
        puts video['uri']
        puts "downloading #{vimeo_id}"
        download_video_thumbs(download_url, vimeo_id)
        thumbs_total += 1
      end
      current_page += 1
    end

    puts thumbs_total
  end

  def download_video_thumbs(url, vimeo_id)
    thumb_file = "./videos/bigvideos/thumbs/#{vimeo_id}.jpg"
    if not File.file?(thumb_file)
      `wget -O #{thumb_file} #{url}`
    end
  end

end


v = VimeoDownloader.new
v.get_videos
