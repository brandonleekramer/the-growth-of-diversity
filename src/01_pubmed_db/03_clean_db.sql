WITH tbl AS (
	SELECT xml_file_name, COUNT(fk_pmid) 
	FROM pubmed_2021.tbl_pmids_in_file
	GROUP BY xml_file_name 
), missing_tables AS (
	SELECT * 
	FROM tbl 
	WHERE count < 29000
), pmids_to_delete AS (
	SELECT fk_pmid, missing_tables.xml_file_name
	FROM pubmed_2021.tbl_pmids_in_file 
	INNER JOIN missing_tables
	ON tbl_pmids_in_file.xml_file_name = missing_tables.xml_file_name
	LIMIT 1000
)
SELECT * 
FROM pubmed_2021.tbl_abstract
INNER JOIN pmids_to_delete
ON tbl_abstract.fk_pmid = pmids_to_delete.fk_pmid
LIMIT 1000;  

--- looks like there was some kind of problem parsing these files
--- affected 0816, 0829, 0865, 0866, 0875, 0879, 0884, 0886, 0891
--- all of the rest were in the high 29,000s or at 30000 
--- i think i parse 900:1062 and come back to these problems later

--- 0432:0438 - 0472:0477
	
	
WITH tbl AS (
	SELECT xml_file_name, COUNT(fk_pmid) 
	FROM pubmed_2021.tbl_pmids_in_file
	GROUP BY xml_file_name 
)
SELECT * 
FROM tbl 
WHERE count < 29000; 	
	
	
CREATE MATERIALIZED VIEW pubmed_2021.pmids_to_delete AS (

WITH tbl AS (
	SELECT xml_file_name, COUNT(fk_pmid) 
	FROM pubmed_2021.tbl_pmids_in_file
	GROUP BY xml_file_name 
), missing_tables AS (
	SELECT * 
	FROM tbl 
	WHERE count < 29000
), pmids_to_delete AS (
	SELECT fk_pmid, missing_tables.xml_file_name
	FROM pubmed_2021.tbl_pmids_in_file 
	INNER JOIN missing_tables
	ON tbl_pmids_in_file.xml_file_name = missing_tables.xml_file_name
	LIMIT 1000
) 

SELECT * FROM pmids_to_delete LIMIT 1000 

); 

--- https://stackoverflow.com/questions/11391085/getting-date-list-in-a-range-in-postgresql



-- don't use - too much work -----
-- this one deletes all of the pmids from a given table with less than n files
-- the problem is that it only deletes entries from one table so i would 
-- have to run this on all the relevant tables for each list of tables 
-- its ultimately easier just to delete all the duplicates from each row later 

--CREATE TABLE pubmed_2021.pmids_to_delete AS (

WITH tbl AS (
	SELECT xml_file_name, COUNT(fk_pmid) 
	FROM pubmed_2021.tbl_pmids_in_file
	GROUP BY xml_file_name 
), missing_tables AS (
	SELECT * 
	FROM tbl 
	--WHERE count < 29000
	WHERE xml_file_name = 'pubmed21n0865.xml.gz'
), pmids_to_delete AS (
	SELECT fk_pmid, missing_tables.xml_file_name
	FROM pubmed_2021.tbl_pmids_in_file 
	INNER JOIN missing_tables
	ON tbl_pmids_in_file.xml_file_name = missing_tables.xml_file_name
	--LIMIT 1000
)

DELETE FROM pubmed_2021.tbl_abstract 
WHERE EXISTS (
SELECT FROM pmids_to_delete 
WHERE  pmids_to_delete.fk_pmid = tbl_abstract.fk_pmid
);

--);


