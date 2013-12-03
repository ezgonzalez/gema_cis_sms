package ar.com.gemasms.campania.mensaje.validacion.factory;

import org.codehaus.jackson.JsonNode;

import ar.com.gemasms.campania.mensaje.validacion.IValidacion;
import ar.com.gemasms.campania.mensaje.validacion.ValidacionRangoNumerico;

public class ValidacionRangoNumericoFactory extends
		ValidacionMensajeCampaniaFactory {

	protected ValidacionRangoNumericoFactory() {
	}

	@Override
	public IValidacion crearValidacion(JsonNode elementos) {
		return new ValidacionRangoNumerico(elementos.get("desde").asInt(),
				elementos.get("hasta").asInt());
	}
}
