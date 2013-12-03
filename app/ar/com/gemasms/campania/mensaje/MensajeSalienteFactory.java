package ar.com.gemasms.campania.mensaje;

import models.campania.Campania;
import models.mensaje.Mensaje;

public class MensajeSalienteFactory extends MensajeAProcesarFactory {

	public MensajeAProcesar crearMensaje(Campania campania, Mensaje mensaje) {
		MensajeSaliente mensajeSaliente = new MensajeSaliente();

		mensajeSaliente.setMensaje(mensaje);
		mensajeSaliente.setRegistro(this.obtenerRegistro(campania,
				mensaje.getContacto()));

		return mensajeSaliente;
	}

}
