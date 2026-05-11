package org.j4di.integration.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name = "OLAP_DIM_PATIENTS")
public class OLAP_DIM_PATIENTS {
    @Id
    private Long patient_id;
    private String gender;
    private Long age;
    private String bp_status;
    private String age_cohort;
}