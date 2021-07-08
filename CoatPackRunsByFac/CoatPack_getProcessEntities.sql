-- get all unique process entity descriptions in CPS.

-- TODO:
--    - categorize each process entity into a "family"
--    - other databases besides 'CoatPack_MDMS_RPT' for process entities?

select distinct vPE.[Desc]
from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE
