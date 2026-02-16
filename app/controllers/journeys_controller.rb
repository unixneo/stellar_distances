class JourneysController < ApplicationController
  def index
    @stars = Star.order(:distance_ly)
    @propulsion_systems = PropulsionSystem.order(:velocity_km_s)
  end

  def calculate
    @star = Star.find(params[:star_id])
    @propulsion_system = PropulsionSystem.find(params[:propulsion_system_id])
    @payload_mass_kg = params[:payload_mass_kg].presence || 1000

    calculator = JourneyCalculator.new(
      star: @star,
      propulsion_system: @propulsion_system,
      payload_mass_kg: @payload_mass_kg
    )

    @result = calculator.calculate

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
