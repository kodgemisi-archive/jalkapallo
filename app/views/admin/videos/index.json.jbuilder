json.array!(@videos) do |video|
  json.extract! video, :id, :video_name, :video_description, :youtube_url, :start_time, :stop_time, :end_time, :result
  json.url video_url(video, format: :json)
end
