package org.j4di.access.views.appointments;

public interface APPOINTMENT_SUMMARY_VIEW {
    Long getAppointmentId();
    Long getPatientId();
    String getSmsReceived();
    String getNoShow();
}