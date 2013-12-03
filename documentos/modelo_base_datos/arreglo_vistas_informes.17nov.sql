create or replace view v_directores_finalizados_total as
    SELECT 
        rest.id_institucion,
        count(DISTINCT camt.mes) cantidadContestada
    FROM
        registro_temporal regt
            JOIN
        respuesta rest ON regt.id_registro_temporal = rest.id_registro_temporal
            JOIN
        campania camt ON regt.id_campania = camt.id_campania
    WHERE
        camt.es_mensual = 1
            AND rest.id_institucion IS NOT NULL
            AND regt.tipo_operacion = 'F'
    GROUP BY rest.id_institucion
    HAVING cantidadContestada = (SELECT 
            count(*)
        FROM
            campania
        WHERE
            es_mensual = 1);

CREATE OR REPLACE VIEW `v_campania_por_departamento` AS
    select 
(select 
                count(distinct regtemp.id_registro_temporal)
            from
                registro_temporal regtemp
            where
                regtemp.id_campania = camp.id_campania) as `total_encuestados`,
        count(distinct if((`reg`.`tipo_operacion` = 'F'),
                `reg`.`id_registro_temporal`,
                NULL)) AS `total_finalizados`,
        truncate(((count(distinct if((`reg`.`tipo_operacion` = 'F'),
                    `reg`.`id_registro_temporal`,
                    NULL)) / (select 
                    count(distinct regtemp.id_registro_temporal)
                from
                    registro_temporal regtemp
                where
                    regtemp.id_campania = camp.id_campania)) * 100),
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
        join v_directores_finalizados_total tot on ins.id_institucion = tot.id_institucion
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


    CREATE OR REPLACE VIEW `v_campania_por_provincia` AS
    select 
        (select 
                count(distinct regtemp.id_registro_temporal)
            from
                registro_temporal regtemp
            where
                regtemp.id_campania = camp.id_campania) as `total_encuestados`,
        count(distinct if((`reg`.`tipo_operacion` = 'F'),
                `reg`.`id_registro_temporal`,
                NULL)) AS `total_finalizados`,
        truncate(((count(distinct if((`reg`.`tipo_operacion` = 'F'),
                    `reg`.`id_registro_temporal`,
                    NULL)) / (select 
                    count(distinct regtemp.id_registro_temporal)
                from
                    registro_temporal regtemp
                where
                    regtemp.id_campania = camp.id_campania)) * 100),
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
        join v_directores_finalizados_total tot on ins.id_institucion = tot.id_institucion
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

    CREATE OR REPLACE VIEW `v_campania_por_supervisor` AS
    select 
(select 
                count(distinct regtemp.id_registro_temporal)
            from
                registro_temporal regtemp
            where
                regtemp.id_campania = camp.id_campania) as `total_encuestados`,
        count(distinct if((`reg`.`tipo_operacion` = 'F'),
                `reg`.`id_registro_temporal`,
                NULL)) AS `total_finalizados`,
        truncate(((count(distinct if((`reg`.`tipo_operacion` = 'F'),
                    `reg`.`id_registro_temporal`,
                    NULL)) / (select 
                    count(distinct regtemp.id_registro_temporal)
                from
                    registro_temporal regtemp
                where
                    regtemp.id_campania = camp.id_campania)) * 100),
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
        join v_directores_finalizados_total tot on ins.id_institucion = tot.id_institucion
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