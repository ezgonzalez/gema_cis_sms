package controllers;

import static play.data.Form.form;
import play.data.Form;
import play.mvc.Controller;
import play.mvc.Result;
import play.mvc.Security;
import seguridad.models.Usuario;
import beta.reporte.Reporte;

public class Application extends Controller {

	@Security.Authenticated(Secured.class)
	public static Result index() {
		if (Usuario.findByEmail(session("dni")) == null) {
			return badRequest(views.html.login.render(form(Login.class)));
		}

		return ok(views.html.reporte.reporte.render(form(Reporte.class),
				Usuario.findByEmail(session("dni"))));
	}

	// -- Authentication

	public static class Login {

		public String dni;
		public String password;

		public String validate() {
			if (Usuario.authenticate(dni, password) == null) {
				return "Usuario/Contraseña inválido";
			}
			return null;
		}

	}

	public static Result login() {
		return ok(views.html.login.render(form(Login.class)));
	}

	public static Result authenticate() {
		Form<Login> loginForm = form(Login.class).bindFromRequest();
		if (loginForm.hasErrors()) {
			return badRequest(views.html.login.render(loginForm));
		} else {
			session("dni", loginForm.get().dni);

			Usuario usuario = Usuario.findByEmail(loginForm.get().dni);

			return ok(views.html.reporte.reporte.render(form(Reporte.class),
					usuario));
		}
	}

	public static Result logout() {
		session().clear();
		flash("success", "You've been logged out");
		return redirect(routes.Application.login());
	}
}
