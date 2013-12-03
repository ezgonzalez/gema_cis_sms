package ar.com.gemasms.campania.ejecutor;


public class MensajeDeCorreccionIncorrectoException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public MensajeDeCorreccionIncorrectoException(String mensaje) {
		super(mensaje);
	}
}
