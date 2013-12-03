package ar.com.gemasms.campania.mensaje.correccion;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import models.mensaje.Mensaje;

import org.apache.commons.lang.StringUtils;

import com.google.common.collect.Iterables;

public class CorreccionDeRespuesta {

	public static String PREFIJO = "CORREGIR ";

	private String codigoPregunta;

	private String nuevoValor;

	private Mensaje mensaje;

	public CorreccionDeRespuesta() {
	}

	public void parsearParametros(String mensaje) {
		mensaje = StringUtils.upperCase(mensaje);
		List<String> parametros = this.obtenerParametros(mensaje);

		if (parametros.size() != 3
				|| !CorreccionDeRespuesta.esDeCorrecion(parametros.get(0))) {
			this.codigoPregunta = "";
			this.nuevoValor = "";
		} else {
			this.codigoPregunta = parametros.get(1);
			this.nuevoValor = parametros.get(2);
		}
	}

	protected List<String> obtenerParametros(String mensaje) {
		List<String> parametros = new ArrayList<String>(Arrays.asList(mensaje
				.trim().split(" ")));
		Iterables.removeAll(parametros, Collections.singleton(""));
		return parametros;
	}

	public static boolean esDeCorrecion(String mensaje) {
		return CorreccionDeRespuesta.PREFIJO.equals(mensaje.trim());
	}

	public String getCodigoPregunta() {
		return codigoPregunta;
	}

	public void setCodigoPregunta(String codigoPregunta) {
		this.codigoPregunta = codigoPregunta;
	}

	public String getNuevoValor() {
		return nuevoValor;
	}

	public void setNuevoValor(String nuevoValor) {
		this.nuevoValor = nuevoValor;
	}

	public Mensaje getMensaje() {
		return this.mensaje;
	}

	public void setMensaje(Mensaje mensaje) {
		this.mensaje = mensaje;
	}
}
