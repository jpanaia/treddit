json.array!(@votes) do |vote|
  json.extract! vote, :id, :post_id, :user_id, :score
  json.url vote_url(vote, format: :json)
end
