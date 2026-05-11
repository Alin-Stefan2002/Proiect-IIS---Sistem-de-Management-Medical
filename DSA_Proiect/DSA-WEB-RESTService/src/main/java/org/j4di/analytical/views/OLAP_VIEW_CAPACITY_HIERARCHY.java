package org.j4di.analytical.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name = "OLAP_VIEW_CAPACITY_HIERARCHY")
public class OLAP_VIEW_CAPACITY_HIERARCHY {
    @Id
    private String clinic_name;
    private String city;
    private Long total_bed_capacity;
    private Long total_patients;
    private Double occupancy_rate_percent;
}