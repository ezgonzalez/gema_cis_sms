package controllers;

import static play.data.Form.form;
import models.campania.Campania;
import play.data.Form;
import play.mvc.Controller;
import play.mvc.Result;
import ar.com.gemasms.campania.ejecutor.EjecutorCampania;

public class CampaniaController extends Controller {

	public static Result HOME = redirect(routes.CampaniaController.listar(0,
			"mes", "asc", ""));

	public static Result nuevo() {
		Form<Campania> computerForm = form(Campania.class);
		return ok(views.html.campania.crear.render(computerForm));
	}

	public static Result guardar() {
		Form<Campania> campaniaForm = form(Campania.class).bindFromRequest();

		if (campaniaForm.hasErrors()) {
			return badRequest(views.html.campania.crear.render(campaniaForm));
		}

		campaniaForm.get().save();
		flash("success", "La campaña se ha creado exitosamente");

		return HOME;
	}

	public static Result listar(int page, String sortBy, String order,
			String filter) {
		return ok(views.html.campania.listar.render(
				Campania.page(page, 10, sortBy, order, filter), sortBy, order,
				filter));
	}

	public static Result editar(Long id) {
		Form<Campania> campaniaForm = form(Campania.class).fill(
				Campania.finder.byId(id));

		return ok(views.html.campania.editar.render(id, campaniaForm));
	}

	public static Result actualizar(Long id) {
		Form<Campania> campaniaForm = form(Campania.class).bindFromRequest();

		if (campaniaForm.hasErrors()) {
			return badRequest(views.html.campania.editar.render(id,
					campaniaForm));
		}

		campaniaForm.get().update(id);

		flash("success", "Se actualizó correctamente la campaña");

		return HOME;
	}

	/**
	 * Handle computer deletion
	 */
	public static Result eliminar(Long id) {
		Campania contacto = Campania.finder.ref(id);
		// contacto.setFechaBaja(FechasUtil.getInstance().obtenerFechaActual());
		contacto.update();

		flash("success", "El contacto fue eliminado");

		return HOME;
	}

	public static Result correr(Long id) {
		new EjecutorCampania().ejecutarCampania(Campania.finder.byId(id));
		return ok();
	}
}
