package models.contacto.grupo;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;

import models.Contacto;
import models.campania.Campania;
import play.data.validation.Constraints.Required;
import play.db.ebean.Model;

import com.avaje.ebean.Page;

@Entity
@Table(name = "grupo")
public class Grupo extends Model {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_grupo")
	private Long id;

	@Column(name = "nombre")
	@Required
	private String nombre;

	@ManyToMany(cascade = CascadeType.PERSIST)
	@JoinTable(name = "grupo_contacto", joinColumns = @JoinColumn(name = "id_grupo", referencedColumnName = "id_grupo"), inverseJoinColumns = @JoinColumn(name = "id_contacto", referencedColumnName = "id_contacto"))
	private List<Contacto> contactos;

	@ManyToMany
	@JoinTable(name = "grupo_campania", joinColumns = @JoinColumn(name = "id_grupo", referencedColumnName = "id_grupo"), inverseJoinColumns = @JoinColumn(name = "id_campania", referencedColumnName = "id_campania"))
	private List<Campania> campanias;

	public static Model.Finder<Long, Grupo> finder = new Model.Finder<Long, Grupo>(
			Long.class, Grupo.class);

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

	public List<Contacto> getContactos() {
		return contactos;
	}

	public void setContactos(List<Contacto> contactos) {
		this.contactos = contactos;
	}

	public List<Campania> getCampanias() {
		return campanias;
	}

	public void setCampanias(List<Campania> campanias) {
		this.campanias = campanias;
	}

	public static Grupo obtenerGrupoPorID(String id) {
		return finder.byId(Long.parseLong(id));
	}

	public boolean esTuContacto(Contacto contacto) {
		if (contacto == null) {
			return false;
		}

		return this.contactos.contains(contacto);
	}

	public static Page<Grupo> page(int page, int pageSize, String sortBy,
			String order, String filter) {
		return finder.where().ilike("nombre", "%" + filter + "%")
				.orderBy(sortBy + " " + order).findPagingList(pageSize)
				.getPage(page);
	}

	public static List<Grupo> todos() {
		return finder.all();
	}
}
