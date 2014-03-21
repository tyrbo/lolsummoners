module IsBot
  def self.is_bot?(request)
    agent = request.env["HTTP_USER_AGENT"]
    matches = nil
    matches = agent.match(/(facebook|postrank|voyager|twitterbot|googlebot|slurp|butterfly|pycurl|tweetmemebot|metauri|evrinid|reddit|digg)/mi) if agent
    if ( agent.nil? or matches)
      return true
    else
      return false
    end
  end
end
