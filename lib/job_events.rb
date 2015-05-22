module JobEvents
  module SearchResult
    def fire_event(status, region, name, id = nil)
      Pusher["search_#{region}_#{name}"].trigger('response', {
        status: status,
        id: id
      })
    end
  end

  module PlayerResult
    def fire_event(status, region, id)
      Pusher["player_#{region}_#{id}"].trigger('response', {
        status: status,
        id: id
      })
    end
  end
end
