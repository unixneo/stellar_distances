# Speed of light in km/s
SPEED_OF_LIGHT_KM_S = 299_792.458

# Light year in km
LIGHT_YEAR_KM = 9.461e12

# Clear existing data
Star.destroy_all
PropulsionSystem.destroy_all

# === STARS ===
# Nearby stars with accurate distances

stars_data = [
  {
    name: "Proxima Centauri",
    distance_ly: 4.2465,
    constellation: "Centaurus",
    star_type: "Red Dwarf (M5.5Ve)",
    notes: "Closest star to the Sun. Has at least two confirmed exoplanets including Proxima b in the habitable zone."
  },
  {
    name: "Alpha Centauri A",
    distance_ly: 4.37,
    constellation: "Centaurus",
    star_type: "Yellow Dwarf (G2V)",
    notes: "Similar to our Sun. Part of a triple star system with Alpha Centauri B and Proxima Centauri."
  },
  {
    name: "Alpha Centauri B",
    distance_ly: 4.37,
    constellation: "Centaurus",
    star_type: "Orange Dwarf (K1V)",
    notes: "Binary partner of Alpha Centauri A. Slightly smaller and cooler than the Sun."
  },
  {
    name: "Barnard's Star",
    distance_ly: 5.963,
    constellation: "Ophiuchus",
    star_type: "Red Dwarf (M4Ve)",
    notes: "Second closest star system. Has the largest proper motion of any known star. Target of Project Daedalus study."
  },
  {
    name: "Wolf 359",
    distance_ly: 7.86,
    constellation: "Leo",
    star_type: "Red Dwarf (M6.5Ve)",
    notes: "One of the faintest and lowest-mass stars known. Famous from Star Trek as site of a Borg battle."
  },
  {
    name: "Lalande 21185",
    distance_ly: 8.31,
    constellation: "Ursa Major",
    star_type: "Red Dwarf (M2V)",
    notes: "One of the nearest stars to Earth. Possibly has planetary companions."
  },
  {
    name: "Sirius A",
    distance_ly: 8.6,
    constellation: "Canis Major",
    star_type: "White Main Sequence (A1V)",
    notes: "Brightest star in Earth's night sky. Binary system with white dwarf companion Sirius B."
  },
  {
    name: "Luyten 726-8 (UV Ceti)",
    distance_ly: 8.73,
    constellation: "Cetus",
    star_type: "Red Dwarf (M5.5Ve)",
    notes: "Prototype flare star. Binary system of two red dwarfs."
  },
  {
    name: "Ross 154",
    distance_ly: 9.7,
    constellation: "Sagittarius",
    star_type: "Red Dwarf (M3.5Ve)",
    notes: "Flare star with periodic brightness increases."
  },
  {
    name: "Ross 248",
    distance_ly: 10.3,
    constellation: "Andromeda",
    star_type: "Red Dwarf (M5.5Ve)",
    notes: "Will become the closest star to the Sun in about 36,000 years due to its motion."
  },
  {
    name: "Epsilon Eridani",
    distance_ly: 10.5,
    constellation: "Eridanus",
    star_type: "Orange Dwarf (K2V)",
    notes: "Young star with confirmed debris disk and at least one planet. Popular target for SETI."
  },
  {
    name: "Lacaille 9352",
    distance_ly: 10.7,
    constellation: "Piscis Austrinus",
    star_type: "Red Dwarf (M1.5Ve)",
    notes: "One of the nearest stars visible to the naked eye from southern hemisphere."
  },
  {
    name: "Ross 128",
    distance_ly: 11.0,
    constellation: "Virgo",
    star_type: "Red Dwarf (M4V)",
    notes: "Has an Earth-sized planet in the habitable zone. Relatively quiet star with few flares."
  },
  {
    name: "Tau Ceti",
    distance_ly: 11.9,
    constellation: "Cetus",
    star_type: "Yellow Dwarf (G8.5V)",
    notes: "Sun-like star with possible planetary system. Historically popular in science fiction."
  },
  {
    name: "Procyon A",
    distance_ly: 11.5,
    constellation: "Canis Minor",
    star_type: "White-Yellow (F5IV-V)",
    notes: "Eighth brightest star in the sky. Binary with white dwarf companion."
  },
  {
    name: "Vega",
    distance_ly: 25.0,
    constellation: "Lyra",
    star_type: "White Main Sequence (A0V)",
    notes: "Fifth brightest star. Was the northern pole star around 12,000 BCE. Has debris disk."
  },
  {
    name: "Arcturus",
    distance_ly: 36.7,
    constellation: "Boötes",
    star_type: "Red Giant (K0III)",
    notes: "Fourth brightest star. Ancient star from the galactic halo, passing through our neighborhood."
  },
  {
    name: "Betelgeuse",
    distance_ly: 700.0,
    constellation: "Orion",
    star_type: "Red Supergiant (M1-M2)",
    notes: "One of the largest stars visible to naked eye. Expected to explode as supernova within 100,000 years."
  },
  {
    name: "Rigel",
    distance_ly: 860.0,
    constellation: "Orion",
    star_type: "Blue Supergiant (B8Ia)",
    notes: "Seventh brightest star. Luminosity about 120,000 times that of the Sun."
  },
  {
    name: "Deneb",
    distance_ly: 2615.0,
    constellation: "Cygnus",
    star_type: "Blue-White Supergiant (A2Ia)",
    notes: "One of the most luminous stars known. Part of the Summer Triangle asterism."
  },
  {
    name: "Polaris (North Star)",
    distance_ly: 433.0,
    constellation: "Ursa Minor",
    star_type: "Yellow Supergiant (F7Ib)",
    notes: "Current northern pole star. Actually a triple star system. Cepheid variable."
  },
  {
    name: "Sagittarius A* (Galactic Center)",
    distance_ly: 26000.0,
    constellation: "Sagittarius",
    star_type: "Supermassive Black Hole",
    notes: "The supermassive black hole at the center of our Milky Way galaxy. 4 million solar masses."
  },
  {
    name: "Andromeda Galaxy (M31)",
    distance_ly: 2537000.0,
    constellation: "Andromeda",
    star_type: "Spiral Galaxy",
    notes: "Nearest major galaxy. Contains roughly 1 trillion stars. Will collide with Milky Way in 4.5 billion years."
  }
]

