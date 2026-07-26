# Remoção física do provider CML legado

Este runbook é histórico e não faz parte do corpus semântico ativo. Ele existe
somente para concluir a remoção física já aprovada.

1. Abra **Editar as variáveis de ambiente do sistema** como administrador.
2. Clique em **Variáveis de Ambiente**.
3. Em **Variáveis do sistema**, edite `Path`.
4. Remova somente `C:\Program Files\Correnth\CML MCP`.
5. Confirme todas as janelas e reinicie Codex e terminais.
6. Valide:

   ```powershell
   (Get-Command cml -ErrorAction SilentlyContinue) -eq $null
   $env:Path -notlike '*CML MCP*'
   -not (Test-Path 'C:\Program Files\Correnth\CML MCP')
   ```

Os três resultados esperados são `True`.
