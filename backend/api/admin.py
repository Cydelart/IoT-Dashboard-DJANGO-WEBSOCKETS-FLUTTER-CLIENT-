from django.contrib import admin
from .models import (
    Field,
    Device,
    Telemetry,
    Alert,
    Actuator,
    ActuatorCommand,
    ThresholdRule,
    UserProfile,
)

admin.site.register(Field)
admin.site.register(Device)
admin.site.register(Telemetry)
admin.site.register(Alert)
admin.site.register(Actuator)
admin.site.register(ActuatorCommand)
admin.site.register(ThresholdRule)
admin.site.register(UserProfile)
