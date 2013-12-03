package ar.com.gemasms.campania.hiloEjecucion;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import ar.com.gemasms.configuracion.GemaProperties;

public class EstadoAplicacion {

	private final static String DIRECTORIO_PROCESO = "C:/Users/ezgonzalez/Documents/Unicef/Works/gema/proc/";// System.getenv("");

	public final static String PLANTILLA_NOMBRE_ARCHIVO_ESTADO = "EstadoAplicacion%s.properties";

	private final static String ARRIBA = "1";

	private final static String CAIDO = "0";

	public synchronized static void crearEstadoDeAplicacion(String campania) {
		String archivoDeEstado = DIRECTORIO_PROCESO + "/"
				+ String.format(PLANTILLA_NOMBRE_ARCHIVO_ESTADO, campania);

		File directorio = new File(DIRECTORIO_PROCESO);
		if (!(directorio.isDirectory() && directorio.exists())) {
			directorio.mkdirs();
		}

		File archivoEstado = new File(archivoDeEstado);
		if (!archivoEstado.exists()) {
			try {
				archivoEstado.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public synchronized static void levantarHiloDeSalida(String campania) {
		levantarHiloDeCampania(GemaProperties.NOMBRE_SALIDA, campania);
	}

	public synchronized static void levantarHiloDeProceso(String campania) {
		levantarHiloDeCampania(GemaProperties.NOMBRE_PROCESADOR, campania);
	}

	public synchronized static void levantarHiloDeEntrada(String campania) {
		levantarHiloDeCampania(GemaProperties.NOMBRE_ENTRADA, campania);
	}

	private static Properties cargarEstado(String campania) {
		Properties properties = new Properties();

		try {
			properties.load(new FileInputStream(
					getNombreArchivoEstado(campania)));
		} catch (IOException ex) {
			ex.printStackTrace();
		}

		return properties;
	}

	private static String getNombreArchivoEstado(String campania) {
		return DIRECTORIO_PROCESO + "/"
				+ String.format(PLANTILLA_NOMBRE_ARCHIVO_ESTADO, campania);
	}

	private static boolean elHiloDeCampaniaEstaArriba(String nombreHilo,
			String campania) {
		return ARRIBA.compareTo(cargarEstado(campania).getProperty(nombreHilo)) == 0;
	}

	private static void matarHiloDeCampania(String nombreHilo, String campania) {
		modificarPropiedad(nombreHilo, campania, CAIDO);
	}

	private static void levantarHiloDeCampania(String nombreHilo,
			String campania) {
		modificarPropiedad(nombreHilo, campania, ARRIBA);
	}

	private static void modificarPropiedad(String nombreHilo, String campania,
			String valor) {
		Properties estado = cargarEstado(campania);
		estado.setProperty(nombreHilo, valor);
		try {
			estado.store(
					new FileOutputStream(getNombreArchivoEstado(campania)),
					"ACTUALIZACION DE ESTADO DE HILOS");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public synchronized static boolean hiloDeEntradaArriba(String campania) {
		return elHiloDeCampaniaEstaArriba(GemaProperties.NOMBRE_ENTRADA,
				campania);
	}

	public synchronized static boolean hiloDeProcesoArriba(String campania) {
		return elHiloDeCampaniaEstaArriba(GemaProperties.NOMBRE_PROCESADOR,
				campania);
	}

	public synchronized static boolean hiloDeSalidaArriba(String campania) {
		return !elHiloDeCampaniaEstaArriba(GemaProperties.NOMBRE_SALIDA,
				campania);
	}

	public synchronized static boolean hiloDeEntradaCaido(String campania) {
		return !elHiloDeCampaniaEstaArriba(GemaProperties.NOMBRE_ENTRADA,
				campania);
	}

	public synchronized static boolean hiloDeProcesoCaido(String campania) {
		return !elHiloDeCampaniaEstaArriba(GemaProperties.NOMBRE_PROCESADOR,
				campania);
	}

	public synchronized static boolean hiloDeSalidaCaido(String campania) {
		return !elHiloDeCampaniaEstaArriba(GemaProperties.NOMBRE_SALIDA,
				campania);
	}

	public synchronized static void matarHiloDeEntrada(String campania) {
		matarHiloDeCampania(GemaProperties.NOMBRE_ENTRADA, campania);
	}

	public synchronized static void matarHiloDeProceso(String campania) {
		matarHiloDeCampania(GemaProperties.NOMBRE_PROCESADOR, campania);
	}

	public synchronized static void matarHiloDeSalida(String campania) {
		matarHiloDeCampania(GemaProperties.NOMBRE_SALIDA, campania);
	}
}
