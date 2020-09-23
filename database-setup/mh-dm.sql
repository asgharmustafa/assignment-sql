/* FIT9132 2019 S1 Assignment 2 Q1-Part B ANSWERS
   Student Name: Asghar Mustafa
    Student ID: 28905644

   Comments to your marker:
   
*/

/* (i)*/

drop sequence patient_id_seq;
drop sequence admission_id_seq;
drop sequence admission_patient_id_seq;

CREATE SEQUENCE patient_id_seq START WITH 200000 INCREMENT BY 10 NOCACHE ORDER;
CREATE SEQUENCE admission_id_seq START WITH 200000 INCREMENT BY 10 NOCACHE ORDER;
CREATE SEQUENCE admission_patient_id_seq START WITH 200000 INCREMENT BY 10 NOCACHE ORDER;


/* (ii)*/

insert into PATIENT (PATIENT_ID, PATIENT_FNAME, PATIENT_LNAME, PATIENT_ADDRESS, PATIENT_DOB, PATIENT_CONTACT_PHN) values (patient_id_seq.nextval, 'Peter', 'Xiue', '14 Narrow Lane Caulfield', TO_DATE('10/01/1981','MM/DD/YYYY'), '0123456789');

insert into ADMISSION (ADM_NO, ADM_DATE_TIME, ADM_DISCHARGE, PATIENT_ID, DOCTOR_ID) values (9123, TO_DATE('05/16/2019 10:00:00','MM/DD/YYYY HH24:MI:SS'), NULL, patient_id_seq.currval, (select DOCTOR_ID from DOCTOR where DOCTOR_TITLE='Dr' and DOCTOR_FNAME='Sawyer' and DOCTOR_LNAME= 'Haisell'));




/* (iii)*/

UPDATE doctor_speciality
SET SPEC_CODE = (SELECT SPEC_CODE FROM speciality WHERE SPEC_DESCRIPTION='Vascular surgery')
where doctor_id=(select doctor_id from doctor where DOCTOR_TITLE='Dr' and DOCTOR_FNAME='Decca' and DOCTOR_LNAME= 'Blankhorn')
and spec_code=(select SPEC_CODE FROM speciality WHERE SPEC_DESCRIPTION='Thoracic surgery');



      
/* (iv)*/

--Removing Child Records
delete from doctor_speciality
where spec_code=(select spec_code from speciality where spec_description='Medical genetics');

-- Removiving Parent record to stop new entries from adding
delete from speciality
where spec_description='Medical genetics';









