class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :reservation_accepted
  validate :reservation_checkout_has_happened

  def reservation_accepted
    if (reservation && reservation.status != "accepted")
      errors.add(:reservation, "reservation has not been accepted")
    end
  end

  def reservation_checkout_has_happened
    if (reservation && reservation.checkout > Date.today)
      errors.add(:reservation, "reservation checkout has not happened")
    end
  end
end
