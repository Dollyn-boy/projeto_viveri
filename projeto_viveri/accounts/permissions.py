
from rest_framework.permissions import BasePermission
class IsPessoaJuridica(BasePermission): #valeu galera de eventos tmjt
    """
    Permite acesso apenas a usuários PJ com documentação verificada
    """
    def has_permission(self, request, view):
        return bool(
            request.user and 
            request.user.is_authenticated and 
            request.user.flag_userPJ
        )


class IsSelf(BasePermission):
    """
    so eu posso editrar eu
    """
    def has_object_permission(self, request, view, obj):
        #verifica se o usuario é o usuario 👍👍👍👍
        return obj == request.user