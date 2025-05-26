from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from django.utils import timezone
from datetime import datetime, timedelta
from django.db.models import Count
from . import models, serializers

class VisitorLogsView(APIView):
    permission_classes = [AllowAny]
    def get(self, request):
        try:
            visitor_logs = models.visitor_logs.objects.all()
            serializer = serializers.VisitorLogsSerializers(visitor_logs, many = True)
            return Response(serializer.data, status = status.HTTP_200_OK)
        except Exception as e:
            print(e) 
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class VisitorStatsView(APIView):
    permission_classes = [AllowAny]
    def get(self, request):
        try:
            today = timezone.now().date()
            print(f"Current date: {today}")
            
            # Get all visitor logs for debugging
            all_logs = models.visitor_logs.objects.all()
            print(f"All visitor logs: {list(all_logs.values())}")
            
            # Get total unique visitors who have ever visited
            total_visitors = models.visitor_logs.objects.values('visitor_details').distinct().count()
            print(f"Total unique visitors: {total_visitors}")
            
            # Get currently checked in visitors for today
            checked_in_logs = models.visitor_logs.objects.filter(
                visit_date=today,
                status__status='Checked-in'
            )
            checked_in = checked_in_logs.count()
            print(f"Checked in visitors today: {checked_in}")
            print(f"Checked in logs: {list(checked_in_logs.values())}")
            
            # Get checked out visitors for today
            checked_out_logs = models.visitor_logs.objects.filter(
                visit_date=today,
                status__status='Checked-out'
            )
            checked_out = checked_out_logs.count()
            print(f"Checked out visitors today: {checked_out}")
            print(f"Checked out logs: {list(checked_out_logs.values())}")
            
            # Get new registrants from the last 24 hours
            yesterday = timezone.now() - timedelta(days=1)
            new_registrant_logs = models.visitor_logs.objects.filter(
                visitor_details__registration_date__gte=yesterday
            ).values('visitor_details').distinct()
            new_registrants = new_registrant_logs.count()
            print(f"New registrants since {yesterday}: {new_registrants}")
            print(f"New registrant logs: {list(new_registrant_logs)}")
            
            stats = {
                'total_visitors': total_visitors,
                'checked_in': checked_in,
                'checked_out': checked_out,
                'new_registrants': new_registrants,
            }
            
            print(f"Final stats being sent: {stats}")
            return Response(stats, status=status.HTTP_200_OK)
            
        except Exception as e:
            print(f"Error calculating stats: {str(e)}")
            return Response(
                {"error": "Failed to calculate visitor statistics", "details": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )