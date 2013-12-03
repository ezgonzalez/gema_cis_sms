package ar.com.gemasms.util;

import java.util.Date;

import org.joda.time.Period;

public class FechasUtil {

	private static FechasUtil instance = null;

	public static FechasUtil getInstance() {
		if (instance == null) {
			instance = new FechasUtil();
		}

		return instance;
	}

	public int diferenciaEnHoras(Date unaFecha, Date otraFecha) {
		return this.obtenerPeriodoDeTiempo(unaFecha, otraFecha).getHours();
	}

	public int diferenciaEnMinutos(Date unaFecha, Date otraFecha) {
		return this.obtenerPeriodoDeTiempo(unaFecha, otraFecha).getMinutes();
	}

	protected Period obtenerPeriodoDeTiempo(Date unaFecha, Date otraFecha) {
		long tiempoInicio = unaFecha.getTime();
		long tiempoFinal = otraFecha.getTime();

		if (unaFecha.after(otraFecha)) {
			// invierto los Time
			tiempoInicio = tiempoFinal;
			tiempoFinal = unaFecha.getTime();
		}

		return new Period(tiempoInicio, tiempoFinal);
	}

	public int diferenciaEnHorasRespectoDeLaFechaActual(Date unaFecha) {
		return this.diferenciaEnHoras(unaFecha, this.obtenerFechaActual());
	}

	public long diferenciaEnMinutosRespectoDeLaFechaActual(Date unaFecha) {
		return this.diferenciaEnMinutos(unaFecha, this.obtenerFechaActual());
	}

	public Date obtenerFechaActual() {
		return new Date();
	}
}
