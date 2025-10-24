from django.test import TestCase
import requests
from .models import Local, Eventos, Reserva, Categoria
# Create your tests here.
BASE_URL = "http://127.0.0.1:8000/eventos/"

TestCase


def print_response(response):
    print(f"\n[ {response.request.method} {response.url} ]")
    print(f"Status: {response.status_code}")
    try:
        print("Resposta JSON:", response.json())
    except Exception:
        print("Resposta texto:", response.text)


def testar_adicionar_():
    # TODO preencher com as informações corretas.
    url = BASE_URL + "adicionar/"
    data = {'nome': 'Evento Teste',  # ---> tava testando as entradas de evento
            'descricao': 'evento de arrecadação',
            'data': '14-12-2025',
            'link': 'http://exemplo.com/evento',
            'local': 1, }

    response = requests.post(url, json=data)
    print_response(response)


def testar_atualizar_usuario(user_id):
    # TODO
    return


def testar_listar_():
    url = BASE_URL
    response = requests.get(url)
    print_response(response)
    return


def testar_detalhar_(user_id):
    # TODO
    return


def testar_deletar_(user_id):
    # TODO
    return


if __name__ == "__main__":
    testar_adicionar_()
