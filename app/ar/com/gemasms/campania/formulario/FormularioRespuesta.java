package ar.com.gemasms.campania.formulario;

import java.util.ArrayList;
import java.util.List;

import models.Institucion;
import models.campania.Campania;
import models.campania.mensaje.MensajeCampania;
import models.campania.mensaje.respuesta.Respuesta;
import scala.Tuple2;

public class FormularioRespuesta {

	public List<Tuple2<MensajeCampania, Respuesta>> mensajesConRespuestas = new ArrayList<Tuple2<MensajeCampania, Respuesta>>();

	public FormularioRespuesta(Campania campania, Institucion institucion) {

		// agrego todos los mensajes
		for (MensajeCampania mensaje : MensajeCampania
				.obtenerTodosLosMensajes(campania)) {

			this.mensajesConRespuestas
					.add(new Tuple2<MensajeCampania, Respuesta>(mensaje, null));
		}

		// agrego aquellos que ya tienen respuesta
		for (Respuesta respuesta : Respuesta.obtenerRespuestas(campania,
				institucion)) {
			this.mensajesConRespuestas.put(respuesta.getMensajeCampania(),
					respuesta);
		}
	}
}
