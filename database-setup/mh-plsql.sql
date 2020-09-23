/* FIT9132 2019 S1 Assignment 2 Q3 ANSWERS
   Student Name: Asghar Mustafa
    Student ID: 28905644

   Comments to your marker:
   
*/

/* (i)*/
create or replace trigger item_code_update 
after update of item_code on item 
for each row 
begin
  update item_treatment
     set item_code = :new.item_code
     where item_code = :old.item_code;
     
  dbms_output.put_line ('The item code has been updated succesfully!!!');
end;
/

set serveroutput on
set echo on
-- Prior state
select * from item
where item_code = 'NE001';

select * from item_treatment
where item_code = 'NE001';

-- Test trigger 

update item set item_code = 'NE01' where item_code = 'NE001';

-- Post state
select * from item
where item_code = 'NE01';

select * from item_treatment
where item_code = 'NE01';
rollback;

-- Post state after rollback
select * from item
where item_code = 'NE001';

select * from item_treatment
where item_code = 'NE001';






/* (ii)*/

create or replace trigger check_patient_name

BEFORE insert or update on Patient
FOR EACH ROW
BEGIN
    IF :new.PATIENT_FNAME is NULL and :new.PATIENT_LNAME is NULL THEN 
        raise_application_error(-20000,'The First and Last names can both not be EMPTY!!!');
    END IF;
    
END;
/

set serveroutput on
set echo on

select * from Patient;

-- Test Insert
-- Insert with one name NULL
insert into PATIENT (PATIENT_ID, PATIENT_FNAME, PATIENT_LNAME, PATIENT_ADDRESS, PATIENT_DOB, PATIENT_CONTACT_PHN) values (83590, 'Asghar', NULL, '2740 Sauthon Pass', TO_DATE('04/28/1956','MM/DD/YYYY'), '0492542464');
--  Insert with both name NULL (to give error)
insert into PATIENT (PATIENT_ID, PATIENT_FNAME, PATIENT_LNAME, PATIENT_ADDRESS, PATIENT_DOB, PATIENT_CONTACT_PHN) values (83592, NULL, NULL, '2940 Sauthon Pass', TO_DATE('06/28/1960','MM/DD/YYYY'), '0432542464');


-- Test Update
-- Update to both Names NULL (To give error)
update PATIENT set PATIENT_FNAME = NULL where PATIENT_FNAME = 'Asghar';

-- Post State
select * from Patient;
rollback;

-- Pre State
select * from Patient;






/* (iii)*/
create or replace trigger adjust_item_stock

BEFORE insert on item_treatment
FOR EACH ROW
DECLARE stock NUMBER;
BEGIN
    select item_stock into stock from item
    where item_code = :new.item_code;
    IF stock - :new.IT_QTY_USED>=0 then
    update item
    set item_stock=item_stock- :new.IT_QTY_USED where item_code = :new.item_code;
    ELSIF stock - :new.IT_QTY_USED<0 then
    raise_application_error(-20010,'The stock does not have enough item!!!');
    END IF;
END;
/

set serveroutput on
set echo on

-- Pre State
select * from item
where item_code='LB250';
-- Insert item with quantity less than current stock
insert into ITEM_TREATMENT (ADPRC_NO,ITEM_CODE,IT_QTY_USED,IT_ITEM_TOTAL_COST) values (15234,'LB250',3,700);
select * from item
where item_code='LB250';

-- Try insert with quantity more than current stock
insert into ITEM_TREATMENT (ADPRC_NO,ITEM_CODE,IT_QTY_USED,IT_ITEM_TOTAL_COST) values (21355,'CF050',11,4000);

-- After rollback
rollback;
select * from item
where item_code='LB250';




