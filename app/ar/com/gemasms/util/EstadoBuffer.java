package ar.com.gemasms.util;

import com.avaje.ebean.annotation.EnumValue;

public enum EstadoBuffer {

	@EnumValue(value = "E")
	ENVIAR,

	@EnumValue(value = "P")
	PROCESAR
}
