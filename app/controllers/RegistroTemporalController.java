package controllers;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

import models.Contacto;
import models.campania.Campania;
import models.campania.mensaje.MensajeCampania;
import models.campania.temporal.RegistroTemporal;
import play.mvc.Controller;
import ar.com.gemasms.campania.registro.util.CodigoTipoOperacion;
import ar.com.gemasms.campania.registro.util.Estado;

import com.google.common.collect.Lists;

public class RegistroTemporalController extends Controller {

	public static List<RegistroTemporal> crearRegistrosTemporales(
			final Campania campania, Set<Contacto> contactos) {
		List<RegistroTemporal> registrosFinales = Lists.newArrayList();

		final List<RegistroTemporal> registros = RegistroTemporal.finder
				.where().in("id_contacto", obtenerListaDeID(contactos))
				.eq("id_campania", campania.getId()).findList();

		for (Contacto contacto : contactos) {
			registrosFinales.add(crearRegistroTemporal(campania, contacto,
					registros));
		}

		return registrosFinales;
	}

	protected static RegistroTemporal crearRegistroTemporal(Campania campania,
			Contacto contacto, List<RegistroTemporal> registros) {

		for (RegistroTemporal registro : registros) {
			if (registro.esTuContacto(contacto)) {
				registros.remove(registro);
				return registro;
			}
		}

		RegistroTemporal registroTemporal = new RegistroTemporal();
		registroTemporal.setCampania(campania);
		registroTemporal.setContacto(contacto);
		registroTemporal.setEstado(Estado.INICIADO);
		// cargo el primer mensaje de la campaña
		registroTemporal.setMensaje(MensajeCampania
				.obtenerPrimerMensajeDeCampania(campania));
		registroTemporal.setOperacion(CodigoTipoOperacion.ESPERANDO_ENVIAR);

		registroTemporal.save();

		return registroTemporal;
	}

	private static List<Serializable> obtenerListaDeID(Set<Contacto> contactos) {
		List<Serializable> ids = Lists.newArrayList();

		for (Contacto contacto : contactos) {
			ids.add(contacto.getId());
		}

		return ids;
	}
}
