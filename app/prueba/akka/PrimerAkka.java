package prueba.akka;

public class PrimerAkka {

	public static void main(String[] args) {
		PrimerCallable primerCallable = new PrimerCallable();
		primerCallable.start();

		try {
			Thread.sleep(10000);
			primerCallable.parar();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		System.out.println("PrimerAkka: termineeeeeeeeeeeeeeee");
	}
}
