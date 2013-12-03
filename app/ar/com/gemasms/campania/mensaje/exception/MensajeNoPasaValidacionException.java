package ar.com.gemasms.campania.mensaje.exception;

import java.util.List;

import ar.com.gemasms.campania.mensaje.validacion.IValidacion;

import com.google.common.base.Joiner;

public class MensajeNoPasaValidacionException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	private List<IValidacion> validacionesNoPasadas;

	public MensajeNoPasaValidacionException(String mensaje,
			List<IValidacion> validacionesNoPasadas) {
		super("El mensaje [" + mensaje
				+ "] no pasa las siguientes validaciones: "
				+ validacionesNoPasadas);

		this.validacionesNoPasadas = validacionesNoPasadas;
	}

	public String getValidacionesNoPasadas() {
		return Joiner.on("; ").join(this.validacionesNoPasadas);
	}

}
