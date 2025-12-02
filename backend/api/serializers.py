from rest_framework import serializers
from django.contrib.auth.models import User , Group
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

#end point mtaa login 
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["id", "username", "email", "password"]

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User.objects.create_user(
            password=password,
            **validated_data
        )

        # Par défaut, on met le user dans le groupe "farmer"
        farmer_group, created = Group.objects.get_or_create(name="farmer")
        user.groups.add(farmer_group)

        return user



class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = "__all__"




# ---------------------------------------------------------
# FIELD
# ---------------------------------------------------------

class FieldSerializer(serializers.ModelSerializer):
    class Meta:
        model = Field
        fields = "__all__"


# ---------------------------------------------------------
# DEVICE
# ---------------------------------------------------------

class DeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = "__all__"


# ---------------------------------------------------------
# TELEMETRY
# ---------------------------------------------------------

class TelemetrySerializer(serializers.ModelSerializer):
    class Meta:
        model = Telemetry
        fields = "__all__"


# ---------------------------------------------------------
# ALERT
# ---------------------------------------------------------

class AlertSerializer(serializers.ModelSerializer):
    class Meta:
        model = Alert
        fields = "__all__"



class ActuatorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Actuator
        fields = '__all__'

class ActuatorCommandSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActuatorCommand
        fields = '__all__'


class ThresholdRuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = ThresholdRule
        fields = '__all__'

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = '__all__'