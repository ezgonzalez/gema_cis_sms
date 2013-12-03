package ar.com.gemasms.util;

import java.util.List;

import models.campania.mensaje.respuesta.Respuesta;

import com.google.common.base.Predicate;
import com.google.common.collect.Iterables;

public abstract class Condicion {

	private static String MAYOR = "MAYOR";

	private static String MAYORIGUAL = "MAYORIGUAL";

	private static String MENOR = "MENOR";

	private static String MENORIGUAL = "MENORIGUAL";

	private static String IGUAL = "IGUAL";

	private static String DISTINTO = "DISTINTO";

	public String codigoPregunta;

	public long valor;

	private Condicion() {
	}

	public static Condicion crearCondicion(String condigoPregunta,
			String codigoCondicion, String valorCondicion) {

		Condicion condicion = null;

		if (codigoCondicion.equals(MAYOR)) {
			condicion = new Condicion.CondicionMayor();
		} else if (codigoCondicion.equals(MAYORIGUAL)) {
			condicion = new CondicionMayorIgual();
		} else if (codigoCondicion.equals(MENOR)) {
			condicion = new CondicionMenor();
		} else if (codigoCondicion.equals(MENORIGUAL)) {
			condicion = new CondicionMenorIgual();
		} else if (codigoCondicion.equals(IGUAL)) {
			condicion = new CondicionIgual();
		} else if (codigoCondicion.equals(DISTINTO)) {
			condicion = new CondicionDistinto();
		} else {
			condicion = new CondicionNula();
		}

		condicion.setCodigoPregunta(condigoPregunta);
		condicion.setValor(Long.parseLong(valorCondicion));

		return condicion;
	}

	public boolean cumple(List<Respuesta> respuestas) {
		Respuesta respuesta = Iterables.find(respuestas,
				new Predicate<Respuesta>() {

					@Override
					public boolean apply(Respuesta respuesta) {
						return respuesta.getCodigoMensaje().equals(
								codigoPregunta);
					}
				}, null);

		return respuesta == null || this.cumple(respuesta);
	}

	protected abstract boolean cumple(Respuesta respuesta);

	public String getCodigoPregunta() {
		return codigoPregunta;
	}

	public void setCodigoPregunta(String codigoPregunta) {
		this.codigoPregunta = codigoPregunta;
	}

	public long getValor() {
		return valor;
	}

	public void setValor(long valor) {
		this.valor = valor;
	}

	public static class CondicionMayor extends Condicion {

		@Override
		protected boolean cumple(Respuesta respuesta) {
			return Long.parseLong(respuesta.getRespuesta()) > this.getValor();
		}

	}

	public static class CondicionMayorIgual extends Condicion {

		@Override
		protected boolean cumple(Respuesta respuesta) {
			return Long.parseLong(respuesta.getRespuesta()) >= this.getValor();
		}

	}

	public static class CondicionMenor extends Condicion {

		@Override
		protected boolean cumple(Respuesta respuesta) {
			return Long.parseLong(respuesta.getRespuesta()) < this.getValor();
		}

	}

	public static class CondicionMenorIgual extends Condicion {

		@Override
		protected boolean cumple(Respuesta respuesta) {
			return Long.parseLong(respuesta.getRespuesta()) <= this.getValor();
		}

	}

	public static class CondicionIgual extends Condicion {

		@Override
		protected boolean cumple(Respuesta respuesta) {
			return Long.parseLong(respuesta.getRespuesta()) == this.getValor();
		}

	}

	public static class CondicionDistinto extends Condicion {

		@Override
		protected boolean cumple(Respuesta respuesta) {
			return Long.parseLong(respuesta.getRespuesta()) != this.getValor();
		}

	}

	public static class CondicionNula extends Condicion {

		@Override
		protected boolean cumple(Respuesta respuesta) {
			return true;
		}

	}
}
