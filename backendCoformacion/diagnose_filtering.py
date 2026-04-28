import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_uniempresarial.settings')
django.setup()

from coformacion.models import ProcesoCoformacion, DocumentosProceso

print("=== PROCESOS ===")
procesos = ProcesoCoformacion.objects.all().values('proceso_id', 'estudiante_id')
for p in procesos:
    print(f"proceso_id={p['proceso_id']}, estudiante_id={p['estudiante_id']}")

print("\n=== DOCUMENTOS ===")
docs = DocumentosProceso.objects.all().values('documento_id', 'proceso_id')
for d in docs:
    try:
        proceso = ProcesoCoformacion.objects.get(proceso_id=d['proceso_id'])
        print(f"doc_id={d['documento_id']}, proceso_id={d['proceso_id']}, proceso.estudiante_id={proceso.estudiante_id}")
    except:
        print(f"doc_id={d['documento_id']}, proceso_id={d['proceso_id']}, ERROR")

print("\n=== TEST FILTRADO ===")
# Simular X-Student-Id para cada estudiante
for est_id in [1, 2, 3, 4]:
    filtered = DocumentosProceso.objects.filter(proceso__estudiante_id=est_id)
    print(f"Documentos estudiante_id={est_id}: {filtered.count()}")
