from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.exceptions import TokenError, InvalidToken
from django.conf import settings
from rest_framework.authentication import CSRFCheck
from rest_framework import exceptions
from rest_framework_simplejwt.tokens import RefreshToken


class CustomAuthentication(JWTAuthentication):
  def authenticate(self, request):
    try:
      access_token = request.COOKIES.get(settings.SIMPLE_JWT['ACCESS_TOKEN'], None)
      refresh_token = request.COOKIES.get(settings.SIMPLE_JWT['REFRESH_TOKEN'], None)

      # User is not logged in
      if access_token is None or refresh_token is None:
        return None
      
      # User logged in before, but pressed back, and upon pressing log in again,
      # should validate the refresh_token and send back another access_token
      if refresh_token is not None:
        try: 
          print("refresh token is not none")
          refresh = RefreshToken(refresh_token)
          print("refresh_token is valid")
          access_token = str(refresh.access_token)
          validated_token = self.get_validated_token(access_token)
          enforce_csrf(request)
          return self.get_user(validated_token), validated_token
        except InvalidToken:
          print("Session Expired")
          return None
      
      
      validated_token = self.get_validated_token(access_token)
      enforce_csrf(request)
      return self.get_user(validated_token), validated_token
    except TokenError:
      return None

  

def enforce_csrf(request):
  check = CSRFCheck(request)
  check.process_request(request)
  reason = check.process_view(request, None, (), {})

  if reason:
    raise exceptions.PermissionDenied('CSRF Fails: %s' % reason)  