package ar.com.gemasms.modem.excepcion;

public class NoPudoEnviarseElMensajeException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public NoPudoEnviarseElMensajeException(String telefono) {
        super("No se pudo enviar el SMS a '" + telefono + "'.");
    }
}
