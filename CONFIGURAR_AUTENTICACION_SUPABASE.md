# CONFIGURAR AUTENTICACIÓN EN SUPABASE - PASO A PASO

## ⚠️ PROBLEMA: "email_provider_disabled"

Este error significa que la autenticación por email está desactivada en tu proyecto de Supabase.

## 🔧 SOLUCIÓN: Activar Email Authentication

### PASO 1: Acceder al Dashboard de Supabase
1. Ve a: https://supabase.com/dashboard
2. Inicia sesión en tu cuenta
3. Selecciona tu proyecto "el-buho"

### PASO 2: Configurar Authentication
1. En el menú lateral, haz clic en **"Authentication"**
2. Luego haz clic en **"Settings"**
3. Busca la sección **"Auth Providers"**

### PASO 3: Habilitar Email Provider
1. Encuentra **"Email"** en la lista de proveedores
2. Asegúrate de que esté **ACTIVADO** (toggle en ON)
3. Configura las siguientes opciones:

```
✅ Enable email provider: ON
✅ Confirm email: ON (recomendado)
✅ Enable email confirmations: ON
```

### PASO 4: Configurar Email Templates (Opcional pero recomendado)
1. Ve a **Authentication > Email Templates**
2. Personaliza los templates si quieres (opcional)

### PASO 5: Verificar Site URL
1. En **Authentication > Settings**
2. Busca **"Site URL"**
3. Asegúrate de que esté configurado correctamente:
   - Para desarrollo: `http://localhost:3000` o tu URL local
   - Para producción: tu dominio real

### PASO 6: Verificar Redirect URLs
1. En la misma sección de Settings
2. Busca **"Redirect URLs"**
3. Agrega las URLs necesarias:
   - `http://localhost:3000/**` (para desarrollo)
   - Tu dominio de producción

## 🔐 CONFIGURACIÓN ADICIONAL DE SEGURIDAD

### Configurar Rate Limiting (Opcional)
- **Rate limiting**: Activado para prevenir spam
- **Max requests per hour**: 30-60 (ajusta según necesites)

### Configurar Password Policy
- **Minimum password length**: 8 caracteres
- **Require special characters**: Sí (recomendado)

## ✅ VERIFICAR CONFIGURACIÓN

Una vez configurado, deberías ver:
- ✅ Email provider: **Enabled**
- ✅ Email confirmations: **Enabled** 
- ✅ Site URL: Configurada correctamente

## 🧪 PROBAR LA CONFIGURACIÓN

1. Guarda todos los cambios en el dashboard
2. Espera 1-2 minutos para que se apliquen
3. Prueba registrar un nuevo usuario en tu app
4. Deberías poder registrarte sin el error "email_provider_disabled"

## 📧 CONFIGURACIÓN DE EMAIL (Si quieres emails personalizados)

Por defecto, Supabase usa su propio servicio de email, pero puedes configurar tu propio SMTP:

1. Ve a **Authentication > Settings**
2. Busca **"SMTP Settings"**
3. Configura tu servidor SMTP (Gmail, SendGrid, etc.)

---

## 🆘 SI AÚN TIENES PROBLEMAS

1. **Verifica que guardaste los cambios** en el dashboard
2. **Espera 2-3 minutos** para que se apliquen
3. **Recompila la app** si es necesario
4. **Verifica las credenciales** en `lib/core/supabase_config.dart`

## 📝 NOTAS IMPORTANTES

- Los cambios en Authentication pueden tomar unos minutos en aplicarse
- Asegúrate de que tu proyecto esté en el plan correcto de Supabase
- Si usas un dominio personalizado, configúralo correctamente
