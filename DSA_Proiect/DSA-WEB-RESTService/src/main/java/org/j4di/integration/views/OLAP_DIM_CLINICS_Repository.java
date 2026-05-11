package org.j4di.integration.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OLAP_DIM_CLINICS_Repository extends JpaRepository<OLAP_DIM_CLINICS, String> {
    @Query("SELECT o FROM OLAP_DIM_CLINICS o")
    List<OLAP_DIM_CLINICS> get_OLAP_DIM_CLINICS();
}