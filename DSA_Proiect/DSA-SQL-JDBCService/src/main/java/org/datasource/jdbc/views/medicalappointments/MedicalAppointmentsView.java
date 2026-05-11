package org.datasource.jdbc.views.medicalappointments;

import lombok.Value;

@Value
public class MedicalAppointmentsView {
    private Long appointment_id;
    private Long patient_id;
    private String scheduled_day;
    private String appointment_day;
    private Integer sms_received;
    private String no_show;
}