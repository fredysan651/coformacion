import requests

url = "http://127.0.0.1:8001/api/estudiantes/"

try:
    response = requests.get(url)
    print(f"Status Code: {response.status_code}")
    print(f"Response OK: {response.status_code == 200}")
    
    if response.status_code == 200:
        data = response.json()
        print(f"\n✅ API funcionando correctamente!")
        print(f"Total de estudiantes: {len(data)}")
        if len(data) > 0:
            print(f"Primer estudiante: {data[0].get('nome_completo', 'N/A')}")
    else:
        print(f"Error: {response.text}")
except Exception as e:
    print(f"Error: {e}")
