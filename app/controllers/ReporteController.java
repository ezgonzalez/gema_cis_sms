package controllers;

import static play.data.Form.form;

<<<<<<< HEAD
import java.io.File;
import java.util.List;
=======
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
>>>>>>> refs/remotes/origin/master

import play.data.Form;
import play.db.DB;
import play.mvc.Controller;
import play.mvc.Result;
import play.mvc.Security;
import seguridad.models.Usuario;
import beta.reporte.Reporte;
<<<<<<< HEAD
import beta.reporte.generador.Generador;
=======

import com.avaje.ebean.Ebean;
import com.avaje.ebean.SqlRow;
>>>>>>> refs/remotes/origin/master

@Security.Authenticated(Secured.class)
public class ReporteController extends Controller {

	public static Result generar() {
		Form<Reporte> reporteForm = form(Reporte.class).bindFromRequest();

		Usuario usuario = Usuario.findByEmail(session("dni"));

		if (reporteForm.hasErrors()) {
			return badRequest(views.html.reporte.reporte.render(reporteForm,
					usuario));
		}

		List<SqlRow> resultado = Ebean
				.getServer(Usuario.findByEmail(session("dni")).getServer())
				.createSqlQuery(reporteForm.get().obtenerQuery()).findList();

		if (resultado == null || resultado.size() < 1) {
			flash("sindatos", "No hay datos para los filtros elegidos");
			return redirect(routes.Application.index());
		}

		Reporte reporte = reporteForm.get();

		if (reporte.existenDatos(usuario.getServer())) {
			flash("sindatos", "No hay datos para los filtros elegidos");
			return redirect(routes.Application.index());
		}

		List<String> reportes = Generador.GENERADORES.generarReportes(reporte,
				DB.getConnection(Usuario.findByEmail(session("dni"))
						.getServer()));

		if (reportes.isEmpty()) {
			flash("sindatos",
					"Ocurrió un error interno al generar los informes. Intente nuevamente.");
			return redirect(routes.Application.index());
		}

		String mensaje = "";
		if (reporte.esPorDepartamento() || reporte.esPorSupervisor()) {
			mensaje = "Aviso: Dado que estas escuelas no han respondido a la totalidad de las campañas, los datos no son comparables en sentido estricto.";
		}

		return ok(views.html.reporte.listar.render(reportes, mensaje, usuario));
	}

<<<<<<< HEAD
	public static Result obtenerImagen(String imgPath) {
		return ok(new File(imgPath));
=======
	protected static Status obtenerResultadoDelInforme(Long mes, String anio,
			String idProvincia, String idDepartamento, String idSupervisor,
			String jrxml, String jasper) {
		ByteArrayOutputStream stream = new ByteArrayOutputStream();

		String pathRaizReportes = Play.application().path() + "/"
				+ Play.application().configuration().getString("informe.path");

		Map<String, Object> parametros = new HashMap<String, Object>();

		parametros.put("p_anio", anio);
		parametros.put("p_mes", mes);

		parametros.put("p_tabla", "v_informe_campania_por_provincia");

		if (!"".equals(idProvincia)) {
			parametros.put("p_id_provincia", idProvincia);
			parametros.put("p_tabla", "v_informe_campania_por_provincia");
		}

		if (!"".equals(idDepartamento)) {
			parametros.put("p_id_departamento", idDepartamento);
			parametros.put("p_tabla", "v_informe_campania_por_departamento");
		}

		if (!"".equals(idSupervisor)) {
			parametros.put("p_id_supervisor", idSupervisor);
			parametros.put("p_tabla", "v_informe_campania_por_supervisor");
		}

		try {
			JasperCompileManager.compileReportToFile(pathRaizReportes + jrxml,
					pathRaizReportes + jasper);

			JasperPrint report = (JasperPrint) JasperFillManager.fillReport(
					pathRaizReportes + jasper, parametros, DB
							.getConnection(Usuario.findByEmail(session("dni"))
									.getServer()));

			ImageIO.write(obtenerBufferedImage(JasperPrintManager
					.printPageToImage(report, 0, 1f)), "JPEG", stream);
		} catch (JRException e) {

			Logger.of(ReporteController.class).error(
					"Ocurrio un error al crear el reporte", e);
		} catch (IOException e) {
			Logger.of(ReporteController.class).error(
					"Ocurrio un error al crear el reporte", e);
		}

		Status as = ok(stream.toByteArray()).as("image/jpeg");
		return as;
	}

	private static BufferedImage obtenerBufferedImage(Image image) {
		BufferedImage bi = new BufferedImage(image.getWidth(null),
				image.getHeight(null), BufferedImage.TYPE_INT_RGB);

		bi.createGraphics().drawImage(image, 0, 0, null);

		return bi;
>>>>>>> refs/remotes/origin/master
	}
}
