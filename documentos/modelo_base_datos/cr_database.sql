SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `campania`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campania` ;

CREATE TABLE IF NOT EXISTS `campania` (
  `id_campania` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `es_mensual` TINYINT(1) NULL DEFAULT 0,
  `mes` TINYINT(3) NULL DEFAULT NULL,
  `anio` CHAR(4) NULL DEFAULT NULL,
  `descripcion` CHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `fecha_baja` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id_campania`))
ENGINE = InnoDB
AUTO_INCREMENT = 17;


-- -----------------------------------------------------
-- Table `modem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `modem` ;

CREATE TABLE IF NOT EXISTS `modem` (
  `id_modem` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` CHAR(10) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NOT NULL,
  `descripcion` CHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NOT NULL,
  `url` CHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `fecha_baja` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id_modem`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci;


-- -----------------------------------------------------
-- Table `contacto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contacto` ;

CREATE TABLE IF NOT EXISTS `contacto` (
  `id_contacto` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` CHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `apellido` CHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `telefono` CHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `dni` CHAR(10) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `fecha_baja` DATE NULL DEFAULT NULL,
  `id_modem` INT(10) UNSIGNED NULL,
  `es_supervisor` TINYINT(1) NOT NULL DEFAULT 0,
  `es_director` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_contacto`),
  INDEX `fk_contacto_modem1_idx` (`id_modem` ASC),
  CONSTRAINT `fk_contacto_modem1`
    FOREIGN KEY (`id_modem`)
    REFERENCES `modem` (`id_modem`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 379;


-- -----------------------------------------------------
-- Table `mensaje`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mensaje` ;

