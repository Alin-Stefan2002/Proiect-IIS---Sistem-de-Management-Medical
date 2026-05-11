package org.j4di.access.views.clinics;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name="clinics_view")
public class CLINICS_VIEW {

    @Id
    @Column(name = "clinic_name")
    private String clinicName;

    @Column(name = "city")
    private String city;

    @Column(name = "bed_capacity")
    private Long bedCapacity;
}