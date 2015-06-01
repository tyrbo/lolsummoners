class Stats < ActiveRecord::Base
  scope :by_region, ->(region) { where(region: region) }
end
