import datetime
from unittest.mock import patch
from django.test import TestCase
from django.core.exceptions import ValidationError
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse
from django.contrib.auth import get_user_model

from .models import PessoaFisica, PessoaJuridica, SegurancaModeracao


Usuario = get_user_model()


class ModelValidationTests(TestCase):
    """
    todas as validacoes possiveis
    """

    def setUp(self):
        self.user_pf = Usuario.objects.create_user(
            username='userpf', email='pf@test.com', password='password123', flag_userPF=True)
        self.user_pj = Usuario.objects.create_user(
            username='userpj', email='pj@test.com', password='password123', flag_userPJ=True)
        self.user_both = Usuario(
            username='userboth', email='both@test.com', flag_userPF=True, flag_userPJ=True)

    def test_usuario_pf_and_pj_raises_error(self):
        """testa se o usuario pd ser pj e pf simulntamenate"""
        with self.assertRaises(ValidationError, msg="usuario não pode ser PF e PJ ao mesmo tempo"):
            self.user_both.clean()

    def test_pf_invalid_cpf_length(self):
        """Testa se CPF com tamanho errado falha na validação."""
        pf = PessoaFisica(
            usuario=self.user_pf, cpf="123", data_nascimento=datetime.date(2000, 1, 1))
        with self.assertRaises(ValidationError, msg="CPF nao tem 11 dígitos"):
            pf.clean()

    def test_pf_invalid_data_nascimento(self):
        """testa se data de nascimento no futuro falha na validação."""
        amanha = datetime.date.today() + datetime.timedelta(days=1)
        pf = PessoaFisica(
            usuario=self.user_pf, cpf="12345678901", data_nascimento=amanha)
        with self.assertRaises(ValidationError, msg="Data de nascimento inválida"):
            pf.clean()

    def test_pj_invalid_cnpj_length(self):
        """testa se CNPJ com tamanho errado falha na validação."""
        pj = PessoaJuridica(
            usuario=self.user_pj, cnpj="123", razao_social="jorge LTDA")
        with self.assertRaises(ValidationError, msg="CNPJ nao tem 14 dígitos"):
            pj.clean()

    def test_moderacao_self_report_raises_error(self):
        """testa se um usuário falha ao denunciar a si mesmo."""
        report = SegurancaModeracao(
            usuario_denunciante=self.user_pf,
            usuario_denunciado=self.user_pf,
            tipo_denuncia="oi",
            descricao="eu vou denunciar eu"
        )
        with self.assertRaises(ValidationError, msg="Um usuário não pode denunciar sua própria conta"):
            report.clean()


