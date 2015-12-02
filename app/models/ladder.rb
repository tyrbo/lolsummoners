class Ladder
  attr_reader :page, :region, :summoners

  PER_PAGE = 25.0

  def initialize(page: 1, region: "all")
    @page = page.to_i
    @region = region
    @summoners = []
  end

  def fetch
    @summoners = get_summoners

    self
  end

  def has_next_page?
    page < total_summoners / PER_PAGE
  end

  def has_prev_page?
    page > 1
  end

  def next_page
    page + 1
  end

  def prev_page
    page - 1
  end

  def total_summoners
    redis.zcard("rank_#{region}")
  end

  private

  def get_summoners
    ids = redis.zrevrange("rank_#{region}", page_min, page_max)

    Summoner.where(id: ids).sort_by { |x| [x.rank(region: region), x.internal_name] }
  end

  def page_min
    (page - 1) * 25
  end

  def page_max
    (page * 25) - 1
  end

  def redis
    Redis.current
  end
end
