cclass DashboardsController < ApplicationController

def create
  @car = Car.new(params_car)
  @car.user = current_user
  if @car.save
    redirect_to cars_path
  else
    render "pages/dashboard"
  end
end

# Index les vehicules de l'user
def my_cars
   @cars = current_user.car
end

def destroy
  @car = Car.find(params[:id])
  @car.destroy
end

# Méthode qui renvoi => les demandes de location pour l'user
def my_demands
  @my_bookings = current_user.booking
  @my_demands  = []
  @my_bookings.each do |booking|
    # Recupere => les datas du vehicule associé au booking
    data_car  = []
    car_id    = booking.car_id
    car_find  = Car.find(car_id)
    car       = {photo: car_find.photo, model: car_find.model, price: car_find.price, adresse: car_find.address}
    data_car.push(car)
    data_out  = {start_date: booking.start_date, finish_date: booking.finish_date, car_data: data_car}
    @my_demands.push(data_out)
  end
  @my_demands
end

def entry_demands
  # Recupere => tous les vehicules de l'user
  @cars = current_user.car
  ar_car_id = []
  @ar_reservation = []
  # Recupere => tous les id's de car's de l'user pour verification
  @cars.each do |car|
    ar_car_id.push(car[:id])
  end
  # Recupere => tous les bookings
  @bookings = Booking.all
  @bookings.each do |booking|
    # Boucle sur les id's de car recuperer
    ar_car_id.each do |car_id|
      # Verifi  si il ya des resa pour l'user
      if booking.car_id == car_id
        car = Car.find(car_id)
        # Recupere =>  les datas du loueur
        user_rent_id  = booking.user_id
        user_rent     = User.find(user_rent_id)
        # Enregistre => les datas, structure => '[{data_booking}, {data_car}, {data_user_rent}]'
        demands_data = [{start_date: booking[:start_date], finish_date: booking[:finish_date], user_id: booking[:user_id]},
                        {model: car.model , car_maker: car.car_maker , price: car.price , photo: car.photo},
                        {first_name: user_rent.first_name, last_name: user_rent.last_name}]
        # Enregistre => la liste de data dans la liste de reservation pour les vues
        @ar_reservation.push(demands_data)
      end
    end
  end
end

def status
  raise
end
