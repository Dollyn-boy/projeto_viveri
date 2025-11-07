from django.db import models
from accounts.models import Usuario
from Events.models import Eventos
from django.utils import timezone


class Pergunta(models.Model):
    txt = models.TextField()
    data = models.DateTimeField(default=timezone.now)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    evento = models.ForeignKey(Eventos, on_delete=models.CASCADE)

    def total_votes(self):
        return self.votos.count()



class Resposta(models.Model):
    txt = models.TextField()
    data = models.DateTimeField(default=timezone.now)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE)


class TipoVoto(models.TextChoices):
    UP = 'UP', 'Upvote'
    DOWN = 'DOWN', 'Downvote'


class Voto(models.Model):
    tipo = models.CharField(max_length=5, choices=TipoVoto.choices)
    data = models.DateTimeField(default=timezone.now)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE, related_name="votos")

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['usuario', 'pergunta'], name='voto_unico')
        ]


class TipoNotificacao(models.TextChoices):
    ALERTA = 'ALERTA', 'Alerta'
    INFO = 'INFO', 'Informação'


class Notificacao(models.Model):
    tipo = models.CharField(max_length=20, choices=TipoNotificacao.choices)
    conteudo = models.TextField()
    data = models.DateTimeField(default=timezone.now)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    evento = models.ForeignKey(Eventos, on_delete=models.CASCADE)
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE, null=True, blank=True)

    class Meta:
        ordering = ['-data']


class Denuncia(models.Model):
    descricao = models.TextField()
    data = models.DateTimeField(default=timezone.now)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, null=True)
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE, null=True, blank=True)
    resposta = models.ForeignKey(Resposta, on_delete=models.CASCADE, null=True, blank=True)


