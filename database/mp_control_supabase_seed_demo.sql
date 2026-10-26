-- =====================================================================

-- MP CONTROL · Datos de DEMOSTRACIÓN (los mismos del Excel / prototipo v7, anclados al 20-10-2026).

-- Ejecutar DESPUÉS de mp_control_supabase_schema.sql. No cargar en producción.

-- Los usuarios quedan sin auth_uid: se enlazan al crearlos en Supabase Authentication.

-- =====================================================================

-- usuarios (3 filas)
insert into usuarios (usuario, nombre, correo, rol, activo, fecha_baja) values
  ('juan', 'Juan González', 'juan@mprental.cl', 'Jefe', 'Sí', null),
  ('operario', 'Silvio V.', 'silvio@mprental.cl', 'Operario', 'Sí', null),
  ('carlos.soto', 'Carlos Soto', 'carlos@mprental.cl', 'Operario', 'No', '2026-10-16 10:00:00 America/Santiago');

-- clientes (5 filas)
insert into clientes (id_cliente, nombre, rut, contacto, telefono, correo, activo) values
  ('CLI-001', 'Constructora Andes', null, null, null, null, 'Sí'),
  ('CLI-002', 'Vialidad Ovalle', null, null, null, null, 'Sí'),
  ('CLI-003', 'Minera Los Cóndores', null, null, null, null, 'Sí'),
  ('CLI-004', 'Municipalidad La Serena', null, null, null, null, 'Sí'),
  ('CLI-005', 'Inmobiliaria Norte', null, null, null, null, 'Sí');

-- equipos (12 filas)
insert into equipos (codigo_equipo, nombre, id_categoria, ubicacion, patio_sin_desde, tarifa_diaria_clp, horometro_h, ultimo_servicio_h, tiene_qr, motivo_revision, activo) values
  ('GEN-021', 'Generador diésel 60 kVA', 'GEN', 'patio-reg', null, null, 3412, 3250, 'Sí', null, 'Sí'),
  ('GEN-014', 'Generador diésel 100 kVA', 'GEN', 'arriendo', null, null, 5120, 5100, 'Sí', null, 'Sí'),
  ('GEN-009', 'Generador diésel 30 kVA', 'GEN', 'patio-sin', '2026-10-14 05:12:00 America/Santiago', 45000, 2890, 2872, 'No', null, 'Sí'),
  ('TIL-004', 'Torre de iluminación LED', 'TIL', 'patio-sin', '2026-10-18 00:24:00 America/Santiago', 28000, 1604, 1635, 'Sí', null, 'Sí'),
  ('TIL-007', 'Torre de iluminación haluro metálico', 'TIL', 'arriendo', null, null, 2210, 2170, 'No', null, 'Sí'),
  ('PLC-012', 'Placa compactadora', 'PLC', 'patio-sin', '2026-10-20 09:35:00 America/Santiago', 18000, 980, 850, 'Sí', null, 'Sí'),
  ('PLC-003', 'Placa compactadora', 'PLC', 'desm', null, null, 1450, 1300, 'Sí', null, 'Sí'),
  ('RDL-002', 'Rodillo compactador', 'RDL', 'taller', null, null, 4300, 4100, 'Sí', null, 'Sí'),
  ('VIB-005', 'Vibrador de hormigón', 'VIB', 'arriendo', null, null, 760, 742, 'No', null, 'Sí'),
  ('COR-003', 'Cortadora de pavimento', 'COR', 'arriendo', null, null, 1120, 1136, 'No', null, 'Sí'),
  ('ALI-006', 'Alisadora de hormigón', 'ALI', 'patio-reg', null, null, 690, 490, 'Sí', null, 'Sí'),
  ('MRT-001', 'Martillo demoledor', 'MRT', 'arriendo', null, null, 540, 650, 'No', null, 'Sí');

