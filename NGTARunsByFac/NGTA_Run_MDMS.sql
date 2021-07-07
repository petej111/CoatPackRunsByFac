-- 210113JP - specifies that statements cannot read data that has been modified 
-- but not committed by other transactions. prevents dirty reads. data can be 
-- changed by other transactions between individual statements within the current 
-- transaction, resulting in nonrepeatable reads/phantom data. This option is the 
-- SQL Server default.
SET TRANSACTION	ISOLATION LEVEL READ COMMITTED 

-- 210113JP - selects database to use.
USE [NGTA_MDMS_Rpt]

-- 210113JP - user defined variable
DECLARE @TopCycles AS INT
SET @TopCycles = CAST(@NumRuns AS INT)

-- 210113JP - user defined table variable; 'FacObjID' integer column specified.
DECLARE @tmpFacObjs TABLE (FacObjID INT)

-- 210122JP - inserting what into tmpFacObjs table?
INSERT @tmpFacObjs( FacObjID )

-- 210122JP - why is '@FacID = 9999', and '@FacTypeID = 9999' being tested?
-- 210122JP - 'pe' alias assigned to ProcessEntity table.
SELECT pe.ProcEntRevID 
FROM [dbo].[vw_ProcessEntity] pe
WHERE (@FacID = 9999 OR ProcEntID = @FacID) AND (@FacTypeID = 9999 OR ProcEntRevID = @FacTypeID) 
--select * from @tmpFacObjs
-- 210122JP - value of '@SearchType' equals value entered into report builder by user.
IF(@SearchType = 'Runs')
	BEGIN
		-- 210122JP set 'TopCycles' equal to value
		-- of 'NumRuns' set in report builder; why repeated here?
		SET @TopCycles = CAST(@NumRuns AS INT)
		
		SELECT 
			R.RunID, 
			CASE
				-- 210113JP when first eight characters starting from the right of r.ProcEntName =
				-- the specified condition; case statement used to make default 'system##' naming
				-- more descriptive/useful. 
				WHEN  RIGHT(r.ProcEntName, 8) = 'System01' THEN 'OTW BalloonInspectionSystem01'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System02' THEN 'MR3 BalloonInspectionSystem02'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System03' THEN 'MR2 BalloonInspectionSystem03'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System04' THEN 'MR1 BalloonInspectionSystem04'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System05' THEN 'H3 BalloonInspectionSystem05'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System06' THEN 'H1 BalloonInspectionSystem06'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System07' THEN 'H2 BalloonInspectionSystem07'
				ELSE R.ProcEntName
			END AS 'FacObjName',
			R.Batch, 
			R.Matl,
			R.BeginRunDT, 
			R.EndRunDT, 
			RPD.PartParam, 
			RPD.PartParamValue
		FROM (
			SELECT TOP (@TopCycles)
			R.RunID
			FROM vw_Run R
			WHERE R.ProcEntRevID IN (SELECT TFO.FacObjID FROM @tmpFacObjs TFO)  
			ORDER BY R.RunID DESC) D
		INNER JOIN vw_Run R ON R.RunID = D.RunID 
		LEFT OUTER JOIN vw_Run_PartDetail RPD ON R.RunID = RPD.RunID 
		ORDER BY R.RunID DESC
	END
ELSE IF (@SearchType = 'Batch')
	BEGIN
		SELECT 
			R.RunID, 
			CASE
				WHEN  RIGHT(r.ProcEntName, 8) = 'System01' THEN 'OTW BalloonInspectionSystem01'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System02' THEN 'MR3 BalloonInspectionSystem02'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System03' THEN 'MR2 BalloonInspectionSystem03'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System04' THEN 'MR1 BalloonInspectionSystem04'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System05' THEN 'H3 BalloonInspectionSystem05'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System06' THEN 'H1 BalloonInspectionSystem06'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System07' THEN 'H2 BalloonInspectionSystem07'
				ELSE R.ProcEntName
			END AS 'FacObjName',
			R.Batch, 
			R.Matl,
			R.BeginRunDT, 
			R.EndRunDT, 
			RPD.PartParam, 
			RPD.PartParamValue
		FROM vw_Run R  
		LEFT OUTER JOIN vw_Run_PartDetail RPD ON R.RunID = RPD.RunID 
		WHERE R.ProcEntRevID IN (SELECT TFO.FacObjID FROM @tmpFacObjs TFO)  
		AND R.Batch = @Batch -- 210122JP filter by batch.
		ORDER BY R.RunID DESC
	END
ELSE IF (@SearchType = 'TimeRange')
	BEGIN
		SELECT 
			R.RunID, 
			CASE
				WHEN  RIGHT(r.ProcEntName, 8) = 'System01' THEN 'OTW BalloonInspectionSystem01'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System02' THEN 'MR3 BalloonInspectionSystem02'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System03' THEN 'MR2 BalloonInspectionSystem03'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System04' THEN 'MR1 BalloonInspectionSystem04'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System05' THEN 'H3 BalloonInspectionSystem05'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System06' THEN 'H1 BalloonInspectionSystem06'
				WHEN  RIGHT(r.ProcEntName, 8) = 'System07' THEN 'H2 BalloonInspectionSystem07'
				ELSE R.ProcEntName
			END AS 'FacObjName',
			R.Batch, 
			R.Matl,
			R.BeginRunDT, 
			R.EndRunDT, 
			RPD.PartParam, 
			RPD.PartParamValue
		FROM vw_Run R 
		LEFT OUTER JOIN vw_Run_PartDetail RPD ON R.RunID = RPD.RunID 
		WHERE R.ProcEntRevID IN (SELECT TFO.FacObjID FROM @tmpFacObjs TFO)  
		AND R.BeginRunDT BETWEEN @BeginDT AND @EndDT -- 210122JP filter by date range.
		ORDER BY R.RunID DESC
	END