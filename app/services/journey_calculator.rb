class JourneyCalculator
  SPEED_OF_LIGHT_KM_S = 299_792.458
  LIGHT_YEAR_KM = 9.461e12
  SECONDS_PER_YEAR = 31_557_600.0  # Julian year
  SECONDS_PER_DAY = 86_400.0

  # Energy constants
  JOULES_PER_KG_TNT = 4.184e6
  HIROSHIMA_BOMB_JOULES = 63e12  # ~15 kilotons TNT
  WORLD_ANNUAL_ENERGY_JOULES = 5.8e20  # ~580 exajoules

  # Propellant-less explanations
  PROPELLANTLESS_REASONS = {
    "Solar Sail"    => "Driven by photon pressure — no propellant is carried or consumed.",
    "Light Sail"    => "Externally accelerated by ground-based laser — carries no propellant.",
    "Starshot"      => "Externally accelerated by ground-based laser — carries no propellant.",
    "Bussard"       => "Scoops interstellar hydrogen as fuel — no propellant stored at launch."
  }.freeze

  attr_reader :star, :propulsion_system, :payload_mass_kg

  def initialize(star:, propulsion_system:, payload_mass_kg: 1000)
    @star = star
    @propulsion_system = propulsion_system
    @payload_mass_kg = payload_mass_kg.to_f
  end

  def calculate
    result = {
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
      reality_check: reality_check,
      is_solar_system: solar_system?,
      calculation_method: calculation_method,
      calculation_disclaimer: calculation_disclaimer,
      propellantless: propulsion_system.propellantless?,
      propellantless_reason: propellantless_reason,
      exhaust_velocity_km_s: propulsion_system.exhaust_velocity_km_s,
      mass_ratio_one_way: mass_ratio_one_way,
      fuel_mass_one_way_kg: fuel_mass_one_way_kg,
      fuel_mass_one_way_human: mass_ratio_one_way ? format_mass(fuel_mass_one_way_kg) : nil,
      mass_ratio_with_decel: mass_ratio_with_decel,
      fuel_mass_with_decel_kg: fuel_mass_with_decel_kg,
      fuel_mass_with_decel_human: mass_ratio_with_decel ? format_mass(fuel_mass_with_decel_kg) : nil,
      mass_ratio_round_trip: mass_ratio_round_trip,
      fuel_mass_round_trip_kg: fuel_mass_round_trip_kg,
      fuel_mass_round_trip_human: mass_ratio_round_trip ? format_mass(fuel_mass_round_trip_kg) : nil
    }
    
    # Add realistic travel info for solar system objects
    if solar_system? && star.realistic_travel_days.present?
      result[:realistic_travel_days] = star.realistic_travel_days
      result[:realistic_travel_human] = format_days(star.realistic_travel_days)
      result[:realistic_travel_notes] = star.realistic_travel_notes
    end
    
    result
  end

  private

  def solar_system?
    star.constellation == "Solar System"
  end

  def distance_km
    star.distance_km || (star.distance_ly * LIGHT_YEAR_KM)
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

  def format_days(days)
    if days >= 365.25
      years = days / 365.25
      "#{years.round(1)} years"
    elsif days >= 30
      months = days / 30.44
      "#{months.round(1)} months"
    else
      "#{days.round(1)} days"
    end
  end

  def calculation_method
    if solar_system?
      :orbital_mechanics
    else
      :straight_line
    end
  end

  def calculation_disclaimer
    if solar_system?
      "Solar System travel times are based on actual mission data using Hohmann transfer orbits and gravity assists. " \
      "Spacecraft do not travel in straight lines—they follow curved trajectories determined by orbital mechanics. " \
      "The 'straight-line' calculation shown for comparison ignores these realities and would require impossible amounts of fuel."
    else
      "Interstellar distances are so vast that orbital mechanics become negligible. " \
      "This calculation assumes constant velocity in a straight line, which is reasonable for interstellar scales. " \
      "However, it ignores acceleration/deceleration time, which would add significantly to journey duration for realistic propulsion systems."
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

    if propulsion_system.name.include?("Light Sail") || propulsion_system.name.include?("Starshot")
      if payload_mass_kg > 1
        checks << "Laser-pushed light sails can only accelerate gram-scale probes (~1 gram), not #{payload_mass_kg.round(0)} kg. This technology cannot carry humans or large payloads."
      end
    end

    if !solar_system? && mass_ratio_one_way && !mass_ratio_one_way.infinite? && mass_ratio_one_way > 1_000_000
      ratio_display = format_large_ratio(mass_ratio_one_way)
      checks << "The fuel-to-payload mass ratio is #{ratio_display}:1 just to accelerate. This exceeds the mass of any object humanity could construct."
    end

    checks
  end

  # === Tsiolkovsky Rocket Equation ===
  # Δv = Vₑ × ln(m₀/mf)
  # where Vₑ = exhaust velocity, m₀ = initial mass, mf = final mass

  def propellantless_reason
    PROPELLANTLESS_REASONS.find { |k, _| propulsion_system.name.include?(k) }&.last
  end

  def mass_ratio_one_way
    return nil if propulsion_system.propellantless?
    Math::E ** (propulsion_system.velocity_km_s / propulsion_system.exhaust_velocity_km_s)
  end

  def fuel_mass_one_way_kg
    return nil unless mass_ratio_one_way
    payload_mass_kg * (mass_ratio_one_way - 1)
  end

  def mass_ratio_with_decel
    return nil unless mass_ratio_one_way
    mass_ratio_one_way ** 2
  end

  def fuel_mass_with_decel_kg
    return nil unless mass_ratio_with_decel
    payload_mass_kg * (mass_ratio_with_decel - 1)
  end

  def mass_ratio_round_trip
    return nil unless mass_ratio_one_way
    mass_ratio_one_way ** 4
  end

  def fuel_mass_round_trip_kg
    return nil unless mass_ratio_round_trip
    payload_mass_kg * (mass_ratio_round_trip - 1)
  end

  def format_mass(kg)
    kg = kg.to_f
    return "incalculably large" if kg.infinite? || kg.nan? || kg > 1e50
    if kg < 1_000
      "#{kg.round(1)} kg"
    elsif kg < 1e6
      "#{(kg / 1_000.0).round(1)} tonnes"
    elsif kg < 1e9
      "#{(kg / 1e6).round(1)} million tonnes"
    elsif kg < 1e12
      "#{(kg / 1e9).round(1)} billion tonnes"
    elsif kg < 1e15
      "#{(kg / 1e12).round(1)} trillion tonnes"
    elsif kg < 1e18
      "#{(kg / 1e15).round(1)} quadrillion tonnes"
    elsif kg < 1e21
      "#{(kg / 1e18).round(1)} quintillion tonnes"
    elsif kg < 5.972e26  # up to ~100 Earth masses
      em = kg / 5.972e24
      "#{em.round(em >= 0.01 ? 2 : 4)} Earth masses"
    elsif kg < 1.989e30
      sm = kg / 1.989e30
      "#{sm.round(sm >= 0.01 ? 2 : 4)} Solar masses"
    else
      "#{(kg / 1.989e30).round(2)} Solar masses"
    end
  end

  def number_with_delimiter(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def format_large_ratio(ratio)
    if ratio > 1e30
      "10^#{Math.log10(ratio).round(1)}"
    elsif ratio > 1e15
      "#{(ratio / 1e15).round(1)} quadrillion"
    elsif ratio > 1e12
      "#{(ratio / 1e12).round(1)} trillion"
    elsif ratio > 1e9
      "#{(ratio / 1e9).round(1)} billion"
    else
      "#{(ratio / 1e6).round(1)} million"
    end
  end
end
