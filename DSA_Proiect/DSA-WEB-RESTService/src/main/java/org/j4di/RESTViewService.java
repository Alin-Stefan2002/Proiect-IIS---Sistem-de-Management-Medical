package org.j4di;

// Importuri pentru stratul Access (Medical Appointments)
import org.j4di.access.views.appointments.PATIENT_APPOINTMENTS_VIEW;
import org.j4di.access.views.appointments.PATIENT_APPOINTMENTS_VIEW_Repository;
import org.j4di.access.views.appointments.APPOINTMENT_SUMMARY_VIEW;
import org.j4di.access.views.clinics.CLINICS_VIEW;
import org.j4di.access.views.clinics.CLINICS_VIEW_Repository;
import org.j4di.access.views.samples.MEDICAL_SAMPLES_VIEW;
import org.j4di.access.views.samples.MEDICAL_SAMPLES_VIEW_Repository;

// Importuri pentru stratul Integration (Dimensions & Facts)
import org.j4di.integration.views.*;

// Importuri pentru stratul Analytical (Cele 6 rapoarte OLAP)
import org.j4di.analytical.views.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

/* Noile URL-uri de testare:
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/PATIENT_APPOINTMENTS
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/OLAP_DIM_PATIENTS
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/OLAP_FACTS_APPOINTMENTS

    Analytical Views:
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/NOSHOW_CITY_GEN
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/AGE_SMS_IMPACT
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/GEO_HIERARCHY
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/CAPACITY_HIERARCHY
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/AGE_COHORTS
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/REGIONAL_BENCHMARK
*/

@RestController
@RequestMapping("/OLAP") // Rădăcina endpoint-urilor
public class RESTViewService {
	private static Logger logger = Logger.getLogger(RESTViewService.class.getName());

	@RequestMapping(value = "/ping", method = RequestMethod.GET,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	@ResponseBody
	public String pingDataSource() {
		logger.info(">>>> DSA-WEB-SparkService:: RESTViewService is Up!");
		return "Ping response from DSA-WEB-SparkService!";
	}

	// --- STRATUL ACCESS (Sursa brută) ---
	@Autowired private PATIENT_APPOINTMENTS_VIEW_Repository appointmentsRepo;
	@Autowired private CLINICS_VIEW_Repository rawClinicsRepo;
	@Autowired private MEDICAL_SAMPLES_VIEW_Repository rawSamplesRepo;

	@GetMapping(value = "/PATIENT_APPOINTMENTS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<PATIENT_APPOINTMENTS_VIEW> get_Appointments() {
		return this.appointmentsRepo.get_PATIENT_APPOINTMENTS();
	}

	@GetMapping(value = "/APPOINTMENT_SUMMARY", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<APPOINTMENT_SUMMARY_VIEW> get_Summary() {
		return this.appointmentsRepo.get_APPOINTMENT_SUMMARY();
	}

	@GetMapping(value = "/CLINICS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<CLINICS_VIEW> get_RawClinics() {
		return this.rawClinicsRepo.get_CLINICS_VIEW();
	}

	@GetMapping(value = "/SAMPLES", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<MEDICAL_SAMPLES_VIEW> get_RawSamples() {
		return this.rawSamplesRepo.get_MEDICAL_SAMPLES_VIEW();
	}

	// --- STRATUL INTEGRATION (Dimensiuni și facts) ---
	@Autowired private OLAP_DIM_PATIENTS_Repository patientsRepo;
	@Autowired private OLAP_DIM_CLINICS_Repository clinicsRepo;
	@Autowired private OLAP_DIM_SPECIALTIES_Repository specialtiesRepo;
	@Autowired private OLAP_FACTS_APPOINTMENTS_Repository factsRepo;

	@GetMapping(value = "/OLAP_DIM_PATIENTS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<OLAP_DIM_PATIENTS> get_Patients() {
		return this.patientsRepo.get_OLAP_DIM_PATIENTS();
	}

	@GetMapping(value = "/OLAP_FACTS_APPOINTMENTS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<OLAP_FACTS_APPOINTMENTS> get_FactTable() {
		return this.factsRepo.get_OLAP_FACTS_APPOINTMENTS();
	}

	@GetMapping(value = "/OLAP_DIM_CLINICS", produces = MediaType.APPLICATION_JSON_VALUE) // ADĂUGATĂ
	public List<OLAP_DIM_CLINICS> get_Clinics() {
		return this.clinicsRepo.get_OLAP_DIM_CLINICS();
	}

	@GetMapping(value = "/OLAP_DIM_SPECIALTIES", produces = MediaType.APPLICATION_JSON_VALUE) // ADĂUGATĂ
	public List<OLAP_DIM_SPECIALTIES> get_Specialties() {
		return this.specialtiesRepo.get_OLAP_DIM_SPECIALTIES();
	}

	// --- STRATUL ANALYTICAL (Cele 6 View-uri OLAP) ---
	@Autowired private OLAP_VIEW_NOSHOW_CITY_GEN_Repository v1Repo;
	@Autowired private OLAP_VIEW_AGE_SMS_IMPACT_Repository v2Repo;
	@Autowired private OLAP_VIEW_GEO_HIERARCHY_Repository v3Repo;
	@Autowired private OLAP_VIEW_CAPACITY_HIERARCHY_Repository v4Repo;
	@Autowired private OLAP_VIEW_AGE_COHORTS_Repository v5Repo;
	@Autowired private OLAP_VIEW_REGIONAL_BENCHMARK_Repository v6Repo;

	@GetMapping(value = "/NOSHOW_CITY_GEN", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<OLAP_VIEW_NOSHOW_CITY_GEN> get_V1() {
		return this.v1Repo.get_OLAP_VIEW_NOSHOW_CITY_GEN();
	}

	@GetMapping(value = "/AGE_SMS_IMPACT", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<OLAP_VIEW_AGE_SMS_IMPACT> get_V2() {
		return this.v2Repo.get_OLAP_VIEW_AGE_SMS_IMPACT();
	}

	@GetMapping(value = "/GEO_HIERARCHY", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<OLAP_VIEW_GEO_HIERARCHY> get_V3() {
		return this.v3Repo.get_OLAP_VIEW_GEO_HIERARCHY();
	}

	@GetMapping(value = "/CAPACITY_HIERARCHY", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<OLAP_VIEW_CAPACITY_HIERARCHY> get_V4() {
		return this.v4Repo.get_OLAP_VIEW_CAPACITY_HIERARCHY();
	}

	@GetMapping(value = "/AGE_COHORTS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<OLAP_VIEW_AGE_COHORTS> get_V5() {
		return this.v5Repo.get_OLAP_VIEW_AGE_COHORTS();
	}

	@GetMapping(value = "/REGIONAL_BENCHMARK", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<OLAP_VIEW_REGIONAL_BENCHMARK> get_V6() {
		return this.v6Repo.get_OLAP_VIEW_REGIONAL_BENCHMARK();
	}
}