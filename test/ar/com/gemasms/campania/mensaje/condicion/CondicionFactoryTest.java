package ar.com.gemasms.campania.mensaje.condicion;

import java.util.List;

import ar.com.gemasms.campania.mensaje.condicion.CondicionFactory;
import ar.com.gemasms.util.Condicion;
import junit.framework.TestCase;

public class CondicionFactoryTest extends TestCase {

	public void testCrearCondicionMenor() {
		String condicionMenor = "DESAPROBADOS MENOR 10";

		Condicion condicion = CondicionFactory.getInstance().crearCondicion(
				condicionMenor);

		assertEquals("Se esperaba codigo de condicion 'MENOR'",
				Condicion.CondicionMenor.class, condicion.getClass());
	}

	public void testCrearCondicionMenorConPuntoComaFinal() {
		String condicionMenor = "DESAPROBADOS MENOR 10;";

		Condicion condicion = CondicionFactory.getInstance().crearCondicion(
				condicionMenor);

		assertEquals("Se esperaba codigo de condicion 'MENOR'",
				Condicion.CondicionMenor.class, condicion.getClass());
	}

	public void testCrearCondicionMenorSinValor() {
		String condicionMenor = "DESAPROBADOS MENOR ;";

		Boolean exception = false;
		try {
			CondicionFactory.getInstance().crearCondicion(condicionMenor);
		} catch (Throwable e) {
			exception = true;
		}

		assertTrue(exception);
	}

	public void testCrearCondicionConEspaciosEnMedio() {
		String condicionMenor = "DESAPROBADOS    MENOR     10;      ";

		Boolean exception = false;
		try {
			CondicionFactory.getInstance().crearCondicion(condicionMenor);
		} catch (Throwable e) {
			exception = true;
		}

		assertFalse(exception);
	}

	public void testCrearDosCondiciones() {
		String condicionMenor = "DESAPROBADOS MENOR 10;     DESAPROBADOS MAYOR 16;   ";

		List<Condicion> condiciones = CondicionFactory.getInstance()
				.crearCondiciones(condicionMenor);

		assertEquals(2, condiciones.size());
	}

	public void testCrearDosCondicionesUnaMalFormada() {
		String condicionMenor = "DESAPROBADOS MENOR 10;     ;DESAPROBADOS MAYOR 16;   ";

		Boolean exception = false;
		try {
			CondicionFactory.getInstance().crearCondiciones(condicionMenor);
		} catch (Throwable e) {
			exception = true;
		}

		assertTrue(exception);
	}
}
