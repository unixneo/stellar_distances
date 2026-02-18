# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Stellar Distance Calculator** is a Rails 7 web application that calculates interstellar travel times using real astronomical distances and physics-based propulsion systems. The app illustrates why interstellar travel is fundamentally impossible within human planning horizons.

The application features 43 destination objects (from the Moon to Andromeda) and 11 propulsion systems (from Voyager-class rockets to theoretical antimatter drives). It includes realistic orbital mechanics for solar system travel and straight-line calculations for interstellar distances.

## Architecture

### Core Components

**Models:**
- **Star** (`app/models/star.rb`): Represents destinations with distance data. Solar system objects store `distance_km` directly; interstellar destinations use `distance_ly` (light years). Includes formatting methods for display and a `solar_system?` helper.
  - Key attributes: `name`, `distance_ly`, `distance_km`, `constellation`, `star_type`, `realistic_travel_days`, `realistic_travel_notes`

- **PropulsionSystem** (`app/models/propulsion_system.rb`): Represents spacecraft/propulsion capabilities. Stores velocity in km/s and optionally pre-computed velocity as fraction of light speed.
  - Key attributes: `name`, `velocity_km_s`, `velocity_fraction_c`, `description`, `technology_readiness`

**Service Layer:**
- **JourneyCalculator** (`app/services/journey_calculator.rb`): The core business logic. Takes a Star, PropulsionSystem, and payload mass, then calculates travel time, energy requirements, communication delays, and feasibility assessments. Returns a comprehensive result hash with formatting and analysis.
  - Key methods: `calculate()` returns hash with all travel metrics, `feasibility_assessment()` provides human-readable assessment, `reality_check()` returns array of sobering contextual facts.

**Controller:**
- **JourneysController** (`app/controllers/journeys_controller.rb`): Simple two-action controller.
  - `index`: Displays form with all stars and propulsion systems (sorted by distance/velocity).
  - `calculate`: Accepts star/propulsion/payload parameters, runs calculator, responds to HTML and turbo_stream formats.

### Key Design Decisions

1. **Calculation Methods**: Solar system destinations use realistic mission data (Hohmann transfers, gravity assists) stored in `realistic_travel_days`. Interstellar distances use straight-line physics (distance/velocity), as orbital mechanics become negligible at light-year scales.

2. **Feasibility Assessments**: The app contextualizes travel times against human history and civilization—showing that Proxima Centauri would take longer than human civilization has existed with current technology.

3. **Energy Calculations**: Kinetic energy is calculated as 0.5 × mass × velocity², then compared to Hiroshima bombs (~63 terajoules) and annual world energy production (~580 exajoules) to illustrate scaling.

4. **No Traditional ORM Queries**: Data is fixture-based (seed data in database). No complex ActiveRecord associations or scopes.

## Database

SQLite with two tables (see `db/schema.rb`):
- **stars**: 43 destinations with distances and contextual notes
- **propulsion_systems**: 11 propulsion types with velocity and technology readiness levels

Both include fixture data included in the repository. `Gemfile.lock` is gitignored since gem versions vary by Ruby version.

## Development

### Setup
```bash
# Install Ruby 3.0.4+
ruby -v

# Install dependencies
bundle install

# Start the server (database already included)
bin/rails server

# Visit http://localhost:3000
```

### Common Commands
```bash
# Run the Rails console (access Star, PropulsionSystem, JourneyCalculator)
bin/rails console

# Start in development with asset pipeline
bin/rails server

# View database schema
bin/rails db:schema:load (rarely needed—database is checked in)

# Reset database to seed data
bin/rails db:reset
```

### Testing
No traditional test suite exists yet. The application is primarily feature-tested manually through the web UI. Consider adding:
- Unit tests for JourneyCalculator calculations (compare against known values)
- Model validations tests
- Controller action tests (calculate endpoint with various payloads)
- System tests for UI interactions

### Code Organization
- **Minimal dependencies**: Uses Rails defaults (no extra gems for validation, serialization, etc.)
- **Calculations live in JourneyCalculator**: Not in models, to keep logic testable and separate
- **Constants**: Physics constants (light speed, Hiroshima bomb energy) are defined in JourneyCalculator and replicated in models where needed
- **Inline CSS**: Tailwind is disabled; styling is in view files or via asset pipeline

## Deployment / Hosting

### Host Authorization
Rails 7 requires explicit host approval. Edit `config/initializers/hosts.rb` to add domains:
```ruby
Rails.application.config.hosts << "yourdomain.com"
```

Default hosts: `www.unix.com`, `unix.com`

### Proxy Setup
Supports proxied access via Apache reverse proxy. Routes work at both `/` and `/stellar/journey`:
```apache
RewriteRule ^(stellar.*)$ http://127.0.0.1:3002/$1 [P,L,END,QSA]
```

**Important**: The `QSA` flag is required to pass query string parameters (star_id, propulsion_system_id, payload_mass_kg) to Rails.

## Important Notes

1. **Physics Constants**: Light year conversion (9.461e12 km), speed of light (299,792.458 km/s), and energy constants are duplicated across JourneyCalculator, Star, and PropulsionSystem models. Keep them in sync when updating.

2. **Fixture Data**: All destination and propulsion data is fixture-based. No migrations to add new data—update the database directly or add seed data.

3. **Realistic vs. Straight-Line**: Solar system results show both realistic mission times and straight-line calculations. Interstellar only shows straight-line. This distinction is intentional to illustrate orbital mechanics vs. simple physics.

4. **Payload Mass**: Defaults to 1000 kg but accepts user input. The light sail reality check warns if mass > 1 gram (these probes are gram-scale only).

5. **No Authentication**: This is a public educational tool with no auth or user state.

## View Hierarchy

- `app/views/journeys/index.html.erb`: Form to select star, propulsion system, and payload mass
- `app/views/journeys/calculate.html.erb`: Results display with feasibility color coding and reality checks
- Supports Hotwire turbo_stream responses for dynamic updates without page reload

## Debugging

For calculation issues:
1. Open Rails console: `bin/rails console`
2. Create calculator: `calc = JourneyCalculator.new(star: Star.find(1), propulsion_system: PropulsionSystem.find(1), payload_mass_kg: 1000)`
3. Inspect result: `calc.calculate`
4. Check individual methods: `calc.travel_time_years`, `calc.kinetic_energy_joules`, etc.

For database issues:
- Check schema with `bin/rails db:schema:load`
- Inspect fixtures in `test/fixtures/stars.yml` and `test/fixtures/propulsion_systems.yml`
