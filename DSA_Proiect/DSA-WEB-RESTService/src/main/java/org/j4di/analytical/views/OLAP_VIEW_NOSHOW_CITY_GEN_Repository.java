package org.j4di.analytical.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OLAP_VIEW_NOSHOW_CITY_GEN_Repository extends JpaRepository<OLAP_VIEW_NOSHOW_CITY_GEN, String> {
    @Query("SELECT o FROM OLAP_VIEW_NOSHOW_CITY_GEN o")
    List<OLAP_VIEW_NOSHOW_CITY_GEN> get_OLAP_VIEW_NOSHOW_CITY_GEN();
}