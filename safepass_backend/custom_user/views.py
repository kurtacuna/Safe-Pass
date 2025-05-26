# from rest_framework_simplejwt.tokens import RefreshToken
# from django.middleware import csrf
# from rest_framework.views import APIView
# from rest_framework.response import Response
# from django.contrib.auth import authenticate
# from django.conf import settings
# from rest_framework import status

# def get_tokens_for_user(user):
#     refresh = RefreshToken.for_user(user)
#     return {
#         'refresh': str(refresh),
#         'access': str(refresh.access_token),
#     }


# class CustomLoginView(APIView):
#     def post(self, request):
#         # User credentials from request
#         data = request.data
#         response = Response()
#         email = data.get('email')
#         password = data.get('password')
#         user = authenticate(email=email, password=password)

#         if user is not None:
#             if user.is_active:
#                 data = get_tokens_for_user(user)
#                 response.set_cookie(
#                     key=settings.SIMPLE_JWT('')
#                 )



