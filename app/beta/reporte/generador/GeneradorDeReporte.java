package beta.reporte.generador;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperPrintManager;
import play.Logger;
import play.Play;
import beta.reporte.generador.excepcion.ErrorAlGenerarElReporteException;
import controllers.ReporteController;

public class GeneradorDeReporte {

	public List<String> generarInformes(List<String> paginas,
			Map<String, Object> parametros, Connection conexionDB)
			throws ErrorAlGenerarElReporteException {

		List<String> pathsDeLasPaginas = new ArrayList<String>();

		for (String pagina : paginas) {
			pathsDeLasPaginas.add(this.obtenerPagina(parametros, pagina
					+ ".jrxml", pagina + ".jasper", conexionDB));
		}

		return pathsDeLasPaginas;
	}

	private String obtenerPagina(Map<String, Object> parametros, String jrxml,
			String jasper, Connection conexionDB)
			throws ErrorAlGenerarElReporteException {

		String pathRaizReportes = Play.application().path() + "/"
				+ Play.application().configuration().getString("informe.path");

		Logger.of(getClass()).error(parametros.toString());

		File archivoImagen = null;

		try {
			JasperCompileManager.compileReportToFile(pathRaizReportes + jrxml,
					pathRaizReportes + jasper);

			JasperPrint report = JasperFillManager.fillReport(pathRaizReportes
					+ jasper, parametros, conexionDB);

			archivoImagen = File.createTempFile(jasper, ".png");

			BufferedImage bufferedImage = obtenerBufferedImage(JasperPrintManager
					.printPageToImage(report, 0, 1f));
			ImageIO.write(bufferedImage, "PNG", archivoImagen);

			bufferedImage.getGraphics().dispose();
			bufferedImage = null;
		} catch (Exception e) {
			Logger.of(ReporteController.class).error(
					"Ocurrio un error inesperado al crear el reporte " + jrxml,
					e);

			throw new ErrorAlGenerarElReporteException(e);
		} finally {
			System.gc();
		}

		return archivoImagen.getAbsolutePath();
	}

	private BufferedImage obtenerBufferedImage(Image image) {
		BufferedImage bi = new BufferedImage(image.getWidth(null),
				image.getHeight(null), BufferedImage.TYPE_INT_RGB);

		bi.createGraphics().drawImage(image, 0, 0, null);

		return bi;
	}
}
