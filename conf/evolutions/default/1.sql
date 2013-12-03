# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table buffer (
  id_buffer                 bigint auto_increment not null,
  id_campania               bigint,
  id_mensaje                bigint,
  estado                    varchar(1),
  timestamp_creacion        datetime,
  constraint ck_buffer_estado check (estado in ('P','E')),
  constraint pk_buffer primary key (id_buffer))
;

create table campania (
  id_campania               bigint auto_increment not null,
  mes                       integer,
  descripcion               varchar(255),
  constraint ck_campania_mes check (mes in ('8','4','5','1','3','12','7','2','10','11','9','6')),
  constraint pk_campania primary key (id_campania))
;

create table contacto (
  id_contacto               bigint auto_increment not null,
  nombre                    varchar(255),
  apellido                  varchar(255),
  telefono                  varchar(255),
  dni                       varchar(255),
  id_modem                  bigint,
  fecha_baja                datetime,
  constraint pk_contacto primary key (id_contacto))
;

create table grupo (
  id_grupo                  bigint auto_increment not null,
  nombre                    varchar(255),
  constraint pk_grupo primary key (id_grupo))
;

create table mensaje (
  id_mensaje                bigint auto_increment not null,
  id_contacto               bigint,
  valor                     varchar(255),
  direccion                 varchar(255),
  constraint pk_mensaje primary key (id_mensaje))
;

create table mensaje_campania (
  id_mensaje_campania       integer auto_increment not null,
  codigo_mensaje            varchar(255),
  texto_mensaje             varchar(255),
  tipo_mensaje              varchar(1),
  condiciones_entrada       varchar(255),
  numero_orden              integer,
  id_campania               bigint,
  validaciones              varchar(255),
  constraint ck_mensaje_campania_tipo_mensaje check (tipo_mensaje in ('N','P')),
  constraint pk_mensaje_campania primary key (id_mensaje_campania))
;

create table modem (
  id_modem                  bigint auto_increment not null,
  codigo                    varchar(255),
  descripcion               varchar(255),
  url                       varchar(255),
  fecha_baja                datetime,
  constraint pk_modem primary key (id_modem))
;

create table registro_temporal (
  id_registro_temporal      bigint auto_increment not null,
  id_contacto               bigint,
  id_campania               bigint,
  tipo_operacion            varchar(2),
  id_mensaje_campania       integer,
  buffer                    varchar(255),
  constraint ck_registro_temporal_tipo_operacion check (tipo_operacion in ('RM','ER','EM')),
  constraint pk_registro_temporal primary key (id_registro_temporal))
;

create table respuesta (
  id_respuesta              bigint auto_increment not null,
  id_mensaje                bigint,
  codigo_mensaje            varchar(255),
  id_contacto               bigint,
  id_registro_temporal      bigint,
  id_mensaje_campania       integer,
  constraint pk_respuesta primary key (id_respuesta))
;


create table grupo_contacto (
  id_grupo                       bigint not null,
  id_contacto                    bigint not null,
  constraint pk_grupo_contacto primary key (id_grupo, id_contacto))
;

create table grupo_campania (
  id_grupo                       bigint not null,
  id_campania                    bigint not null,
  constraint pk_grupo_campania primary key (id_grupo, id_campania))
;

create table mensaje_campania_siguiente (
  id_mensaje_campania            integer not null,
  id_siguiente_mensaje_campania  integer not null,
  constraint pk_mensaje_campania_siguiente primary key (id_mensaje_campania, id_siguiente_mensaje_campania))
