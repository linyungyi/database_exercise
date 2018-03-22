 /*
*****************************************************************
* Parameter Description 					*
*---------------------------------------------------------------*
* @Operator		:Operator ID				*
*****************************************************************
*/
create proc AccountRemove
(@Operator varchar(20),
 @DeleteYear varchar(4),
 @DeleteMonth varchar(2),
 @DeleteDay	varchar(2)
 )
as
begin
	declare @DeleteDate datetime,
		@result int,
		@count_item int
		
	select  @DeleteDate = @DeleteMonth + "/" + @DeleteDay + "/" + @DeleteYear + " 23:59:59"
	select @result=0
	
	select @count_item=count(Reg_System_ID)
	from Account
	where Status=2
	and Maintain_Date < @DeleteDate
	
	
	if @count_item = 0
	begin
		select @result=1
		select result=@result
		return
	end
	
	select 'result'=@result
	select Reg_System_ID
	into #temp_Account
	from Account
	where Status=2
	and Maintain_Date < @DeleteDate
	
	delete Account where Status=2 and Maintain_Date < @DeleteDate
	
	exec InsEventLog @Operator,10,7,null,null,'Remove Account'
	delete Account_Internal
	from Account_Internal,#temp_Account
	where Account_Internal.Reg_System_ID=#temp_Account.Reg_System_ID
	
	delete Subscriber_Info 
	from Subscriber_Info,#temp_Account
	where Subscriber_Info.Reg_System_ID=#temp_Account.Reg_System_ID
	
	delete ServiceClass
	from ServiceClass,#temp_Account
	where ServiceClass.Reg_System_ID=#temp_Account.Reg_System_ID
	
	delete Notify_Schedule
	from Notify_Schedule,#temp_Account
	where Notify_Schedule.Reg_System_ID=#temp_Account.Reg_System_ID
	
	drop table #temp_Account
	
end
return
