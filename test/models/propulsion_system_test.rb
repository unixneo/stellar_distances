require "test_helper"

class PropulsionSystemTest < ActiveSupport::TestCase
  # === Validations ===

  test "valid propulsion system passes validation" do
    ps = PropulsionSystem.new(name: "Test Engine", velocity_km_s: 17.0)
    assert ps.valid?
  end

  test "name is required" do
    ps = PropulsionSystem.new(velocity_km_s: 17.0)
    assert_not ps.valid?
    assert_includes ps.errors[:name], "can't be blank"
  end

  test "velocity_km_s is required" do
    ps = PropulsionSystem.new(name: "Test Engine")
    assert_not ps.valid?
  end

  test "velocity_km_s must be positive" do
    ps = PropulsionSystem.new(name: "Test Engine", velocity_km_s: 0)
    assert_not ps.valid?

    ps.velocity_km_s = -5
    assert_not ps.valid?
  end

  # === propellantless? ===

  test "propellantless? returns true when exhaust_velocity_km_s is nil" do
    assert propulsion_systems(:solar_sail).propellantless?
  end

  test "propellantless? returns false when exhaust_velocity_km_s is set" do
    assert_not propulsion_systems(:voyager).propellantless?
  end

  # === velocity_fraction_c ===

  test "velocity_fraction_c returns stored value when present" do
    ps = propulsion_systems(:antimatter)
    assert_in_delta 0.3336, ps.velocity_fraction_c, 0.001
  end

  test "velocity_fraction_c calculates from velocity_km_s when not stored" do
    ps = PropulsionSystem.new(name: "Test", velocity_km_s: 29979.2458)
    expected = 29979.2458 / PropulsionSystem::SPEED_OF_LIGHT_KM_S
    assert_in_delta expected, ps.velocity_fraction_c, 0.0001
  end

  # === formatted_velocity ===

  test "formatted_velocity shows km/s for slow systems" do
    assert_includes propulsion_systems(:voyager).formatted_velocity, "km/s"
  end

  test "formatted_velocity shows percent of light speed for fast systems" do
    assert_includes propulsion_systems(:antimatter).formatted_velocity, "% of light speed"
  end

  test "formatted_velocity threshold is 1% of light speed" do
    # 1% c = 2997.9 km/s — anything at or above shows as % c
    fast = PropulsionSystem.new(name: "Fast", velocity_km_s: 3000, velocity_fraction_c: 0.01)
    assert_includes fast.formatted_velocity, "% of light speed"

    slow = PropulsionSystem.new(name: "Slow", velocity_km_s: 100, velocity_fraction_c: 0.0003)
    assert_includes slow.formatted_velocity, "km/s"
  end
end
