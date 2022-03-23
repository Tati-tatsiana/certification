class User < ApplicationRecord
  has_many :car
  has_many :booking
end
