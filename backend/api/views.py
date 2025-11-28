from django.shortcuts import render

from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response

from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

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

    @action(detail=True, methods=["get"])
    def devices(self, request, pk=None):
        field = self.get_object()
        serializer = DeviceSerializer(field.devices.all(), many=True)
        return Response(serializer.data)

    @action(detail=True, methods=["get"])
    def alerts(self, request, pk=None):
        field = self.get_object()
        alerts = Alert.objects.filter(device__field=field)
        serializer = AlertSerializer(alerts, many=True)
        return Response(serializer.data)

# ----------------------------------------------------
# DEVICE
# ----------------------------------------------------

class DeviceViewSet(viewsets.ModelViewSet):
    queryset = Device.objects.all()
    serializer_class = DeviceSerializer
    permission_classes = [permissions.AllowAny]

#récupérer toute la télémétrie d’un device
    @action(detail=True, methods=["get"])
    def telemetry(self, request, pk=None):
        device = self.get_object()  # Device avec l id puisque detqil=true
        telemetry_qs = device.telemetry.all()  # foreign key related_name="telemetry"
        serializer = TelemetrySerializer(telemetry_qs, many=True)
        return Response(serializer.data)
#devices online
    @action(detail=False, methods=["get"])
    def online(self, request):
        qs = Device.objects.filter(status="online")
        serializer = DeviceSerializer(qs, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=["get"])
    def offline(self, request):
        devices = Device.objects.filter(status="offline")
        serializer = DeviceSerializer(devices, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=["get"])
    def latest_telemetry(self, request, pk=None):
        device = self.get_object()
        latest = device.telemetry.order_by("-timestamp").first()
        serializer = TelemetrySerializer(latest)
        return Response(serializer.data)
#tous les alerts
    @action(detail=True, methods=["get"])
    def alerts(self, request, pk=None):
        device = self.get_object()
        qs = device.alerts.order_by("-created_at")
        serializer = AlertSerializer(qs, many=True)
        return Response(serializer.data)


# ----------------------------------------------------
# TELEMETRY
# ----------------------------------------------------

class TelemetryViewSet(viewsets.ModelViewSet):
    queryset = Telemetry.objects.all()
    serializer_class = TelemetrySerializer
    permission_classes = [permissions.AllowAny]

    def perform_create(self, serializer):
        #creer reellement l objet telemtry dans bd 
        telemetry = serializer.save()

        #Préparer les données pour webSocket
        data = {
            "device_id": telemetry.device.id,
            "value": telemetry.value,
            "timestamp": telemetry.timestamp.isoformat(),
        }

        #donner l access a toutes les boites lettres (devices)
        channel_layer = get_channel_layer()

        #synchroniser avec la bonne boite ou le bon device 
        async_to_sync(channel_layer.group_send)(
            f"device_{telemetry.device.id}",   # nom du groupe
            {
                "type": "send_telemetry",      # correspond à la méthode du consumer
                "data": data
            }
        )

# ----------------------------------------------------
# ALERT
# ----------------------------------------------------

class AlertViewSet(viewsets.ModelViewSet):
    queryset = Alert.objects.all()
    serializer_class = AlertSerializer
    permission_classes = [permissions.AllowAny]
#renvoyer les alertes non resolues
    @action(detail=False, methods=["get"])
    def uresolved(self, request):
        qs = Alert.objects.filter(resolved=False)
        serializer = AlertSerializer(qs, many=True)
        return Response(serializer.data)
#resolu
    @action(detail=False, methods=["get"])
    def resolved(self, request):
        qs = Alert.objects.filter(resolved=True)
        serializer = AlertSerializer(qs, many=True)
        return Response(serializer.data)
#resoudre une alerte 
    @action(detail=True, methods=["post"])
    def resolve(self, request, pk=None):
        alert = self.get_object()
        alert.resolved = True
        alert.save()
        return Response({"status": "alert resolved"})

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