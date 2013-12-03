package beta.reporte.generador;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import beta.reporte.Reporte;

public class GeneradorDeReportePorProvincia extends Generador {

	private static List<String> PAGINAS = Arrays.asList("info1", "info2",
			"info3", "info4", "info5", "info6");

	@Override
	protected List<String> obtenerPaginas() {
		return PAGINAS;
	}

	@Override
	protected boolean soyElGenerador(Reporte reporte) {
		return reporte.esPorProvincia();
	}

	@Override
	protected Map<String, Object> obtenerParametros(Reporte reporte) {
		Map<String, Object> parametros = super.obtenerParametros(reporte);

		parametros.put("p_tabla", "v_informe_campania_por_provincia");

		return parametros;
	}
}
