package org.datasource.mongodb.views.clinics; // Schimbă "clinics" cu "departamentscities" dacă nu ai redenumit folderul

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.io.Serializable;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor(force = true)
public class ClinicView implements Serializable {
	private String _id;
	private String clinic_name;
	private String city;
	private Integer bed_capacity;
	private List<String> departments;
}