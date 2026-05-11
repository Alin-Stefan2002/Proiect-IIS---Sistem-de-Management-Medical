package org.j4di.analytical.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name = "OLAP_VIEW_AGE_SMS_IMPACT")
public class OLAP_VIEW_AGE_SMS_IMPACT {
    @Id
    private String age_cohort;
    private String sms_received;
    private Long total_appointments;
    private Double no_show_rate_percent;
}