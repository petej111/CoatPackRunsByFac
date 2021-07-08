select top 100
	vPE.[Desc],
	vR.Batch,
	vR.Matl as Material,
	vR.BeginRunDT,
	vR.EndRunDT,
	vRPD.RunParamName,
	vRPD.RunParamValue
from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE

	inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
	on vPE.ProcEntTypeID = vRPD.ProcEntTypeRevID

	inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
	on vPE.ProcEntRevID = vR.ProcEntRevID

where vPE.[Desc] = 'PegasusStation01'
