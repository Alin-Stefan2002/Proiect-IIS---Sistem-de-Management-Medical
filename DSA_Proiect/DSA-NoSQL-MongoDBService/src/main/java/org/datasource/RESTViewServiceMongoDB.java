package org.datasource;

import org.datasource.mongodb.views.clinics.ClinicView;
import org.datasource.mongodb.views.clinics.ClinicViewBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;

/* REST Service URL (Test in Browser):
    http://localhost:8093/DSA-NoSQL-MongoDBService/rest/medical/ClinicView
*/
@RestController
@RequestMapping("/medical")
public class RESTViewServiceMongoDB {
	private static Logger logger = Logger.getLogger(RESTViewServiceMongoDB.class.getName());

	@Autowired
	private ClinicViewBuilder viewBuilder;

	@RequestMapping(value = "/ping", method = RequestMethod.GET, produces = {MediaType.TEXT_PLAIN_VALUE})
	@ResponseBody
	public String pingDataSource() {
		logger.info(">>>> org.datasource.rest.RESTViewService(MongoDB) is Up!");
		return "Ping response from RESTViewServiceMongoDB!";
	}

	@RequestMapping(value = "/ClinicView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<ClinicView> get_ClinicView() throws Exception {
		// Aici chemăm Builder-ul să se conecteze la DB și să ne aducă lista
		List<ClinicView> viewList = this.viewBuilder.build().getClinicViewList();
		return viewList;
	}
}