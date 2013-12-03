package models.campania.temporal;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import models.Contacto;
import models.campania.Campania;
import models.campania.mensaje.MensajeCampania;
import models.campania.mensaje.respuesta.Respuesta;
import models.mensaje.Mensaje;

import org.apache.commons.lang3.StringUtils;

import play.Logger;
import play.db.ebean.Model;
import ar.com.gemasms.campania.mensaje.validacion.IValidacion;
import ar.com.gemasms.campania.registro.util.CodigoTipoOperacion;
import ar.com.gemasms.campania.registro.util.Estado;
import ar.com.gemasms.modem.BufferSMSFacade;
import ar.com.gemasms.util.FechasUtil;
import ar.com.gemasms.util.RespuestaFactory;

import com.google.common.base.Predicate;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;

@Entity
@Table(name = "registro_temporal")
public class RegistroTemporal extends Model {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_registro_temporal")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "id_contacto", referencedColumnName = "id_contacto")
	public Contacto contacto;

	@ManyToOne
	@JoinColumn(name = "id_campania", referencedColumnName = "id_campania")
	public Campania campania;

	@Enumerated(EnumType.STRING)
	@Column(name = "tipo_operacion")
	public CodigoTipoOperacion operacion;

	// @Enumerated(EnumType.STRING)
	@Transient
	public Estado estado;

	@ManyToOne
	@JoinColumn(name = "id_mensaje_campania", referencedColumnName = "id_mensaje_campania")
	public MensajeCampania mensaje;

	@Column(name = "buffer")
	private String buffer;

	// @Column(name = "ultima_operacion")
	@Transient
	private Date tiempoUltimaOperacion;

	@OneToMany(mappedBy = "registro")
	private List<Respuesta> respuestas = new ArrayList<Respuesta>();

	public static Model.Finder<String, RegistroTemporal> finder = new Model.Finder<String, RegistroTemporal>(
			String.class, RegistroTemporal.class);

	public Contacto getContacto() {
		return contacto;
	}

	public void setContacto(Contacto contacto) {
		this.contacto = contacto;
	}

	public Campania getCampania() {
		return campania;
	}

	public void setCampania(Campania campania) {
		this.campania = campania;
	}

	public CodigoTipoOperacion getOperacion() {
		return operacion;
	}

	public void setOperacion(CodigoTipoOperacion operacion) {
		this.operacion = operacion;
	}

	public Estado getEstado() {
		return estado;
	}

	public void setEstado(Estado estado) {
		this.estado = estado;
	}

	public MensajeCampania getMensajeCampania() {
		return mensaje;
	}

	public void setMensaje(MensajeCampania mensaje) {
		this.mensaje = mensaje;
	}

	public void ejecutarOperacion() {
		this.getOperacion().ejecutar(this);
	}

	public String getTelefonoContacto() {
		return this.getContacto().getTelefono();
	}

	public String getMensajeDeTexto() {
		return this.getMensajeCampania().getMensaje();
	}

	public boolean esTuContacto(Contacto contacto) {
		return this.getContacto().equals(contacto);
	}

	public String obtenerMensajeDeError() {
		return this.getBuffer();
	}

	public List<Respuesta> getRespuestas() {
		return respuestas;
	}

	public void setRespuestas(List<Respuesta> respuestas) {
		this.respuestas = respuestas;
	}

	public String getBuffer() {
		return buffer;
	}

	public void setBuffer(String buffer) {
		this.buffer = buffer;
	}

