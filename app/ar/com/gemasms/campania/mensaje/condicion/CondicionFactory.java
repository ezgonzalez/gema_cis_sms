package ar.com.gemasms.campania.mensaje.condicion;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import ar.com.gemasms.campania.mensaje.condicion.excepcion.CondicionMalFormadaException;
import ar.com.gemasms.util.Condicion;

public class CondicionFactory {

	private static CondicionFactory INSTANCE = null;

	public static CondicionFactory getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new CondicionFactory();
		}

		return INSTANCE;
	}

	public List<Condicion> crearCondiciones(String condicionesStr) {
		condicionesStr = condicionesStr.trim();
		List<Condicion> condiciones = new ArrayList<Condicion>();

		for (String condicion : condicionesStr.split(";")) {
			condiciones.add(this.crearCondicion(condicion));
		}

		return condiciones;
	}

	public Condicion crearCondicion(String condicionStr) {
		condicionStr = condicionStr.trim();
		condicionStr = condicionStr.endsWith(";") ? condicionStr.substring(0,
				condicionStr.length() - 1) : condicionStr;

		String[] datos = condicionStr.split(" ");
		List<String> datosCondicion = new ArrayList<String>();

		for (String dato : datos) {
			if (StringUtils.isNotBlank(dato)) {
				datosCondicion.add(dato);
			}
		}

		// si son mas de 3 argumentos, esta mal
		if (datosCondicion.size() != 3) {
			throw new CondicionMalFormadaException();
		}

		Condicion condicion = null;
		try {
			condicion = Condicion.crearCondicion(datosCondicion.get(0).trim(),
					datosCondicion.get(1).trim(), datosCondicion.get(2).trim());
		} catch (NumberFormatException e) {
			throw new CondicionMalFormadaException(e);
		}
		return condicion;
	}
}
