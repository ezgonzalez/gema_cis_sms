package models.campania;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import models.Contacto;
import models.campania.mensaje.MensajeCampania;
import models.campania.temporal.RegistroTemporal;
import models.contacto.grupo.Grupo;
import play.data.validation.Constraints.Required;
import play.db.ebean.Model;
import seguridad.models.Usuario;
import ar.com.gemasms.util.Mes;

import com.avaje.ebean.Page;
import com.google.common.collect.Lists;

import controllers.RegistroTemporalController;

@Entity
@Table(name = "campania")
public class Campania extends Model {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_campania")
	public Long id;

	@OneToMany(mappedBy = "campania", cascade = CascadeType.ALL)
	private List<MensajeCampania> mensajes = Lists.newArrayList();

	@ManyToMany(cascade = CascadeType.ALL, mappedBy = "campanias")
	private List<Grupo> grupo = Lists.newArrayList();

	@OneToMany(mappedBy = "campania", cascade = CascadeType.ALL)
	private List<RegistroTemporal> registros = new ArrayList<RegistroTemporal>();

	@Column(name = "mes")
	@Enumerated(value = EnumType.STRING)
	private Mes mes;

	@Column(name = "anio")
	private String anio;

	@Column(name = "descripcion")
	@Required
	private String descripcion;

	public static Model.Finder<Long, Campania> finder = new Model.Finder<Long, Campania>(
			Long.class, Campania.class);

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public List<MensajeCampania> getMensajes() {
		return mensajes;
	}

	public void setMensajes(List<MensajeCampania> mensajes) {
		this.mensajes = mensajes;
	}

	public List<Grupo> getGrupo() {
		return grupo;
	}

	public void setGrupo(List<Grupo> grupo) {
		this.grupo = grupo;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public List<RegistroTemporal> getRegistros() {
		return registros;
	}

	public void setRegistros(List<RegistroTemporal> registros) {
		this.registros = registros;
	}

	public Mes getMes() {
		return mes;
	}

	public void setMes(Mes mes) {
		this.mes = mes;
	}

	public String getAnio() {
		return anio;
	}

	public void setAnio(String anio) {
		this.anio = anio;
	}

	public String getMesCampania() {
		return this.mes != null ? this.mes.getNumero().toString() : "";
	}

	public void setMesCampania(String numero) {
		this.mes = Mes.meses().get(Integer.parseInt(numero) - 1);
	}

	public void agregarRegistros(List<RegistroTemporal> reporteTemporal) {
		this.registros.addAll(reporteTemporal);
	}

	public void ejecutar() {
		this.cargarRegistroTemporales();
	}

	protected void cargarRegistroTemporales() {
		Set<Contacto> contactos = new HashSet<Contacto>();

		for (Grupo grupo : this.getGrupo()) {
			contactos.addAll(grupo.getContactos());
		}

		this.setRegistros(RegistroTemporalController.crearRegistrosTemporales(
				this, contactos));
	}

	public boolean esUnContactoTuyo(Contacto contacto) {
		for (Grupo grupo : this.getGrupo()) {
			if (grupo.esTuContacto(contacto)) {
				return true;
			}
		}

		return false;
	}

	@Override
	public String toString() {
		return "Camp[" + Long.toString(this.id) + "]";
	}

	public static Page<Campania> page(int page, int pageSize, String sortBy,
			String order, String filter) {
		return finder.orderBy(sortBy + " " + order).findPagingList(pageSize)
				.getPage(page);
	}

	public static List<String> aniosHabilitados(Usuario usuario) {
		Set<String> anios = new HashSet<String>();
		for (Campania c : finder
				.on(usuario == null ? "default" : usuario.getServer()).where()
				.isNotNull("anio").findList()) {
			anios.add(c.getAnio());
		}

		return new ArrayList<String>(anios);
	}

	public static List<String> mesesHabilitados(Usuario usuario) {
		Set<String> anios = new HashSet<String>();
		for (Campania c : finder
				.on(usuario == null ? "default" : usuario.getServer()).where()
				.isNotNull("mes").findList()) {
			anios.add(c.getMes().getNumero().toString());
		}

		ArrayList<String> meses = new ArrayList<String>(anios);
		Collections.sort(meses);
		return meses;
	}

	public static Map<String, String> campaniasMensuales() {
		LinkedHashMap<String, String> options = new LinkedHashMap<String, String>();

		for (Campania c : finder.where().isNotNull("mes").orderBy("mes")
				.findList()) {
			options.put(c.getId().toString(),
					c.getMesCampania() + "-" + c.getDescripcion());
		}

		return options;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((anio == null) ? 0 : anio.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((mes == null) ? 0 : mes.hashCode());
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
		Campania other = (Campania) obj;
		if (anio == null) {
			if (other.anio != null)
				return false;
		} else if (!anio.equals(other.anio))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (mes != other.mes)
			return false;
		return true;
	}
}
