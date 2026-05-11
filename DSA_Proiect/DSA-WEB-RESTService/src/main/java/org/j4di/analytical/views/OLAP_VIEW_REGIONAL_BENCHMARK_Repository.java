package org.j4di.analytical.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface OLAP_VIEW_REGIONAL_BENCHMARK_Repository extends JpaRepository<OLAP_VIEW_REGIONAL_BENCHMARK, String> {
    @Query("SELECT o FROM OLAP_VIEW_REGIONAL_BENCHMARK o")
    List<OLAP_VIEW_REGIONAL_BENCHMARK> get_OLAP_VIEW_REGIONAL_BENCHMARK();
}