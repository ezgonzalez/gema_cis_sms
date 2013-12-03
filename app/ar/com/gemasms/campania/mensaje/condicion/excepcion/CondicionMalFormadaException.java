package ar.com.gemasms.campania.mensaje.condicion.excepcion;

public class CondicionMalFormadaException extends RuntimeException {

    private static String MENSAJE = "";

    public CondicionMalFormadaException(Throwable causa) {
        super(MENSAJE, causa);
    }

    public CondicionMalFormadaException() {
        super(MENSAJE);
    }

    private static final long serialVersionUID = 1L;

}
