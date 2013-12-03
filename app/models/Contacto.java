package models;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import models.contacto.grupo.Grupo;
import models.modem.Modem;
import play.data.format.Formats.DateTime;
import play.data.validation.Constraints.Required;
import play.db.ebean.Model;
import play.mvc.Http.Context;
import seguridad.models.Usuario;
import ar.com.gemasms.modem.ModemCompuesto;

import com.avaje.ebean.Page;
import com.google.common.collect.Lists;

@Entity
@Table(name = "contacto")
public class Contacto extends Model {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_contacto")
	private Long id;

	@Column(name = "nombre")
	@Required
	private String nombre;

	@Column(name = "apellido")
	@Required
	private String apellido;

	@Column(name = "telefono")
	@Required
	private String telefono;

	@Column(name = "dni")
	private String dni;

	@ManyToMany(cascade = CascadeType.ALL, mappedBy = "contactos")
	private List<Grupo> grupos = Lists.newArrayList();

	@ManyToOne
	@JoinColumn(name = "id_modem", referencedColumnName = "id_modem")
	private Modem modem;

	@Column(name = "fecha_baja")
	@DateTime(pattern = "dd/MM/yyyy")
	private Date fechaBaja;

	@Column(name = "es_supervisor")
	private Boolean esSupervisor;

	public static Model.Finder<Long, Contacto> finder = new Model.Finder<Long, Contacto>(
			Long.class, Contacto.class);

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellido() {
		return apellido;
	}

	public void setApellido(String apellido) {
		this.apellido = apellido;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getDni() {
		return dni;
	}

	public void setDni(String dni) {
		this.dni = dni;
	}

	public static Contacto obtenerContactoDesdeTelefono(String telefono) {
		return finder
				.where()
				.iendsWith("telefono",
						telefono.substring(Math.max(0, telefono.length() - 6)))
				.findUnique();
	}

	public Modem getModem() {
		return modem;
	}

	public void setModem(Modem modem) {
		this.modem = modem;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public List<Grupo> getGrupos() {
		return grupos;
	}

	public void setGrupos(List<Grupo> grupo) {
		this.grupos = grupo;
	}

	public Boolean getEsSupervisor() {
		return esSupervisor;
	}

	public void setEsSupervisor(Boolean esSupervisor) {
		this.esSupervisor = esSupervisor;
	}

	@Transient
	public void enviarMensaje(String texto) {
		(this.modem == null ? new ModemCompuesto() : this.modem).enviarMensaje(
				this.getTelefono(), texto);
	}

	public static Page<Contacto> page(int page, int pageSize, String sortBy,
			String order, String filter) {
		return finder.where().ilike("apellido", "%" + filter + "%")
				.orderBy(sortBy + " " + order).fetch("modem")
				.findPagingList(pageSize).getPage(page);
	}

	public static Map<String, String> todosLosSupervisoresParaElUsuario(
			Usuario usuario) {
		Map<String, String> map = new HashMap<String, String>();

		Contacto contacto = finder
				.on(usuario == null ? "default" : usuario.getServer()).where()
				.eq("dni", Context.current().session().get("dni")).findUnique();
		if (contacto != null && contacto.esSupervisor) {
			map.put(contacto.getId().toString(), contacto.toString());
		} else {
			for (Contacto con : finder
					.on(usuario == null ? "default" : usuario.getServer())
					.where().eq("esSupervisor", Boolean.TRUE).findList()) {
				map.put(con.getId().toString(), con.toString());
			}
		}

		return map;
	}

	@Override
	public String toString() {
		return this.getNombre() + " " + this.getApellido() + " - DNI: "
				+ this.getDni();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((apellido == null) ? 0 : apellido.hashCode());
		result = prime * result + ((dni == null) ? 0 : dni.hashCode());
		result = prime * result + (int) (id ^ (id >>> 32));
		result = prime * result + ((nombre == null) ? 0 : nombre.hashCode());
		result = prime * result
				+ ((telefono == null) ? 0 : telefono.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (getClass() != obj.getClass())
			return false;
		Contacto other = (Contacto) obj;
		if (apellido == null) {
			if (other.apellido != null)
				return false;
		} else if (!apellido.equals(other.apellido))
			return false;
		if (dni == null) {
			if (other.dni != null)
				return false;
		} else if (!dni.equals(other.dni))
			return false;
		if (id != other.id)
			return false;
		if (nombre == null) {
			if (other.nombre != null)
				return false;
		} else if (!nombre.equals(other.nombre))
			return false;
		if (telefono == null) {
			if (other.telefono != null)
				return false;
		} else if (!telefono.equals(other.telefono))
			return false;
		return true;
	}
}