-- repuestos (18 filas)
insert into repuestos (id_repuesto, nombre, tipo, unidad, controla_stock, stock_actual, stock_minimo, precio_unitario_clp, canibalizable, activo) values
  ('REP-001', 'Filtro de combustible', 'Consumible', 'un', 'Sí', 2, 6, 12500, 'No', 'Sí'),
  ('REP-002', 'Filtro de aceite', 'Consumible', 'un', 'Sí', 5, 6, 9800, 'No', 'Sí'),
  ('REP-003', 'Filtro de aire', 'Consumible', 'un', 'Sí', 11, 5, 14200, 'No', 'Sí'),
  ('REP-004', 'Correa', 'Consumible', 'un', 'Sí', 14, 8, 18900, 'No', 'Sí'),
  ('REP-005', 'Aceite 15W40 (L)', 'Consumible', 'L', 'Sí', 9, 8, 5200, 'No', 'Sí'),
  ('REP-006', 'Batería 12V', 'Consumible', 'un', 'Sí', 3, 2, 68000, 'Sí', 'Sí'),
  ('REP-007', 'Motor de partida', 'Pieza', 'un', 'No', null, null, 85000, 'Sí', 'Sí'),
  ('REP-008', 'Alternador', 'Pieza', 'un', 'No', null, null, 120000, 'Sí', 'Sí'),
  ('REP-009', 'Regulador de voltaje (AVR)', 'Pieza', 'un', 'No', null, null, 45000, 'Sí', 'Sí'),
  ('REP-010', 'Bomba de combustible', 'Pieza', 'un', 'No', null, null, 68000, 'Sí', 'Sí'),
  ('REP-011', 'Inyector', 'Pieza', 'un', 'No', null, null, 38000, 'Sí', 'Sí'),
  ('REP-012', 'Panel de control', 'Pieza', 'un', 'No', null, null, 95000, 'Sí', 'Sí'),
  ('REP-013', 'Radiador', 'Pieza', 'un', 'No', null, null, 110000, 'Sí', 'Sí'),
  ('REP-014', 'Carburador', 'Pieza', 'un', 'No', null, null, 42000, 'Sí', 'Sí'),
  ('REP-015', 'Luminaria LED', 'Pieza', 'un', 'No', null, null, 36000, 'Sí', 'Sí'),
  ('REP-016', 'Balasto', 'Pieza', 'un', 'No', null, null, 28000, 'Sí', 'Sí'),
  ('REP-017', 'Mástil telescópico', 'Pieza', 'un', 'No', null, null, 150000, 'Sí', 'Sí'),
  ('REP-018', 'Embrague centrífugo', 'Pieza', 'un', 'No', null, null, 52000, 'Sí', 'Sí');

-- contratos (9 filas)
insert into contratos (num_contrato, codigo_equipo, id_cliente, destino, fecha_salida, fecha_termino_original, estado, fecha_llegada_real, fecha_cierre, registrado_por, motivo_anulacion, anulado_por, fecha_anulacion) values
  ('CT-090', 'GEN-021', 'CLI-001', 'Obra Edificio Costanera, La Serena', '2026-10-06 10:00:00 America/Santiago', '2026-10-20 02:48:00 America/Santiago', 'Cerrado', '2026-10-20 04:40:00 America/Santiago', '2026-10-20 05:00:00 America/Santiago', 'operario', null, null, null),
  ('CT-091', 'GEN-014', 'CLI-001', 'Obra Edificio Costanera, La Serena', '2026-09-30 10:00:00 America/Santiago', '2026-10-30 10:00:00 America/Santiago', 'Vigente', null, null, 'juan', null, null, null),
  ('CT-092', 'GEN-009', 'CLI-002', 'Ruta D-43, tramo Ovalle', '2026-09-13 22:00:00 America/Santiago', '2026-10-13 22:00:00 America/Santiago', 'Vigente', null, null, 'operario', null, null, null),
  ('CT-093', 'TIL-004', 'CLI-003', 'Faena Los Cóndores, Illapel', '2026-09-17 22:00:00 America/Santiago', '2026-10-17 22:00:00 America/Santiago', 'Vigente', null, null, 'operario', null, null, null),
  ('CT-094', 'TIL-007', 'CLI-004', 'Plaza de Armas, evento de fiestas', '2026-10-10 10:00:00 America/Santiago', '2026-11-09 10:00:00 America/Santiago', 'Vigente', null, null, 'juan', null, null, null),
  ('CT-095', 'PLC-012', 'CLI-001', 'Obra Edificio Costanera, La Serena', '2026-10-05 10:00:00 America/Santiago', '2026-10-20 09:58:00 America/Santiago', 'Vigente', null, null, 'operario', null, null, null),
  ('CT-096', 'VIB-005', 'CLI-005', 'Condominio Las Brisas, Coquimbo', '2026-10-11 10:00:00 America/Santiago', '2026-10-25 10:00:00 America/Santiago', 'Vigente', null, null, 'juan', null, null, null),
  ('CT-097', 'COR-003', 'CLI-002', 'Ruta D-43, tramo Ovalle', '2026-09-23 10:00:00 America/Santiago', '2026-10-23 10:00:00 America/Santiago', 'Vigente', null, null, 'operario', null, null, null),
  ('CT-098', 'MRT-001', 'CLI-001', 'Obra Edificio Costanera, La Serena', '2026-09-19 05:12:00 America/Santiago', '2026-10-19 05:12:00 America/Santiago', 'Vigente', null, null, 'operario', null, null, null);

