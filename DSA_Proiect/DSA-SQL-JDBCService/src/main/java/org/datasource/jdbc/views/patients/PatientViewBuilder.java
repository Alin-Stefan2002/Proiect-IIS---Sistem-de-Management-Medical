package org.datasource.jdbc.views.patients;

import org.datasource.jdbc.JDBCDataSourceConnector;
import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class PatientViewBuilder {
	private static Logger logger = Logger.getLogger(PatientViewBuilder.class.getName());

	// 1. MODIFICAT: Query-ul adaptat pentru tabela ta din PostgreSQL
	private String SQL_PATIENTS_SELECT = "SELECT patient_id, gender, age, neighbourhood, scholarship, hipertension, diabetes, alcoholism, handcap FROM appointments.patients";

	private Integer fetchOffset = -1;
	private Integer fetchSize = 25;

	// 2. MODIFICAT: Lista de pacienți în loc de clienți
	private List<PatientView> patientsViewList = new ArrayList<>();

	public List<PatientView> getViewList() {
		return this.patientsViewList;
	}

	// building steps
	public PatientViewBuilder build() {
		logger.info(">>> Building PatientView: fetchOffset=" + fetchOffset + ", fetchSize=" + fetchSize + "");
		try (Connection jdbcConnection = jdbcConnector.getConnection()) {
			String sql = SQL_PATIENTS_SELECT;
			PreparedStatement selectStmt;

			// Prepare fetch SQL
			if (fetchOffset != null && fetchOffset > 0) {
				sql = String.format(SQL_FETCH_SELECT, SQL_PATIENTS_SELECT);
				selectStmt = jdbcConnection.prepareStatement(sql);
				logger.info(">>> SQL_FETCH_SELECT formatted:\n" + sql);
				// Am corectat un mic bug din codul initial unde prepareStatement era apelat de 2 ori
				selectStmt.setInt(1, fetchOffset);
				selectStmt.setInt(2, fetchOffset + fetchSize);
			} else {
				selectStmt = jdbcConnection.prepareStatement(sql);
			}

			// extract data
			ResultSet rs = selectStmt.executeQuery();
			patientsViewList = new ArrayList<>();

			// 3. MODIFICAT: Maparea datelor medicale din SQL in Java
			while (rs.next()) {
				Long patient_id = rs.getLong("patient_id");

				String gender = rs.getString("gender");
				if(gender != null) gender = gender.trim(); // curatam spatiile goale

				Integer age = rs.getInt("age");

				String neighbourhood = rs.getString("neighbourhood");
				if(neighbourhood != null) neighbourhood = neighbourhood.trim();

				Integer scholarship = rs.getInt("scholarship");
				Integer hipertension = rs.getInt("hipertension");
				Integer diabetes = rs.getInt("diabetes");
				Integer alcoholism = rs.getInt("alcoholism");
				Integer handcap = rs.getInt("handcap");

				// Adaugam pacientul in lista folosind constructorul clasei PatientView
				this.patientsViewList.add(new PatientView(
						patient_id, gender, age, neighbourhood,
						scholarship, hipertension, diabetes, alcoholism, handcap
				));
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return this;
	}

	/* JDBC Session Management ---------------------------------------- */
	private JDBCDataSourceConnector jdbcConnector;

	public PatientViewBuilder(JDBCDataSourceConnector jdbcConnector) {
		this.jdbcConnector = jdbcConnector;
	}

	public PatientViewBuilder setFetchOffset(Integer fetchOffset) {
		if (fetchOffset != null) {
			this.fetchOffset = fetchOffset;
		}
		return this;
	}
	public PatientViewBuilder setFetchSize(Integer fetchSize) {
		if (fetchSize != null) {
			this.fetchSize = fetchSize;
		}
		return this;
	}

	private String SQL_FETCH_SELECT = """
          SELECT *
            FROM (
                 SELECT Q_.*,
                        ROW_NUMBER() OVER(
                                ORDER BY 1
                        ) RN___
                   FROM (
                        %s
                 ) Q_
          ) Q__
           WHERE RN___ BETWEEN ? AND ?
          """;
}