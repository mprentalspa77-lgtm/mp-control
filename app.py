import streamlit as st
import datetime
from db_manager import (get_supabase_client, consultar_datos, contar_datos, consultar_en,
                        subir_foto_recepcion, registrar_recepcion)

# Configuración de página
st.set_page_config(page_title="MP Control · MP Rental SpA", layout="wide", page_icon="🔧")

# CSS PERSONALIZADO - Esto hace que se parezca al Figma
st.markdown("""
<style>
    /* Fondo general oscuro */
    .stApp {
        background-color: #f5f5f5;
    }
    
    /* Header personalizado */
    .main-header {
        background-color: #1e293b;
        color: white;
        padding: 1rem 2rem;
        border-radius: 8px;
        margin-bottom: 2rem;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    .main-header h1 {
        color: white;
        margin: 0;
        font-size: 1.5rem;
    }
    
    .main-header p {
        color: #94a3b8;
        margin: 0.2rem 0 0 0;
        font-size: 0.9rem;
    }
    
    /* Tarjetas de métricas */
    .metric-card {
        background-color: white;
        padding: 1.5rem;
        border-radius: 12px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        margin-bottom: 1rem;
        border-left: 4px solid #ef4444;
    }
    
    .metric-card h3 {
        margin: 0 0 0.5rem 0;
        color: #1e293b;
        font-size: 0.9rem;
        text-transform: uppercase;
    }
    
    .metric-card .value {
        font-size: 2rem;
        font-weight: bold;
        color: #ef4444;
        margin: 0;
    }
    
    /* Login card */
    .login-container {
        max-width: 450px;
        margin: 3rem auto;
        background-color: white;
        padding: 3rem;
        border-radius: 16px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    
    .login-title {
        text-align: center;
        color: #1e293b;
        margin-bottom: 0.5rem;
        font-size: 1.8rem;
    }
    
    .login-subtitle {
        text-align: center;
        color: #64748b;
        margin-bottom: 2rem;
        font-size: 0.95rem;
    }
    
    /* Botones personalizados */
    .stButton>button {
        background-color: #ef4444;
        color: white;
        border: none;
        padding: 0.6rem 2rem;
        border-radius: 8px;
        font-weight: 600;
        font-size: 1rem;
        transition: all 0.3s;
    }
    
    .stButton>button:hover {
        background-color: #dc2626;
        transform: translateY(-2px);
        box-shadow: 0 4px 6px rgba(239, 68, 68, 0.3);
    }
    
    /* Sidebar */
    .css-1d391kg {
        background-color: #1e293b;
    }
    
    .css-1d391kg .stMarkdown {
        color: white;
    }
    
    /* Alertas */
    .alert-box {
        background-color: #fef2f2;
        border-left: 4px solid #ef4444;
        padding: 1rem;
        border-radius: 8px;
        margin: 1rem 0;
    }
    
    .alert-box.success {
        background-color: #f0fdf4;
        border-left-color: #22c55e;
    }
    
    .alert-box.info {
        background-color: #eff6ff;
        border-left-color: #3b82f6;
    }
    
    /* Formulario */
    .stTextInput>div>div>input, .stSelectbox>div>div>select, .stTextArea>div>div>textarea {
        border-radius: 8px;
        border: 1px solid #e2e8f0;
    }
    
    /* Ocultar elementos de Streamlit */
    #MainMenu {visibility: hidden;}
    footer {visibility: hidden;}
    
    /* Badge de usuario */
    .user-badge {
        display: inline-block;
        background-color: #10b981;
        color: white;
        padding: 0.3rem 0.8rem;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
        margin-left: 0.5rem;
    }
</style>
""", unsafe_allow_html=True)

# Inicializar session state
if 'logged_in' not in st.session_state:
    st.session_state.logged_in = False
    st.session_state.user = None
    st.session_state.role = None
    st.session_state.user_name = None
    st.session_state.user_id = None

