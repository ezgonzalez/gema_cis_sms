package ar.com.gemasms.campania.mensaje.validacion;

import models.campania.temporal.RegistroTemporal;

public interface IValidacion {

	public String getMensaje();

	public boolean elMensajeNoPasaLaValidacion(String mensaje,
			RegistroTemporal registro);

	public boolean elMensajePasaLaValidacion(String mensaje,
			RegistroTemporal registro);
}
