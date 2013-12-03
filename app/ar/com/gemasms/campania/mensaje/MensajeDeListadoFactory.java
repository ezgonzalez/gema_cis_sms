package ar.com.gemasms.campania.mensaje;

import models.campania.Campania;
import models.mensaje.Mensaje;

public class MensajeDeListadoFactory extends MensajeAProcesarFactory {

	@Override
	public MensajeAProcesar crearMensaje(Campania campania, Mensaje mensaje) {
		MensajeDeListado mensajeDeListado = new MensajeDeListado();

		mensajeDeListado.setRegistro(this.obtenerRegistro(campania,
				mensaje.getContacto()));

		return mensajeDeListado;
	}

}
