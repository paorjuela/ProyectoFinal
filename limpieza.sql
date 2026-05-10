START TRANSACTION;

	ALTER TABLE "raw".orders DROP COLUMN postal_code;
	ALTER TABLE "raw".orders DROP COLUMN row_id;
	
	/*
	SELECT *
	FROM "raw".orders;
	*/
	
ROLLBACK;
--COMMIT;
