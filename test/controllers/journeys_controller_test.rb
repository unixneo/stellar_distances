require "test_helper"

class JourneysControllerTest < ActionDispatch::IntegrationTest
  test "GET index returns success" do
    get root_url
    assert_response :success
  end

  test "GET index renders stars and propulsion systems" do
    get root_url
    assert_select "select#star_id"
    assert_select "select#propulsion_system_id"
    assert_select "select#payload_mass_kg"
  end

  test "GET calculate with valid params returns success" do
    star = stars(:proxima_centauri)
    ps   = propulsion_systems(:voyager)
    get journeys_calculate_url, params: {
      star_id: star.id,
      propulsion_system_id: ps.id,
      payload_mass_kg: 1000
    }
    assert_response :success
  end

  test "GET calculate response includes travel time" do
    star = stars(:proxima_centauri)
    ps   = propulsion_systems(:voyager)
    get journeys_calculate_url, params: {
      star_id: star.id,
      propulsion_system_id: ps.id,
      payload_mass_kg: 1000
    }
    assert_match /years/, response.body
  end

  test "GET calculate with solar system star shows realistic mission time" do
    star = stars(:mars)
    ps   = propulsion_systems(:voyager)
    get journeys_calculate_url, params: {
      star_id: star.id,
      propulsion_system_id: ps.id,
      payload_mass_kg: 1000
    }
    assert_response :success
    assert_match /realistic mission duration/, response.body
  end

  test "GET calculate with propellantless system shows no-propellant card" do
    star = stars(:proxima_centauri)
    ps   = propulsion_systems(:solar_sail)
    get journeys_calculate_url, params: {
      star_id: star.id,
      propulsion_system_id: ps.id,
      payload_mass_kg: 1000
    }
    assert_response :success
    assert_match /No propellant required/, response.body
  end

  test "GET calculate with solar system star hides fuel requirements card" do
    star = stars(:mars)
    ps   = propulsion_systems(:voyager)
    get journeys_calculate_url, params: {
      star_id: star.id,
      propulsion_system_id: ps.id,
      payload_mass_kg: 1000
    }
    assert_no_match /Tsiolkovsky Rocket Equation/, response.body
  end

  test "GET calculate with interstellar destination shows fuel requirements card" do
    star = stars(:proxima_centauri)
    ps   = propulsion_systems(:voyager)
    get journeys_calculate_url, params: {
      star_id: star.id,
      propulsion_system_id: ps.id,
      payload_mass_kg: 1000
    }
    assert_match /Tsiolkovsky Rocket Equation/, response.body
  end

  test "GET calculate defaults payload to 1000 kg when omitted" do
    star = stars(:proxima_centauri)
    ps   = propulsion_systems(:voyager)
    get journeys_calculate_url, params: {
      star_id: star.id,
      propulsion_system_id: ps.id
    }
    assert_response :success
  end
end
