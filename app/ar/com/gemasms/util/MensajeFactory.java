package ar.com.gemasms.util;

import models.Contacto;
import models.mensaje.Mensaje;

import org.apache.commons.lang3.StringUtils;

public class MensajeFactory {

	private static MensajeFactory instance = null;

	private static String CAMPO_NULO = ",CAMPO_NULO,";

	public static MensajeFactory getInstance() {
		if (instance == null) {
			instance = new MensajeFactory();
		}

		return instance;
	}

	public Mensaje crearMensajeDesdeLineaAT(String cabecera) {
		String[] resultado = StringUtils.replace(cabecera, ",,", CAMPO_NULO)
				.split(",");

		Mensaje mensaje = new Mensaje();

		mensaje.setContacto(Contacto.obtenerContactoDesdeTelefono(resultado[1]));

		return mensaje;
	}

	public Mensaje crearMensajeEntrante(Contacto contacto, String texto) {
		return this.crearMensaje(contacto, texto, Mensaje.DIRECCION_ENTRANTE);
	}

	public Mensaje crearMensajeSaliente(Contacto contacto, String texto) {
		return this.crearMensaje(contacto, texto, Mensaje.DIRECCION_SALIENTE);
	}

	private Mensaje crearMensaje(Contacto contacto, String texto,
			String direccion) {
		Mensaje mensaje = new Mensaje();

		mensaje.setMensaje(texto);
		mensaje.setContacto(contacto);
		mensaje.setDireccion(direccion);
		mensaje.setIndice(-1);

		mensaje.save();

		return mensaje;
	}
}
