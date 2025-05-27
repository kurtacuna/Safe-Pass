from django.urls import path
from . import views

urlpatterns = [
    path("visitor_logs/", views.VisitorLogsView.as_view(), name="visitor_logs"),
    path("stats/", views.VisitorStatsView.as_view(), name="visitor_stats"),
]