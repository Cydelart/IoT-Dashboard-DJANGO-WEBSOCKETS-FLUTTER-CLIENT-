from django.shortcuts import render

from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response

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
from .serializers import (
    UserSerializer,
    UserProfileSerializer,
    FieldSerializer,
    DeviceSerializer,
    TelemetrySerializer,
    AlertSerializer,
    ActuatorSerializer,
    ActuatorCommandSerializer,
    ThresholdRuleSerializer,
)




class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]  # later you can restrict


class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.AllowAny]


# ----------------------------------------------------
# FIELD
# ----------------------------------------------------

class FieldViewSet(viewsets.ModelViewSet):
    queryset = Field.objects.all()
    serializer_class = FieldSerializer
    permission_classes = [permissions.AllowAny]


# ----------------------------------------------------
# DEVICE
# ----------------------------------------------------

class DeviceViewSet(viewsets.ModelViewSet):
    queryset = Device.objects.all()
    serializer_class = DeviceSerializer
    permission_classes = [permissions.AllowAny]


# ----------------------------------------------------
# TELEMETRY
# ----------------------------------------------------

class TelemetryViewSet(viewsets.ModelViewSet):
    queryset = Telemetry.objects.all()
    serializer_class = TelemetrySerializer
    permission_classes = [permissions.AllowAny]


# ----------------------------------------------------
# ALERT
# ----------------------------------------------------

class AlertViewSet(viewsets.ModelViewSet):
    queryset = Alert.objects.all()
    serializer_class = AlertSerializer
    permission_classes = [permissions.AllowAny]


# ----------------------------------------------------
# ACTUATOR
# ----------------------------------------------------

class ActuatorViewSet(viewsets.ModelViewSet):
    queryset = Actuator.objects.all()
    serializer_class = ActuatorSerializer
    permission_classes = [permissions.AllowAny]


# ----------------------------------------------------
# ACTUATOR COMMAND
# ----------------------------------------------------

class ActuatorCommandViewSet(viewsets.ModelViewSet):
    queryset = ActuatorCommand.objects.all()
    serializer_class = ActuatorCommandSerializer
    permission_classes = [permissions.AllowAny]


# ----------------------------------------------------
# THRESHOLD RULE
# ----------------------------------------------------

class ThresholdRuleViewSet(viewsets.ModelViewSet):
    queryset = ThresholdRule.objects.all()
    serializer_class = ThresholdRuleSerializer
    permission_classes = [permissions.AllowAny]
