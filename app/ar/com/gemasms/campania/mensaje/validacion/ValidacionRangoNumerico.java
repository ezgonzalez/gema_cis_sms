package ar.com.gemasms.campania.mensaje.validacion;

import models.campania.temporal.RegistroTemporal;

public class ValidacionRangoNumerico implements IValidacion {

	private Integer desde = null;

	private Integer hasta = null;

	public ValidacionRangoNumerico(Integer desde, Integer hasta) {
		this.desde = desde;
		this.hasta = hasta;
	}

	@Override
	public String getMensaje() {
		return "El valor debe ser un numero mayor-igual a " + this.desde
				+ (this.hasta != null ? " y menor-igual a " + this.hasta : "");
	}

	@Override
	public boolean elMensajeNoPasaLaValidacion(String mensaje,
			RegistroTemporal registro) {
		return !this.elMensajePasaLaValidacion(mensaje, registro);
	}

	@Override
	public boolean elMensajePasaLaValidacion(String mensaje,
			RegistroTemporal registro) {
		boolean resultado = false;

		try {
			Integer valor = Integer.valueOf(mensaje);
			resultado = valor >= this.desde
					&& (this.hasta == null || (valor <= this.hasta));
		} catch (NumberFormatException e) {
			resultado = false;
		}

		return resultado;
	}

	public Integer getDesde() {
		return desde;
	}

	public void setDesde(Integer desde) {
		this.desde = desde;
	}

	public Integer getHasta() {
		return hasta;
	}

	public void setHasta(Integer hasta) {
		this.hasta = hasta;
	}

}
