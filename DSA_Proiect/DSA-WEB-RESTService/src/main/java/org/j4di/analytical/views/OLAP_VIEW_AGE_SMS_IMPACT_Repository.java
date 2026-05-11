package org.j4di.analytical.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OLAP_VIEW_AGE_SMS_IMPACT_Repository extends JpaRepository<OLAP_VIEW_AGE_SMS_IMPACT, String> {
    @Query("SELECT o FROM OLAP_VIEW_AGE_SMS_IMPACT o")
    List<OLAP_VIEW_AGE_SMS_IMPACT> get_OLAP_VIEW_AGE_SMS_IMPACT();
}