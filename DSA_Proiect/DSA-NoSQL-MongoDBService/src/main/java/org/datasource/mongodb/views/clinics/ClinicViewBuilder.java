package org.datasource.mongodb.views.clinics;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.datasource.mongodb.MongoDataSourceConnector;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ClinicViewBuilder {

	// Aici vom stoca lista finală de clinici
	private List<ClinicView> clinicViewList;

	public List<ClinicView> getClinicViewList() {
		return clinicViewList;
	}

	private MongoDataSourceConnector dataSourceConnector;

	public ClinicViewBuilder(MongoDataSourceConnector dataSourceConnector) {
		this.dataSourceConnector = dataSourceConnector;
	}

	// Builder Workflow
	public ClinicViewBuilder build() throws Exception {
		return this.select().map();
	}

	private ClinicViewBuilder map() {
		return this;
	}

	public ClinicViewBuilder select() throws Exception {
		MongoDatabase db = dataSourceConnector.getMongoDatabase();

		MongoCollection<ClinicView> clinicsCollection = db.getCollection("clinics", ClinicView.class);

		this.clinicViewList = new ArrayList<>();
		clinicsCollection.find().into(this.clinicViewList);

		clinicViewList.forEach(System.out::println);

		return this;
	}
}