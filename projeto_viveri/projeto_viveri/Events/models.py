from django.db import models
from django.core.exceptions import ValidationError
from accounts.models import Usuario
from django.utils import timezone
from accounts.models import Usuario


#o outro ano separou local em espaço físico e endereço


class Categoria(models.Model):
    id_categoria = models.IntegerField(primary_key=True)
    nome = models.CharField(max_length=50)

    def __str__(self):
        return self.nome


# ----------------------------
#     MODELO DE LOCAL
# ----------------------------
class Local(models.Model):
    id_local = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=150, default='sem nome')
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='locais',null=True, blank=True  )
    capacidade = models.DecimalField(max_digits=10, decimal_places=0, default=0)
    endereco = models.TextField(default='')
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6,null=True, blank=True)

    def __str__(self):
        return self.nome
    
    def clean(self):
        if self.capacidade < 0:
            raise ValidationError('A capacidade não pode ser negativa.')




# ----------------------------
#    MODELO DE EVENTOS
# ----------------------------


class Eventos(models.Model):


    class StatusEvento(models.TextChoices):
        NAO_INICIADO = 'NAO_INICIADO', 'Não Iniciado'
        EM_ANDAMENTO = 'EM_ANDAMENTO', 'Em Andamento'
        CONCLUIDO = 'CONCLUIDO', 'Concluído'
        CANCELADO = 'CANCELADO', 'Cancelado' 
    
    class FaixaEtaria(models.TextChoices):
        LIVRE = 'LIVRE', 'Livre'
        MAIOR_12 = 'MAIOR_12', 'Maior de 12 anos'
        MAIOR_16 = 'MAIOR_16', 'Maior de 16 anos'
        MAIOR_18 = 'MAIOR_18', 'Maior de 18 anos'
        MAIOR_21 = 'MAIOR_21', 'Maior de 21 anos'

    id_evento = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=100)
    descricao = models.CharField(max_length=1000)
    data = models.DateTimeField(default=timezone.now)
    horario = models.TimeField(default="12:00")
    link = models.URLField(max_length=200)
    local = models.ForeignKey(Local, on_delete=models.CASCADE, related_name='eventos')
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='eventos')
    categoria = models.ForeignKey(Categoria, on_delete=models.CASCADE, related_name='eventos', default=1)
    categoria_secundaria = models.ForeignKey(Categoria, on_delete=models.SET_NULL, related_name='eventos_secundarios', null=True, blank=True)  

    faixa_etaria = models.CharField(
        max_length=20,
        choices=FaixaEtaria.choices,
        default=FaixaEtaria.LIVRE
    )
    situacao = models.CharField(
        max_length=20,
        choices=StatusEvento.choices,      
        default=StatusEvento.NAO_INICIADO
    )
    data_criacao = models.DateTimeField(auto_now_add=True, null=True, blank=True)

    
    def __str__(self):
        return self.nome
    
    def clean(self):
        if self.data < timezone.now():
            raise ValidationError('A data do evento não pode ser no passado.')




# ----------------------------
#      MODELO RESERVA
# ----------------------------
class Reserva(models.Model):
    class StatusReserva(models.TextChoices):
        PENDENTE = 'PENDENTE', 'Pendente'
        CONFIRMADA = 'CONFIRMADA', 'Confirmada'
        CANCELADA = 'CANCELADA', 'Cancelada'
        FINALIZADA = 'FINALIZADA', 'Finalizada'

    id_reserva = models.AutoField(primary_key=True)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='reservas')
    evento = models.ForeignKey(Eventos, on_delete=models.CASCADE, related_name='reservas')
    preco = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    status = models.CharField(
        max_length=20,
        choices=StatusReserva.choices,
        default=StatusReserva.PENDENTE
    )
    data_reserva = models.DateTimeField(auto_now_add=True)
    quantidade_ingressos = models.IntegerField(default=1)

    def __str__(self):
        usuario_nome = getattr(self.usuario, 'nome_completo', self.usuario.username)
        return f"Reserva {self.id_reserva} - Evento: {self.evento.nome} - Usuário: {usuario_nome}"
    
    def clean(self):
        if self.preco < 0:
            raise ValidationError('O preço da reserva não pode ser negativo.')
        if self.quantidade_ingressos <= 0:
            raise ValidationError('A quantidade de ingressos deve ser maior que zero.')