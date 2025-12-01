from rest_framework.permissions import BasePermission


class IsFarmer(BasePermission):
    def has_permission(self, request, view):
        return bool(
            request.user and
            request.user.is_authenticated and
            request.user.groups.filter(name="farmer").exists()
        )


class IsAdminGroup(BasePermission):
    def has_permission(self, request, view):
        return bool(
            request.user and
            request.user.is_authenticated and
            request.user.groups.filter(name="admin").exists()
        )

class IsFarmerOrAdmin(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        return bool(
            user
            and user.is_authenticated
            and (
                user.groups.filter(name="farmer").exists()
                or user.groups.filter(name="admin").exists()
                or user.is_superuser
            )
        )