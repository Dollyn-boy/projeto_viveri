# Adrielle, Duda e Taylon

from django.test import TestCase
from django.utils import timezone
from FAQ.models import Pergunta, Resposta, Voto, Denuncia, Notificacao, TipoVoto, TipoNotificacao
from FAQ.views import perguntas_porEvento

try:
    from accounts.models import Usuario
except ImportError:
    from django.contrib.auth import get_user_model
    Usuario = get_user_model()

try:
    from Events.models import Eventos, Local
except ImportError:
    from django.db import models
    class Eventos(models.Model):
        nome = models.CharField(max_length=100)
        class Meta:
            app_label = "Events"
            managed = False

class ModelTestCase(TestCase):
    def setUp(self): # Duda
        self.usuario = Usuario.objects.create_user(username='test', password='senhaforte')
        self.evento = Eventos.objects.create(nome='Evento De Test')

    pergunta = None

    def setUp(self): # Dudu
        self.usuario = Usuario.objects.create_user(username='test', password='senhaforte')
        self.local = Local.objects.create(id_local="12334")
        self.evento = Eventos.objects.create(
            nome='Evento De Test',
            usuario=self.usuario,
            local=self.local,
        )


    def test_pergunta(self): 
        self.pergunta = Pergunta.objects.create(
            texto = "Qual?",
            usuario = self.usuario,
            evento = self.evento,
        )
        self.assertEqual(self.pergunta.texto, 'Qual?')
        self.assertEqual(self.pergunta.usuario, self.usuario)
        self.assertEqual(self.pergunta.evento, self.evento)
        self.assertEqual(self.pergunta.evento, self.evento)

    def test_criar_resposta(self): # Taylon
        pergunta_obj = Pergunta.objects.create(
        texto = "Pergunta resp",
        usuario = self.usuario,
        evento = self.evento,
        )
        resposta = Resposta.objects.create(
            texto = "A dois.",
            usuario=self.usuario,  
            pergunta=pergunta_obj
        )
        
        self.assertIsNotNone(resposta)
        self.assertEqual(resposta.texto, "A dois.")
        self.assertEqual(resposta.usuario.username, self.usuario.username)



    def test_criar_voto(self):
        perguntas_pora_votar  = Pergunta.objects.create(
            texto = "O que vai denunciar?",
            usuario = self.usuario,
            evento = self.evento,
        )
        voto = Voto.objects.create(
            tipo= TipoVoto.UP,
            usuario = self.usuario,
            pergunta = perguntas_pora_votar
        )
        self.assertEqual(Voto.objects.count(), 1)
        self.assertEqual(voto.tipo, TipoVoto.UP)
    
    def test_criar_denuncia(self):
        Pergunta.objects.create(
            texto = "O que vai denunciar?",
            usuario = self.usuario,
            evento = self.evento,
        )
        denuncia = Denuncia.objects.create(
            descricao = "Neymar na copa",
        )
        self.assertEqual(Denuncia.objects.count(), 1)
        self.assertEqual(denuncia.descricao, "Neymar na copa")
        
    def test_criar_notificacao(self):
        notificacao = Notificacao.objects.create(
            tipo = TipoNotificacao.INFO,
            mensagem = "Nova pergunta",
            usuario = self.usuario,
            evento = self.evento,
            )
        self.assertEqual(Notificacao.objects.count(), 1)
        self.assertEqual(notificacao.tipo, TipoNotificacao.INFO)

