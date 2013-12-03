package ar.com.gemasms.campania.mensaje.correccion;

import junit.framework.TestCase;

import org.apache.commons.lang.StringUtils;

public class CorreccionDeRespuestaTest extends TestCase {

	private CorreccionDeRespuesta correccion = new CorreccionDeRespuesta();

	public void testMensajeIncorrecto() {
		String mensajeQueFalla = "NADA";
		String codigo = StringUtils.EMPTY;
		String nuevoValor = StringUtils.EMPTY;

		correccion.parsearParametros(mensajeQueFalla);

		assertEquals(codigo, correccion.getCodigoPregunta());
		assertEquals(nuevoValor, correccion.getNuevoValor());
	}

	public void testMensajeConEspaciosCorrecto() {
		String mensaje = "   CORREGIR desaprobados 15";

		String codigo = "DESAPROBADOS";
		String nuevoValor = "15";

		correccion.parsearParametros(mensaje);

		assertEquals(codigo, correccion.getCodigoPregunta());
		assertEquals(nuevoValor, correccion.getNuevoValor());
	}

	public void testMensajeConMasDeTresPalabrasFalla() {
		String mensaje = "   CORREGIR desaprobados 15 15";
		String codigo = StringUtils.EMPTY;
		String nuevoValor = StringUtils.EMPTY;

		correccion.parsearParametros(mensaje);

		assertEquals(codigo, correccion.getCodigoPregunta());
		assertEquals(nuevoValor, correccion.getNuevoValor());
	}
}
