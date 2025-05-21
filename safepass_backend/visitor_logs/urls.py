from django.urls import path
from . import views

urlpatterns = [
    path("visitor_logs/", views.VisitorLogsView.as_view(), name="visitor_logs"),
]