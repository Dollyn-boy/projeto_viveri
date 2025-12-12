from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth.models import User
from ..models import Local, Eventos, Reserva, Categoria
from ..views import EventosViewSet, LocalViewSet, ReservaViewSet, CategoriaViewSet

def home():
    pass

class EventoTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='testuser', password='testpass')
        self.local = Local.objects.create(nome='Local Teste', endereco='Endereço Teste')
        self.categoria = Categoria.objects.create(nome='Categoria Teste')
        Eventos.objects.create(
            nome='Evento 1',
            descricao='Descrição do Evento 1',
            data='2025-12-14',
            link='http://exemplo.com/evento1',
            local=self.local,
            categoria=self.categoria
        )
        Eventos.objects.create(
            nome='Evento 2',
            descricao='Descrição do Evento 2',
            data='2025-12-15',
            link='http://exemplo.com/evento2',
            local=self.local,
            categoria=self.categoria
        )

    def listar_eventos(self):
        self.client.login(username='testuser', password='testpass')
        url = reverse('Eventos:evento-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.json()), 2)
    
    def pegar_1_evento_específico(self):
        self.client.login(username='testuser', password='testpass')
        evento = Eventos.objects.get(nome='Evento 1')
        url = reverse('Eventos:evento-confirmar', args=[evento.id]) #args serve para passar parâmetros na URL
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['nome'], evento.nome)
    
class ReservaTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='testuser', password='testpass')
        self.local = Local.objects.create(nome='Local Teste', endereco='Endereço Teste')
        self.categoria = Categoria.objects.create(nome='Categoria Teste')
        self.evento = Eventos.objects.create(
            nome='Evento Reserva',
            descricao='Descrição do Evento Reserva',
            data='2025-12-16',
            link='http://exemplo.com/evento_reserva',
            local=self.local,
            categoria=self.categoria
        )
        self.reserva=Reserva.objects.create(
            evento=self.evento,
            nome_cliente='Cliente Teste',
        )
    def listar_reservas(self):
        self.client.login(username='testuser', password='testpass')
        url = reverse('Eventos:reserva-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200) 
        self.assertEqual(len(response.json()), 1)