-- recepciones (1 filas)
insert into recepciones (id_recepcion, codigo_equipo, num_contrato, fecha_llegada_fisica, fecha_registro, estado_fisico, horometro_h, observaciones, foto_url, registrado_por, ubicacion_previa, patio_sin_desde_previo, horometro_previo_h) values
  (1, 'GEN-021', 'CT-090', '2026-10-20 04:40:00 America/Santiago', '2026-10-20 05:00:00 America/Santiago', 'Bueno', 3412, null, null, 'operario', 'arriendo', null, null);

-- ordenes_trabajo (10 filas)
insert into ordenes_trabajo (ot, codigo_equipo, tipo_trabajo, id_repuesto, cantidad_plan, fecha_programada, estado, fecha_creacion, fecha_inicio, fecha_termino, creada_por, iniciada_por, completada_por) values
  ('OT-229', 'RDL-002', 'Cambio de aceite', 'REP-005', 3, '2026-10-19 10:00:00 America/Santiago', 'En curso', '2026-10-18 10:00:00 America/Santiago', '2026-10-20 07:00:00 America/Santiago', null, 'operario', 'operario', null),
  ('OT-230', 'GEN-021', 'Cambio de aceite', 'REP-005', 2, '2026-10-19 10:00:00 America/Santiago', 'Completada', '2026-10-18 10:00:00 America/Santiago', '2026-10-19 04:00:00 America/Santiago', '2026-10-19 08:00:00 America/Santiago', 'operario', 'operario', 'operario'),
  ('OT-231', 'GEN-021', 'Cambio de filtros de combustible', 'REP-001', 4, '2026-10-24 10:00:00 America/Santiago', 'Programada', '2026-10-19 10:00:00 America/Santiago', null, null, 'operario', null, null),
  ('OT-232', 'ALI-006', 'Cambio de aceite', 'REP-005', 2, '2026-10-27 10:00:00 America/Santiago', 'Programada', '2026-10-19 10:00:00 America/Santiago', null, null, 'operario', null, null),
  ('OT-233', 'PLC-012', 'Cambio de correa', 'REP-004', 1, '2026-10-28 10:00:00 America/Santiago', 'Programada', '2026-10-20 09:00:00 America/Santiago', null, null, 'operario', null, null),
  ('OT-224', 'GEN-014', 'Mantención preventiva (240 h)', 'REP-005', 3, '2026-09-14 10:00:00 America/Santiago', 'Completada', '2026-09-12 10:00:00 America/Santiago', '2026-09-14 10:00:00 America/Santiago', '2026-09-15 10:00:00 America/Santiago', 'operario', 'operario', 'operario'),
  ('OT-225', 'TIL-007', 'Cambio de correa', 'REP-004', 1, '2026-09-16 10:00:00 America/Santiago', 'Completada', '2026-09-15 10:00:00 America/Santiago', '2026-09-16 10:00:00 America/Santiago', '2026-09-17 10:00:00 America/Santiago', 'operario', 'operario', 'operario'),
  ('OT-226', 'VIB-005', 'Cambio de batería', 'REP-006', 1, '2026-09-18 10:00:00 America/Santiago', 'Completada', '2026-09-17 10:00:00 America/Santiago', '2026-09-18 10:00:00 America/Santiago', '2026-09-19 10:00:00 America/Santiago', 'operario', 'operario', 'operario'),
  ('OT-227', 'ALI-006', 'Mantención preventiva (240 h)', 'REP-005', 2, '2026-09-21 10:00:00 America/Santiago', 'Completada', '2026-09-20 10:00:00 America/Santiago', '2026-09-21 10:00:00 America/Santiago', '2026-09-22 10:00:00 America/Santiago', 'operario', 'operario', 'operario'),
  ('OT-228', 'TIL-004', 'Mantención preventiva (240 h)', 'REP-002', 1, '2026-10-10 10:00:00 America/Santiago', 'Completada', '2026-10-09 10:00:00 America/Santiago', '2026-10-10 10:00:00 America/Santiago', '2026-10-11 10:00:00 America/Santiago', 'operario', 'operario', 'operario');

