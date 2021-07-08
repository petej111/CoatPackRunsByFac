-- vvv Debugging; remove in report builder vvv
declare @pQueryType as varchar(max)
declare @pNumRuns as int
declare @pProcessEntity as varchar(max)
declare @pBatch as varchar(max)
declare @pStartTime as date
declare @pEndTime as date

set @pQueryType = 'RUNS'
set @pNumRuns = 10
set @pProcessEntity = 'PegasusStation01'
set @pBatch = '27588039'
set @pStartTime = '2021-07-06'
set @pEndTime = '2021-07-07'
-- ^^^ Debugging; remove in report builder ^^^

if (@pQueryType = 'RUNS')
	begin
		select top (@pNumRuns)
				vPE.[Desc],
				vR.RunID as [Run ID],
				vR.Batch,
				vR.Matl as Material,
				vR.BeginRunDT as [Start Time],
				vR.EndRunDT as [End Time],
				vRPD.RunParamName,
				vRPD.RunParamValue
		from CoatPack_MDMS_RPT.dbo.vw_Run as vR

			--inner join CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE
			--	on vR.ProcEntRevID = vPE.ProcEntRevID

			inner join CoatPack_MDMS_RPT.dbo.vw_Run_ParameterDetail as vRPD
				on vR.runID = vRPD.RunID

			left outer join CoatPack_MDMS_RPT.dbo.vw_ProcessEntity as vPE
				on vR.ProcEntRevID = vPE.ProcEntRevID

		where vPE.[Desc] = 'PegasusStation02'
			--and vRPD.RunParamName in --(@pProcessParams)
			--						('CoatRHSolBatchID',
			--							'RackID',
			--							'CoatRHRework',
			--							'CoatLHEndTime',
			--							'CoatRHEndTime',
			--							'CoatLHSolBatchID',
			--							'CoatLHStartTime',
			--							'CureEndTime',
			--							'CoatRHStartTime',
			--							'CoatLHRework',
			--							'CureStartTime')

		--order by vR.RunID desc
	end