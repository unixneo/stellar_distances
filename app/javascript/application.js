// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const SPEED_OF_LIGHT_KM_S = 299792.458
const SPEED_OF_LIGHT_M_S = 299792458
const SECONDS_PER_YEAR = 31557600
const WORLD_ANNUAL_ENERGY_J = 5.8e20
const HIROSHIMA_BOMB_J = 63e12

function formatNumber(value, decimals) {
  return Number(value).toLocaleString(undefined, {
    minimumFractionDigits: 0,
    maximumFractionDigits: decimals
  })
}

function formatYears(years) {
  if (years >= 1e9) return `${(years / 1e9).toFixed(2)} billion years`
  if (years >= 1e6) return `${(years / 1e6).toFixed(2)} million years`
  if (years >= 1000) return `${formatNumber(years, 0)} years`
  if (years >= 1) return `${years.toFixed(1)} years`
  if (years >= 1 / 12) return `${(years * 12).toFixed(1)} months`
  return `${(years * (SECONDS_PER_YEAR / 86400)).toFixed(1)} days`
}

function formatWorldYears(worldYears) {
  if (worldYears < 0.001) return `${(worldYears * 365.25).toFixed(2)} days`
  if (worldYears < 1) return `${(worldYears * 12).toFixed(1)} months`
  return `${formatNumber(worldYears, 2)} years`
}

function formatMass(kg) {
  if (!Number.isFinite(kg) || kg > 1e50) return "Incalculably large"
  if (kg < 1000) return `${kg.toFixed(1)} kg`
  if (kg < 1e6) return `${(kg / 1000).toFixed(1)} tonnes`
  if (kg < 1e9) return `${(kg / 1e6).toFixed(1)} million tonnes`
  if (kg < 1e12) return `${(kg / 1e9).toFixed(1)} billion tonnes`
  if (kg < 1e15) return `${(kg / 1e12).toFixed(1)} trillion tonnes`
  return `${(kg / 5.972e24).toFixed(2)} Earth masses`
}

function drawCurve(widget, markerBeta, payloadMassKg) {
  const curve = widget.querySelector('[data-relativity-slider-target="curve"]')
  if (!curve) return

  const width = 640
  const height = 240
  const pad = { l: 40, r: 10, t: 10, b: 26 }
  const maxBeta = 0.999
  const points = []
  let minY = Infinity
  let maxY = -Infinity

  for (let i = 0; i <= 200; i += 1) {
    const beta = maxBeta * (i / 200)
    const gamma = 1 / Math.sqrt(1 - beta * beta)
    const kinetic = (gamma - 1) * payloadMassKg * SPEED_OF_LIGHT_M_S * SPEED_OF_LIGHT_M_S
    const yVal = Math.log10(Math.max(kinetic, 1))
    points.push({ beta, yVal })
    minY = Math.min(minY, yVal)
    maxY = Math.max(maxY, yVal)
  }

  const xScale = (beta) => pad.l + (beta / maxBeta) * (width - pad.l - pad.r)
  const yScale = (y) => pad.t + (1 - (y - minY) / (maxY - minY || 1)) * (height - pad.t - pad.b)
  const polyline = points.map((p) => `${xScale(p.beta).toFixed(2)},${yScale(p.yVal).toFixed(2)}`).join(" ")

  const mb = Math.min(maxBeta, markerBeta)
  const mg = 1 / Math.sqrt(1 - mb * mb)
  const mk = (mg - 1) * payloadMassKg * SPEED_OF_LIGHT_M_S * SPEED_OF_LIGHT_M_S
  const my = Math.log10(Math.max(mk, 1))
  const marker = `<circle cx="${xScale(mb).toFixed(2)}" cy="${yScale(my).toFixed(2)}" r="4" fill="#ea580c" />`

  curve.innerHTML = `
    <line x1="${pad.l}" y1="${height - pad.b}" x2="${width - pad.r}" y2="${height - pad.b}" stroke="#94a3b8" stroke-width="1" />
    <line x1="${pad.l}" y1="${pad.t}" x2="${pad.l}" y2="${height - pad.b}" stroke="#94a3b8" stroke-width="1" />
    <polyline points="${polyline}" fill="none" stroke="#ea580c" stroke-width="2" />
    <text x="${width - 48}" y="${height - 8}" fill="#64748b" font-size="11">v/c</text>
    <text x="6" y="16" fill="#64748b" font-size="11">log10(J)</text>
    ${marker}
  `
}

