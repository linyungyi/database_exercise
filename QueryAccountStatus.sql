 /*
*****************************************************************
* Parameter Description 					*
*---------------------------------------------------------------*
* @Query_Type 	:1->Query Account is Create			*
*		:2->Query Account is Apply			*
*****************************************************************
*/
create proc QueryAccountStatus
(@Query_Type tinyint,
 @Subscriber_ID varchar(20)
 )
as
begin
	declare @DBServer varchar(20),
		@APServer varchar(20),
		@IsLocal char(1),
		@result int,
		@count_item int,
		@count_item1 int,
		@Status char(2)
		
	exec check_DBServer @Subscriber_ID output,@DBServer output,@IsLocal output,@APServer output,@result output
	if @result !=0
	begin
		select 'result'=@result
		return @result
	end
	
	if @IsLocal ='0'
	begin
  	    select @result=4		/* just Allow Local*/
	    select 'result'=@result
	    return
	    return
	end
	
	if @Query_Type=1
	begin
		select @count_item=count(Reg_System_ID)
		from Account_Internal
		where Subscriber_ID=@Subscriber_ID
		
		if @count_item >0
		begin
			select @result=0
			select 'result'=@result
			return @result
		end
		
		select @count_item1=count(SequenceId)
		from AccountModifyRequest
		where NewPhoneNumber=@Subscriber_ID
		
		if @count_item1 >0
		begin
		
			select @Status=Status
			from AccountModifyRequest
			where NewPhoneNumber=@Subscriber_ID
			having ApplyDate=max(ApplyDate)
			
			select @result=7
			select 'result'=@result,'Status'=@Status
			return @result
		end
		
		if (@count_item=0) and (@count_item1=0)
		begin
			select @result=8
			select 'result'=@result
			return @result
		end
		
		
	end
	
	if @Query_Type=2
	begin
		select @count_item=count(Reg_System_ID)
		from Account_Internal
		where Subscriber_ID=@Subscriber_ID
		
		if @count_item >0
		begin
			select @count_item=count(SequenceId)
			from AccountModifyRequest
			where OldPhoneNumber=@Subscriber_ID
		
			if @count_item >0
			begin
			
				select @Status=Status
				from AccountModifyRequest
				where OldPhoneNumber=@Subscriber_ID
				having ApplyDate=max(ApplyDate)
			
				select @result=7
				select 'result'=@result,'Status'=@Status
				return @result
			end
			else
			begin
				select @result=8
				select 'result'=@result
				return @result
			end
			
		end
		else
		begin
				select @result=0
				select 'result'=@result
				return @result
		end
		
	end
end
return
