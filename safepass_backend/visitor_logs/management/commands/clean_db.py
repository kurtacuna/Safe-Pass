from django.core.management.base import BaseCommand
from visitor_logs.models import visitor_logs, visitor_status, VisitPurposes
from visitor_details.models import VisitorDetails, IdTypes

class Command(BaseCommand):
    help = 'Removes ALL visitor logs and details from the database'

    def handle(self, *args, **options):
        # Delete all visitor logs first (due to foreign key constraints)
        visitor_logs_count = visitor_logs.objects.all().count()
        visitor_logs.objects.all().delete()
        self.stdout.write(self.style.SUCCESS(f'Successfully deleted {visitor_logs_count} visitor logs'))

        # Delete all visitor details
        visitor_details_count = VisitorDetails.objects.all().count()
        VisitorDetails.objects.all().delete()
        self.stdout.write(self.style.SUCCESS(f'Successfully deleted {visitor_details_count} visitor details'))

        # Keep only the system data (ID Types, Visit Purposes, Visitor Statuses)
        self.stdout.write(self.style.SUCCESS('Database cleaned successfully - only system settings remain')) 