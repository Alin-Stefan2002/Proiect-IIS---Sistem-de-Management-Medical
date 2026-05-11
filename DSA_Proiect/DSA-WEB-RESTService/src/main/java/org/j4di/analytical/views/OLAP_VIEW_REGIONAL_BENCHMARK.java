package org.j4di.analytical.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name = "OLAP_VIEW_REGIONAL_BENCHMARK")
public class OLAP_VIEW_REGIONAL_BENCHMARK {
    @Id
    private String clinic_name;
    private String city;
    private Long clinic_appointments;
    private Double city_avg_appointments;
    private Double diff_from_avg;
}