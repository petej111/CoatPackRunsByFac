-- Given search type, one of three queries are run.

-- declarations for testing/debugging only.
declare @pQueryType as varchar(30)
declare @pProcessEntity as varchar(30)
declare @pBatch as varchar(30)
declare @pNumRuns as int
declare @pStartTime as time
declare @pEndTime as time

set @pQueryType = 'RUNS'
set @pProcessEntity = 'PegasusStation01'
set @pBatch = ''
set @pNumRuns = 10
set @pStartTime = '2021-04-01'
set @pEndTime = '2021-04-02'

if (@pQueryType = 'RUNS')
	-- Query #1; returns results table for number of previous runs specified by @pNumRuns.
	begin 
	select top (@pNumRuns) tPE.[Desc] --vpe.[Name]
	from CoatPack_MDMS_RPT.dbo.ProcessEntity as tPE

	-- TODO
	end
else if (@pQueryType = 'BATCH_NUMBER')
	-- Query #2; returns results table filtered by batch number specified by @pBatch.
	begin
	select tPE.[Desc]
	from CoatPack_MDMS_RPT.dbo.ProcessEntity as tPE
	-- TODO
	end
else if (@pQueryType = 'DATE_RANGE')
	-- Query #3; returns results table filtered by date where @pStartTime <= date <= @pEndTime.
	begin
	select tPE.[Desc]
	from CoatPack_MDMS_RPT.dbo.ProcessEntity as tPE
	-- TODO
	end