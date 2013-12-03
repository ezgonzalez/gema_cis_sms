package ar.com.gemasms.campania.mensaje.validacion.factory;

import java.util.HashMap;
import java.util.Map;

import org.codehaus.jackson.JsonNode;

import ar.com.gemasms.campania.mensaje.validacion.IValidacion;

public abstract class ValidacionMensajeCampaniaFactory {

	private static Map<String, ValidacionMensajeCampaniaFactory> fabricas = new HashMap<String, ValidacionMensajeCampaniaFactory>();

	static {
		fabricas.put("inclusion", new ValidacionInclusionFactory());
		fabricas.put("numerica", new ValidacionNumericaFactory());
		fabricas.put("numero", new ValidacionRangoNumericoFactory());
	}

	public static ValidacionMensajeCampaniaFactory fabricaConcreta(String codigo) {
		return fabricas.get(codigo);
	}

	public abstract IValidacion crearValidacion(JsonNode elementos);
}
