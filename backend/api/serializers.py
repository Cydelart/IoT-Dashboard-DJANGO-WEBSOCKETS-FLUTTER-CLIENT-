from rest_framework import serializers
from django.contrib.auth.models import User
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



class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = "__all__"





class FieldSerializer(serializers.ModelSerializer):
    class Meta:
        model = Field
        fields = "__all__"




class DeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = "__all__"




class TelemetrySerializer(serializers.ModelSerializer):
    class Meta:
        model = Telemetry
        fields = "__all__"




class AlertSerializer(serializers.ModelSerializer):
    class Meta:
        model = Alert
        fields = "__all__"



class ActuatorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Actuator
        fields = '_all_'

class ActuatorCommandSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActuatorCommand
        fields = '_all_'

class ThresholdRuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = ThresholdRule
        fields = '_all_'

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = '_all_'