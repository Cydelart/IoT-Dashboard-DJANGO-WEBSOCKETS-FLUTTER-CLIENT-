from django.shortcuts import render

from rest_framework import viewsets, permissions ,generics
from rest_framework.decorators import action
from rest_framework.response import Response

from rest_framework.permissions import AllowAny
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from rest_framework.views import APIView

from .permissions import IsAdminGroup, IsFarmer ,IsFarmerOrAdmin
from django.contrib.auth.models import User
from django.http import JsonResponse
from .influx import get_history

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
    RegisterSerializer
)

def telemetry_history(request, device_id):
    data = get_history(device_id)
    return JsonResponse(data, safe=False)

class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]  # inscription accessible sans être connecté


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminGroup] #user lezmou authentifie w ykoun admin


class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated, IsFarmerOrAdmin]


# ----------------------------------------------------
# FIELD
# ----------------------------------------------------

class FieldViewSet(viewsets.ModelViewSet):
    queryset = Field.objects.all()
    serializer_class = FieldSerializer
    permission_classes = [permissions.IsAuthenticated, IsFarmerOrAdmin]

    def get_permissions(self):
        # Lecture 
        if self.request.method in permissions.SAFE_METHODS:
            return [permissions.IsAuthenticated(), IsFarmerOrAdmin()]

        # Ecriture (POST, PUT, PATCH, DELETE)
        return [permissions.IsAuthenticated(), IsAdminGroup()]
    
    #houni on va voir les fields mtaa l user connecte si hwa l owner on l affiche si hwa admin on affiche tous
    def get_queryset(self):
        user = self.request.user

        if user.is_superuser or user.groups.filter(name="admin").exists():
            return Field.objects.all()

        return Field.objects.filter(owner=user)

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
    permission_classes = [permissions.IsAuthenticated]

    def get_permissions(self):
        # Lecture (GET, HEAD, OPTIONS) → Farmer ok
        if self.request.method in ("GET", "HEAD", "OPTIONS"):
            return [permissions.IsAuthenticated(), IsFarmerOrAdmin()]

        # Ecriture (POST, PUT, PATCH, DELETE) → uniquement Admin
        return [permissions.IsAuthenticated(), IsAdminGroup()]
    
    def get_queryset(self):
        user = self.request.user

        if user.is_superuser or user.groups.filter(name="admin").exists():
            return Device.objects.all()

        return Device.objects.filter(field__owner=user)
    
# ----------------------------------------------------
# urls specifique
# ----------------------------------------------------
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
    permission_classes = [permissions.IsAuthenticated, IsFarmerOrAdmin]
    
    
    def get_permissions(self):
        if self.request.method in permissions.SAFE_METHODS:
            return [permissions.IsAuthenticated(), IsFarmerOrAdmin()]

        return [permissions.IsAuthenticated(), IsAdminGroup()]
    
    def get_queryset(self):
        user = self.request.user

        if user.is_superuser or user.groups.filter(name="admin").exists():
            return Telemetry.objects.all()

        return Telemetry.objects.filter(device__field__owner=user)

    #fct pour envoyer a temps reel l telemetry 
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
                "type": "send_telemetry",      # correspond à la méthode du consumer pour envoyer telemtry au flutter
                "data": data
            }
        )

# ----------------------------------------------------
# ALERT
# ----------------------------------------------------

class AlertViewSet(viewsets.ModelViewSet):
    queryset = Alert.objects.all()
    serializer_class = AlertSerializer
    permission_classes = [permissions.IsAuthenticated, IsFarmerOrAdmin]

    def get_permissions(self):
        if self.request.method in permissions.SAFE_METHODS:
            return [permissions.IsAuthenticated(), IsFarmerOrAdmin()]

        return [permissions.IsAuthenticated(), IsAdminGroup()]
    
    def get_queryset(self):
        user = self.request.user

        if user.is_superuser or user.groups.filter(name="admin").exists():
            return Alert.objects.all()

        return Alert.objects.filter(device__field__owner=user)

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
    permission_classes = [permissions.IsAuthenticated, IsAdminGroup]


# ----------------------------------------------------
# ACTUATOR COMMAND
# ----------------------------------------------------

class ActuatorCommandViewSet(viewsets.ModelViewSet):
    queryset = ActuatorCommand.objects.all()
    serializer_class = ActuatorCommandSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminGroup]


# ----------------------------------------------------
# THRESHOLD RULE
# ----------------------------------------------------

class ThresholdRuleViewSet(viewsets.ModelViewSet):
    queryset = ThresholdRule.objects.all()
    serializer_class = ThresholdRuleSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminGroup]

#nouvelle end point lit l role du user connecte pour l envoyer l flutter pour savoir quoi afficher
class MeView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user

        # récupérer les groupes (roles)
        groups = list(user.groups.values_list("name", flat=True))

        return Response({
            "id": user.id,
            "username": user.username,
            "roles": groups,
        })