package org.datasource.jdbc.views.patients;

import lombok.Value;

@Value
public class PatientView {
	private Long patient_id;
	private String gender;
	private Integer age;
	private String neighbourhood;
	private Integer scholarship;
	private Integer hipertension;
	private Integer diabetes;
	private Integer alcoholism;
	private Integer handcap;
}
