package ar.com.gemasms.campania.registro.util;

import models.campania.temporal.RegistroTemporal;


public class OperacionEnviarResumen extends TipoOperacion {

	public OperacionEnviarResumen() {
		super(CodigoTipoOperacion.ENVIAR_RESUMEN);
	}

	@Override
	protected void ejecutarOperacion(RegistroTemporal registro) {

	}
}
