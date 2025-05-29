from django.urls import path
from . import views

urlpatterns = [
    path('', views.AppSettingsView.as_view(), name="settings"),
    path('update/', views.UpdateSettingsView.as_view(), name="update-settings")
]