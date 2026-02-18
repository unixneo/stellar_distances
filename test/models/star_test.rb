require "test_helper"

class StarTest < ActiveSupport::TestCase
  # === Validations ===

  test "valid star passes validation" do
    star = Star.new(name: "Test Star", distance_ly: 4.2)
    assert star.valid?
  end

  test "name is required" do
    star = Star.new(distance_ly: 4.2)
    assert_not star.valid?
    assert_includes star.errors[:name], "can't be blank"
  end

  test "distance_ly is required" do
    star = Star.new(name: "Test Star")
    assert_not star.valid?
    assert_includes star.errors[:distance_ly], "can't be blank"
  end

  test "distance_ly must be positive" do
    star = Star.new(name: "Test Star", distance_ly: -1.0)
    assert_not star.valid?

    star.distance_ly = 0
    assert_not star.valid?
  end

  # === solar_system? ===

  test "solar_system? returns true for Solar System objects" do
    assert stars(:mars).solar_system?
  end

  test "solar_system? returns false for interstellar objects" do
    assert_not stars(:proxima_centauri).solar_system?
  end

  # === distance_km ===

  test "distance_km returns stored value when present" do
    star = stars(:mars)
    assert_equal 225_000_000, star.distance_km
  end

  test "distance_km calculates from distance_ly when not stored" do
    star = Star.new(name: "Test", distance_ly: 1.0)
    expected = 1.0 * Star::LIGHT_YEAR_KM
    assert_in_delta expected, star.distance_km, 1e6
  end

  # === formatted_distance ===

  test "formatted_distance shows km for close solar system objects" do
    moon = Star.new(name: "Moon", distance_ly: 0.0000000406, distance_km: 384_400,
                    constellation: "Solar System", star_type: "Satellite")
    assert_includes moon.formatted_distance, "km"
  end

  test "formatted_distance shows light years for interstellar objects" do
    assert_includes stars(:proxima_centauri).formatted_distance, "ly"
  end

  test "formatted_distance shows million ly for Andromeda" do
    assert_includes stars(:andromeda).formatted_distance, "million ly"
  end

  test "formatted_distance shows billion km for outer solar system" do
    assert_includes stars(:oort_cloud).formatted_distance, "billion km"
  end
end
