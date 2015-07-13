class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    listings.joins(:reservations)
    .where("(checkin NOT BETWEEN ? AND ?) AND (checkout NOT BETWEEN ? AND ?)", start_date, end_date, start_date, end_date)
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by {|neighborhood| neighborhood.ratio_res_to_listings}
  end

  def ratio_res_to_listings
    if self.listings.size > 0
      self.listings.joins(:reservations).size / self.listings.size
    else
      0.0
    end
  end

  def self.most_res
    self.all.max_by {|neighborhood| neighborhood.listings.joins(:reservations).size}
  end
end
