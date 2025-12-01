# backend/api/jwt_channels_middleware.py

from urllib.parse import parse_qs

from asgiref.sync import sync_to_async
from channels.middleware import BaseMiddleware
from django.contrib.auth.models import AnonymousUser
from rest_framework_simplejwt.authentication import JWTAuthentication


class JWTAuthMiddleware(BaseMiddleware):
    """
    Middleware Channels pour authentifier les connexions WebSocket
    via un token JWT passé en query string: ?token=...
    """

    async def __call__(self, scope, receive, send):
        # Récupérer la query string brute (bytes) -> str
        query_string = scope.get("query_string", b"").decode()
        query_params = parse_qs(query_string)

        token = None
        tokens = query_params.get("token")
        if tokens:
            token = tokens[0]

        scope["user"] = await self.get_user_from_token(token)
        return await super().__call__(scope, receive, send)

    @sync_to_async
    def get_user_from_token(self, raw_token):
        """
        Vérifie le token avec SimpleJWT et renvoie l'utilisateur
        associé, ou AnonymousUser si le token est invalide.
        """
        if not raw_token:
            return AnonymousUser()

        jwt_auth = JWTAuthentication()
        try:
            validated_token = jwt_auth.get_validated_token(raw_token)
            user = jwt_auth.get_user(validated_token)
            return user
        except Exception:
            # token invalide / expiré / etc.
            return AnonymousUser()