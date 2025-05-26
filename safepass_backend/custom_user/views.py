from rest_framework_simplejwt.tokens import RefreshToken
from django.middleware import csrf
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth import authenticate
from django.conf import settings
from rest_framework import status
from rest_framework.permissions import AllowAny

def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

class CustomLoginView(APIView):
    def post(self, request):
        # User credentials from request
        data = request.data.get("credentials")
        print(f"debug: in customlogin {data}")
        # return Response(status=status.HTTP_200_OK)
        response = Response()
        email = data.get('email')
        password = data.get('password')


        user = authenticate(email=email, password=password)

        if user is not None:
            if user.is_active:
                data = get_tokens_for_user(user)
                # TODO: store tokens in a db
                response.set_cookie(
                    key=settings.SIMPLE_JWT['AUTH_COOKIE'],
                    value=data['access'],
                    expires=settings.SIMPLE_JWT['AUTH_TOKEN_LIFETIME'],
                    secure=settings.SIMPLE_JWT['AUTH_COOKIE_SECURE'],
                    httponly=settings.SIMPLE_JWT['AUTH_COOKIE_HTTP_ONLY'],
                    samesite=settings.SIMPLE_JWT['AUTH_COOKIE_SAMESITE']
                )
                csrf.get_token(request)
                response.data = {"detail": "Login Successful", "data": data}
                response.status_code = status.HTTP_200_OK

                print(f"debug: this is the response.cookies {response.cookies}")
                return response
            else:
                return Response({"detail": "Unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response({"details": "Invalid account"}, status=status.HTTP_404_NOT_FOUND)