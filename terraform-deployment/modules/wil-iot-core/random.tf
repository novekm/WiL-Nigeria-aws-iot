// Generate UUID for each Mini Pupper defined in main.tf
resource "random_string" "random_wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  length   = 8
  special  = false
  # override_special = "/@£$"
}
// Generate UUID for each Gas Sensor defined in main.tf
resource "random_string" "random_wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  length   = 8
  special  = false
  # override_special = "/@£$"
}
