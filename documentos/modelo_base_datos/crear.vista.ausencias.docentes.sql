Create or replace view v_ausencia_por_grado (
id_respuesta, grado, ausencias
)
as
SELECT resp.id_respuesta, '1' as grado,
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '1', '')), 0))) as cantidad_ausencias
FROM gema_cis_sms.respuesta resp
join gema_cis_sms.mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '2',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '2', '')), 0))) as cantidad_ausencias
FROM gema_cis_sms.respuesta resp
join gema_cis_sms.mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '3',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '3', '')), 0))) as cantidad_ausencias
FROM gema_cis_sms.respuesta resp
join gema_cis_sms.mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '4',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '4', '')), 0))) as cantidad_ausencias
FROM gema_cis_sms.respuesta resp
join gema_cis_sms.mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '5',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '5', '')), 0))) as cantidad_ausencias
FROM gema_cis_sms.respuesta resp
join gema_cis_sms.mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '6',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '6', '')), 0))) as cantidad_ausencias
FROM gema_cis_sms.respuesta resp
join gema_cis_sms.mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '7',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '7', '')), 0))) as cantidad_ausencias
FROM gema_cis_sms.respuesta resp
join gema_cis_sms.mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE';