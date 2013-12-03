package seguridad.models;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import play.data.format.Formats;
import play.data.validation.Constraints;
import play.db.ebean.Model;

/**
 * User entity managed by Ebean
 */
@Entity
@Table(name = "usuario")
public class Usuario extends Model {

	@Id
	@Constraints.Required
	@Formats.NonEmpty
	public String dni;

	@Constraints.Required
	public String password;

	@Column(name = "id_provincia")
	public Long idProvincia;

	public static Map<String, String> provincias = new HashMap<String, String>() {
		{
			put("10", "jujuy");
			put("17", "salta");
		}
	};

	public static Model.Finder<String, Usuario> find = new Model.Finder(
			"seguridad", String.class, Usuario.class);

	/**
	 * Retrieve all users.
	 */
	public static List<Usuario> findAll() {
		return find.all();
	}

	/**
	 * Retrieve a User from email.
	 */
	public static Usuario findByEmail(String dni) {
		return find.where().eq("dni", dni).findUnique();
	}

	/**
	 * Authenticate a User.
	 */
	public static Usuario authenticate(String dni, String password) {
		return find.where().eq("dni", dni).eq("password", password)
				.findUnique();
	}

	// --

	public String toString() {
		return "User(" + dni + ")";
	}

	public String getServer() {
		return Usuario.provincias.get(this.idProvincia.toString());
	}

}
