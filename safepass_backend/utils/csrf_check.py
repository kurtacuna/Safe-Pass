from rest_framework.authentication import CSRFCheck
from rest_framework import exceptions

def enforce_csrf(request):
  check = CSRFCheck()
  check.process_request(request)
  reason = check.process_view(request, None, (), {})
  if reason:
    raise exceptions.PermissionDenied('CSRF Fails: %s' % reason)