 /*
*****************************************************************
* Parameter Description 					*
*---------------------------------------------------------------*
* @Operator		:Operator ID				*
*****************************************************************
*/
create proc AccountFail
(@Operator varchar(20),
 @Subscriber_ID varchar(20),
 @Folder_ID varchar(2)
)
as
begin
 	declare @MBDir 		varchar(25),
		@FileServer	varchar(10),
		@Reg_System_ID	char(14),
		@result		int,
		@DBServer varchar(20),
		@APServer varchar(20),
		@IsLocal char(1),
		@sql varchar(255),
		@remote_result int
		
 	exec check_DBServer @Subscriber_ID output,@DBServer output,@IsLocal output,@APServer output,@result output
	if @result !=0
	begin
		select 'result'=@result
		return @result
	end
	
	if @IsLocal ='0'
	begin
/*	    select @sql="AccountFail '"+@Operator+"','"+@Subscriber_ID+"','"+@Folder_ID+"'"
	    exec sp_remotesql @DBServer,@sql
	    
	    select @remote_result=@@error
	    if @remote_result !=0
	    begin
	    	select 'result'=@remote_result
	    end
*/
	    select @result=4
	    select 'result'=@result
	    return
	    return
	end
	
	select @Reg_System_ID=Reg_System_ID,@FileServer=FileServer 
	from Account_Internal
	where Subscriber_ID=@Subscriber_ID
	and Folder_ID=@Folder_ID
	
	if @@rowcount =0
	begin
		select @result=4
		select 'result'=@result
		return @result
	end
	
	exec InsEventLog @Operator,10,10,@Subscriber_ID,@Folder_ID,'Account add Fail'
	
	delete Subscriber_Info where Reg_System_ID=@Reg_System_ID
	
	delete Notify_Schedule where Reg_System_ID=@Reg_System_ID
	
	delete ServiceClass where Reg_System_ID=@Reg_System_ID
	
	delete Account where Reg_System_ID=@Reg_System_ID
	
	delete Account_Internal where Reg_System_ID=@Reg_System_ID
	
	delete Distribution_Group where Reg_System_ID=@Reg_System_ID
	
	update FileServer set MBcount=MBcount-1 where Name=@FileServer
	
	select 'result'=@result	
	
end
return
