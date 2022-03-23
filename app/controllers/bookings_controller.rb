require 'date'

class BookingsController < ApplicationController
  def new
    @car = Booking.find(params[:car_id])
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @car = Car.find(params[:car_id])
    @booking.car = @car
    @booking.user = current_user
    if @booking.save
      redirect_to car_path(@car)
    else
      puts "FAILED SAVE !"
    end
  end

  def show
    @booking = Car.find(params[:id])
  end

  def edit
  end

  def update
  end

  def index
    @bookings = Car.all
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :finish_date, :user_id, :car_id)
  end
end
