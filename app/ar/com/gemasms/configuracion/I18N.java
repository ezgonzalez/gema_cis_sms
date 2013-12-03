package ar.com.gemasms.configuracion;

import java.io.FileInputStream;
import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

import play.Logger;
import play.Logger.ALogger;
import play.Play;

public class I18N {

	protected static final ALogger logger = Logger.of(I18N.class);

	public static void initializeMessages(String propertiesPartName,
			Class<?> clazz) {
		Properties p = new Properties();
		String propertiesFileName = "";
		try {
			propertiesFileName = String.format("%s/%s.properties",
					propertiesPartName, clazz.getSimpleName());
			p.load(new FileInputStream(propertiesFileName));
		} catch (Exception e) {
			logger.error("Error cargando el archivo de propiedades '"
					+ propertiesFileName + "'", e);

			throw new RuntimeException(
					"Error cargando el archivo de propiedades '"
							+ propertiesFileName + "'", e);
		}

		for (Field f : clazz.getDeclaredFields())
			try {
				f.set(null,
						p.getProperty(f.getName(), "${" + f.getName() + "}"));
			} catch (Exception e) {
				if (!ignored(f.getName()))
					logger.debug(
							"No se (re)asigna la propiedad '"
									+ f.getDeclaringClass().getName() + "."
									+ f.getName() + "'", e);
			}

	}

	private static final String[] reservedConstants = { "UBICACION_ARCHIVO" };

	private static final Set<String> reserved = new HashSet<String>(
			Arrays.asList(reservedConstants));

	private static boolean ignored(String constantName) {
		return reserved.contains(constantName);
	}
}