;
alter table buffer add constraint fk_buffer_campania_1 foreign key (id_campania) references campania (id_campania) on delete restrict on update restrict;
create index ix_buffer_campania_1 on buffer (id_campania);
alter table buffer add constraint fk_buffer_mensaje_2 foreign key (id_mensaje) references mensaje (id_mensaje) on delete restrict on update restrict;
create index ix_buffer_mensaje_2 on buffer (id_mensaje);
alter table contacto add constraint fk_contacto_modem_3 foreign key (id_modem) references modem (id_modem) on delete restrict on update restrict;
create index ix_contacto_modem_3 on contacto (id_modem);
alter table mensaje add constraint fk_mensaje_contacto_4 foreign key (id_contacto) references contacto (id_contacto) on delete restrict on update restrict;
create index ix_mensaje_contacto_4 on mensaje (id_contacto);
alter table mensaje_campania add constraint fk_mensaje_campania_campania_5 foreign key (id_campania) references campania (id_campania) on delete restrict on update restrict;
create index ix_mensaje_campania_campania_5 on mensaje_campania (id_campania);
alter table registro_temporal add constraint fk_registro_temporal_contacto_6 foreign key (id_contacto) references contacto (id_contacto) on delete restrict on update restrict;
create index ix_registro_temporal_contacto_6 on registro_temporal (id_contacto);
alter table registro_temporal add constraint fk_registro_temporal_campania_7 foreign key (id_campania) references campania (id_campania) on delete restrict on update restrict;
create index ix_registro_temporal_campania_7 on registro_temporal (id_campania);
alter table registro_temporal add constraint fk_registro_temporal_mensaje_8 foreign key (id_mensaje_campania) references mensaje_campania (id_mensaje_campania) on delete restrict on update restrict;
create index ix_registro_temporal_mensaje_8 on registro_temporal (id_mensaje_campania);
alter table respuesta add constraint fk_respuesta_mensaje_9 foreign key (id_mensaje) references mensaje (id_mensaje) on delete restrict on update restrict;
create index ix_respuesta_mensaje_9 on respuesta (id_mensaje);
alter table respuesta add constraint fk_respuesta_contacto_10 foreign key (id_contacto) references contacto (id_contacto) on delete restrict on update restrict;
create index ix_respuesta_contacto_10 on respuesta (id_contacto);
alter table respuesta add constraint fk_respuesta_registro_11 foreign key (id_registro_temporal) references registro_temporal (id_registro_temporal) on delete restrict on update restrict;
create index ix_respuesta_registro_11 on respuesta (id_registro_temporal);
alter table respuesta add constraint fk_respuesta_mensajeCampania_12 foreign key (id_mensaje_campania) references mensaje_campania (id_mensaje_campania) on delete restrict on update restrict;
create index ix_respuesta_mensajeCampania_12 on respuesta (id_mensaje_campania);



alter table grupo_contacto add constraint fk_grupo_contacto_grupo_01 foreign key (id_grupo) references grupo (id_grupo) on delete restrict on update restrict;

alter table grupo_contacto add constraint fk_grupo_contacto_contacto_02 foreign key (id_contacto) references contacto (id_contacto) on delete restrict on update restrict;

alter table grupo_campania add constraint fk_grupo_campania_grupo_01 foreign key (id_grupo) references grupo (id_grupo) on delete restrict on update restrict;

alter table grupo_campania add constraint fk_grupo_campania_campania_02 foreign key (id_campania) references campania (id_campania) on delete restrict on update restrict;

alter table mensaje_campania_siguiente add constraint fk_mensaje_campania_siguiente_mensaje_campania_01 foreign key (id_mensaje_campania) references mensaje_campania (id_mensaje_campania) on delete restrict on update restrict;

alter table mensaje_campania_siguiente add constraint fk_mensaje_campania_siguiente_mensaje_campania_02 foreign key (id_siguiente_mensaje_campania) references mensaje_campania (id_mensaje_campania) on delete restrict on update restrict;

# --- !Downs

SET FOREIGN_KEY_CHECKS=0;

drop table buffer;

drop table campania;

drop table grupo_campania;

drop table contacto;

drop table grupo_contacto;

drop table grupo;

drop table mensaje;

drop table mensaje_campania;

drop table mensaje_campania_siguiente;

drop table modem;

drop table registro_temporal;

drop table respuesta;

SET FOREIGN_KEY_CHECKS=1;

