# Configuração de TestFlight para CI/CD

Este documento explica como configurar a autenticação para upload de builds no TestFlight para os dois times (Lello e Hubert) em ambientes de CI/CD.

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Pré-requisitos](#pré-requisitos)
3. [Geração de App-Specific Passwords](#geração-de-app-specific-passwords)
4. [Configuração no GitLab CI/CD](#configuração-no-gitlab-cicd)
5. [Variáveis de Ambiente](#variáveis-de-ambiente)
6. [Segurança e Boas Práticas](#segurança-e-boas-práticas)
7. [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

O projeto **app-lello-colaborador** suporta dois flavors (Lello e Hubert), cada um com sua própria conta Apple Developer:

| Flavor | Team ID | Team Name | Bundle ID |
|--------|---------|-----------|-----------|
| **Lello** | `RNEA6DL9E4` | Lello Condominios Sociedade Simples Ltda | `app.lello.colaborador` |
| **Hubert** | `Z3H6XQP5FK` | Hubert Imoveis e Administracao Ltda. | `app.hubert.colaborador` |

Para fazer upload de builds no TestFlight via CI/CD, é necessário configurar **App-Specific Passwords** para cada conta.

---

## 📋 Pré-requisitos

- Acesso administrativo às contas Apple Developer de ambos os times
- Acesso administrativo ao projeto no GitLab
- Permissão para configurar variáveis protegidas no GitLab CI/CD

---

## 🔑 Geração de App-Specific Passwords

### Para o Team Lello

1. **Acesse o Apple ID**: https://appleid.apple.com/account/manage
2. **Faça login** com a conta: `sharepoint_infra@arbit.com.br`
3. Navegue para: **Sign-In and Security** → **App-Specific Passwords**
4. Clique em **"Generate Password"** (ícone `+`)
5. **Nome sugerido**: `GitLab CI - Lello Colaborador`
6. **Copie a senha** gerada (formato: `xxxx-xxxx-xxxx-xxxx`)
7. ⚠️ **IMPORTANTE**: Guarde essa senha em local seguro (ela não pode ser visualizada novamente)

### Para o Team Hubert

1. **Acesse o Apple ID**: https://appleid.apple.com/account/manage
2. **Faça login** com a conta: `victor.mariano@lello.com.br`
3. Navegue para: **Sign-In and Security** → **App-Specific Passwords**
4. Clique em **"Generate Password"** (ícone `+`)
5. **Nome sugerido**: `GitLab CI - Hubert Colaborador`
6. **Copie a senha** gerada (formato: `xxxx-xxxx-xxxx-xxxx`)
7. ⚠️ **IMPORTANTE**: Guarde essa senha em local seguro

---

## ⚙️ Configuração no GitLab CI/CD

### 1. Acessar Configurações do Projeto

1. Vá para o projeto no GitLab
2. **Settings** → **CI/CD**
3. Expanda a seção **Variables**

### 2. Criar Variáveis para o Team Lello

Adicione as seguintes variáveis:

| Key | Value | Protected | Masked | Description |
|-----|-------|-----------|--------|-------------|
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD_LELLO` | `xxxx-xxxx-xxxx-xxxx` | ✅ Yes | ✅ Yes | App-Specific Password do Lello |
| `APPLE_ID_LELLO` | `sharepoint_infra@arbit.com.br` | ✅ Yes | ❌ No | Email da conta Apple Developer Lello |

### 3. Criar Variáveis para o Team Hubert

Adicione as seguintes variáveis:

| Key | Value | Protected | Masked | Description |
|-----|-------|-----------|--------|-------------|
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD_HUBERT` | `yyyy-yyyy-yyyy-yyyy` | ✅ Yes | ✅ Yes | App-Specific Password do Hubert |
| `APPLE_ID_HUBERT` | `victor.mariano@lello.com.br` | ✅ Yes | ❌ No | Email da conta Apple Developer Hubert |

### 4. Configurações Recomendadas

Para cada variável:
- ✅ **Protected**: Marcar como "Yes" (só estará disponível em branches protegidas)
- ✅ **Masked**: Marcar como "Yes" para senhas (serão ocultadas nos logs)
- ❌ **Expand variable reference**: Deixar desmarcado

---

## 🔧 Variáveis de Ambiente

### Resumo das Variáveis Necessárias

```bash
# Team Lello
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD_LELLO=xxxx-xxxx-xxxx-xxxx
APPLE_ID_LELLO=sharepoint_infra@arbit.com.br

# Team Hubert
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD_HUBERT=yyyy-yyyy-yyyy-yyyy
APPLE_ID_HUBERT=victor.mariano@lello.com.br
```

### Como São Usadas no Pipeline

O arquivo `.gitlab-ci.yml` já está configurado para usar essas variáveis automaticamente:

```yaml
# Exemplo para deploy do Hubert
ios_testflight_hubert_deployment:
  stage: production_deployment
  script:
    - export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="${FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD_HUBERT}"
    - bundle exec fastlane ios testflight_beta flavor:hubert environment:prod ci_commit:"${CI_COMMIT_MESSAGE}"
  only:
    - main
    - tags
```

---

## 🔒 Segurança e Boas Práticas

### ✅ Recomendações

1. **Rotação de Senhas**
   - Renovar as App-Specific Passwords a cada 6-12 meses
   - Revogar senhas antigas imediatamente após gerar novas

2. **Acesso Restrito**
   - Configurar variáveis como **Protected** (apenas branches protegidas)
   - Configurar variáveis como **Masked** (ocultar nos logs)
   - Limitar acesso de Maintainer/Owner no GitLab

3. **Separação de Credenciais**
   - Usar senhas diferentes para cada time
   - Nunca compartilhar senhas entre projetos

4. **Monitoramento**
   - Verificar periodicamente o uso das senhas em: https://appleid.apple.com/account/manage
   - Revogar senhas suspeitas imediatamente

5. **Backup Seguro**
   - Armazenar senhas em gerenciador de senhas corporativo (1Password, LastPass, etc)
   - **NUNCA** commitar senhas no Git
   - **NUNCA** compartilhar senhas via Slack/Email

### ❌ O Que NÃO Fazer

- ❌ Não commitar senhas no código
- ❌ Não usar a mesma senha para múltiplos projetos
- ❌ Não compartilhar senhas via canais inseguros
- ❌ Não deixar variáveis sem marcar como "Protected" e "Masked"
- ❌ Não usar senhas pessoais em pipelines corporativos

---

## 🐛 Troubleshooting

### Erro: "Sign in with the app-specific password you generated"

**Causa**: Senha inválida, expirada ou não configurada corretamente.

**Solução**:
1. Verificar se a variável está configurada no GitLab com o nome correto
2. Gerar uma nova App-Specific Password
3. Atualizar a variável no GitLab
4. Re-executar o pipeline

### Erro: "Failed to find item AC_PASSWORD for user"

**Causa**: A máquina de CI está tentando usar o Keychain local em vez da variável de ambiente.

**Solução**:
1. Garantir que a variável `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` esteja configurada
2. Verificar se o `.gitlab-ci.yml` está exportando a variável corretamente

### Erro: "Could not determine the appleID from bundleID"

**Causa**: Bundle ID não encontrado na conta especificada ou credenciais incorretas.

**Solução**:
1. Verificar se o Bundle ID existe no App Store Connect
2. Verificar se o email (`APPLE_ID_*`) está correto
3. Confirmar que a conta tem permissões de acesso ao app

### Erro: "No profile for team matching"

**Causa**: Provisioning profile não existe ou está usando team ID incorreto.

**Solução**:
1. Executar `fastlane match` para gerar os profiles
2. Verificar se o Team ID está correto no código
3. Confirmar que os certificados foram gerados na branch correta do repositório de certificados

---

## 📚 Referências

- [App-Specific Passwords - Apple Support](https://support.apple.com/en-us/HT204397)
- [Fastlane - Authentication](https://docs.fastlane.tools/best-practices/continuous-integration/#authentication)
- [GitLab CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/)
- [Match - Code Signing](https://docs.fastlane.tools/actions/match/)

---

## 📞 Suporte

Para questões relacionadas a:
- **Configuração de CI/CD**: Time de DevOps
- **Acesso às contas Apple**: Administradores dos respectivos teams
- **Problemas com builds**: Time de desenvolvimento iOS

---

**Última atualização**: 28 de Janeiro de 2026
