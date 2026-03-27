# TODD

## Probe-Focused Roadmap

1. Shielding and Geometry Model
- Add spacecraft frontal area input (`m^2`).
- Add shield material selection and thickness.
- Convert current ISM metrics from per-`m^2` to vehicle-level loads.
- Estimate shield mass penalties and resulting performance impact.

2. Dust and ISM Hazard Model
- Add dust-grain size distribution (not only average hydrogen atoms).
- Estimate kinetic impact severity by particle size and velocity.
- Surface catastrophic-impact risk as a probability over mission distance.
- Separate cumulative erosion from single-event kill risks.

3. Power and Thermal Closure
- Add propulsion efficiency assumptions.
- Model waste heat generation from propulsion and onboard systems.
- Add radiator sizing and mass implications.
- Show when thermal rejection becomes a hard mission constraint.

4. Finite-Thrust Trajectory Model
- Replace impulsive-burn approximation with finite-thrust integration.
- Model acceleration/deceleration durations explicitly.
- Include mass flow through burn phases.
- Compare integrated trajectory time against current cruise abstraction.

5. Reliability Over Mission Duration
- Add component-level failure-rate assumptions.
- Compute mission survival probability over full duration.
- Support redundancy configurations and their mass overhead.
- Surface reliability as a first-class feasibility metric.

## Out of Scope
- Human factors (life support, crew psychology, medical risk).
