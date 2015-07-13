class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    listings.joins(:reservations)
    .where("(checkin NOT BETWEEN ? AND ?) AND (checkout NOT BETWEEN ? AND ?)", start_date, end_date, start_date, end_date)
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by {|city| city.ratio_res_to_listings}
  end

  def ratio_res_to_listings
    self.listings.joins(:reservations).size / self.listings.size
  end

  def self.most_res
    self.all.max_by {|city| city.listings.joins(:reservations).size}
  end
end
