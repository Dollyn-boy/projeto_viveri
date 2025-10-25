from rest_framework import serializers
from .models import Usuario, PessoaFisica, PessoaJuridica, SegurancaModeracao
from django.contrib.auth.hashers import make_password

class UsuarioSerializer(serializers.ModelSerializer):
    pessoa_fisica = serializers.PrimaryKeyRelatedField(read_only=True)
    pessoa_juridica = serializers.PrimaryKeyRelatedField(read_only=True)
    
    class Meta:
        model = Usuario
        # Lista de campos que vão ser inclúidos na API
        fields = '__all__'
        
        read_only_fields = ['date_joined']
        
    # Cria usuário com senha hasheada
    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        
        if password is not None:
            instance.set_password(password)
        instance.save()
        return instance
    
    # Atualiza senha se for necessário
    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        # Atualiza os outros campos normalmente
        instance = super().update(instance, validated_data)
        if password is not None:
            instance.set_password(password)
            instance.save()
        return instance
    

class PessoaFisicaSerializer(serializers.ModelSerializer):
    usuario_username = serializers.ReadOnlyField(source='usuario.username')
    
    class Meta:
        model = PessoaFisica
        fields = ['usuario', 'usuario_username', 'cpf', 'data_nascimento']


class PessoaJuridicaSerializer(serializers.ModelSerializer):
    usuario_username = serializers.ReadOnlyField(source='usuario.username')

    class Meta:
        model = PessoaJuridica
        fields = ['usuario', 'usuario_username', 'cnpj', 'razao_social', 
            'nome_fantasia', 'endereco_comercial', 
            'documentacao_verificada', 'selo_verificacao']
        

class SegurancaModeracaoSerializer(serializers.ModelSerializer):
    denunciante_username = serializers.ReadOnlyField(source='usuario_denunciante.username')
    denunciado_username = serializers.ReadOnlyField(source='usuario_denunciado.username')

    class Meta:
        model = SegurancaModeracao
        fields = [
            'id', 'usuario_denunciante', 'denunciante_username', 
            'usuario_denunciado', 'denunciado_username', 'tipo_denuncia', 
            'descricao', 'status_denuncia', 'data_denuncia'
        ]
        read_only_fields = ['data_denuncia']