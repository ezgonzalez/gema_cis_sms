package ar.com.gemasms.modem;

public enum TipoRespuestaModem {
	OK,
	WAIT,
	ERROR,
	WMSG,
	RMSG,
	ECHO,
	TIMEOUT;
	
	public boolean esConError() {
		return ERROR.equals(this);
	}
	
	public boolean esOK() {
		return OK.equals(this);
	}
}
