// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import RelativitySliderController from "controllers/relativity_slider_controller"

eagerLoadControllersFrom("controllers", application)
application.register("relativity-slider", RelativitySliderController)
