package ar.com.gemasms.campania.mensaje.validacion.factory;

import org.codehaus.jackson.JsonNode;

import ar.com.gemasms.campania.mensaje.validacion.IValidacion;
import ar.com.gemasms.campania.mensaje.validacion.ValidacionInclusion;

public class ValidacionInclusionFactory extends
		ValidacionMensajeCampaniaFactory {

	protected ValidacionInclusionFactory() {
	}

	@Override
	public IValidacion crearValidacion(JsonNode elementos) {
		ValidacionInclusion validacionInclusion = new ValidacionInclusion();
		validacionInclusion.setCodigoPregunta(elementos.get("codigo").asText());

		return validacionInclusion;
	}

}