-- uso_repuestos (12 filas)
insert into uso_repuestos (id_uso, fecha_hora, id_repuesto, cantidad, precio_unitario_clp, codigo_equipo, ot, justificacion, registrado_por) values
  (1, '2026-10-19 07:00:00 America/Santiago', 'REP-005', 2, 5200, 'GEN-021', 'OT-230', null, 'operario'),
  (2, '2026-10-19 07:30:00 America/Santiago', 'REP-002', 3, 9800, 'GEN-021', 'OT-230', null, 'operario'),
  (3, '2026-10-19 07:36:00 America/Santiago', 'REP-001', 2, 12500, 'GEN-021', 'OT-230', null, 'operario'),
  (4, '2026-09-14 22:00:00 America/Santiago', 'REP-005', 3, 5200, 'GEN-014', 'OT-224', null, 'operario'),
  (5, '2026-09-15 00:24:00 America/Santiago', 'REP-002', 1, 9800, 'GEN-014', 'OT-224', null, 'operario'),
  (6, '2026-09-15 02:48:00 America/Santiago', 'REP-003', 1, 14200, 'GEN-014', 'OT-224', null, 'operario'),
  (7, '2026-09-17 10:00:00 America/Santiago', 'REP-004', 1, 18900, 'TIL-007', 'OT-225', null, 'operario'),
  (8, '2026-09-19 10:00:00 America/Santiago', 'REP-006', 1, 68000, 'VIB-005', 'OT-226', null, 'operario'),
  (9, '2026-09-22 10:00:00 America/Santiago', 'REP-005', 2, 5200, 'ALI-006', 'OT-227', null, 'operario'),
  (10, '2026-09-22 12:24:00 America/Santiago', 'REP-002', 1, 9800, 'ALI-006', 'OT-227', null, 'operario'),
  (11, '2026-10-11 10:00:00 America/Santiago', 'REP-002', 1, 9800, 'TIL-004', 'OT-228', null, 'operario'),
  (12, '2026-10-11 12:24:00 America/Santiago', 'REP-005', 3, 5200, 'TIL-004', 'OT-228', null, 'operario');

-- canibalizaciones (1 filas)
insert into canibalizaciones (id_canibalizacion, fecha_hora, equipo_donante, id_repuesto, pieza_otra, equipo_receptor, estado, registrado_por) values
  (1, '2026-10-17 10:00:00 America/Santiago', 'PLC-003', 'REP-007', null, 'PLC-012', 'Desmantelado', 'operario');

