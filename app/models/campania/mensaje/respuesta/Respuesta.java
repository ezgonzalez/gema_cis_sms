package models.campania.mensaje.respuesta;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import models.Contacto;
import models.Institucion;
import models.campania.Campania;
import models.campania.mensaje.MensajeCampania;
import models.campania.temporal.RegistroTemporal;
import models.mensaje.Mensaje;
import play.data.validation.Constraints.Required;
import play.db.ebean.Model;

@Entity
@Table(name = "respuesta")
public class Respuesta extends Model {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_respuesta")
	private long id;

	@OneToOne
	@JoinColumn(name = "id_mensaje", referencedColumnName = "id_mensaje")
	private Mensaje mensaje;

	@Column(name = "codigo_mensaje")
	@Required
	private String codigoMensaje;

	@ManyToOne
	@JoinColumn(name = "id_contacto", referencedColumnName = "id_contacto")
	private Contacto contacto;

	@ManyToOne
	@JoinColumn(name = "id_registro_temporal", referencedColumnName = "id_registro_temporal")
	private RegistroTemporal registro;

	@ManyToOne
	@JoinColumn(name = "id_mensaje_campania", referencedColumnName = "id_mensaje_campania")
	private MensajeCampania mensajeCampania;

	public static Model.Finder<String, Respuesta> find = new Model.Finder<String, Respuesta>(
			String.class, Respuesta.class);

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public MensajeCampania getMensajeCampania() {
		return mensajeCampania;
	}

	public void setMensajeCampania(MensajeCampania mensaje) {
		this.mensajeCampania = mensaje;
	}

	public String getRespuesta() {
		return this.mensaje.getMensaje();
	}

	public Mensaje getMensaje() {
		return this.mensaje;
	}

	public void setMensaje(Mensaje mensaje) {
		this.mensaje = mensaje;
	}

	public String getCodigoMensaje() {
		return codigoMensaje;
	}

	public void setCodigoMensaje(String codigoMensaje) {
		this.codigoMensaje = codigoMensaje;
	}

	public Contacto getContacto() {
		return contacto;
	}

	public void setContacto(Contacto contacto) {
		this.contacto = contacto;
	}

	public RegistroTemporal getRegistro() {
		return registro;
	}

	public void setRegistro(RegistroTemporal registro) {
		this.registro = registro;
	}

	@Override
	public String toString() {
		return this.getCodigoMensaje() + ": " + this.getRespuesta();
	}

	public static List<Respuesta> obtenerRespuestas(Campania campania,
			Institucion institucion) {
		return find.where().eq("campania", campania)
				.eq("institucion", institucion).findList();
	}
}
