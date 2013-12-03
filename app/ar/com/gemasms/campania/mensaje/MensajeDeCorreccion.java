package ar.com.gemasms.campania.mensaje;

import models.mensaje.Mensaje;
import ar.com.gemasms.campania.mensaje.correccion.CorreccionDeRespuesta;
import ar.com.gemasms.util.MensajeFactory;

public class MensajeDeCorreccion extends MensajeAProcesar {

	private CorreccionDeRespuesta correccion;

	public void parsearMensaje() {
		this.correccion = new CorreccionDeRespuesta();
		this.correccion.setMensaje(this.getMensaje());
		this.parsearMensaje();
	}

	@Override
	public void tratarMensaje() {
		// corrijo la respuesta
		this.getRegistro().corregirRespuesta(
				this.correccion.getCodigoPregunta(), this.crearMensaje());

		// marco para enviar, asi manda el mensaje sobre el que estaba parado
		this.getRegistro().marcarParaEnviar();
	}

	protected Mensaje crearMensaje() {
		return MensajeFactory.getInstance().crearMensajeEntrante(
				this.getContacto(), this.correccion.getNuevoValor());
	}

	public static boolean esDeCorreccion(Mensaje mensaje) {
		return CorreccionDeRespuesta.esDeCorrecion(mensaje.getMensaje());
	}
}
