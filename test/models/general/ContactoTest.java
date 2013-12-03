package models.general;

import static play.test.Helpers.fakeApplication;

import org.junit.Before;
import org.junit.Test;

import play.test.WithApplication;

public class ContactoTest extends WithApplication {
	@Before
	public void setUp() {
		start(fakeApplication());
	}

	@Test
	public void testCrearUnCliente() {
		// new Modem().save();

		// Contacto c = new Contacto();
		//
		// c.setNombre("Ezequiel");
		// c.setApellido("Gonzalez");
		// c.setDni("34574128");
		// c.setTelefono("15");
		//
		// c.save();
	}
}
