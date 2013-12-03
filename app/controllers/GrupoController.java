package controllers;

import static play.data.Form.form;
import models.contacto.grupo.Grupo;
import play.data.Form;
import play.mvc.Controller;
import play.mvc.Result;

public class GrupoController extends Controller {

	public static Result HOME = redirect(routes.GrupoController.listar(0,
			"nombre", "asc", ""));

	public static Result nuevo() {
		Form<Grupo> grupoForm = form(Grupo.class);
		return ok(views.html.grupo.crear.render(grupoForm));
	}

	public static Result guardar() {
		Form<Grupo> grupoForm = form(Grupo.class).bindFromRequest();

		if (grupoForm.hasErrors()) {
			return badRequest(views.html.grupo.crear.render(grupoForm));
		}

		grupoForm.get().save();
		flash("success", "Grupo creado exitosamente");

		return HOME;
	}

	public static Result listar(int page, String sortBy, String order,
			String filter) {
		return ok(views.html.grupo.listar.render(
				Grupo.page(page, 10, sortBy, order, filter), sortBy, order,
				filter));
	}

	public static Result editar(Long id) {
		Form<Grupo> grupoForm = form(Grupo.class).fill(Grupo.finder.byId(id));

		return ok(views.html.grupo.editar.render(id, grupoForm));
	}

	public static Result actualizar(Long id) {
		Form<Grupo> grupoForm = form(Grupo.class).bindFromRequest();

		if (grupoForm.hasErrors()) {
			return badRequest(views.html.grupo.editar.render(id, grupoForm));
		}

		grupoForm.get().update(id);

		flash("success", "Se actualizó correctamente el grupo");

		return HOME;
	}

	/**
	 * Handle computer deletion
	 */
	public static Result eliminar(Long id) {
		Grupo grupo = Grupo.finder.ref(id);
		// grupo.setFechaBaja(FechasUtil.getInstance().obtenerFechaActual());
		grupo.update();

		flash("success", "Grupo eliminado");

		return HOME;
	}
}