-- compras (10 filas)
insert into compras (id_compra, fecha_hora, id_repuesto, cantidad, precio_unitario_clp, origen, detalle, estado, ot_origen, id_canibalizacion) values
  (1, '2026-10-17 10:00:00 America/Santiago', 'REP-007', 1, 85000, 'Canibalización', 'PLC-003 → PLC-012', 'Aprobada', null, 1),
  (2, '2026-09-10 10:00:00 America/Santiago', 'REP-002', 12, 9800, 'Alerta de mínimo', 'Stock 3 · mínimo 6', 'Recibida', null, null),
  (3, '2026-09-14 10:00:00 America/Santiago', 'REP-005', 20, 5200, 'Mantención', 'OT-224 · GEN-014', 'Recibida', 'OT-224', null),
  (4, '2026-09-16 10:00:00 America/Santiago', 'REP-004', 6, 18900, 'Alerta de mínimo', 'Stock 2 · mínimo 8', 'Recibida', null, null),
  (5, '2026-09-18 10:00:00 America/Santiago', 'REP-006', 2, 68000, 'Mantención', 'OT-226 · VIB-005', 'Recibida', 'OT-226', null),
  (6, '2026-09-05 10:00:00 America/Santiago', 'REP-008', 1, 120000, 'Canibalización', 'GEN-006 → GEN-014', 'Recibida', null, null),
  (7, '2026-10-08 10:00:00 America/Santiago', 'REP-001', 10, 12500, 'Alerta de mínimo', 'Stock 1 · mínimo 6', 'Recibida', null, null),
  (8, '2026-10-12 10:00:00 America/Santiago', 'REP-005', 20, 5200, 'Sugerencia manual', 'Pedida por Silvio V.', 'Recibida', null, null),
  (9, '2026-10-14 10:00:00 America/Santiago', 'REP-003', 8, 14200, 'Alerta de mínimo', 'Stock 2 · mínimo 5', 'Recibida', null, null),
  (10, '2026-10-15 10:00:00 America/Santiago', 'REP-002', 6, 9800, 'Mantención', 'OT-228 · TIL-004', 'Recibida', 'OT-228', null);

-- ajustes_inventario (1 filas)
insert into ajustes_inventario (id_ajuste, fecha_hora, id_repuesto, stock_sistema, stock_contado, estado, registrado_por) values
  (1, '2026-10-20 07:00:00 America/Santiago', 'REP-003', 11, 9, 'Pendiente', 'operario');

-- solicitudes_acceso (1 filas)
insert into solicitudes_acceso (id_solicitud, nombre, correo, fecha_hora, estado) values
  (1, 'Álvaro Portilla', 'alvaro@mprental.cl', '2026-10-20 08:00:00 America/Santiago', 'Pendiente');

-- bitacora (4 filas)
insert into bitacora (id_log, fecha_hora, usuario, modulo, accion, detalle) values
  (1, '2026-10-11 10:00:00 America/Santiago', 'carlos.soto', 'Recepción', 'Registró recepción', 'COR-003 · Bueno · 1100 h'),
  (2, '2026-10-16 10:00:00 America/Santiago', 'juan', 'Acceso', 'Desactivó cuenta (queda inactiva)', 'Carlos Soto'),
  (3, '2026-10-19 07:00:00 America/Santiago', 'operario', 'Bodega', 'Registró uso de repuesto', '2 × Aceite 15W40 (L) · GEN-021 · OT-230'),
  (4, '2026-10-20 05:00:00 America/Santiago', 'operario', 'Recepción', 'Registró recepción', 'GEN-021 · Bueno · 3412 h');

-- Reiniciar contadores de los ids autoincrementales

select setval(pg_get_serial_sequence('extensiones_contrato','id_extension'), (select coalesce(max(id_extension),1) from extensiones_contrato));

select setval(pg_get_serial_sequence('recepciones','id_recepcion'), (select coalesce(max(id_recepcion),1) from recepciones));

select setval(pg_get_serial_sequence('uso_repuestos','id_uso'), (select coalesce(max(id_uso),1) from uso_repuestos));

select setval(pg_get_serial_sequence('canibalizaciones','id_canibalizacion'), (select coalesce(max(id_canibalizacion),1) from canibalizaciones));

select setval(pg_get_serial_sequence('compras','id_compra'), (select coalesce(max(id_compra),1) from compras));

select setval(pg_get_serial_sequence('ajustes_inventario','id_ajuste'), (select coalesce(max(id_ajuste),1) from ajustes_inventario));

select setval(pg_get_serial_sequence('solicitudes_acceso','id_solicitud'), (select coalesce(max(id_solicitud),1) from solicitudes_acceso));

select setval(pg_get_serial_sequence('solicitudes_eliminacion','id_solicitud'), (select coalesce(max(id_solicitud),1) from solicitudes_eliminacion));

select setval(pg_get_serial_sequence('registros_eliminados','id_archivo'), (select coalesce(max(id_archivo),1) from registros_eliminados));

select setval(pg_get_serial_sequence('bitacora','id_log'), (select coalesce(max(id_log),1) from bitacora));
