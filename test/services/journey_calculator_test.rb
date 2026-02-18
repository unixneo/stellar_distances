require "test_helper"

class JourneyCalculatorTest < ActiveSupport::TestCase
  # Helpers to build calculators from fixtures
  def calc(star_key, ps_key, payload: 1000)
    JourneyCalculator.new(
      star: stars(star_key),
      propulsion_system: propulsion_systems(ps_key),
      payload_mass_kg: payload
    )
  end

  def result(star_key, ps_key, payload: 1000)
    calc(star_key, ps_key, payload: payload).calculate
  end

  # =========================================================
  # Travel time
  # =========================================================

  test "travel time for Proxima Centauri with Voyager is ~74,900 years" do
    # 4.2465 ly × 9.461e12 km/ly / 17 km/s / 31,557,600 s/yr ≈ 74,897 years
    years = result(:proxima_centauri, :voyager)[:travel_time_years]
    assert_in_delta 74_897, years, 200
  end

  test "travel time scales linearly with distance" do
    proxima = result(:proxima_centauri, :voyager)[:travel_time_years]
    # Andromeda is 2,537,000 / 4.2465 ≈ 597,667× further
    andromeda = result(:andromeda, :voyager)[:travel_time_years]
    ratio = andromeda / proxima
    expected_ratio = 2_537_000.0 / 4.2465
    assert_in_delta expected_ratio, ratio, 100  # Allow for floating-point precision
  end

  test "travel time scales inversely with velocity" do
    # Antimatter (100,000 km/s) is 100,000/17 ≈ 5882× faster than Voyager (17 km/s)
    voyager_time = result(:proxima_centauri, :voyager)[:travel_time_years]
    antimatter_time = result(:proxima_centauri, :antimatter)[:travel_time_years]
    ratio = voyager_time / antimatter_time
    assert_in_delta 100_000.0 / 17.0, ratio, 10
  end

  test "round trip is exactly twice the one-way time" do
    r = result(:proxima_centauri, :voyager)
    assert_in_delta r[:travel_time_years] * 2, r[:round_trip_years], 0.001
  end

  # =========================================================
  # Solar system detection
  # =========================================================

  test "Mars is flagged as solar system" do
    assert result(:mars, :voyager)[:is_solar_system]
  end

  test "Proxima Centauri is not solar system" do
    assert_not result(:proxima_centauri, :voyager)[:is_solar_system]
  end

  test "solar system result includes realistic travel data" do
    r = result(:mars, :voyager)
    assert_equal 255.0, r[:realistic_travel_days]
    assert r[:realistic_travel_human].present?
  end

  test "solar system result without realistic_travel_days omits those keys" do
    r = result(:oort_cloud, :voyager)
    assert_nil r[:realistic_travel_days]
  end

  test "interstellar result does not include realistic travel data" do
    r = result(:proxima_centauri, :voyager)
    assert_nil r[:realistic_travel_days]
  end

  # =========================================================
  # Communication delay
  # =========================================================

  test "communication delay equals distance in light years" do
    r = result(:proxima_centauri, :voyager)
    assert_in_delta 4.2465, r[:communication_delay_years], 0.001
  end

  test "round trip communication is double one-way" do
    r = result(:proxima_centauri, :voyager)
    assert_in_delta r[:communication_delay_years] * 2, r[:round_trip_communication_years], 0.001
  end

  # =========================================================
  # Energy calculations
  # =========================================================

  test "kinetic energy equals 0.5 * m * v^2" do
    # v = 17 km/s = 17,000 m/s; m = 1000 kg
    # KE = 0.5 × 1000 × 17000² = 1.445e11 J
    expected = 0.5 * 1000 * (17_000 ** 2)
    assert_in_delta expected, result(:proxima_centauri, :voyager)[:kinetic_energy_joules], 1e6
  end

  test "kinetic energy scales with payload mass" do
    r1 = result(:proxima_centauri, :voyager, payload: 1000)[:kinetic_energy_joules]
    r2 = result(:proxima_centauri, :voyager, payload: 2000)[:kinetic_energy_joules]
    assert_in_delta r1 * 2, r2, 1
  end

  test "energy_in_hiroshima_bombs divides by correct constant" do
    r = result(:proxima_centauri, :voyager)
    expected = r[:kinetic_energy_joules] / JourneyCalculator::HIROSHIMA_BOMB_JOULES
    assert_in_delta expected, r[:energy_in_hiroshima_bombs], 0.001
  end

  # =========================================================
  # Generations
  # =========================================================

  test "generations is travel time divided by 25 rounded up" do
    r = result(:proxima_centauri, :voyager)
    expected = (r[:travel_time_years] / 25.0).ceil
    assert_equal expected, r[:generations]
  end

  # =========================================================
  # Feasibility assessment
  # =========================================================

  test "feasibility is possible for trips under 50 years" do
    # Solar sail at 200 km/s to nearby solar system object
    r = result(:mars, :solar_sail)
    assert_equal "possible", r[:feasibility_assessment][:level]
  end

  test "feasibility is impossible for trips exceeding 100,000 years" do
    r = result(:andromeda, :voyager)
    assert_equal "impossible", r[:feasibility_assessment][:level]
  end

  test "feasibility is civilization_scale for trips between 1,000 and 100,000 years" do
    r = result(:proxima_centauri, :voyager)
    assert_equal "civilization_scale", r[:feasibility_assessment][:level]
  end

  # =========================================================
  # Reality checks
  # =========================================================

  test "reality check warns when travel > 80 years" do
    r = result(:proxima_centauri, :voyager)
    assert r[:reality_check].any? { |c| c.include?("not live to see") }
  end

  test "reality check warns about technology readiness for Far Future systems" do
    r = result(:proxima_centauri, :antimatter)
    assert r[:reality_check].any? { |c| c.include?("may never be practical") }
  end

  test "reality check includes solar sail name check" do
    r = result(:proxima_centauri, :solar_sail, payload: 1000)
    # Solar Sail is propellantless, so different checks apply
    assert r[:reality_check].present?
  end

  test "reality check warns about extreme mass ratio for interstellar rockets" do
    r = result(:proxima_centauri, :nuclear_pulse)
    assert r[:reality_check].any? { |c| c.include?("mass ratio") }
  end

  test "reality check does not warn about mass ratio for solar system trips" do
    r = result(:mars, :nuclear_pulse)
    assert_not r[:reality_check].any? { |c| c.include?("mass ratio") }
  end

  # =========================================================
  # Tsiolkovsky fuel calculations
  # =========================================================

  test "propellantless system has nil mass ratios" do
    r = result(:proxima_centauri, :solar_sail)
    assert_nil r[:mass_ratio_one_way]
    assert_nil r[:mass_ratio_with_decel]
    assert_nil r[:mass_ratio_round_trip]
    assert_nil r[:fuel_mass_one_way_human]
  end

  test "propellantless flag and reason are set for solar sail" do
    r = result(:proxima_centauri, :solar_sail)
    assert r[:propellantless]
    assert_includes r[:propellantless_reason], "photon pressure"
  end

  test "propellantless is false for chemical rocket" do
    r = result(:proxima_centauri, :voyager)
    assert_not r[:propellantless]
  end

  test "mass_ratio_one_way equals e^(v/Ve)" do
    # Voyager: v=17, Ve=4.5 → e^(17/4.5) ≈ 43.72
    expected = Math::E ** (17.0 / 4.5)
    assert_in_delta expected, result(:proxima_centauri, :voyager)[:mass_ratio_one_way], 0.01
  end

  test "mass_ratio_with_decel is the square of mass_ratio_one_way" do
    r = result(:proxima_centauri, :voyager)
    assert_in_delta r[:mass_ratio_one_way] ** 2, r[:mass_ratio_with_decel], 0.1
  end

  test "mass_ratio_round_trip is the fourth power of mass_ratio_one_way" do
    r = result(:proxima_centauri, :voyager)
    assert_in_delta r[:mass_ratio_one_way] ** 4, r[:mass_ratio_round_trip], 1.0
  end

  test "fuel_mass_one_way_kg equals payload × (ratio - 1)" do
    r = result(:proxima_centauri, :voyager)
    expected = 1000 * (r[:mass_ratio_one_way] - 1)
    assert_in_delta expected, r[:fuel_mass_one_way_kg], 0.1
  end

  test "fuel mass is proportional to payload" do
    r1 = result(:proxima_centauri, :voyager, payload: 1000)[:fuel_mass_one_way_kg]
    r2 = result(:proxima_centauri, :voyager, payload: 2000)[:fuel_mass_one_way_kg]
    assert_in_delta r1 * 2, r2, 0.1
  end

  test "mass ratio does not depend on destination distance" do
    # The rocket equation only cares about Δv (velocity), not distance
    proxima = result(:proxima_centauri, :voyager)[:mass_ratio_one_way]
    andromeda = result(:andromeda, :voyager)[:mass_ratio_one_way]
    assert_in_delta proxima, andromeda, 0.001
  end

  test "high Ve gives much smaller mass ratio than low Ve" do
    voyager_ratio = result(:proxima_centauri, :voyager)[:mass_ratio_one_way]      # Ve=4.5
    antimatter_ratio = result(:proxima_centauri, :antimatter)[:mass_ratio_one_way] # Ve=150,000
    assert antimatter_ratio < voyager_ratio
  end

  # =========================================================
  # format_mass
  # =========================================================

  # Access private method via send for direct unit testing
  def fmt(kg)
    JourneyCalculator.new(
      star: stars(:proxima_centauri),
      propulsion_system: propulsion_systems(:voyager),
      payload_mass_kg: 1000
    ).send(:format_mass, kg)
  end

  test "format_mass: grams-scale returns kg" do
    assert_equal "500.0 kg", fmt(500)
  end

  test "format_mass: 1500 kg returns tonnes" do
    assert_equal "1.5 tonnes", fmt(1_500)
  end

  test "format_mass: 3.65e9 kg returns billion tonnes" do
    assert_includes fmt(3.65e9), "billion tonnes"
  end

  test "format_mass: 2.13e13 kg returns trillion tonnes" do
    assert_includes fmt(2.13e13), "trillion tonnes"
  end

  test "format_mass: 1e15 kg returns quadrillion tonnes" do
    assert_includes fmt(1e15), "quadrillion tonnes"
  end

  test "format_mass: 1e18 kg returns quintillion tonnes" do
    assert_includes fmt(1e18), "quintillion tonnes"
  end

  test "format_mass: 1 Earth mass returns Earth masses" do
    assert_includes fmt(5.972e24), "Earth masses"
  end

  test "format_mass: 1 Solar mass returns Solar masses" do
    assert_includes fmt(1.989e30), "Solar masses"
  end

  test "format_mass: infinity returns incalculably large" do
    assert_equal "incalculably large", fmt(Float::INFINITY)
  end

  test "format_mass: values over 1e50 return incalculably large" do
    assert_equal "incalculably large", fmt(1e51)
  end

  # =========================================================
  # Result hash completeness
  # =========================================================

  test "calculate returns all expected keys" do
    r = result(:proxima_centauri, :voyager)
    expected_keys = %i[
      star propulsion_system payload_mass_kg
      distance_km distance_ly
      velocity_km_s velocity_fraction_c
      travel_time_seconds travel_time_years travel_time_human
      round_trip_years
      communication_delay_years round_trip_communication_years
      kinetic_energy_joules energy_in_hiroshima_bombs energy_in_world_years
      generations feasibility_assessment reality_check
      is_solar_system calculation_method calculation_disclaimer
      propellantless propellantless_reason exhaust_velocity_km_s
      mass_ratio_one_way fuel_mass_one_way_kg fuel_mass_one_way_human
      mass_ratio_with_decel fuel_mass_with_decel_kg fuel_mass_with_decel_human
      mass_ratio_round_trip fuel_mass_round_trip_kg fuel_mass_round_trip_human
    ]
    expected_keys.each do |key|
      assert r.key?(key), "Missing key: #{key}"
    end
  end
end
