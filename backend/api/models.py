from django.db import models
from .enumerations import SENSOR_TYPES, DEVICE_STATUS, ALERT_SEVERITY, ACTUATOR_TYPES, ACTUATOR_COMMAND_SOURCE, USER_ROLES, UNIT_CHOICES
from django.contrib.auth.models import User



class Field(models.Model):
    owner = models.ForeignKey(User,on_delete=models.CASCADE,related_name="fields",null=True, blank=True) # pour éviter les erreurs au début si tu as déjà des données
    name = models.CharField(max_length=100)
    crop_type = models.CharField(max_length=100, blank=True)         
    variety = models.CharField(max_length=100, blank=True)           
    planting_date = models.DateField(null=True, blank=True)         
    soil_type = models.CharField(
        max_length=50,
        blank=True,
        help_text="e.g. clay, sandy, loamy",
    )
    irrigation_type = models.CharField(
        max_length=50,
        blank=True,
        help_text="e.g. drip, sprinkler, sprinkler",
    )
    
    farmer = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="fields_responsible",
    )

    area_m2 = models.FloatField(
        null=True,
        blank=True,
        help_text="Area of the field in square meters",
    )

    def __str__(self):
        return self.name


class Device(models.Model):
    name = models.CharField(max_length=100)

    field = models.ForeignKey(
        Field,
        on_delete=models.CASCADE,
        related_name="devices",
    )

    sensor_type = models.CharField(
        max_length=30,
        choices=SENSOR_TYPES,
    )

    status = models.CharField(
        max_length=10,
        choices=DEVICE_STATUS,
        default="online",
    )

    description = models.TextField(blank=True)
    unit = models.CharField(
        max_length=20,
        choices=UNIT_CHOICES,
    )

    def __str__(self):
        return f"{self.name} ({self.sensor_type} {self.status})"
    


class Telemetry(models.Model):
    device = models.ForeignKey(
        Device,
        on_delete=models.CASCADE,
        related_name="telemetry",
    )
    processed_by_rule = models.BooleanField(default=False)
    # flag to avoid processing a value twice in automation rules

    value = models.FloatField()

    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-timestamp"]

    def __str__(self):
        return f"{self.device.name}: {self.value} at {self.timestamp}"


class Alert(models.Model):
    device = models.ForeignKey(
        Device,
        on_delete=models.CASCADE,
        related_name="alerts",
    )

    message = models.CharField(max_length=255)

    severity = models.CharField(
        max_length=20,
        choices=ALERT_SEVERITY,
        default="warning",
    )

    created_at = models.DateTimeField(auto_now_add=True)

    resolved = models.BooleanField(default=False)

    resolved_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ["-created_at"]  

    def __str__(self):
        return f"[{self.severity}] {self.device.name}: {self.message}"

class Actuator(models.Model):
    name = models.CharField(max_length=50)
    type = models.CharField(max_length=20, choices=ACTUATOR_TYPES)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.name} ({self.get_type_display()})"
    
class ActuatorCommand(models.Model):
    actuator = models.ForeignKey(Actuator, on_delete=models.CASCADE, related_name="commands")
    command = models.BooleanField()  # True = ON, False = OFF
    source = models.CharField(max_length=20, choices=ACTUATOR_COMMAND_SOURCE)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        origin = self.get_source_display()
        action = "ON" if self.command else "OFF"
        return f"{self.actuator.name} → {action} ({origin})"


class ThresholdRule(models.Model):
    sensor_type = models.CharField(max_length=50)  # ex: "SOIL_MOISTURE"
    condition = models.CharField(max_length=20)  # e.g., choices in ENUM
    threshold_value = models.FloatField()
    actuator = models.ForeignKey(Actuator, on_delete=models.CASCADE, related_name="rules")
    action = models.BooleanField()  # True = ON, False = OFF
    enabled = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Rule {self.sensor_type} {self.condition} {self.threshold_value}"


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    role = models.CharField(max_length=20, choices=USER_ROLES)

    def __str__(self):
        return f"{self.user.username} ({self.get_role_display()})"


