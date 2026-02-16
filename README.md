# 🚀 Stellar Distance Calculator

**Why we will always be alone, even if we're not.**

A Rails application that calculates interstellar travel times using real astronomical distances and physics-based propulsion systems. The results are sobering.

## The Point

This calculator illustrates the fundamental challenge of interstellar travel. Even with theoretical propulsion systems, the distances involved make travel to other star systems effectively impossible within human lifespans—and often within the span of human civilization itself.

## Features

- **34 Destinations**: From the Moon (384,400 km) to the Andromeda Galaxy (2.5 million light years)
- **10 Propulsion Systems**: From current Voyager-class rockets to theoretical antimatter drives
- **Reality Checks**: Contextualizes travel times against human history and civilization
- **Energy Requirements**: Shows kinetic energy needed in Hiroshima bombs and world-years of energy production
- **Communication Delays**: Light-speed message round-trip times

## Sample Results

| Destination | Propulsion | Travel Time |
|------------|------------|-------------|
| The Moon | Voyager-class | 6 hours |
| Mars (average) | Voyager-class | 5 months |
| Pluto | Voyager-class | 11 years |
| Proxima Centauri (4.2 ly) | Voyager-class | 74,889 years |
| Proxima Centauri | Laser Light Sail (20% c) | 21 years |
| Andromeda Galaxy | Antimatter Rocket | 25.4 million years |

## Installation

```bash
# Clone the repository
git clone https://github.com/unixneo/stellar_distances.git
cd stellar_distances

# Install dependencies
bundle install

# Setup database
rails db:migrate
rails db:seed

# Start the server
rails server
```

Visit `http://localhost:3000`

## Requirements

- Ruby 3.2+
- Rails 7.1+
- SQLite3

## Data Sources

### Solar System Distances
Average distances from Earth. Actual distances vary with orbital positions.

### Stellar Distances
Based on current astronomical measurements (parallax, spectroscopic methods).

### Propulsion Systems
- **Operational**: Voyager, New Horizons, Dawn spacecraft actual velocities
- **Demonstrated**: Solar sail technology (IKAROS, LightSail)
- **Tested Historically**: NERVA nuclear thermal rocket program
- **Theoretical**: Project Daedalus, Breakthrough Starshot, antimatter propulsion
- **Speculative**: Bussard ramjet

## The Math

Travel time is calculated simply:

```
time = distance / velocity
```

Kinetic energy:

```
KE = 0.5 × mass × velocity²
```

Energy comparisons:
- Hiroshima bomb: ~63 terajoules
- World annual energy production: ~580 exajoules

## Why This Matters

The universe is not built to human scale. The nearest star is 4.2 light years away—a distance so vast that even at 20% of light speed (far beyond current capability), it would take over 20 years to reach.

At speeds we can actually achieve today, visiting even our closest stellar neighbor would take longer than human civilization has existed.

This isn't pessimism. It's physics.

## License

MIT

## Author

Built with Ruby on Rails and Claude.

---

*"The universe is under no obligation to make sense to you."* — Neil deGrasse Tyson
