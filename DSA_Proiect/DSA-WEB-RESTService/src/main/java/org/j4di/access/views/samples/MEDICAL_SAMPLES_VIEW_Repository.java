package org.j4di.access.views.samples;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface MEDICAL_SAMPLES_VIEW_Repository extends JpaRepository<MEDICAL_SAMPLES_VIEW, String> {
    @Query(nativeQuery = true, value = "SELECT sampleName, medicalSpecialty FROM view_medical_samples")
    List<MEDICAL_SAMPLES_VIEW> get_MEDICAL_SAMPLES_VIEW();
}