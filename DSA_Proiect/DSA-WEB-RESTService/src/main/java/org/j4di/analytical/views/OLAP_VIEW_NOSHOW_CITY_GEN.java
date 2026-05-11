package org.j4di.analytical.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name = "OLAP_VIEW_NOSHOW_CITY_GEN")
public class OLAP_VIEW_NOSHOW_CITY_GEN {
    @Id // JPA are nevoie de un Id; folosim coloana city pentru identificare
    private String city;
    private String gender;
    private Long total_appointments;
    private Long total_no_shows;
    private Double no_show_rate_percent;
}