from django.core.management.base import BaseCommand
from visitor_details.models import IdTypes

class Command(BaseCommand):
    help = 'Creates default ID types'

    def handle(self, *args, **kwargs):
        default_id_types = [
            'Drivers License',
            'Passport',
            'National ID',
            'Government-Issued ID',
            'Professional Identification Card (PIC)',
            'Postal ID',
            'School ID',
            'Company/Corporate ID',
            'Other'
        ]

        for id_type in default_id_types:
            IdTypes.objects.get_or_create(type=id_type)
            self.stdout.write(self.style.SUCCESS(f'Successfully created ID type: {id_type}')) 