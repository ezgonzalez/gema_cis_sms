package ar.com.gemasms.util;

import com.avaje.ebean.annotation.EnumValue;

public enum TipoMensaje {

	@EnumValue("P")
	PREGUNTA,

	@EnumValue("N")
	NOTIFICACION;

	public boolean esPregunta() {
		return PREGUNTA.equals(this);
	}

	public boolean esNotificacion() {
		return NOTIFICACION.equals(this);
	}
}
