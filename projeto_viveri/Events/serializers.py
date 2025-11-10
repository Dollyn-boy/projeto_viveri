from rest_framework import serializers
from .models import Eventos, Local, Categoria, Reserva

class EventosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Eventos
        fields = '__all__'
        #fields = ['id', 'nome_evento', 'data_evento', 'local', 'categoria', 'descricao']

class LocalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Local
        fields = '__all__'
        #fields = ['id', 'nome_local', 'endereco', 'capacidade']

class CategoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = '__all__'
        #fields = ['id', 'nome_categoria', 'descricao']

class ReservaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reserva
        fields = '__all__'
        #fields = ['id', 'evento', 'usuario', 'data_reserva', 'quantidade_ingressos']