# ==================== PÁGINA DE LOGIN ====================
if not st.session_state.logged_in:
    # Header de la página de login
    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.markdown("""
        <div style="text-align: center; margin-bottom: 1rem;">
            <h1 style="color: #1e293b; margin: 0;">MP CONTROL</h1>
            <p style="color: #64748b; margin: 0.5rem 0;">MP RENTAL SPA</p>
        </div>
        """, unsafe_allow_html=True)
    
    # Card de login
    st.markdown('<div class="login-container">', unsafe_allow_html=True)
    
    st.markdown('<h2 class="login-title">Acceso a Operaciones</h2>', unsafe_allow_html=True)
    st.markdown('<p class="login-subtitle">Recepción de equipos y control de repuestos en el instante en que ocurren</p>', unsafe_allow_html=True)
    
    with st.form("login_form", clear_on_submit=False):
        st.markdown('<div style="margin-bottom: 1.5rem;">', unsafe_allow_html=True)
        email_input = st.text_input("Usuario", placeholder="juan o operario")
        st.markdown('</div>', unsafe_allow_html=True)
        
        st.markdown('<div style="margin-bottom: 1.5rem;">', unsafe_allow_html=True)
        pass_input = st.text_input("Contraseña", type="password", placeholder="••••••••")
        st.markdown('</div>', unsafe_allow_html=True)
        
        col_a, col_b, col_c = st.columns([1, 1.5, 1])
        with col_b:
            submit_login = st.form_submit_button("Ingresar", use_container_width=True)
    
    st.markdown('</div>', unsafe_allow_html=True)
    
    # Info de demo
    st.markdown("""
    <div style="text-align: center; margin-top: 2rem; color: #64748b; font-size: 0.9rem;">
        <p>🔐 <strong>Demo:</strong> juan (jefe) / operario</p>
        <p style="font-size: 0.85rem;">Contraseña: mp2026</p>
    </div>
    """, unsafe_allow_html=True)
    
    # Procesar login
    if submit_login:
        sb = get_supabase_client()
        try:
            auth_response = sb.auth.sign_in_with_password({
                "email": f"{email_input}@mprental.cl" if "@" not in email_input else email_input,
                "password": pass_input
            })
            
            if auth_response.user:
                # Obtener datos del usuario desde la tabla usuarios
                usuarios = consultar_datos("usuarios", "usuario, rol", {"auth_uid": auth_response.user.id})
                
                if usuarios:
                    st.session_state.logged_in = True
                    st.session_state.user = email_input
                    st.session_state.user_id = auth_response.user.id
                    st.session_state.role = usuarios[0]['rol']
                    st.session_state.user_name = usuarios[0]['usuario']
                    st.rerun()
                else:
                    st.error("Usuario no encontrado en la base de datos.")
            else:
                st.error("Usuario o contraseña incorrectos.")
        except Exception as e:
            st.error(f"Error de conexión: {str(e)}")

