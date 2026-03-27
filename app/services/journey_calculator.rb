class JourneyCalculator
  SPEED_OF_LIGHT_KM_S = 299_792.458
  SPEED_OF_LIGHT_M_S = 299_792_458.0
  LIGHT_YEAR_KM = 9.461e12
  SECONDS_PER_YEAR = 31_557_600.0  # Julian year
  SECONDS_PER_DAY = 86_400.0

  # Energy constants
  JOULES_PER_KG_TNT = 4.184e6
  HIROSHIMA_BOMB_JOULES = 63e12  # ~15 kilotons TNT
  WORLD_ANNUAL_ENERGY_JOULES = 5.8e20  # ~580 exajoules
  PROTON_MASS_KG = 1.67262192369e-27
  ISM_HYDROGEN_DENSITY_PER_M3 = 1_000_000.0 # ~1 atom/cm^3
  EV_PER_JOULE = 6.241509074e18

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
      earth_frame_travel_time_years: travel_time_years,
      crew_proper_time_years: crew_proper_time_years,
      time_dilation_gamma: lorentz_gamma,
      travel_time_human: format_time(travel_time_years),
      crew_time_human: format_time(crew_proper_time_years),
      round_trip_years: travel_time_years * 2,
      communication_delay_years: communication_delay_years,
      round_trip_communication_years: communication_delay_years * 2,
      minimum_possible_travel_years: minimum_possible_travel_years,
      minimum_possible_travel_human: format_time(minimum_possible_travel_years),
      kinetic_energy_joules: kinetic_energy_joules,
      energy_in_hiroshima_bombs: energy_in_hiroshima_bombs,
      energy_in_world_years: energy_in_world_years,
      doppler_departure_redshift_factor: doppler_departure_redshift_factor,
      doppler_arrival_blueshift_factor: doppler_arrival_blueshift_factor,
      ism_number_density_per_m3: ISM_HYDROGEN_DENSITY_PER_M3,
      ism_atom_flux_m2_s: ism_atom_flux_m2_s,
      ism_atom_flux_cm2_s: ism_atom_flux_cm2_s,
      ism_atom_flux_cm2_s_human: format_scientific(ism_atom_flux_cm2_s, unit: "atoms/cm²/s"),
      ism_proton_energy_joules: ism_proton_energy_joules,
      ism_proton_energy_ev: ism_proton_energy_ev,
      ism_proton_energy_human: format_particle_energy(ism_proton_energy_ev),
      ism_power_load_w_m2: ism_power_load_w_m2,
      ism_power_load_w_m2_human: format_scientific(ism_power_load_w_m2, unit: "W/m²"),
      ism_total_hits_m2: ism_total_hits_m2,
      ism_total_hits_m2_human: format_scientific(ism_total_hits_m2, unit: "atoms/m²"),
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

  def minimum_possible_travel_years
    distance_km / SPEED_OF_LIGHT_KM_S / SECONDS_PER_YEAR
  end

  def lorentz_gamma
    beta = propulsion_system.velocity_fraction_c
    return Float::INFINITY if beta >= 1
    1.0 / Math.sqrt(1.0 - (beta * beta))
  end

  def crew_proper_time_years
    travel_time_years / lorentz_gamma
  end

  def kinetic_energy_joules
    # Relativistic kinetic energy: KE = (gamma - 1) m c^2
    (lorentz_gamma - 1.0) * payload_mass_kg * SPEED_OF_LIGHT_M_S * SPEED_OF_LIGHT_M_S
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

    if propulsion_system.velocity_fraction_c >= 0.1
      checks << "Relativistic effects matter here: ship time and Earth time diverge by a Lorentz factor of #{lorentz_gamma.round(3)}."
    end
    
    if !solar_system? && propulsion_system.velocity_fraction_c >= 0.1
      checks << "Interstellar medium impacts become severe at this speed: each hydrogen atom hits at ~#{format_particle_energy(ism_proton_energy_ev)}, creating significant shielding and radiation challenges."
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
    ve_fraction_c = propulsion_system.exhaust_velocity_km_s / SPEED_OF_LIGHT_KM_S
    beta = propulsion_system.velocity_fraction_c
    return Float::INFINITY if beta >= 1 || ve_fraction_c <= 0

    exponent = Math.atanh(beta) / ve_fraction_c
    return Float::INFINITY if exponent > 709 # exp overflow guard for doubles
    Math.exp(exponent)
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

  def doppler_departure_redshift_factor
    beta = propulsion_system.velocity_fraction_c
    Math.sqrt((1.0 - beta) / (1.0 + beta))
  end

  def doppler_arrival_blueshift_factor
    1.0 / doppler_departure_redshift_factor
  end

  def ism_atom_flux_m2_s
    ISM_HYDROGEN_DENSITY_PER_M3 * propulsion_system.velocity_km_s * 1000.0
  end

  def ism_atom_flux_cm2_s
    ism_atom_flux_m2_s / 10_000.0
  end

  def ism_proton_energy_joules
    (lorentz_gamma - 1.0) * PROTON_MASS_KG * SPEED_OF_LIGHT_M_S * SPEED_OF_LIGHT_M_S
  end

  def ism_proton_energy_ev
    ism_proton_energy_joules * EV_PER_JOULE
  end

  def ism_power_load_w_m2
    ism_atom_flux_m2_s * ism_proton_energy_joules
  end

  def ism_total_hits_m2
    ISM_HYDROGEN_DENSITY_PER_M3 * distance_km * 1000.0
  end

  def format_particle_energy(ev)
    if ev >= 1e9
      "#{(ev / 1e9).round(2)} GeV"
    elsif ev >= 1e6
      "#{(ev / 1e6).round(2)} MeV"
    elsif ev >= 1e3
      "#{(ev / 1e3).round(2)} keV"
    else
      "#{ev.round(2)} eV"
    end
  end

  def format_scientific(value, unit:, sig_figs: 3)
    return "∞ #{unit}" unless value.finite?
    return "0 #{unit}" if value.zero?

    abs = value.abs
    if abs >= 1e5 || abs < 1e-2
      exponent = Math.log10(abs).floor
      coeff = value / (10 ** exponent)
      "#{coeff.round(sig_figs - 1)}e#{exponent >= 0 ? '+' : ''}#{exponent} #{unit}"
    else
      "#{value.round(2)} #{unit}"
    end
  end
end
