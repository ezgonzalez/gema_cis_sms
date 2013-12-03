package models;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import play.db.ebean.Model;
import seguridad.models.Usuario;

@Entity
@Table(name = "departamento")
public class Departamento extends Model {

	@Id
	@Column(name = "id_departamento")
	public Long id;

	@Column(name = "nombre")
	public String nombre;

	@ManyToOne
	@JoinColumn(name = "id_provincia", referencedColumnName = "id_provincia")
	public Provincia provincia;

	public static Model.Finder<Long, Departamento> finder = new Model.Finder<Long, Departamento>(
			Long.class, Departamento.class);

	public static Map<String, String> todosLosDelUsuario(Usuario usuario) {
		Map<String, String> deptos = new HashMap<String, String>();

		if (usuario != null) {
			for (Departamento dto : finder.where()
					.eq("id_provincia", usuario.idProvincia).findList()) {
				deptos.put(dto.id.toString(), dto.provincia.nombre + " - "
						+ dto.nombre);
			}
		}

		return deptos;
	}
}
