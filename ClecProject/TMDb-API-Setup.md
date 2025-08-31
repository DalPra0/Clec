# 🎬 CONFIGURAÇÃO DA API TMDb (The Movie Database)

## Para ativar a busca REAL de filmes:

### 1. **Criar conta gratuita:**
   - Acesse: https://www.themoviedb.org/signup
   - Confirme o email

### 2. **Gerar API Key:**
   - Vá em: https://www.themoviedb.org/settings/api
   - Clique em "Create" na seção "API Key (v3 auth)"
   - Preencha as informações (uso educacional/pessoal)
   - Copie a API Key gerada

### 3. **Configurar no app:**
   - Abra `Services/TMDbService.swift`
   - Substitua `"demo_key"` pela sua API key real
   - Descomente o código da busca real no `MovieSearchViewModel.swift` (linhas comentadas)

### 4. **Testar:**
   - Execute o app
   - Entre na tela de perfil
   - Tente buscar um filme
   - Deve funcionar com dados reais!

---

## 💡 **Modo DEMO (atual):**
- Funciona SEM API key
- Usa 5 filmes mock (Clube da Luta, Pulp Fiction, etc.)
- Busca funciona por filtro local
- Perfeito para desenvolvimento/teste

---

## 🔧 **Implementação Atual:**
✅ Interface completa (busca, grid, favoritos)  
✅ Persistência dos filmes favoritos  
✅ Limite de 4 filmes  
✅ Remover/substituir filmes  
✅ Visual estilo Letterboxd  
🔄 API real (opcional - só trocar a key)

---

*Criado em: 31/08/2025*
