SELECT
  RPT.RunParamName
FROM
  vw_FactoryObject FO
  INNER JOIN vw_RunParamType RPT
  ON FO.FacObjTypeName = RPT.FacObjTypeName
WHERE FO.FacObjTypeID LIKE @FacTypeID
UNION 
SELECT TOP(1) '' FROM vw_Run