CREATE TABLE IF NOT EXISTS `mensaje` (
  `id_mensaje` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `valor` TEXT CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `direccion` CHAR(40) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `fecha_mensaje` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_contacto` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_mensaje`),
  INDEX `fk_mensaje_contacto1_idx` (`id_contacto` ASC),
  CONSTRAINT `fk_mensaje_contacto1`
    FOREIGN KEY (`id_contacto`)
    REFERENCES `contacto` (`id_contacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 30656;


-- -----------------------------------------------------
-- Table `buffer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `buffer` ;

CREATE TABLE IF NOT EXISTS `buffer` (
  `id_buffer` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `estado` CHAR(1) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NOT NULL,
  `timestamp_creacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_campania` INT(10) UNSIGNED NOT NULL,
  `id_mensaje` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_buffer`),
  INDEX `fk_buffer_campania1_idx` (`id_campania` ASC),
  INDEX `fk_buffer_mensaje1_idx` (`id_mensaje` ASC),
  CONSTRAINT `fk_buffer_campania1`
    FOREIGN KEY (`id_campania`)
    REFERENCES `campania` (`id_campania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buffer_mensaje1`
    FOREIGN KEY (`id_mensaje`)
    REFERENCES `mensaje` (`id_mensaje`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `provincia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `provincia` ;

CREATE TABLE IF NOT EXISTS `provincia` (
  `id_provincia` INT(10) UNSIGNED NOT NULL,
  `nombre` CHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  PRIMARY KEY (`id_provincia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `departamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `departamento` ;

CREATE TABLE IF NOT EXISTS `departamento` (
  `id_departamento` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` CHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `id_provincia` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_departamento`),
  INDEX `fk_departamento_provinvia1_idx` (`id_provincia` ASC),
  CONSTRAINT `fk_departamento_provinvia1`
    FOREIGN KEY (`id_provincia`)
    REFERENCES `provincia` (`id_provincia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `grupo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `grupo` ;

CREATE TABLE IF NOT EXISTS `grupo` (
  `id_grupo` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` CHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  PRIMARY KEY (`id_grupo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci;


-- -----------------------------------------------------
-- Table `institucion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `institucion` ;

CREATE TABLE IF NOT EXISTS `institucion` (
  `id_institucion` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cue` CHAR(10) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `nombre` CHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `id_supervisor` INT(10) UNSIGNED NULL,
  `id_director` INT(10) UNSIGNED NULL,
  `id_departamento` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_institucion`),
  INDEX `fk_institucion_contacto1_idx` (`id_supervisor` ASC),
  INDEX `fk_institucion_contacto2_idx` (`id_director` ASC),
  INDEX `fk_institucion_departamento1_idx` (`id_departamento` ASC),
  CONSTRAINT `fk_institucion_contacto1`
    FOREIGN KEY (`id_supervisor`)
    REFERENCES `contacto` (`id_contacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_institucion_contacto2`
    FOREIGN KEY (`id_director`)
    REFERENCES `contacto` (`id_contacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_institucion_departamento1`
    FOREIGN KEY (`id_departamento`)
    REFERENCES `departamento` (`id_departamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `localidad`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `localidad` ;

CREATE TABLE IF NOT EXISTS `localidad` (
  `id_localidad` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` CHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `id_departamento` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_localidad`),
  INDEX `fk_localidad_departamento1_idx` (`id_departamento` ASC),
  CONSTRAINT `fk_localidad_departamento1`
    FOREIGN KEY (`id_departamento`)
    REFERENCES `departamento` (`id_departamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mensaje_campania`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mensaje_campania` ;

CREATE TABLE IF NOT EXISTS `mensaje_campania` (
  `id_mensaje_campania` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `validaciones` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `condiciones_entrada` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `codigo_mensaje` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `texto_mensaje` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `tipo_mensaje` CHAR(1) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `numero_orden` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
  `id_campania` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_mensaje_campania`),
  INDEX `fk_mensaje_campania_campania1_idx` (`id_campania` ASC),
  CONSTRAINT `fk_mensaje_campania_campania1`
    FOREIGN KEY (`id_campania`)
    REFERENCES `campania` (`id_campania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 168;


-- -----------------------------------------------------
-- Table `mensaje_campania_siguiente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mensaje_campania_siguiente` ;

CREATE TABLE IF NOT EXISTS `mensaje_campania_siguiente` (
  `id_mensaje_campania_siguiente` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_siguiente_mensaje_campania` INT(10) UNSIGNED NOT NULL,
  `id_mensaje_campania` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_mensaje_campania_siguiente`),
  INDEX `mensaje_campania_siguiente_FKIndex2` (`id_siguiente_mensaje_campania` ASC),
  INDEX `fk_mensaje_campania_siguiente_mensaje_campania1_idx` (`id_mensaje_campania` ASC),
  CONSTRAINT `fk_mensaje_campania_siguiente_mensaje_campania1`
    FOREIGN KEY (`id_mensaje_campania`)
    REFERENCES `mensaje_campania` (`id_mensaje_campania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mensaje_campania_siguiente_mensaje_campania2`
    FOREIGN KEY (`id_siguiente_mensaje_campania`)
    REFERENCES `mensaje_campania` (`id_mensaje_campania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `registro_temporal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `registro_temporal` ;

CREATE TABLE IF NOT EXISTS `registro_temporal` (
  `id_registro_temporal` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `buffer` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `tipo_operacion` CHAR(2) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `fecha_ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_contacto` INT(10) UNSIGNED NOT NULL,
  `id_campania` INT(10) UNSIGNED NOT NULL,
  `id_mensaje_campania` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_registro_temporal`),
  INDEX `fk_registro_temporal_contacto1_idx` (`id_contacto` ASC),
  INDEX `fk_registro_temporal_campania1_idx` (`id_campania` ASC),
  INDEX `fk_registro_temporal_mensaje_campania1_idx` (`id_mensaje_campania` ASC),
  CONSTRAINT `fk_registro_temporal_contacto1`
    FOREIGN KEY (`id_contacto`)
    REFERENCES `contacto` (`id_contacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registro_temporal_campania1`
    FOREIGN KEY (`id_campania`)
    REFERENCES `campania` (`id_campania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registro_temporal_mensaje_campania1`
    FOREIGN KEY (`id_mensaje_campania`)
    REFERENCES `mensaje_campania` (`id_mensaje_campania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1882;


-- -----------------------------------------------------
-- Table `respuesta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `respuesta` ;

CREATE TABLE IF NOT EXISTS `respuesta` (
  `id_respuesta` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `valor` TEXT CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NULL DEFAULT NULL,
  `id_mensaje_campania` INT(10) UNSIGNED NOT NULL,
  `id_registro_temporal` INT(10) UNSIGNED NOT NULL,
  `id_institucion` INT(10) UNSIGNED NULL,
  PRIMARY KEY (`id_respuesta`),
  INDEX `fk_respuesta_mensaje_campania1_idx` (`id_mensaje_campania` ASC),
  INDEX `fk_respuesta_registro_temporal1_idx` (`id_registro_temporal` ASC),
  INDEX `fk_respuesta_institucion1_idx` (`id_institucion` ASC),
  CONSTRAINT `fk_respuesta_mensaje_campania1`
    FOREIGN KEY (`id_mensaje_campania`)
    REFERENCES `mensaje_campania` (`id_mensaje_campania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_respuesta_registro_temporal1`
    FOREIGN KEY (`id_registro_temporal`)
    REFERENCES `registro_temporal` (`id_registro_temporal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_respuesta_institucion1`
    FOREIGN KEY (`id_institucion`)
    REFERENCES `institucion` (`id_institucion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `grupo_campania`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `grupo_campania` ;

CREATE TABLE IF NOT EXISTS `grupo_campania` (
  `id_grupo` INT(10) UNSIGNED NOT NULL,
  `id_campania` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_grupo`, `id_campania`),
  INDEX `fk_grupo_campania_campania1_idx` (`id_campania` ASC),
  INDEX `fk_grupo_campania_grupo_idx` (`id_grupo` ASC),
  CONSTRAINT `fk_grupo_campania_grupo`
    FOREIGN KEY (`id_grupo`)
    REFERENCES `grupo` (`id_grupo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_grupo_campania_campania1`
    FOREIGN KEY (`id_campania`)
    REFERENCES `campania` (`id_campania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci;


-- -----------------------------------------------------
-- Table `grupo_contacto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `grupo_contacto` ;

CREATE TABLE IF NOT EXISTS `grupo_contacto` (
  `id_grupo` INT(10) UNSIGNED NOT NULL,
  `id_contacto` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_grupo`, `id_contacto`),
  INDEX `fk_grupo_contacto_contacto1_idx` (`id_contacto` ASC),
  INDEX `fk_grupo_contacto_grupo1_idx` (`id_grupo` ASC),
  CONSTRAINT `fk_grupo_contacto_grupo1`
    FOREIGN KEY (`id_grupo`)
    REFERENCES `grupo` (`id_grupo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_grupo_contacto_contacto1`
    FOREIGN KEY (`id_contacto`)
    REFERENCES `contacto` (`id_contacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci;


-- -----------------------------------------------------
-- Placeholder table for view `v_ausencia_por_grado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_ausencia_por_grado` (`id_respuesta` INT, `grado` INT, `ausencias` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_campania_por_departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_campania_por_departamento` (`total_encuestados` INT, `total_finalizados` INT, `representatividad` INT, `mes` INT, `anio` INT, `id_provincia` INT, `provincias` INT, `id_departamento` INT, `departamentos` INT, `instituciones` INT, `id_supervisor` INT, `matricula` INT, `abandono` INT, `riesgo_abandono` INT, `riesgo_repitencia` INT, `instituciones_abandono` INT, `instituciones_repitencia` INT, `aprobados` INT, `porcentaje_aprobados` INT, `aprobados_dificultad` INT, `porcentaje_aprobados_dificultad` INT, `desaprobados` INT, `porcentaje_desaprobados` INT, `instituciones_desaprobados` INT, `instituciones_aprobados_dificultad` INT, `inasistencia_docente` INT, `inasistencia_docente_mas_tres` INT, `cursos_inasistencia` INT, `instituciones_inasistencia_docente` INT, `inasistencia_alumnos` INT, `porcentaje_inasistencia_alumnos_enfermedad` INT, `porcentaje_inasistencia_alumnos_trabajo` INT, `porcentaje_inasistencia_alumnos_familiar` INT, `inasistencia_alumnos_mas_tres` INT, `instituciones_inasistencia_alumnos` INT, `solicitud_pase` INT, `ingresos` INT, `instituciones_ingresos` INT, `foco_uno` INT, `foco_dos_uno` INT, `foco_dos_dos` INT, `foco_tres` INT, `porcentaje_foco_uno` INT, `porcentaje_foco_dos_uno` INT, `porcentaje_foco_dos_dos` INT, `porcentaje_foco_tres` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_campania_por_provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_campania_por_provincia` (`total_encuestados` INT, `total_finalizados` INT, `representatividad` INT, `mes` INT, `anio` INT, `id_provincia` INT, `provincias` INT, `id_departamento` INT, `departamentos` INT, `instituciones` INT, `id_supervisor` INT, `matricula` INT, `abandono` INT, `riesgo_abandono` INT, `riesgo_repitencia` INT, `instituciones_abandono` INT, `instituciones_repitencia` INT, `aprobados` INT, `porcentaje_aprobados` INT, `aprobados_dificultad` INT, `porcentaje_aprobados_dificultad` INT, `desaprobados` INT, `porcentaje_desaprobados` INT, `instituciones_desaprobados` INT, `instituciones_aprobados_dificultad` INT, `inasistencia_docente` INT, `inasistencia_docente_mas_tres` INT, `cursos_inasistencia` INT, `instituciones_inasistencia_docente` INT, `inasistencia_alumnos` INT, `porcentaje_inasistencia_alumnos_enfermedad` INT, `porcentaje_inasistencia_alumnos_trabajo` INT, `porcentaje_inasistencia_alumnos_familiar` INT, `inasistencia_alumnos_mas_tres` INT, `instituciones_inasistencia_alumnos` INT, `solicitud_pase` INT, `ingresos` INT, `instituciones_ingresos` INT, `foco_uno` INT, `foco_dos_uno` INT, `foco_dos_dos` INT, `foco_tres` INT, `porcentaje_foco_uno` INT, `porcentaje_foco_dos_uno` INT, `porcentaje_foco_dos_dos` INT, `porcentaje_foco_tres` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_campania_por_supervisor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_campania_por_supervisor` (`total_encuestados` INT, `total_finalizados` INT, `representatividad` INT, `mes` INT, `anio` INT, `id_provincia` INT, `provincias` INT, `id_departamento` INT, `departamentos` INT, `instituciones` INT, `id_supervisor` INT, `matricula` INT, `abandono` INT, `riesgo_abandono` INT, `riesgo_repitencia` INT, `instituciones_abandono` INT, `instituciones_repitencia` INT, `aprobados` INT, `porcentaje_aprobados` INT, `aprobados_dificultad` INT, `porcentaje_aprobados_dificultad` INT, `desaprobados` INT, `porcentaje_desaprobados` INT, `instituciones_desaprobados` INT, `instituciones_aprobados_dificultad` INT, `inasistencia_docente` INT, `inasistencia_docente_mas_tres` INT, `cursos_inasistencia` INT, `instituciones_inasistencia_docente` INT, `inasistencia_alumnos` INT, `porcentaje_inasistencia_alumnos_enfermedad` INT, `porcentaje_inasistencia_alumnos_trabajo` INT, `porcentaje_inasistencia_alumnos_familiar` INT, `inasistencia_alumnos_mas_tres` INT, `instituciones_inasistencia_alumnos` INT, `solicitud_pase` INT, `ingresos` INT, `instituciones_ingresos` INT, `foco_uno` INT, `foco_dos_uno` INT, `foco_dos_dos` INT, `foco_tres` INT, `porcentaje_foco_uno` INT, `porcentaje_foco_dos_uno` INT, `porcentaje_foco_dos_dos` INT, `porcentaje_foco_tres` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_informe_campania_por_departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_informe_campania_por_departamento` (`total_encuestados` INT, `total_finalizados` INT, `representatividad` INT, `mes` INT, `anio` INT, `id_provincia` INT, `provincias` INT, `id_departamento` INT, `departamentos` INT, `instituciones` INT, `id_supervisor` INT, `matricula` INT, `abandono` INT, `riesgo_abandono` INT, `riesgo_repitencia` INT, `instituciones_abandono` INT, `instituciones_repitencia` INT, `aprobados` INT, `porcentaje_aprobados` INT, `aprobados_dificultad` INT, `porcentaje_aprobados_dificultad` INT, `desaprobados` INT, `porcentaje_desaprobados` INT, `instituciones_desaprobados` INT, `instituciones_aprobados_dificultad` INT, `inasistencia_docente` INT, `inasistencia_docente_mas_tres` INT, `cursos_inasistencia` INT, `instituciones_inasistencia_docente` INT, `inasistencia_alumnos` INT, `porcentaje_inasistencia_alumnos_enfermedad` INT, `porcentaje_inasistencia_alumnos_trabajo` INT, `porcentaje_inasistencia_alumnos_familiar` INT, `inasistencia_alumnos_mas_tres` INT, `instituciones_inasistencia_alumnos` INT, `solicitud_pase` INT, `ingresos` INT, `instituciones_ingresos` INT, `foco_uno` INT, `foco_dos_uno` INT, `foco_dos_dos` INT, `foco_tres` INT, `porcentaje_foco_uno` INT, `porcentaje_foco_dos_uno` INT, `porcentaje_foco_dos_dos` INT, `porcentaje_foco_tres` INT, `abandono_anterior` INT, `abandono_acumulado` INT, `riesgo_abandono_anterior` INT, `riesgo_abandono_acumulado` INT, `riesgo_repitencia_anterior` INT, `riesgo_repitencia_acumulado` INT, `aprobados_anterior` INT, `porcentaje_aprobados_anterior` INT, `aprobados_dificultad_anterior` INT, `porcentaje_aprobados_dificultad_anterior` INT, `desaprobados_anterior` INT, `porcentaje_desaprobados_anterior` INT, `inasistencia_docente_anterior` INT, `inasistencia_docente_acumulado` INT, `inasistencia_docente_mas_tres_anterior` INT, `inasistencia_docente_mas_tres_acumulado` INT, `inasistencia_alumnos_anterior` INT, `inasistencia_alumnos_acumulado` INT, `inasistencia_alumnos_mas_tres_anterior` INT, `inasistencia_alumnos_mas_tres_acumulado` INT, `solicitud_pase_anterior` INT, `solicitud_pase_acumulado` INT, `ingresos_anterior` INT, `ingresos_acumulado` INT, `foco_uno_anterior` INT, `foco_dos_uno_anterior` INT, `foco_dos_dos_anterior` INT, `foco_tres_anterior` INT, `porcentaje_foco_uno_anterior` INT, `porcentaje_foco_dos_uno_anterior` INT, `porcentaje_foco_dos_dos_anterior` INT, `porcentaje_foco_tres_anterior` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_informe_campania_por_provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_informe_campania_por_provincia` (`total_encuestados` INT, `total_finalizados` INT, `representatividad` INT, `mes` INT, `anio` INT, `id_provincia` INT, `provincias` INT, `id_departamento` INT, `departamentos` INT, `instituciones` INT, `id_supervisor` INT, `matricula` INT, `abandono` INT, `riesgo_abandono` INT, `riesgo_repitencia` INT, `instituciones_abandono` INT, `instituciones_repitencia` INT, `aprobados` INT, `porcentaje_aprobados` INT, `aprobados_dificultad` INT, `porcentaje_aprobados_dificultad` INT, `desaprobados` INT, `porcentaje_desaprobados` INT, `instituciones_desaprobados` INT, `instituciones_aprobados_dificultad` INT, `inasistencia_docente` INT, `inasistencia_docente_mas_tres` INT, `cursos_inasistencia` INT, `instituciones_inasistencia_docente` INT, `inasistencia_alumnos` INT, `porcentaje_inasistencia_alumnos_enfermedad` INT, `porcentaje_inasistencia_alumnos_trabajo` INT, `porcentaje_inasistencia_alumnos_familiar` INT, `inasistencia_alumnos_mas_tres` INT, `instituciones_inasistencia_alumnos` INT, `solicitud_pase` INT, `ingresos` INT, `instituciones_ingresos` INT, `foco_uno` INT, `foco_dos_uno` INT, `foco_dos_dos` INT, `foco_tres` INT, `porcentaje_foco_uno` INT, `porcentaje_foco_dos_uno` INT, `porcentaje_foco_dos_dos` INT, `porcentaje_foco_tres` INT, `abandono_anterior` INT, `abandono_acumulado` INT, `riesgo_abandono_anterior` INT, `riesgo_abandono_acumulado` INT, `riesgo_repitencia_anterior` INT, `riesgo_repitencia_acumulado` INT, `aprobados_anterior` INT, `porcentaje_aprobados_anterior` INT, `aprobados_dificultad_anterior` INT, `porcentaje_aprobados_dificultad_anterior` INT, `desaprobados_anterior` INT, `porcentaje_desaprobados_anterior` INT, `inasistencia_docente_anterior` INT, `inasistencia_docente_acumulado` INT, `inasistencia_docente_mas_tres_anterior` INT, `inasistencia_docente_mas_tres_acumulado` INT, `inasistencia_alumnos_anterior` INT, `inasistencia_alumnos_acumulado` INT, `inasistencia_alumnos_mas_tres_anterior` INT, `inasistencia_alumnos_mas_tres_acumulado` INT, `solicitud_pase_anterior` INT, `solicitud_pase_acumulado` INT, `ingresos_anterior` INT, `ingresos_acumulado` INT, `foco_uno_anterior` INT, `foco_dos_uno_anterior` INT, `foco_dos_dos_anterior` INT, `foco_tres_anterior` INT, `porcentaje_foco_uno_anterior` INT, `porcentaje_foco_dos_uno_anterior` INT, `porcentaje_foco_dos_dos_anterior` INT, `porcentaje_foco_tres_anterior` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_informe_campania_por_supervisor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_informe_campania_por_supervisor` (`total_encuestados` INT, `total_finalizados` INT, `representatividad` INT, `mes` INT, `anio` INT, `id_provincia` INT, `provincias` INT, `id_departamento` INT, `departamentos` INT, `instituciones` INT, `id_supervisor` INT, `matricula` INT, `abandono` INT, `riesgo_abandono` INT, `riesgo_repitencia` INT, `instituciones_abandono` INT, `instituciones_repitencia` INT, `aprobados` INT, `porcentaje_aprobados` INT, `aprobados_dificultad` INT, `porcentaje_aprobados_dificultad` INT, `desaprobados` INT, `porcentaje_desaprobados` INT, `instituciones_desaprobados` INT, `instituciones_aprobados_dificultad` INT, `inasistencia_docente` INT, `inasistencia_docente_mas_tres` INT, `cursos_inasistencia` INT, `instituciones_inasistencia_docente` INT, `inasistencia_alumnos` INT, `porcentaje_inasistencia_alumnos_enfermedad` INT, `porcentaje_inasistencia_alumnos_trabajo` INT, `porcentaje_inasistencia_alumnos_familiar` INT, `inasistencia_alumnos_mas_tres` INT, `instituciones_inasistencia_alumnos` INT, `solicitud_pase` INT, `ingresos` INT, `instituciones_ingresos` INT, `foco_uno` INT, `foco_dos_uno` INT, `foco_dos_dos` INT, `foco_tres` INT, `porcentaje_foco_uno` INT, `porcentaje_foco_dos_uno` INT, `porcentaje_foco_dos_dos` INT, `porcentaje_foco_tres` INT, `abandono_anterior` INT, `abandono_acumulado` INT, `riesgo_abandono_anterior` INT, `riesgo_abandono_acumulado` INT, `riesgo_repitencia_anterior` INT, `riesgo_repitencia_acumulado` INT, `aprobados_anterior` INT, `porcentaje_aprobados_anterior` INT, `aprobados_dificultad_anterior` INT, `porcentaje_aprobados_dificultad_anterior` INT, `desaprobados_anterior` INT, `porcentaje_desaprobados_anterior` INT, `inasistencia_docente_anterior` INT, `inasistencia_docente_acumulado` INT, `inasistencia_docente_mas_tres_anterior` INT, `inasistencia_docente_mas_tres_acumulado` INT, `inasistencia_alumnos_anterior` INT, `inasistencia_alumnos_acumulado` INT, `inasistencia_alumnos_mas_tres_anterior` INT, `inasistencia_alumnos_mas_tres_acumulado` INT, `solicitud_pase_anterior` INT, `solicitud_pase_acumulado` INT, `ingresos_anterior` INT, `ingresos_acumulado` INT, `foco_uno_anterior` INT, `foco_dos_uno_anterior` INT, `foco_dos_dos_anterior` INT, `foco_tres_anterior` INT, `porcentaje_foco_uno_anterior` INT, `porcentaje_foco_dos_uno_anterior` INT, `porcentaje_foco_dos_dos_anterior` INT, `porcentaje_foco_tres_anterior` INT);

-- -----------------------------------------------------
-- Placeholder table for view `v_respuestas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `v_respuestas` (`id_registro_temporal` INT, `tipo_operacion` INT, `mes` INT, `anio` INT, `es_mensual` INT, `id_provincia` INT, `nombre_provincia` INT, `id_departamento` INT, `nombre_departamento` INT, `id_institucion` INT, `cue` INT, `id_supervisor` INT, `id_respuesta` INT, `valor` INT, `codigo_mensaje` INT);

-- -----------------------------------------------------
-- View `v_ausencia_por_grado`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_ausencia_por_grado` ;
DROP TABLE IF EXISTS `v_ausencia_por_grado`;
Create or replace view v_ausencia_por_grado (
id_respuesta, grado, ausencias
)
as
SELECT resp.id_respuesta, '1' as grado,
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '1', '')), 0))) as cantidad_ausencias
FROM respuesta resp
join mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '2',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '2', '')), 0))) as cantidad_ausencias
FROM respuesta resp
join mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '3',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '3', '')), 0))) as cantidad_ausencias
FROM respuesta resp
join mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '4',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '4', '')), 0))) as cantidad_ausencias
FROM respuesta resp
join mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '5',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '5', '')), 0))) as cantidad_ausencias
FROM respuesta resp
join mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '6',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '6', '')), 0))) as cantidad_ausencias
FROM respuesta resp
join mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE'
union all
SELECT resp.id_respuesta, '7',
    ((IF(msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE', LENGTH(resp.valor) - LENGTH(REPLACE(resp.valor, '7', '')), 0))) as cantidad_ausencias
FROM respuesta resp
join mensaje_campania msj_camp on resp.id_mensaje_campania = msj_camp.id_mensaje_campania and msj_camp.codigo_mensaje = 'INASISTENCIASDOCENTE';

-- -----------------------------------------------------
-- View `v_campania_por_departamento`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_campania_por_departamento` ;
DROP TABLE IF EXISTS `v_campania_por_departamento`;
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
        sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) AS `matricula`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'),
            `resp`.`valor`,
            0)) AS `abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'),
            `resp`.`valor`,
            0)) AS `riesgo_abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOREPITENCIA'),
            `resp`.`valor`,
            0)) AS `riesgo_repitencia`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_abandono`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_repitencia`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0))) AS `aprobados`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'),
            `resp`.`valor`,
            0)) AS `aprobados_dificultad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados_dificultad`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0)) AS `desaprobados`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS')
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
                            ((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_aprobados_dificultad`,
        sum(aus.ausencias) AS `inasistencia_docente`,
        ((((((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '7', ''))),
            0)) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '6', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '5', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '4', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '3', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '2', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '1', ''))),
            0))) AS `inasistencia_docente_mas_tres`,
        group_concat(distinct `aus`.`grado`
            order by `aus`.`ausencias` DESC
            separator ',') AS `cursos_inasistencia`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTE')
                                and (`resp`.`valor` <> '0'))
                        then
                            `ins`.`cue`
                    end)
                    order by length(ltrim(rtrim(`resp`.`valor`))) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_docente`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASENFERMEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_enfermedad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASTRABAJO'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_trabajo`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASPROBLEMASFAMILIARES'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_familiar`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASMASDETRES'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos_mas_tres`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_alumnos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESO'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'),
            `resp`.`valor`,
            0))) AS `solicitud_pase`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INGRESO'),
            `resp`.`valor`,
            0)) AS `ingresos`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INGRESO')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_ingresos`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
            `resp`.`valor`,
            0)) AS `foco_uno`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
            `resp`.`valor`,
            0)) AS `foco_dos_uno`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
            `resp`.`valor`,
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
            `resp`.`valor`,
            0)))) AS `foco_dos_dos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0))) AS `foco_tres`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_uno`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_uno`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
                `resp`.`valor`,
                0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
                `resp`.`valor`,
                0)))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_dos`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
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

