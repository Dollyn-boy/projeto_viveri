from rest_framework import serializers
from .models import Eventos, Local, Categoria, Reserva

class CategoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = ['id_categoria', 'nome']

class LocalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Local
        fields = ['id_local', 'nome', 'endereco', 'latitude', 'longitude']

class EventosSerializer(serializers.ModelSerializer):
    local = LocalSerializer(read_only=True)
    categoria = CategoriaSerializer(read_only=True)
    categoria_secundaria = CategoriaSerializer(read_only=True, allow_null=True)
    usuario_nome = serializers.CharField(source='usuario.get_full_name', read_only=True)
    faixa_etaria_display = serializers.CharField(source='get_faixa_etaria_display', read_only=True)
    situacao_display = serializers.CharField(source='get_situacao_display', read_only=True)

    class Meta:
        model = Eventos
        fields = [
            'id_evento', 'nome', 'descricao', 'data', 'horario', 'link',
            'local', 'categoria', 'categoria_secundaria', 'usuario_nome',
            'faixa_etaria', 'faixa_etaria_display', 'situacao', 'situacao_display',
            'data_criacao'
        ]

class ReservaSerializer(serializers.ModelSerializer):
    evento = EventosSerializer(read_only=True)
    usuario_nome = serializers.CharField(source='usuario.get_full_name', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)

    class Meta:
        model = Reserva
        fields = [
            'id_reserva', 'usuario_nome', 'evento', 'preco', 'status',
            'status_display', 'data_reserva', 'quantidade_ingressos'
        ]