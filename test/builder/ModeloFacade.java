package builder;

import models.Contacto;

import org.apache.commons.lang.RandomStringUtils;

public class ModeloFacade {

	public static Contacto crearContacto() {
		return new ContactoBuilder().nombre(RandomStringUtils.random(10))
				.apellido(RandomStringUtils.random(10))
				.dni(RandomStringUtils.random(8))
				.telefono(RandomStringUtils.random(10)).build();
	}
}
