from rest_framework import serializers
from .models import *

class PeguntaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pergunta
        fields = ['id', 'txt', 'usuario', 'evento']

class RespostaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Resposta
        fields = ['id', 'txt', 'usuario', 'pergunta']
        