stars_data.each do |star|
  Star.create!(
    name: star[:name],
    distance_ly: star[:distance_ly],
    distance_km: star[:distance_ly] * LIGHT_YEAR_KM,
    constellation: star[:constellation],
    star_type: star[:star_type],
    notes: star[:notes]
  )
end

puts "Created #{Star.count} stars"

# === PROPULSION SYSTEMS ===
# Real or theoretically feasible propulsion systems

propulsion_data = [
  {
    name: "Chemical Rocket (Voyager-class)",
    velocity_km_s: 17.0,
    description: "Current technology. Voyager 1 travels at about 17 km/s relative to the Sun. Limited by the energy density of chemical fuels.",
    technology_readiness: "Operational"
  },
  {
    name: "Chemical Rocket (New Horizons)",
    velocity_km_s: 16.26,
    description: "Fastest spacecraft launched from Earth. Reached Pluto in 9.5 years. Chemical propulsion with Jupiter gravity assist.",
    technology_readiness: "Operational"
  },
  {
    name: "Ion Drive (Dawn spacecraft)",
    velocity_km_s: 11.0,
    description: "Xenon ion propulsion. Very efficient but low thrust. Good for long-duration missions within the solar system.",
    technology_readiness: "Operational"
  },
  {
    name: "Solar Sail (Near-Sun deployment)",
    velocity_km_s: 200.0,
    description: "Light pressure propulsion. Theoretical maximum by diving close to the Sun for acceleration. No fuel needed but limited by material strength.",
    technology_readiness: "Demonstrated"
  },
  {
    name: "Nuclear Thermal Rocket (NERVA-class)",
    velocity_km_s: 50.0,
    description: "Nuclear reactor heats propellant. About 2x more efficient than chemical rockets. Was tested in the 1960s-70s.",
    technology_readiness: "Tested Historically"
  },
  {
    name: "Nuclear Pulse (Project Orion)",
    velocity_km_s: 10000.0,
    description: "Propulsion by nuclear bomb explosions. Studied in 1950s-60s. Could theoretically reach 3-5% of light speed. Banned by treaties.",
    technology_readiness: "Theoretical (Banned)"
  },
  {
    name: "Laser-Pushed Light Sail (Breakthrough Starshot)",
    velocity_km_s: 60000.0,
    description: "Gram-scale probe accelerated by ground-based laser array to 20% of light speed. Proposed for Alpha Centauri mission. Would take 20-30 years.",
    technology_readiness: "Proposed"
  },
  {
    name: "Fusion Rocket (Project Daedalus)",
    velocity_km_s: 36000.0,
    description: "1970s British Interplanetary Society study. Deuterium/Helium-3 fusion. Designed for 50-year trip to Barnard's Star at 12% c.",
    technology_readiness: "Theoretical"
  },
  {
    name: "Antimatter Rocket (Theoretical)",
    velocity_km_s: 100000.0,
    description: "Matter-antimatter annihilation. Most energetic possible reaction. Current antimatter production is nanograms per year at enormous cost.",
    technology_readiness: "Far Future"
  },
  {
    name: "Bussard Ramjet (Interstellar)",
    velocity_km_s: 290000.0,
    description: "Collects interstellar hydrogen as fuel. Theoretically could approach light speed. Physics may not actually work as hoped.",
    technology_readiness: "Speculative"
  }
]

propulsion_data.each do |prop|
  PropulsionSystem.create!(
    name: prop[:name],
    velocity_km_s: prop[:velocity_km_s],
    velocity_fraction_c: prop[:velocity_km_s] / SPEED_OF_LIGHT_KM_S,
    description: prop[:description],
    technology_readiness: prop[:technology_readiness]
  )
end

puts "Created #{PropulsionSystem.count} propulsion systems"
