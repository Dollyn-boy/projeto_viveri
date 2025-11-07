import requests
from datetime import datetime

BASE_URL_LOCAL = "http://127.0.0.1:8000/local/"
BASE_URL_EVENTO = "http://127.0.0.1:8000/eventos/"
BASE_URL_RESERVA = "http://127.0.0.1:8000/reservas/"

def print_response(response):
    """Imprime informações legíveis sobre a resposta HTTP"""
    print(f"\n[ {response.request.method} {response.url} ]")
    print(f"Status: {response.status_code}")
    try:
        print("Resposta JSON:", response.json())
    except Exception:
        print("Resposta texto:", response.text)


# ==================================================
# ===============  TESTES DE LOCAL  =================
# ==================================================

def testar_adicionar_local():
    """Cria um novo local"""
    url = BASE_URL_LOCAL + "adicionar/"
    data = {
        "nome": "Auditório Central",
        "capacidade": 500,
        "endereco": "Av. Brasil, 123",
        "latitude": -23.550520,
        "longitude": -46.633308
    }
    print("Teste: adicionar local")
    response = requests.post(url, json=data)
    print_response(response)
    return response.json().get("id_local") if response.ok else None


def testar_listar_locais():
    """Lista todos os locais"""
    url = BASE_URL_LOCAL
    print("Teste: listar locais")
    response = requests.get(url)
    print_response(response)


def testar_detalhar_local(local_id):
    """Obtém detalhes de um local"""
    url = BASE_URL_LOCAL + f"detalhar/{local_id}/"
    print("Teste: detalhar local")
    response = requests.get(url)
    print_response(response)


def testar_atualizar_local(local_id):
    """Atualiza dados de um local existente"""
    url = BASE_URL_LOCAL + f"atualizar/{local_id}/"
    data = {
        "nome": "Auditório Central - Atualizado",
        "capacidade": 700,
        "endereco": "Av. Paulista, 500",
        "latitude": -23.556000,
        "longitude": -46.650000
    }
    print("Teste: atualizar local")
    response = requests.put(url, json=data)
    print_response(response)


def testar_deletar_local(local_id):
    """Exclui um local"""
    url = BASE_URL_LOCAL + f"deletar/{local_id}/"
    print("Teste: deletar local")
    response = requests.delete(url)
    print_response(response)


# ==================================================
# ===============  TESTES DE EVENTO  ===============
# ==================================================

def testar_adicionar_evento(local_id):
    """Cria um novo evento vinculado a um local"""
    url = BASE_URL_EVENTO + "adicionar/"
    data = {
        "nome": "Show Beneficente",
        "descricao": "Evento para arrecadar fundos",
        "data": datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
        "link": "http://exemplo.com/show",
        "local": local_id,
        "usuario": 1,
    }
    print("Teste: adicionar evento")
    response = requests.post(url, json=data)
    print_response(response)
    return response.json().get("id_evento") if response.ok else None


def testar_listar_eventos():
    """Lista todos os eventos"""
    url = BASE_URL_EVENTO
    print("Teste: listar eventos")
    response = requests.get(url)
    print_response(response)


def testar_detalhar_evento(evento_id):
    """Obtém detalhes de um evento específico"""
    url = BASE_URL_EVENTO + f"detalhar/{evento_id}/"
    print("Teste: detalhar evento")
    response = requests.get(url)
    print_response(response)


def testar_atualizar_evento(evento_id, local_id):
    """Atualiza um evento"""
    url = BASE_URL_EVENTO + f"atualizar/{evento_id}/"
    data = {
        "nome": "Show Atualizado",
        "descricao": "Evento atualizado via teste",
        "data": "2025-12-31T19:00:00",
        "link": "http://exemplo.com/atualizado",
        "local": local_id,
        "usuario": 1,
    }
    print("Teste: atualizar evento")
    response = requests.put(url, json=data)
    print_response(response)


def testar_deletar_evento(evento_id):
    """Deleta um evento"""
    url = BASE_URL_EVENTO + f"deletar/{evento_id}/"
    print("Teste: deletar evento")
    response = requests.delete(url)
    print_response(response)


# ==================================================
# ===============  TESTES DE RESERVA  ==============
# ==================================================

def testar_adicionar_reserva(evento_id):
    """Cria uma nova reserva vinculada a um evento"""
    url = BASE_URL_RESERVA + "adicionar/"
    data = {
        "usuario": 1,          # ID de usuário existente
        "evento": evento_id,   # Evento recém-criado
        "preco": 120.00,
        "status": "confirmada"
    }
    print("Teste: adicionar reserva")
    response = requests.post(url, json=data)
    print_response(response)
    return response.json().get("id_reserva") if response.ok else None


def testar_listar_reservas():
    """Lista todas as reservas"""
    url = BASE_URL_RESERVA
    print("Teste: listar reservas")
    response = requests.get(url)
    print_response(response)


def testar_detalhar_reserva(reserva_id):
    """Obtém detalhes de uma reserva"""
    url = BASE_URL_RESERVA + f"detalhar/{reserva_id}/"
    print("Teste: detalhar reserva")
    response = requests.get(url)
    print_response(response)


def testar_atualizar_reserva(reserva_id, evento_id):
    """Atualiza uma reserva"""
    url = BASE_URL_RESERVA + f"atualizar/{reserva_id}/"
    data = {
        "usuario": 1,
        "evento": evento_id,
        "preco": 150.00,
        "status": "alterada"
    }
    print("Teste: atualizar reserva")
    response = requests.put(url, json=data)
    print_response(response)


def testar_deletar_reserva(reserva_id):
    """Exclui uma reserva"""
    url = BASE_URL_RESERVA + f"deletar/{reserva_id}/"
    print("Teste: deletar reserva")
    response = requests.delete(url)
    print_response(response)


# ==================================================
# ================== EXECUÇÃO ======================
# ==================================================

if __name__ == "__main__":
    print("Iniciando testes CRUD de Local, Evento e Reserva...\n")

    # Testes de LOCAL
    local_id = testar_adicionar_local()
    testar_listar_locais()
    if local_id:
        testar_detalhar_local(local_id)
        testar_atualizar_local(local_id)
    else:
        print("Falha ao criar local. Pulando testes de evento/reserva.")
        exit()

    # Testes de EVENTO
    evento_id = testar_adicionar_evento(local_id)
    testar_listar_eventos()
    if evento_id:
        testar_detalhar_evento(evento_id)
        testar_atualizar_evento(evento_id, local_id)
    else:
        print("Falha ao criar evento. Pulando testes de reserva.")
        exit()

    # Testes de RESERVA
    reserva_id = testar_adicionar_reserva(evento_id)
    testar_listar_reservas()
    if reserva_id:
        testar_detalhar_reserva(reserva_id)
        testar_atualizar_reserva(reserva_id, evento_id)
        testar_deletar_reserva(reserva_id)

    # Limpeza final
    testar_deletar_evento(evento_id)
    testar_deletar_local(local_id)
