 create proc AccountCount
as
begin
	declare @Virtual_Account int,
		@Virtual_SubAccount int,
		@Normal_Account int,
		@Normal_SubAccount int,
		@Teacher_Account int,
		@Teacher_count int,
		@DBServer varchar(20)
	
	select @Virtual_Account = 0
	select @Virtual_SubAccount = 0
	select @Normal_Account = 0
	select @Normal_SubAccount = 0
	select @Teacher_Account = 0
	
	select @DBServer=DBServer
	from LocalDBServer
	
	select @Teacher_count=count(*)
	from NoVM_Prefix
	
	if @Teacher_count > 0
	begin
		select @Teacher_Account=count(a.Reg_System_ID)
		from Account_Internal a,NoVM_Prefix b
		where a.Subscriber_ID like b.Prefix +'%'
		and a.Folder_ID = '00'
		select @Virtual_Account=count(a.Reg_System_ID)-@Teacher_Account
		from Account_Internal a,Virtual_Prefix b
		where  a.Subscriber_ID like b.Prefix +'%' 
		and a.Folder_ID = '00'
	
		select @Virtual_SubAccount=count(a.Reg_System_ID)
		from Account_Internal a,Virtual_Prefix b
		where  a.Subscriber_ID like b.Prefix +'%'
		and a.Folder_ID != '00'
	end
	else
	begin
		select @Virtual_Account=count(a.Reg_System_ID)
		from Account_Internal a,Virtual_Prefix b
		where  a.Subscriber_ID like b.Prefix +'%' 
		and a.Folder_ID = '00'
	
		select @Virtual_SubAccount=count(a.Reg_System_ID)
		from Account_Internal a,Virtual_Prefix b
		where  a.Subscriber_ID like b.Prefix +'%'
		and a.Folder_ID != '00'
	
	end
	
	select @Normal_Account=count(Reg_System_ID)
	from Account 
	where DBServer=@DBServer
	and Folder_ID = '00'
		
	select @Normal_SubAccount=count(Reg_System_ID)
	from Account
	where DBServer=@DBServer 
	and  Folder_ID!= '00'
	
	
	select @Normal_Account=@Normal_Account-@Virtual_Account-@Teacher_Account
	select @Normal_SubAccount=@Normal_SubAccount-@Virtual_SubAccount
	
	select 'Virtual_Account'=@Virtual_Account,
		'Virtual_SubAccount'=@Virtual_SubAccount,
		'Normal_Account'=@Normal_Account,
		'Normal_SubAccount'=@Normal_SubAccount,
		'Teacher_Account'=@Teacher_Account
	
end
return
