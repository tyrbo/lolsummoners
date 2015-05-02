module JobEvents
  module SearchResult
    def fire_event(status, region, name, id = nil)
      Pusher["search_#{region}_#{name}"].trigger('response', {
        status: status,
        id: id
      })
    end
  end
end
