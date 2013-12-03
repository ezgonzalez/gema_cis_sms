package ar.com.gemasms.modem;

import java.util.List;

import models.BufferSMS;
import models.Contacto;
import models.campania.Campania;
import models.mensaje.Mensaje;
import ar.com.gemasms.util.EstadoBuffer;
import ar.com.gemasms.util.FechasUtil;
import ar.com.gemasms.util.MensajeFactory;

public class BufferSMSFacade {

	public static void insertarMensajeEntrante(Campania campania,
			Mensaje mensaje) {
		BufferSMS bufferSMS = new BufferSMS();

		bufferSMS.setCampania(campania);
		bufferSMS.setMensaje(mensaje);
		bufferSMS.setEstado(EstadoBuffer.PROCESAR);

		bufferSMS.save();
	}

	public static void insertarMensajeSaliente(Campania campania,
			Contacto contacto, String texto) {
		BufferSMS bufferSMS = new BufferSMS();

		bufferSMS.setCampania(campania);
		bufferSMS.setMensaje(MensajeFactory.getInstance().crearMensajeSaliente(
				contacto, texto));
		bufferSMS.setEstado(EstadoBuffer.ENVIAR);
		bufferSMS
				.setHoraCreacion(FechasUtil.getInstance().obtenerFechaActual());

		bufferSMS.save();
	}

	public static List<BufferSMS> obtenerMensajesAProcesar(Campania campania) {
		return BufferSMS.obtenerAProcesar(campania);
	}

	public static List<BufferSMS> obtenerMensajesAEnviar(Campania campania) {
		return BufferSMS.obtenerAEnviar(campania);
	}
}
