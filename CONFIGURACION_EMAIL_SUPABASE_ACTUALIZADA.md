# CONFIGURACIÓN DE EMAIL EN SUPABASE - GUÍA ACTUALIZADA

## 🎯 OBJETIVO: Solucionar "email_provider_disabled"

### PASO 1: Acceder a Authentication Settings
1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto "el-buho"
3. En el menú lateral: **Authentication** → **Settings**

### PASO 2: Configurar Email Provider (LO MÁS IMPORTANTE)
En la sección **"Auth Providers"** deberías ver:

```
📧 Email
   ✅ Enable sign up: [ACTIVAR ESTE]
   ✅ Enable login: [ACTIVAR ESTE]
```

**IMPORTANTE**: Si no ves estas opciones exactas, busca:
- "Enable email provider" → **ACTIVAR**
- "Email" → **ACTIVAR** 
- O simplemente un toggle junto a "Email" → **ACTIVAR**

### PASO 3: Configuraciones Adicionales (Si aparecen)
Dependiendo de tu versión de Supabase, podrías ver:

```
🔐 Email Settings:
   □ Enable email confirmations (opcional)
   □ Secure email change (opcional) 
   □ Double confirm email change (opcional)
```

**NO TE PREOCUPES** si no aparecen estas opciones. Lo importante es que el **Email Provider esté activado**.

### PASO 4: Configurar URLs Obligatorias
En la misma página, busca:

```
🌐 Site URL: http://localhost:3000
📱 Redirect URLs: 
   - http://localhost:3000/**
   - (Agrega esta línea)
```

### PASO 5: Configuración Mínima que SÍ DEBE aparecer
Estas opciones SIEMPRE deberían estar disponibles:

```
✅ Site URL: [Configurar]
✅ JWT expiry: 3600 (default está bien)
✅ Refresh token expiry: 604800 (default está bien)
```

## 🔍 QUÉ BUSCAR ESPECÍFICAMENTE

### Opción 1: Si ves una tabla de providers
```
Provider    | Status  | Actions
----------- | ------- | -------
Email       | ✅ ON   | Configure
Google      | ❌ OFF  | 
GitHub      | ❌ OFF  |
```

### Opción 2: Si ves una lista simple
```
📧 Email Provider
   [Toggle ON/OFF] ← ACTIVAR ESTE
```

### Opción 3: Si ves pestañas
Busca pestañas como:
- **Providers** (ahí está Email)
- **General** 
- **Email Templates**

## ⚠️ SI NO ENCUENTRAS LAS OPCIONES

### Verifica tu cuenta:
1. **Plan gratuito**: Debería tener acceso a email auth
2. **Proyecto creado correctamente**: Ve a Settings → General
3. **Región del proyecto**: Algunos proyectos antiguos pueden tener interfaces diferentes

### Alternativa - Verificar por API:
Si tienes dudas, puedes verificar el estado actual ejecutando en el SQL Editor:

```sql
-- Verificar configuración de auth
SELECT * FROM auth.config;
```

## 🚀 CONFIGURACIÓN MÍNIMA PARA QUE FUNCIONE

**SOLO necesitas activar:**
1. ✅ **Email Provider** (como sea que aparezca en tu dashboard)
2. ✅ **Site URL**: `http://localhost:3000`
3. ✅ **Guardar cambios**

**NO necesitas:**
- ❌ Email confirmations (opcional)
- ❌ SMTP personalizado (opcional)
- ❌ Templates personalizados (opcional)

## 📷 REFERENCIAS VISUALES

Busca algo que se vea así:
```
Authentication Settings
├── Providers
│   └── 📧 Email [Toggle] ← ESTE DEBE ESTAR ON
├── General
│   ├── Site URL
│   └── Redirect URLs
└── Email Templates (opcional)
```

---

## 💡 SIGUIENTE PASO

Una vez que hayas activado el **Email Provider**:
1. **Guarda** los cambios
2. **Espera 2-3 minutos**
3. **Prueba registrarte** en la app
4. El error "email_provider_disabled" debería desaparecer

¿Encuentras la opción de Email Provider para activarla?
