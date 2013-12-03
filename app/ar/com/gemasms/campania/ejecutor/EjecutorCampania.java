package ar.com.gemasms.campania.ejecutor;

import models.campania.Campania;
import ar.com.gemasms.campania.hiloEjecucion.Entrada;
import ar.com.gemasms.campania.hiloEjecucion.EstadoAplicacion;
import ar.com.gemasms.campania.hiloEjecucion.Procesador;
import ar.com.gemasms.campania.hiloEjecucion.Salida;

public class EjecutorCampania {

	public void ejecutarCampania(Campania campania) {
		campania.ejecutar();

		EstadoAplicacion.crearEstadoDeAplicacion(campania.toString());

		EstadoAplicacion.levantarHiloDeEntrada(campania.toString());
		EstadoAplicacion.levantarHiloDeProceso(campania.toString());
		EstadoAplicacion.levantarHiloDeSalida(campania.toString());

		new Entrada(campania).iniciarEjecucion();
		new Procesador(campania).iniciarEjecucion();
		new Salida(campania).iniciarEjecucion();
	}
}
