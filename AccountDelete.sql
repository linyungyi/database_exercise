 /*
*****************************************************************
* Parameter Description 					*
*---------------------------------------------------------------*
* @Operator		:Operator ID				*
*****************************************************************
*/
create proc AccountDelete
(@Operator varchar(20),
 @Subscriber_ID varchar(20),
 @Folder_ID varchar(2)
 )
as
begin
	declare @present_datetime datetime,
		@result int,
		@APServer varchar(20),
		@DBServer varchar(20),
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
/*	    select @sql="AccountDelete '"+@Operator+"','"+@Subscriber_ID+"','"+@Folder_ID+"'"
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
	end
	select @result=0
	select @present_datetime=getdate()
	
	if @Folder_ID='00'
	begin
	
		select Reg_System_ID,FileServer,MBDir
		into #temp_Account
		from Account_Internal
		where Subscriber_ID=@Subscriber_ID
	
		if @@rowcount=0
		begin
			drop table #temp_Account
			select @result=1
			select 'result'=@result
			return @result
		end
	
		exec InsEventLog @Operator,10,2,@Subscriber_ID,@Folder_ID,'delete all Folder'
		
		update Account
		set Status=2
		from Account a, #temp_Account b
		where a.Reg_System_ID=b.Reg_System_ID
		
		delete NotifyQueue
		from NotifyQueue a,#temp_Account b
		where a.Reg_System_ID=b.Reg_System_ID
	
		delete Mail
		from Mail a,#temp_Account b
		where a.Reg_System_ID=b.Reg_System_ID
	
		delete SubscriberStatList
		from SubscriberStatList 
		where Subscriber_ID=@Subscriber_ID
		
		delete SubscriberStatData
		from SubscriberStatData a,#temp_Account b
		where a.Reg_System_ID=b.Reg_System_ID
		
		update FileServer
		set  a.MBcount=a.MBcount-1
		from FileServer a,#temp_Account b
		where a.Name=b.FileServer
		
		update PartFileServer
		set MBcount=MBcount-1
		where @Subscriber_ID like 'AreaCode'+'%'
		
		
		select FileServer,MBDir,'result'=@result
		from #temp_Account
		
		drop table #temp_Account
	end
	else 
	begin
		select Reg_System_ID,FileServer,MBDir
		into #temp_subAccount
		from Account_Internal
		where Subscriber_ID=@Subscriber_ID
		and Folder_ID=@Folder_ID
	
		if @@rowcount=0
		begin
			drop table #temp_subAccount
			select @result=1
			select 'result'=@result
			return @result
		end
	
		exec InsEventLog @Operator,10,2,@Subscriber_ID,@Folder_ID,'delete a Folder'
	
		update Account
		set Status=2
		from Account a, #temp_subAccount b
		where a.Reg_System_ID=b.Reg_System_ID
		
		delete NotifyQueue
		from NotifyQueue a,#temp_subAccount b
		where a.Reg_System_ID=b.Reg_System_ID
	
		delete Mail
		from Mail a,#temp_subAccount b
		where a.Reg_System_ID=b.Reg_System_ID
	
		delete SubscriberStatList
		from SubscriberStatList 
		where Subscriber_ID=@Subscriber_ID
		
		delete SubscriberStatData
		from SubscriberStatData a,#temp_subAccount b
		where a.Reg_System_ID=b.Reg_System_ID
		
		update FileServer
		set  a.MBcount=a.MBcount-1
		from FileServer a,#temp_subAccount b
		where a.Name=b.FileServer
		
		update PartFileServer
		set MBcount=MBcount-1
		where @Subscriber_ID like 'AreaCode'+'%'

	
		select FileServer,MBDir,'result'=@result
		from #temp_subAccount
		
		drop table #temp_subAccount
	end
end
return
