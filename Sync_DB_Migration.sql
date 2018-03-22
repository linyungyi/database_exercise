 create proc Sync_DB_Migration
(@Before_Prefix varchar(10),
 @After_Prefix varchar(10),
 @Type tinyint
 )
as
begin
	declare @Before_Prefix_Length int,
		@item int,
		@result int,
		@Phone_Length tinyint,
		@NotMigration_Prefix varchar(5)
	
	select @result=0
	
	select @NotMigration_Prefix=substring(@Before_Prefix,1,2)+'412'
	
	select @Phone_Length=Phone_Length from DBParameter
	
	delete Migration_Item_Internal
	where Status in (34,35,36)
	if @Type=1 /* Migration  */
	begin
	    	select @item=count(@Before_Prefix)
		from Migration_Item_Internal
		where Before_Prefix=@Before_Prefix
		
		if @item =0
		begin
	
			insert into Migration_Item_Internal
			values (@Before_Prefix,@After_Prefix,30)
			
			select @result=1
		end
		else
		begin
			update Migration_Item_Internal
			set Status=32
			where Before_Prefix=@Before_Prefix
			and After_Prefix=@After_Prefix
			
			select @result=0
		end
			
	end
	else if @Type=2 /* RollBack */
	begin
	    	select @Phone_Length=@Phone_Length+1
		select @item=count(@Before_Prefix)
		from Migration_Item_Internal
		where Before_Prefix=@After_Prefix
		and After_Prefix=@Before_Prefix
		
		if @item =0
		begin
	
			insert into Migration_Item_Internal
			values (@Before_Prefix,@After_Prefix,33)
			
			select @result=0
		end
		else
		begin
			delete Migration_Item_Internal
			where Before_Prefix=@After_Prefix
			and After_Prefix=@Before_Prefix
			
			insert into Migration_Item_Internal
			values (@Before_Prefix,@After_Prefix,35)
			select @result=1
		end
			
	end
	
	if @result=1
	begin
       		select @Before_Prefix_Length=char_length(@Before_Prefix)
       	
		begin tran Migration
		
			update Communication_Set
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
			update Voice_Folder
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
		
			update Mobile_Notify
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
		
			update Reg_Subscriber
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
		
			update Mobile_Time
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
		
			update Subscriber_Main
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
			update SubscriberStatList
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
			update Account
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
			update Account
			set Phone_Number=@After_Prefix+right(Phone_Number,char_length(Phone_Number)-@Before_Prefix_Length)
			where Phone_Number like @Before_Prefix +'%'
			and Phone_Number not like @NotMigration_Prefix + '%'
			and char_length(Phone_Number)=@Phone_Length
			
			update Account_Internal
			set Subscriber_ID=@After_Prefix+right(Subscriber_ID,char_length(Subscriber_ID)-@Before_Prefix_Length)
			where Subscriber_ID like @Before_Prefix +'%'
			and Subscriber_ID not like @NotMigration_Prefix + '%'
			and char_length(Subscriber_ID)=@Phone_Length
			update Mail
			set CPA=@After_Prefix+right(CPA,char_length(CPA)-@Before_Prefix_Length)
			where CPA like @Before_Prefix +'%'
			and CPA not like @NotMigration_Prefix + '%'
			and char_length(CPA)=@Phone_Length
			update NotifyQueue
			set Notify_Address=@After_Prefix+right(Notify_Address,char_length(Notify_Address)-@Before_Prefix_Length)			
			where Notify_Address like @Before_Prefix +'%'
			and Notify_Address not like @NotMigration_Prefix + '%'
			and char_length(Notify_Address)=@Phone_Length
			
			update Distribution_List
			set FullName=@After_Prefix+right(FullName,char_length(FullName)-@Before_Prefix_Length)
			where FullName=VMS_Number 
			and FullName like @Before_Prefix +'%'
			and FullName not like @NotMigration_Prefix + '%'
			and char_length(FullName)=@Phone_Length
			
			
			update Distribution_List
			set VMS_Number=@After_Prefix+right(VMS_Number,char_length(VMS_Number)-@Before_Prefix_Length)
			where VMS_Number like @Before_Prefix +'%'
			and VMS_Number not like @NotMigration_Prefix + '%'
			and char_length(VMS_Number)=@Phone_Length
		
			if @Type=1
			begin
				update Migration_Item_Internal
				set Status=31
				where Before_Prefix=@Before_Prefix
				and After_Prefix=@After_Prefix
			end
			else
			begin
				update Migration_Item_Internal
				set Status=34
				where Before_Prefix=@Before_Prefix
				and After_Prefix=@After_Prefix
			end
		
		commit tran
		
		if @@transtate !=1		
		begin
			update Migration_Item_Internal
			set Status=36
			where Before_Prefix=@Before_Prefix
			and After_Prefix=@After_Prefix		
		end
	end
	
	
end
return
