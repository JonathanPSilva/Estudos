## Configurando chave SSH  - GitHub

Gerando chave SSH:
```bash
ssh-keygen -t ed25519 -C "Comentario aqui"
```

Adicione essa chave publica a sua conta no Github em Settings > SSH and GPG Keys. Nesse caso nomeei a chave como github com o comando anterior.
```bash
cat ~/.ssh/github.pub
```


Adicionando chave ssh ao ssh-agent
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

```

Teste de conexão com o GitHub via SSH.
```bash
ssh -T git@github.com
```

Caso tenha dado certo você verá uma mensagem como:
```bash
Hi SuaConta! You've successfully authenticated, but GitHub does not provide shell access.
```

Recebendo essa mensagem anterior agora é só clonar seu repositório com a opção ssh.

```bash
git clone git@github.com:SeuUsuario/Repositorio.git
```

## Problemas

Mesmo seguindo o procedimento e funcionando via Terminal o Obsidian reclamou algumas vezes de Permission Denied. Caso tenha esse problema seguir os proximos passos para tentar resolver.

1. Feche o Obsidian.
2. Configure Git user.name:
```bash
git config user.name "Seu nome aqui"
```

3. Configure Git user.email:
```bash
git config user.email "seuEmail@aqui"
```
4. Certifique-se de que o ssh-agent esta rodando.
```bash
eval "$(ssh-agent -s)"
```
5. Certifique-se de que a chave ssh correta foi adicionar ao ssh-agent:
```bash
ssh-add ~/.ssh/suaChavePrivDoGitHub
```
6. 

#obsidian-git #git