class UserAuthAPITests(APITestCase):
    """
    as rotas de login
    """

    def setUp(self):
        self.registro_url = reverse('usuario-list')  # /usuarios/
        self.login_url = reverse('usuario-login')  # /usuarios/login/

        # Usuário para teste de login
        self.user = Usuario.objects.create_user(
            username='testuser', email='test@test.com', password='senha1234')

    def test_user_registration(self):
        """Garante que um novo usuário pode ser criado."""
        data = {
            'username': 'newuser',
            'email': 'new@test.com',
            'password': 'senha1234',
            'first_name': 'New',
            'last_name': 'User'
        }
        response = self.client.post(self.registro_url, data)
        # Este teste AINDA VAI FALHAR com o TypeError
        # se você não corrigir o UsuarioSerializer (adicionando 'groups'
        # e 'user_permissions' aos 'read_only_fields')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Usuario.objects.count(), 2)
        
        # Verifica se a senha foi hasheada
        created_user = Usuario.objects.get(email='new@test.com')
        self.assertTrue(created_user.check_password('senha1234'))
        self.assertNotEqual(created_user.password, 'senha1234')

    def test_user_login(self):
        """Garante que um usuário existente pode fazer login."""
        data = {'email': 'test@test.com', 'password': 'senha1234'}
        response = self.client.post(self.login_url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_user_login_invalid_credentials(self):
        """Garante que login com credenciais erradas falha."""
        data = {'email': 'test@test.com', 'password': 'senhaerrada'}
        response = self.client.post(self.login_url, data)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertIn('error', response.data)

class UsuarioViewSetPermissionTests(APITestCase):
    """
    testa as permissões   
    """

    def setUp(self):
        self.user = Usuario.objects.create_user(
            username='roberto', email='roberto@test.com', password='senha1234')
        self.other_user = Usuario.objects.create_user(
            username='carlos', email='carlos@test.com', password='senha1234')
        self.admin_user = Usuario.objects.create_superuser(
            username='admin', email='admin@test.com', password='senhaadmin1234')

        self.pj_user = Usuario.objects.create_user(
            username='empresa', 
            email='empresa@test.com', 
            password='senha1234', 
            flag_userPJ=True
        )
        
        self.list_url = reverse('usuario-list') # /usuarios/
        self.detail_url_user = reverse('usuario-detail', kwargs={'pk': self.user.pk})
        self.detail_url_other = reverse('usuario-detail', kwargs={'pk': self.other_user.pk})
        self.detail_url_admin = reverse('usuario-detail', kwargs={'pk': self.admin_user.pk})
        self.detail_url_pj = reverse('usuario-detail', kwargs={'pk': self.pj_user.pk})

    def test_list_users_as_admin(self):
        """admin pode listar todos os usuários."""
        self.client.force_authenticate(user=self.admin_user)
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['count'], 4)

    def test_list_users_as_regular_user(self):
        """usuario comum NÃO pode listar usuários."""
        self.client.force_authenticate(user=self.user)
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_list_users_unauthenticated(self):
        """ususario não autenticado NÃO pode listar usuários."""
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_retrieve_self_as_regular_user(self):
        """usuario comum PODE ver o próprio perfil."""
        self.client.force_authenticate(user=self.user)
        response = self.client.get(self.detail_url_user)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_retrieve_other_as_regular_user_FAILS(self):
        """usuario comum NÃO pode ver outro perfil."""
        self.client.force_authenticate(user=self.user)
        response = self.client.get(self.detail_url_other)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_retrieve_self_as_admin(self):
        """admin PODE ver o PRÓPRIO perfil."""
        self.client.force_authenticate(user=self.admin_user)
        response = self.client.get(self.detail_url_admin)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_retrieve_other_as_admin(self):
        """admin PODE ver OUTRO perfil."""
        self.client.force_authenticate(user=self.admin_user)
        response = self.client.get(self.detail_url_user)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['email'], self.user.email)
    
    def test_retrieve_other_as_pj(self):
        """usuario pj PODE ver OUTRO perfil."""
        self.client.force_authenticate(user=self.pj_user)
        response = self.client.get(self.detail_url_user)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['email'], self.user.email)
    
    def test_update_other_as_admin(self):
        """Admin PODE atualizar OUTRO perfil."""
        self.client.force_authenticate(user=self.admin_user)
        data = {'first_name': 'admatualizado'}
        response = self.client.patch(self.detail_url_other, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.other_user.refresh_from_db()
        self.assertEqual(self.other_user.first_name, 'admatualizado')

    def test_update_other_as_regular_user(self):
        """usuario comum NÃO pode atualizar OUTRO perfil."""
        self.client.force_authenticate(user=self.user)
        data = {'first_name': 'aaa'}
        response = self.client.patch(self.detail_url_other, data)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        
    def test_delete_other_as_admin(self):
        """admin PODE deletar OUTRO perfil."""
        self.client.force_authenticate(user=self.admin_user)
        
        user_count_before = Usuario.objects.count()
        response = self.client.delete(self.detail_url_other)
        
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

        self.assertEqual(Usuario.objects.count(), user_count_before - 1) #so pra ter certez q ele n apagou algum outro usuario por acidente
        self.assertFalse(Usuario.objects.filter(pk=self.other_user.pk).exists())  

    def test_delete_other_as_regular_user(self):
        """usuario comum NÃO PODE deletar OUTRO perfil."""
        self.client.force_authenticate(user=self.user)
        
        user_count_before = Usuario.objects.count()
        response = self.client.delete(self.detail_url_other)
        
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        # Garante que ninguém foi deletado
        self.assertEqual(Usuario.objects.count(), user_count_before)

    def test_delete_self_as_regular_user(self):
        """usuario comum PODE deletar o PRÓPRIO perfil."""
        self.client.force_authenticate(user=self.user)
        
        user_count_before = Usuario.objects.count()
        response = self.client.delete(self.detail_url_user) # Deletando a si mesmo
        
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Usuario.objects.count(), user_count_before - 1)
        self.assertFalse(Usuario.objects.filter(pk=self.user.pk).exists())
        