function updateWidget(widget) {
  const slider = widget.querySelector('[data-relativity-slider-target="slider"]')
  if (!slider) return

  const payloadMassKg = parseFloat(widget.dataset.relativitySliderPayloadMassKgValue || "1000")
  const distanceLy = parseFloat(widget.dataset.relativitySliderDistanceLyValue || "0")
  const exhaustVelocityKmS = parseFloat(widget.dataset.relativitySliderExhaustVelocityKmSValue || "0")
  const propellantless = widget.dataset.relativitySliderPropellantlessValue === "true"

  const beta = Math.min(0.999999, Math.max(0.000001, parseFloat(slider.value || "0.001")))
  const gamma = 1 / Math.sqrt(1 - beta * beta)
  const velocityKmS = beta * SPEED_OF_LIGHT_KM_S
  const earthYears = distanceLy / beta
  const crewYears = earthYears / gamma
  const kineticJ = (gamma - 1) * payloadMassKg * SPEED_OF_LIGHT_M_S * SPEED_OF_LIGHT_M_S
  const worldYears = kineticJ / WORLD_ANNUAL_ENERGY_J
  const bombs = kineticJ / HIROSHIMA_BOMB_J

  const set = (target, text) => {
    const el = widget.querySelector(`[data-relativity-slider-target="${target}"]`)
    if (el) el.textContent = text
  }

  set("velocityPercent", `${(beta * 100).toFixed(2)}% c`)
  set("velocityKmS", `${formatNumber(velocityKmS, 0)} km/s`)
  set("gamma", gamma.toFixed(4))
  set("earthTime", formatYears(earthYears))
  set("crewTime", formatYears(crewYears))
  set("causalityFloor", formatYears(distanceLy))
  set("energyWorld", formatWorldYears(worldYears))
  set("energyBombs", `${formatNumber(bombs, 2)} eq`)

  if (propellantless || exhaustVelocityKmS <= 0) {
    set("massRatio", "N/A")
    set("fuelMass", "No onboard propellant")
  } else {
    const veFrac = exhaustVelocityKmS / SPEED_OF_LIGHT_KM_S
    const exponent = Math.atanh(beta) / veFrac
    const ratio = exponent > 709 ? Infinity : Math.exp(exponent)
    set("massRatio", Number.isFinite(ratio) ? `${formatNumber(ratio, 2)}:1` : "∞")
    set("fuelMass", Number.isFinite(ratio) ? formatMass(payloadMassKg * (ratio - 1)) : "Incalculably large")
  }

  drawCurve(widget, beta, payloadMassKg)
}

function initRelativityWidgets(root) {
  const widgets = root.querySelectorAll('[data-controller~="relativity-slider"]')
  widgets.forEach((widget) => {
    const slider = widget.querySelector('[data-relativity-slider-target="slider"]')
    if (!slider) return

    if (!slider.dataset.initialized) {
      const initialBeta = parseFloat(widget.dataset.relativitySliderInitialBetaValue || "0.001")
      slider.value = Math.min(0.99, Math.max(0.001, initialBeta)).toFixed(3)
      slider.addEventListener("input", () => updateWidget(widget))
      slider.dataset.initialized = "true"
    }

    updateWidget(widget)
  })
}

document.addEventListener("turbo:load", () => initRelativityWidgets(document))
document.addEventListener("turbo:frame-load", (event) => {
  if (event.target instanceof Element) initRelativityWidgets(event.target)
})
