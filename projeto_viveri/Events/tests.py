from django.test import TestCase
#from .views import requests

from .models import Local, Eventos, Reserva, Categoria

BASE_URL = "http://127.0.0.1:8000/eventos/"


def print_response(response):
    """Imprime informações legíveis sobre a resposta HTTP"""
    print(f"\n[ {response.request.method} {response.url} ]")
    print(f"Status: {response.status_code}")
    try:
        print("Resposta JSON:", response.json())
    except Exception:
        print("Resposta texto:", response.text)


def testar_adicionar_():
    """Testa criação de um novo evento"""
    url = BASE_URL + "adicionar/"
    data = {
        "nome": "Evento Teste",
        "descricao": "Evento de arrecadação",
        "data": "2025-12-14",
        "link": "http://exemplo.com/evento",
        "local": 1,
        "categoria": 1,
    }

    print("\n🧩 Teste: adicionar evento")
    response = requests.post(url, json=data)
    print_response(response)
    return response.json().get("id") if response.ok else None


def testar_listar_():
    """Testa listagem de todos os eventos"""
    print("\n📋 Teste: listar eventos")
    url = BASE_URL
    response = requests.get(url)
    print_response(response)


def testar_detalhar_(evento_id):
    """Testa detalhamento de um evento específico"""
    print("\n🔍 Teste: detalhar evento")
    url = BASE_URL + f"detalhar/{evento_id}/"
    response = requests.get(url)
    print_response(response)


def testar_atualizar_(evento_id):
    """Testa atualização de um evento"""
    print("\n✏ Teste: atualizar evento")
    url = BASE_URL + f"atualizar/{evento_id}/"
    data = {
        "nome": "Evento Atualizado",
        "descricao": "Descrição atualizada via teste",
        "data": "2025-12-31",
        "link": "http://exemplo.com/novo",
        "local": 1,
        "categoria": 1,
    }
    response = requests.put(url, json=data)
    print_response(response)


def testar_deletar_(evento_id):
    """Testa exclusão de um evento"""
    print("\n🗑 Teste: deletar evento")
    url = BASE_URL + f"deletar/{evento_id}/"
    response = requests.delete(url)
    print_response(response)


if __name__ == "_main_":
    print("\n🚀 Iniciando testes da API de eventos...\n")

    evento_id = testar_adicionar_()

    testar_listar_()

    if evento_id:
        testar_detalhar_(evento_id)

        testar_atualizar_(evento_id)

        testar_deletar_(evento_id)

        testar_listar_()
    else:
        print("\n⚠ O teste de adicionar falhou — os próximos testes foram pulados.")