# ==================== APLICACIÓN PRINCIPAL ====================
else:
    # Sidebar
    with st.sidebar:
        # Header del sidebar
        st.markdown(f"""
        <div style="background-color: #0f172a; padding: 1.5rem; border-radius: 12px; margin-bottom: 1rem;">
            <h3 style="color: white; margin: 0 0 0.5rem 0;"> {st.session_state.user_name}</h3>
            <p style="color: #94a3b8; margin: 0; font-size: 0.9rem;">{st.session_state.role}</p>
        </div>
        """, unsafe_allow_html=True)
        
        # Navegación
        st.markdown("### Navegación")
        page = st.radio(
            "",
            ["🏠 Inicio", "📥 Recepción de Equipos", "📊 Salidas y Contratos", "🔧 Mantenciones", "📦 Flota de Equipos", "📋 Decisiones Pendientes"],
            label_visibility="collapsed"
        )
        
        st.markdown("---")
        
        if st.button("🚪 Cerrar Sesión", use_container_width=True):
            sb = get_supabase_client()
            sb.auth.sign_out()
            st.session_state.clear()
            st.rerun()
    
    # ==================== PÁGINA: INICIO ====================
    if "🏠 Inicio" in page:
        # Header
        st.markdown(f"""
        <div class="main-header">
            <h1>👋 Bienvenido/a, {st.session_state.user_name}</h1>
            <p>MP Rental SpA · {datetime.datetime.now().strftime('%d de %B de %Y')} · {datetime.datetime.now().strftime('%H:%M')}</p>
        </div>
        """, unsafe_allow_html=True)
        
        # Métricas principales
        col1, col2, col3, col4 = st.columns(4)
        
        # Obtener datos de la base de datos
        n_total = contar_datos("equipos")
        n_arriendo = contar_datos("equipos", {"ubicacion": "arriendo"})
        n_patio = contar_datos("equipos", {"ubicacion": "patio-reg"})
        n_revision = contar_datos("equipos", {"ubicacion": "revision"})
        n_sin_registro = contar_datos("equipos", {"ubicacion": "patio-sin"})
        n_alertas = n_revision + n_sin_registro
        
        with col1:
            st.markdown(f"""
            <div class="metric-card">
                <h3>🔧 Total Equipos</h3>
                <p class="value">{n_total}</p>
            </div>
            """, unsafe_allow_html=True)
        
        with col2:
            st.markdown(f"""
            <div class="metric-card" style="border-left-color: #3b82f6;">
                <h3>📤 En Arriendo</h3>
                <p class="value" style="color: #3b82f6;">{n_arriendo}</p>
            </div>
            """, unsafe_allow_html=True)
        
        with col3:
            st.markdown(f"""
            <div class="metric-card" style="border-left-color: #22c55e;">
                <h3>✅ En Patio</h3>
                <p class="value" style="color: #22c55e;">{n_patio}</p>
            </div>
            """, unsafe_allow_html=True)
        
        with col4:
            st.markdown(f"""
            <div class="metric-card" style="border-left-color: #f59e0b;">
                <h3>⚠️ Alertas</h3>
                <p class="value" style="color: #f59e0b;">{n_alertas}</p>
            </div>
            """, unsafe_allow_html=True)
        
        # Alertas y decisiones pendientes
        st.markdown("### 🔔 Alertas y Decisiones Pendientes")
        
        if n_sin_registro:
            st.warning(f"{n_sin_registro} equipo(s) están en el patio SIN registro de recepción.")
        if n_revision:
            st.error(f"{n_revision} equipo(s) en revisión esperan decisión del Jefe.")

        equipos_devueltos = consultar_datos("equipos", "codigo_equipo, nombre, ubicacion", {"ubicacion": "patio-reg"})
        
        if equipos_devueltos:
            st.markdown(f"""
            <div class="alert-box info">
                <strong>️ Información:</strong> Hay {len(equipos_devueltos)} equipo(s) en patio. 
                El sistema está conectado correctamente a la base de datos.
            </div>
            """, unsafe_allow_html=True)
        else:
            st.markdown(f"""
            <div class="alert-box success">
                <strong>✅ Todo en orden:</strong> La base de datos está conectada correctamente.
            </div>
            """, unsafe_allow_html=True)
        
        # Accesos rápidos
        st.markdown("### ⚡ Accesos Rápidos")
        col_a, col_b = st.columns(2)
        with col_a:
            if st.button("📥 Ir a Recepción de Equipos", use_container_width=True):
                st.info("Use el menú lateral: Recepción de Equipos.")
        with col_b:
            if st.button(" Ver Flota Completa", use_container_width=True):
                st.info("Esta funcionalidad estará disponible próximamente")
    
    # ==================== PÁGINA: RECEPCIÓN DE EQUIPOS ====================
    elif "📥 Recepción de Equipos" in page:
        # Header
        st.markdown(f"""
        <div class="main-header">
            <h1>📥 Recepción de Equipos (Taller)</h1>
            <p>Registre el ingreso de un equipo que vuelve de arriendo</p>
        </div>
        """, unsafe_allow_html=True)
        
        # Obtener equipos en arriendo
        equipos_arriendo = consultar_en("equipos", "codigo_equipo, nombre, ubicacion", "ubicacion", ["arriendo", "patio-sin"])
        ubic_por_codigo = {e["codigo_equipo"]: e["ubicacion"] for e in equipos_arriendo}
        estados_fisicos = consultar_datos("cat_estados_fisicos", "estado_fisico")
        
        if not equipos_arriendo:
            st.markdown("""
            <div class="alert-box">
                <strong>⚠️ Sin equipos disponibles</strong>
                <p>No hay equipos en arriendo ni en patio sin registro pendientes de recepción.</p>
            </div>
            """, unsafe_allow_html=True)
        else:
            # Crear diccionario de opciones
            opciones_equipos = {f"{e['codigo_equipo']} - {e['nombre']}": e['codigo_equipo'] for e in equipos_arriendo}
            opciones_estados = [e['estado_fisico'] for e in estados_fisicos] if estados_fisicos else ["Bueno", "Regular", "Malo"]
            
            # Formulario de recepción
            st.markdown("### Datos del Equipo")
            
            with st.form("form_recepcion", clear_on_submit=False):
                col1, col2 = st.columns([2, 1])
                with col1:
                    seleccion = st.selectbox(
                        "Seleccione el equipo que llega:",
                        list(opciones_equipos.keys()),
                        label_visibility="collapsed"
                    )
                    codigo_equipo = opciones_equipos[seleccion]
                
                with col2:
                    st.markdown('<div style="padding: 0.5rem; background-color: #f0f9ff; border-radius: 8px; text-align: center;">', unsafe_allow_html=True)
                    st.markdown("**📍 Estado:** Pendiente de recepción")
                    st.markdown('</div>', unsafe_allow_html=True)
                
                st.markdown("---")
                
                col_a, col_b, col_c = st.columns(3)
                with col_a:
                    horometro = st.number_input(
                        " Lectura de Horómetro (h)",
                        min_value=0,
                        step=1,
                        help="Ingrese la lectura actual del horómetro del equipo"
                    )
                
                with col_b:
                    estado_fis = st.selectbox(
                        "🔍 Estado Físico",
                        opciones_estados,
                        help="Seleccione el estado físico del equipo al llegar"
                    )
                
                with col_c:
                    st.markdown('<div style="padding: 0.5rem; background-color: #f0fdf4; border-radius: 8px; text-align: center; margin-top: 2rem;">', unsafe_allow_html=True)
                    st.markdown("**✅ Listo para registrar**")
                    st.markdown('</div>', unsafe_allow_html=True)
                
                obs = st.text_area(
                    "📝 Observaciones del mecánico (opcional)",
                    height=100,
                    placeholder="Ej: Golpe en tapa lateral, desgaste normal, etc."
                )
                
                # Foto del equipo (simulado - Streamlit no permite upload en forms)
                st.markdown("📸 Foto del equipo (obligatoria)")
                uploaded_file = st.file_uploader("Seleccione archivo", type=['jpg', 'jpeg', 'png'], label_visibility="collapsed")
                
                st.markdown("---")
                
                col_x, col_y, col_z = st.columns([1, 2, 1])
                with col_y:
                    btn_guardar = st.form_submit_button(
                        "✅ Confirmar Recepción",
                        type="primary",
                        use_container_width=True
                    )
                
                if btn_guardar and uploaded_file is None:
                    st.error("La foto del equipo es obligatoria.")
                elif btn_guardar:
                    try:
                        # 1) Foto obligatoria -> Storage; 2) una sola transacción en la BD
                        foto_ruta = subir_foto_recepcion(codigo_equipo, uploaded_file)
                        resultado = registrar_recepcion(codigo_equipo, estado_fis, horometro, obs, foto_ruta)
                        ubic_final = "En revisión (decide el Jefe)" if resultado["requiere_revision"] else "Disponible en patio"
                        contrato_txt = f"Contrato {resultado['contrato_cerrado']} cerrado." if resultado.get("contrato_cerrado") else "Sin contrato vigente asociado."
                        
                        st.markdown(f"""
                        <div class="alert-box success">
                            <strong>✅ Recepción exitosa</strong>
                            <p>El equipo <strong>{codigo_equipo}</strong> ha sido registrado correctamente.</p>
                            <p>Ubicación actualizada a: <strong>{ubic_final}</strong> · {contrato_txt}</p>
                            <p>🔢 Horómetro: <strong>{horometro} h</strong></p>
                        </div>
                        """, unsafe_allow_html=True)
                        
                        st.balloons()
                        
                    except Exception as e:
                        st.markdown(f"""
                        <div class="alert-box">
                            <strong> Error al guardar</strong>
                            <p>{str(e)}</p>
                        </div>
                        """, unsafe_allow_html=True)
    
    # ==================== OTRAS PÁGINAS (Placeholder) ====================
    else:
        st.markdown(f"""
        <div class="main-header">
            <h1>{page}</h1>
            <p>Esta funcionalidad estará disponible próximamente</p>
        </div>
        """, unsafe_allow_html=True)
        
        st.info("Esta sección está en desarrollo. Por ahora, el sistema cuenta con:\n- ✅ Login funcional con Supabase Auth\n- ✅ Panel de inicio con métricas\n- ✅ Recepción de equipos completa")