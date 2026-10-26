-- =====================================================================
-- MP CONTROL · Funciones que usa la app Streamlit (ejecutar DESPUÉS del schema)
-- 1) registrar_recepcion: hace en UNA sola transacción lo que el BPMN TO-BE define:
--    guarda la recepción, actualiza el equipo y cierra el contrato vigente.
-- 2) Bucket privado de Storage para la foto obligatoria de la recepción.
-- security invoker => se respetan las políticas RLS del usuario que llama.
-- =====================================================================
create or replace function public.registrar_recepcion(
  p_codigo_equipo text,
  p_estado_fisico text,
  p_horometro integer,
  p_observaciones text default null,
  p_foto_url text default null
) returns jsonb
language plpgsql security invoker set search_path = public as $$
declare
  v_usuario  text := public.mp_usuario();
  v_eq       equipos%rowtype;
  v_rev      text;
  v_contrato text;
  v_llegada  timestamptz;
  v_ubic     text;
  v_id       integer;
begin
  if v_usuario is null then
    raise exception 'Usuario sin perfil activo';
  end if;
  if p_foto_url is null or length(trim(p_foto_url)) = 0 then
    raise exception 'La foto de la recepción es obligatoria';
  end if;

  select * into v_eq from equipos where codigo_equipo = p_codigo_equipo for update;
  if not found then
    raise exception 'El equipo % no existe', p_codigo_equipo;
  end if;
  if v_eq.ubicacion not in ('arriendo', 'patio-sin') then
    raise exception 'El equipo % no está pendiente de recepción (ubicación actual: %)', p_codigo_equipo, v_eq.ubicacion;
  end if;

  select requiere_revision into v_rev from cat_estados_fisicos where estado_fisico = p_estado_fisico;
  if not found then
    raise exception 'Estado físico no válido: %', p_estado_fisico;
  end if;

  select num_contrato into v_contrato from contratos
   where codigo_equipo = p_codigo_equipo and estado = 'Vigente';

  -- Si el equipo estaba "en patio sin registro", la llegada real es anterior al registro
  v_llegada := coalesce(v_eq.patio_sin_desde, now());
  v_ubic    := case when v_rev = 'Sí' then 'revision' else 'patio-reg' end;

  insert into recepciones (codigo_equipo, num_contrato, fecha_llegada_fisica, fecha_registro, estado_fisico,
                           horometro_h, observaciones, foto_url, registrado_por,
                           ubicacion_previa, patio_sin_desde_previo, horometro_previo_h)
  values (p_codigo_equipo, v_contrato, v_llegada, now(), p_estado_fisico,
          p_horometro, nullif(trim(p_observaciones), ''), p_foto_url, v_usuario,
          v_eq.ubicacion, v_eq.patio_sin_desde, v_eq.horometro_h)
  returning id_recepcion into v_id;

  update equipos
     set ubicacion = v_ubic,
         horometro_h = p_horometro,
         patio_sin_desde = null,
         motivo_revision = case when v_rev = 'Sí'
                                then p_estado_fisico || coalesce(': ' || nullif(trim(p_observaciones), ''), '')
                                else null end
   where codigo_equipo = p_codigo_equipo;

  if v_contrato is not null then
    update contratos
       set estado = 'Cerrado', fecha_llegada_real = v_llegada, fecha_cierre = now()
     where num_contrato = v_contrato;
  end if;

  insert into bitacora (fecha_hora, usuario, modulo, accion, detalle)
  values (now(), v_usuario, 'Recepción', 'Registrar recepción',
          'Equipo ' || p_codigo_equipo || ' · ' || p_estado_fisico || ' · ' || p_horometro || ' h · ' || v_ubic);

  return jsonb_build_object('id_recepcion', v_id, 'ubicacion', v_ubic,
                            'contrato_cerrado', v_contrato, 'requiere_revision', v_rev = 'Sí');
end $$;

grant execute on function public.registrar_recepcion(text, text, integer, text, text) to authenticated;

-- Bucket privado para las fotos (la app guarda la ruta en recepciones.foto_url)
insert into storage.buckets (id, name, public) values ('recepciones', 'recepciones', false)
on conflict (id) do nothing;

drop policy if exists recepciones_fotos_ins on storage.objects;
drop policy if exists recepciones_fotos_sel on storage.objects;
create policy recepciones_fotos_ins on storage.objects for insert to authenticated
  with check (bucket_id = 'recepciones' and public.mp_rol() is not null);
create policy recepciones_fotos_sel on storage.objects for select to authenticated
  using (bucket_id = 'recepciones' and public.mp_rol() is not null);
