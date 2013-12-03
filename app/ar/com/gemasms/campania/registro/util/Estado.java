package ar.com.gemasms.campania.registro.util;

import com.avaje.ebean.annotation.EnumValue;

public enum Estado {
	@EnumValue(value = "F")
	FINALIZADO,

	@EnumValue(value = "S")
	SUSPENDIDO,

	@EnumValue(value = "I")
	INICIADO
}
