package ar.com.gemasms.util;

import models.campania.mensaje.respuesta.Respuesta;
import models.campania.temporal.RegistroTemporal;
import models.mensaje.Mensaje;

public class RespuestaFactory {

	public static Respuesta crearRespuestaDesdeMensaje(Mensaje mensaje,
			RegistroTemporal registro) {
		Respuesta respuesta = new Respuesta();

		respuesta.setContacto(mensaje.getContacto());
		respuesta.setMensaje(mensaje);
		respuesta.setRegistro(registro);

		registro.agregarRespuesta(respuesta);

		respuesta.save();

		return respuesta;
	}
}
