package models.modem;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.google.common.collect.Lists;

import play.data.format.Formats.DateTime;
import play.data.validation.Constraints.Required;
import play.db.ebean.Model;
import ar.com.gemasms.modem.IModem;

@Entity
@Table(name = "modem")
public class Modem extends Model implements IModem {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_modem")
	private long id;

	@Column(name = "codigo")
	@Required
	private String codigo;

	@Column(name = "descripcion")
	private String descripcion;

	@Column(name = "url")
	@Required
	private String url;

	@Column(name = "fecha_baja")
	@DateTime(pattern = "dd/MM/yyyy")
	private Date fechaBaja;

	public static Model.Finder<Long, Modem> finder = new Model.Finder<Long, Modem>(
			Long.class, Modem.class);

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public static Map<String, String> activos() {
		LinkedHashMap<String, String> options = new LinkedHashMap<String, String>();

		for (Modem modem : finder.where().isNull("fechaBaja").findList()) {
			options.put(Long.toString(modem.getId()), modem.getDescripcion());
		}

		return options;
	}

	@Override
	public void enviarMensaje(String celular, String texto) {
		// TODO Auto-generated method stub

	}

	@Override
	public List<String[]> recibirMensajes() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String consultarEstado() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void eliminarMensaje(String idMensaje) {
		// TODO Auto-generated method stub

	}

	public static List<IModem> activosParaEnviar() {
		List<IModem> modems = Lists.newArrayList();
		modems.addAll(finder.where().isNull("fechaBaja").findList());
		return modems;
	}
}
