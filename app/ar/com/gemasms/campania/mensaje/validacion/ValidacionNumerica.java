package ar.com.gemasms.campania.mensaje.validacion;

import java.util.regex.Pattern;

import models.campania.temporal.RegistroTemporal;

import org.apache.commons.lang.StringUtils;

public class ValidacionNumerica implements IValidacion {

	@Override
	public String getMensaje() {
		return "El valor debe ser un numero.";
	}

	@Override
	public boolean elMensajeNoPasaLaValidacion(String mensaje,
			RegistroTemporal registro) {
		return !this.elMensajePasaLaValidacion(mensaje, registro);
	}

	@Override
	public boolean elMensajePasaLaValidacion(String mensaje,
			RegistroTemporal registro) {
		return Pattern.matches("-?[0-9]+", StringUtils.trim(mensaje));
	}
}
