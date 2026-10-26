# MP Control · MP Rental SpA

Aplicación web para controlar la recepción de equipos que vuelven de arriendo y el stock de repuestos,
registrando el dato en el momento en que ocurre. Proyecto Integrador Transversal 2026 (UCN) · Hito intermedio.

**Stack:** Python + Streamlit (app) · Supabase (PostgreSQL, Auth y Storage) · GitHub · Google Sheets / Looker Studio (indicadores).

## Estructura
| Carpeta / archivo | Contenido |
|---|---|
| `app.py`, `db_manager.py` | Aplicación Streamlit y acceso a Supabase |
| `database/mp_control_supabase_schema.sql` | Tablas, restricciones, triggers, vistas y RLS (ejecutar 1.º) |
| `database/mp_control_funciones_app.sql` | Función `registrar_recepcion` y bucket de fotos (ejecutar 2.º) |
| `database/mp_control_supabase_seed_demo.sql` | Datos de demostración (ejecutar 3.º) |
| `docs/` | Informe, diccionario maestro, BPMN, bitácora |
| `design/figma.md` | Enlace al prototipo |

## Puesta en marcha
1. Crear un proyecto en Supabase y ejecutar los tres `.sql` de `database/` en el SQL Editor, en el orden indicado.
2. En *Authentication → Users* crear los usuarios y enlazar cada `auth_uid` en la tabla `usuarios`
   (el correo debe coincidir con `usuario@mprental.cl`, formato que usa el login).
3. Copiar `.streamlit/secrets.toml.example` a `.streamlit/secrets.toml` y completar URL y anon key.
4. `pip install -r requirements.txt` y `streamlit run app.py`.

## Funcionalidades del Hito intermedio
- Login con Supabase Auth y perfiles Jefe / Operario (RLS en la base de datos).
- Inicio con métricas reales y alertas (equipos en patio sin registro, en revisión).
- Recepción de equipos: foto obligatoria, estado físico por lista cerrada, horómetro; en una transacción guarda la
  recepción, actualiza el equipo (a *revisión* si el estado indica daño), cierra el contrato vigente y deja bitácora.

## Pendiente para el Hito final
Salidas y contratos, mantenciones, flota, decisiones pendientes, uso de repuestos y compras; carga desde Google Sheets;
dashboard en Looker Studio; manual de usuario; traspaso de cuentas a la empresa.

> Nunca subir claves ni `secrets.toml` al repositorio.
