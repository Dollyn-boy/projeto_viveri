from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.exceptions import ValidationError
from datetime import date

# ABSTRACT USER JÁ VEM COM OS CAMPOS ID, NOME COMPLETO(first name e last name) E SENHA, POR ISSO FORAM REMOVIDOS AQUI
class Usuario(AbstractUser):
    email = models.EmailField(unique=True)
    status_conta = models.BooleanField(default=False)
    codigo_verificacao = models.CharField(max_length=6, null=True, blank=True)
    flag_userPF = models.BooleanField(default=False)
    flag_userPJ = models.BooleanField(default=False)
    
    
    def str(self):
        return self.first_name or self.email

    def clean(self):
        if self.flag_userPF and self.flag_userPJ:
            raise ValidationError("Usuário não pode ser PF e PJ ao mesmo tempo")
        
        super().clean()

class PessoaFisica(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE, related_name="pessoa_fisica")
    cpf = models.CharField(max_length=11, unique=True)
    data_nascimento = models.DateField()

    def str(self):
        return f"{self.usuario.first_name +  " " + self.usuario.last_name }"
    
    def clean(self):
        if self.data_nascimento >= date.today():
            raise ValidationError("Data de nascimento inválida")
        
        if len(self.cpf) != 11:
            raise ValidationError("CPF deve ter 11 dígitos")
        
        super().clean()


class PessoaJuridica(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE, related_name="pessoa_juridica")
    cnpj = models.CharField(max_length=14, unique=True)
    razao_social = models.CharField(max_length=255)
    nome_fantasia = models.CharField(max_length=255, null=True, blank=True)
    endereco_comercial = models.CharField(max_length=255)
    documentacao_verificada = models.BooleanField(default=False)
    selo_verificacao = models.BooleanField(default=False)

    def str(self):
        return f"{self.razao_social}"
    
    def clean(self):
        if len(self.cnpj) != 14:
            raise ValidationError("CNPJ deve ter 14 dígitos")
        
        super().clean()



class SegurancaModeracao(models.Model):
    
    class StatusDenuncia(models.TextChoices):
        ABERTA = 'ABERTA', 'Aberta'
        EM_ANALISE = 'EM_ANALISE', 'Em Análise'
        RESOLVIDA = 'RESOLVIDA', 'Resolvida'
        REJEITADA = 'REJEITADA', 'Rejeitada'
    
    usuario_denunciante = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name="denuncias_enviadas")
    usuario_denunciado = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name="denuncias_recebidas")
    tipo_denuncia = models.CharField(max_length=100)
    descricao = models.TextField()
    status_denuncia = models.CharField(max_length=50, choices=StatusDenuncia.choices, default=StatusDenuncia.ABERTA)
    data_denuncia = models.DateTimeField(auto_now_add=True)

    def str(self):
        return f"Denúncia {self.id} - {self.tipo_denuncia}"
        #talvez seja self.pk mas vou deixar pra alguem testar dps
    
    def clean(self):
        if self.usuario_denunciado == self.usuario_denunciante:
            raise ValidationError("Um usuário não pode denunciar sua própria conta")
        
        super().clean()