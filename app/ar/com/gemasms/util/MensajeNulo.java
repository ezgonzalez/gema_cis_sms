package ar.com.gemasms.util;

import models.mensaje.Mensaje;

public class MensajeNulo extends Mensaje {

	public static MensajeNulo INSTANCE = new MensajeNulo();

	@Override
	public String toString() {
		return "MENSAJE NULO";
	}
}
