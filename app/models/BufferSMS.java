package models;

import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import models.campania.Campania;
import models.mensaje.Mensaje;
import play.db.ebean.Model;
import ar.com.gemasms.util.EstadoBuffer;

@Entity
@Table(name = "buffer")
public class BufferSMS extends Model {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_buffer")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "id_campania", referencedColumnName = "id_campania")
	private Campania campania;

	@OneToOne
	@JoinColumn(name = "id_mensaje", referencedColumnName = "id_mensaje")
	private Mensaje mensaje;

	@Enumerated(EnumType.STRING)
	@Column(name = "estado")
	private EstadoBuffer estado;

	@Column(name = "timestamp_creacion")
	private Date horaCreacion;

	public static Model.Finder<String, BufferSMS> finder = new Model.Finder<String, BufferSMS>(
			String.class, BufferSMS.class);

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Campania getCampania() {
		return campania;
	}

	public void setCampania(Campania campania) {
		this.campania = campania;
	}

	public Mensaje getMensaje() {
		return mensaje;
	}

	public void setMensaje(Mensaje mensaje) {
		this.mensaje = mensaje;
	}

	public EstadoBuffer getEstado() {
		return this.estado;
	}

	public void setEstado(EstadoBuffer estado) {
		this.estado = estado;
	}

	public Date getHoraCreacion() {
		return horaCreacion;
	}

	public void setHoraCreacion(Date horaCreacion) {
		this.horaCreacion = horaCreacion;
	}

	public static List<BufferSMS> obtenerAProcesar(Campania campania) {
		return finder.where().eq("estado", EstadoBuffer.PROCESAR)
				.eq("campania", campania).orderBy("horaCreacion").findList();
	}

	public static List<BufferSMS> obtenerAEnviar(Campania campania) {
		return finder.where().eq("estado", EstadoBuffer.ENVIAR)
				.eq("campania", campania).orderBy("horaCreacion").findList();
	}

	public String getTelefono() {
		return this.mensaje.getTelefono();
	}

	public String getMensajeDeTexto() {
		return this.mensaje.getMensaje();
	}

	public void enviarMensaje() {
		this.mensaje.enviar();
	}
}
