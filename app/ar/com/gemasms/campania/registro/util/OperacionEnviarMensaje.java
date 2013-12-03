package ar.com.gemasms.campania.registro.util;

import models.campania.temporal.RegistroTemporal;
import ar.com.gemasms.modem.BufferSMSFacade;

public class OperacionEnviarMensaje extends TipoOperacion {

	public OperacionEnviarMensaje() {
		super(CodigoTipoOperacion.ESPERANDO_ENVIAR);
	}

	@Override
	protected void ejecutarOperacion(RegistroTemporal registro) {
		BufferSMSFacade.insertarMensajeSaliente(registro.getCampania(),
				registro.getContacto(), registro.getMensajeDeTexto());

		registro.marcarParaEsperar();
	}
}
