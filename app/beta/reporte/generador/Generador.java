package beta.reporte.generador;

import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import play.Logger;
import beta.reporte.Reporte;
import beta.reporte.generador.excepcion.ErrorAlGenerarElReporteException;

import com.google.common.collect.Lists;

public abstract class Generador {

	public static Generador GENERADORES = new GeneradorReportePorSupervisor()
			.setSiguiente(new GeneradorDeReportePorDepartamento()
					.setSiguiente(new GeneradorDeReportePorProvincia()));

	private Generador siguiente = null;

	public Generador setSiguiente(Generador siguiente) {
		this.siguiente = siguiente;
		return this;
	}

	public List<String> generarReportes(Reporte reporte, Connection conexionDB) {

		Logger.of(getClass()).error(
				"Por verificar si cumplo para generar el pedido.");

		if (this.soyElGenerador(reporte)) {
			try {
				return this.obtenerReportes(reporte, conexionDB);
			} catch (ErrorAlGenerarElReporteException e) {
				play.Logger.of(getClass()).error(
						"error al generar los reportes");
			}
		} else if (this.siguiente != null) {
			Logger.of(getClass()).error(
					"No cumplo las condiciones, busco el siguiente.");
			return this.siguiente.generarReportes(reporte, conexionDB);
		}

		return Lists.newArrayList();
	}

	protected List<String> obtenerReportes(Reporte reporte,
			Connection conexionDB) throws ErrorAlGenerarElReporteException {
		return new GeneradorDeReporte().generarInformes(this.obtenerPaginas(),
				this.obtenerParametros(reporte), conexionDB);

	}

	protected abstract List<String> obtenerPaginas();

	protected abstract boolean soyElGenerador(Reporte reporte);

	protected Map<String, Object> obtenerParametros(Reporte reporte) {
		Long mes = reporte.mes.getNumero();
		String anio = reporte.anio;

		String idProvincia = reporte.provincia != null
				&& reporte.provincia.id != null ? reporte.provincia.id
				.toString() : null;
		String idDepartamento = reporte.departamento != null
				&& reporte.departamento.id != null ? reporte.departamento.id
				.toString() : null;
		String idSupervisor = reporte.supervisor != null
				&& reporte.supervisor.getId() != null ? reporte.supervisor
				.getId().toString() : null;

		Map<String, Object> parametros = new HashMap<String, Object>();

		parametros.put("p_anio", anio);
		parametros.put("p_mes", mes);

		if (idProvincia != null) {
			parametros.put("p_id_provincia", idProvincia);
		}

		if (idDepartamento != null) {
			parametros.put("p_id_departamento", idDepartamento);
		}

		if (idSupervisor != null) {
			parametros.put("p_id_supervisor", idSupervisor);
		}

		return parametros;
	}
}
