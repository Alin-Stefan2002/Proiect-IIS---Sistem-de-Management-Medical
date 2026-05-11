package org.datasource.jdbc.views.patientdetails;

import lombok.Value;

@Value
public class CustomerDetailsView {
    private Integer customerId;
    private String creditRating;
    private String industry;
    private Integer age;
    private Double turnover;
    private Double nrOfEmps;
    private String compType;
}
