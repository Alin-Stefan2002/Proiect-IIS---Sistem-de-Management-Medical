package org.j4di.analytical.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OLAP_VIEW_AGE_COHORTS_Repository extends JpaRepository<OLAP_VIEW_AGE_COHORTS, String> {
    @Query("SELECT o FROM OLAP_VIEW_AGE_COHORTS o")
    List<OLAP_VIEW_AGE_COHORTS> get_OLAP_VIEW_AGE_COHORTS();
}