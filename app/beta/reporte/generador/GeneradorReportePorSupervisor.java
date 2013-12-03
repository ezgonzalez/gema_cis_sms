package beta.reporte.generador;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import beta.reporte.Reporte;

public class GeneradorReportePorSupervisor extends Generador {

	private static List<String> PAGINAS = Arrays.asList("info1_supervisor",
			"info2_supervisor", "info3_supervisor", "info4_supervisor",
			"info5_supervisor", "info6_supervisor");

	@Override
	protected List<String> obtenerPaginas() {
		return PAGINAS;
	}

	@Override
	protected boolean soyElGenerador(Reporte reporte) {
		return reporte.esPorSupervisor();
	}

	@Override
	protected Map<String, Object> obtenerParametros(Reporte reporte) {
		Map<String, Object> parametros = super.obtenerParametros(reporte);

		parametros.put("p_tabla", "v_informe_campania_por_supervisor");

		return parametros;
	}

}
