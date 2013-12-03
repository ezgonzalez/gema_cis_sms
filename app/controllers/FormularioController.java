package controllers;

import models.campania.mensaje.respuesta.Respuesta;
import play.data.Form;
import play.mvc.Controller;
import play.mvc.Result;
import play.mvc.Security;
import seguridad.models.Usuario;
import ar.com.gemasms.campania.formulario.ConfiguracionFormulario;

@Security.Authenticated(Secured.class)
public class FormularioController extends Controller {

	public static Result generar() {
		return ok(views.html.formulario.formulario.render(
				play.data.Form.form(ConfiguracionFormulario.class),
				Usuario.findByEmail(session("dni"))));
	}

	public static Result hacer() {
		Form<ConfiguracionFormulario> reporteForm = play.data.Form.form(
				ConfiguracionFormulario.class).bindFromRequest();

		Long id = reporteForm.get().campaniaAResponder.getId();

		new RuntimeException(id.toString());

		return redirect(routes.FormularioController.mostrar(id));
	}

	public static Result mostrar(Long campania) {
		return ok(views.html.formulario.formulario_preguntas.render(
				Respuesta.obtenerMensajesYRespuestas(campania, ""),
				Usuario.findByEmail(session("dni"))));
	}
}
