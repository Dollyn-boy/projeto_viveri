from django.db import models

# Create your models here.


class Eventos(models.Model):
    id_evento = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=100)
    descricao = models.CharField(max_length=1000)
    data = models.DateTimeField()
    link = models.URLField(max_length=200)
    local = models.ForeignKey(Local)
    usuario = models.ForeignKey(Usuario)

    def __str__(self):
        return self.nome


# class Reserva(models.Model):


class Local(models.Model):
    id_local = models.AutoField(primary_key=True)


class Categoria(models.Model):
    id_categoria = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=100)

    def __str__(self):
        return self.nome
