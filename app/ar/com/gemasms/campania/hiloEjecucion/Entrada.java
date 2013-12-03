package ar.com.gemasms.campania.hiloEjecucion;

import models.Contacto;
import models.campania.Campania;
import play.Logger;
import ar.com.gemasms.configuracion.GemaProperties;
import ar.com.gemasms.modem.BufferSMSFacade;
import ar.com.gemasms.modem.IModem;
import ar.com.gemasms.util.MensajeFactory;

public class Entrada extends HiloDeEjecucion {

	private IModem modem = new ModemPrueba();

	public Entrada(Campania campania) {
		super(campania);
	}

	@Override
	public void ejecutarEnBucle() {
		try {
			this.obtenerMensajesEntrantes();
		} catch (Throwable ex) {
			Logger.of(this.getClass())
					.error("Ocurrio un error inesperado mientras se interactuaba con el modem",
							ex);
		}
	}

	private void obtenerMensajesEntrantes() {
		for (String[] smsRecibido : this.modem.recibirMensajes()) {
			String celular = smsRecibido[0];
			String texto = smsRecibido[1];
			String idMensaje = smsRecibido[2];

			Contacto contacto = Contacto.obtenerContactoDesdeTelefono(celular);

			if (contacto != null && this.campania.esUnContactoTuyo(contacto)) {
				BufferSMSFacade.insertarMensajeEntrante(
						this.campania,
						MensajeFactory.getInstance().crearMensajeEntrante(
								contacto, texto));

				this.modem.eliminarMensaje(idMensaje);
				this.huboActividadEnLaUltimoCorrida = true;
			}
		}
	}

	@Override
	protected String nombreDelThread() {
		return GemaProperties.NOMBRE_ENTRADA;
	}

	@Override
	protected void levantarThread() {
		EstadoAplicacion.levantarHiloDeEntrada(this.campania.toString());
	}

	@Override
	protected void matarThread() {
		EstadoAplicacion.matarHiloDeEntrada(this.campania.toString());
	}

	public IModem getModem() {
		return modem;
	}

	public void setModem(IModem modem) {
		this.modem = modem;
	}
}
