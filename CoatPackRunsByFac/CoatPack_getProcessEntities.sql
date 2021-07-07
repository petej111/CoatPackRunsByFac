-- get all unique process entity descriptions.
select distinct vpe.[Name], vpe.[Desc]
-- from CoatPack_MDMS_RPT.dbo.CurrentProcessEntity pe
from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity vpe
where vpe.[Name] not in (select distinct tpe.[Name]
						 from CoatPack_MDMS_RPT.dbo.CurrentProcessEntity tpe)
