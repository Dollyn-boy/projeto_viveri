from django.db import models

# Create your models here.
class Pergunta(models.Model):
    txt = models.TextField()
    data = models.DateTimeFieldt()
    





class Denuncia(models.Model):
    descricao = models.TextField()
    data =  models.DateTimeField(auto_now_add=True)