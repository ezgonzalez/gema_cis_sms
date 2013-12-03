package beta.reporte.generador.excepcion;

public class ErrorAlGenerarElReporteException extends Exception {

	private static final long serialVersionUID = 1L;

	public ErrorAlGenerarElReporteException(Exception e) {
		super("Ocurrió un error inesperado al generar el reporte", e);
	}
}
