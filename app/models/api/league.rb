class Api::League
  attr_reader :region

  def initialize(args, region)
    @args = args
    @region = region
  end

  def entries
    @entries ||= @args.fetch("entries").map { |x| Api::LeagueEntry.new(x, region) }
  end

  def name
    @args.fetch("name")
  end

  def queue
    @args.fetch("queue")
  end

  def tier
    @args.fetch("tier")
  end

  def to_ar(cascade: false)
    league = ::League.find_or_create_by(name: name, region: region).tap do |x|
      x.update(queue: queue, tier: tier)
    end

    if cascade
      entries.each do |x|
        x.league_id = league.id
        x.to_ar
      end
    end
  end
end
