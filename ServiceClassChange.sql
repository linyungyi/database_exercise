 create proc ServiceClassChange
(@Operator varchar(20),
 @Subscriber_ID varchar(20),
 @Profile_Combine varchar(32)
 )
as
begin
	declare @result int	
	
	select @result=0
	if @Profile_Combine='PW'
	begin
		exec InsEventLog @Operator,10,4,@Subscriber_ID,'00','Reset Password'

		update Account
		set VPU_Password='0000'
		where Subscriber_ID=@Subscriber_ID
		select 'result'=@result
		return		
	end
	
	exec @result = upd_ServiceClass @Operator,@Subscriber_ID,@Profile_Combine
	
	if @result=0
	begin
		select Reg_System_ID
		into #temp_Account
		from Account_Internal
		where Subscriber_ID=@Subscriber_ID
		
		update ServiceClass 
		set a.Profile_Combine=@Profile_Combine 
		from ServiceClass a,#temp_Account b
		where a.Reg_System_ID=b.Reg_System_ID
		/*
		if @Profile_Combine='3' /*UT*/
		begin
			update Distribution_Group
			set Group_Name='老師聯絡清單',
			    VMS_List_ID='01'
			from Distribution_Group a,#temp_Account b
			where a.Reg_System_ID=b.Reg_System_ID
			and a.VMS_List_ID='00'
		end
		*/
	end
	select 'result'=@result
	
	
end
return
