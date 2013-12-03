package ar.com.gemasms.util;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.avaje.ebean.annotation.EnumValue;

public enum Mes {

	@EnumValue(value = "1")
	ENERO(1L, "Enero"),

	@EnumValue(value = "2")
	FEBRERO(2L, "Febrero"),

	@EnumValue(value = "3")
	MARZO(3L, "Marzo"),

	@EnumValue(value = "4")
	ABRIL(4L, "Abril"),

	@EnumValue(value = "5")
	MAYO(5L, "Mayo"),

	@EnumValue(value = "6")
	JUNIO(6L, "Junio"),

	@EnumValue(value = "7")
	JULIO(7L, "Julio"),

	@EnumValue(value = "8")
	AGOSTO(8L, "Agosto"),

	@EnumValue(value = "9")
	SEPTIEMBRE(9L, "Septiembre"),

	@EnumValue(value = "10")
	OCTUBRE(10L, "Octubre"),

	@EnumValue(value = "11")
	NOVIEMBRE(11L, "Noviembre"),

	@EnumValue(value = "12")
	DICIEMBRE(12L, "Diciembre");

	private Long numero;

	private String nombre;

	private Mes(Long numero, String nombre) {
		this.numero = numero;
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Long getNumero() {
		return numero;
	}

	public void setNumero(Long numero) {
		this.numero = numero;
	}

	@Override
	public String toString() {
		return this.getNumero() + " - " + this.getNombre();
	}

	public static List<Mes> meses() {
		LinkedHashMap<String, String> meses = new LinkedHashMap<String, String>();

		for (Mes mes : Arrays.asList(ENERO, FEBRERO, MARZO, ABRIL, MAYO, JUNIO,
				JULIO, AGOSTO, SEPTIEMBRE, OCTUBRE, NOVIEMBRE, DICIEMBRE)) {
			meses.put(mes.getNumero().toString(), mes.getNombre());
		}

		return Arrays.asList(ENERO, FEBRERO, MARZO, ABRIL, MAYO, JUNIO, JULIO,
				AGOSTO, SEPTIEMBRE, OCTUBRE, NOVIEMBRE, DICIEMBRE);
	}

	public static Map<String, String> mesess() {
		LinkedHashMap<String, String> meses = new LinkedHashMap<String, String>();

		for (Mes mes : Arrays.asList(ENERO, FEBRERO, MARZO, ABRIL, MAYO, JUNIO,
				JULIO, AGOSTO, SEPTIEMBRE, OCTUBRE, NOVIEMBRE, DICIEMBRE)) {
			meses.put(mes.getNumero().toString(), mes.getNombre());
		}

		return meses;
	}
}