-- -----------------------------------------------------
-- View `v_campania_por_provincia`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_campania_por_provincia` ;
DROP TABLE IF EXISTS `v_campania_por_provincia`;
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
        sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) AS `matricula`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'),
            `resp`.`valor`,
            0)) AS `abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'),
            `resp`.`valor`,
            0)) AS `riesgo_abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOREPITENCIA'),
            `resp`.`valor`,
            0)) AS `riesgo_repitencia`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_abandono`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_repitencia`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0))) AS `aprobados`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'),
            `resp`.`valor`,
            0)) AS `aprobados_dificultad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados_dificultad`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0)) AS `desaprobados`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS')
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
                            ((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_aprobados_dificultad`,
        sum(aus.ausencias) AS `inasistencia_docente`,
        ((((((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '7', ''))),
            0)) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '6', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '5', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '4', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '3', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '2', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '1', ''))),
            0))) AS `inasistencia_docente_mas_tres`,
        group_concat(distinct `aus`.`grado`
            order by `aus`.`ausencias` DESC
            separator ',') AS `cursos_inasistencia`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTE')
                                and (`resp`.`valor` <> '0'))
                        then
                            `ins`.`cue`
                    end)
                    order by length(ltrim(rtrim(`resp`.`valor`))) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_docente`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASENFERMEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_enfermedad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASTRABAJO'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_trabajo`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASPROBLEMASFAMILIARES'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_familiar`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASMASDETRES'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos_mas_tres`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_alumnos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESO'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'),
            `resp`.`valor`,
            0))) AS `solicitud_pase`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INGRESO'),
            `resp`.`valor`,
            0)) AS `ingresos`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INGRESO')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_ingresos`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
            `resp`.`valor`,
            0)) AS `foco_uno`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
            `resp`.`valor`,
            0)) AS `foco_dos_uno`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
            `resp`.`valor`,
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
            `resp`.`valor`,
            0)))) AS `foco_dos_dos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0))) AS `foco_tres`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_uno`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_uno`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
                `resp`.`valor`,
                0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
                `resp`.`valor`,
                0)))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_dos`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
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

