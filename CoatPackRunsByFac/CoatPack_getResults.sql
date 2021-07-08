set transaction isolation level read committed

use CoatPack_MDMS_RPT

-- Given search type, one of three queries are run.

-- vvv Debugging; remove in report builder vvv
declare @pQueryType as varchar(max)
declare @pNumRuns as int
declare @pProcessEntity as varchar(max)
declare @pBatch as varchar(max)
declare @pStartTime as date
declare @pEndTime as date

set @pQueryType = 'BATCH_NUMBER'
set @pNumRuns = 10
set @pProcessEntity = 'Clean And Coat'
set @pBatch = '27592622'
set @pStartTime = '2021-07-06'
set @pEndTime = '2021-07-07'
-- ^^^ Debugging; remove in report builder ^^^

if (@pQueryType = 'RUNS')
	-- returns results table for number of previous runs specified by @pNumRuns.
	begin 
		select top (@pNumRuns) vPE.[Desc] as [Process Entity],
			vR.runID as [Run ID],
			vR.Batch,
			vR.Matl as [Material],
			vR.BeginRunDT,
			vR.EndRunDT,
			vRPD.RunParamName as [Param Name],
			vRPD.RunParamValue as [Param Value]
		from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE
			inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
				on vPE.ProcEntRevID = vR.ProcEntRevID
			inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
				on vR.RunID = vRPD.RunID

		where vPE.[Desc] = @pProcessEntity
			--and vRPD.RunParamName in (@pProcessParams)
		order by vR.RunID desc
	end
else if (@pQueryType = 'BATCH_NUMBER')
	-- returns results table filtered by batch number specified by @pBatch.
	begin
		select vPE.[Desc] as [Process Entity],
			vR.runID as [Run ID],
			vR.Batch,
			vR.Matl as [Material],
			vR.BeginRunDT,
			vR.EndRunDT,
			vRPD.RunParamName as [Param Name],
			vRPD.RunParamValue as [Param Value]
		from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE
			inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
				on vPE.ProcEntRevID = vR.ProcEntRevID
			inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
				on vR.RunID = vRPD.RunID

		where vPE.[Desc] = @pProcessEntity
			--and vRPD.RunParamName in (@pProcessParams)
			and vR.Batch = @pBatch
		order by vR.RunID desc
	end
else if (@pQueryType = 'DATE_RANGE')
	-- returns results table filtered by date where @pStartTime <= date <= @pEndTime.
	begin
		select vPE.[Desc] as [Process Entity],
			vR.runID as [Run ID],
			vR.Batch,
			vR.Matl as [Material],
			vR.BeginRunDT,
			vR.EndRunDT,
			vRPD.RunParamName as [Param Name],
			vRPD.RunParamValue as [Param Value]
		from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE
			inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
				on vPE.ProcEntRevID = vR.ProcEntRevID
			inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
				on vR.RunID = vRPD.RunID

		where vPE.[Desc] = @pProcessEntity
			--and vRPD.RunParamName in (@pProcessParams)
			and vR.BeginRunDT >= @pStartTime
			and vR.EndRunDT <= @pEndTime
		order by vR.RunID desc
	end