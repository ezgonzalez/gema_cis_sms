CREATE OR REPLACE VIEW `v_campania_por_provincia` AS
    select 
        count(distinct `reg`.`id_registro_temporal`) AS `total_encuestados`,
        count(distinct if((`reg`.`tipo_operacion` = 'F'),
                `reg`.`id_registro_temporal`,
                NULL)) AS `total_finalizados`,
        truncate(((count(distinct if((`reg`.`tipo_operacion` = 'F'),
                    `reg`.`id_registro_temporal`,
                    NULL)) / count(distinct `reg`.`id_registro_temporal`)) * 100),
            2) AS `representatividad`,
        `camp`.`mes` AS `mes`,
        `camp`.`anio` AS `anio`,
        `prov`.`id_provincia` AS `id_provincia`,
        group_concat(distinct `prov`.`nombre`
            separator ', ') AS `provincias`,
        `dto`.`id_departamento` AS `id_departamento`,
        group_concat(distinct `dto`.`nombre`
            separator ', ') AS `departamentos`,
        group_concat(distinct `ins`.`cue`
            separator ', ') AS `instituciones`,
        `ins`.`id_supervisor` AS `id_supervisor`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `matricula`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `abandono`,
        sum(if(((`msj_camp`.`codigo_mensaje` = 'ABAND_SINPASE'
                or `msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE')
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `abandono_acumulado`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `riesgo_abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOREPITENCIA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `riesgo_repitencia`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                        AND `reg`.`tipo_operacion` = 'F')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_abandono`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'
                        AND `reg`.`tipo_operacion` = 'F')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_repitencia`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `aprobados`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `aprobados_dificultad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados_dificultad`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `desaprobados`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_aprobados_dificultad`,
        sum(aus.ausencias) AS `inasistencia_docente`,
        ((((((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '7', ''))),
            0)) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '6', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '5', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '4', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '3', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '2', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '1', ''))),
            0))) AS `inasistencia_docente_mas_tres`,
        group_concat(distinct `aus`.`grado`
            order by `aus`.`ausencias` DESC
            separator ',') AS `cursos_inasistencia`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTE'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` <> '0'))
                        then
                            `ins`.`cue`
                    end)
                    order by length(ltrim(rtrim(`resp`.`valor`))) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_docente`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASENFERMEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_enfermedad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASTRABAJO'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_trabajo`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASPROBLEMASFAMILIARES'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_familiar`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos_mas_tres`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_alumnos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `solicitud_pase`,
        (sum(if(((`msj_camp`.`codigo_mensaje` = 'EGRESO'
                or `msj_camp`.`codigo_mensaje` = 'ABAND_PASE')
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `solicitud_pase_acumulado`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INGRESO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `ingresos`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INGRESO'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_ingresos`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `foco_uno`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `foco_dos_uno`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)))) AS `foco_dos_dos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `foco_tres`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_uno`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_uno`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_dos`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_tres`
    from
        (((((((`registro_temporal` `reg`
        join `institucion` `ins` ON ((`reg`.`id_contacto` = `ins`.`id_director`)))
        join `respuesta` `resp` ON (((`reg`.`id_registro_temporal` = `resp`.`id_registro_temporal`)
            and (`resp`.`id_institucion` = `ins`.`id_institucion`))))
        join `mensaje_campania` `msj_camp` ON ((`resp`.`id_mensaje_campania` = `msj_camp`.`id_mensaje_campania`)))
        join `campania` `camp` ON ((`reg`.`id_campania` = `camp`.`id_campania`)))
        join `departamento` `dto` ON ((`ins`.`id_departamento` = `dto`.`id_departamento`)))
        join `provincia` `prov` ON ((`dto`.`id_provincia` = `prov`.`id_provincia`)))
        left join `v_ausencia_por_grado` `aus` ON ((`resp`.`id_respuesta` = `aus`.`id_respuesta`)))
    where
        (`camp`.`es_mensual` = 1)
    group by `prov`.`id_provincia` , `camp`.`mes` , `camp`.`anio`;

CREATE OR REPLACE VIEW `v_campania_por_departamento` AS
   select 
        count(distinct `reg`.`id_registro_temporal`) AS `total_encuestados`,
        count(distinct if((`reg`.`tipo_operacion` = 'F'),
                `reg`.`id_registro_temporal`,
                NULL)) AS `total_finalizados`,
        truncate(((count(distinct if((`reg`.`tipo_operacion` = 'F'),
                    `reg`.`id_registro_temporal`,
                    NULL)) / count(distinct `reg`.`id_registro_temporal`)) * 100),
            2) AS `representatividad`,
        `camp`.`mes` AS `mes`,
        `camp`.`anio` AS `anio`,
        `prov`.`id_provincia` AS `id_provincia`,
        group_concat(distinct `prov`.`nombre`
            separator ', ') AS `provincias`,
        `dto`.`id_departamento` AS `id_departamento`,
        group_concat(distinct `dto`.`nombre`
            separator ', ') AS `departamentos`,
        group_concat(distinct `ins`.`cue`
            separator ', ') AS `instituciones`,
        `ins`.`id_supervisor` AS `id_supervisor`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `matricula`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `abandono`,
        sum(if(((`msj_camp`.`codigo_mensaje` = 'ABAND_SINPASE'
                or `msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE')
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `abandono_acumulado`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `riesgo_abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOREPITENCIA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `riesgo_repitencia`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                        AND `reg`.`tipo_operacion` = 'F')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_abandono`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'
                        AND `reg`.`tipo_operacion` = 'F')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_repitencia`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `aprobados`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `aprobados_dificultad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados_dificultad`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `desaprobados`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_aprobados_dificultad`,
        sum(aus.ausencias) AS `inasistencia_docente`,
        ((((((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '7', ''))),
            0)) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '6', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '5', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '4', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '3', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '2', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '1', ''))),
            0))) AS `inasistencia_docente_mas_tres`,
        group_concat(distinct `aus`.`grado`
            order by `aus`.`ausencias` DESC
            separator ',') AS `cursos_inasistencia`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTE'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` <> '0'))
                        then
                            `ins`.`cue`
                    end)
                    order by length(ltrim(rtrim(`resp`.`valor`))) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_docente`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASENFERMEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_enfermedad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASTRABAJO'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_trabajo`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASPROBLEMASFAMILIARES'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_familiar`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos_mas_tres`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_alumnos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `solicitud_pase`,
        (sum(if(((`msj_camp`.`codigo_mensaje` = 'EGRESO'
                or `msj_camp`.`codigo_mensaje` = 'ABAND_PASE')
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `solicitud_pase_acumulado`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INGRESO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `ingresos`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INGRESO'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_ingresos`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `foco_uno`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `foco_dos_uno`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)))) AS `foco_dos_dos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `foco_tres`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_uno`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_uno`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_dos`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_tres`
    from
        (((((((`registro_temporal` `reg`
        join `institucion` `ins` ON ((`reg`.`id_contacto` = `ins`.`id_director`)))
        join `respuesta` `resp` ON (((`reg`.`id_registro_temporal` = `resp`.`id_registro_temporal`)
            and (`resp`.`id_institucion` = `ins`.`id_institucion`))))
        join `mensaje_campania` `msj_camp` ON ((`resp`.`id_mensaje_campania` = `msj_camp`.`id_mensaje_campania`)))
        join `campania` `camp` ON ((`reg`.`id_campania` = `camp`.`id_campania`)))
        join `departamento` `dto` ON ((`ins`.`id_departamento` = `dto`.`id_departamento`)))
        join `provincia` `prov` ON ((`dto`.`id_provincia` = `prov`.`id_provincia`)))
        left join `v_ausencia_por_grado` `aus` ON ((`resp`.`id_respuesta` = `aus`.`id_respuesta`)))
    where
        (`camp`.`es_mensual` = 1)
    group by `dto`.`id_departamento` , `prov`.`id_provincia` , `camp`.`mes` , `camp`.`anio`;

    CREATE OR REPLACE VIEW `v_campania_por_supervisor` AS
    select 
        count(distinct `reg`.`id_registro_temporal`) AS `total_encuestados`,
        count(distinct if((`reg`.`tipo_operacion` = 'F'),
                `reg`.`id_registro_temporal`,
                NULL)) AS `total_finalizados`,
        truncate(((count(distinct if((`reg`.`tipo_operacion` = 'F'),
                    `reg`.`id_registro_temporal`,
                    NULL)) / count(distinct `reg`.`id_registro_temporal`)) * 100),
            2) AS `representatividad`,
        `camp`.`mes` AS `mes`,
        `camp`.`anio` AS `anio`,
        `prov`.`id_provincia` AS `id_provincia`,
        group_concat(distinct `prov`.`nombre`
            separator ', ') AS `provincias`,
        `dto`.`id_departamento` AS `id_departamento`,
        group_concat(distinct `dto`.`nombre`
            separator ', ') AS `departamentos`,
        group_concat(distinct `ins`.`cue`
            separator ', ') AS `instituciones`,
        `ins`.`id_supervisor` AS `id_supervisor`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `matricula`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `abandono`,
        sum(if(((`msj_camp`.`codigo_mensaje` = 'ABAND_SINPASE'
                or `msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE')
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `abandono_acumulado`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `riesgo_abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOREPITENCIA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `riesgo_repitencia`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                        AND `reg`.`tipo_operacion` = 'F')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_abandono`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'
                        AND `reg`.`tipo_operacion` = 'F')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_repitencia`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `aprobados`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `aprobados_dificultad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados_dificultad`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `desaprobados`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_aprobados_dificultad`,
        sum(aus.ausencias) AS `inasistencia_docente`,
        ((((((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '7', ''))),
            0)) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '6', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '5', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '4', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '3', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '2', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '1', ''))),
            0))) AS `inasistencia_docente_mas_tres`,
        group_concat(distinct `aus`.`grado`
            order by `aus`.`ausencias` DESC
            separator ',') AS `cursos_inasistencia`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTE'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (`resp`.`valor` <> '0'))
                        then
                            `ins`.`cue`
                    end)
                    order by length(ltrim(rtrim(`resp`.`valor`))) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_docente`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASENFERMEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_enfermedad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASTRABAJO'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_trabajo`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASPROBLEMASFAMILIARES'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_familiar`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos_mas_tres`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_alumnos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `solicitud_pase`,
        (sum(if(((`msj_camp`.`codigo_mensaje` = 'EGRESO'
                or `msj_camp`.`codigo_mensaje` = 'ABAND_PASE')
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `solicitud_pase_acumulado`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INGRESO'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `ingresos`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INGRESO'
                                AND `reg`.`tipo_operacion` = 'F')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_ingresos`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `foco_uno`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) AS `foco_dos_uno`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)))) AS `foco_dos_dos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                AND `reg`.`tipo_operacion` = 'F'),
            `resp`.`valor`,
            0))) AS `foco_tres`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_uno`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_uno`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_dos`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'
                    AND `reg`.`tipo_operacion` = 'F'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_tres`
    from
        (((((((`registro_temporal` `reg`
        join `institucion` `ins` ON ((`reg`.`id_contacto` = `ins`.`id_director`)))
        join `respuesta` `resp` ON (((`reg`.`id_registro_temporal` = `resp`.`id_registro_temporal`)
            and (`resp`.`id_institucion` = `ins`.`id_institucion`))))
        join `mensaje_campania` `msj_camp` ON ((`resp`.`id_mensaje_campania` = `msj_camp`.`id_mensaje_campania`)))
        join `campania` `camp` ON ((`reg`.`id_campania` = `camp`.`id_campania`)))
        join `departamento` `dto` ON ((`ins`.`id_departamento` = `dto`.`id_departamento`)))
        join `provincia` `prov` ON ((`dto`.`id_provincia` = `prov`.`id_provincia`)))
        left join `v_ausencia_por_grado` `aus` ON ((`resp`.`id_respuesta` = `aus`.`id_respuesta`)))
    where
        (`camp`.`es_mensual` = 1)
    group by `ins`.`id_supervisor` , `camp`.`mes` , `camp`.`anio`;

    CREATE or replace VIEW `v_informe_campania_por_departamento` AS
    select 
        `prov`.`total_encuestados` AS `total_encuestados`,
        `prov`.`total_finalizados` AS `total_finalizados`,
        `prov`.`representatividad` AS `representatividad`,
        `prov`.`mes` AS `mes`,
        `prov`.`anio` AS `anio`,
        `prov`.`id_provincia` AS `id_provincia`,
        `prov`.`provincias` AS `provincias`,
        `prov`.`id_departamento` AS `id_departamento`,
        `prov`.`departamentos` AS `departamentos`,
        `prov`.`instituciones` AS `instituciones`,
        `prov`.`id_supervisor` AS `id_supervisor`,
        `prov`.`matricula` AS `matricula`,
        `prov`.`abandono` AS `abandono`,
        `prov`.`riesgo_abandono` AS `riesgo_abandono`,
        `prov`.`riesgo_repitencia` AS `riesgo_repitencia`,
        `prov`.`instituciones_abandono` AS `instituciones_abandono`,
        `prov`.`instituciones_repitencia` AS `instituciones_repitencia`,
        `prov`.`aprobados` AS `aprobados`,
        `prov`.`porcentaje_aprobados` AS `porcentaje_aprobados`,
        `prov`.`aprobados_dificultad` AS `aprobados_dificultad`,
        `prov`.`porcentaje_aprobados_dificultad` AS `porcentaje_aprobados_dificultad`,
        `prov`.`desaprobados` AS `desaprobados`,
        `prov`.`porcentaje_desaprobados` AS `porcentaje_desaprobados`,
        `prov`.`instituciones_desaprobados` AS `instituciones_desaprobados`,
        `prov`.`instituciones_aprobados_dificultad` AS `instituciones_aprobados_dificultad`,
        `prov`.`inasistencia_docente` AS `inasistencia_docente`,
        `prov`.`inasistencia_docente_mas_tres` AS `inasistencia_docente_mas_tres`,
        `prov`.`cursos_inasistencia` AS `cursos_inasistencia`,
        `prov`.`instituciones_inasistencia_docente` AS `instituciones_inasistencia_docente`,
        `prov`.`inasistencia_alumnos` AS `inasistencia_alumnos`,
        `prov`.`porcentaje_inasistencia_alumnos_enfermedad` AS `porcentaje_inasistencia_alumnos_enfermedad`,
        `prov`.`porcentaje_inasistencia_alumnos_trabajo` AS `porcentaje_inasistencia_alumnos_trabajo`,
        `prov`.`porcentaje_inasistencia_alumnos_familiar` AS `porcentaje_inasistencia_alumnos_familiar`,
        `prov`.`inasistencia_alumnos_mas_tres` AS `inasistencia_alumnos_mas_tres`,
        `prov`.`instituciones_inasistencia_alumnos` AS `instituciones_inasistencia_alumnos`,
        `prov`.`solicitud_pase` AS `solicitud_pase`,
        `prov`.`ingresos` AS `ingresos`,
        `prov`.`instituciones_ingresos` AS `instituciones_ingresos`,
        `prov`.`foco_uno` AS `foco_uno`,
        `prov`.`foco_dos_uno` AS `foco_dos_uno`,
        `prov`.`foco_dos_dos` AS `foco_dos_dos`,
        `prov`.`foco_tres` AS `foco_tres`,
        `prov`.`porcentaje_foco_uno` AS `porcentaje_foco_uno`,
        `prov`.`porcentaje_foco_dos_uno` AS `porcentaje_foco_dos_uno`,
        `prov`.`porcentaje_foco_dos_dos` AS `porcentaje_foco_dos_dos`,
        `prov`.`porcentaje_foco_tres` AS `porcentaje_foco_tres`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`abandono`,
            0)) AS `abandono_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`abandono_acumulado`,
            0)) AS `abandono_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`riesgo_abandono`,
            0)) AS `riesgo_abandono_anterior`,
        '--' AS `riesgo_abandono_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`riesgo_repitencia`,
            0)) AS `riesgo_repitencia_anterior`,
        '--' AS `riesgo_repitencia_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`aprobados`,
            0)) AS `aprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_aprobados`,
            0)) AS `porcentaje_aprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`aprobados_dificultad`,
            0)) AS `aprobados_dificultad_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_aprobados_dificultad`,
            0)) AS `porcentaje_aprobados_dificultad_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`desaprobados`,
            0)) AS `desaprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_desaprobados`,
            0)) AS `porcentaje_desaprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_docente`,
            0)) AS `inasistencia_docente_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_docente`,
            0)) AS `inasistencia_docente_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_docente_mas_tres`,
            0)) AS `inasistencia_docente_mas_tres_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_docente_mas_tres`,
            0)) AS `inasistencia_docente_mas_tres_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_alumnos`,
            0)) AS `inasistencia_alumnos_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_alumnos`,
            0)) AS `inasistencia_alumnos_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_alumnos_mas_tres`,
            0)) AS `inasistencia_alumnos_mas_tres_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_alumnos_mas_tres`,
            0)) AS `inasistencia_alumnos_mas_tres_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`solicitud_pase`,
            0)) AS `solicitud_pase_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`solicitud_pase_acumulado`,
            0)) AS `solicitud_pase_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`ingresos`,
            0)) AS `ingresos_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`ingresos`,
            0)) AS `ingresos_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_uno`,
            0)) AS `foco_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_dos_uno`,
            0)) AS `foco_dos_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_dos_dos`,
            0)) AS `foco_dos_dos_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_tres`,
            0)) AS `foco_tres_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_uno`,
            0)) AS `porcentaje_foco_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_dos_uno`,
            0)) AS `porcentaje_foco_dos_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_dos_dos`,
            0)) AS `porcentaje_foco_dos_dos_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_tres`,
            0)) AS `porcentaje_foco_tres_anterior`
    from
        (`v_campania_por_departamento` `prov`
        join `v_campania_por_departamento` `prov_ant` ON (((`prov`.`id_provincia` = `prov_ant`.`id_provincia`)
            and (`prov`.`id_departamento` = `prov_ant`.`id_departamento`)
            and (`prov`.`anio` = `prov_ant`.`anio`))))
    group by `prov`.`id_departamento` , `prov`.`id_provincia` , `prov`.`mes` , `prov`.`anio`;

    CREATE or replace VIEW `v_informe_campania_por_provincia` AS
    select 
        `prov`.`total_encuestados` AS `total_encuestados`,
        `prov`.`total_finalizados` AS `total_finalizados`,
        `prov`.`representatividad` AS `representatividad`,
        `prov`.`mes` AS `mes`,
        `prov`.`anio` AS `anio`,
        `prov`.`id_provincia` AS `id_provincia`,
        `prov`.`provincias` AS `provincias`,
        `prov`.`id_departamento` AS `id_departamento`,
        `prov`.`departamentos` AS `departamentos`,
        `prov`.`instituciones` AS `instituciones`,
        `prov`.`id_supervisor` AS `id_supervisor`,
        `prov`.`matricula` AS `matricula`,
        `prov`.`abandono` AS `abandono`,
        `prov`.`riesgo_abandono` AS `riesgo_abandono`,
        `prov`.`riesgo_repitencia` AS `riesgo_repitencia`,
        `prov`.`instituciones_abandono` AS `instituciones_abandono`,
        `prov`.`instituciones_repitencia` AS `instituciones_repitencia`,
        `prov`.`aprobados` AS `aprobados`,
        `prov`.`porcentaje_aprobados` AS `porcentaje_aprobados`,
        `prov`.`aprobados_dificultad` AS `aprobados_dificultad`,
        `prov`.`porcentaje_aprobados_dificultad` AS `porcentaje_aprobados_dificultad`,
        `prov`.`desaprobados` AS `desaprobados`,
        `prov`.`porcentaje_desaprobados` AS `porcentaje_desaprobados`,
        `prov`.`instituciones_desaprobados` AS `instituciones_desaprobados`,
        `prov`.`instituciones_aprobados_dificultad` AS `instituciones_aprobados_dificultad`,
        `prov`.`inasistencia_docente` AS `inasistencia_docente`,
        `prov`.`inasistencia_docente_mas_tres` AS `inasistencia_docente_mas_tres`,
        `prov`.`cursos_inasistencia` AS `cursos_inasistencia`,
        `prov`.`instituciones_inasistencia_docente` AS `instituciones_inasistencia_docente`,
        `prov`.`inasistencia_alumnos` AS `inasistencia_alumnos`,
        `prov`.`porcentaje_inasistencia_alumnos_enfermedad` AS `porcentaje_inasistencia_alumnos_enfermedad`,
        `prov`.`porcentaje_inasistencia_alumnos_trabajo` AS `porcentaje_inasistencia_alumnos_trabajo`,
        `prov`.`porcentaje_inasistencia_alumnos_familiar` AS `porcentaje_inasistencia_alumnos_familiar`,
        `prov`.`inasistencia_alumnos_mas_tres` AS `inasistencia_alumnos_mas_tres`,
        `prov`.`instituciones_inasistencia_alumnos` AS `instituciones_inasistencia_alumnos`,
        `prov`.`solicitud_pase` AS `solicitud_pase`,
        `prov`.`ingresos` AS `ingresos`,
        `prov`.`instituciones_ingresos` AS `instituciones_ingresos`,
        `prov`.`foco_uno` AS `foco_uno`,
        `prov`.`foco_dos_uno` AS `foco_dos_uno`,
        `prov`.`foco_dos_dos` AS `foco_dos_dos`,
        `prov`.`foco_tres` AS `foco_tres`,
        `prov`.`porcentaje_foco_uno` AS `porcentaje_foco_uno`,
        `prov`.`porcentaje_foco_dos_uno` AS `porcentaje_foco_dos_uno`,
        `prov`.`porcentaje_foco_dos_dos` AS `porcentaje_foco_dos_dos`,
        `prov`.`porcentaje_foco_tres` AS `porcentaje_foco_tres`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`abandono`,
            0)) AS `abandono_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`abandono_acumulado`,
            0)) AS `abandono_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`riesgo_abandono`,
            0)) AS `riesgo_abandono_anterior`,
        '--' AS `riesgo_abandono_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`riesgo_repitencia`,
            0)) AS `riesgo_repitencia_anterior`,
        '--' AS `riesgo_repitencia_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`aprobados`,
            0)) AS `aprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_aprobados`,
            0)) AS `porcentaje_aprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`aprobados_dificultad`,
            0)) AS `aprobados_dificultad_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_aprobados_dificultad`,
            0)) AS `porcentaje_aprobados_dificultad_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`desaprobados`,
            0)) AS `desaprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_desaprobados`,
            0)) AS `porcentaje_desaprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_docente`,
            0)) AS `inasistencia_docente_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_docente`,
            0)) AS `inasistencia_docente_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_docente_mas_tres`,
            0)) AS `inasistencia_docente_mas_tres_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_docente_mas_tres`,
            0)) AS `inasistencia_docente_mas_tres_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_alumnos`,
            0)) AS `inasistencia_alumnos_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_alumnos`,
            0)) AS `inasistencia_alumnos_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_alumnos_mas_tres`,
            0)) AS `inasistencia_alumnos_mas_tres_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_alumnos_mas_tres`,
            0)) AS `inasistencia_alumnos_mas_tres_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`solicitud_pase`,
            0)) AS `solicitud_pase_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`solicitud_pase_acumulado`,
            0)) AS `solicitud_pase_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`ingresos`,
            0)) AS `ingresos_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`ingresos`,
            0)) AS `ingresos_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_uno`,
            0)) AS `foco_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_dos_uno`,
            0)) AS `foco_dos_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_dos_dos`,
            0)) AS `foco_dos_dos_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_tres`,
            0)) AS `foco_tres_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_uno`,
            0)) AS `porcentaje_foco_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_dos_uno`,
            0)) AS `porcentaje_foco_dos_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_dos_dos`,
            0)) AS `porcentaje_foco_dos_dos_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_tres`,
            0)) AS `porcentaje_foco_tres_anterior`
    from
        (`v_campania_por_provincia` `prov`
        join `v_campania_por_provincia` `prov_ant` ON (((`prov`.`id_provincia` = `prov_ant`.`id_provincia`)
            and (`prov`.`anio` = `prov_ant`.`anio`))))
    group by `prov`.`mes` , `prov`.`id_provincia`;

    CREATE or replace VIEW `v_informe_campania_por_supervisor` AS
    select 
        `prov`.`total_encuestados` AS `total_encuestados`,
        `prov`.`total_finalizados` AS `total_finalizados`,
        `prov`.`representatividad` AS `representatividad`,
        `prov`.`mes` AS `mes`,
        `prov`.`anio` AS `anio`,
        `prov`.`id_provincia` AS `id_provincia`,
        `prov`.`provincias` AS `provincias`,
        `prov`.`id_departamento` AS `id_departamento`,
        `prov`.`departamentos` AS `departamentos`,
        `prov`.`instituciones` AS `instituciones`,
        `prov`.`id_supervisor` AS `id_supervisor`,
        `prov`.`matricula` AS `matricula`,
        `prov`.`abandono` AS `abandono`,
        `prov`.`riesgo_abandono` AS `riesgo_abandono`,
        `prov`.`riesgo_repitencia` AS `riesgo_repitencia`,
        `prov`.`instituciones_abandono` AS `instituciones_abandono`,
        `prov`.`instituciones_repitencia` AS `instituciones_repitencia`,
        `prov`.`aprobados` AS `aprobados`,
        `prov`.`porcentaje_aprobados` AS `porcentaje_aprobados`,
        `prov`.`aprobados_dificultad` AS `aprobados_dificultad`,
        `prov`.`porcentaje_aprobados_dificultad` AS `porcentaje_aprobados_dificultad`,
        `prov`.`desaprobados` AS `desaprobados`,
        `prov`.`porcentaje_desaprobados` AS `porcentaje_desaprobados`,
        `prov`.`instituciones_desaprobados` AS `instituciones_desaprobados`,
        `prov`.`instituciones_aprobados_dificultad` AS `instituciones_aprobados_dificultad`,
        `prov`.`inasistencia_docente` AS `inasistencia_docente`,
        `prov`.`inasistencia_docente_mas_tres` AS `inasistencia_docente_mas_tres`,
        `prov`.`cursos_inasistencia` AS `cursos_inasistencia`,
        `prov`.`instituciones_inasistencia_docente` AS `instituciones_inasistencia_docente`,
        `prov`.`inasistencia_alumnos` AS `inasistencia_alumnos`,
        `prov`.`porcentaje_inasistencia_alumnos_enfermedad` AS `porcentaje_inasistencia_alumnos_enfermedad`,
        `prov`.`porcentaje_inasistencia_alumnos_trabajo` AS `porcentaje_inasistencia_alumnos_trabajo`,
        `prov`.`porcentaje_inasistencia_alumnos_familiar` AS `porcentaje_inasistencia_alumnos_familiar`,
        `prov`.`inasistencia_alumnos_mas_tres` AS `inasistencia_alumnos_mas_tres`,
        `prov`.`instituciones_inasistencia_alumnos` AS `instituciones_inasistencia_alumnos`,
        `prov`.`solicitud_pase` AS `solicitud_pase`,
        `prov`.`ingresos` AS `ingresos`,
        `prov`.`instituciones_ingresos` AS `instituciones_ingresos`,
        `prov`.`foco_uno` AS `foco_uno`,
        `prov`.`foco_dos_uno` AS `foco_dos_uno`,
        `prov`.`foco_dos_dos` AS `foco_dos_dos`,
        `prov`.`foco_tres` AS `foco_tres`,
        `prov`.`porcentaje_foco_uno` AS `porcentaje_foco_uno`,
        `prov`.`porcentaje_foco_dos_uno` AS `porcentaje_foco_dos_uno`,
        `prov`.`porcentaje_foco_dos_dos` AS `porcentaje_foco_dos_dos`,
        `prov`.`porcentaje_foco_tres` AS `porcentaje_foco_tres`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`abandono`,
            0)) AS `abandono_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`abandono_acumulado`,
            0)) AS `abandono_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`riesgo_abandono`,
            0)) AS `riesgo_abandono_anterior`,
        '--' AS `riesgo_abandono_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`riesgo_repitencia`,
            0)) AS `riesgo_repitencia_anterior`,
        '--' AS `riesgo_repitencia_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`aprobados`,
            0)) AS `aprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_aprobados`,
            0)) AS `porcentaje_aprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`aprobados_dificultad`,
            0)) AS `aprobados_dificultad_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_aprobados_dificultad`,
            0)) AS `porcentaje_aprobados_dificultad_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`desaprobados`,
            0)) AS `desaprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_desaprobados`,
            0)) AS `porcentaje_desaprobados_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_docente`,
            0)) AS `inasistencia_docente_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_docente`,
            0)) AS `inasistencia_docente_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_docente_mas_tres`,
            0)) AS `inasistencia_docente_mas_tres_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_docente_mas_tres`,
            0)) AS `inasistencia_docente_mas_tres_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_alumnos`,
            0)) AS `inasistencia_alumnos_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_alumnos`,
            0)) AS `inasistencia_alumnos_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`inasistencia_alumnos_mas_tres`,
            0)) AS `inasistencia_alumnos_mas_tres_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`inasistencia_alumnos_mas_tres`,
            0)) AS `inasistencia_alumnos_mas_tres_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`solicitud_pase`,
            0)) AS `solicitud_pase_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`solicitud_pase_acumulado`,
            0)) AS `solicitud_pase_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`ingresos`,
            0)) AS `ingresos_anterior`,
        sum(if((`prov_ant`.`mes` <= `prov`.`mes`),
            `prov_ant`.`ingresos`,
            0)) AS `ingresos_acumulado`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_uno`,
            0)) AS `foco_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_dos_uno`,
            0)) AS `foco_dos_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_dos_dos`,
            0)) AS `foco_dos_dos_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`foco_tres`,
            0)) AS `foco_tres_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_uno`,
            0)) AS `porcentaje_foco_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_dos_uno`,
            0)) AS `porcentaje_foco_dos_uno_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_dos_dos`,
            0)) AS `porcentaje_foco_dos_dos_anterior`,
        sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),
            `prov_ant`.`porcentaje_foco_tres`,
            0)) AS `porcentaje_foco_tres_anterior`
    from
        (`v_campania_por_departamento` `prov`
        join `v_campania_por_departamento` `prov_ant` ON (((`prov`.`id_provincia` = `prov_ant`.`id_provincia`)
            and (`prov`.`id_supervisor` = `prov_ant`.`id_supervisor`))))
    group by `prov`.`id_supervisor` , `prov`.`mes` , `prov`.`anio`;


    update respuesta res set res.valor = 0
    where res.id_mensaje_campania in (select msj.id_mensaje_campania from mensaje_campania msj join campania cam on cam.id_campania = msj.id_campania where msj.codigo_mensaje = 'EGRESOSINPASE' and cam.mes in (5,6,7));
update respuesta res set res.valor = 0  
    where res.id_mensaje_campania in (select msj.id_mensaje_campania from mensaje_campania msj join campania cam on cam.id_campania = msj.id_campania where msj.codigo_mensaje = 'EGRESO' and cam.mes in (5, 6,7));