	public Date getTiempoUltimaOperacion() {
		return tiempoUltimaOperacion;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public MensajeCampania getMensaje() {
		return mensaje;
	}

	public void setTiempoUltimaOperacion(Date tiempoUltimaOperacion) {
		this.tiempoUltimaOperacion = tiempoUltimaOperacion;
	}

	public void limpiarBuffer() {
		this.buffer = "";
	}

	public List<IValidacion> getValidacionesDelMensajeCampaniaActual() {
		return this.getMensajeCampania().getValidacionesDelMensaje();
	}

	public void confirmarEnvioDeMensajeActual() {
		if (StringUtils.isNotBlank(this.getBuffer())) {
			this.limpiarBuffer();
			this.marcarParaEnviar();
		} else if (this.getMensajeCampania().esPregunta()) {
			this.setOperacion(CodigoTipoOperacion.ESPERANDO_RECIBIR);
		} else {
			this.setMensaje(this.getMensajeCampania().obtenerSiguienteMensaje(
					null));
			this.marcarParaEnviar();
		}

		this.cambiarEstadoYPersistir();
	}

	protected void cambiarEstadoYPersistir() {
		// si no tengo mas mensajes, es porque termine
		if (this.getMensajeCampania() == null) {
			this.setEstado(Estado.FINALIZADO);
		}

		this.save();
	}

	public void agregarRespuesta(Respuesta respuesta) {
		this.getRespuestas().add(respuesta);
	}

	public void marcarParaEnviar() {
		this.setOperacion(CodigoTipoOperacion.ESPERANDO_ENVIAR);
		this.save();
	}

	public void marcaDeTiempo() {
		this.setTiempoUltimaOperacion(FechasUtil.getInstance()
				.obtenerFechaActual());
		this.save();
	}

	public void agregarRespuesta(MensajeCampania mensajeCampania,
			Mensaje mensajeEnProceso) {
		Respuesta respuesta = this.dameRespuesta(mensajeCampania
				.getCodigoMensaje());

		if (respuesta != null) {
			respuesta.setMensaje(mensajeEnProceso);
		} else {
			RespuestaFactory.crearRespuestaDesdeMensaje(mensajeEnProceso, this);
		}
	}

	public Respuesta dameRespuesta(final String codigoPregunta) {
		return Iterables.find(this.getRespuestas(), new Predicate<Respuesta>() {

			@Override
			public boolean apply(Respuesta respuesta) {
				return respuesta.getCodigoMensaje().equals(codigoPregunta);
			}
		});
	}

	public void tratarMensajeEntrante(Mensaje mensaje) {
		this.validarMensajeYAgregarRespuesta(this.getMensajeCampania(), mensaje);
		this.confirmarProcesamientoDelMensajeRecibido();
		this.marcaDeTiempo();

	}

	private void confirmarProcesamientoDelMensajeRecibido() {
		if (StringUtils.isNotBlank(this.getBuffer())) {
			this.agregarMensajeParaEnviar(this.getBuffer());
			this.limpiarBuffer();
		} else {
			this.mensaje = this.getMensajeCampania().obtenerSiguienteMensaje(
					this.getRespuestas());
		}

		this.marcarParaEnviar();
		this.cambiarEstadoYPersistir();
	}

	protected MensajeCampania obtenerMensajeCampaniaConCodigo(
			String codigoPregunta) {
		return this.dameRespuesta(codigoPregunta).getMensajeCampania();
	}

	public void validarMensajeYAgregarRespuesta(
			MensajeCampania mensajeCampania, Mensaje mensajeRecibido) {

		List<String> errores = Lists.newArrayList();
		mensajeCampania.validarMensaje(this, mensajeRecibido.getMensaje(),
				errores);

		if (!errores.isEmpty()) {
			this.setBuffer(StringUtils.join(errores, " - "));

			Logger.of(getClass()).debug(
					"El mensaje [" + mensajeRecibido
							+ "] no cumple las validaciones.");
		} else {
			this.agregarRespuesta(mensajeCampania, mensajeRecibido);
		}
	}

	public String listaDeRespuestas() {
		return "Respuestas: " + StringUtils.join(this.getRespuestas(), "; ");
	}

	public void corregirRespuesta(String codigoPregunta, Mensaje mensajeRecibido) {
		this.validarMensajeYAgregarRespuesta(
				this.obtenerMensajeCampaniaConCodigo(codigoPregunta),
				mensajeRecibido);

		if (this.getBuffer().isEmpty()) {
			this.setBuffer("Respuesta corregida correctamente.");
		}

		this.agregarMensajeParaEnviar(this.getBuffer());
		this.limpiarBuffer();
	}

	public void enviarListaDeRespuestas() {
		this.agregarMensajeParaEnviar(this.listaDeRespuestas());
	}

	protected void agregarMensajeParaEnviar(String texto) {
		BufferSMSFacade.insertarMensajeSaliente(this.getCampania(),
				this.getContacto(), texto);
	}

	public void marcarParaEsperar() {
		this.setOperacion(CodigoTipoOperacion.ESPERANDO_RECIBIR);
	}

	public void procesarInactividad() {
		if (this.seCumplioElTiempoDeInactividad(120)) {
			this.marcarParaEnviar();
		}
	}

	protected boolean seCumplioElTiempoDeInactividad(int minutos) {
		return FechasUtil.getInstance()
				.diferenciaEnMinutosRespectoDeLaFechaActual(
						this.getTiempoUltimaOperacion()) > minutos;
	}
}
