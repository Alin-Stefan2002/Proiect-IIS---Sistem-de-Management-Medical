package org.datasource.csv.medicalsamples;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;
import org.datasource.csv.CSVResourceFileDataSourceConnector;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

@Service
public class MedicalSampleViewBuilder {

    private List<MedicalSampleView> viewList = new java.util.ArrayList<>();

    public List<MedicalSampleView> getViewList() {
        return viewList;
    }

    private CSVResourceFileDataSourceConnector dataSourceConnector;
    private File csvFile;

    public MedicalSampleViewBuilder(CSVResourceFileDataSourceConnector dataSourceConnector) throws Exception {
        this.dataSourceConnector = dataSourceConnector;
        this.csvFile = dataSourceConnector.getCSVFile();
    }

    // Builder Workflow
    public MedicalSampleViewBuilder build() throws Exception{
        Reader in = new FileReader(this.csvFile);
        // Setăm cititorul să ignore spațiile goale din jurul capetelor de tabel
        CSVFormat format = CSVFormat.DEFAULT.withFirstRecordAsHeader().withDelimiter(',').withTrim();
        Iterable<CSVRecord> records = format.parse(in);
        viewList = new ArrayList<>();

        for (CSVRecord record : records) {
            this.viewList.add(new MedicalSampleView(
                            // ATENȚIE: Textul din paranteze trebuie să fie IDENTIC cu capul de tabel din CSV-ul tău!
                            record.get("description"),
                            record.get("medical_specialty"),
                            record.get("sample_name"),
                            record.get("transcription"),
                            record.get("keywords")
                    )
            );
        }
        return this;
    }
}