class RelatedModelViewSetTests(APITestCase):
    """
    Testa os ViewSets de PessoaFisica, PessoaJuridica e SegurancaModeracao.
    """

    def setUp(self):
        self.user1 = Usuario.objects.create_user(
            username='user1', email='user1@test.com', password='password123', flag_userPF=True)
        self.user2 = Usuario.objects.create_user(
            username='user2', email='user2@test.com', password='password123', flag_userPJ=True)
        
        self.pf_url = reverse('pessoafisica-list') # /pessoas-fisicas/
        self.pj_url = reverse('pessoajuridica-list') # /pessoas-juridicas/
        self.mod_url = reverse('segurancamoderacao-list') # /moderacao/

    def test_create_pf_authenticated(self):
        """usuario autenticado pode criar PessoaFisica."""
        self.client.force_authenticate(user=self.user1)
        data = {
            'usuario': self.user1.pk,
            'cpf': '11122233344',
            'data_nascimento': '1990-05-15'
        }
        response = self.client.post(self.pf_url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(PessoaFisica.objects.filter(usuario=self.user1).exists())

    def test_create_pj_unauthenticated(self):
        """usuario não autenticado não pode criar PessoaJuridica."""
        data = {
            'usuario': self.user2.pk,
            'cnpj': '11222333000144',
            'razao_social': 'Empresa Teste',
            'endereco_comercial': 'Rua Teste, 123'
        }
        response = self.client.post(self.pj_url, data)


        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_create_report_authenticated(self):
        """usuario autenticado pode criar uma denúncia."""
        self.client.force_authenticate(user=self.user1)
        data = {
            'usuario_denunciante': self.user1.pk,
            'usuario_denunciado': self.user2.pk,
            'tipo_denuncia': 'Comportamento inadequado',
            'descricao': 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA.'
        }
        response = self.client.post(self.mod_url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(SegurancaModeracao.objects.count(), 1)
        self.assertEqual(response.data['status_denuncia'], 'ABERTA') # Testa o default

    def test_create_self_report_api_fails(self):
        """usuario nao pode se denunciar."""
        self.client.force_authenticate(user=self.user1)
        data = {
            'usuario_denunciante': self.user1.pk,
            'usuario_denunciado': self.user1.pk, 
            'tipo_denuncia': 'Spam',
            'descricao': 'Eu sou um spammer.'
        }
        response = self.client.post(self.mod_url, data)
        
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        
        self.assertIn('non_field_errors', response.data)


@patch('accounts.serializers.send_mail')
class PasswordResetTests(APITestCase):
    """
    Testa o fluxo de 'esqueci a senha' e 'verificar código'.
    """

    def setUp(self):
        self.user = Usuario.objects.create_user(
            username='resetuser', email='reset@test.com', password='password123')
        self.forgot_url = reverse('forgot_password') 
        self.verify_url = reverse('verify_code') 
            
    def test_forgot_password_success(self, mock_send_mail):
        """Testa se 'esqueci a senha' envia o e-mail e salva o código."""
        data = {'email': 'reset@test.com'}
        response = self.client.post(self.forgot_url, data)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['message'], "Código enviado para o e-mail.")
        
        self.assertTrue(mock_send_mail.called)
        
        self.user.refresh_from_db()
        self.assertIsNotNone(self.user.codigo_verificacao)
        self.assertEqual(len(self.user.codigo_verificacao), 6)

    def test_forgot_password_invalid_email(self, mock_send_mail):
        """testa a falha com e-mail que n existe."""
        data = {'email': 'naoexiste@test.com'}
        response = self.client.post(self.forgot_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('Email não encontrado', str(response.data['email']))
        self.assertFalse(mock_send_mail.called)

    def test_verify_code_and_reset_success(self, mock_send_mail):
        """testa se o código correto e a nova senha funcionam."""
     
        self.user.codigo_verificacao = "123456"
        self.user.save()

        data = {
            'email': 'reset@test.com',
            'codigo': '123456',
            'nova_senha': 'newsecurepassword'
        }
        response = self.client.post(self.verify_url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['message'], "Senha redefinida com sucesso.")

        # Verifica se a senha foi alterada
        self.user.refresh_from_db()
        self.assertTrue(self.user.check_password('newsecurepassword'))
        
    def test_verify_code_invalid_code(self, mock_send_mail):
        """Testa se um código inválido falha."""
        self.user.codigo_verificacao = "123456"
        self.user.save()

        data = {
            'email': 'reset@test.com',
            'codigo': '123457', 
            'nova_senha': 'newsecurepassword'
        }
        response = self.client.post(self.verify_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('Código inválido', str(response.data))