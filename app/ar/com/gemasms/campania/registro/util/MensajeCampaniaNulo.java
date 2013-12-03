package ar.com.gemasms.campania.registro.util;

import java.util.List;

import models.campania.mensaje.MensajeCampania;
import models.campania.temporal.RegistroTemporal;
import ar.com.gemasms.campania.mensaje.validacion.IValidacion;

import com.google.common.collect.Lists;

public class MensajeCampaniaNulo extends MensajeCampania {

	private static final long serialVersionUID = 1L;

	public static MensajeCampaniaNulo INSTANCE = new MensajeCampaniaNulo();

	@Override
	public List<IValidacion> getValidacionesDelMensaje() {
		return Lists.newArrayList();
	}

	public static MensajeCampaniaNulo getInstance() {
		return new MensajeCampaniaNulo();
	}

	@Override
	public void validarMensaje(RegistroTemporal registroTemporal,
			String smsTexto, List<String> validacionesNoPasadas) {
	}
}
