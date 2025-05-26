from django.urls import path, include
from . import views

urlpatterns = [
  path('login/', views.CustomLoginView.as_view(), name="log-in")
]