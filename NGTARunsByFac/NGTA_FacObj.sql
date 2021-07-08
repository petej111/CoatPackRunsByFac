-- only changes that have been committed are read; prevents "dirty reads" or results that 
-- cannot be reproduced; this is the default for SSMS.
SET TRANSACTION	ISOLATION LEVEL READ COMMITTED 

-- OBJECT_ID returns the database object identification number of a schema-scoped object
IF OBJECT_ID('tempdb..#t1') IS NOT NULL

	-- 'Drop Table' deletes the table in the specified database and results in complete loss
	-- of all information stored in the table.
    DROP TABLE #t1;
IF OBJECT_ID('tempdb..#t2') IS NOT NULL
    DROP TABLE #t2;
IF OBJECT_ID('tempdb..#t3') IS NOT NULL
    DROP TABLE #t3;
IF OBJECT_ID('tempdb..#t4') IS NOT NULL
    DROP TABLE #t4;
IF OBJECT_ID('tempdb..#t5') IS NOT NULL
    DROP TABLE #t5;

USE [APEX_RPT]
 
SELECT
	'ALL Stations' AS 'Station',
	'' AS 'FacObjName',
	'9999' AS 'FacObjID',
	'9999' AS 'FacObjTypeID',
	'9999_9999' AS 'ID_TYPE' into #t1


SELECT 
	CASE
		-- Adding description to general factory object names as encountered.
		WHEN LEFT(FacObjName, 6) = 'Line A' THEN Replace(FacObjName,'Line A MG MR', 'MR1')
		WHEN LEFT(FacObjName, 6) = 'Line J' THEN Replace(FacObjName,'Line J MG Hybrid', 'MR2')
		WHEN LEFT(FacObjName, 6) = 'Line G' THEN Replace(FacObjName,'Line G MG Hybrid', 'H2')
		WHEN LEFT(FacObjName, 6) = 'Line E' THEN Replace(FacObjName,'Line E MG Hybrid', 'H1')
		WHEN FacObjName LIKE 'Line H1 MG Hybrid%' THEN Replace(FacObjName,'Line H1 MG Hybrid', 'H1')
		WHEN FacObjName LIKE 'Line H1 MG%' THEN Replace(FacObjName,'Line H1 MG', 'H1')
		WHEN FacObjName LIKE 'Line H2 MG Hybrid%' THEN Replace(FacObjName,'Line H2 MG Hybrid', 'H2')
		WHEN FacObjName LIKE 'Line H2 MG%' THEN Replace(FacObjName,'Line H2 MG', 'H2')
		WHEN FacObjName LIKE 'Line H3 MG Hybrid%' THEN Replace(FacObjName,'Line H3 MG Hybrid', 'H3')
		WHEN FacObjName LIKE 'Line H3 MG%' THEN Replace(FacObjName,'Line H3 MG', 'H3')
		WHEN FacObjName LIKE 'Line H3%' THEN Replace(FacObjName,'Line H3', 'H3')
		WHEN FacObjName LIKE 'Line MR1 MG%' THEN Replace(FacObjName,'Line MR1 MG', 'MR1')
		WHEN FacObjName LIKE 'Line MR2 MG%' THEN Replace(FacObjName,'Line MR2 MG', 'MR2')
		WHEN FacObjName LIKE 'Express OTW 1%' THEN Replace(FacObjName,'Express OTW 1', 'OTW')
		WHEN LEFT(FacObjName, 11) = 'Line MR3 MG' THEN Replace(FacObjName,'Line MR3 MG', 'MR3')
		WHEN FacObjName LIKE 'Line MR3%' THEN Replace(FacObjName,'Line MR3', 'MR3')
		WHEN LEFT(FacObjName, 20) = 'Line D MG OTW Periph' THEN Replace(FacObjName,'Line D MG OTW', 'OTW')
		WHEN LEFT(FacObjName, 13) = 'Line D MG OTW' THEN Replace(FacObjName,'Line D MG OTW', 'OTW')
		WHEN LEFT(FacObjName, 9) = 'Line D MG' THEN Replace(FacObjName,'Line D MG ', 'OTW')
		ELSE FacObjName
	END 'Station', 
	F.FacObjName,
	F.FacObjID,
	F.FacObjTypeID,
	CAST(F.FacObjID AS VARCHAR) + '_' + CAST(F.FacObjTypeID AS VARCHAR) AS 'ID_TYPE' into #t2
