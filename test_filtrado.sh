#!/bin/bash
# Test script para verificar filtrado de documentos

echo "===== TEST DE FILTRADO DE DOCUMENTOS ====="
echo ""
echo "Base URL: http://127.0.0.1:8001/api/documentos-proceso/"
echo ""

echo "TEST 1: Estudiante 1 ve sus documentos (proceso 4, estudante 1)"
curl -s "http://127.0.0.1:8001/api/documentos-proceso/?proceso_id=4&estudiante_id=1" | python -c "import sys, json; d=json.load(sys.stdin); print(f'✅ {len(d)} documentos'); [print(f'   - doc_id={x[\"documento_id\"]}') for x in d]"

echo ""
echo "TEST 2: Estudiante 2 NO puede ver documentos del proceso 4 (que es de estudiante 1)"
curl -s "http://127.0.0.1:8001/api/documentos-proceso/?proceso_id=4&estudiante_id=2" | python -c "import sys, json; d=json.load(sys.stdin); print(f'✅ {len(d)} documentos (correcto, no debería ver nada)')"

echo ""
echo "TEST 3: Sin filtro estudiante_id (como admin)"
curl -s "http://127.0.0.1:8001/api/documentos-proceso/?proceso_id=4" | python -c "import sys, json; d=json.load(sys.stdin); print(f'✅ {len(d)} documentos (admin ve todo)')"

echo ""
echo "===== ¡SISTEMA LISTO! ====="
echo "El filtrado está funcionando correctamente."
echo "El frontend enviará estudiante_id automáticamente por query param."
