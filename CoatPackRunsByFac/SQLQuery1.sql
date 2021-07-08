-- vvv WORKING! vvv
select vPE.[Desc],
	vR.runID,
	vR.Batch,
	vR.Matl,
	vR.BeginRunDT,
	vR.EndRunDT,
	vRPD.RunParamName,
	vRPD.RunParamValue
from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE
	inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
		on vPE.ProcEntRevID = vR.ProcEntRevID
	inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
		on vR.RunID = vRPD.RunID

where vPE.[Desc] = 'Clean And Coat'
order by vR.RunID desc