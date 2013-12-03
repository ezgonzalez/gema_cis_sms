package models.mensaje;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import models.Contacto;
import play.db.ebean.Model;

@Entity
@Table(name = "mensaje")
public class Mensaje extends Model {

	private static final long serialVersionUID = 1L;

	public static String DIRECCION_ENTRANTE = "E";

	public static String DIRECCION_SALIENTE = "S";

	@Transient
	private int indice;

	@Id
	@Column(name = "id_mensaje")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "id_contacto", referencedColumnName = "id_contacto")
	private Contacto contacto;

	@Column(name = "valor")
	private String mensaje;

	@Column(name = "direccion")
	private String direccion;

	public static Finder<Long, Mensaje> find = new Finder<Long, Mensaje>(
			Long.class, Mensaje.class);

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public int getIndice() {
		return indice;
	}

	public void setIndice(int indice) {
		this.indice = indice;
	}

	public String getTelefono() {
		return this.contacto != null ? this.contacto.getTelefono()
				: "<DESCONOCIDO>";
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}

	public Contacto getContacto() {
		return contacto;
	}

	public void setContacto(Contacto contacto) {
		this.contacto = contacto;
	}

	public boolean esTuContacto(Contacto contacto) {
		return contacto.equals(this.getContacto());
	}

	@Override
	public String toString() {
		return "Contacto: <" + this.getContacto() + "Telefono: <"
				+ this.getTelefono() + "> - Mensaje: <" + this.getMensaje()
				+ ">";
	}

	public void enviar() {
		this.getContacto().enviarMensaje(this.getMensaje());
	}
}
