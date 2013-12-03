package ar.com.gemasms.campania.registro.util;

import models.campania.temporal.RegistroTemporal;

public class OperacionEsperarRespuesta extends TipoOperacion {

	public OperacionEsperarRespuesta() {
		super(CodigoTipoOperacion.ESPERANDO_RECIBIR);
	}

	@Override
	protected void ejecutarOperacion(RegistroTemporal registro) {
		registro.procesarInactividad();
	}

}
