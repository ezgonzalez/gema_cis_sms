package models.campania.mensaje;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OrderBy;
import javax.persistence.OrderColumn;
import javax.persistence.Table;

import models.campania.Campania;
import models.campania.mensaje.respuesta.Respuesta;
import models.campania.temporal.RegistroTemporal;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.JsonNode;

import play.data.validation.Constraints.Required;
import play.db.ebean.Model;
import ar.com.gemasms.campania.mensaje.condicion.CondicionFactory;
import ar.com.gemasms.campania.mensaje.validacion.IValidacion;
import ar.com.gemasms.campania.mensaje.validacion.factory.ValidacionMensajeCampaniaFactory;
import ar.com.gemasms.util.Condicion;
import ar.com.gemasms.util.TipoMensaje;

import com.google.common.base.Function;
import com.google.common.collect.Lists;

@Entity
@Table(name = "mensaje_campania")
public class MensajeCampania extends Model {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_mensaje_campania")
	private int id;

	@Column(name = "codigo_mensaje")
	@Required
	private String codigoMensaje;

	@Column(name = "texto_mensaje")
	private String mensaje;

	@Column(name = "tipo_mensaje")
	private TipoMensaje tipoMensaje;

	@ManyToMany
	@JoinTable(name = "mensaje_campania_siguiente", joinColumns = @JoinColumn(name = "id_mensaje_campania", referencedColumnName = "id_mensaje_campania"), inverseJoinColumns = @JoinColumn(name = "id_siguiente_mensaje_campania", referencedColumnName = "id_mensaje_campania"))
	@OrderBy("numeroOrden ASC")
	private List<MensajeCampania> posiblesSiguientes = Lists.newArrayList();

	@Column(name = "condiciones_entrada")
	private String condicionesDeEntrada;

	@Column(name = "numero_orden")
	@OrderColumn
	private int numeroOrden;

	@ManyToOne(cascade = CascadeType.PERSIST)
	@JoinColumn(name = "id_campania", referencedColumnName = "id_campania")
	@Required
	private Campania campania;

	@Column(name = "validaciones")
	private String validaciones;

	public static Model.Finder<String, MensajeCampania> finder = new Model.Finder<String, MensajeCampania>(
			String.class, MensajeCampania.class);

	public static MensajeCampania obtenerPrimerMensajeDeCampania(
			Campania campania) {
		return finder.where().eq("id_campania", campania.getId())
				.orderBy("numero_orden").findUnique();
	}

	public static List<MensajeCampania> obtenerTodasLasPreguntas(Long campania) {
		return finder.where().eq("campania.id", campania)
				.eq("tipoMensaje", TipoMensaje.PREGUNTA)
				.orderBy("numero_orden").findList();
	}

	public Campania getCampania() {
		return campania;
	}

	public void setCampania(Campania campania) {
		this.campania = campania;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}

	public TipoMensaje getTipoMensaje() {
		return tipoMensaje;
	}

	public void setTipoMensaje(TipoMensaje tipoMensaje) {
		this.tipoMensaje = tipoMensaje;
	}

	public String getCodigoMensaje() {
		return codigoMensaje;
	}

	public void setCodigoMensaje(String codigoMensaje) {
		this.codigoMensaje = codigoMensaje;
	}

	public boolean esPregunta() {
		return this.getTipoMensaje().esPregunta();
	}

	public boolean esNotificacion() {
		return this.getTipoMensaje().esNotificacion();
	}

	public MensajeCampania obtenerSiguienteMensaje(List<Respuesta> respuestas) {
		for (MensajeCampania posibleSiguiente : this.posiblesSiguientes) {
			if (posibleSiguiente.cumpleCriteriosDeEntrada(respuestas)) {
				return posibleSiguiente;
			}
		}

		return null;
	}

	protected boolean cumpleCriteriosDeEntrada(List<Respuesta> respuestas) {
		for (Condicion condicion : CondicionFactory.getInstance()
				.crearCondiciones(this.condicionesDeEntrada)) {
			if (!condicion.cumple(respuestas)) {
				return false;
			}
		}

		return true;
	}

	public int getNumeroOrden() {
		return numeroOrden;
	}

	public void setNumeroOrden(int numeroOrden) {
		this.numeroOrden = numeroOrden;
	}

	public List<MensajeCampania> getPosiblesSiguientes() {
		return posiblesSiguientes;
	}

	public void setPosiblesSiguientes(List<MensajeCampania> posiblesSiguientes) {
		this.posiblesSiguientes = posiblesSiguientes;
	}

	public String getCondicionesDeEntrada() {
		return condicionesDeEntrada;
	}

	public void setCondicionesDeEntrada(String condicionesDeEntrada) {
		this.condicionesDeEntrada = condicionesDeEntrada;
	}

	public List<IValidacion> getValidacionesDelMensaje() {
		return this.convertirValidaciones();
	}

	protected List<IValidacion> convertirValidaciones() {
		return Lists.transform(this.interpretarValidaciones(),
				new Function<JsonNode, IValidacion>() {

					@Override
					public IValidacion apply(JsonNode elementos) {
						return ValidacionMensajeCampaniaFactory
								.fabricaConcreta(elementos.get("tipo").asText())
								.crearValidacion(elementos);
					}
				});
	}

	protected ArrayList<JsonNode> interpretarValidaciones() {
		return Lists.newArrayList(play.libs.Json.parse(
				StringUtils.isBlank(this.validaciones) ? "[]"
						: this.validaciones).getElements());
	}

	public String getValidaciones() {
		return this.validaciones;
	}

	public void setValidaciones(String validaciones) {
		this.validaciones = validaciones;
	}

	public void validarMensaje(RegistroTemporal registroTemporal,
			String smsTexto, List<String> validacionesNoPasadas) {
		for (IValidacion validacion : this.getValidacionesDelMensaje()) {
			if (validacion.elMensajeNoPasaLaValidacion(smsTexto,
					registroTemporal)) {
				validacionesNoPasadas.add(validacion.getMensaje());
			}
		}
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((campania == null) ? 0 : campania.hashCode());
		result = prime * result
				+ ((codigoMensaje == null) ? 0 : codigoMensaje.hashCode());
		result = prime * result + numeroOrden;
		result = prime * result
				+ ((tipoMensaje == null) ? 0 : tipoMensaje.hashCode());
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
		MensajeCampania other = (MensajeCampania) obj;
		if (campania == null) {
			if (other.campania != null)
				return false;
		} else if (!campania.equals(other.campania))
			return false;
		if (codigoMensaje == null) {
			if (other.codigoMensaje != null)
				return false;
		} else if (!codigoMensaje.equals(other.codigoMensaje))
			return false;
		if (numeroOrden != other.numeroOrden)
			return false;
		if (tipoMensaje != other.tipoMensaje)
			return false;
		return true;
	}
}
