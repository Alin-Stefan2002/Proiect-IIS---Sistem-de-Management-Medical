package org.j4di.access.views.clinics;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface CLINICS_VIEW_Repository extends JpaRepository<CLINICS_VIEW, String> {

    // FĂRĂ alias-uri (as clinicName)! Lăsăm numele exact ca în SparkSQL.
    @Query(nativeQuery = true,
            value = "SELECT clinic_name, city, bed_capacity FROM clinics_view")
    List<CLINICS_VIEW> get_CLINICS_VIEW();
}