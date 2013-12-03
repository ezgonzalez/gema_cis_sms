package ar.com.gemasms.campania.hiloEjecucion;

import models.BufferSMS;
import models.campania.Campania;
import ar.com.gemasms.configuracion.GemaProperties;
import ar.com.gemasms.modem.BufferSMSFacade;

public class Salida extends HiloDeEjecucion {

	public Salida(Campania campania) {
		super(campania);
	}

	@Override
	public void ejecutarEnBucle() {
		try {
			this.enviarMensajesPendientes();
		} catch (Throwable ex) {
			this.logger().error("No se pudo enviar el mensaje", ex);
		}
	}

	private void enviarMensajesPendientes() {
		for (BufferSMS buffer : BufferSMSFacade
				.obtenerMensajesAEnviar(this.campania)) {

			this.logger().info(
					"Se va a enviar el mensaje: " + buffer.getMensaje());

			buffer.enviarMensaje();
			buffer.delete();

			this.huboActividadEnLaUltimoCorrida = true;
		}
	}

	@Override
	protected String nombreDelThread() {
		return GemaProperties.NOMBRE_SALIDA;
	}

	@Override
	protected void levantarThread() {
		EstadoAplicacion.levantarHiloDeSalida(campania.toString());
	}

	@Override
	protected void matarThread() {
		EstadoAplicacion.matarHiloDeSalida(campania.toString());
	}
}
