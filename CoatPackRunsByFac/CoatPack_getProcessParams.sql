-- Following query generates results table containing all relevent process parameters for a given
-- process entity name.

select distinct tPPT.[Name], tCPE.[Desc]
from CoatPack_MDMS_RPT.dbo.ProcParmType as tPPT

	inner join CoatPack_MDMS_RPT.dbo.CurrentProcessEntityType as tCPET
		on tCPET.ProcEntTypeRevID = tPPT.ProcEntTypeRevID

	inner join CoatPack_MDMS_RPT.dbo.CurrentProcessEntity as tCPE
		on tCPE.ProcEntTypeID = tCPET.ProcEntTypeID

where tCPE.[Desc] = @pProcessEntity

order by tPPT.[Name] asc