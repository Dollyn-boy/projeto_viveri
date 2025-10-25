from django.db import models
from accounts.models import Usuario
from Events.models import Eventos


class Pergunta(models.Model):
    texto = models.TextField()
    data = models.DateTimeField(auto_now_add=True)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    evento = models.ForeignKey(Eventos, on_delete=models.CASCADE)


class Resposta(models.Model):
    texto = models.TextField()
    data = models.DateTimeField(auto_now_add=True)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE)


class TipoVoto(models.TextChoices):
    UP = 'UP', 'Upvote'
    DOWN = 'DOWN', 'Downvote'

class Voto(models.Model):
    tipo = models.CharField(max_length=5, choices=TipoVoto.choices)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE)


class Denuncia(models.Model):
    descricao = models.TextField()
    data = models.DateTimeField(auto_now_add=True)
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE, null=True, blank=True)
    resposta = models.ForeignKey(Resposta, on_delete=models.CASCADE, null=True, blank=True)


class TipoNotificacao(models.TextChoices):
    ALERTA = 'ALERTA', 'Alerta'
    INFO = 'INFO', 'Informação'


class Notificacao(models.Model):
    tipo = models.CharField(max_length=20, choices=TipoNotificacao.choices)
    mensagem = models.TextField()
    data = models.DateTimeField(auto_now_add=True)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    evento = models.ForeignKey(Eventos, on_delete=models.CASCADE)
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE, null=True, blank=True)

