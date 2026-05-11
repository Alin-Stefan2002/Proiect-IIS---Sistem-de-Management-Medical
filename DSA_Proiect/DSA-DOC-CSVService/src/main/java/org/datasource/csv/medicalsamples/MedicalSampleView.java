package org.datasource.csv.medicalsamples;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @AllArgsConstructor @NoArgsConstructor(force = true)
public class MedicalSampleView {
	private String description;
	private String medicalSpecialty;
	private String sampleName;
	private String transcription;
	private String keywords;
}