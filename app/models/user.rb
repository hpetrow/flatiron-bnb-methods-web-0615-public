class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    User.find(guest_ids)
  end

  def hosts
    User.find(host_ids)
  end

  def host_reviews
    Review.find(host_review_ids)
  end

  def guest_ids
    reservations.collect { |reservation|
      reservation.guest_id
    }
  end

  def host_ids
    trips.collect { |trip|
      trip.listing.host_id
    }
  end

  def host_review_ids
    reservations.collect { |reservation|
      reservation.review.id if reservation.review
    }.compact
  end
end
