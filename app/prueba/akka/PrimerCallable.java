package prueba.akka;

public class PrimerCallable extends Thread {

	boolean seguir = true;

	@Override
	public void run() {
		while (seguir) {
			for (int i = 0; i < 10; i++) {
				System.out
						.println("PrimerCallable paso por aca es un ejecucion "
								+ i);

				try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}
		System.out.println("FIN THREAD");
	}

	public void parar() {
		this.seguir = false;
	}
}
