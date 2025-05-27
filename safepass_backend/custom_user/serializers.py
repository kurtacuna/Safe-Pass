from rest_framework_simplejwt.serializers import TokenRefreshSerializer
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework import serializers
from django.conf import settings
from rest_framework_simplejwt.tokens import RefreshToken

class CookieTokenRefreshSerializer(TokenRefreshSerializer):
    refresh = None
    def validate(self, attrs):
        refresh_token = self.context['request'].COOKIES.get(settings.SIMPLE_JWT['REFRESH_TOKEN'], None)

        if refresh_token is None:
            raise serializers.ValidationError('Refresh token not found in cookies.')
        
        try:
            self.token = RefreshToken(refresh_token)
        except TokenError as e:
            print(f"in CookieTokenRefreshSerializer: {e}")
            raise serializers.ValidationError()
        
        attrs = {'refresh': refresh_token}
        return super().validate(attrs)