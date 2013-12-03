package ar.com.gemasms.campania.mensaje.validacion.factory;

import org.codehaus.jackson.JsonNode;

import ar.com.gemasms.campania.mensaje.validacion.IValidacion;
import ar.com.gemasms.campania.mensaje.validacion.ValidacionNumerica;

public class ValidacionNumericaFactory extends ValidacionMensajeCampaniaFactory {

	protected ValidacionNumericaFactory() {
	}

	@Override
	public IValidacion crearValidacion(JsonNode elementos) {
		return new ValidacionNumerica();
	}

}
