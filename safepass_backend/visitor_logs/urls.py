from django.urls import path
from . import views

urlpatterns = [
    path("visitor_logs/", views.VisitorLogsView.as_view(), name="visitor_logs"),
    path("stats/", views.VisitorStatsView.as_view(), name="visitor_stats"),
    path("purposes/", views.VisitPurposesView.as_view(), name="visit_purposes"),
    path("check-in/", views.VisitorCheckInView.as_view(), name="visitor-check-in"),
    path("check-out-search/", views.CheckOutSearchView.as_view(), name="visitor-check-out-search"),
    path("check-out/", views.VisitorCheckOutView.as_view(), name="visitor-check-out"),
]