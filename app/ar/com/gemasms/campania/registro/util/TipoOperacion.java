package ar.com.gemasms.campania.registro.util;

import models.campania.temporal.RegistroTemporal;
import play.Logger;

public abstract class TipoOperacion {

	private CodigoTipoOperacion codigoOperacion;

	public TipoOperacion(CodigoTipoOperacion estado) {
		this.setCodigoOperacion(estado);
	}

	public void ejecutar(RegistroTemporal registro) {
		try {
			this.ejecutarOperacion(registro);
		} catch (Throwable e) {
			Logger.of(getClass()).error(
					"No se pudo ejecutar la operacion con exito. "
							+ e.getMessage());
		}
	}

	protected abstract void ejecutarOperacion(RegistroTemporal registro);

	public CodigoTipoOperacion getCodigoOperacion() {
		return codigoOperacion;
	}

	public void setCodigoOperacion(CodigoTipoOperacion codigoOperacion) {
		this.codigoOperacion = codigoOperacion;
	}

	public boolean esEnvioDeMensaje() {
		return this.getCodigoOperacion().esperandoEnviarMensaje();
	}
}
