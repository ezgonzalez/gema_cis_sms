package ar.com.gemasms.campania.mensaje.validacion;

import models.campania.mensaje.respuesta.Respuesta;
import models.campania.temporal.RegistroTemporal;

public class ValidacionInclusion implements IValidacion {

	private IValidacion validacionImplicita = new ValidacionNumerica();

	private String codigoPregunta = "";

	public String getCodigoPregunta() {
		return codigoPregunta;
	}

	public void setCodigoPregunta(String codigoPregunta) {
		this.codigoPregunta = codigoPregunta;
	}

	@Override
	public String getMensaje() {
		return "El valor debe ser menor-igual a la respuesta de codigo "
				+ this.codigoPregunta;
	}

	@Override
	public boolean elMensajeNoPasaLaValidacion(String mensaje,
			RegistroTemporal registro) {
		return !this.elMensajePasaLaValidacion(mensaje, registro);
	}

	@Override
	public boolean elMensajePasaLaValidacion(String mensaje,
			RegistroTemporal registro) {

		return this.validacionImplicita.elMensajePasaLaValidacion(mensaje,
				registro)
				&& this.elNumeroActualEsMenorIgualQueLaRespuesta(mensaje,
						registro.dameRespuesta(this.codigoPregunta));
	}

	protected boolean elNumeroActualEsMenorIgualQueLaRespuesta(String mensaje,
			Respuesta respuesta) {
		return respuesta != null
				&& Integer.valueOf(respuesta.getRespuesta()).compareTo(
						Integer.valueOf(mensaje)) >= 0;
	}
}
