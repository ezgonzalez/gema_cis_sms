package controllers;

import static play.data.Form.form;

import java.io.File;
import java.util.List;

import play.data.Form;
import play.db.DB;
import play.mvc.Controller;
import play.mvc.Result;
import play.mvc.Security;
import seguridad.models.Usuario;
import beta.reporte.Reporte;
import beta.reporte.generador.Generador;

import com.avaje.ebean.Ebean;
import com.avaje.ebean.SqlRow;

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

	public static Result obtenerImagen(String imgPath) {
		return ok(new File(imgPath));

	}
}
