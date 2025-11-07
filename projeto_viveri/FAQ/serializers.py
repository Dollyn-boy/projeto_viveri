from rest_framework import serializers
from .models import *

class PeguntaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pergunta
        fields = ['id', 'txt', 'data', 'usuario', 'evento', 'total_votes']


class RespostaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Resposta
        fields = ['id', 'txt', 'data', 'usuario', 'pergunta']
        

class DenunciaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Denuncia
        fields = ['id', 'descricao', 'data', 'usuario', 'pergunta', 'resposta']


class NotificacaoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notificacao
        fields = ['id', 'tipo', 'conteudo', 'data', 'usuario', 'evento', 'pergunta']




