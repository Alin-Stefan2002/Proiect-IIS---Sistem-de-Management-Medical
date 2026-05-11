package org.j4di.access.views.appointments;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Getter
@Entity
@Immutable
@Table(name="view_medical_appointments")
public class PATIENT_APPOINTMENTS_VIEW {

    @Id
    @Column(name = "appointment_id") // Numele exact din Spark
    private Long appointmentId;

    @Column(name = "patient_id")
    private Long patientId;

    @Column(name = "sms_received")
    private String smsReceived;

    @Column(name = "no_show")
    private String noShow;
}