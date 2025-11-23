SENSOR_TYPES = [
    ("moisture", "Soil Moisture"),
    ("temperature", "Air Temperature"),
    ("humidity", "Air Humidity"),
    ("light", "Light Intensity"),
    ("rain", "Rain Detector"),
]

UNIT_CHOICES = [
    ("percent", "%"),          # soil moisture, humidity
    ("celsius", "°C"),         # temperature
    ("lux", "Lux"),            # light intensity
    ("boolean", "On/Off"),     # rain detector, switches
]

DEVICE_STATUS = [
    ("online", "Online"),
    ("offline", "Offline"),
    ("error", "Error"),
]


ALERT_SEVERITY = [
    ("info", "Info"),
    ("warning", "Warning"),
    ("critical", "Critical"),
]


ACTUATOR_TYPES = [
    ("pump", "Irrigation Pump"),
    ("fan", "Ventilation Fan"),
    ("light", "Grow Light"),
]


ACTUATOR_COMMAND_SOURCE = [
    ("manual", "Manual"),
    ("auto", "Automatic Rule"),
]


USER_ROLES = [
    ("admin", "Admin"),
    ("farmer", "Farmer"),
    ("worker", "Worker"),
]