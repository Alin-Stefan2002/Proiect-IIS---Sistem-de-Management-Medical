package org.j4di.analytical.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name = "OLAP_VIEW_GEO_HIERARCHY")
public class OLAP_VIEW_GEO_HIERARCHY {
    @Id
    private String specialty; // Folosim ultima coloană a ierarhiei ca ID logic
    private String city;
    private String clinic;
    private Long total_appointments;
    private Long missed_appointments;
}