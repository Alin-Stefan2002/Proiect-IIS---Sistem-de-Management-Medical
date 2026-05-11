package org.datasource;

import org.datasource.jdbc.JDBCDataSourceConnector;
import org.datasource.jdbc.views.patients.PatientView;
import org.datasource.jdbc.views.patients.PatientViewBuilder;
import org.datasource.jdbc.views.medicalappointments.MedicalAppointmentsView;
import org.datasource.jdbc.views.medicalappointments.MedicalAppointmentsViewBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

/* Noile tale adrese pentru testare in browser:
    http://localhost:8090/DSA-SQL-JDBCService/rest/medical/ping
    http://localhost:8090/DSA-SQL-JDBCService/rest/medical/PatientView
    http://localhost:8090/DSA-SQL-JDBCService/rest/medical/MedicalAppointmentsView
*/
@RestController
@RequestMapping("/medical")
public class RESTViewServiceJDBC {
	private static Logger logger = Logger.getLogger(RESTViewServiceJDBC.class.getName());

	@RequestMapping(value = "/ping", method = RequestMethod.GET,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	@ResponseBody
	public String ping() {
		logger.info(">>>> DSA-SQL-JDBCService (Medical):: RESTViewService is Up!");
		return "Ping response from Medical JDBC Service!";
	}

	// ==========================================
	// ENDPOINT 1: PACIENTI
	// ==========================================
	@RequestMapping(value = "/PatientView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<PatientView> get_PatientView() {
		return patientViewBuilder.build().getViewList();
	}

	@RequestMapping(value = "/PatientViewData", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<PatientView> get_PatientView(
			@RequestParam("fetch_offset") Integer fetchOffset,
			@RequestParam("fetch_size") Integer fetchSize
	) {
		return patientViewBuilder
				.setFetchOffset(fetchOffset)
				.setFetchSize(fetchSize)
				.build().getViewList();
	}

	// ==========================================
	// ENDPOINT 2: PROGRAMARI MEDICALE (NOU)
	// ==========================================
	@RequestMapping(value = "/MedicalAppointmentsView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<MedicalAppointmentsView> get_AppointmentsView() {
		return appointmentsViewBuilder.build().getViewList();
	}

	// ==========================================
	// DEPENDENTE (Set-up)
	// ==========================================
	@Autowired private JDBCDataSourceConnector jdbcConnector;

	@Autowired private PatientViewBuilder patientViewBuilder;

	// 3. NOU: Injectam builder-ul pentru programari
	@Autowired private MedicalAppointmentsViewBuilder appointmentsViewBuilder;
}