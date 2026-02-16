class JourneyCalculator
  SPEED_OF_LIGHT_KM_S = 299_792.458
  LIGHT_YEAR_KM = 9.461e12
  SECONDS_PER_YEAR = 31_557_600.0  # Julian year
  
  # Energy constants
  JOULES_PER_KG_TNT = 4.184e6
  HIROSHIMA_BOMB_JOULES = 63e12  # ~15 kilotons TNT
  WORLD_ANNUAL_ENERGY_JOULES = 5.8e20  # ~580 exajoules

  attr_reader :star, :propulsion_system, :payload_mass_kg

  def initialize(star:, propulsion_system:, payload_mass_kg: 1000)
    @star = star
    @propulsion_system = propulsion_system
    @payload_mass_kg = payload_mass_kg.to_f
  end

  def calculate
    {
      star: star,
      propulsion_system: propulsion_system,
      payload_mass_kg: payload_mass_kg,
      distance_km: distance_km,
      distance_ly: star.distance_ly,
      velocity_km_s: propulsion_system.velocity_km_s,
      velocity_fraction_c: propulsion_system.velocity_fraction_c,
      travel_time_seconds: travel_time_seconds,
      travel_time_years: travel_time_years,
      travel_time_human: format_time(travel_time_years),
      round_trip_years: travel_time_years * 2,
      communication_delay_years: communication_delay_years,
      round_trip_communication_years: communication_delay_years * 2,
      kinetic_energy_joules: kinetic_energy_joules,
      energy_in_hiroshima_bombs: energy_in_hiroshima_bombs,
      energy_in_world_years: energy_in_world_years,
      generations: generations_required,
      feasibility_assessment: feasibility_assessment,
      reality_check: reality_check
    }
  end

  private

  def distance_km
    star.distance_ly * LIGHT_YEAR_KM
  end

  def travel_time_seconds
    distance_km / propulsion_system.velocity_km_s
  end

  def travel_time_years
    travel_time_seconds / SECONDS_PER_YEAR
  end

  def communication_delay_years
    # Light-speed communication delay (one way)
    star.distance_ly
  end

  def kinetic_energy_joules
    # KE = 0.5 * m * v^2
    # For relativistic velocities, this is an approximation
    v = propulsion_system.velocity_km_s * 1000  # convert to m/s
    0.5 * payload_mass_kg * v * v
  end

  def energy_in_hiroshima_bombs
    kinetic_energy_joules / HIROSHIMA_BOMB_JOULES
  end

  def energy_in_world_years
    kinetic_energy_joules / WORLD_ANNUAL_ENERGY_JOULES
  end

  def generations_required
    # Assuming 25 years per generation
    (travel_time_years / 25.0).ceil
  end

  def format_time(years)
    if years >= 1_000_000_000
      "#{(years / 1_000_000_000.0).round(2)} billion years"
    elsif years >= 1_000_000
      "#{(years / 1_000_000.0).round(2)} million years"
    elsif years >= 1000
      "#{years.round(0).to_fs(:delimited)} years"
    elsif years >= 1
      "#{years.round(1)} years"
    elsif years >= (1.0/12)
      "#{(years * 12).round(1)} months"
    else
      "#{(years * 365.25).round(1)} days"
    end
  end

  def feasibility_assessment
    if travel_time_years <= 50
      { level: "possible", description: "Within a human lifetime. Ambitious but conceivable.", color: "green" }
    elsif travel_time_years <= 100
      { level: "difficult", description: "Multi-generational or requires life extension.", color: "yellow" }
    elsif travel_time_years <= 1000
      { level: "impractical", description: "Requires generation ships or suspended animation.", color: "orange" }
    elsif travel_time_years <= 100_000
      { level: "civilization_scale", description: "Longer than recorded human history.", color: "red" }
    else
      { level: "impossible", description: "Exceeds any reasonable planning horizon.", color: "darkred" }
    end
  end

  def reality_check
    checks = []
    
    if travel_time_years > 80
      checks << "You will not live to see arrival."
    end
    
    if travel_time_years > 1000
      checks << "Human civilization has only existed for ~10,000 years."
    end
    
    if travel_time_years > 100_000
      checks << "Homo sapiens has only existed for ~300,000 years."
    end
    
    if travel_time_years > 1_000_000
      checks << "The genus Homo has only existed for ~2 million years."
    end
    
    if travel_time_years > 65_000_000
      checks << "Dinosaurs went extinct more recently than this."
    end
    
    if communication_delay_years > 50
      checks << "If you sent a message and got a reply, you'd be dead before it arrived."
    end
    
    if energy_in_world_years > 1
      checks << "Accelerating just #{payload_mass_kg.round(0)} kg requires more than a year of total world energy production."
    end
    
    if energy_in_hiroshima_bombs > 1
      checks << "Kinetic energy equivalent to #{energy_in_hiroshima_bombs.round(1)} Hiroshima bombs."
    end
    
    if propulsion_system.technology_readiness == "Theoretical" || propulsion_system.technology_readiness == "Speculative"
      checks << "This propulsion technology does not yet exist."
    end
    
    if propulsion_system.technology_readiness == "Far Future"
      checks << "This technology may never be practical."
    end
    
    if propulsion_system.name.include?("Orion")
      checks << "Nuclear pulse propulsion is banned by international treaty."
    end

    checks
  end
end
