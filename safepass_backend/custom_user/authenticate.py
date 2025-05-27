from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.exceptions import TokenError
from django.conf import settings
from rest_framework.authentication import CSRFCheck
from rest_framework import exceptions


class CustomAuthentication(JWTAuthentication):
  def authenticate(self, request):
    try:
      access_token = request.COOKIES.get(settings.SIMPLE_JWT['ACCESS_TOKEN'], None)
      refresh_token = request.COOKIES.get(settings.SIMPLE_JWT['REFRESH_TOKEN'], None)

      # User is not logged in
      if access_token is None or refresh_token is None:
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