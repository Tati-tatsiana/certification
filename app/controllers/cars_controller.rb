class CarsController < ApplicationController
  def show
    @car = Car.find(params[:id])
    @car_geo = Car.where(id: params[:id])
    @markers = @car_geo.geocoded.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude
      }
    end
    @booking = Booking.new
    @bookings = Booking.where(user: current_user, car: @car)
  end

  def new
    @car = Car.new
  end

  def update
    @car = Car.find(params[:id])
    @car.update(params_car)
    redirect_to new_car_path
  end

  def create
    @car = Car.new(params_car)
    @car.user = current_user
    if @car.save
      redirect_to cars_path
    else
      render "pages/dashboard"
    end
  end

  def index
    if params[:type_car]
      @cars = Car.where(type_car: params[:type_car])
    elsif params[:query]
      # @cars = Car.global_search(params[:query])
      @cars = Car.near(params[:query])
    else
      @cars = Car.all
    end
    @markers = @cars.geocoded.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude,
        info_window: render_to_string(partial: "info_window", locals: { car: car })
      }
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
  end

  def edit
    @car = Car.find(params[:id])
  end

  def find
    @car = Car.find(params[:id])
  end

  def price
    if params[:price]
      @cars = Car.order('price DESC')
    else
      @cars = Car.order('price ASC')
    end
  end

  def index_bar
    if params[:query].present?
      @cars = Car.where(type_car: params[:query])
    else
      @cars = Car.all
    end
  end

  private

  def params_car
    params.require(:car).permit(:user_id, :car_maker, :model, :type_car, :engine, :transmission, :number_of_miles, :date_of_production, :price, :address, :photo)
  end
end
