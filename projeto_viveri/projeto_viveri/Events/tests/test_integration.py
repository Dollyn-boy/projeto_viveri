from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth.models import User
from ..models import Local, Eventos, Reserva, Categoria
from accounts.models import Usuario

class EventoPostIntegration(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='testuser', password='testpass')
        self.local = Local.objects.create(nome='Local Teste', endereco='Endereço Teste')
        self.categoria = Categoria.objects.create(nome='Categoria Teste')

    def test_adicionar_evento(self):
        self.client.login(username='testuser', password='testpass')
        url = reverse('eventos:adicionar')
        data = {
            'nome': 'Evento Teste',
            'descricao': 'Evento de arrecadação',
            'data': '2025-12-14',
            'link': 'http://exemplo.com/evento',
            'local': self.local.id,
            'categoria': self.categoria.id,
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, 201)
        self.assertTrue(Eventos.objects.filter(nome='Evento Teste').exists())

class LocalPostIntegration(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='testuser', password='testpass')

    def test_adicionar_local(self):
        self.client.login(username='testuser', password='testpass')
        url = reverse('locais:adicionar')
        data = {
            'nome': 'Local Teste',
            'endereco': 'Endereço Teste',
            'capacidade': 100,
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, 201)
        self.assertTrue(Local.objects.filter(nome='Local Teste').exists())

class CategoriaPostIntegration(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='testuser', password='testpass')

    def test_adicionar_categoria(self):
        self.client.login(username='testuser', password='testpass')
        url = reverse('categorias:adicionar')
        data = {
            'nome': 'Categoria Teste',
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, 201)
        self.assertTrue(Categoria.objects.filter(nome='Categoria Teste').exists())

class ReservaPostIntegration(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='testuser', password='testpass')
        self.local = Local.objects.create(nome='Local Teste', endereco='Endereço Teste')
        self.categoria = Categoria.objects.create(nome='Categoria Teste')
        self.evento = Eventos.objects.create(
            nome='Evento Teste',
            descricao='Descrição do Evento Teste',
            data='2025-12-14',
            link='http://exemplo.com/evento',
            local=self.local,
            categoria=self.categoria
        )
        self.cliente = Usuario.objects.create_user(username='clientuser', password='clientpass')
        self.cliente.save()
    def test_adicionar_reserva(self):
        self.client.login(username='clientuser', password='clientpass')
        url = reverse('reservas:adicionar')
        data = {
            'evento': self.evento.id,
            'cliente': self.cliente.id,
            'quantidade': 2,
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, 201)
        self.assertTrue(Reserva.objects.filter(evento=self.evento, cliente=self.cliente).exists())
