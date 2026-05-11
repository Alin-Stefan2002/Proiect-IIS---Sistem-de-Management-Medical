package org.j4di.integration.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name = "OLAP_FACTS_APPOINTMENTS")
public class OLAP_FACTS_APPOINTMENTS {
    @Id
    private Long appointment_id;
    private Long patient_id;
    private String clinic_id;
    private String id_sample;
    private Long sms_received;
    private Long is_no_show;
}