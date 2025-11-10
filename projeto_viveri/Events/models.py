from django.db import models
from django.core.exceptions import ValidationError
from django.utils import timezone
from accounts.models import Usuario


class Categoria(models.Model):
    id_categoria = models.IntegerField(primary_key=True)
    nome = models.CharField(max_length=50)

    def __str__(self):
        return self.nome


class Local(models.Model):
    id_local = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=150, default='sem nome')
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='usuario_local', null=True, blank=True)
    capacidade = models.DecimalField(max_digits=10, decimal_places=0, default=0)
    endereco = models.TextField(default='')
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)

    def __str__(self):
        return self.nome

    def clean(self):
        if self.capacidade < 0:
            raise ValidationError('A capacidade não pode ser negativa.')


class Eventos(models.Model):
    id_evento = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=100)
    descricao = models.TextField(default='')
    data = models.DateTimeField()
    link = models.URLField(max_length=200)
    local = models.ForeignKey(Local, on_delete=models.CASCADE, related_name='local_eventos')
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='usuario_eventos')

    def __str__(self):
        return self.nome

    def clean(self):
        if self.data < timezone.now():
            raise ValidationError('A data do evento não pode ser no passado.')


class Reserva(models.Model):
    id_reserva = models.AutoField(primary_key=True)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    evento = models.ForeignKey(Eventos, on_delete=models.CASCADE)
    preco = models.DecimalField(max_digits=10, decimal_places=6, default=0)
    status = models.CharField(max_length=50, default='pendente')
    data_reserva = models.DateTimeField(auto_now_add=True, null=True)


    def __str__(self):
        return f"Reserva {self.id_reserva} - Evento: {self.evento.nome} - Usuário: {self.usuario.nome_completo}"

    def clean(self):
        if self.preco < 0:
            raise ValidationError('O preço da reserva não pode ser negativo.')
