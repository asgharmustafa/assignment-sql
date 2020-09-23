/* FIT9132 2019 S1 Assignment 2 Q4 ANSWERS
   Student Name: Asghar Mustafa
    Student ID: 28905644

   Comments to your marker:
   Assumption for Q4 (i)
   Reorder level is set one time only to half of initial stock 
   Assumption for Q4 (ii)
   1) DOCS_Procedure contains an entry of the procedure if the procedure is performed by a Doctor.
   2) The Perform_DR_ID in ADM_PRC (being not NULL) helps to identify if the procedure was performed by a Doctor and thus should be in the table

*/
/* (i)*/

--ALTER TABLE ITEM DROP COLUMN REORDER_LEVEL;
ALTER TABLE ITEM ADD REORDER_LEVEL NUMBER DEFAULT 0 NOT NULL;

COMMENT ON COLUMN item.reorder_level IS 'Minimum level of stock for warning for reordering';
update item set reorder_level=floor(item_stock/2);

select * from item;


/* (ii)*/
DROP TABLE docs_procedure CASCADE CONSTRAINTS;

CREATE TABLE docs_procedure (
    adprc_no             NUMBER(7) NOT NULL,
    DOC_ID               NUMBER(4) NOT NULL,
    Lead_Doctor          NUMBER(1) NOT NULL
    
);

--ALTER TABLE docs_procedure ADD (Lead_Doctor NUMBER(1) DEFAULT 0 NOT NULL);
ALTER TABLE docs_procedure ADD CONSTRAINT CK_Lead_Doctor_Input CHECK (Lead_Doctor IN (0,1));
COMMENT ON COLUMN docs_procedure.adprc_no IS
    'Admission procedure identifier';

COMMENT ON COLUMN docs_procedure.DOC_ID IS
    'Identifier of the doctor involved in the procedure';
COMMENT ON COLUMN docs_procedure.lead_Doctor IS
    'Boolean variable to identify if the given doctor is the lead doctor (1 for lead and 0 for Ancillary)';

ALTER TABLE docs_procedure ADD CONSTRAINT docs_procedure_pk PRIMARY KEY (adprc_no,DOC_ID);

ALTER TABLE docs_procedure
    ADD CONSTRAINT docs_procedure_admprc FOREIGN KEY ( adprc_no )
        REFERENCES adm_prc ( adprc_no );

-- Insert into new table for ADPRC_NO 10953
insert into docs_procedure values (10953,1061,1);
insert into docs_procedure values (10953,1027,0);
insert into docs_procedure values (10953,2459,0);

select * from docs_procedure a natural join adm_prc b;










