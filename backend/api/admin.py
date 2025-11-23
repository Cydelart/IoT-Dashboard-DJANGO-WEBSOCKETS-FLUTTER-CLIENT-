from django.contrib import admin

from .models import Device

@admin.register(Device)
class DeviceAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "status")
    list_filter = ("status",)
    search_fields = ("name",)

# Register your models here.
