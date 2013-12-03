package ar.com.gemasms.campania.mensaje.validacion;

import junit.framework.TestCase;

public class ValidacionNumericaTest extends TestCase {

	private IValidacion validacion = new ValidacionNumerica();

	public void testValidacionFallaPorNoSerNumero() {
		String mensajeNoNumero = "quince";

		assertFalse("[" + mensajeNoNumero
				+ "] no es un numero, por lo que deberia fallar",
				this.validacion
						.elMensajePasaLaValidacion(mensajeNoNumero, null));
		assertTrue("[" + mensajeNoNumero
				+ "] no es un numero, por lo que deberia fallar",
				this.validacion.elMensajeNoPasaLaValidacion(mensajeNoNumero,
						null));
	}

	public void testValidacionNoFalla() {
		String unNumero = "100";

		assertTrue("[" + unNumero
				+ "] es un numero, por lo que deberia funcionar ok",
				this.validacion.elMensajePasaLaValidacion(unNumero, null));
	}

	public void testValidacionDeMensajeConEspaciosALaIzquierdaNoFalla() {
		String unNumero = " 100";

		assertTrue("[" + unNumero
				+ "] es un numero, por lo que deberia funcionar ok",
				this.validacion.elMensajePasaLaValidacion(unNumero, null));
	}

	public void testValidacionDeMensajeConEspaciosALaDerechaNoFalla() {
		String unNumero = "100      ";

		assertTrue("[" + unNumero
				+ "] es un numero, por lo que deberia funcionar ok",
				this.validacion.elMensajePasaLaValidacion(unNumero, null));
	}

	public void testValidacionDeMensajeConUnNumeroYUnPuntoFalla() {
		String unNumero = "100.";

		assertFalse("[" + unNumero
				+ "] no es un numero puro, por lo que deberia funcionar ok",
				this.validacion.elMensajePasaLaValidacion(unNumero, null));
	}
}