-- -----------------------------------------------------
-- View `v_campania_por_supervisor`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_campania_por_supervisor` ;
DROP TABLE IF EXISTS `v_campania_por_supervisor`;
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
        sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) AS `matricula`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'),
            `resp`.`valor`,
            0)) AS `abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO'),
            `resp`.`valor`,
            0)) AS `riesgo_abandono`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'RIESGOREPITENCIA'),
            `resp`.`valor`,
            0)) AS `riesgo_repitencia`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_abandono`,
        group_concat(distinct (case
                when
                    ((`msj_camp`.`codigo_mensaje` = 'RIESGOABANDONO')
                        and (`resp`.`valor` > 0))
                then
                    `ins`.`cue`
            end)
            order by cast(`resp`.`valor` as unsigned) ASC
            separator ', ') AS `instituciones_repitencia`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0))) AS `aprobados`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'),
            `resp`.`valor`,
            0)) AS `aprobados_dificultad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_aprobados_dificultad`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0)) AS `desaprobados`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_desaprobados`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS')
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
                            ((`msj_camp`.`codigo_mensaje` = 'APROBADOSMALDESEMPEÑO')
                                and (`resp`.`valor` > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) ASC
                    separator ', '),
                ',',
                10) AS `instituciones_aprobados_dificultad`,
        sum(aus.ausencias) AS `inasistencia_docente`,
        ((((((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '7', ''))),
            0)) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '6', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '5', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '4', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '3', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '2', ''))),
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTEMASDETRES'),
            (length(`resp`.`valor`) - length(replace(`resp`.`valor`, '1', ''))),
            0))) AS `inasistencia_docente_mas_tres`,
        group_concat(distinct `aus`.`grado`
            order by `aus`.`ausencias` DESC
            separator ',') AS `cursos_inasistencia`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASDOCENTE')
                                and (`resp`.`valor` <> '0'))
                        then
                            `ins`.`cue`
                    end)
                    order by length(ltrim(rtrim(`resp`.`valor`))) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_docente`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASENFERMEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_enfermedad`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASTRABAJO'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_trabajo`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASPROBLEMASFAMILIARES'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_inasistencia_alumnos_familiar`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INASISTENCIASMASDETRES'),
            `resp`.`valor`,
            0)) AS `inasistencia_alumnos_mas_tres`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INASISTENCIAS')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_inasistencia_alumnos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESO'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'EGRESOSINPASE'),
            `resp`.`valor`,
            0))) AS `solicitud_pase`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'INGRESO'),
            `resp`.`valor`,
            0)) AS `ingresos`,
        substring_index(group_concat(distinct (case
                        when
                            ((`msj_camp`.`codigo_mensaje` = 'INGRESO')
                                and (cast(`resp`.`valor` as unsigned) > 0))
                        then
                            `ins`.`cue`
                    end)
                    order by cast(`resp`.`valor` as unsigned) DESC
                    separator ', '),
                ',',
                10) AS `instituciones_ingresos`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
            `resp`.`valor`,
            0)) AS `foco_uno`,
        sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
            `resp`.`valor`,
            0)) AS `foco_dos_uno`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
            `resp`.`valor`,
            0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
            `resp`.`valor`,
            0)))) AS `foco_dos_dos`,
        (sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
            `resp`.`valor`,
            0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
            `resp`.`valor`,
            0))) AS `foco_tres`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_uno`,
        truncate(((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
                `resp`.`valor`,
                0)) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_uno`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0)) - ((sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRES'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSSOBREEDAD'),
                `resp`.`valor`,
                0))) + sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOSINASISTENCIASMASDETRESSOBREEDAD'),
                `resp`.`valor`,
                0)))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0))) * 100),
            2) AS `porcentaje_foco_dos_dos`,
        truncate((((sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
                `resp`.`valor`,
                0)) - sum(if((`msj_camp`.`codigo_mensaje` = 'DESAPROBADOS'),
                `resp`.`valor`,
                0))) / sum(if((`msj_camp`.`codigo_mensaje` = 'MATRICULA'),
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

-- -----------------------------------------------------
-- View `v_informe_campania_por_departamento`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_informe_campania_por_departamento` ;
DROP TABLE IF EXISTS `v_informe_campania_por_departamento`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_informe_campania_por_departamento` AS select `prov`.`total_encuestados` AS `total_encuestados`,`prov`.`total_finalizados` AS `total_finalizados`,`prov`.`representatividad` AS `representatividad`,`prov`.`mes` AS `mes`,`prov`.`anio` AS `anio`,`prov`.`id_provincia` AS `id_provincia`,`prov`.`provincias` AS `provincias`,`prov`.`id_departamento` AS `id_departamento`,`prov`.`departamentos` AS `departamentos`,`prov`.`instituciones` AS `instituciones`,`prov`.`id_supervisor` AS `id_supervisor`,`prov`.`matricula` AS `matricula`,`prov`.`abandono` AS `abandono`,`prov`.`riesgo_abandono` AS `riesgo_abandono`,`prov`.`riesgo_repitencia` AS `riesgo_repitencia`,`prov`.`instituciones_abandono` AS `instituciones_abandono`,`prov`.`instituciones_repitencia` AS `instituciones_repitencia`,`prov`.`aprobados` AS `aprobados`,`prov`.`porcentaje_aprobados` AS `porcentaje_aprobados`,`prov`.`aprobados_dificultad` AS `aprobados_dificultad`,`prov`.`porcentaje_aprobados_dificultad` AS `porcentaje_aprobados_dificultad`,`prov`.`desaprobados` AS `desaprobados`,`prov`.`porcentaje_desaprobados` AS `porcentaje_desaprobados`,`prov`.`instituciones_desaprobados` AS `instituciones_desaprobados`,`prov`.`instituciones_aprobados_dificultad` AS `instituciones_aprobados_dificultad`,`prov`.`inasistencia_docente` AS `inasistencia_docente`,`prov`.`inasistencia_docente_mas_tres` AS `inasistencia_docente_mas_tres`,`prov`.`cursos_inasistencia` AS `cursos_inasistencia`,`prov`.`instituciones_inasistencia_docente` AS `instituciones_inasistencia_docente`,`prov`.`inasistencia_alumnos` AS `inasistencia_alumnos`,`prov`.`porcentaje_inasistencia_alumnos_enfermedad` AS `porcentaje_inasistencia_alumnos_enfermedad`,`prov`.`porcentaje_inasistencia_alumnos_trabajo` AS `porcentaje_inasistencia_alumnos_trabajo`,`prov`.`porcentaje_inasistencia_alumnos_familiar` AS `porcentaje_inasistencia_alumnos_familiar`,`prov`.`inasistencia_alumnos_mas_tres` AS `inasistencia_alumnos_mas_tres`,`prov`.`instituciones_inasistencia_alumnos` AS `instituciones_inasistencia_alumnos`,`prov`.`solicitud_pase` AS `solicitud_pase`,`prov`.`ingresos` AS `ingresos`,`prov`.`instituciones_ingresos` AS `instituciones_ingresos`,`prov`.`foco_uno` AS `foco_uno`,`prov`.`foco_dos_uno` AS `foco_dos_uno`,`prov`.`foco_dos_dos` AS `foco_dos_dos`,`prov`.`foco_tres` AS `foco_tres`,`prov`.`porcentaje_foco_uno` AS `porcentaje_foco_uno`,`prov`.`porcentaje_foco_dos_uno` AS `porcentaje_foco_dos_uno`,`prov`.`porcentaje_foco_dos_dos` AS `porcentaje_foco_dos_dos`,`prov`.`porcentaje_foco_tres` AS `porcentaje_foco_tres`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`abandono`,0)) AS `abandono_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`abandono`,0)) AS `abandono_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`riesgo_abandono`,0)) AS `riesgo_abandono_anterior`,'--' AS `riesgo_abandono_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`riesgo_repitencia`,0)) AS `riesgo_repitencia_anterior`,'--' AS `riesgo_repitencia_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`aprobados`,0)) AS `aprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_aprobados`,0)) AS `porcentaje_aprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`aprobados_dificultad`,0)) AS `aprobados_dificultad_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_aprobados_dificultad`,0)) AS `porcentaje_aprobados_dificultad_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`desaprobados`,0)) AS `desaprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_desaprobados`,0)) AS `porcentaje_desaprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_docente`,0)) AS `inasistencia_docente_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_docente`,0)) AS `inasistencia_docente_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_docente_mas_tres`,0)) AS `inasistencia_docente_mas_tres_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_docente_mas_tres`,0)) AS `inasistencia_docente_mas_tres_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_alumnos`,0)) AS `inasistencia_alumnos_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_alumnos`,0)) AS `inasistencia_alumnos_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_alumnos_mas_tres`,0)) AS `inasistencia_alumnos_mas_tres_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_alumnos_mas_tres`,0)) AS `inasistencia_alumnos_mas_tres_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`solicitud_pase`,0)) AS `solicitud_pase_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`solicitud_pase`,0)) AS `solicitud_pase_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`ingresos`,0)) AS `ingresos_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`ingresos`,0)) AS `ingresos_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_uno`,0)) AS `foco_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_dos_uno`,0)) AS `foco_dos_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_dos_dos`,0)) AS `foco_dos_dos_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_tres`,0)) AS `foco_tres_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_uno`,0)) AS `porcentaje_foco_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_dos_uno`,0)) AS `porcentaje_foco_dos_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_dos_dos`,0)) AS `porcentaje_foco_dos_dos_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_tres`,0)) AS `porcentaje_foco_tres_anterior` from (`v_campania_por_departamento` `prov` join `v_campania_por_departamento` `prov_ant` on(((`prov`.`id_provincia` = `prov_ant`.`id_provincia`) and (`prov`.`id_departamento` = `prov_ant`.`id_departamento`) and (`prov`.`anio` = `prov_ant`.`anio`)))) group by `prov`.`id_departamento`,`prov`.`id_provincia`,`prov`.`mes`,`prov`.`anio`;

-- -----------------------------------------------------
-- View `v_informe_campania_por_provincia`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_informe_campania_por_provincia` ;
DROP TABLE IF EXISTS `v_informe_campania_por_provincia`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_informe_campania_por_provincia` AS select `prov`.`total_encuestados` AS `total_encuestados`,`prov`.`total_finalizados` AS `total_finalizados`,`prov`.`representatividad` AS `representatividad`,`prov`.`mes` AS `mes`,`prov`.`anio` AS `anio`,`prov`.`id_provincia` AS `id_provincia`,`prov`.`provincias` AS `provincias`,`prov`.`id_departamento` AS `id_departamento`,`prov`.`departamentos` AS `departamentos`,`prov`.`instituciones` AS `instituciones`,`prov`.`id_supervisor` AS `id_supervisor`,`prov`.`matricula` AS `matricula`,`prov`.`abandono` AS `abandono`,`prov`.`riesgo_abandono` AS `riesgo_abandono`,`prov`.`riesgo_repitencia` AS `riesgo_repitencia`,`prov`.`instituciones_abandono` AS `instituciones_abandono`,`prov`.`instituciones_repitencia` AS `instituciones_repitencia`,`prov`.`aprobados` AS `aprobados`,`prov`.`porcentaje_aprobados` AS `porcentaje_aprobados`,`prov`.`aprobados_dificultad` AS `aprobados_dificultad`,`prov`.`porcentaje_aprobados_dificultad` AS `porcentaje_aprobados_dificultad`,`prov`.`desaprobados` AS `desaprobados`,`prov`.`porcentaje_desaprobados` AS `porcentaje_desaprobados`,`prov`.`instituciones_desaprobados` AS `instituciones_desaprobados`,`prov`.`instituciones_aprobados_dificultad` AS `instituciones_aprobados_dificultad`,`prov`.`inasistencia_docente` AS `inasistencia_docente`,`prov`.`inasistencia_docente_mas_tres` AS `inasistencia_docente_mas_tres`,`prov`.`cursos_inasistencia` AS `cursos_inasistencia`,`prov`.`instituciones_inasistencia_docente` AS `instituciones_inasistencia_docente`,`prov`.`inasistencia_alumnos` AS `inasistencia_alumnos`,`prov`.`porcentaje_inasistencia_alumnos_enfermedad` AS `porcentaje_inasistencia_alumnos_enfermedad`,`prov`.`porcentaje_inasistencia_alumnos_trabajo` AS `porcentaje_inasistencia_alumnos_trabajo`,`prov`.`porcentaje_inasistencia_alumnos_familiar` AS `porcentaje_inasistencia_alumnos_familiar`,`prov`.`inasistencia_alumnos_mas_tres` AS `inasistencia_alumnos_mas_tres`,`prov`.`instituciones_inasistencia_alumnos` AS `instituciones_inasistencia_alumnos`,`prov`.`solicitud_pase` AS `solicitud_pase`,`prov`.`ingresos` AS `ingresos`,`prov`.`instituciones_ingresos` AS `instituciones_ingresos`,`prov`.`foco_uno` AS `foco_uno`,`prov`.`foco_dos_uno` AS `foco_dos_uno`,`prov`.`foco_dos_dos` AS `foco_dos_dos`,`prov`.`foco_tres` AS `foco_tres`,`prov`.`porcentaje_foco_uno` AS `porcentaje_foco_uno`,`prov`.`porcentaje_foco_dos_uno` AS `porcentaje_foco_dos_uno`,`prov`.`porcentaje_foco_dos_dos` AS `porcentaje_foco_dos_dos`,`prov`.`porcentaje_foco_tres` AS `porcentaje_foco_tres`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`abandono`,0)) AS `abandono_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`abandono`,0)) AS `abandono_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`riesgo_abandono`,0)) AS `riesgo_abandono_anterior`,'--' AS `riesgo_abandono_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`riesgo_repitencia`,0)) AS `riesgo_repitencia_anterior`,'--' AS `riesgo_repitencia_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`aprobados`,0)) AS `aprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_aprobados`,0)) AS `porcentaje_aprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`aprobados_dificultad`,0)) AS `aprobados_dificultad_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_aprobados_dificultad`,0)) AS `porcentaje_aprobados_dificultad_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`desaprobados`,0)) AS `desaprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_desaprobados`,0)) AS `porcentaje_desaprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_docente`,0)) AS `inasistencia_docente_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_docente`,0)) AS `inasistencia_docente_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_docente_mas_tres`,0)) AS `inasistencia_docente_mas_tres_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_docente_mas_tres`,0)) AS `inasistencia_docente_mas_tres_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_alumnos`,0)) AS `inasistencia_alumnos_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_alumnos`,0)) AS `inasistencia_alumnos_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_alumnos_mas_tres`,0)) AS `inasistencia_alumnos_mas_tres_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_alumnos_mas_tres`,0)) AS `inasistencia_alumnos_mas_tres_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`solicitud_pase`,0)) AS `solicitud_pase_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`solicitud_pase`,0)) AS `solicitud_pase_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`ingresos`,0)) AS `ingresos_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`ingresos`,0)) AS `ingresos_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_uno`,0)) AS `foco_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_dos_uno`,0)) AS `foco_dos_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_dos_dos`,0)) AS `foco_dos_dos_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_tres`,0)) AS `foco_tres_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_uno`,0)) AS `porcentaje_foco_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_dos_uno`,0)) AS `porcentaje_foco_dos_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_dos_dos`,0)) AS `porcentaje_foco_dos_dos_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_tres`,0)) AS `porcentaje_foco_tres_anterior` from (`v_campania_por_provincia` `prov` join `v_campania_por_provincia` `prov_ant` on(((`prov`.`id_provincia` = `prov_ant`.`id_provincia`) and (`prov`.`anio` = `prov_ant`.`anio`)))) group by `prov`.`mes`,`prov`.`id_provincia`;

-- -----------------------------------------------------
-- View `v_informe_campania_por_supervisor`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_informe_campania_por_supervisor` ;
DROP TABLE IF EXISTS `v_informe_campania_por_supervisor`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_informe_campania_por_supervisor` AS select `prov`.`total_encuestados` AS `total_encuestados`,`prov`.`total_finalizados` AS `total_finalizados`,`prov`.`representatividad` AS `representatividad`,`prov`.`mes` AS `mes`,`prov`.`anio` AS `anio`,`prov`.`id_provincia` AS `id_provincia`,`prov`.`provincias` AS `provincias`,`prov`.`id_departamento` AS `id_departamento`,`prov`.`departamentos` AS `departamentos`,`prov`.`instituciones` AS `instituciones`,`prov`.`id_supervisor` AS `id_supervisor`,`prov`.`matricula` AS `matricula`,`prov`.`abandono` AS `abandono`,`prov`.`riesgo_abandono` AS `riesgo_abandono`,`prov`.`riesgo_repitencia` AS `riesgo_repitencia`,`prov`.`instituciones_abandono` AS `instituciones_abandono`,`prov`.`instituciones_repitencia` AS `instituciones_repitencia`,`prov`.`aprobados` AS `aprobados`,`prov`.`porcentaje_aprobados` AS `porcentaje_aprobados`,`prov`.`aprobados_dificultad` AS `aprobados_dificultad`,`prov`.`porcentaje_aprobados_dificultad` AS `porcentaje_aprobados_dificultad`,`prov`.`desaprobados` AS `desaprobados`,`prov`.`porcentaje_desaprobados` AS `porcentaje_desaprobados`,`prov`.`instituciones_desaprobados` AS `instituciones_desaprobados`,`prov`.`instituciones_aprobados_dificultad` AS `instituciones_aprobados_dificultad`,`prov`.`inasistencia_docente` AS `inasistencia_docente`,`prov`.`inasistencia_docente_mas_tres` AS `inasistencia_docente_mas_tres`,`prov`.`cursos_inasistencia` AS `cursos_inasistencia`,`prov`.`instituciones_inasistencia_docente` AS `instituciones_inasistencia_docente`,`prov`.`inasistencia_alumnos` AS `inasistencia_alumnos`,`prov`.`porcentaje_inasistencia_alumnos_enfermedad` AS `porcentaje_inasistencia_alumnos_enfermedad`,`prov`.`porcentaje_inasistencia_alumnos_trabajo` AS `porcentaje_inasistencia_alumnos_trabajo`,`prov`.`porcentaje_inasistencia_alumnos_familiar` AS `porcentaje_inasistencia_alumnos_familiar`,`prov`.`inasistencia_alumnos_mas_tres` AS `inasistencia_alumnos_mas_tres`,`prov`.`instituciones_inasistencia_alumnos` AS `instituciones_inasistencia_alumnos`,`prov`.`solicitud_pase` AS `solicitud_pase`,`prov`.`ingresos` AS `ingresos`,`prov`.`instituciones_ingresos` AS `instituciones_ingresos`,`prov`.`foco_uno` AS `foco_uno`,`prov`.`foco_dos_uno` AS `foco_dos_uno`,`prov`.`foco_dos_dos` AS `foco_dos_dos`,`prov`.`foco_tres` AS `foco_tres`,`prov`.`porcentaje_foco_uno` AS `porcentaje_foco_uno`,`prov`.`porcentaje_foco_dos_uno` AS `porcentaje_foco_dos_uno`,`prov`.`porcentaje_foco_dos_dos` AS `porcentaje_foco_dos_dos`,`prov`.`porcentaje_foco_tres` AS `porcentaje_foco_tres`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`abandono`,0)) AS `abandono_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`abandono`,0)) AS `abandono_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`riesgo_abandono`,0)) AS `riesgo_abandono_anterior`,'--' AS `riesgo_abandono_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`riesgo_repitencia`,0)) AS `riesgo_repitencia_anterior`,'--' AS `riesgo_repitencia_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`aprobados`,0)) AS `aprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_aprobados`,0)) AS `porcentaje_aprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`aprobados_dificultad`,0)) AS `aprobados_dificultad_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_aprobados_dificultad`,0)) AS `porcentaje_aprobados_dificultad_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`desaprobados`,0)) AS `desaprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_desaprobados`,0)) AS `porcentaje_desaprobados_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_docente`,0)) AS `inasistencia_docente_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_docente`,0)) AS `inasistencia_docente_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_docente_mas_tres`,0)) AS `inasistencia_docente_mas_tres_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_docente_mas_tres`,0)) AS `inasistencia_docente_mas_tres_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_alumnos`,0)) AS `inasistencia_alumnos_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_alumnos`,0)) AS `inasistencia_alumnos_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`inasistencia_alumnos_mas_tres`,0)) AS `inasistencia_alumnos_mas_tres_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`inasistencia_alumnos_mas_tres`,0)) AS `inasistencia_alumnos_mas_tres_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`solicitud_pase`,0)) AS `solicitud_pase_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`solicitud_pase`,0)) AS `solicitud_pase_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`ingresos`,0)) AS `ingresos_anterior`,sum(if((`prov_ant`.`mes` <= `prov`.`mes`),`prov_ant`.`ingresos`,0)) AS `ingresos_acumulado`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_uno`,0)) AS `foco_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_dos_uno`,0)) AS `foco_dos_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_dos_dos`,0)) AS `foco_dos_dos_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`foco_tres`,0)) AS `foco_tres_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_uno`,0)) AS `porcentaje_foco_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_dos_uno`,0)) AS `porcentaje_foco_dos_uno_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_dos_dos`,0)) AS `porcentaje_foco_dos_dos_anterior`,sum(if((`prov_ant`.`mes` = (`prov`.`mes` - 1)),`prov_ant`.`porcentaje_foco_tres`,0)) AS `porcentaje_foco_tres_anterior` from (`v_campania_por_departamento` `prov` join `v_campania_por_departamento` `prov_ant` on(((`prov`.`id_provincia` = `prov_ant`.`id_provincia`) and (`prov`.`id_supervisor` = `prov_ant`.`id_supervisor`)))) group by `prov`.`id_supervisor`,`prov`.`mes`,`prov`.`anio`;

