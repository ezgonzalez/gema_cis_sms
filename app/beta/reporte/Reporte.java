package beta.reporte;

import java.util.List;

import models.Contacto;
import models.Departamento;
import models.Provincia;
import play.Logger;
import play.data.validation.Constraints.Required;
import ar.com.gemasms.util.Mes;

import com.avaje.ebean.Ebean;
import com.avaje.ebean.SqlRow;

public class Reporte {

	@Required
	public String anio = null;

	@Required
	public Mes mes;

	public Provincia provincia = null;

	public Departamento departamento = null;

	public Contacto supervisor = null;

	public String mensaje = "";

	public String getAnio() {
		return anio;
	}

	public void setAnio(String anio) {
		this.anio = anio;
	}

	public Mes getMes() {
		return mes;
	}

	public void setMes(Mes mes) {
		this.mes = mes;
	}

	public Provincia getProvincia() {
		return provincia;
	}

	public void setProvincia(Provincia provincia) {
		this.provincia = provincia;
	}

	public Departamento getDepartamento() {
		return departamento;
	}

	public void setDepartamento(Departamento departamento) {
		this.departamento = departamento;
	}

	public Contacto getSupervisor() {
		return supervisor;
	}

	public void setSupervisor(Contacto supervisor) {
		this.supervisor = supervisor;
	}

	public String getElMes() {
		return this.mes != null ? this.mes.getNumero().toString() : "";
	}

	public void setElMes(String numero) {
		this.mes = Mes.meses().get(Integer.parseInt(numero) - 1);
	}

	public String obtenerQuery() {

		String from = " from v_informe_campania_por_provincia ";
		String where = " where anio = " + anio + " and mes = "
				+ mes.getNumero() + " ";

		if (provincia != null && provincia.id != null) {
			where = where + " and id_provincia = " + provincia.id.toString()
					+ " ";
			from = "from v_informe_campania_por_provincia ";
		}

		if (departamento != null && departamento.id != null) {
			where = where + " and id_departamento = "
					+ departamento.id.toString() + " ";
			from = "from v_informe_campania_por_departamento ";
		}

		if (supervisor != null && supervisor.getId() != null) {
			where = where + " and id_supervisor = "
					+ supervisor.getId().toString() + " ";
			from = "from v_informe_campania_por_supervisor ";
		}

		Logger.of(getClass()).error("select * " + from + " " + where);
		return "select * " + from + " " + where;
	}

	public boolean existenDatos(String servidorBD) {
		List<SqlRow> resultado = Ebean.getServer(servidorBD)
				.createSqlQuery(this.obtenerQuery()).findList();

		return resultado == null || resultado.size() < 1;
	}

	public boolean esPorProvincia() {
		return (provincia != null && provincia.id != null)
				&& (!this.esPorDepartamento()) && (!this.esPorSupervisor());
	}

	public boolean esPorDepartamento() {
		return (departamento != null && departamento.id != null)
				&& !this.esPorSupervisor();
	}

	public boolean esPorSupervisor() {
		Logger.of(getClass()).error(supervisor.toString());
		return supervisor != null && supervisor.getId() != null;
	}
}
