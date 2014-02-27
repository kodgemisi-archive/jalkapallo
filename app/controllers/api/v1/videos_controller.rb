module Api
  module V1
    class VideosController < ApplicationController

      # GET /videos
      # GET /videos.json
      def index

        size = params[:size] || 1
        exclude = params[:exclude] || ""
        exclude = exclude.split(',')
        exclude = exclude.map{|e|e.to_i}

        @videos = Video.where(id: generate_random_ids(exclude, size))

        @results = []

        @videos.each do |video|

          real_url = get_video_url(video.youtube_url)
          if(!real_url.nil?)
            @results.append({
              id: video.id,
              url: real_url,
              result: video.result
              })
          end

        end

        @success = true
        return @results
      end

      private

      def generate_random_ids(exclude = [], size = 1)
        ids = Video.pluck(:id)
        ids = ids - exclude
        indexes = []

        size = size.to_i

        #prevent endless loop when size is greater than available ids
        size = ids.size < size ? ids.size : size

        while indexes.size < size
          id = ids.sample

          if(!indexes.include?(id))
            indexes.append(id)
          end
        end

        return indexes
      end

      def get_video_url(url)
        cached = VideoCache.find_by(youtube_url: url)

        if(cached.nil?)
          #out to cache
          print "=============================================\n"
          print "putting to cache"
          cached = VideoCache.new
          cached.youtube_url = url
          cached.video_url = get_real_url(url)
          cached.save
        elsif !is_alive?(cached.video_url)
          #update cache
          print "=============================================\n"
          print "updating cache"
          cached.video_url = get_real_url(url)
          cached.save
        else
          print "=============================================\n"
          print "serving from cache"
        end

        return cached.video_url
      end

      def is_alive?(url)
        uri = URI(url)

        response = nil
        Net::HTTP.start(uri.host, uri.port, {use_ssl: (true if uri.scheme == "https")}) {|http|
          response = http.head(uri.to_s)
        }
        return response.code == "200"
      end

      def get_real_url(youtube_url)
        output = IO.popen(['youtube-dl', '-g', youtube_url], :err=>[:child, :out])
        output = output.readlines

        return output.size > 0 ? output[0] : nil
      end

    end
  end
end