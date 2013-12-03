package ar.com.gemasms.campania.hiloEjecucion;

import models.BufferSMS;
import models.campania.Campania;
import models.campania.temporal.RegistroTemporal;
import ar.com.gemasms.campania.mensaje.MensajeAProcesarFactory;
import ar.com.gemasms.configuracion.GemaProperties;
import ar.com.gemasms.modem.BufferSMSFacade;

public class Procesador extends HiloDeEjecucion {

	public Procesador(Campania campania) {
		super(campania);
	}

	@Override
	protected void ejecutarEnBucle() {
		for (BufferSMS buffer : BufferSMSFacade
				.obtenerMensajesAProcesar(this.campania)) {
			MensajeAProcesarFactory.crearMensajeEntrante(campania,
					buffer.getMensaje()).tratarMensaje();

			this.huboActividadEnLaUltimoCorrida = true;
		}

		for (RegistroTemporal registro : this.campania.getRegistros()) {
			registro.ejecutarOperacion();
		}
	}

	@Override
	protected String nombreDelThread() {
		return GemaProperties.NOMBRE_PROCESADOR;
	}

	@Override
	protected void levantarThread() {
		EstadoAplicacion.levantarHiloDeProceso(this.campania.toString());
	}

	@Override
	protected void matarThread() {
		EstadoAplicacion.matarHiloDeProceso(this.campania.toString());
	}
}
