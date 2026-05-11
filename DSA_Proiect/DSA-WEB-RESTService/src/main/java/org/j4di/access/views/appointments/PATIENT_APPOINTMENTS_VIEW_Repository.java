package org.j4di.access.views.appointments;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface PATIENT_APPOINTMENTS_VIEW_Repository extends JpaRepository<PATIENT_APPOINTMENTS_VIEW, Long> {

    // Folosim o interogare nativă simplă.
    // Hibernate va folosi adnotările @Column de mai sus pentru a face legătura.
    @Query(nativeQuery = true, value = "SELECT appointment_id, patient_id, sms_received, no_show FROM view_medical_appointments")
    List<PATIENT_APPOINTMENTS_VIEW> get_PATIENT_APPOINTMENTS();

    @Query(nativeQuery = true,
            value = """
                    SELECT a.appointment_id as appointmentId, a.patient_id as patientId,
                    a.sms_received as smsReceived, a.no_show as noShow
                    FROM view_medical_appointments a
            """)
    List<APPOINTMENT_SUMMARY_VIEW> get_APPOINTMENT_SUMMARY();
}