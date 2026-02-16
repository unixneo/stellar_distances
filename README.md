# 🚀 Stellar Distance Calculator

**Why we will always be alone, even if we're not.**

A Rails application that calculates interstellar travel times using real astronomical distances and physics-based propulsion systems. The results are sobering.

## The Point

This calculator illustrates the fundamental challenge of interstellar travel. Even with theoretical propulsion systems, the distances involved make travel to other star systems effectively impossible within human lifespans—and often within the span of human civilization itself.

## Features

- **43 Destinations**: From the Moon (384,400 km) to the Andromeda Galaxy (2.5 million light years)
- **11 Propulsion Systems**: From current Voyager-class rockets to theoretical antimatter drives
- **Realistic Orbital Mechanics**: Solar system travel times based on actual mission data (Hohmann transfers, gravity assists)
- **Scientific Disclaimers**: Clear explanations of calculation methodology
- **Reality Checks**: Contextualizes travel times against human history and civilization
- **Energy Requirements**: Shows kinetic energy needed in Hiroshima bombs and world-years of energy production
- **Communication Delays**: Light-speed message round-trip times

## Solar System: Realistic Mission Times

For solar system destinations, travel times are based on actual missions, not straight-line calculations. Spacecraft don't travel in straight lines—they follow curved trajectories determined by orbital mechanics.

| Destination | Realistic Time | Based On |
|------------|---------------|----------|
| The Moon | 3 days | Apollo missions |
| Venus | 110 days | Mariner 2 |
| Mars | 8.5 months | Hohmann transfer orbit |
| Jupiter | 2 years | Varies by trajectory |
| Saturn | 7 years | Cassini-Huygens |
| Uranus | 8.4 years | Voyager 2 |
| Neptune | 12 years | Voyager 2 |
| Pluto | 9.5 years | New Horizons |

## Interstellar: The Sobering Reality

| Destination | Propulsion | Travel Time |
|------------|------------|-------------|
| Proxima Centauri (4.2 ly) | Voyager-class | 74,889 years |
| Proxima Centauri | SpaceX Starship | 57,868 years |
| Proxima Centauri | Laser Light Sail (20% c) | 21 years |
| Andromeda Galaxy | Antimatter Rocket | 25.4 million years |

Note: SpaceX Starship is revolutionary for Mars colonization, but doesn't change the fundamental physics of interstellar travel.

## Propulsion Systems

### Current Technology
- **Chemical Rocket (Voyager-class)**: 17 km/s - Operational
- **Chemical Rocket (New Horizons)**: 16.26 km/s - Operational
- **Ion Drive (Dawn)**: 11 km/s - Operational
- **Solar Sail**: 200 km/s - Demonstrated

### In Development / Near-Future
- **SpaceX Starship**: 22 km/s - In Development
- **Nuclear Thermal (NERVA-class)**: 50 km/s - Tested Historically
- **Laser Light Sail (Breakthrough Starshot)**: 60,000 km/s (20% c) - Proposed

### Theoretical / Speculative
- **Nuclear Pulse (Project Orion)**: 10,000 km/s - Theoretical (Banned)
- **Fusion Rocket (Project Daedalus)**: 36,000 km/s - Theoretical
- **Antimatter Rocket**: 100,000 km/s - Far Future
- **Bussard Ramjet**: 290,000 km/s - Speculative

## Installation

```bash
# Clone the repository
git clone https://github.com/unixneo/stellar_distances.git
cd stellar_distances

# Install dependencies
bundle install

# Start the server (database included)
rails server
```

Visit `http://localhost:3000`

The SQLite database with all destinations and propulsion systems is included in the repository for convenience.

## Host Configuration

Rails 7 requires explicit host authorization. The app is configured for `www.unix.com` by default.

To run on a different host, edit `config/initializers/hosts.rb`:

```ruby
# Allow your host
Rails.application.config.hosts << "your-domain.com"

# Or allow all hosts (development only)
Rails.application.config.hosts.clear
```

## Proxy Deployment

The app includes routes for both direct and proxied access:

- Direct: `/` and `/journeys/calculate`
- Proxied: `/stellar/journey` and `/stellar/journey/calculate`

For Apache reverse proxy:

```apache
RewriteRule ^stellar(/.*)?$ http://127.0.0.1:3002$1 [P,L,END]
```

## Requirements

- Ruby 3.0.4+
- Rails 7.1+
- SQLite3

## The Math

### Interstellar (straight-line calculation)
```
time = distance / velocity
```

This is valid for interstellar distances where orbital mechanics become negligible.

### Solar System (orbital mechanics)
Travel times are based on actual mission data using Hohmann transfer orbits and gravity assists. The straight-line calculation is shown for comparison but doesn't reflect how spacecraft actually navigate.

### Energy Requirements
```
KE = 0.5 × mass × velocity²
```

Energy comparisons:
- Hiroshima bomb: ~63 terajoules
- World annual energy production: ~580 exajoules

## Why This Matters

The universe is not built to human scale. The nearest star is 4.2 light years away—a distance so vast that even at 20% of light speed (far beyond current capability), it would take over 20 years to reach.

At speeds we can actually achieve today (including Starship), visiting even our closest stellar neighbor would take longer than human civilization has existed.

This isn't pessimism. It's physics.

## License

MIT

## Author

Built with Ruby on Rails and Claude.

---

*"The universe is under no obligation to make sense to you."* — Neil deGrasse Tyson
