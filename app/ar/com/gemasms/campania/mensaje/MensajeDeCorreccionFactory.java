package ar.com.gemasms.campania.mensaje;

import models.campania.Campania;
import models.mensaje.Mensaje;

public class MensajeDeCorreccionFactory extends MensajeAProcesarFactory {

	@Override
	public MensajeAProcesar crearMensaje(Campania campania, Mensaje mensaje) {
		MensajeDeCorreccion mensajeDeCorreccion = new MensajeDeCorreccion();

		mensajeDeCorreccion.setMensaje(mensaje);
		mensajeDeCorreccion.setRegistro(this.obtenerRegistro(campania,
				mensaje.getContacto()));

		mensajeDeCorreccion.parsearMensaje();

		return mensajeDeCorreccion;
	}
}
