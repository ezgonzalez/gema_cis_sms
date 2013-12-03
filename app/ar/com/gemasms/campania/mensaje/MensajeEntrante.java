package ar.com.gemasms.campania.mensaje;

public class MensajeEntrante extends MensajeAProcesar {

	@Override
	public void tratarMensaje() {
		this.getRegistro().tratarMensajeEntrante(this.getMensaje());
	}
}
