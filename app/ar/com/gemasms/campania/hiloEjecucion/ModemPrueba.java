package ar.com.gemasms.campania.hiloEjecucion;

import java.util.List;

import ar.com.gemasms.modem.IModem;

import com.google.common.collect.Lists;

public class ModemPrueba implements IModem {

	@Override
	public void enviarMensaje(String celular, String texto) {
		// TODO Auto-generated method stub

	}

	@Override
	public List<String[]> recibirMensajes() {
		String[] mensaje = new String[3];

		mensaje[0] = "1553235303";
		mensaje[1] = "probando la entrada";
		mensaje[2] = "1";

		List<String[]> list = Lists.newArrayList();
		list.add(mensaje);

		return list;
	}

	@Override
	public String consultarEstado() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void eliminarMensaje(String idMensaje) {
		// TODO Auto-generated method stub

	}

}
