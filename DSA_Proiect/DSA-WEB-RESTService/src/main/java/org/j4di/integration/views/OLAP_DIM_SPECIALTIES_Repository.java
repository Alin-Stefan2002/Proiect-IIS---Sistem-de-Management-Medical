package org.j4di.integration.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OLAP_DIM_SPECIALTIES_Repository extends JpaRepository<OLAP_DIM_SPECIALTIES, String> {
    @Query("SELECT o FROM OLAP_DIM_SPECIALTIES o")
    List<OLAP_DIM_SPECIALTIES> get_OLAP_DIM_SPECIALTIES();
}