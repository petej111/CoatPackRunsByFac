-- list run params for all processes.

select distinct 
	vPE.[Name], 
	vPE.[Desc], 
	vRPD.RunParamName

from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE

	left outer join CoatPack_MDMS_RPT.dbo.vw_Run as vR
	on vPE.ProcEntRevID = vR.ProcEntRevID

	left outer join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
	on vR.RunID = vRPD.RunID

order by vPE.[Name] asc