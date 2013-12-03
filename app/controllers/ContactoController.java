package controllers;

import static play.data.Form.form;

import java.util.Arrays;

import models.Contacto;
import models.contacto.grupo.Grupo;
import play.data.Form;
import play.i18n.Messages;
import play.mvc.Controller;
import play.mvc.Result;
import ar.com.gemasms.util.FechasUtil;

public class ContactoController extends Controller {

	private static final long ID_NUEVO = 0L;

	public static Result HOME = redirect(routes.ContactoController.listar(0,
			"nombre", "asc", ""));

	public static Result nuevo() {
		return ok(views.html.contacto.editar.render(ID_NUEVO,
				form(Contacto.class)));
	}

	public static Result guardar() {
		form(Contacto.class).bindFromRequest().get().save();
		return HOME;
	}

	public static Result listar(int page, String sortBy, String order,
			String filter) {
		return ok(views.html.contacto.listar.render(
				Contacto.page(page, 10, sortBy, order, filter), sortBy, order,
				filter));
	}

	public static Result editar(Long id) {
		return ok(views.html.contacto.editar.render(id, form(Contacto.class)
				.fill(Contacto.finder.byId(id))));
	}

	public static Result actualizar(Long id) {
		Form<Contacto> contactoForm = form(Contacto.class).bindFromRequest();

		if (contactoForm.hasErrors()) {
			return badRequest(views.html.contacto.editar.render(id,
					contactoForm));
		}

		String[] checkedVal = request().body().asFormUrlEncoded()
				.get("listaDeGrupos");
		if (checkedVal != null) {
			for (String grupoId : Arrays.asList(checkedVal)) {
				contactoForm.get().getGrupos()
						.add(Grupo.finder.byId(Long.parseLong(grupoId)));
			}
		}

		if (id == ID_NUEVO) {
			contactoForm.get().save();
		} else {
			contactoForm.get().update(id);
		}

		flash("success", Messages.get("contacto.edicion.success", contactoForm
				.get().toString()));

		return HOME;
	}

	/**
	 * Handle computer deletion
	 */
	public static Result eliminar(Long id) {
		Contacto contacto = Contacto.finder.ref(id);
		contacto.setFechaBaja(FechasUtil.getInstance().obtenerFechaActual());
		contacto.update();

		flash("success", "El contacto fue eliminado");

		return HOME;
	}
}
