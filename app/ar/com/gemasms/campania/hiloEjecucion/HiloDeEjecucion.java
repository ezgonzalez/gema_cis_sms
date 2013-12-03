package ar.com.gemasms.campania.hiloEjecucion;

import models.campania.Campania;
import play.Logger;
import play.Logger.ALogger;

public abstract class HiloDeEjecucion extends Thread {

	protected Campania campania;

	protected boolean seguirEjecutando = true;

	protected long tiempoDeSiesta = 0;

	protected boolean huboActividadEnLaUltimoCorrida;

	protected static long SALTO_TIEMPO_DE_SIESTA = 100;

	public HiloDeEjecucion(Campania campania) {
		this.campania = campania;
		this.setName(this.nombreDelThread());
	}

	protected abstract String nombreDelThread();

	public void iniciarEjecucion() {
		this.seguirEjecutando = true;
		this.start();
	}

	public void detenerEjecucion() {
		this.seguirEjecutando = false;
	}

	@Override
	public void run() {
		this.logger().info("Iniciando ejecucion del hilo: " + this.getClass());

		this.levantarThread();

		try {
			while (this.seguirCorriendo()) {
				this.ejecutarEnBucle();
				this.dormir();
			}
		} catch (Exception e) {
			this.logger()
					.error("Ocurrió un error inesperado en el thread <"
							+ this.nombreDelThread()
							+ ">. Se procede a finalizar la ejecución general del sistema.",
							e);
		}

		this.matarThread();

		this.logger()
				.info("Finalizando ejecucion del hilo: " + this.getClass());
	}

	protected void dormir() {
		this.actualizarTiempoDeSiesta();
		try {
			sleep(tiempoDeSiesta);
		} catch (InterruptedException e) {
			Logger.of(getClass()).error(
					"Ocurrio un error al hacer dormir el thread");
		}
	}

	private void actualizarTiempoDeSiesta() {
		if (this.noHuboActividadEnLaUltimoCorrida()) {
			this.tiempoDeSiesta += SALTO_TIEMPO_DE_SIESTA;
		}
	}

	private boolean noHuboActividadEnLaUltimoCorrida() {
		return !this.huboActividadEnLaUltimoCorrida;
	}

	protected synchronized boolean seguirCorriendo() {
		return this.seguirEjecutando
				&& EstadoAplicacion.hiloDeEntradaArriba(campania.toString())
				&& EstadoAplicacion.hiloDeProcesoArriba(campania.toString())
				&& EstadoAplicacion.hiloDeSalidaArriba(campania.toString());
	}

	protected ALogger logger() {
		return Logger.of(getClass());
	}

	protected abstract void ejecutarEnBucle();

	protected abstract void levantarThread();

	protected abstract void matarThread();
}
