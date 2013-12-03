package ar.com.gemasms.campania.mensaje;

import models.Contacto;
import models.campania.temporal.RegistroTemporal;
import models.mensaje.Mensaje;

public abstract class MensajeAProcesar {

	private Mensaje mensaje;

	private RegistroTemporal registro;

	public RegistroTemporal getRegistro() {
		return registro;
	}

	public void setRegistro(RegistroTemporal registro) {
		this.registro = registro;
	}

	public Mensaje getMensaje() {
		return mensaje;
	}

	public void setMensaje(Mensaje mensaje) {
		this.mensaje = mensaje;
	}

	public abstract void tratarMensaje();

	public Contacto getContacto() {
		return this.getMensaje().getContacto();
	}
}
