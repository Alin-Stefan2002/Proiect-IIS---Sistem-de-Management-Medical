package org.j4di.integration.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OLAP_DIM_PATIENTS_Repository extends JpaRepository<OLAP_DIM_PATIENTS, Long> {
    @Query("SELECT o FROM OLAP_DIM_PATIENTS o")
    List<OLAP_DIM_PATIENTS> get_OLAP_DIM_PATIENTS();
}