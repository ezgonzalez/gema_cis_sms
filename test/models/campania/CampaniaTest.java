package models.campania;

import static org.fest.assertions.Assertions.assertThat;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import models.Contacto;
import models.campania.mensaje.MensajeCampania;
import models.campania.temporal.RegistroTemporal;
import models.contacto.grupo.Grupo;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import builder.ContactoBuilder;
import builder.ModeloFacade;
import play.db.ebean.Transactional;
import play.test.FakeApplication;
import play.test.Helpers;
import play.test.WithApplication;

public class CampaniaTest extends WithApplication {

	private FakeApplication app;

	@Before
	public void startApp() throws Exception {
		Map<String, String> settings = new HashMap<String, String>();
		settings.put("db.default.driver", "com.mysql.jdbc.Driver");
		settings.put("db.default.user", "root");
		settings.put("db.default.password", "");
		settings.put("db.default.url", "jdbc:mysql://localhost:3306/gema");
		settings.put("db.default.jndiName", "DefaultDS");

		app = Helpers.fakeApplication(Helpers.inMemoryDatabase());

		Helpers.start(app);
	}

	@After
	public void stopApp() throws Exception {
		Helpers.stop(app);
	}

	@Test
	@Transactional
	public void crearRegistroTemporalDeCampania() {
		Campania campania = new Campania();
		campania.setDescripcion("Campaña Test");
		campania.getGrupo().add(this.crearGrupoConDosContactos());
		campania.getMensajes().add(this.crearMensajeDeCampania());

		campania.save();

		campania.cargarRegistroTemporales();

		assertThat(Campania.finder.byId(campania.getId()).getRegistros().size())
				.isEqualTo(2);
	}

	private MensajeCampania crearMensajeDeCampania() {
		MensajeCampania mensajeCampania = new MensajeCampania();
		mensajeCampania.setCodigoMensaje("DESAPROBADOS");
		mensajeCampania.setMensaje("Prueba");
		return mensajeCampania;
	}

	private Grupo crearGrupoConDosContactos() {
		Grupo grupo = new Grupo();

		grupo.getContactos().add(ModeloFacade.crearContacto());
		grupo.getContactos().add(ModeloFacade.crearContacto());

		return grupo;
	}
}
