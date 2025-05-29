from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.utils import timezone
from datetime import datetime, timedelta
from django.db.models import Count
from visitor_details.models import VisitorDetails
from rest_framework.permissions import IsAuthenticated
from rest_framework.permissions import AllowAny
from . import models, serializers
import pytz
from django.conf import settings
from django.shortcuts import render
from rest_framework import generics
from .models import visitor_logs, visitor_status, VisitPurposes
from django.db.models import Q

class VisitorLogsView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        try:
            visitor_logs = models.visitor_logs.objects.all().order_by('-log_datetime')
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
        

class VisitPurposesView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            print("DEBUG: Fetching visit purposes")
            purposes = models.VisitPurposes.objects.all()
            print(f"DEBUG: Found purposes: {list(purposes.values())}")
            serializer = serializers.VisitPurposes(purposes, many=True)
            print(f"DEBUG: Serialized data: {serializer.data}")
            response_data = {"purposes": serializer.data}
            print(f"DEBUG: Final response data: {response_data}")
            return Response(response_data, status=status.HTTP_200_OK)
        except Exception as e:
            print(f"DEBUG: Error in VisitPurposesView: {str(e)}")
            print(f"DEBUG: Error type: {type(e)}")
            print(f"DEBUG: Stack trace:")
            import traceback
            traceback.print_exc()
            return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class VisitorCheckInView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            visitor_id = request.data.get('visitor_id')
            visit_purpose = request.data.get('visit_purpose')

            if not visitor_id or not visit_purpose:
                return Response(
                    {"detail": "Visitor ID and visit purpose are required"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Get the visitor
            try:
                visitor = VisitorDetails.objects.get(id=visitor_id)
            except VisitorDetails.DoesNotExist:
                return Response(
                    {"detail": "Visitor not found"},
                    status=status.HTTP_404_NOT_FOUND
                )

            # Get the visit purpose
            try:
                purpose = VisitPurposes.objects.get(purpose=visit_purpose)
            except VisitPurposes.DoesNotExist:
                return Response(
                    {"detail": "Invalid visit purpose"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Get or create the "Checked In" status
            checked_in_status, _ = visitor_status.objects.get_or_create(status="Checked In")

            # Create the visitor log
            now = timezone.now()
            visitor_logs.objects.create(
                visitor_details=visitor,
                check_in=now.time(),
                visit_date=now.date(),
                purpose=purpose,
                status=checked_in_status
            )

            return Response({
                "detail": "Visitor successfully checked in",
                "check_in_time": now.time().strftime("%H:%M:%S")
            })

        except Exception as e:
            print(f"VisitorCheckInView: {str(e)}")
            return Response(
                {"detail": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

class CheckOutSearchView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        query = request.GET.get('query', '')
        if not query:
            return Response({'results': []})

        try:
            # Get current time in UTC
            now_utc = timezone.now()
            
            # Convert to local timezone
            current_timezone = pytz.timezone(settings.TIME_ZONE)
            local_datetime = now_utc.astimezone(current_timezone)
            today = local_datetime.date()
            
            print(f"DEBUG: UTC time: {now_utc}")
            print(f"DEBUG: Local time: {local_datetime}")
            print(f"DEBUG: Today's date: {today}")

            # First, get all visitor logs for today that are checked in
            checked_in_status = visitor_status.objects.get(status="Checked In")
            print(f"DEBUG: Found Checked In status: {checked_in_status}")

            # Get all visitor logs for today
            all_today_logs = visitor_logs.objects.filter(visit_date=today)
            print(f"DEBUG: All logs for today: {list(all_today_logs.values())}")

            # Get checked in logs
            today_checked_in_logs = visitor_logs.objects.filter(
                visit_date=today,
                status=checked_in_status,
                check_out__isnull=True
            )
            print(f"DEBUG: Found {today_checked_in_logs.count()} checked in logs for today")
            print(f"DEBUG: Checked in logs details: {list(today_checked_in_logs.values())}")

            visitor_ids = list(today_checked_in_logs.values_list('visitor_details_id', flat=True))
            print(f"DEBUG: Visitor IDs checked in today: {visitor_ids}")

            # Then search for visitors who are checked in today
            visitors = VisitorDetails.objects.filter(
                id__in=visitor_ids
            ).filter(
                Q(id_number__icontains=query) |
                Q(full_name__icontains=query)
            )
            print(f"DEBUG: Found {visitors.count()} matching visitors")
            print(f"DEBUG: Search query was: {query}")
            print(f"DEBUG: Matching visitors: {list(visitors.values('id', 'id_number', 'full_name'))}")

            results = []
            for visitor in visitors:
                # Get the current active visit for today
                current_visit = visitor_logs.objects.filter(
                    visitor_details=visitor,
                    visit_date=today,
                    status=checked_in_status,
                    check_out__isnull=True
                ).first()

                if current_visit:
                    visitor_data = {
                        'id': str(visitor.id),
                        'id_number': visitor.id_number,
                        'full_name': visitor.full_name,
                        'display_string': f"{visitor.id_number} ({visitor.full_name})",
                        'visit_purpose': current_visit.purpose.purpose if current_visit.purpose else None
                    }
                    print(f"DEBUG: Adding visitor to results with data: {visitor_data}")
                    results.append(visitor_data)

            print(f"DEBUG: Final results count: {len(results)}")
            print(f"DEBUG: Final results: {results}")
            return Response({'results': results})
        except Exception as e:
            print(f"ERROR in CheckOutSearchView: {str(e)}")
            return Response(
                {"detail": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

class VisitorCheckOutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            visitor_id = request.data.get('visitor_id')

            if not visitor_id:
                return Response(
                    {"detail": "Visitor ID is required"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Get the visitor
            try:
                visitor = VisitorDetails.objects.get(id=visitor_id)
            except VisitorDetails.DoesNotExist:
                return Response(
                    {"detail": "Visitor not found"},
                    status=status.HTTP_404_NOT_FOUND
                )

            # Get today's date
            today = timezone.now().date()
            now = timezone.now()

            # Get the current active visit
            checked_in_status = visitor_status.objects.get(status="Checked In")
            current_visit = visitor_logs.objects.filter(
                visitor_details=visitor,
                visit_date=today,
                status=checked_in_status,
                check_out__isnull=True
            ).first()

            if not current_visit:
                return Response(
                    {"detail": "No active check-in found for this visitor today"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Get or create the "Checked Out" status
            checked_out_status, _ = visitor_status.objects.get_or_create(status="Checked Out")

            # Update the visitor log
            current_visit.check_out = now.time()
            current_visit.status = checked_out_status
            current_visit.save()

            return Response({
                "detail": "Visitor successfully checked out",
                "check_out_time": now.time().strftime("%H:%M:%S")
            })

        except Exception as e:
            return Response(
                {"detail": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )