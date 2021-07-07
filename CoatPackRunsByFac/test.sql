---- declare and set integer variable
--declare @test_var as int
--set @test_var = 1
--print @test_var

-------------------------------------------------------------------------------

---- list all tables in database; ensure target database is selected
---- in available databases.
--select SCHEMA_NAME(t.schema_id) as schema_name,
--		t.name as table_name,
--		t.create_date,
--		t.modify_date
--from sys.tables t
--order by schema_name,
--		table_name;

-------------------------------------------------------------------------------

---- print out each column for each table in database
--select distinct TABLE_NAME, COLUMN_NAME, DATA_TYPE
--from INFORMATION_SCHEMA.COLUMNS
--where TABLE_NAME in 
--		(select t.Table_Name
--		from INFORMATION_SCHEMA.TABLES t)

-------------------------------------------------------------------------------

---- print out all tables in database.
--select t.TABLE_CATALOG,
--		t.TABLE_SCHEMA,
--		t.TABLE_NAME
--from INFORMATION_SCHEMA.TABLES t;

-------------------------------------------------------------------------------

---- declare process entity variable. 
--declare @pProcessEntity as varchar(max)
--set @pProcessEntity = 'Auto Check Weigh Station 1'

---- generate results table containing all relevent process parameters for given
---- process entity name.
--select cpe.[Name], cpe.[Desc], ppt.[Name], ppt.[Desc]
--from CoatPack_MDMS_RPT.dbo.ProcParmType ppt
--inner join CoatPack_MDMS_RPT.dbo.CurrentProcessEntityType as cpet
--on cpet.ProcEntTypeRevID = ppt.ProcEntTypeRevID
--inner join CoatPack_MDMS_RPT.dbo.CurrentProcessEntity as cpe
--on cpe.ProcEntTypeID = cpet.ProcEntTypeID
--where cpe.Name = @pProcessEntity
--order by ppt.[Name] asc

-- CoatPackRunsByFac test:

select top 10 * 
from CoatPack_MDMS_RPT.dbo.vw_ProcessEntity

-------------------------------------------------------------------------------

--select top 10 *
--from CoatPack_MDMS_RPT.dbo.vw_Run

-------------------------------------------------------------------------------

---- get results
--select cpe.[Name], cpe.[Desc], ppt.[Name], ppt.[Desc], r.BeginRunDT, r.EndRunDT
--from CoatPack_MDMS_RPT.dbo.ProcParmType ppt
--inner join CoatPack_MDMS_RPT.dbo.CurrentProcessEntityType as cpet
--on cpet.ProcEntTypeRevID = ppt.ProcEntTypeRevID
--inner join CoatPack_MDMS_RPT.dbo.CurrentProcessEntity as cpe
--on cpe.ProcEntTypeID = cpet.ProcEntTypeID
--inner join CoatPack_MDMS_RPT.dbo.Run as r
--on r.ProcEntRevID = cpe.procentrevid 
--where cpe.Name = @pProcessEntity
--	and r.BeginRunDT >= @pStartTime 
--	and r.EndRunDT < @pEndTime

--order by ppt.[Name] asc

---- check if batch is 
--if (@pBatch is null or @pBatch != '')
--	-- filter by specified batch value.
--	print('')
--else
--	-- get all batches.
--	print('')