 /*
*****************************************************************
* Parameter Description 					*
*---------------------------------------------------------------*
* @Operator		:Operator ID				*
* @Password		:Default Password			*
*****************************************************************
*/
create proc AccountAdd
(@Operator varchar(20),
 @Subscriber_ID varchar(20),
 @Folder_ID varchar(2),
 @Password varchar(20)
 )
as
begin
	declare @present_datetime datetime,
		@MBDir 		varchar(25),
		@FileServer	varchar(10),
		@Profile_Combine	varchar(32),
		@Account_SeqNr	varchar(6),
		@Reg_System_ID	char(14),
		@Query_Allow	bit,
		@result		int,
		@DBServer varchar(20),
		@APServer varchar(20),
		@IsLocal char(1),
		@sql varchar(255),
		@count_item int,
		@remote_result int,
		@Main_Reg_System_ID char(14),
		@Notify_By_MWI bit,
		@IsVirtual bit,
		@temp_Password varchar(20),
		@CompanyType 	char(1)
	
	
	exec check_DBServer @Subscriber_ID output,@DBServer output,@IsLocal output,@APServer output,@result output
	if @result !=0
	begin
		select 'result'=@result
		return @result
	end
	
	if @IsLocal ='0'
	begin
/*	    select @sql="AccountAdd '"+@Operator+"','"+@Subscriber_ID+"','"+@Folder_ID+"','"+@Password+"'"
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
	
  	select @present_datetime=getdate()
	
	select @result=0
	select @count_item=0
	
	select @count_item=count(Reg_System_ID)
	from Account_Internal
	where Subscriber_ID=@Subscriber_ID
	and Folder_ID=@Folder_ID
	
	if @count_item >0
	begin
		select @result=2
		select 'result'=@result
		return @result
	end
	
	if @Folder_ID !='00' 
	begin
		select @Main_Reg_System_ID=Reg_System_ID
		from Account_Internal
		where Subscriber_ID=@Subscriber_ID
		and Folder_ID='00'
		
		select @Profile_Combine=Profile_Combine
		from ServiceClass
		Where Reg_System_ID=@Main_Reg_System_ID 
		
		if @@rowcount =0
		begin
			select @result=1
			select 'result'=@result
			return @result
		end
	end
	else
	begin
		select @Profile_Combine=Profile_Combine
		from AccountTemplate
	end
	
	exec get_Reg_System_ID @Reg_System_ID output
	
	exec get_MBDir @Subscriber_ID,@FileServer output,@MBDir output
	
	exec InsEventLog @Operator,10,1,@Subscriber_ID,@Folder_ID,'create new Account'
  	
  	select @Query_Allow=Query_Allow,@Notify_By_MWI=Notify_By_MWI,@temp_Password=Password
  	from AccountTemplate
  	
	exec check_Virtual_Prefix @Subscriber_ID,@IsVirtual output
	
	if @IsVirtual=1
	begin
		select @Notify_By_MWI=0
	end
	if @Password is null
	begin
		select @Password=@temp_Password
	end
	
	select @CompanyType =CompanyType from DBParameter
   	
  	insert into Account
  	select  @Reg_System_ID,
  	 	@Subscriber_ID,
  	 	@Folder_ID,
  	 	@Password,
  	 	Language,
  	 	Sys_Greeting,
  	 	Personal_Greeting,
  	 	Status,
  	 	New_Mail_Notify,
  	 	Notify_E_Mail,
  	 	Notify_Voice,
  	 	Notify_Fax,
  	 	Notify_By_Phone,
  	 	Notify_By_Mobile,
  	 	Notify_By_Pager,
  	 	Notify_By_SM,
  	 	@Notify_By_MWI,
  	 	Notify_By_EM,
  	 	Notify_By_VM_To_EM,
  	 	Notify_By_FAX_To_EM,
  	 	null,
  	 	null,
  	 	case 
  	 		when @CompanyType = '1' then @Subscriber_ID
  	 		else null
  	 	end,
  	 	case 
  	 		when @CompanyType = '2' then @Subscriber_ID
  	 		else null
  	 	end,
  	 	case 
  	 		when @CompanyType = '3' then @Subscriber_ID
  	 		else null
  	 	end,
  	 	null,
  	 	null,
  	 	null,
  	 	null,
  	 	0,
  	 	0,
  	 	0,
  	 	0,
  	 	0,
  	 	@present_datetime,
  	 	@FileServer,
  	 	@FileServer+@MBDir,
  	 	@DBServer,
  	 	0,
  	 	@Password,
  	 	Voice_Signature,
  	 	Identify_Password,
  	 	Identify_LinkListen,
  	 	Notify_Only_Urgent,
  	 	0
   	from AccountTemplate
   	
   	insert into Account_Internal
   	values  (@Reg_System_ID,@Subscriber_ID,@Folder_ID,@FileServer,@FileServer+@MBDir,0,0)
  	
  	exec ins_ServiceClass @Reg_System_ID,@Subscriber_ID,@Profile_Combine
  	
  	insert into Notify_Schedule
  	select @Reg_System_ID,
  		Serial_No,
  		Notify_Day,
  		Notify_Start,
  		Notify_End
  	from Notify_Schedule_Template	
  	
  	insert into Subscriber_Info (Reg_System_ID,Applied_Date,Query_Allow)
  	values(@Reg_System_ID,@present_datetime,@Query_Allow)
  	  	
  	  	
  	if @@error !=0
  	 begin
  		select @result=2222
  		select 'restult'=@result
  		return 2222
  	 end
  	
  	
       
       select 'Reg_System_ID'=@Reg_System_ID,'FileServer'=@FileServer,'MBDir'=@FileServer+@MBDir,'result'=@result
 	  
  	  
end
return
