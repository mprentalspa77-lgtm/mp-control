import datetime
import streamlit as st
from supabase import create_client, Client


def get_supabase_client() -> Client:
    """Un cliente POR SESIÓN de navegador.
    (Con st.cache_resource el cliente se compartía entre todos los usuarios y la sesión
    de quien ingresó último pisaba a las demás.)"""
    if "sb_client" not in st.session_state:
        st.session_state["sb_client"] = create_client(
            st.secrets["SUPABASE_URL"], st.secrets["SUPABASE_KEY"]
        )
    return st.session_state["sb_client"]


def insertar_datos(tabla: str, datos: dict):
    """Inserta un registro en la tabla especificada."""
    return get_supabase_client().table(tabla).insert(datos).execute()


def actualizar_datos(tabla: str, datos: dict, columna_filtro: str, valor_filtro):
    """Actualiza registros en la tabla especificada."""
    return get_supabase_client().table(tabla).update(datos).eq(columna_filtro, valor_filtro).execute()


def consultar_datos(tabla: str, columnas: str = "*", filtros: dict = None):
    """Consulta datos de una tabla con filtros opcionales (igualdad)."""
    query = get_supabase_client().table(tabla).select(columnas)
    if filtros:
        for col, val in filtros.items():
            query = query.eq(col, val)
    return query.execute().data


def contar_datos(tabla: str, filtros: dict = None) -> int:
    """Cuenta filas sin traer los datos (count exacto de PostgREST)."""
    query = get_supabase_client().table(tabla).select("*", count="exact").limit(1)
    if filtros:
        for col, val in filtros.items():
            query = query.eq(col, val)
    return query.execute().count or 0


def consultar_en(tabla: str, columnas: str, columna: str, valores: list):
    """Consulta filas cuya columna esté dentro de una lista de valores."""
    return get_supabase_client().table(tabla).select(columnas).in_(columna, valores).execute().data


def subir_foto_recepcion(codigo_equipo: str, archivo) -> str:
    """Sube la foto al bucket privado 'recepciones' y devuelve la ruta (se guarda en foto_url)."""
    ext = archivo.name.rsplit(".", 1)[-1].lower()
    ruta = f"{codigo_equipo}/{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.{ext}"
    get_supabase_client().storage.from_("recepciones").upload(
        ruta, archivo.getvalue(), {"content-type": archivo.type or "image/jpeg"}
    )
    return ruta


def registrar_recepcion(codigo_equipo, estado_fisico, horometro, observaciones, foto_url) -> dict:
    """Llama a la función SQL registrar_recepcion (una sola transacción en la base de datos)."""
    res = get_supabase_client().rpc("registrar_recepcion", {
        "p_codigo_equipo": codigo_equipo,
        "p_estado_fisico": estado_fisico,
        "p_horometro": int(horometro),
        "p_observaciones": observaciones or None,
        "p_foto_url": foto_url,
    }).execute()
    return res.data
