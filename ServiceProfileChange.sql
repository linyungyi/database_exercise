 create proc ServiceProfileChange
as
begin
	declare @Subscriber_ID varchar(20),
		@Profile_Combine varchar(32),
		@str_ProfileID varchar(32)
	
	declare @CountItem tinyint,
		@Profile_ID char(1),
		@CurrChar char(1),
		@Max_Allow_VM bit,
		@Max_eachVM_Time int,
		@Max_VM_Number int,
		@Max_VM_Storeday int,
		@Max_VM_Reply bit,
		@Max_VM_Forward bit,
		@Max_VM_to_EM bit,
		@Max_Allow_FAX bit,
		@Max_FAX_Length int,
		@Max_FAX_Number int,
		@Max_FAX_to_EM bit,
		@Max_Allow_email bit,
		@Max_EM_text2speech bit,
		@Max_EM_querystatus bit,
		@Max_EM_notify bit,
		@Max_SM_notify bit,
		@Max_PSTN_notify bit,
		@Max_MWI_notify bit,
		@Max_Pager_notify bit,
		@Max_Mobile_notify bit,
		@Max_Priority tinyint,
		@Max_Emergency_Member smallint,
		@Max_Distribute_List smallint,
		@Max_SubAccount tinyint,
		@Max_Profile_ID tinyint
		
	
	select Profile_ID
	into #temp_ProfileID
	from ServiceProfile
	where IsChanged=1
	
	if @@rowcount=0
	begin
		drop table #temp_ProfileID
		return
	end
	
	select distinct Profile_Combine
	into #temp_Subscriber_ID 
	from ServiceClass a,#temp_ProfileID b
	where b.Profile_ID like '['+a.Profile_Combine+']'
	
	declare ServiceClass_cur cursor for
	select *
	from #temp_Subscriber_ID
	
        open ServiceClass_cur
        fetch ServiceClass_cur into @Profile_Combine
        
        while @@sqlstatus=0
        begin
        
	select 	@Max_VM_Reply =convert(bit,isnull(Max(convert(tinyint,VM_Reply)),0)),
		@Max_VM_Forward=convert(bit,isnull(Max(convert(tinyint,VM_Forward)),0)),
              	@Max_VM_to_EM=convert(bit,isnull(Max(convert(tinyint,VM_to_EM)),0)),
              	@Max_Allow_FAX=convert(bit,isnull(Max(convert(tinyint,Allow_FAX)),0)),              			       
              	@Max_FAX_to_EM=convert(bit,isnull(Max(convert(tinyint,FAX_to_EM)),0)),
              	@Max_Allow_email=convert(bit,isnull(Max(convert(tinyint,Allow_email)),0)),
              	@Max_EM_text2speech=convert(bit,isnull(Max(convert(tinyint,EM_text2speech)),0)),
              	@Max_EM_querystatus=convert(bit,isnull(Max(convert(tinyint,EM_querystatus)),0)),
              	@Max_EM_notify=convert(bit,isnull(Max(convert(tinyint,EM_notify)),0)),
              	@Max_SM_notify=convert(bit,isnull(Max(convert(tinyint,SM_notify)),0)),
              	@Max_PSTN_notify=convert(bit,isnull(Max(convert(tinyint,PSTN_notify)),0)),
               	@Max_Pager_notify=convert(bit,isnull(Max(convert(tinyint,Pager_notify)),0)),
              	@Max_Mobile_notify=convert(bit,isnull(Max(convert(tinyint,Mobile_notify)),0)),
		@Max_eachVM_Time=isnull(Max(Max_eachVM_Time),0),
		@Max_VM_Number=isnull(Max(Max_VM_Number),0),
		@Max_VM_Storeday=isnull(Max(Max_VM_Storeday),0),
		@Max_FAX_Length=isnull(Max(Max_FAX_Length),0),
		@Max_FAX_Number=isnull(Max(Max_FAX_Number),0),
		@Max_Priority=isnull(Max(Priority),0),
		@Max_Emergency_Member=isnull(Max(Max_Emergency_Member),0),
		@Max_Distribute_List=isnull(Max(Max_Distribute_List),0),
		@Max_SubAccount=isnull(Max(Max_SubAccount),0)
		from ServiceProfile
		where Profile_ID like '['+@Profile_Combine+']'
		
	update ServiceClass 
	set     Max_eachVM_Time=@Max_eachVM_Time,
		Max_VM_Number=@Max_VM_Number,
		Max_VM_Storeday=@Max_VM_Storeday,
		VM_Reply=@Max_VM_Reply, 
		VM_Forward=@Max_VM_Forward ,
		VM_to_EM=@Max_VM_to_EM ,
		Allow_FAX=@Max_Allow_FAX ,
		Max_FAX_Length=@Max_FAX_Length,
		Max_FAX_Number=@Max_FAX_Number,
		FAX_to_EM=@Max_FAX_to_EM ,
		Allow_email=@Max_Allow_email ,
		EM_text2speech=@Max_EM_text2speech ,
		EM_querystatus=@Max_EM_querystatus ,
		EM_notify=@Max_EM_notify ,
		SM_notify=@Max_SM_notify ,
		PSTN_notify=@Max_PSTN_notify ,		
		Pager_notify=@Max_Pager_notify ,
		Mobile_notify=@Max_Mobile_notify ,
		Priority=@Max_Priority,
		Max_Emergency_Member=@Max_Emergency_Member,
		Max_Distribute_List=@Max_Distribute_List,
		Max_SubAccount=@Max_SubAccount
	where Profile_Combine=@Profile_Combine	
         	fetch ServiceClass_cur into @Profile_Combine
       	end
	close ServiceClass_cur
        deallocate cursor ServiceClass_cur
        
        update ServiceProfile set IsChanged=0
        
        drop table #temp_Subscriber_ID
        drop table #temp_ProfileID
        
	
end
return
