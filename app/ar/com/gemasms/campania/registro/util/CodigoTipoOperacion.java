package ar.com.gemasms.campania.registro.util;

import models.campania.temporal.RegistroTemporal;

import com.avaje.ebean.annotation.EnumValue;

public enum CodigoTipoOperacion {
	@EnumValue(value = "EM")
	ESPERANDO_ENVIAR(new OperacionEnviarMensaje()),

	@EnumValue(value = "RM")
	ESPERANDO_RECIBIR(new OperacionEsperarRespuesta()),

	@EnumValue(value = "ER")
	ENVIAR_RESUMEN(new OperacionEnviarResumen());

	private TipoOperacion tipoOperacion;

	private CodigoTipoOperacion(TipoOperacion tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}

	public boolean esperandoEnviarMensaje() {
		return ESPERANDO_ENVIAR.equals(this);
	}

	public boolean esperandoRecibirRespuesta() {
		return ESPERANDO_RECIBIR.equals(this);
	}

	public boolean esperandoEnviarMensajeResumen() {
		return ENVIAR_RESUMEN.equals(this);
	}

	public void ejecutar(RegistroTemporal registro) {
		this.tipoOperacion.ejecutar(registro);
	}
}