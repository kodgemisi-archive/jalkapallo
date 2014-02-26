module Api
  module V1
    class VideosController < ApplicationController

      # GET /videos
      # GET /videos.json
      def index

        size = params[:size] || 1
        exclude = params[:exclude] || []

        @videos = Video.where(id: generate_random_ids(exclude, size))

        @results = []

        @videos.each do |video|

          output = IO.popen(['youtube-dl', '-g', 'http://www.youtube.com/watch?v=EDD8PvnSW9o'], :err=>[:child, :out])
          output = output.readlines
          if(output.size > 0)
            @results.append(output[0])
          end
        end

        @success = true
        return @results
      end

      def generate_random_ids(exclude = [], size = 1)
        ids = Video.pluck(:id)
        ids = ids - exclude
        indexes = []

        size = size.to_i

        while indexes.size < size
          id = ids.sample

          if(!indexes.include?(id))
            indexes.append(id)
          end
        end

        return indexes
      end

    end
  end
end