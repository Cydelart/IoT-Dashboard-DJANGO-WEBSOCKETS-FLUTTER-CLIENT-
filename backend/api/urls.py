from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    UserViewSet,
    UserProfileViewSet,
    FieldViewSet,
    DeviceViewSet,
    TelemetryViewSet,
    AlertViewSet,
    ActuatorViewSet,
    ActuatorCommandViewSet,
    ThresholdRuleViewSet,
)

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'user-profiles', UserProfileViewSet)
router.register(r'fields', FieldViewSet)
router.register(r'devices', DeviceViewSet)
router.register(r'telemetry', TelemetryViewSet)
router.register(r'alerts', AlertViewSet)
router.register(r'actuators', ActuatorViewSet)
router.register(r'actuator-commands', ActuatorCommandViewSet)
router.register(r'threshold-rules', ThresholdRuleViewSet)

urlpatterns = [
    path('', include(router.urls)),
]



