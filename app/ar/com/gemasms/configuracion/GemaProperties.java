package ar.com.gemasms.configuracion;

public class GemaProperties extends I18N {

	static {
		// Carga el valor de los mensajes desde el archivo desde el Bundle
		I18N.initializeMessages(GemaProperties.UBICACION_ARCHIVO,
				GemaProperties.class);
	}

	protected static final String UBICACION_ARCHIVO = ".";

	public static String NOMBRE_ENTRADA;

	public static String NOMBRE_PROCESADOR;

	public static String NOMBRE_SALIDA;

	public static String PATH_INFORMES;
}
