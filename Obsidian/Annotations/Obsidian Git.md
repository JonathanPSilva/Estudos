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
#obsidian-git #git