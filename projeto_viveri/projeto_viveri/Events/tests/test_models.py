from django.test import TestCase
from ..models import Local, Eventos, Reserva, Categoria
from django.utils import timezone
from datetime import datetime
from accounts.models import Usuario

class ReservaTestCase(TestCase):
    def setUp(self):
        self.local = Local.objects.create(
            nome="Local de Teste",
            endereco="Endereço de Teste",
            capacidade=100,
        )
        self.evento = Eventos.objects.create(
            titulo="Evento de Teste",
            descricao="Descrição de Teste",
            data_hora=timezone.make_aware(datetime(2024, 12, 31, 20, 0, 0)),
            local=self.local,
        )
        self.reserva = Reserva.objects.create(
            evento=self.evento,
            nome_cliente="Cliente de Teste", #faz a reserva
            quantidade_ingressos=2,
        )

    def test_evento_reserva(self):
        self.assertEqual(self.reserva.evento.titulo, "Evento de Teste")

    def test_nome_cliente_reserva(self):
        self.assertEqual(self.reserva.nome_cliente, "Cliente de Teste")

    def test_quantidade_ingressos_reserva(self):
        self.assertEqual(self.reserva.quantidade_ingressos, 2)

    def test_contagem_reservas_por_evento(self):
        count = Reserva.objects.filter(evento=self.evento).count()
        self.assertEqual(count, 1)

class LocalTestCase(TestCase):
    def setUp(self):
        self.local = Local.objects.create(
            nome="Local de Teste",
            endereco="Endereço de Teste",
            capacidade=100,
        )

    def test_criacao_local(self):
        self.assertIsInstance(self.local, Local)

    def test_nome_local(self):
        self.assertEqual(self.local.nome, "Local de Teste")

    def test_endereco_local(self):
        self.assertEqual(self.local.endereco, "Endereço de Teste")
    
    def test_capacidade_local(self):
        self.assertEqual(self.local.capacidade, 100)

class EventosTestCase(TestCase):
    def setUp(self):
        self.cliente = Usuario.objects.create_user(
            username='testuser',
            password='testpass'
        )
        self.local = Local.objects.create(
            nome="Local de Teste",
            endereco="Endereço de Teste",
            capacidade=100,
        )
        self.categoria = Categoria.objects.create(
            nome="Categoria de Teste",
        )
        self.evento = Eventos.objects.create(
            titulo="Evento de Teste",
            descricao="Descrição de Teste",
            data_hora=timezone.make_aware(datetime(2024, 12, 31, 20, 0, 0)),
            local=self.local,
            categoria=self.categoria
        )

    def test_titulo_evento(self):
        self.assertEqual(self.evento.titulo, "Evento de Teste")

    def test_descricao_evento(self):
        self.assertEqual(self.evento.descricao, "Descrição de Teste")

    def test_data_hora_evento(self):
        expected = timezone.make_aware(datetime(2024, 12, 31, 20, 0, 0))
        self.assertEqual(self.evento.data_hora, expected)
    
    def test_local_evento(self):
        self.assertEqual(self.evento.local.nome, "Local de Teste")

    def test_categoria_evento(self):
        self.assertEqual(self.evento.categoria.nome, "Categoria de Teste")

class CategoriaTestCase(TestCase):
    def setUp(self):
        self.categoria = Categoria.objects.create(
            nome="Categoria de Teste",
        )
        
        local = Local.objects.create(
            nome="Local para Evento",
            endereco="Endereço X",
            capacidade=50,
        )
        
        self.evento = Eventos.objects.create(
            titulo="Evento de Teste",
            descricao="Descrição de Teste",
            data_hora=timezone.make_aware(datetime(2024, 12, 31, 20, 0, 0)), # make_aware faz o datetime ter informação do fuso horário 
            local=local,
            categoria=self.categoria,
        )
    
    def test_nome_categoria(self):
        self.assertEqual(self.categoria.nome, "Categoria de Teste")

    def test_evento_categoria(self):
        self.assertIsNotNone(self.evento.categoria)
        self.assertEqual(self.evento.categoria.nome, self.categoria.nome)
