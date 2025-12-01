from rest_framework import serializers
from .models import Pergunta, Resposta, Voto, Denuncia, Notificacao


class PerguntaSerializer(serializers.ModelSerializer):
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


class VotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Voto
        fields = ['tipo', 'pergunta', 'usuario']