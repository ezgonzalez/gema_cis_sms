package ar.com.gemasms.campania.mensaje;

import models.campania.Campania;
import models.mensaje.Mensaje;

public class MensajeEntranteFactory extends MensajeAProcesarFactory {

	@Override
	public MensajeAProcesar crearMensaje(Campania campania, Mensaje mensaje) {
		MensajeEntrante mensajeEntrante = new MensajeEntrante();

		mensajeEntrante.setMensaje(mensaje);
		mensajeEntrante.setRegistro(this.obtenerRegistro(campania,
				mensaje.getContacto()));

		return mensajeEntrante;
	}

}
