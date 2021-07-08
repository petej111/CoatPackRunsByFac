set transaction isolation level read committed

-- Given search type, one of three queries are run.

-- vvv Debugging; remove in report builder vvv
declare @pQueryType as varchar(max)
declare @pNumRuns as int
declare @pProcessEntity as varchar(max)
declare @pBatch as varchar(max)
declare @pStartTime as date
declare @pEndTime as date

set @pQueryType = 'BATCH_NUMBER'
set @pNumRuns = 100
set @pProcessEntity = 'PegasusStation01'
set @pBatch = '27588039'
set @pStartTime = '2021-07-06'
set @pEndTime = '2021-07-07'
-- ^^^ Debugging; remove in report builder ^^^

if (@pQueryType = 'RUNS')
	-- returns results table for number of previous runs specified by @pNumRuns.
	begin 
		select top (@pNumRuns) vPE.[Desc],
			   vR.RunID as [Run ID],
			   vR.Batch,
			   vR.Matl as Material,
			   vR.BeginRunDT as [Start Time],
			   vR.EndRunDT as [End Time],
			   vRPD.RunParamName as [Param Name],
			   vRPD.RunParamValue as [Param Value]
		from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE

			inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
			on vPE.ProcEntTypeID = vRPD.ProcEntTypeRevID

			inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
			on vR.runID = vRPD.RunID

		where vRPD.RunParamName in --(@pProcessParams)
									('CoatRHSolBatchID',
									 'RackID',
									 'CoatRHRework',
									 'CoatLHEndTime',
									 'CoatRHEndTime',
									 'CoatLHSolBatchID',
									 'CoatLHStartTime',
									 'CureEndTime',
									 'CoatRHStartTime',
									 'CoatLHRework',
									 'CureStartTime')

		order by vR.RunID desc
	end
else if (@pQueryType = 'BATCH_NUMBER')
	-- returns results table filtered by batch number specified by @pBatch.
	begin
		select vPE.[Desc],
			   vR.RunID as [Run ID],
			   vR.Batch,
			   vR.Matl as Material,
			   vR.BeginRunDT as [Start Time],
			   vR.EndRunDT as [End Time],
			   vRPD.RunParamName as [Param Name],
			   vRPD.RunParamValue as [Param Value]
		from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE

			inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
			on vPE.ProcEntTypeID = vRPD.ProcEntTypeRevID

			inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
			on vR.runID = vRPD.RunID

		where vPE.[Desc] = @pProcessEntity 
			and vRPD.RunParamName in --(@pProcessParams)
									('CoatRHSolBatchID',
									 'RackID',
									 'CoatRHRework',
									 'CoatLHEndTime',
									 'CoatRHEndTime',
									 'CoatLHSolBatchID',
									 'CoatLHStartTime',
									 'CureEndTime',
									 'CoatRHStartTime',
									 'CoatLHRework',
									 'CureStartTime')
			and vR.Batch = @pBatch
		order by vR.RunID desc
	end
else if (@pQueryType = 'DATE_RANGE')
	-- returns results table filtered by date where @pStartTime <= date <= @pEndTime.
	begin
		select vPE.[Desc],
			   vR.RunID as [Run ID],
			   vR.Batch,
			   vR.Matl as Material,
			   vR.BeginRunDT as [Start Time],
			   vR.EndRunDT as [End Time],
			   vRPD.RunParamName as [Param Name],
			   vRPD.RunParamValue as [Param Value]
		from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE

			inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
			on vPE.ProcEntTypeID = vRPD.ProcEntTypeRevID

			inner join CoatPack_MDMS_RPT.dbo.vw_Run as vR
			on vPE.ProcEntRevID = vR.ProcEntRevID

		where vPE.[Desc] = @pProcessEntity 
			and vRPD.RunParamName in --(@pProcessParams)
									('CoatRHSolBatchID',
									 'RackID',
									 'CoatRHRework',
									 'CoatLHEndTime',
									 'CoatRHEndTime',
									 'CoatLHSolBatchID',
									 'CoatLHStartTime',
									 'CureEndTime',
									 'CoatRHStartTime',
									 'CoatLHRework',
									 'CureStartTime')
			and vR.BeginRunDT >= @pStartTime 
			and vR.EndRunDT <= @pEndTime
		order by vR.RunID desc
	end