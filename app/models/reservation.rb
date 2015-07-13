class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_not_host
  validate :available_at_checkin
  validate :available_at_checkout
  validate :checkin_before_checkout

  def guest_not_host
    if (listing.host_id == guest_id)
      errors.add(:guest_id, "cannot make reservation on own listing")
    end
  end

  def available_at_checkin
    res_overlap = listing.reservations.where('? BETWEEN checkin AND checkout', checkin)
    if (!res_overlap.empty?) && !(self == res_overlap.first)
      errors.add(:checkin, "checkin date unavailable")
    end
  end

  def available_at_checkout
    res_overlap = listing.reservations.where('? BETWEEN checkin AND checkout', checkout)
    if (!res_overlap.empty?) && !(self == res_overlap.first)
      errors.add(:checkout, "checkout date unavailable")
    end
  end

  def checkin_before_checkout
    if (checkin && checkout)
      if (checkin >= checkout)
        errors.add(:checkout, "checkin date is not before checkout date")
      end
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end
end
