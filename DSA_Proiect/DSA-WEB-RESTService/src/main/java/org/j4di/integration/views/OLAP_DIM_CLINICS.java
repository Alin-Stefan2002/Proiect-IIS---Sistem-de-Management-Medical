package org.j4di.integration.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name = "OLAP_DIM_CLINICS")
public class OLAP_DIM_CLINICS {
    @Id
    private String clinic_id;
    private String clinic_name;
    private String city;
    private Long bed_capacity;
}