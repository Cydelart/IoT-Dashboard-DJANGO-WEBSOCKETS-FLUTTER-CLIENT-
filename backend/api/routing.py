from django.urls import re_path
from api.consumers import TelemetryConsumer

websocket_urlpatterns = [
    re_path(r'ws/telemetry/(?P<device_id>\d+)/$', TelemetryConsumer.as_asgi()),
]
