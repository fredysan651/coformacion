from django.http import JsonResponse
from rest_framework.decorators import api_view

@api_view(['GET'])
def diagnostico_headers(request):
    """
    Endpoint para diagnosticar qué headers recibe el servidor
    """
    headers_dict = {}
    for header, value in request.META.items():
        if header.startswith('HTTP_'):
            # Convertir HTTP_X_STUDENT_ID a X-Student-Id
            clean_header = header[5:].replace('_', '-').title()
            headers_dict[clean_header] = value
    
    return JsonResponse({
        'headers_recibidos': headers_dict,
        'user': str(request.user),
        'user_type': request.META.get('HTTP_USER_TYPE'),
        'x_student_id': request.headers.get('X-Student-Id'),
        'authorization': request.headers.get('Authorization', 'NO PRESENT'),
        'all_meta_keys': list(request.META.keys())
    }, indent=2)
