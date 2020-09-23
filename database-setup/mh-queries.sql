/* FIT9132 2019 S1 Assignment 2 Q2 ANSWERS
   Student Name: ASGHAR MUSTAFA
    Student ID: 28905644

   Comments to your marker:
   
*/

/* (i)*/
SELECT
    d.doctor_title,
    d.doctor_fname,
    d.doctor_lname,
    d.doctor_phone
FROM
    (doctor d join doctor_speciality ds on d.doctor_id=ds.doctor_id) join speciality s on s.spec_code=ds.spec_code
WHERE (s.spec_description = 'Orthopedic surgery')
order by 
    Doctor_LNAME, Doctor_FNAME;




/* (ii)*/

SELECT
    i.item_code,
    i.item_description,
    i.item_stock,
    cc.cc_title
FROM
    item         i
    JOIN costcentre   cc ON i.cc_code = cc.cc_code
WHERE
    i.item_stock > 50
    AND item_description LIKE '%Disposable%'
ORDER BY
    i.item_code;


    
/* (iii)*/

SELECT
    admission.patient_id,
    concat(concat(patient.patient_fname, ' '), patient.patient_lname) AS "Patient Name",
    TO_CHAR(admission.adm_date_time, 'dd-Mon-yyyy hh24:mi:ss') AS "ADMDATETIME",
    concat(concat(concat(concat(doctor.doctor_title, ' '), doctor.doctor_fname), ' '), doctor.doctor_lname) AS "Doctor Name"
FROM
    patient
    JOIN admission ON patient.patient_id = admission.patient_id
    JOIN doctor ON admission.doctor_id = doctor.doctor_id
WHERE
    admission.adm_date_time >= '14-Mar-2019'
    AND admission.adm_date_time <= '15-Mar-2019'
ORDER BY
    admdatetime;



/* (iv)*/

SELECT
    proc_code,
    proc_name,
    proc_description,
    --concat('$', CAST(proc_std_cost AS DECIMAL(16, 2))) "Standard Cost"
    concat('$', to_char(proc_std_cost,'990.99') ) "Standard Cost"
FROM
    procedure
WHERE
    proc_std_cost < (
        SELECT
            AVG(proc_std_cost)
        FROM
            procedure
    )
ORDER BY
    proc_std_cost DESC;


 
/* (v)*/

SELECT
    admission.patient_id,
    patient.patient_fname,
    patient.patient_lname,
    patient.patient_dob AS "DOB",
    COUNT(*) AS "NUMBERADMISSIONS"
FROM
    admission
    JOIN patient ON admission.patient_id = patient.patient_id
GROUP BY
    admission.patient_id,
    patient.patient_fname,
    patient.patient_lname,
    patient.patient_dob
HAVING
    COUNT(*) > 2
ORDER BY
    numberadmissions DESC,
    dob;


    
/* (vi)*/

SELECT
        admission.adm_no        adm_no,
        admission.patient_id    Patient_ID,
        patient.patient_fname   PATIENT_FNAME,
        patient.patient_lname   PATIENT_LNAME,
        concat(concat(concat(concat(concat(concat(floor(admission.adm_discharge - admission.adm_date_time), ' '), 'days'), ' '), to_char(((admission.adm_discharge - admission.adm_date_time - floor(admission.adm_discharge - admission.adm_date_time)) * 24), '99.9')),' '), 'hours'
    ) "STAYLENGTH"
        FROM
            admission
            JOIN patient ON admission.patient_id = patient.patient_id
        WHERE
            admission.adm_discharge IS NOT NULL
            AND admission.adm_discharge - admission.adm_date_time > (
                SELECT
                    AVG(adm_discharge - adm_date_time)
                FROM
                    admission
                WHERE
                    adm_discharge IS NOT NULL
            )
        ORDER BY
            admission.adm_discharge - admission.adm_date_time DESC;


    
/* (vii)*/

SELECT
    procedure.proc_code,
    procedure.proc_name,
    procedure.proc_description,
    procedure.proc_time,
    --round(procedure.proc_std_cost - proc_avg.average, 2) "Price Differential"
    to_char(procedure.proc_std_cost - proc_avg.average, '9999990.99') "Price Differential"
FROM
    procedure
    JOIN (
        SELECT
            adm_prc.proc_code,
            AVG(adprc_pat_cost) average
        FROM
            adm_prc
        GROUP BY
            adm_prc.proc_code
    ) proc_avg ON proc_avg.proc_code = procedure.proc_code
ORDER BY
    procedure.proc_code;



    
/* (viii)*/


SELECT
    procedure.proc_code proc_code,
    procedure.proc_name,
    (CASE WHEN adm_prc_item.b IS NULL THEN  '---' ELSE adm_prc_item.b END) item_code,
    (CASE WHEN adm_prc_item.d IS NULL THEN '---' ELSE adm_prc_item.d END ) item_description,
    nvl(TO_CHAR(MAX(adm_prc_item.c)), '---') max_qty_used
FROM
    procedure 
    left JOIN (
        SELECT
            adm_prc.proc_code                  a,
            item_treatment2.item_code          b,
            item_treatment2.item_description   d,
            item_treatment2.it_qty_used        c
        FROM
            adm_prc
            JOIN (
                SELECT
                    item_treatment.adprc_no      adprc_no,
                    item_treatment.item_code     item_code,
                    item.item_description        item_description,
                    item_treatment.it_qty_used   it_qty_used
                FROM
                    item_treatment
                    JOIN item ON item_treatment.item_code = item.item_code
            ) item_treatment2 ON adm_prc.adprc_no = item_treatment2.adprc_no
    ) adm_prc_item ON adm_prc_item.a = procedure.proc_code
GROUP BY
    procedure.proc_code,
    procedure.proc_name,
    adm_prc_item.b,
    adm_prc_item.d
ORDER BY
    procedure.proc_name;