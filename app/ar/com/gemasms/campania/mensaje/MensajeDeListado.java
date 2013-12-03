package ar.com.gemasms.campania.mensaje;

import models.mensaje.Mensaje;

import com.google.common.base.Strings;

public class MensajeDeListado extends MensajeAProcesar {

	private static String MENSAJE_LISTADO = "LISTADO";

	@Override
	public void tratarMensaje() {
		this.getRegistro().enviarListaDeRespuestas();
		this.getRegistro().marcarParaEnviar();
	}

	public static boolean esDeListado(Mensaje mensaje) {
		return MENSAJE_LISTADO.equals(Strings.nullToEmpty(mensaje.getMensaje())
				.trim().toUpperCase());
	}
}
