package org.j4di.analytical.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OLAP_VIEW_CAPACITY_HIERARCHY_Repository extends JpaRepository<OLAP_VIEW_CAPACITY_HIERARCHY, String> {
    @Query("SELECT o FROM OLAP_VIEW_CAPACITY_HIERARCHY o")
    List<OLAP_VIEW_CAPACITY_HIERARCHY> get_OLAP_VIEW_CAPACITY_HIERARCHY();
}