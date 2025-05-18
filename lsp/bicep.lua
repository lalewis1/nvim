local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
  cmd = { "dotnet", "/usr/local/bin/bicep-langserver/Bicep.LangServer.dll" },
  capabilities = capabilities,
  filetypes = { "bicep" },
  root_markers = { ".git", "main.bicep" },
}
