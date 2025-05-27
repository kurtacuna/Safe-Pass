from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.utils import timezone
from datetime import datetime, timedelta
from django.db.models import Count
from visitor_details import models as visitor_details_models
from . import models, serializers
import pytz
from django.conf import settings

class VisitorLogsView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        try:
            visitor_logs = models.visitor_logs.objects.all()
            serializer = serializers.VisitorLogsSerializers(visitor_logs, many = True)
            return Response(serializer.data, status = status.HTTP_200_OK)
        except Exception as e:
            print(e) 
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class VisitorStatsView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        try:
            now_utc = timezone.now() 
            
            # 2. Get your Django TIME_ZONE setting
            current_timezone = pytz.timezone(settings.TIME_ZONE)
            
            # 3. Convert the UTC time to your local timezone
            today_local_datetime = now_utc.astimezone(current_timezone)
            
            # 4. Extract the date from the local timezone datetime
            today = today_local_datetime.date()
            
            print(f"Current date (local timezone): {today}")
            
            # Get all visitor logs for debugging
            all_logs = models.visitor_logs.objects.all()
            print(f"All visitor logs: {list(all_logs.values())}")
            
            # Get all statuses for debugging
            all_statuses = models.visitor_status.objects.all()
            print(f"All available statuses: {list(all_statuses.values())}")
            
            # Get total visitors for today (all visitors who checked in today)
            total_visitors = models.visitor_logs.objects.filter(
                visit_date=today
            ).count()
            print(f"Total visitors today: {total_visitors}")
            
            # Get currently checked in visitors for today (those with no check_out time)
            checked_in_logs = models.visitor_logs.objects.filter(
                visit_date=today,
                check_out__isnull=True
            )
            checked_in = checked_in_logs.count()
            print(f"Checked in visitors today: {checked_in}")
            print(f"Checked in logs: {list(checked_in_logs.values())}")
            
            # Get checked out visitors for today (those with a check_out time)
            checked_out_logs = models.visitor_logs.objects.filter(
                visit_date=today,
                check_out__isnull=False
            )
            checked_out = checked_out_logs.count()
            print(f"Checked out visitors today: {checked_out}")
            print(f"Checked out logs: {list(checked_out_logs.values())}")
            
            # Get new registrants directly from VisitorDetails model
            new_registrants = visitor_details_models.VisitorDetails.objects.filter(
                registration_date__date=today
            ).count()
            print(f"New registrants today: {new_registrants}")
            
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