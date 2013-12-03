package ar.com.gemasms.modem;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Random;

import models.modem.Modem;

public class ModemCompuesto implements IModem {

	private List<IModem> modems = Modem.activosParaEnviar();

	@Override
	public void enviarMensaje(String celular, String texto) {
		this.obtenerModemAlAzar().enviarMensaje(celular, texto);
	}

	protected IModem obtenerModemAlAzar() {
		return this.modems.get(new Random(Calendar.getInstance()
				.getTimeInMillis()).nextInt(this.modems.size()));
	}

	@Override
	public List<String[]> recibirMensajes() {
		List<String[]> mensajes = new ArrayList<String[]>();

		for (IModem modem : this.modems) {
			mensajes.addAll(modem.recibirMensajes());
		}

		return mensajes;
	}

	@Override
	public String consultarEstado() {
		StringBuilder estado = new StringBuilder();

		for (IModem modem : this.modems) {
			estado.append(" - ").append(modem.consultarEstado());
		}

		return estado.toString();
	}

	@Override
	public void eliminarMensaje(String idMensaje) {
		for (IModem modem : this.modems) {
			modem.eliminarMensaje(idMensaje);
		}
	}
}
