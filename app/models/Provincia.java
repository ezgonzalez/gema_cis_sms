package models;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import play.db.ebean.Model;
import seguridad.models.Usuario;

@Entity
@Table(name = "provincia")
public class Provincia extends Model {

	@Id
	@Column(name = "id_provincia")
	public Long id;

	@Column(name = "nombre")
	public String nombre;

	@OneToMany(mappedBy = "provincia")
	public List<Departamento> departamentos;

	public static Model.Finder<Long, Provincia> finder = new Model.Finder<Long, Provincia>(
			Long.class, Provincia.class);

	public static Map<String, String> todasLasDelUsuario(Usuario usuario) {
		LinkedHashMap<String, String> options = new LinkedHashMap<String, String>();

		if (usuario != null) {
			Provincia provincia = finder.byId(usuario.idProvincia);
			options.put(provincia.id.toString(), provincia.nombre);
		}

		return options;
	}
}
