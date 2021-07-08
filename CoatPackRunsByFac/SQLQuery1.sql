select distinct vRPD.RunParamName 
from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE

	inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
	on vPE.ProcEntTypeID = vRPD.ProcEntTypeRevID

	inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
	on vPE.ProcEntRevID = vR.ProcEntRevID

where vPE.[Desc] = 'PegasusStation01'

--('CoatRHSolBatchID',
--	'RackID',
--	'CoatRHRework',
--	'CoatLHEndTime',
--	'CoatRHEndTime',
--	'CoatLHSolBatchID',
--	'CoatLHStartTime',
--	'CureEndTime',
--	'CoatRHStartTime',
--	'CoatLHRework',
--	'CureStartTime')