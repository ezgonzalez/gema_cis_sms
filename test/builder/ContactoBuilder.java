package builder;

import java.util.Date;

import models.Contacto;
import models.modem.Modem;

public class ContactoBuilder {

	private String nombre = "";

	private String apellido = "";

	private String telefono = "";

	private String dni = "";

	private Modem modem = null;

	private Date fechaBaja = null;

	public ContactoBuilder nombre(String nombre) {
		this.nombre = nombre;
		return this;
	}

	public ContactoBuilder apellido(String apellido) {
		this.apellido = apellido;
		return this;
	}

	public ContactoBuilder telefono(String telefono) {
		this.telefono = telefono;
		return this;
	}

	public ContactoBuilder dni(String dni) {
		this.dni = dni;
		return this;
	}

	public ContactoBuilder modem(Modem modem) {
		this.modem = modem;
		return this;
	}

	public ContactoBuilder fechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
		return this;
	}

	public Contacto build() {
		Contacto c = new Contacto();

		c.setApellido(apellido);
		c.setDni(dni);
		c.setFechaBaja(fechaBaja);
		c.setNombre(nombre);
		c.setModem(modem);
		c.setTelefono(telefono);

		c.save();

		return c;
	}
}
