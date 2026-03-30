BEGIN
  -- Ștergem modulul anterior dacă există
  ORDS.DELETE_MODULE(p_module_name => 'fdbo.olap.api');

  -- Definim Modulul Principal pentru Analize Complexe
  ORDS.DEFINE_MODULE(
      p_module_name    => 'fdbo.olap.api',
      p_base_path      => '/olap/',
      p_items_per_page => 0, -- Returnăm tot setul de date pentru tabelele OLAP
      p_status         => 'PUBLISHED');

  -- 1. Endpoint: Clasament Venituri (CUBE)
  ORDS.DEFINE_TEMPLATE(p_module_name => 'fdbo.olap.api', p_pattern => 'revenue_rank');
  ORDS.DEFINE_HANDLER(p_module_name => 'fdbo.olap.api', p_pattern => 'revenue_rank', p_method => 'GET', 
                      p_source_type => 'json/collection', p_source => 'SELECT * FROM OLAP_VIEW_REVENUE_CITY_GEN');

  -- 2. Endpoint: Corelație Stil Viață
  ORDS.DEFINE_TEMPLATE(p_module_name => 'fdbo.olap.api', p_pattern => 'lifestyle_stats');
  ORDS.DEFINE_HANDLER(p_module_name => 'fdbo.olap.api', p_pattern => 'lifestyle_stats', p_method => 'GET', 
                      p_source_type => 'json/collection', p_source => 'SELECT * FROM OLAP_VIEW_LIFESTYLE_CORRELATION');

  -- 3. Endpoint: Ierarhie Geografică (ROLLUP)
  ORDS.DEFINE_TEMPLATE(p_module_name => 'fdbo.olap.api', p_pattern => 'geo_hierarchy');
  ORDS.DEFINE_HANDLER(p_module_name => 'fdbo.olap.api', p_pattern => 'geo_hierarchy', p_method => 'GET', 
                      p_source_type => 'json/collection', p_source => 'SELECT * FROM OLAP_VIEW_GEO_HIERARCHY');

  -- 4. Endpoint: Capacitate Spitale
  ORDS.DEFINE_TEMPLATE(p_module_name => 'fdbo.olap.api', p_pattern => 'capacity_usage');
  ORDS.DEFINE_HANDLER(p_module_name => 'fdbo.olap.api', p_pattern => 'capacity_usage', p_method => 'GET', 
                      p_source_type => 'json/collection', p_source => 'SELECT * FROM OLAP_VIEW_CAPACITY_HIERARCHY');

  -- 5. Endpoint: Cohoarte Vârstă
  ORDS.DEFINE_TEMPLATE(p_module_name => 'fdbo.olap.api', p_pattern => 'age_cohorts');
  ORDS.DEFINE_HANDLER(p_module_name => 'fdbo.olap.api', p_pattern => 'age_cohorts', p_method => 'GET', 
                      p_source_type => 'json/collection', p_source => 'SELECT * FROM OLAP_VIEW_AGE_COHORTS');

  -- 6. Endpoint: Benchmarking Regional
  ORDS.DEFINE_TEMPLATE(p_module_name => 'fdbo.olap.api', p_pattern => 'regional_bench');
  ORDS.DEFINE_HANDLER(p_module_name => 'fdbo.olap.api', p_pattern => 'regional_bench', p_method => 'GET', 
                      p_source_type => 'json/collection', p_source => 'SELECT * FROM OLAP_VIEW_REGIONAL_BENCHMARK');

  COMMIT;
END;
/

--Test
--Clasament Venituri:
--http://localhost:9090/ords/fdbo/olap/revenue_rank

--Corelație Stil Viață:
--http://localhost:9090/ords/fdbo/olap/lifestyle_stats

--Ierarhie Geografică:
--http://localhost:9090/ords/fdbo/olap/geo_hierarchy

--Capacitate Spitale:
--http://localhost:9090/ords/fdbo/olap/capacity_usage

--Cohoarte Vârstă:
--http://localhost:9090/ords/fdbo/olap/age_cohorts

--Benchmarking Regional:
--http://localhost:9090/ords/fdbo/olap/regional_bench
