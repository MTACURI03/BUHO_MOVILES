# ACTIVAR EMAIL EN SUPABASE - TU INTERFAZ ESPECÍFICA

## 🎯 PASOS EXACTOS PARA TU DASHBOARD

### PASO 1: Ir a Sign In / Providers
1. En el menú de Authentication que ya tienes abierto
2. Haz clic en **"Sign In / Providers"**

### PASO 2: Activar Email Provider
Una vez en "Sign In / Providers" deberías ver una lista de proveedores:

```
📧 Email
   [Toggle o botón para activar] ← ACTIVAR ESTE

🔗 Google
   [Desactivado]

🔗 GitHub 
   [Desactivado]

🔗 Apple
   [Desactivado]
```

### PASO 3: Configurar Email
Al hacer clic en Email o activarlo, deberías ver opciones como:

```
✅ Enable email provider: ON
✅ Enable email signup: ON  
✅ Enable email login: ON
```

### PASO 4: Configurar URL Configuration
1. Regresa al menú y haz clic en **"URL Configuration"**
2. Configura:
   - **Site URL**: `http://localhost:3000`
   - **Redirect URLs**: Agrega `http://localhost:3000/**`

### PASO 5: Guardar
- Busca un botón **"Save"** o **"Update"**
- Haz clic para guardar los cambios
- Espera 2-3 minutos para que se apliquen

## 🔍 QUÉ BUSCAR EN "Sign In / Providers"

Deberías ver algo como:

```
Sign In / Providers
├── 📧 Email [Disabled] → Hacer clic para configurar
├── 🔗 Google [Disabled] 
├── 🔗 GitHub [Disabled]
├── 🔗 Apple [Disabled]
└── 🔗 Otros providers...
```

## ⚡ PASOS RÁPIDOS

1. **Authentication** → **Sign In / Providers**
2. **Buscar "Email"** en la lista
3. **Activar/Configurar** el provider de Email
4. **Authentication** → **URL Configuration** 
5. **Site URL**: `http://localhost:3000`
6. **Guardar** cambios

## 🚨 IMPORTANTE

- Si Email aparece como "Disabled", haz clic en él para configurarlo
- Asegúrate de que aparezca como "Enabled" o con un ✅
- No olvides configurar las URLs en "URL Configuration"

---

## 📋 CHECKLIST FINAL

- [ ] Ir a "Sign In / Providers"
- [ ] Activar/Configurar "Email"
- [ ] Ir a "URL Configuration" 
- [ ] Configurar Site URL: `http://localhost:3000`
- [ ] Guardar cambios
- [ ] Esperar 2-3 minutos
- [ ] Probar registro en la app

¿Ya entraste a "Sign In / Providers"? ¿Qué opciones ves ahí?
