from rest_framework import serializers
from .models import Pergunta, Resposta, Voto, Denuncia, Notificacao
from accounts.models import Usuario
from Events.models import Eventos

class DenunciaSerializar(serializers.ModelSerializer):
    pergunta = serializers.PrimaryKeyRelatedField(queryset=Pergunta.objects.all())
    resposta = serializers.PrimaryKeyRelatedField(queryset=Resposta.objects.all())

    class Meta:
        model = Denuncia
        fields = 'id', 'descricao', 'data', 'pergunta', 'resposta'


class NotificacaoSerializer(serializers.ModelSerializer):
    pergunta = serializers.PrimaryKeyRelatedField(queryset=Pergunta.objects.all())
    usuario = serializers.PrimaryKeyRelatedField(queryset=Usuario.objects.all())
    evento = serializers.PrimaryKeyRelatedField(queryset=Eventos.objects.all())

    class Meta:
        model = Notificacao
        fields = 'id', 'tipo', 'conteudo', 'data', 'evento', 'pergunta'

class PerguntaSerializer(serializers.ModelSerializer):
    usuario = serializers.PrimaryKeyRelatedField(queryset=Usuario.objects.all())
    evento = serializers.PrimaryKeyRelatedField(queryset=Eventos.objects.all())

    class Meta:
        model = Pergunta
        fields = 'id', 'texto', 'data', 'usuario', 'evento'

class RespostaSerializer(serializers.ModelSerializer):
    pergunta = serializers.PrimaryKeyRelatedField(queryset=Pergunta.objects.all()) # Salva o ID da pergunta apenas
    usuario = serializers.PrimaryKeyRelatedField(queryset=Usuario.objects.all())

    class Meta:
        model = Resposta
        fields = "texto", "data", "pergunta", "usuario"

class VotoSerializer(serializers.ModelSerializer):
    usuario = serializers.PrimaryKeyRelatedField(queryset=Usuario.objects.all())

    class Meta:
        model = Voto
        fields = 'tipo', 'pergunta', 'usuario'