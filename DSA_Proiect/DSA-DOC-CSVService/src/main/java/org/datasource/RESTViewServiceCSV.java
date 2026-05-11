package org.datasource;

import org.datasource.csv.medicalsamples.MedicalSampleView;
import org.datasource.csv.medicalsamples.MedicalSampleViewBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;

/* REST Service URL
    http://localhost:8097/DSA-DOC-CSVService/rest/medical/MedicalSamplesView
*/
@RestController
@RequestMapping("/medical")
public class RESTViewServiceCSV {
	private static Logger logger = Logger.getLogger(RESTViewServiceCSV.class.getName());

	// Set-up (E mai bine să punem Autowired la începutul clasei)
	@Autowired
	private MedicalSampleViewBuilder medicalSampleViewBuilder;


	@RequestMapping(value = "/MedicalSamplesView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody

	public List<MedicalSampleView> get_MedicalSamplesView() throws Exception {
		List<MedicalSampleView> viewList;
		if (this.medicalSampleViewBuilder.getViewList().isEmpty() == true)
			viewList = this.medicalSampleViewBuilder.build().getViewList();
		else
			viewList = this.medicalSampleViewBuilder.getViewList();
		return viewList;
	}
}