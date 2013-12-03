package ar.com.gemasms.campania.mensaje;

import models.Contacto;
import models.campania.Campania;
import models.campania.temporal.RegistroTemporal;
import models.mensaje.Mensaje;

public abstract class MensajeAProcesarFactory {

	private static MensajeDeCorreccionFactory correccionFactory = new MensajeDeCorreccionFactory();

	private static MensajeDeListadoFactory listadoFactory = new MensajeDeListadoFactory();

	private static MensajeEntranteFactory entranteFactory = new MensajeEntranteFactory();

	protected abstract MensajeAProcesar crearMensaje(Campania campania,
			Mensaje mensaje);

	public static MensajeAProcesar crearMensajeEntrante(Campania campania,
			Mensaje mensaje) {
		return MensajeAProcesarFactory.obtenerFactoryParaMensajeEntrante(
				mensaje).crearMensaje(campania, mensaje);
	}

	public static MensajeAProcesarFactory obtenerFactoryParaMensajeEntrante(
			Mensaje mensaje) {
		if (MensajeDeCorreccion.esDeCorreccion(mensaje)) {
			return correccionFactory;
		} else if (MensajeDeListado.esDeListado(mensaje)) {
			return listadoFactory;
		}

		return entranteFactory;
	}

	protected RegistroTemporal obtenerRegistro(Campania campania,
			Contacto contacto) {
		return RegistroTemporal.finder.where().eq("contacto", contacto)
				.eq("campania", campania).findUnique();
	}
}
