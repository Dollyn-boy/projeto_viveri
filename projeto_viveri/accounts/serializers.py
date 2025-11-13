from rest_framework import serializers
from .models import Usuario, PessoaFisica, PessoaJuridica, SegurancaModeracao
from django.contrib.auth.hashers import make_password
from django.contrib.auth import get_user_model
import random
from django.core.mail import send_mail
from .permissions import IsSelf, IsPessoaJuridica
User = get_user_model()



class UsuarioSerializer(serializers.ModelSerializer):
    pessoa_fisica = serializers.PrimaryKeyRelatedField(read_only=True)
    pessoa_juridica = serializers.PrimaryKeyRelatedField(read_only=True)
    
    class Meta:
        model = Usuario
        # Lista de campos que vão ser inclúidos na API
        fields = '__all__'
        #campos inalteraveis pelo usuario cmum
        read_only_fields = [
                'id',
                'is_staff',
                'is_superuser',
                'is_active',
                'status_conta',
                'last_login',
                'date_joined',
                'groups',          
                'user_permissions'
            ]
        #campos q a api n manda
        extra_kwargs = {
            'password': {'write_only': True}
        }
        
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
        
    def validate(self, data):
        #pra verificar se o usuario esta denunciando a si mesmo
        if data['usuario_denunciante'] == data['usuario_denunciado']:
            raise serializers.ValidationError("Um usuário não pode denunciar sua própria conta")
        return data
        
class LoginSerializer(serializers.Serializer):
    email = serializers.CharField()
    password = serializers.CharField()


class ForgotPasswordSerializer(serializers.Serializer):
   
    email = serializers.EmailField()

    def validate_email(self, value):
        if not User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email não encontrado.")
        return value
    

    def save(self):
        email = self.validated_data['email']
        user = User.objects.get(email=email)
        codigo  = str(random.randint(100000, 999999))
        user.codigo_verificacao = codigo
        user.save()

        send_mail(
            'Recuperacao de senha',
            f'Seu codigo de recuperação é {codigo}',
            'noreply@meusite.com',
            [email],
        )

        return user
    


class VerifyCodeSerializer(serializers.Serializer):
    email = serializers.EmailField()
    codigo = serializers.CharField(max_length=6)
    nova_senha = serializers.CharField(write_only=True)

    def validate(self, data):
        try:
            user = User.objects.get(email=data['email'], codigo_verificacao=data['codigo'])
        except User.DoesNotExist:
            raise serializers.ValidationError("Código inválido ou e-mail incorreto.")
        data['user'] = user
        return data

    def save(self):
        user = self.validated_data['user']
        user.set_password(self.validated_data['nova_senha'])
        user.codigo_verificacao = None
        user.save()
        return user