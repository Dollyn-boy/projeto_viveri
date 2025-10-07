from django.db import models

# Create your models here.

# 1 - User model
  # id 
  # nome_completo
  # email
  # senha
  # status_conta
  # codigo_verificacao
  # flag_userPF
  # flag_userPJ
class User(models.Model):
    id = models.AutoField(primary_key=True)
    nome_completo = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    senha = models.CharField(max_length=255)
    status_conta = models.BooleanField(default=False)
    codigo_verificacao = models.CharField(max_length=100, null=True, blank=True)
    flag_userPF = models.BooleanField(default=False)
    flag_userPJ = models.BooleanField(default=False)

    def __str__(self):
        return self.nome_completo

    

# 2 - Pessoa fisica
  # id_pessoa_fisica
  # id_user (FK)
  # cpf
  # data_nascimento
class PessoaFisica(models.Model):
    id_pessoa_fisica = models.AutoField(primary_key=True)
    id_user = models.OneToOneField(User, on_delete=models.CASCADE)
    cpf = models.CharField(max_length=14, unique=True)
    data_nascimento = models.DateField()

    def __str__(self):
        return self.id_user.nome_completo

# 3 - Pessoa juridica
  # id_pessoa_juridica
  # id_user (FK)
  # cnpj
  # razao_social
  # nome_fantasia
  # endereco_comercial
  # documento_verificado 
  # selo_verificado
class PessoaJuridica(models.Model):
    id_pessoa_juridica = models.AutoField(primary_key=True)
    id_user = models.OneToOneField(User, on_delete=models.CASCADE)
    cnpj = models.CharField(max_length=18, unique=True)
    razao_social = models.CharField(max_length=255)
    nome_fantasia = models.CharField(max_length=255)
    endereco_comercial = models.TextField()
    documento_verificado = models.BooleanField(default=False)
    selo_verificado = models.BooleanField(default=False)

    def __str__(self):
        return self.nome_fantasia
