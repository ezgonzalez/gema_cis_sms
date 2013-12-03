package ar.com.gemasms.modem;

import java.util.List;

public interface IModem {

	void enviarMensaje(String celular, String texto);

	List<String[]> recibirMensajes();

	String consultarEstado();

	void eliminarMensaje(String idMensaje);
}
