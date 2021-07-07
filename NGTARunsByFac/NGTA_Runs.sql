SET TRANSACTION	ISOLATION LEVEL READ COMMITTED 

DECLARE @TopCycles AS INT
SET @TopCycles = CAST(@NumRuns AS INT)

DECLARE @tmpFacObjs TABLE (FacObjID INT)

INSERT @tmpFacObjs
              ( FacObjID )
SELECT FO.FacObjID FROM vw_FactoryObject FO
WHERE (@FacID = 9999 OR FacObjID = @FacID) AND (@FacTypeID = 9999 OR FacObjTypeID = @FacTypeID) 

IF(@SearchType = 'Runs') ---RUNS
	BEGIN

		SET @TopCycles = CAST(@NumRuns AS INT)
		
		SELECT 
			R.RunID, 
			CASE
				WHEN LEFT(R.FacObjName, 6) = 'Line A' THEN Replace(R.FacObjName,'Line A MG MR', 'MR1')
				WHEN LEFT(R.FacObjName, 6) = 'Line J' THEN Replace(R.FacObjName,'Line J MG Hybrid', 'MR2')
				WHEN LEFT(R.FacObjName, 6) = 'Line G' THEN Replace(R.FacObjName,'Line G MG Hybrid', 'H2')
				WHEN LEFT(R.FacObjName, 6) = 'Line E' THEN Replace(R.FacObjName,'Line E MG Hybrid', 'H1')
				WHEN R.FacObjName LIKE 'Line H1 MG Hybrid%' THEN Replace(R.FacObjName,'Line H1 MG Hybrid', 'H1')
				WHEN R.FacObjName LIKE 'Line H1 MG%' THEN Replace(R.FacObjName,'Line H1 MG', 'H1')
				WHEN R.FacObjName LIKE 'Line H2 MG Hybrid%' THEN Replace(R.FacObjName,'Line H2 MG Hybrid', 'H2')
				WHEN R.FacObjName LIKE 'Line H2 MG%' THEN Replace(R.FacObjName,'Line H2 MG', 'H2')
				WHEN R.FacObjName LIKE 'Line H3 MG Hybrid%' THEN Replace(R.FacObjName,'Line H3 MG Hybrid', 'H3')
				WHEN R.FacObjName LIKE 'Line H3 MG%' THEN Replace(R.FacObjName,'Line H3 MG', 'H3')
				WHEN R.FacObjName LIKE 'Line H3%' THEN Replace(R.FacObjName,'Line H3', 'H3')
				WHEN R.FacObjName LIKE 'Line MR1 MG%' THEN Replace(R.FacObjName,'Line MR1 MG', 'MR1')
				WHEN R.FacObjName LIKE 'Line MR2 MG%' THEN Replace(R.FacObjName,'Line MR2 MG', 'MR2')
				WHEN R.FacObjName LIKE 'Express OTW 1%' THEN Replace(R.FacObjName,'Express OTW 1', 'OTW')
				WHEN LEFT(R.FacObjName, 11) = 'Line MR3 MG' THEN Replace(R.FacObjName,'Line MR3 MG', 'MR3')
				WHEN R.FacObjName LIKE 'Line MR3%' THEN Replace(R.FacObjName,'Line MR3', 'MR3')
				WHEN LEFT(R.FacObjName, 13) = 'Line D MG OTW' THEN Replace(R.FacObjName,'Line D MG OTW', 'OTW')
				WHEN LEFT(R.FacObjName, 9) = 'Line D MG' THEN Replace(R.FacObjName,'Line D MG ', 'OTW')
				ELSE R.FacObjName
			END AS 'FacObjName',
			R.Batch, 
			R.BatchSeq, 
			R.Matl,
			R.BeginRunDT, 
			R.EndRunDT, 
			RPD.RunParamName, 
			RPD.RunParamValue
		FROM (
			SELECT TOP (@TopCycles)
			R.RunID
			FROM vw_Run R
			WHERE R.FacObjID IN (SELECT TFO.FacObjID FROM @tmpFacObjs TFO)  
			ORDER BY R.RunID DESC) D
		INNER JOIN vw_Run R ON R.RunID = D.RunID 
		LEFT OUTER JOIN vw_Run_ParameterDetail RPD ON R.RunID = RPD.RunID --AND RPD.RunParamName IN (@RunParamNames) 
		ORDER BY R.RunID DESC
	END
