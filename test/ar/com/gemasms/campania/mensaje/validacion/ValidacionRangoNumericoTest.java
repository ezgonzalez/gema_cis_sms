package ar.com.gemasms.campania.mensaje.validacion;

import junit.framework.TestCase;

public class ValidacionRangoNumericoTest extends TestCase {

	private static Integer DESDE = 1;
	private static Integer HASTA = 100;

	private ValidacionRangoNumerico validacion = new ValidacionRangoNumerico(
			DESDE, HASTA);

	public void testNoEsUnNumero() {
		String mensaje = "uno";

		assertFalse("El mensaje no debería pasar la validacion",
				validacion.elMensajePasaLaValidacion(mensaje, null));
	}

	public void testEsUnNumeroMenorQueElMinimo() {
		String mensaje = "0";

		assertFalse("El mensaje no deberia pasar la validacion.",
				validacion.elMensajePasaLaValidacion(mensaje, null));
	}

	public void testEsElExtremoInferior() {
		String mensaje = DESDE.toString();

		assertTrue(
				"El mensaje deberia pasar la validacion, ya que es el minimo: "
						+ DESDE,
				validacion.elMensajePasaLaValidacion(mensaje, null));
	}

	public void testEsElExtremoSuperior() {
		String mensaje = HASTA.toString();

		assertTrue(
				"El mensaje deberia pasar la validacion, ya que es el maximo incluido: "
						+ HASTA,
				validacion.elMensajePasaLaValidacion(mensaje, null));
	}

	public void testNoPasaPorquePasaPorUnoAlMaximo() {
		String mensaje = Integer.valueOf(HASTA + 1).toString();

		assertFalse(
				"El mensaje no deberia pasar la validacion, ya que es el maximo incluido + 1: "
						+ HASTA,
				validacion.elMensajePasaLaValidacion(mensaje, null));
	}
}