FROM FacObj F
INNER JOIN 
	FacObjType T ON F.FacObjTypeID = T.FacObjTypeID
WHERE T.FacObjHierID = '10000004'
AND NOT F.FacObjName LIKE '% GAL %'
--ORDER BY FacObjTypeID

-- JP 210114 square brackets are used to delimit identifiers; necessary if the column name 
-- is a reserved keyword (e.g. 'order' or 'name') or contains special characters like space
-- or hyphen.
SELECT 
	REPLACE('ALL ' + [Name], ' Type', '') AS 'Station',
	REPLACE(REPLACE(REPLACE('%' + [Name] + '%', ' Type', ''), ' Station', ''), 'Inspection', 'Insp') AS 'FacObjName',
	NULL AS 'FacObjID',
	FacObjTypeID,
	'9999_' + CAST(FacObjTypeID AS VARCHAR) AS 'ID_TYPE' into #t3
FROM
	FacObjType
WHERE FacObjHierID =  '10000004'



---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------

USE [NGTA_MDMS_Rpt]

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 
	CASE
		WHEN  RIGHT(pe.Name, 8) = 'System01' THEN 'OTW BalloonInspectionSystem01'
		WHEN  RIGHT(pe.Name, 8) = 'System02' THEN 'MR3 BalloonInspectionSystem02'
		WHEN  RIGHT(pe.Name, 8) = 'System03' THEN 'MR2 BalloonInspectionSystem03'
		WHEN  RIGHT(pe.Name, 8) = 'System04' THEN 'MR1 BalloonInspectionSystem04'
		WHEN  RIGHT(pe.Name, 8) = 'System05' THEN 'H3 BalloonInspectionSystem05'
		WHEN  RIGHT(pe.Name, 8) = 'System06' THEN 'H1 BalloonInspectionSystem01'
		WHEN  RIGHT(pe.Name, 8) = 'System07' THEN 'H2 BalloonInspectionSystem01'
		ELSE pe.Name
	END 'Station', 
	pe.Name,
	MAX(pe.ProcEntID) AS 'FacObjID',
	MAX(pe.ProcEntRevID) AS 'FacObjTypeID',
	CAST(pe.ProcEntID AS VARCHAR) + '_' + CAST(pe.ProcEntRevID AS VARCHAR) AS 'ID_TYPE' into #t4
	FROM [NGTA_MDMS_Rpt].[dbo].[vw_ProcessEntity] pe
	WHERE pe.Name like 'BalloonInspectionSystem%'
	Group by pe.Name, pe.ProcEntID, pe.ProcEntRevID


Select 
	Station as 'Station',
	Name, 
	FacObjID as 'FacObjID',
	Max (FacObjTypeID) as 'FacObjTypeID',
	CAST(FacObjID AS VARCHAR) + '_' + CAST( MAX(FacObjTypeID) AS VARCHAR) AS 'ID_TYPE' into #t5
	from #t4 group by Station, name, #t4.FacObjID


Select * from #t1 Union Select * from #t2 Union Select * from #t3 Union Select * from #t5


IF OBJECT_ID('tempdb..#t1') IS NOT NULL
    DROP TABLE #t1;
IF OBJECT_ID('tempdb..#t2') IS NOT NULL
    DROP TABLE #t2;
IF OBJECT_ID('tempdb..#t3') IS NOT NULL
    DROP TABLE #t3;
IF OBJECT_ID('tempdb..#t4') IS NOT NULL
    DROP TABLE #t4;
IF OBJECT_ID('tempdb..#t5') IS NOT NULL
    DROP TABLE #t5;
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------