ELSE IF (@SearchType = 'Batch') --BATCH
	BEGIN
		SELECT 
			R.RunID, 
			CASE
				WHEN LEFT(R.FacObjName, 6) = 'Line A' THEN Replace(R.FacObjName,'Line A MG MR', 'MR1')
				WHEN LEFT(R.FacObjName, 6) = 'Line J' THEN Replace(R.FacObjName,'Line J MG Hybrid', 'MR2')
				WHEN LEFT(R.FacObjName, 6) = 'Line G' THEN Replace(R.FacObjName,'Line G MG Hybrid', 'H2')
				WHEN LEFT(R.FacObjName, 6) = 'Line E' THEN Replace(R.FacObjName,'Line E MG Hybrid', 'H1')
				WHEN R.FacObjName LIKE 'Line H1 MG Hybrid%' THEN Replace(R.FacObjName,'Line H1 MG Hybrid', 'H1')
				WHEN R.FacObjName LIKE 'Line H1 MG%' THEN Replace(R.FacObjName,'Line H1 MG', 'H1')
				WHEN R.FacObjName LIKE 'Line H2 MG Hybrid%' THEN Replace(R.FacObjName,'Line H2 MG Hybrid', 'H2')
				WHEN R.FacObjName LIKE 'Line H2 MG%' THEN Replace(R.FacObjName,'Line H2 MG', 'H2')
				WHEN R.FacObjName LIKE 'Line H3 MG Hybrid%' THEN Replace(R.FacObjName,'Line H3 MG Hybrid', 'H3')
				WHEN R.FacObjName LIKE 'Line H3 MG%' THEN Replace(R.FacObjName,'Line H3 MG', 'H3')
				WHEN R.FacObjName LIKE 'Line H3%' THEN Replace(R.FacObjName,'Line H3', 'H3')
				WHEN R.FacObjName LIKE 'Line MR1 MG%' THEN Replace(R.FacObjName,'Line MR1 MG', 'MR1')
				WHEN R.FacObjName LIKE 'Line MR2 MG%' THEN Replace(R.FacObjName,'Line MR2 MG', 'MR2')
				WHEN R.FacObjName LIKE 'Express OTW 1%' THEN Replace(R.FacObjName,'Express OTW 1', 'OTW')
				WHEN LEFT(R.FacObjName, 11) = 'Line MR3 MG' THEN Replace(R.FacObjName,'Line MR3 MG', 'MR3')
				WHEN R.FacObjName LIKE 'Line MR3%' THEN Replace(R.FacObjName,'Line MR3', 'MR3')
				WHEN LEFT(R.FacObjName, 13) = 'Line D MG OTW' THEN Replace(R.FacObjName,'Line D MG OTW', 'OTW')
				WHEN LEFT(R.FacObjName, 9) = 'Line D MG' THEN Replace(R.FacObjName,'Line D MG ', 'OTW')
				ELSE R.FacObjName
			END AS 'FacObjName', 
			R.Batch, 
			R.BatchSeq, 
			R.Matl,
			R.BeginRunDT, 
			R.EndRunDT, 
			RPD.RunParamName, 
			RPD.RunParamValue
		FROM vw_Run R  
		LEFT OUTER JOIN vw_Run_ParameterDetail RPD ON R.RunID = RPD.RunID AND RPD.RunParamName IN (@RunParamNames) 
		WHERE R.FacObjID IN (SELECT TFO.FacObjID FROM @tmpFacObjs TFO)  
		AND R.Batch = @Batch
		ORDER BY R.RunID DESC
	END
ELSE IF (@SearchType = 'TimeRange') --TIMERANGE
	BEGIN
		SELECT 
			R.RunID, 
			CASE
				WHEN LEFT(R.FacObjName, 6) = 'Line A' THEN Replace(R.FacObjName,'Line A MG MR', 'MR1')
				WHEN LEFT(R.FacObjName, 6) = 'Line J' THEN Replace(R.FacObjName,'Line J MG Hybrid', 'MR2')
				WHEN LEFT(R.FacObjName, 6) = 'Line G' THEN Replace(R.FacObjName,'Line G MG Hybrid', 'H2')
				WHEN LEFT(R.FacObjName, 6) = 'Line E' THEN Replace(R.FacObjName,'Line E MG Hybrid', 'H1')
				WHEN R.FacObjName LIKE 'Line H1 MG Hybrid%' THEN Replace(R.FacObjName,'Line H1 MG Hybrid', 'H1')
				WHEN R.FacObjName LIKE 'Line H1 MG%' THEN Replace(R.FacObjName,'Line H1 MG', 'H1')
				WHEN R.FacObjName LIKE 'Line H2 MG Hybrid%' THEN Replace(R.FacObjName,'Line H2 MG Hybrid', 'H2')
				WHEN R.FacObjName LIKE 'Line H2 MG%' THEN Replace(R.FacObjName,'Line H2 MG', 'H2')
				WHEN R.FacObjName LIKE 'Line H3 MG Hybrid%' THEN Replace(R.FacObjName,'Line H3 MG Hybrid', 'H3')
				WHEN R.FacObjName LIKE 'Line H3 MG%' THEN Replace(R.FacObjName,'Line H3 MG', 'H3')
				WHEN R.FacObjName LIKE 'Line H3%' THEN Replace(R.FacObjName,'Line H3', 'H3')
				WHEN R.FacObjName LIKE 'Line MR1 MG%' THEN Replace(R.FacObjName,'Line MR1 MG', 'MR1')
				WHEN R.FacObjName LIKE 'Line MR2 MG%' THEN Replace(R.FacObjName,'Line MR2 MG', 'MR2')
				WHEN R.FacObjName LIKE 'Express OTW 1%' THEN Replace(R.FacObjName,'Express OTW 1', 'OTW')
				WHEN LEFT(R.FacObjName, 11) = 'Line MR3 MG' THEN Replace(R.FacObjName,'Line MR3 MG', 'MR3')
				WHEN R.FacObjName LIKE 'Line MR3%' THEN Replace(R.FacObjName,'Line MR3', 'MR3')
				WHEN LEFT(R.FacObjName, 13) = 'Line D MG OTW' THEN Replace(R.FacObjName,'Line D MG OTW', 'OTW')
				WHEN LEFT(R.FacObjName, 9) = 'Line D MG' THEN Replace(R.FacObjName,'Line D MG ', 'OTW')
				ELSE R.FacObjName
			END AS 'FacObjName', 
			R.Batch, 
			R.BatchSeq, 
			R.Matl,
			R.BeginRunDT, 
			R.EndRunDT, 
			RPD.RunParamName, 
			RPD.RunParamValue
		FROM vw_Run R 
		LEFT OUTER JOIN vw_Run_ParameterDetail RPD ON R.RunID = RPD.RunID AND RPD.RunParamName IN (@RunParamNames) 
		WHERE R.FacObjID IN (SELECT TFO.FacObjID FROM @tmpFacObjs TFO)  
		AND R.BeginRunDT BETWEEN @BeginDT AND @EndDT
		ORDER BY R.RunID DESC
	END