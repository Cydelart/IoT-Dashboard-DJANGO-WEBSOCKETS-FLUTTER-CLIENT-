from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
<<<<<<< HEAD

=======
from . import views
>>>>>>> b8df76b (final version)
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
    RegisterView,
    MeView,
)

router = DefaultRouter()
router.register(r'users', UserViewSet) # creer auto les endpoints get/post 
router.register(r'user-profiles', UserProfileViewSet)
router.register(r'fields', FieldViewSet)
router.register(r'devices', DeviceViewSet)
router.register(r'telemetry', TelemetryViewSet)
router.register(r'alerts', AlertViewSet)
router.register(r'actuators', ActuatorViewSet)
router.register(r'actuator-commands', ActuatorCommandViewSet)
router.register(r'threshold-rules', ThresholdRuleViewSet)

urlpatterns = [
    # ROUTES API PRINCIPALES
    path('', include(router.urls)),
    
    path('auth/register/', RegisterView.as_view(), name='register'),
    path('auth/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('auth/me/', MeView.as_view(), name='me'),

]
