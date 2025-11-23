from django.shortcuts import render

from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Device
from .serializers import DeviceSerializer


class DeviceViewSet(viewsets.ModelViewSet):
    queryset = Device.objects.all()
    serializer_class = DeviceSerializer

    # /api/devices/status/<status>/
    @action(
        detail=False,
        methods=["get"],
        url_path=r"status/(?P<status>[^/.]+)",
    )
    def get_devices_by_status(self, request, status=None):
        """
        Custom action to filter devices by status.
        Example: /api/devices/status/online/
        """
        qs = Device.objects.filter(status=status)
        serializer = self.get_serializer(qs, many=True)
        return Response(serializer.data)

