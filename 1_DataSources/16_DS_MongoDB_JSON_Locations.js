use medical;

db.clinics.drop();

db.clinics.insertMany([
  {
    "_id": "C100",
    "clinic_name": "JOHNS HOPKINS HOSPITAL",
    "city": "BALTIMORE",
    "bed_capacity": 1162,
    "departments": ["Cardiology", "Neurosurgery", "Pediatrics", "Oncology"]
  },
  {
    "_id": "C101",
    "clinic_name": "MASSACHUSETTS GENERAL HOSPITAL",
    "city": "BOSTON",
    "bed_capacity": 1011,
    "departments": ["Psychiatry", "Endocrinology", "Gastroenterology"]
  },
  {
    "_id": "C102",
    "clinic_name": "UCSF MEDICAL CENTER",
    "city": "SAN FRANCISCO",
    "bed_capacity": 785,
    "departments": ["Neurology", "Ophthalmology", "Urology"]
  },
  {
    "_id": "C103",
    "clinic_name": "MAYO CLINIC HOSPITAL",
    "city": "ROCHESTER",
    "bed_capacity": 1265,
    "departments": ["Cardiology", "Oncology", "Gynecology", "Orthopedics"]
  },
  {
    "_id": "C104",
    "clinic_name": "CLEVELAND CLINIC",
    "city": "CLEVELAND",
    "bed_capacity": 1285,
    "departments": ["Cardiac Surgery", "Rheumatology", "Urology"]
  },
  {
    "_id": "C105",
    "clinic_name": "CEDARS-SINAI MEDICAL CENTER",
    "city": "LOS ANGELES",
    "bed_capacity": 882,
    "departments": ["Cardiology", "Gastroenterology", "Orthopedics"]
  },
  {
    "_id": "C106",
    "clinic_name": "NEW YORK-PRESBYTERIAN HOSPITAL",
    "city": "NEW YORK",
    "bed_capacity": 2600,
    "departments": ["Psychiatry", "Neurology", "Rheumatology"]
  },
  {
    "_id": "C107",
    "clinic_name": "MOUNT SINAI HOSPITAL",
    "city": "NEW YORK",
    "bed_capacity": 1134,
    "departments": ["Geriatrics", "Gastroenterology", "Cardiology"]
  },
  {
    "_id": "C108",
    "clinic_name": "BRIGHAM AND WOMEN'S HOSPITAL",
    "city": "BOSTON",
    "bed_capacity": 793,
    "departments": ["Gynecology", "Cancer Care", "Orthopedics"]
  },
  {
    "_id": "C109",
    "clinic_name": "UCLA MEDICAL CENTER",
    "city": "LOS ANGELES",
    "bed_capacity": 466,
    "departments": ["Ophthalmology", "Psychiatry", "Urology"]
  }
]);

db.clinics.find();