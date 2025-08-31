# 🎬 GUIA COMPLETO - API TMDb Real

## 🚀 COMO ATIVAR A BUSCA REAL DE FILMES:

### **PASSO 1: Criar conta no TMDb (GRATUITA)**
1. Acesse: **https://www.themoviedb.org/signup**
2. Preencha seus dados
3. Confirme o email

### **PASSO 2: Solicitar API Key**
1. Faça login no site
2. Vá em: **Account Settings → API**
   - URL direta: https://www.themoviedb.org/settings/api
3. Clique em **"Create"** na seção "API Key (v3 auth)"
4. Preencha o formulário:
   - **Application name**: "ClecProject iOS App"
   - **Application URL**: pode deixar em branco ou colocar github
   - **Application summary**: "App iOS para gerenciar filmes favoritos"
   - **Type of Use**: Personal/Educational
5. Aceite os termos
6. **Copie a API Key** gerada (algo como: `1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p`)

### **PASSO 3: Configurar no App**
1. Abra o projeto no Xcode
2. Vá para: `Services/TMDbService.swift`
3. **Encontre a linha 15:**
   ```swift
   private let apiKey = "SEU_API_KEY_AQUI"  // ⚠️ SUBSTITUA
   ```
4. **Substitua** por sua API Key:
   ```swift
   private let apiKey = "1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p"  // ✅ SUA KEY AQUI
   ```
5. **Salve o arquivo** (Cmd+S)

### **PASSO 4: Testar**
1. **Execute o app** (Cmd+R)
2. Long press no logo → adiciona projetos mock
3. **Clique na foto de perfil** → entra no perfil
4. **Clique em qualquer slot de filme vazio** (+)
5. **Digite para buscar**: "inception", "avatar", "batman"
6. **Verifique o status**: deve aparecer "✅ API Real Ativa"

---

## 🔍 **COMO SABER SE ESTÁ FUNCIONANDO:**

### ✅ **API FUNCIONANDO:**
- Status: "✅ API Real Ativa" 
- Busca retorna filmes reais do TMDb
- Posters carregam de verdade
- Mais filmes disponíveis para busca

### ❌ **API NÃO FUNCIONANDO:**
- Status: "❌ API Key Inválida" ou "🎭 Modo Demo"
- Só aparece 10 filmes mock pré-definidos
- Console mostra erro de API key

---

## 🐛 **RESOLUÇÃO DE PROBLEMAS:**

### **Problema: "API Key Inválida"**
```
✅ Solução:
1. Verifique se copiou a key completa
2. Não deve ter espaços antes/depois
3. Deve ter cerca de 32 caracteres
4. Teste a key em: https://api.themoviedb.org/3/configuration?api_key=SUA_KEY
```

### **Problema: "Nenhum filme encontrado"**
```
✅ Soluções:
1. Busque em inglês: "batman" ao invés de "batman cavaleiro"
2. Teste nomes simples: "avatar", "matrix", "titanic"
3. Verifique conexão com internet
```

### **Problema: Console mostra erros HTTP**
```
✅ Debug:
1. Abra Console no Xcode
2. Busque por mensagens com 📡 ou ❌
3. Se Status Code 401 = API key inválida
4. Se Status Code 404 = URL errada
```

---

## 🎯 **TESTE RÁPIDO:**

Execute este teste para confirmar que está tudo funcionando:

1. **Abra o app**
2. **Long press no logo CLÉQUI!** → adiciona projetos mock
3. **Clique na foto de perfil** → abre tela de perfil
4. **Clique no primeiro slot de filme vazio** (ícone +)
5. **Digite "batman"** na busca
6. **Deve aparecer vários filmes do Batman**
7. **Status deve mostrar "✅ API Real Ativa"**

---

## 📊 **LIMITES DA API GRATUITA:**

- ✅ **40 requisições por 10 segundos**
- ✅ **Busca ilimitada de filmes**
- ✅ **Posters em alta qualidade**
- ✅ **Informações completas dos filmes**
- ✅ **Mais que suficiente para o app**

---

## 💡 **DICAS EXTRAS:**

### **Buscar Filmes Brasileiros:**
- "cidade de deus"
- "tropa de elite" 
- "central do brasil"

### **Buscar Filmes Populares:**
- "avengers"
- "star wars"
- "harry potter"

### **Ver Console Debug:**
- No Xcode: View → Debug Area → Console
- Mensagens começam com 🔍, ✅, ou ❌

---

**🎬 Agora sua busca está usando a API real do TMDb com mais de 500.000 filmes!**

*Criado em: 31/08/2025*
