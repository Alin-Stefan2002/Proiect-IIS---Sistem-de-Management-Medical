package org.datasource.jdbc.views.medicalappointments;

import org.datasource.jdbc.JDBCDataSourceConnector;
import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@Service
public class MedicalAppointmentsViewBuilder {
	// Interogarea catre tabela ta de programari
	private String SQL_APPOINTMENTS_SELECT =
			"SELECT appointment_id, patient_id, scheduled_day, appointment_day, sms_received, no_show " +
					"FROM appointments.medical_appointments";

	private List<MedicalAppointmentsView> appointmentsViewList = new ArrayList<>();

	public List<MedicalAppointmentsView> getViewList() {
		return this.appointmentsViewList;
	}

	public MedicalAppointmentsViewBuilder build() {
		try (Connection jdbcConnection = jdbcConnector.getConnection()) {
			Statement selectStmt = jdbcConnection.createStatement();
			ResultSet rs = selectStmt.executeQuery(SQL_APPOINTMENTS_SELECT);

			appointmentsViewList = new ArrayList<>();
			while (rs.next()) {
				// Citim din baza de date
				Long appointment_id = rs.getLong("appointment_id");
				Long patient_id = rs.getLong("patient_id");
				String scheduled_day = rs.getString("scheduled_day"); // citim ca text pt JSON
				String appointment_day = rs.getString("appointment_day");
				Integer sms_received = rs.getInt("sms_received");
				String no_show = rs.getString("no_show");
				if(no_show != null) no_show = no_show.trim();

				// Adaugam in lista
				this.appointmentsViewList.add(new MedicalAppointmentsView(
						appointment_id, patient_id, scheduled_day, appointment_day, sms_received, no_show
				));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return this;
	}

	/* JDBC Session Management */
	private JDBCDataSourceConnector jdbcConnector;

	public MedicalAppointmentsViewBuilder(JDBCDataSourceConnector jdbcConnector) {
		this.jdbcConnector = jdbcConnector;
	}
}