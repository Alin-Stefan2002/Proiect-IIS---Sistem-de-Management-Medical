package org.j4di.access.views.samples;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name="view_medical_samples") // Numele brut din Spark (CSV)
public class MEDICAL_SAMPLES_VIEW {

    @Id
    @Column(name = "sampleName") // Conform CSV-ului tău
    private String sampleName;

    @Column(name = "medicalSpecialty")
    private String medicalSpecialty;
}