-- -----------------------------------------------------
-- View `v_respuestas`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `v_respuestas` ;
DROP TABLE IF EXISTS `v_respuestas`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_respuestas` AS select `reg`.`id_registro_temporal` AS `id_registro_temporal`,`reg`.`tipo_operacion` AS `tipo_operacion`,`camp`.`mes` AS `mes`,`camp`.`anio` AS `anio`,`camp`.`es_mensual` AS `es_mensual`,`prov`.`id_provincia` AS `id_provincia`,`prov`.`nombre` AS `nombre_provincia`,`dto`.`id_departamento` AS `id_departamento`,`dto`.`nombre` AS `nombre_departamento`,`ins`.`id_institucion` AS `id_institucion`,`ins`.`cue` AS `cue`,`ins`.`id_supervisor` AS `id_supervisor`,`resp`.`id_respuesta` AS `id_respuesta`,`resp`.`valor` AS `valor`,`msj_camp`.`codigo_mensaje` AS `codigo_mensaje` from (((((((`registro_temporal` `reg` join `institucion` `ins` on((`reg`.`id_contacto` = `ins`.`id_director`))) join `respuesta` `resp` on(((`reg`.`id_registro_temporal` = `resp`.`id_registro_temporal`) and (`resp`.`id_institucion` = `ins`.`id_institucion`)))) join `mensaje_campania` `msj_camp` on((`resp`.`id_mensaje_campania` = `msj_camp`.`id_mensaje_campania`))) join `campania` `camp` on((`msj_camp`.`id_campania` = `camp`.`id_campania`))) join `departamento` `dto` on((`ins`.`id_departamento` = `dto`.`id_departamento`))) join `provincia` `prov` on((`dto`.`id_provincia` = `prov`.`id_provincia`))) left join `v_ausencia_por_grado` `aus` on((`resp`.`id_respuesta` = `aus`.`id_respuesta`))) where (`camp`.`es_mensual` = 1) group by `reg`.`id_registro_temporal`,`msj_camp`.`id_mensaje_campania`,`camp`.`mes`,`camp`.`anio`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
