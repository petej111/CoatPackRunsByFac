-- Following query generates results table containing all relevent process parameters for a given
-- process entity name.

---- declaration for testing only; comment out when moved to report builder.
declare @pProcessEntity as varchar(30)
set @pProcessEntity = 'PegasusStation01'

select distinct * --ppt.[Name]
from CoatPack_MDMS_RPT.dbo.ProcParmType tPPT

inner join CoatPack_MDMS_RPT.dbo.CurrentProcessEntityType as tCPET
	on tCPET.ProcEntTypeRevID = tPPT.ProcEntTypeRevID

inner join CoatPack_MDMS_RPT.dbo.CurrentProcessEntity as tCPE
	on tCPE.ProcEntTypeID = tCPET.ProcEntTypeID

where tCPE.[Desc] = @pProcessEntity

order by tPPT.[Name] asc