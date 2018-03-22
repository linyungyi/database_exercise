/*  
** Confidential property of Sybase, Inc.
** (c) Copyright Sybase, Inc. 1998.
** All rights reserved
*/

/*
** sql_server.sql
**
**
** Tables created:
**
**      Name                    Default Location
**      ----------------------- ----------------
**      spt_jdbc_table_types    master
**      spt_mda                 master
**      spt_jtext               master
**      spt_jdbc_conversion     master
**      spt_jdatatype_info      sybsystemprocs
**
**
** Stored procedures created:
**
**      Name                          Default Location
**      ----------------------------- ----------------
**      sp_mda                        sybsystemprocs
**      sp_jdbc_datatype_info         sybsystemprocs
**      sp_jdbc_columns               sybsystemprocs
**      sp_jdbc_tables                sybsystemprocs
**      jdbc_function_escapes         sybsystemprocs
**      sp_jdbc_convert_datatype      sybsystemprocs
**      sp_jdbc_function_escapes      sybsystemprocs
**      sp_jdbc_fkeys                 sybsystemprocs
**      sp_jdbc_exportkey             sybsystemprocs
**      sp_jdbc_importkey             sybsystemprocs
**      sp_jdbc_getcrossreferences    sybsystemprocs
**      sp_jdbc_getschemas            sybsystemprocs
**      sp_jdbc_getcolumnprivileges   sybsystemprocs
**      sp_jdbc_gettableprivileges    sybsystemprocs
**      sp_jdbc_getcatalogs           sybsystemprocs
**      sp_jdbc_primarykey            sybsystemprocs
**      sp_sql_type_name              sybsystemprocs
**      sp_jdbc_getbestrowidentifier  sybsystemprocs
**      sp_jdbc_getisolationlevels    sybsystemprocs
**      sp_jdbc_getindexinfo          sybsystemprocs
**      sp_jdbc_stored_procedures     sybsystemprocs
**      sp_jdbc_getprocedurecolumns   sybsystemprocs
**      sp_jdbc_getversioncolumns     sybsystemprocs
**      sp_jdbc_escapeliteralforlike  sybsystemprocs
**      sp_default_charset            sybsystemprocs
**      sp_jdbc_getudts               sybsystemprocs
**
**
** File Sections for use with the jConnect IsqlApp Sample:
**
**      Section Name  Description
**      ------------- ---------------------------------------
**      CLEANUP       Removes all of the tables/sprocs
**                    created by this script.
**
*/

set quoted_identifier on
go

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

sp_configure 'allow updates', 1
go
/** SECTION END: CLEANUP **/


/*
**   spt_jdatatype_info
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if (exists (select * from sysobjects
where name = 'spt_jdatatype_info' and type = 'U'))
    drop table spt_jdatatype_info
go
/** SECTION END: CLEANUP **/

create table spt_jdatatype_info  
(
ss_dtype    tinyint not null,  
type_name          varchar(32)  not null,  
data_type          smallint     not null,  
data_precision     int          null,  
numeric_scale      smallint     null,  
numeric_radix      smallint     null,  
length             int          null,  
literal_prefix     varchar(32)  null,  
literal_suffix     varchar(32)  null,  
create_params      varchar(32)  null,  
nullable           smallint     not null,  
case_sensitive     smallint     not null,  
searchable         smallint     not null,  
unsigned_attribute smallint     null,  
money              smallint     not null,  
auto_increment     smallint     null,  
local_type_name    varchar(128) not null,  
aux                int          null,
maximum_scale    smallint null,
minimum_scale    smallint null,
sql_data_type    smallint null,
sql_datetime_sub   smallint null,
num_prec_radix    smallint null,
interval_precision smallint null
)
go

grant select on spt_jdatatype_info to public
go

/*
** There is a complicated set of SQL used to deal with
** the SQL Server Null data types (MONEYn, INTn, etc.)
** ISNULL is the only conditional SQL Server function that can be used
** to differentiate between these types depending on size.
**
** The aux column in the above table is used to differentiate
** the null data types from the non-null types.
**
** The aux column contains NULL for the null data types and 0
** for the non-null data types.
**
** The following SQL returns the contents of the aux column (0)
** for the non-null data types and returns a variable non-zero
** value for the null data types.
**
** ' I   I I FFMMDD'
** ' 1   2 4 484848'
** isnull(d.aux, ascii(substring('666AAA@@@CB??GG',  
** 2*(d.ss_dtype%35+1)+2-8/c.length, 1))-60)
**
** The '2*(d.ss_dtype%35+1)+2-8/c.length' selects a specific character of
** the substring mask depending on the null data type and its size, i.e.
** null MONEY4 or null MONEY8.  The character selected is then converted
** to its binary value and an appropriate bias (i.e. 60) is subtracted to
** return the correct non-zero value. This value may be used as a
** constant, i.e. ODBC data type, precision, scale, etc., or used as an
** index with a substring to pick out a character string, i.e. type name.
**
** The comments above the substring mask denote which character is
** selected for each null data type, i.e. In (INTn), Fn (FLOATn),  
** Mn (MONEYn) and Dn (DATETIMn).
*/


declare @case smallint

select @case = 0
select @case = 1 where 'a' != 'A'

/* Local Binary */
insert into spt_jdatatype_info values
/* ss_type, name, data_type, prec, scale, rdx, len, prf, suf,  
** cp, nul, case, srch, unsigned, money, auto, local, aux  
*/
(45, 'binary', -2, null, null, null, null, '0x', null,  
 'length', 1, 0, 2, null, 0, null, 'binary', 0,
 null, null, null, null, null, null)

/* Local Bit */
insert into spt_jdatatype_info values
(50, 'bit', -7, 1, 0, 2, null, null, null,  
 null, 0, 0, 2, null, 0, null, 'bit', 0,
 null, null, null, null, null, null)

/* Local Char */
insert into spt_jdatatype_info values
(47, 'char', 1, null, null, null, null, '''', '''',  
'length', 1, @case, 3, null, 0, null, 'char', 0,
 null, null, null, null, null, null)

/* Local Datetime */
insert into spt_jdatatype_info values
(61, 'datetime', 93, 23, 3, 10, 16, '''', '''',  
 null, 1, 0, 3, null, 0, null, 'datetime', 0,
 null, null, 93, null, null, null)

/* Local Smalldatetime */
insert into spt_jdatatype_info values
(58, 'smalldatetime', 93, 16, 0, 10, 16, '''', '''',  
null, 1, 0, 3, null, 0, null, 'smalldatetime', 0,
 null, null, 93, null, null, null)

/* Local Datetimn  sql server type is 'datetimn' */
insert into spt_jdatatype_info values
(111, 'smalldatetime', 93, 0, 0, 10, 0, '''', '''',  
null, 1, 0, 3, null, 0, null, 'datetime', null,
 null, null, 93, null, null, null)

/* Decimal sql server type is 'decimal' */
insert into spt_jdatatype_info values
(55, 'decimal', 3, 38, 0, 10, 0, null, null,
'precision,scale', 1, 0, 2, 0, 0, 0, 'decimal', 0,
 38, 0, null, null, null, null)

/* Numeric sql server type is 'numeric' */
insert into spt_jdatatype_info values
(63, 'numeric', 2, 38, 0, 10, 0, null, null,
'precision,scale', 1, 0, 2, 0, 0, 0, 'numeric', 0,
 38, 0, null, null, null, null)

/* Local RealFloat   sql server type is 'floatn' */
insert into spt_jdatatype_info values
(109, 'float        real', 1111, 0, null, 10, 0, null, null,  
null, 1, 0, 2, 0, 0, 0, 'real      float', null,
 null, null, null, null, 10, null)

/* Local Real */
insert into spt_jdatatype_info values
(59, 'real', 7, 7, null, 10, null, null, null,
null, 1, 0, 2, 0, 0, 0, 'real', 0,
 null, null, null, null, 10, null)

/* Local Double */
insert into spt_jdatatype_info values
(62, 'double precision', 8, 15, null, 10, null, null, null,
null, 1, 0, 2, 0, 0, 0, 'double precision', 0,
 null, null, null, null, 10, null)

/* Local Smallmoney */
insert into spt_jdatatype_info values
(122, 'smallmoney', 3, 10, 4, 10, null, '$', null,  
null, 1, 0, 2, 0, 1, 0, 'smallmoney', 0,
 null, null, null, null, null, null)

/* Local Int */
insert into spt_jdatatype_info values
(56, 'int', 4, 10, 0, 10, null, null, null,  
null, 1, 0, 2, 0, 0, 0, 'int', 0,
 null, null, null, null, null, null)

/* Local Intn  sql server type is 'intn' */
insert into spt_jdatatype_info values
(38, 'smallint     tinyint', 1111, 0, 0, 10, 0, null, null,  
null, 1, 0, 2, 0, 0, 0, 'tinyint   smallint', null,
 null, null, null, null, null, null)

/* Local Money */
insert into spt_jdatatype_info values
(60, 'money', 3, 19, 4, 10, null, '$', null,  
null, 1, 0, 2, 0, 1, 0, 'money', 0,
 null, null, null, null, null, null)

/* Local Moneyn  sql server type is 'moneyn'*/  
insert into spt_jdatatype_info values
(110, 'moneyn', 3, 0, 4, 10, 0, '$', null,  
null, 1, 0, 2, 0, 1, 0, 'moneyn', null,
 null, null, null, null, null, null)

/* Local Smallint */
insert into spt_jdatatype_info values
(52, 'smallint', 5, 5, 0, 10, null, null, null,  
null, 1, 0, 2, 0, 0, 0, 'smallint', 0,
 null, null, null, null, null, null)

/* Local Text */
insert into spt_jdatatype_info values
(35, 'text', -1, 2147483647, null, null, 2147483647, '''', '''',  
null, 1, @case, 1, null, 0, null, 'text', 0,
 null, null, null, null, null, null)

/* Local Varbinary */
insert into spt_jdatatype_info values
(37, 'varbinary', -3, null, null, null, null, '0x', null,  
'max length', 1, 0, 2, null, 0, null, 'varbinary', 0,
 null, null, null, null, null, null)

/* Local Tinyint */
insert into spt_jdatatype_info values
(48, 'tinyint', -6, 3, 0, 10, null, null, null,  
null, 1, 0, 2, 1, 0, 0, 'tinyint', 0,
 null, null, null, null, null, null)

/* Local Varchar */
insert into spt_jdatatype_info values
(39, 'varchar', 12, null, null, null, null, '''', '''',  
'max length', 1, @case, 3, null, 0, null, 'varchar', 0,
 null, null, null, null, null, null)

/* Local Image */
insert into spt_jdatatype_info values
(34, 'image', -4, 2147483647, null, null, 2147483647, '0x', null,  
null, 1, 0, 1, null, 0, null, 'image', 0,
 null, null, null, null, null, null)
go

dump tran master with truncate_only
go

/*
**   End of spt_jdatatype_info
*/



/*
**  sp_jdbc_escapeliteralforlike
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select *
from sysobjects
where name = 'sp_jdbc_escapeliteralforlike')
begin
drop procedure sp_jdbc_escapeliteralforlike
end
go
/** SECTION END: CLEANUP **/


/*
** This is a utility procedure which takes an input string
** and places the escape character '\' before any symbol
** which needs to be a literal when used in a LIKE clause.
**
*/
create proc sp_jdbc_escapeliteralforlike @pString varchar(255) output
as
    declare @newString    varchar(255)
    declare @validEscapes varchar(255)
    declare @escapeChar   varchar(10)
    declare @pIndex       int
    declare @pLength      int
    declare @curChar      char(1)
    declare @escapeIndex  int
    declare @escapeLength int
    declare @boolEscapeIt int

    select @pLength = char_length(@pString)
    if (@pString is null) or (@pLength = 0)
    begin
        return
    end

    /*
    ** we will use the backslash as our escape  
    ** character
    */
    select @escapeChar = '\'
     
    /*  
    ** valid escape characters
    */
    select @validEscapes = '%_\[]'
    select @escapeLength = char_length(@validEscapes)

    /* start at the beginning of the string */
    select @pIndex = 1
    select @newString = ''

    while(@pIndex <= @pLength)
    begin
        /*
        ** get the next character of the string
        */
        select @curChar = substring(@pString, @pIndex, 1)
         
        /*
        ** loop through all of the escape characters and
        ** see if the character needs to be escaped
        */
        select @escapeIndex = 1
        select @boolEscapeIt = 0
        while(@escapeIndex <= @escapeLength)
        begin
            /* see if this is a match */
            if (substring(@validEscapes, @escapeIndex, 1) =  
                @curChar)
            begin
                select @boolEscapeIt = 1
                break
            end
            /* move on to the next escape character */
            select @escapeIndex = @escapeIndex + 1
        end
         
        /* build the string */
        if (@boolEscapeIt = 1)
        begin
            select @newString = @newString + @escapeChar + @curChar
        end
        else
        begin
            select @newString = @newString + @curChar
        end

        /* go on to the next character in our source string */
        select @pIndex = @pIndex + 1
    end
         
    /* return to new string to the caller */
    select @pString = ltrim(rtrim(@newString))
    return 0
go

exec sp_procxmode 'sp_jdbc_escapeliteralforlike', 'anymode'
go
grant execute on sp_jdbc_escapeliteralforlike to public
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_escapeliteralforlike
*/  




/*
**  sp_jdbc_datatype_info
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

/* create a 1-off version of sp_datatype_info that has the additional
** 2 columns required for ODBC 2.0 and 3 more columns required by
** JDBC (from ODBC 3.0?).
*/

if exists (select * from sysobjects where name = 'sp_jdbc_datatype_info')
    begin
drop procedure sp_jdbc_datatype_info
    end
go
/** SECTION END: CLEANUP **/

create procedure sp_jdbc_datatype_info
@data_type int = 0 /* Provide datatype_info for type # */
as

if @@trancount = 0
begin
set chained off
end

set transaction isolation level 1

if (select @data_type) = 0
select /* Real SQL Server data types */
t.name as TYPE_NAME,
d.data_type as DATA_TYPE,
isnull(d.data_precision,  
    convert(int,t.length))
    as 'PRECISION',
d.literal_prefix as LITERAL_PREFIX,
d.literal_suffix as LITERAL_SUFFIX,
e.create_params as CREATE_PARAMS,
d.nullable as NULLABLE,
d.case_sensitive as CASE_SENSITIVE,
d.searchable as SEARCHABLE,
d.unsigned_attribute as UNSIGNED_ATTRIBUTE,
d.money as FIXED_PREC_SCALE,
d.auto_increment as AUTO_INCREMENT,
d.local_type_name as LOCAL_TYPE_NAME,
d.minimum_scale as MINIMUM_SCALE,
d.maximum_scale as MAXIMUM_SCALE,
d.sql_data_type as SQL_DATA_TYPE,
d.sql_datetime_sub as SQL_DATETIME_SUB,
d.num_prec_radix as NUM_PREC_RADIX,
d.interval_precision as INTERVAL_PRECISION
from
            sybsystemprocs.dbo.spt_jdatatype_info d,  
sybsystemprocs.dbo.spt_datatype_info_ext e,
            systypes t
where
d.ss_dtype = t.type
and t.usertype *= e.user_type
    /* restrict results to 'real' datatypes */
and t.name not in ('nchar','nvarchar',
   'sysname','timestamp',
   'datetimn','floatn','intn','moneyn')
and t.usertype < 100 /* No user defined types */
UNION
select /* SQL Server user data types */
t.name,
d.data_type,
isnull(d.data_precision,  
    convert(int,t.length))
    as 'PRECISION',
d.literal_prefix,
d.literal_suffix,
e.create_params,
d.nullable,
d.case_sensitive,
d.searchable,
d.unsigned_attribute,
d.money,
d.auto_increment,
t.name,
d.minimum_scale,
d.maximum_scale,
d.sql_data_type,
d.sql_datetime_sub,
d.num_prec_radix,
d.interval_precision
from 
            sybsystemprocs.dbo.spt_jdatatype_info d,
sybsystemprocs.dbo.spt_datatype_info_ext e,
            systypes t
where
d.ss_dtype = t.type
and t.usertype *= e.user_type
    /*  
    ** Restrict to user defined types (value > 100)
    ** and Sybase user defined types (listed)
    */
and (t.name in ('nchar','nvarchar',
    'sysname')
    or t.usertype >= 100)      /* User defined types */
order by d.data_type, t.name
else
select 
t.name as TYPE_NAME,
d.data_type as DATA_TYPE,
isnull(d.data_precision,  
    convert(int,t.length))
    as 'PRECISION',
d.literal_prefix as LITERAL_PREFIX,
d.literal_suffix as LITERAL_SUFFIX,
e.create_params as CREATE_PARAMS,
d.nullable as NULLABLE,
d.case_sensitive as CASE_SENSITIVE,
d.searchable as SEARCHABLE,
d.unsigned_attribute as UNSIGNED_ATTRIBUTE,
d.money as FIXED_PREC_SCALE,
d.auto_increment as AUTO_INCREMENT,
d.local_type_name as LOCAL_TYPE_NAME,
d.sql_data_type as SQL_DATA_TYPE,
d.sql_datetime_sub as SQL_DATETIME_SUB,
d.num_prec_radix as NUM_PREC_RADIX,
d.interval_precision as INTERVAL_PRECISION
from 
            sybsystemprocs.dbo.spt_jdatatype_info d,
sybsystemprocs.dbo.spt_datatype_info_ext e,
            systypes t
where
data_type = @data_type
and d.ss_dtype = t.type
and t.usertype *= e.user_type
    /* restrict results to 'real' datatypes */
and t.name not in ('nchar','nvarchar',
   'sysname','timestamp',
   'datetimn','floatn','intn','moneyn')
and t.usertype < 100 /* No user defined types */
UNION
select
t.name TYPE_NAME,
d.data_type,
isnull(d.data_precision,  
    convert(int,t.length))
    as 'PRECISION',
d.literal_prefix,
d.literal_suffix,
e.create_params,
d.nullable,
d.case_sensitive,
d.searchable,
d.unsigned_attribute,
d.money,
d.auto_increment,
t.name,
d.sql_data_type,
d.sql_datetime_sub,
d.num_prec_radix,
d.interval_precision
from 
            sybsystemprocs.dbo.spt_jdatatype_info d,
sybsystemprocs.dbo.spt_datatype_info_ext e,
            systypes t
where
data_type = @data_type
and d.ss_dtype = t.type
and t.usertype *= e.user_type
and (t.name in ('nchar','nvarchar', 'sysname') or t.usertype >= 100)      
order by t.name
return(0)

go

exec sp_procxmode 'sp_jdbc_datatype_info', 'anymode'
go
grant execute on sp_jdbc_datatype_info to public
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_datatype_info
*/




/*
**  sp_jdbc_columns
*/

use sybsystemprocs  
go

/* create a 1-off version of sp_jdbc_columns that has the additional
** columns required for ODBC 2.0 and more columns required by
** JDBC (from ODBC 3.0?).
*/

/** SECTION BEGIN: CLEANUP **/
if exists (select * from sysobjects where name = 'sp_jdbc_columns')
    begin
drop procedure sp_jdbc_columns
    end
go
/** SECTION END: CLEANUP **/

  

/* This is the version for servers which support UNION */

/* This routine is intended for support of ODBC connectivity.  Under no
** circumstances should changes be made to this routine unless they are
** to fix ODBC related problems.  All other users are at there own risk!
**
** Please be aware that any changes made to this file (or any other ODBC
** support routine) will require Sybase to recertify the SQL server as
** ODBC compliant.  This process is currently being managed internally
** by the 'Interoperability Engineering Technology Solutions Group' here
** within Sybase.
*/

CREATE PROCEDURE sp_jdbc_columns (
    @table_name         varchar(32),
    @table_owner        varchar(32) = null,
    @table_qualifier    varchar(32) = null,
    @column_name        varchar(32) = null )
AS
    declare @msg      varchar(250)
    declare @full_table_name  char(70)
    declare @table_id         int
    declare @char_bin_types   varchar(30)
     
    if @@trancount > 0
    begin
        /*
        ** 17260, 'Can't run %1! from within a transaction.'
        */
        exec sp_getmessage 17260, @msg output
        print @msg, 'sp_jdbc_columns'
        return (1)
    end
    else
    begin
        set chained off
    end

    set transaction isolation level 1
     
    /* character and binary datatypes */
    select @char_bin_types =
        char(47)+char(39)+char(45)+char(37)+char(35)+char(34)

    if @column_name is null select @column_name = '%'
     
    if @table_qualifier is not null
    begin
        if db_name() != @table_qualifier
        begin /*  
            ** If qualifier doesn't match current database: 18039
            ** Table qualifier must be name of current database
            */
            exec sp_getmessage 18039, @msg output
            raiserror 18039 @msg
            return (1)
        end
    end
     
    if @table_name is null
    begin /* If table name not supplied, match all */
        select @table_name = '%'
    end
     
    if @table_owner is null
    begin /* If unqualified table name */
        SELECT @full_table_name = @table_name
        select @table_owner = '%'
    end
    else
    begin /* Qualified table name */
        SELECT @full_table_name = @table_owner + '.' + @table_name
    end
   
    /* Get Object ID */
    SELECT @table_id = object_id(@full_table_name)
     
     
    /* If the table name parameter is valid, get the information */  
    if ((charindex('%',@full_table_name) = 0) and
        (charindex('_',@full_table_name) = 0)  and
        (@table_id != 0))
    begin
       SELECT /* INTn, FLOATn, DATETIMEn and MONEYn types */
            TABLE_CAT = DB_NAME(),
            TABLE_SCHEM = USER_NAME(o.uid),
            TABLE_NAME = o.name,
            COLUMN_NAME = c.name,
            DATA_TYPE = d.data_type+convert(smallint,
                        isnull(d.aux,
                        ascii(substring('666AAA@@@CB??GG',
                        2*(d.ss_dtype%35+1)+2-8/c.length,1))
                        -60)),
            TYPE_NAME = rtrim(substring(d.type_name,
                        1+isnull(d.aux,
                        ascii(substring('III<<<MMMI<<A<A',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-60), 13)),
            COLUMN_SIZE = isnull(convert(int, c.prec),
                      isnull(convert(int, d.data_precision),
                             convert(int, c.length)))
                        +isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                        2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
            BUFFER_LENGTH = isnull(convert(int, c.length),  
                    convert(int,d.length)) +
                       convert(int, isnull(d.aux,
                        ascii(substring('AAA<BB<DDDHJSPP',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-64)),
            DECIMAL_DIGITS = isnull(convert(smallint, c.scale),  
                       convert(smallint, d.numeric_scale)) +
                        convert(smallint, isnull(d.aux,
                        ascii(substring('<<<<<<<<<<<<<<?',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-60)),
            NUM_PREC_RADIX = d.numeric_radix,
            NULLABLE = /* set nullability from status flag */
                convert(smallint, convert(bit, c.status&8)),
            REMARKS = convert(varchar(254),null), /* Remarks are NULL */
            COLUMN_DEF = NULL,
            SQL_DATA_TYPE = isnull(d.sql_data_type,
                      d.data_type+convert(smallint,
                      isnull(d.aux,
                      ascii(substring('666AAA@@@CB??GG',
                      2*(d.ss_dtype%35+1)+2-8/c.length,1))
                      -60))),
            SQL_DATETIME_SUB = NULL,
            /*
            ** if the datatype is of type CHAR or BINARY
            ** then set char_octet_length to the same value
            ** assigned in the "prec" column.
            **
            ** The first part of the logic is:
            **
            **   if(c.type is in (47, 39, 45, 37, 35, 34))
            **       set char_octet_length = prec;
            **   else
            **       set char_octet_length = 0;
            */
            CHAR_OCTET_LENGTH =  
                /*
                ** check if in the list
                ** if so, return a 1 and multiply it by the precision  
                ** if not, return a 0 and multiply it by the precision
                */
                convert(smallint,  
                    substring('0111111',  
                        charindex(convert(char, c.type), @char_bin_types)+1, 1)) *  
                /* calculate the precision */
                isnull(convert(int, c.prec),
                    isnull(convert(int, d.data_precision),
                        convert(int,c.length)))
                    +isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                            2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
            ORDINAL_POSITION = c.colid,
            IS_NULLABLE = rtrim(substring('YESNO ', (nullable*3)+1, 3))
     
        FROM
            syscolumns c,
            sysobjects o,
            sybsystemprocs.dbo.spt_jdatatype_info d,
            systypes t
        WHERE
            o.id = @table_id
            AND o.id = c.id
            /*
            ** We use syscolumn.usertype instead of syscolumn.type
            ** to do join with systypes.usertype. This is because
            ** for a column which allows null, type stores its
            ** Server internal datatype whereas usertype still
            ** stores its user defintion datatype.  For an example,
            ** a column of type 'decimal NULL', its usertype = 26,
            ** representing decimal whereas its type = 106  
            ** representing decimaln. nullable in the select list
            ** already tells user whether the column allows null.
            ** In the case of user defining datatype, this makes
            ** more sense for the user.
            */
            AND c.usertype = t.usertype
            AND t.type = d.ss_dtype
            AND o.type != 'P'
            AND c.name like @column_name ESCAPE '\'
            AND d.ss_dtype IN (111, 109, 38, 110) /* Just *N types */
            AND c.usertype < 100
        UNION
        SELECT /* All other types including user data types */
            TABLE_CAT = DB_NAME(),
            TABLE_SCHEM = USER_NAME(o.uid),
            TABLE_NAME = o.name,
            COLUMN_NAME = c.name,
            DATA_TYPE = d.data_type+convert(smallint,
                        isnull(d.aux,
                        ascii(substring('666AAA@@@CB??GG',
                        2*(d.ss_dtype%35+1)+2-8/c.length,1))
                        -60)),
            TYPE_NAME = rtrim(substring(d.type_name,
                        1+isnull(d.aux,
                        ascii(substring('III<<<MMMI<<A<A',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-60), 13)),
            COLUMN_SIZE = isnull(convert(int, c.prec),
                      isnull(convert(int, d.data_precision),
                         convert(int,c.length)))
                        +isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                        2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
            BUFFER_LENGTH = isnull(convert(int, c.length),  
                    convert(int, d.length)) +
                       convert(int, isnull(d.aux,
                        ascii(substring('AAA<BB<DDDHJSPP',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-64)),
            DECIMAL_DIGITS = isnull(convert(smallint, c.scale),
                       convert(smallint, d.numeric_scale)) +
                        convert(smallint, isnull(d.aux,
                        ascii(substring('<<<<<<<<<<<<<<?',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-60)),
            NUM_PREC_RADIX = d.numeric_radix,
            NULLABLE = /* set nullability from status flag */
                convert(smallint, convert(bit, c.status&8)),
            REMARKS  = convert(varchar(254),null),
            COLUMN_DEF = NULL,
            SQL_DATA_TYPE = isnull(d.sql_data_type,
                      d.data_type+convert(smallint,
                      isnull(d.aux,
                      ascii(substring('666AAA@@@CB??GG',
                      2*(d.ss_dtype%35+1)+2-8/c.length,1))
                      -60))),
            SQL_DATETIME_SUB = NULL,
            /*
            ** if the datatype is of type CHAR or BINARY
            ** then set char_octet_length to the same value
            ** assigned in the "prec" column.
            **
            ** The first part of the logic is:
            **
            **   if(c.type is in (47, 39, 45, 37, 35, 34))
            **       set char_octet_length = prec;
            **   else
            **       set char_octet_length = 0;
            */
            CHAR_OCTET_LENGTH =  
                /*
                ** check if in the list
                ** if so, return a 1 and multiply it by the precision  
                ** if not, return a 0 and multiply it by the precision
                */
                convert(smallint,  
                    substring('0111111',  
                        charindex(convert(char, c.type), @char_bin_types)+1, 1)) *  
                /* calculate the precision */
                isnull(convert(int, c.prec),
                    isnull(convert(int, d.data_precision),
                        convert(int,c.length)))
                    +isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                            2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
            ORDINAL_POSITION = c.colid,
            IS_NULLABLE = rtrim(substring('YESNO ', (nullable*3)+1, 3))
     
        FROM
            syscolumns c,
            sysobjects o,
            sybsystemprocs.dbo.spt_jdatatype_info d,
            systypes t
        WHERE
            o.id = @table_id
            AND o.id = c.id
            /*
            ** We use syscolumn.usertype instead of syscolumn.type
            ** to do join with systypes.usertype. This is because
            ** for a column which allows null, type stores its
            ** Server internal datatype whereas usertype still
            ** stores its user defintion datatype.  For an example,
            ** a column of type 'decimal NULL', its usertype = 26,
            ** representing decimal whereas its type = 106  
            ** representing decimaln. nullable in the select list
            ** already tells user whether the column allows null.
            ** In the case of user defining datatype, this makes
            ** more sense for the user.
            */
            AND c.usertype = t.usertype
            /*
            ** We need a equality join with  
            ** sybsystemprocs.dbo.spt_jdatatype_info here so that
            ** there is only one qualified row returned from  
            ** sybsystemprocs.dbo.spt_jdatatype_info, thus avoiding
            ** duplicates.
            */
            AND t.type = d.ss_dtype
            AND o.type != 'P'
            AND c.name like @column_name ESCAPE '\'
            AND (d.ss_dtype NOT IN (111, 109, 38, 110) /* No *N types */
                OR c.usertype >= 100) /* User defined types */
        ORDER BY TABLE_SCHEM, TABLE_NAME, ORDINAL_POSITION
    end
    else
    begin
        SELECT /* INTn, FLOATn, DATETIMEn and MONEYn types */
            TABLE_CAT = DB_NAME(),
            TABLE_SCHEM = USER_NAME(o.uid),
            TABLE_NAME = o.name,
            COLUMN_NAME = c.name,
            DATA_TYPE = d.data_type+convert(smallint,
                        isnull(d.aux,
                        ascii(substring('666AAA@@@CB??GG',
                        2*(d.ss_dtype%35+1)+2-8/c.length,1))
                        -60)),
            TYPE_NAME = rtrim(substring(d.type_name,
                        1+isnull(d.aux,
                        ascii(substring('III<<<MMMI<<A<A',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-60), 13)),
            COLUMN_SIZE = isnull(convert(int, c.prec),
                      isnull(convert(int, d.data_precision),
                             convert(int, c.length)))
                        +isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                        2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
            BUFFER_LENGTH = isnull(convert(int, c.length),  
                    convert(int,d.length)) +
                       convert(int, isnull(d.aux,
                        ascii(substring('AAA<BB<DDDHJSPP',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-64)),
            DECIMAL_DIGITS = isnull(convert(smallint, c.scale),  
                       convert(smallint, d.numeric_scale)) +
                        convert(smallint, isnull(d.aux,
                        ascii(substring('<<<<<<<<<<<<<<?',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-60)),
            NUM_PREC_RADIX = d.numeric_radix,
            NULLABLE = /* set nullability from status flag */
                convert(smallint, convert(bit, c.status&8)),
            REMARKS = convert(varchar(254),null), /* Remarks are NULL */
            COLUMN_DEF = NULL,
            SQL_DATA_TYPE = isnull(d.sql_data_type,
                      d.data_type+convert(smallint,
                      isnull(d.aux,
                      ascii(substring('666AAA@@@CB??GG',
                      2*(d.ss_dtype%35+1)+2-8/c.length,1))
                      -60))),
            SQL_DATETIME_SUB = NULL,
            /*
            ** if the datatype is of type CHAR or BINARY
            ** then set char_octet_length to the same value
            ** assigned in the "prec" column.
            **
            ** The first part of the logic is:
            **
            **   if(c.type is in (47, 39, 45, 37, 35, 34))
            **       set char_octet_length = prec;
            **   else
            **       set char_octet_length = 0;
            */
            CHAR_OCTET_LENGTH =  
                /*
                ** check if in the list
                ** if so, return a 1 and multiply it by the precision  
                ** if not, return a 0 and multiply it by the precision
                */
                convert(smallint,  
                    substring('0111111',  
                        charindex(convert(char, c.type), @char_bin_types)+1, 1)) *  
                /* calculate the precision */
                isnull(convert(int, c.prec),
                    isnull(convert(int, d.data_precision),
                        convert(int,c.length)))
                    +isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                            2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
            ORDINAL_POSITION = c.colid,
            IS_NULLABLE = rtrim(substring('YESNO ', (nullable*3)+1, 3))
     
        FROM
            syscolumns c,
            sysobjects o,
            sybsystemprocs.dbo.spt_jdatatype_info d,
            systypes t
        WHERE
            o.name like @table_name ESCAPE '\'
            AND user_name(o.uid) like @table_owner ESCAPE '\'
            AND o.id = c.id
            /*
            ** We use syscolumn.usertype instead of syscolumn.type
            ** to do join with systypes.usertype. This is because
            ** for a column which allows null, type stores its
            ** Server internal datatype whereas usertype still
            ** stores its user defintion datatype.  For an example,
            ** a column of type 'decimal NULL', its usertype = 26,
            ** representing decimal whereas its type = 106  
            ** representing decimaln. nullable in the select list
            ** already tells user whether the column allows null.
            ** In the case of user defining datatype, this makes
            ** more sense for the user.
            */
            AND c.usertype = t.usertype
            AND t.type = d.ss_dtype
            AND o.type != 'P'
            AND c.name like @column_name ESCAPE '\'
            AND d.ss_dtype IN (111, 109, 38, 110) /* Just *N types */
            AND c.usertype < 100
        UNION
        SELECT /* All other types including user data types */
            TABLE_CAT = DB_NAME(),
            TABLE_SCHEM = USER_NAME(o.uid),
            TABLE_NAME = o.name,
            COLUMN_NAME = c.name,
            DATA_TYPE = d.data_type+convert(smallint,
                        isnull(d.aux,
                        ascii(substring('666AAA@@@CB??GG',
                        2*(d.ss_dtype%35+1)+2-8/c.length,1))
                        -60)),
            TYPE_NAME = rtrim(substring(d.type_name,
                        1+isnull(d.aux,
                        ascii(substring('III<<<MMMI<<A<A',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-60), 13)),
            COLUMN_SIZE = isnull(convert(int, c.prec),
                      isnull(convert(int, d.data_precision),
                         convert(int,c.length)))
                        +isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                        2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
            BUFFER_LENGTH = isnull(convert(int, c.length),  
                    convert(int, d.length)) +
                       convert(int, isnull(d.aux,
                        ascii(substring('AAA<BB<DDDHJSPP',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-64)),
            DECIMAL_DIGITS = isnull(convert(smallint, c.scale),
                       convert(smallint, d.numeric_scale)) +
                        convert(smallint, isnull(d.aux,
                        ascii(substring('<<<<<<<<<<<<<<?',
                        2*(d.ss_dtype%35+1)+2-8/c.length,
                        1))-60)),
            NUM_PREC_RADIX = d.numeric_radix,
            NULLABLE = /* set nullability from status flag */
                convert(smallint, convert(bit, c.status&8)),
            REMARKS  = convert(varchar(254),null),
            COLUMN_DEF = NULL,
            SQL_DATA_TYPE = isnull(d.sql_data_type,
                      d.data_type+convert(smallint,
                      isnull(d.aux,
                      ascii(substring('666AAA@@@CB??GG',
                      2*(d.ss_dtype%35+1)+2-8/c.length,1))
                      -60))),
            SQL_DATETIME_SUB = NULL,
            /*
            ** if the datatype is of type CHAR or BINARY
            ** then set char_octet_length to the same value
            ** assigned in the "prec" column.
            **
            ** The first part of the logic is:
            **
            **   if(c.type is in (47, 39, 45, 37, 35, 34))
            **       set char_octet_length = prec;
            **   else
            **       set char_octet_length = 0;
            */
            CHAR_OCTET_LENGTH =  
                /*
                ** check if in the list
                ** if so, return a 1 and multiply it by the precision  
                ** if not, return a 0 and multiply it by the precision
                */
                convert(smallint,  
                    substring('0111111',  
                        charindex(convert(char, c.type), @char_bin_types)+1, 1)) *  
                /* calculate the precision */
                isnull(convert(int, c.prec),
                    isnull(convert(int, d.data_precision),
                        convert(int,c.length)))
                    +isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                            2*(d.ss_dtype%35+1)+2-8/c.length,1))-60)),
            ORDINAL_POSITION = c.colid,
            IS_NULLABLE = rtrim(substring('YESNO ', (nullable*3)+1, 3))
     
        FROM
            syscolumns c,
            sysobjects o,
            sybsystemprocs.dbo.spt_jdatatype_info d,
            systypes t
        WHERE
            o.name like @table_name ESCAPE '\'
            AND user_name(o.uid) like @table_owner ESCAPE '\'
            AND o.id = c.id
            /*
            ** We use syscolumn.usertype instead of syscolumn.type
            ** to do join with systypes.usertype. This is because
            ** for a column which allows null, type stores its
            ** Server internal datatype whereas usertype still
            ** stores its user defintion datatype.  For an example,
            ** a column of type 'decimal NULL', its usertype = 26,
            ** representing decimal whereas its type = 106  
            ** representing decimaln. nullable in the select list
            ** already tells user whether the column allows null.
            ** In the case of user defining datatype, this makes
            ** more sense for the user.
            */
            AND c.usertype = t.usertype
            /*
            ** We need a equality join with  
            ** sybsystemprocs.dbo.spt_jdatatype_info here so that
            ** there is only one qualified row returned from  
            ** sybsystemprocs.dbo.spt_jdatatype_info, thus avoiding
            ** duplicates.
            */
            AND t.type = d.ss_dtype
            AND o.type != 'P'
            AND c.name like @column_name ESCAPE '\'
            AND (d.ss_dtype NOT IN (111, 109, 38, 110) /* No *N types */
                OR c.usertype >= 100) /* User defined types */
        ORDER BY TABLE_SCHEM, TABLE_NAME, ORDINAL_POSITION
    end            
     
    return(0)

go
exec sp_procxmode 'sp_jdbc_columns', 'anymode'
go
grant execute on sp_jdbc_columns to public
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_columns
*/


/*
**  sp_jdbc_tables
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name = 'sp_jdbc_tables')
begin
drop procedure sp_jdbc_tables
end
go
/** SECTION END: CLEANUP **/

create procedure sp_jdbc_tables
    @table_name       varchar(32)  = null,
    @table_owner      varchar(32)  = null,
    @table_qualifier  varchar(32)  = null,
    @table_type       varchar(100) = null
as
    declare @msg varchar(90)
    declare @searchstr varchar(255)

    if @@trancount = 0
    begin
    set chained off
    end
     
    set transaction isolation level 1

    /* temp table */
    if (@table_name like '#%' and
       db_name() != 'tempdb')
    begin
        /*
        ** Can return data about temp. tables only in tempdb
        */
        exec sp_getmessage 17676, @msg out
        raiserror 17676 @msg
        return(1)
    end
        if @table_qualifier is not null
        begin
            if db_name() != @table_qualifier
            begin
            exec sp_getmessage 18039, @msg out
            raiserror 18039 @msg
            return 1
        end
    end

    if @table_name is null select @table_name = '%'
    if @table_owner is null select @table_owner = '%'

    select @searchstr = ''
    if (patindex('%''SYSTEM%',upper(@table_type)) > 0)
        select @searchstr = @searchstr + 'S'

    if (patindex('%''TABLE''%',upper(@table_type)) > 0)
        select @searchstr = @searchstr +'U'
     
    if (patindex('%''VIEW''%',upper(@table_type)) > 0)  
        select @searchstr = @searchstr +'V'  
     
    if @table_type is null  
        select @searchstr = 'SUV'
    if ((@table_type is not null) and (@searchstr=''))
    begin
        exec sp_getmessage 17301, @msg output
        raiserror 17301 @msg, @table_type
        return(3)
    end

    /*
    ** Just return an empty result set with properly named columns
    ** if (select count(*) from sysobjects where user_name(uid) like @table_owner
    **                and name like @table_name
    **     and charindex(substring(type,1,1),@searchstr)! = 0) = 0  
    ** begin
    ** exec sp_getmessage 17674, @msg output
    ** raiserror 17674 @msg
    ** return(1)
    ** end
    */

    select
        TABLE_CAT =  rtrim(db_name()),
        TABLE_SCHEM= rtrim(user_name(uid)),
        TABLE_NAME = rtrim(name),
        rtrim(substring('SYSTEM TABLE            TABLE       VIEW       ',
        (ascii(type)-83)*12+1,12)) as TABLE_TYPE,
        REMARKS=     convert(varchar(254),null)
    from sysobjects  
    where name like @table_name ESCAPE '\'
        and user_name(uid) like @table_owner ESCAPE '\'
        and charindex(substring(type,1,1),@searchstr)! = 0
    order by TABLE_TYPE, TABLE_CAT, TABLE_SCHEM, TABLE_NAME
go
exec sp_procxmode 'sp_jdbc_tables', 'anymode'
go
grant execute on sp_jdbc_tables to public
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_tables
*/


/*
**  spt_jdbc_table_types
*/


/** SECTION BEGIN: CLEANUP **/
use master
go

if (exists (select * from sysobjects
                where name = 'spt_jdbc_table_types'))
    drop table spt_jdbc_table_types
go
/** SECTION END: CLEANUP **/
  

create table spt_jdbc_table_types (TABLE_TYPE char(15))
go
    insert into spt_jdbc_table_types values('TABLE')
    insert into spt_jdbc_table_types values('SYSTEM TABLE')
    insert into spt_jdbc_table_types values('VIEW')
go
  
commit
go
  
grant select on spt_jdbc_table_types to public
go

/*
**  End of spt_jdbc_table_types
*/


/*
**  spt_mda
*/


/** SECTION BEGIN: CLEANUP **/
use master
go

if exists (select * from sysobjects where name = 'spt_mda')
begin
    drop table spt_mda
end
go
/** SECTION END: CLEANUP **/

/*
** querytype: 1 == RPC, 2 == LANGUAGE, 3 == NOT_SUPPORTED,
**            4 == LITERAL (boolean), 5 == LITERAL (integer),
**            6 == LITERAL (string), 7 == LITERAL (string, not tokenizable)
**
** note: querytypes 4 through 6 were added in version level 4  
**       of the metadata access.
** note: querytype 7 was added in version level 5 of the metadata access
** to fix 168844
** note: sp_mda version does NOT refer to the jConnect version!!
*/
create table spt_mda (mdinfo varchar(30), querytype tinyint,  
    query varchar(255) null, mdaver_start tinyint, mdaver_end tinyint)
go

create unique nonclustered index spt_mda_ind  
    on spt_mda (mdinfo, mdaver_end)
go

grant select on spt_mda to public
go

insert spt_mda values ('FUNCTIONCALL', 1, 'sp_jdbc_function_escapes', 1, 6)
insert spt_mda values ('TYPEINFO', 1, 'sp_jdbc_datatype_info', 1, 6)
insert spt_mda values ('TABLES', 1, 'sp_jdbc_tables(?,?,?,?)', 1, 6)
insert spt_mda values ('COLUMNS', 1, 'sp_jdbc_columns(?,?,?,?)', 1, 6)
insert spt_mda values ('IMPORTEDKEYS', 1, 'sp_jdbc_importkey(?,?,?)', 1, 6)
insert spt_mda values ('EXPORTEDKEYS', 1, 'sp_jdbc_exportkey(?,?,?)', 1, 6)
insert spt_mda values ('PRIMARYKEYS', 1, 'sp_jdbc_primarykey(?,?,?)', 1, 6)
insert spt_mda values ('PRODUCTNAME', 2, 'select ''Sybase SQL Server''', 1, 3)  
insert spt_mda values ('PRODUCTNAME', 6, 'Sybase SQL Server', 4, 6)  
insert spt_mda values ('ISREADONLY', 2, 'select 0', 1, 3)
insert spt_mda values ('ISREADONLY', 4, '0', 4, 6)
insert spt_mda values ('ALLPROCSCALLABLE', 2, 'select 0', 1, 3)
insert spt_mda values ('ALLPROCSCALLABLE', 4, '0', 4, 6)
insert spt_mda values ('ALLTABLESSELECTABLE', 2, 'select 0', 1, 3)
insert spt_mda values ('ALLTABLESSELECTABLE', 4, '0', 4, 6)
insert spt_mda values ('COLUMNALIASING', 2, 'select 1', 1, 3)
insert spt_mda values ('COLUMNALIASING', 4, '1', 4, 6)
insert spt_mda values ('IDENTIFIERQUOTE', 2, 'select ''"''', 1, 3)
insert spt_mda values ('IDENTIFIERQUOTE', 6, '"', 4, 6)
insert spt_mda values ('ALTERTABLESUPPORT', 2, 'select 1, 1', 1, 3)
insert spt_mda values ('ALTERTABLESUPPORT', 4, '1, 1', 4, 6)
insert spt_mda values ('CONNECTCONFIG', 2, 'set quoted_identifier on set textsize 50000', 1, 6)
insert spt_mda values ('CONVERTSUPPORT', 2, 'select 1', 1, 3)
insert spt_mda values ('CONVERTSUPPORT', 4, '1', 4, 6)
insert spt_mda values ('CONVERTMAP', 1, 'sp_jdbc_convert_datatype(?,?)', 1, 6)
insert spt_mda values ('LIKEESCAPECLAUSE', 2, 'select 1', 1, 3)
insert spt_mda values ('LIKEESCAPECLAUSE', 4, '1', 4, 6)
insert spt_mda values ('MULTIPLERESULTSETS', 2, 'select 1', 1, 3)
insert spt_mda values ('MULTIPLERESULTSETS', 4, '1', 4, 6)
insert spt_mda values ('MULTIPLETRANSACTIONS', 2, 'select 1', 1, 3)
insert spt_mda values ('MULTIPLETRANSACTIONS', 4, '1', 4, 6)
insert spt_mda values ('NONNULLABLECOLUMNS', 2, 'select 1', 1, 3)  
insert spt_mda values ('NONNULLABLECOLUMNS', 4, '1', 4, 6)  
insert spt_mda values ('POSITIONEDDELETE', 2, 'select 1', 1, 3)
insert spt_mda values ('POSITIONEDDELETE', 4, '1', 4, 6)
insert spt_mda values ('POSITIONEDUPDATE', 2, 'select 1', 1, 3)
insert spt_mda values ('POSITIONEDUPDATE', 4, '1', 4, 6)
insert spt_mda values ('STOREDPROCEDURES', 2, 'select 1', 1, 3)
insert spt_mda values ('STOREDPROCEDURES', 4, '1', 4, 6)
insert spt_mda values ('PROCEDURES', 1, 'sp_jdbc_stored_procedures(?,?,?)', 1, 6)
insert spt_mda values ('SELECTFORUPDATE', 2, 'select 1', 1, 3)  
insert spt_mda values ('SELECTFORUPDATE', 4, '1', 4, 6)  
insert spt_mda values ('CURSORTRANSACTIONS', 2, 'select 1, 1', 1, 3)
insert spt_mda values ('CURSORTRANSACTIONS', 4, '1, 1', 4, 6)
insert spt_mda values ('STATEMENTTRANSACTIONS', 2, 'select 1, 1', 1, 3)
insert spt_mda values ('STATEMENTTRANSACTIONS', 4, '1, 1', 4, 6)
insert spt_mda values ('TRANSACTIONSUPPORT', 2, 'select 1', 1, 3)
insert spt_mda values ('TRANSACTIONSUPPORT', 4, '1', 4, 6)
/*  
 *Set this to 1 if 'exec <dbname>..<storedProcName>' is allowed
 */
insert spt_mda values ('PREPEND_DB_NAME', 2, 'select 1', 1, 3)  
insert spt_mda values ('PREPEND_DB_NAME', 5, '1', 4, 6)  

-- note - transaction levels here match Connection.TRANSACTION
insert spt_mda values ('TRANSACTIONLEVELS', 1, 'sp_jdbc_getisolationlevels',1 ,6)  
insert spt_mda values ('TRANSACTIONLEVELDEFAULT', 2, 'select 2', 1, 3)
insert spt_mda values ('TRANSACTIONLEVELDEFAULT', 5, '2', 4, 6)
insert spt_mda values  
('SET_ISOLATION', 2, 'set transaction isolation level ', 1, 6)
insert spt_mda values ('GET_ISOLATION', 2, 'select @@isolation', 1, 6)
insert spt_mda values ('SET_ROWCOUNT', 2, 'set rowcount ?', 1, 6)
insert spt_mda values ('GET_AUTOCOMMIT', 2, 'select @@tranchained', 1, 6)
insert spt_mda values ('SET_AUTOCOMMIT_ON', 2, 'set CHAINED off', 1, 6)
insert spt_mda values ('SET_AUTOCOMMIT_OFF', 2, 'set CHAINED on', 1, 6)
insert spt_mda values ('SET_READONLY_TRUE', 3, '', 1, 6)
insert spt_mda values ('SET_READONLY_FALSE', 3, '', 1, 6)
insert spt_mda values ('SET_CATALOG', 2, 'use ?', 1, 6)
insert spt_mda values ('GET_CATALOG', 2, 'select db_name()', 1, 6)
insert spt_mda values ('NULLSORTING', 2, 'select 0, 1, 0, 0', 1, 3)
insert spt_mda values ('NULLSORTING', 4, '0, 1, 0, 0', 4, 6)
insert spt_mda values ('PRODUCTVERSION', 2, 'select @@version', 1, 6)
insert spt_mda values ('FILEUSAGE', 2, 'select 0, 0', 1, 3)
insert spt_mda values ('FILEUSAGE', 4, '0, 0', 4, 6)
if ('a'='A')  /* Case insensitive */
    begin
        insert spt_mda values ('IDENTIFIERCASES', 2, 'select 0, 0, 0, 1, 1, 0, 0, 1', 1, 3)
        insert spt_mda values ('IDENTIFIERCASES', 4, '0, 0, 0, 1, 1, 0, 0, 1', 4, 6)
    end
else /* case sensitive */
    begin
        insert spt_mda values ('IDENTIFIERCASES', 2, 'select 1, 0, 0, 0, 1, 0, 0, 0', 1, 3)
        insert spt_mda values ('IDENTIFIERCASES', 4, '1, 0, 0, 0, 1, 0, 0, 0', 4, 6)
    end
insert spt_mda values ('SQLKEYWORDS', 2,     
    'select value from master.dbo.spt_jtext where mdinfo = ''SQLKEYWORDS''', 1, 6)
insert spt_mda values ('NUMERICFUNCTIONLIST', 2,
    'select ''abs,acos,asin,atan,atan2,ceiling,cos,cot,degrees,exp,floor,log,log10,pi,power,radians,rand,round,sign,sin,sqrt,tan''', 1, 4)
insert spt_mda values ('NUMERICFUNCTIONLIST', 7,
    'abs,acos,asin,atan,atan2,ceiling,cos,cot,degrees,exp,floor,log,log10,pi,power,radians,rand,round,sign,sin,sqrt,tan', 5, 6)
insert spt_mda values ('STRINGFUNCTIONLIST', 2,
    'select ''ascii,char,concat,difference,insert,length,lcase,ltrim,repeat,right,rtrim,soundex,space,substring,ucase''', 1, 4)
insert spt_mda values ('STRINGFUNCTIONLIST', 7,
    'ascii,char,concat,difference,insert,length,lcase,ltrim,repeat,right,rtrim,soundex,space,substring,ucase', 5, 6)
insert spt_mda values ('SYSTEMFUNCTIONLIST', 2,  
    'select ''database,ifnull,user,convert''', 1, 4)
insert spt_mda values ('SYSTEMFUNCTIONLIST', 7,
    'database,ifnull,user,convert', 5, 6)
insert spt_mda values ('TIMEDATEFUNCTIONLIST', 2,
    'select ''curdate,curtime,dayname,dayofmonth,dayofweek,dayofyear,hour,minute,month,monthname,now,quarter,second,timestampadd,timestampdiff,week,year''', 1,4)
insert spt_mda values ('TIMEDATEFUNCTIONLIST', 7,
    'curdate,curtime,dayname,dayofmonth,dayofweek,dayofyear,hour,minute,month,monthname,now,quarter,second,timestampadd,timestampdiff,week,year', 5, 6)   
insert spt_mda values ('NULLPLUSNONNULL', 2, 'select 1', 1, 3)
insert spt_mda values ('NULLPLUSNONNULL', 4, '1', 4, 6)
insert spt_mda values ('EXTRANAMECHARS', 2, 'select ''@#$ге''', 1, 3)
insert spt_mda values ('EXTRANAMECHARS', 6, '@#$ге', 4, 6)
insert spt_mda values ('MAXBINARYLITERALLENGTH', 2, 'select 255', 1, 3)
insert spt_mda values ('MAXBINARYLITERALLENGTH', 5, '255', 4, 6)
insert spt_mda values ('MAXCHARLITERALLENGTH', 2, 'select 255', 1, 3)
insert spt_mda values ('MAXCHARLITERALLENGTH', 5, '255', 4, 6)

insert spt_mda values ('SCHEMAS', 1, 'sp_jdbc_getschemas', 1, 6)
insert spt_mda values ('COLUMNPRIVILEGES', 1, 'sp_jdbc_getcolumnprivileges(?,?,?,?)', 1, 6)
insert spt_mda values ('TABLEPRIVILEGES', 1, 'sp_jdbc_gettableprivileges(?,?,?)', 1, 6)
insert spt_mda values ('ROWIDENTIFIERS', 1, 'sp_jdbc_getbestrowidentifier(?,?,?,?,?)', 1, 6)
insert spt_mda values ('VERSIONCOLUMNS', 1, 'sp_jdbc_getversioncolumns(?,?,?)', 1, 6)
insert spt_mda values ('KEYCROSSREFERENCE', 1, 'sp_jdbc_getcrossreferences(?,?,?,?,?,?)', 1, 6)
insert spt_mda values ('INDEXINFO', 1, 'sp_jdbc_getindexinfo(?,?,?,?,?)', 1, 6)
insert spt_mda values ('PROCEDURECOLUMNS', 1, 'sp_jdbc_getprocedurecolumns(?,?,?,?)', 1, 6)
insert spt_mda values ('CATALOGS', 1, 'sp_jdbc_getcatalogs', 1, 6)
insert spt_mda values ('TABLETYPES', 2, 'select TABLE_TYPE from master.dbo.spt_jdbc_table_types', 1, 6)
insert spt_mda values ('SEARCHSTRING', 2, 'select ''\''', 1, 3)
insert spt_mda values ('SEARCHSTRING', 6, '\', 4, 6)
/*
supportsIntegrityEnhancementFacility: true
*/
insert spt_mda values ('INTEGRITYENHANCEMENT', 2, 'select 1', 1, 3)
insert spt_mda values ('INTEGRITYENHANCEMENT', 4, '1', 4, 6)

/*  
supportsOuterJoins: true
supportsFullOuterJoins: false
supportsLimitedOuterJoins: true
supports the syntax of the body of an oj escape without further
processing: false
*/
insert spt_mda values ('OUTERJOINS', 2, 'select 1, 0, 1, 0', 1, 3)
insert spt_mda values ('OUTERJOINS', 4, '1, 0, 1, 0', 4, 6)

/*  
isCatalogAtStart: true
*/
insert spt_mda values ('CATALOGATSTART', 2, 'select 1', 1, 3)
insert spt_mda values ('CATALOGATSTART', 4, '1', 4, 6)

/*  
same with catalog
*/
insert spt_mda values ('CATALOGSUPPORT', 2, 'select 1, 1, 1, 1, 0', 1, 3)
insert spt_mda values ('CATALOGSUPPORT', 4, '1, 1, 1, 1, 0', 4, 6)

/*  
supportsSubqueriesInComparisons: true
supportsSubqueriesInExists: true
supportsSubqueriesInIns: true
supportsSubqueriesInQuantifieds: true
supportsCorrelatedSubqueries: true
*/
insert spt_mda values ('SUBQUERIES', 2, 'select 1, 1, 1, 1, 1', 1, 3)
insert spt_mda values ('SUBQUERIES', 4, '1, 1, 1, 1, 1', 4, 6)

/*
supportsTableCorrelationNames: true
supportsDifferentTableCorrelationNames: false
*/
insert spt_mda values ('CORRELATIONNAMES', 2, 'select 1, 0', 1, 3)
insert spt_mda values ('CORRELATIONNAMES', 4, '1, 0', 4, 6)

/*
supportsExpressionsInOrderBy: true
supportsOrderByUnrelated: true
*/
insert spt_mda values ('ORDERBYSUPPORT', 2, 'select 1, 1', 1, 3)
insert spt_mda values ('ORDERBYSUPPORT', 4, '1, 1', 4, 6)

/*  
supportsGroupBy: true
supportsGroupByUnrelated: true
supportsGroupByBeyondSelect: true
*/
insert spt_mda values ('GROUPBYSUPPORT', 2, 'select 1, 1, 1', 1, 3)
insert spt_mda values ('GROUPBYSUPPORT', 4, '1, 1, 1', 4, 6)

/*  
supportsMinimumSQLGrammar: true
supportsCoreSQLGrammar: false
supportsExtendedSQLGrammar: false
*/
insert spt_mda values ('SQLGRAMMAR', 2, 'select 1, 0, 0', 1, 3)
insert spt_mda values ('SQLGRAMMAR', 4, '1, 0, 0', 4, 6)

/*  
supportsANSI92EntryLevelSQL: true
supportsANSI92IntermediateSQL: false
supportsANSI92FullSQL: false
*/
insert spt_mda values ('ANSI92LEVEL', 2, 'select 1, 0, 0', 1, 3)
insert spt_mda values ('ANSI92LEVEL', 4, '1, 0, 0', 4, 6)

/*  
SQL Server's terms for 'schema', 'procedure' and 'catalog'  
and how to separate them
*/
insert spt_mda values ('SCHEMATERM', 2, 'select ''owner''', 1, 3)
insert spt_mda values ('SCHEMATERM', 6, 'owner', 4, 6)
insert spt_mda values ('PROCEDURETERM', 2, 'select ''stored procedure''', 1, 3)
insert spt_mda values ('PROCEDURETERM', 6, 'stored procedure', 4, 6)
insert spt_mda values ('CATALOGTERM', 2, 'select ''database''', 1, 3)
insert spt_mda values ('CATALOGTERM', 6, 'database', 4, 6)
insert spt_mda values ('CATALOGSEPARATOR', 2, 'select ''.''', 1, 3)
insert spt_mda values ('CATALOGSEPARATOR', 6, '.', 4, 6)

/*  
supportsSchemasInDataManipulation: true
supportsSchemasInProcedureCalls: true
supportsSchemasInTableDefinitions: true
supportsSchemasInIndexDefinitions: true
supportsSchemasInPrivilegeDefinitions: false
*/
insert spt_mda values ('SCHEMASUPPORT', 2, 'select 1, 1, 1, 1, 0', 1, 3)
insert spt_mda values ('SCHEMASUPPORT', 4, '1, 1, 1, 1, 0', 4, 6)

/*  
supportsUnion: true
supportsUnionAll: true
*/
insert spt_mda values ('UNIONSUPPORT', 2, 'select 1, 1', 1, 3)
insert spt_mda values ('UNIONSUPPORT', 4, '1, 1', 4, 6)

/*  
supportsDataDefinitionAndDataManipulationTransactions: true
supportsDataManipulationTransactionsOnly: false
dataDefinitionCausesTransactionCommit: false
dataDefinitionIgnoredInTransactions: false
*/
insert spt_mda values ('TRANSACTIONDATADEFINFO', 2, 'select 1, 0, 0, 0', 1, 3)
insert spt_mda values ('TRANSACTIONDATADEFINFO', 4, '1, 0, 0, 0', 4, 6)

/*
max column name length, max columns in group by,
max columns in index, max columns in order by,
max columns in select, max columns in table
XXX max columns in index is only 15 for B1
server.  Will that be a separate script?  Can we
detect whether this is B1 server?
XXX max columns in select is unlimited, so I'm
returning 0 -- the spec I'm looking at
doesn't actually say what to do in such a case
*/
insert spt_mda values ('COLUMNINFO', 2, 'select 30, 16, 16, 16, 0, 250', 1, 3)
insert spt_mda values ('COLUMNINFO', 5, '30, 16, 16, 16, 0, 250', 4, 6)
insert spt_mda values ('MAXCONNECTIONS', 2, 'select @@max_connections', 1, 6)
insert spt_mda values ('MAXINDEXLENGTH', 2, 'select 255', 1, 3)
insert spt_mda values ('MAXINDEXLENGTH', 5, '255', 4, 6)
/*
max cursor name length, max user name length,
max schema name length, max procedure name length,
max catalog name length
*/
insert spt_mda values ('MAXNAMELENGTHS', 2, 'select 30, 30, 30, 30, 30', 1, 3)
insert spt_mda values ('MAXNAMELENGTHS', 5, '30, 30, 30, 30, 30', 4, 6)
/*
** max bytes in a row is 1962, 0 is for 'no, that doesn't include blobs'
** ROWINFO cannot be converted into a LITERAL type since it contains  
** different types for each column:  int, boolean
*/
insert spt_mda values ('ROWINFO', 2, 'select 1962, 0', 1, 6)
/*
max length of a statement, max number of open statements
both are unlimited
*/
insert spt_mda values ('STATEMENTINFO', 2, 'select 0, 0', 1, 3)
insert spt_mda values ('STATEMENTINFO', 5, '0, 0', 4, 6)
/*
max table name length, max tables in a select
*/
insert spt_mda values ('TABLEINFO', 2, 'select 30, 256', 1, 3)
insert spt_mda values ('TABLEINFO', 5, '30, 256', 4, 6)
go
/*
RSMDA.getColumnTypeName
*/
insert spt_mda values ('COLUMNTYPENAME', 1, 'sp_sql_type_name(?,?)', 1, 6)
go
/*
Get the Data source specific DEFAULT CHARACTER SET
*/
insert spt_mda values ('DEFAULT_CHARSET', 1, 'sp_default_charset', 1, 6)
go
/*
ownUpdatesAreVisible (JDBC 2.0)
TYPE_FORWARD_ONLY: true
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('OWNUPDATESAREVISIBLE', 4, '1, 0, 0', 6, 6)
go
/*
ownDeletesAreVisible (JDBC 2.0)
TYPE_FORWARD_ONLY: true
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('OWNDELETESAREVISIBLE', 4, '1, 0, 0', 6, 6)
go
/*
ownInsertsAreVisible (JDBC 2.0)
TYPE_FORWARD_ONLY: false
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('OWNINSERTSAREVISIBLE', 4, '0, 0, 0', 6, 6)
go
/*
othersUpdatesAreVisible (JDBC 2.0)
TYPE_FORWARD_ONLY: true
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('OTHERSUPDATESAREVISIBLE', 4, '1, 0, 0', 6, 6)
go
/*
othersDeletesAreVisible (JDBC 2.0)
TYPE_FORWARD_ONLY: true
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('OTHERSDELETESAREVISIBLE', 4, '1, 0, 0', 6, 6)
go
/*
othersInsertsAreVisible (JDBC 2.0)
TYPE_FORWARD_ONLY: true
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('OTHERSINSERTSAREVISIBLE', 4, '1, 0, 0', 6, 6)
go
/*
updatesAreDetected (JDBC 2.0)
TYPE_FORWARD_ONLY: false
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('UPDATESAREDETECTED', 4, '0, 0, 0', 6, 6)
go
/*
deletesAreDetected (JDBC 2.0)
TYPE_FORWARD_ONLY: false
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('DELETESAREDETECTED', 4, '0, 0, 0', 6, 6)
go
/*
insertsAreDetected (JDBC 2.0)
TYPE_FORWARD_ONLY: false
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('INSERTSAREDETECTED', 4, '0, 0, 0', 6, 6)
go
/*
supportsBatchUpdates: true (JDBC 2.0)
*/
insert spt_mda values ('SUPPORTSBATCHUPDATES', 4, '1', 6, 6)
go
/*
execBatchUpdatesInLoop: false  
*/
insert spt_mda values ('EXECBATCHUPDATESINLOOP', 4, '0', 6, 6)
go
/*
supportsResultSetType (JDBC 2.0)
TYPE_FORWARD_ONLY: true
TYPE_SCROLL_INSENSITIVE: true
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('SUPPORTSRESULTSETTYPE', 4, '1, 1, 0', 6, 6)
go
/*
supportsResultSetConcurrency(CONCUR_READ_ONLY) (JDBC 2.0)
TYPE_FORWARD_ONLY: true
TYPE_SCROLL_INSENSITIVE: true
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('READONLYCONCURRENCY', 4, '1, 1, 0', 6, 6)
go
/*
supportsResultSetConcurrency(CONCUR_UPDATABLE) (JDBC 2.0)
TYPE_FORWARD_ONLY: true
TYPE_SCROLL_INSENSITIVE: false
TYPE_SCROLL_SENSITIVE: false
*/
insert spt_mda values ('UPDATABLECONCURRENCY', 4, '1, 0, 0', 6, 6)
go
/*
getUDTs (JDBC 2.0)
*/   
insert spt_mda values ('UDTS', 1, 'sp_jdbc_getudts(?,?,?,?)', 6, 6)
go
/*
isCaseSensitive
*/
insert spt_mda values ('ISCASESENSITIVE', 2,
    'if exists (select 1 where ''A'' = ''a'') select 0 else select 1', 6, 6)
go

commit
go
dump tran sybsystemprocs with truncate_only  
go

/*
**  End of spt_mda
*/


/*
**  spt_jtext
*/


/** SECTION BEGIN: CLEANUP **/
use master
go

if exists (select * from sysobjects where name = 'spt_jtext')
begin
    drop table spt_jtext
end
go
/** SECTION END: CLEANUP **/

create table spt_jtext (mdinfo varchar(30) unique, value text)
go

grant select on spt_jtext to public
go

insert spt_jtext values ('SQLKEYWORDS',
'ARITH_OVERFLOW,BREAK,BROWSE,BULK,CHAR_CONVERT,CHECKPOINT,CLUSTERED,COMPUTE,CONFIRM,CONTROLROW,DATA_PGS,DATABASE,DBCC,DISK,DUMMY,DUMP,ENDTRAN,ERRLVL,ERRORDATA,ERROREXIT,EXIT,FILLFACTOR,HOLDLOCK,IDENTITY_INSERT,IF,INDEX,KILL,LINENO,LOAD,MAX_ROWS_PER_PAGE,MIRROR,MIRROREXIT,NOHOLDLOCK,NONCLUSTERED,NUMERIC_TRUNCATION,OFF,OFFSETS,ONCE,ONLINE,OVER,PARTITION,PERM,PERMANENT,PLAN,PRINT,PROC,PROCESSEXIT,RAISERROR,READTEXT,RECONFIGURE,REPLACE,RESERVED_PGS,RETURN,ROLE,ROWCNT,ROWCOUNT,RULE,SAVE,SETUSER,SHARED,SHUTDOWN,SOME,STATISTICS,STRIPE,SYB_IDENTITY,SYB_RESTREE,SYB_TERMINATE,TEMP,TEXTSIZE,TRAN,TRIGGER,TRUNCATE,TSEQUAL,UNPARTITION,USE,USED_PGS,USER_OPTION,WAITFOR,WHILE,WRITETEXT')
go

commit
go
dump tran sybsystemprocs with truncate_only  
go

/*
**  End of spt_jtext
*/


/*
**  spt_jdbc_conversion
*/


/** SECTION BEGIN: CLEANUP **/
use master
go

/*
** create table with conversion information
*/
if exists (select * from sysobjects
where name = 'spt_jdbc_conversion')
begin
    drop table spt_jdbc_conversion
end
go
/** SECTION END: CLEANUP **/

create table spt_jdbc_conversion (datatype int, conversion char(20))
go

grant select on spt_jdbc_conversion to public
go

/*Values based on the table info from the SQL Server Ref Man Chapter 4*/
/*bit*/
insert into spt_jdbc_conversion values(0,'11111110111111110001')
/*integers+numerics*/
insert into spt_jdbc_conversion values(1,'11111100011111110000')
insert into spt_jdbc_conversion values(2,'11111100011111110000')
insert into spt_jdbc_conversion values(9,'11111100011111110000')
insert into spt_jdbc_conversion values(10,'11111100011111110000')
insert into spt_jdbc_conversion values(11,'11111100011111110000')
insert into spt_jdbc_conversion values(12,'11111100011111110000')
insert into spt_jdbc_conversion values(13,'11111100011111110000')
insert into spt_jdbc_conversion values(14,'11111100011111110000')
insert into spt_jdbc_conversion values(15,'11111100011111110000')
/*Binaries*/
insert into spt_jdbc_conversion values(5,'11111110111111111111')
insert into spt_jdbc_conversion values(4,'11111110111111111111')
insert into spt_jdbc_conversion values(3,'11111110111111111111')
/*Characters*/
insert into spt_jdbc_conversion values(6,'00011110100000001111')
insert into spt_jdbc_conversion values(8,'00011110100000001111')
insert into spt_jdbc_conversion values(19,'00011110100000001111')
/*Dates*/
insert into spt_jdbc_conversion values(16,'00000010000000001110')
insert into spt_jdbc_conversion values(17,'00000010000000001110')
insert into spt_jdbc_conversion values(18,'00000010000000001110')
/*NULL*/
insert into spt_jdbc_conversion values(7,'00000000000000000000')
go
commit
go
dump tran sybsystemprocs with truncate_only  
go

/*
**  End of spt_jdbc_conversion
*/


/*
**  sp_mda
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs
go

/*
** create the well-known sp_mda procedure for accessing the data
*/
if exists (select * from sysobjects where name = 'sp_mda')
begin
    drop procedure sp_mda
end
go
/** SECTION END: CLEANUP **/


/*
** requesttype 0 == Returns the mdinfo:MDAVERSION and mdinfo:MDARELEASEID rows.
** requesttype 1 == JDBC
** requesttype 2 == JDBC - but only send back the minimal frequently used info.
**  
** mdaversion  
*/
create procedure sp_mda(@requesttype int, @requestversion int, @clientversion int = 0) as
begin

    declare @min_mdaversion int, @max_mdaversion int
    declare @mda_version int
    declare @mdaver_querytype tinyint
    declare @mdaver_query varchar(255)
     
    select @min_mdaversion = 1
    select @max_mdaversion = 6
    select @mda_version = @requestversion
     
    if @@trancount = 0
    begin
    set chained off
    end
     
    set transaction isolation level 1

    /*
    ** if the client is requesting a version too old
    ** then we return our lowest version supported
    **
    ** the client needs to be able to just handle this
    */
    if (@requestversion < @min_mdaversion)
        begin
            select @mda_version = @min_mdaversion
        end
         
    /*
    ** if the client is requesting a version too new
    ** we will return our highest version available
    */
    if (@mda_version > @max_mdaversion)
        begin
            select @mda_version = @max_mdaversion
        end
         
    /*
    ** if the client's requested version is between 1 and 3,  
    ** then the mda version returned needs to be 1.  The reason
    ** for this is the jConnect driver would pass in it's own  
    ** major version number as the @requestversion.  We need to
    ** keep older version's of the driver working ok since  
    ** they expect a '1' to be returned.
    */
    if (@mda_version < 4)
        begin
            select @mda_version = 1
            select @mdaver_querytype = 2
            select @mdaver_query = 'select 1'
        end
    else
        begin
            select @mdaver_querytype = 5
            select @mdaver_query = convert(varchar(255), @mda_version)
        end

    /*
    ** process the @requesttype
    */
    if (@requesttype = 0)
        begin
            select "mdinfo" = convert(varchar(30),'MDAVERSION'),  
                   "querytype" = @mdaver_querytype,
                   "query" = @mdaver_query
            union
            select mdinfo, querytype, query  
            from master..spt_mda
        where mdinfo in (
                'MDARELEASEID'
            )
        end
    else if (@requesttype = 1)
        begin
            select "mdinfo" = convert(varchar(30),'MDAVERSION'),  
                   "querytype" = @mdaver_querytype,
                   "query" = @mdaver_query
            union
            select mdinfo, querytype, query
            from master..spt_mda
            where @mda_version >= mdaver_start
                  and @mda_version <= mdaver_end
        end
    else if (@requesttype = 2)
        begin
            select "mdinfo" = convert(varchar(30),'MDAVERSION'),  
                   "querytype" = @mdaver_querytype,
                   "query" = @mdaver_query
            union
            select mdinfo, querytype, query  
            from master..spt_mda
        where mdinfo in (
                'CONNECTCONFIG',  
        'SET_CATALOG',
        'SET_AUTOCOMMIT_ON',
        'SET_AUTOCOMMIT_OFF',
        'SET_ISOLATION',
        'SET_ROWCOUNT',
                'DEFAULT_CHARSET'
            )
                and @mda_version >= mdaver_start
                and @mda_version <= mdaver_end
        end
end
go

exec sp_procxmode 'sp_mda', 'anymode'
go
grant execute on sp_mda to public
go
dump transaction sybsystemprocs with truncate_only
go

/*
**  End of sp_mda
*/


/*
**  jdbc_function_escapes
*/


/*  
** This script creates a table which is used by jdbcCONNECT to
** obtain information on this specific server types implementation
** of the various static functions for which JDBC provides escape
** sequences.
**
** Each row has two columns.  Escape_name is the name of the
** static function escape.  Map_string is a string showing how the
** function call should be sent to the server.  %i is a placeholder
** for the i'th argument to the escape.  This numbering is used
** to support skipping arguments.  Reordering of arguments is NOT
** supported.  Thus, a map string of 'foo(%2)' is ok (skips first
** argument); 'foo(%2, %1)' is not ok, at least until the driver
** changes to support this.
**
** Don't include rows for unsupported functions.
**
** Three escapes, convert, timestampadd, and timestampdiff, have
** one argument which takes special constant values.  These constants
** may also need to be mapped.  Therefore, include one row for each
** possible constant value, using the concatenation of the function name
** and the constant value as the escape_name column.  E.g.:  
** convertsql_binary, convertsql_bit, convertsql_char, etc.
** DO count the constant in figuring argument numbers.  Thus,
** timestampadd(sql_tsi_second, ts, ts) gets the map string
** 'dateadd(ss, %2, %3)')
**
** Use lower case for the escape name.  Use whatever case you
** need to for the map string.
**
*/

/** SECTION BEGIN: CLEANUP **/
use master
go

if exists (select * from sysobjects
    where name = 'jdbc_function_escapes')
    begin
        drop table jdbc_function_escapes
    end
go
/** SECTION END: CLEANUP **/

create table jdbc_function_escapes (escape_name varchar(40),
    map_string varchar(40))
go

grant select on jdbc_function_escapes to public
go

/* don't bother inserting rows for unsupported functions
** insert jdbc_function_escapes values ('mod', null)
** insert jdbc_function_escapes values ('truncate', null)
** insert jdbc_function_escapes values ('left', null)
** insert jdbc_function_escapes values ('locate', null)
** insert jdbc_function_escapes values ('replace', null)
** insert jdbc_function_escapes values (timestampdiffsql_tsi_frac_second, null)
** insert jdbc_function_escapes values (timestampaddsql_tsi_frac_second, null)
** insert jdbc_function_escapes values ('convertsql_bigint', null)
*/
insert jdbc_function_escapes values ('abs', 'abs(%1)')
go
insert jdbc_function_escapes values ('acos', 'acos(%1)')
go
insert jdbc_function_escapes values ('asin', 'asin(%1)')
go
insert jdbc_function_escapes values ('atan', 'atan(%1)')
go
insert jdbc_function_escapes values ('atan2', 'atn2(%1, %2)')
go
insert jdbc_function_escapes values ('ceiling', 'ceiling(%1)')
go
insert jdbc_function_escapes values ('cos', 'cos(%1)')
go
insert jdbc_function_escapes values ('cot', 'cot(%1)')
go
insert jdbc_function_escapes values ('degrees', 'degrees(%1)')
go
insert jdbc_function_escapes values ('exp', 'exp(%1)')
go
insert jdbc_function_escapes values ('floor', 'floor(%1)')
go
insert jdbc_function_escapes values ('log', 'log(%1)')
go
insert jdbc_function_escapes values ('log10', 'log10(%1)')
go
insert jdbc_function_escapes values ('pi', 'pi()')
go
insert jdbc_function_escapes values ('power', 'power(%1, %2)')
go
insert jdbc_function_escapes values ('radians', 'radians(%1)')
go
insert jdbc_function_escapes values ('rand', 'rand(%1)')
go
insert jdbc_function_escapes values ('round', 'round(%1, %2)')
go
insert jdbc_function_escapes values ('sign', 'sign(%1)')
go
insert jdbc_function_escapes values ('sin', 'sin(%1)')
go
insert jdbc_function_escapes values ('sqrt', 'sqrt(%1)')
go
insert jdbc_function_escapes values ('tan', 'tan(%1)')
go
insert jdbc_function_escapes values ('ascii', 'ascii(%1)')
go
insert jdbc_function_escapes values ('char', 'char(%1)')
go
insert jdbc_function_escapes values ('concat', '%1 + %2')
go
insert jdbc_function_escapes values ('difference', 'difference(%1, %2)')
go
insert jdbc_function_escapes values ('insert', 'stuff(%1, %2, %3, %4)')
go
insert jdbc_function_escapes values ('length', 'char_length(%1)')
go
insert jdbc_function_escapes values ('lcase', 'lower(%1)')
go
insert jdbc_function_escapes values ('ltrim', 'ltrim(%1)')
go
insert jdbc_function_escapes values ('repeat', 'replicate(%1, %2)')
go
insert jdbc_function_escapes values ('right', 'right(%1, %2)')
go
insert jdbc_function_escapes values ('rtrim', 'rtrim(%1)')
go
insert jdbc_function_escapes values ('soundex', 'soundex(%1)')
go
insert jdbc_function_escapes values ('space', 'space(%1)')
go
insert jdbc_function_escapes values ('substring', 'substring(%1, %2, %3)')
go
insert jdbc_function_escapes values ('ucase', 'upper(%1)')
go
insert jdbc_function_escapes values ('curdate', 'getdate()')
go
insert jdbc_function_escapes values ('curtime', 'getdate()')
go
insert jdbc_function_escapes values ('dayname', 'datename(dw, %1)')
go
insert jdbc_function_escapes values ('dayofmonth',  
    'datepart(dd, %1)')
go
insert jdbc_function_escapes values ('dayofweek',  
    'datepart(dw, %1)')
go
insert jdbc_function_escapes values ('dayofyear',  
    'datepart(dy, %1)')
go
insert jdbc_function_escapes values ('hour', 'datepart(hh, %1)')
go
insert jdbc_function_escapes values ('minute', 'datepart(mi, %1)')
go
insert jdbc_function_escapes values ('month', 'datepart(mm, %1)')
go
insert jdbc_function_escapes values ('monthname',     
    'datename(mm, %1)')
go
insert jdbc_function_escapes values ('now', 'getdate()')
go
insert jdbc_function_escapes values ('quarter', 'datepart(qq, %1)')
go
insert jdbc_function_escapes values ('second', 'datepart(ss, %1)')
go
insert jdbc_function_escapes values ('timestampaddsql_tsi_second',
'dateadd(ss, %2, %3)')
go
insert jdbc_function_escapes values ('timestampaddsql_tsi_minute',
'dateadd(mi, %2, %3)')
go
insert jdbc_function_escapes values ('timestampaddsql_tsi_hour',
'dateadd(hh, %2, %3)')
go
insert jdbc_function_escapes values ('timestampaddsql_tsi_day',
'dateadd(dd, %2, %3)')
go
insert jdbc_function_escapes values ('timestampaddsql_tsi_week',
'dateadd(wk, %2, %3)')
go
insert jdbc_function_escapes values ('timestampaddsql_tsi_month',
'dateadd(mm, %2, %3)')
go
insert jdbc_function_escapes values ('timestampaddsql_tsi_quarter',
'dateadd(qq, %2, %3)')
go
insert jdbc_function_escapes values ('timestampaddsql_tsi_year',
'dateadd(yy, %2, %3)')
go
insert jdbc_function_escapes values ('timestampdiffsql_tsi_second',
'datediff(ss, %2, %3)')
go
insert jdbc_function_escapes values ('timestampdiffsql_tsi_minute',
'datediff(mi, %2, %3)')
go
insert jdbc_function_escapes values ('timestampdiffsql_tsi_hour',
'datediff(hh, %2, %3)')
go
insert jdbc_function_escapes values ('timestampdiffsql_tsi_day',
'datediff(dd, %2, %3)')
go
insert jdbc_function_escapes values ('timestampdiffsql_tsi_week',
'datediff(wk, %2, %3)')
go
insert jdbc_function_escapes values ('timestampdiffsql_tsi_month',
'datediff(mm, %2, %3)')
go
insert jdbc_function_escapes values ('timestampdiffsql_tsi_quarter',
'datediff(qq, %2, %3)')
go
insert jdbc_function_escapes values ('timestampdiffsql_tsi_year',
'datediff(yy, %2, %3)')
go
insert jdbc_function_escapes values ('week', 'datepart(wk, %1)')
go
insert jdbc_function_escapes values ('year', 'datepart(yy, %1)')
go
insert jdbc_function_escapes values ('database', 'db_name()')
go
insert jdbc_function_escapes values ('ifnull', 'isnull(%1, %2)')
go
insert jdbc_function_escapes values ('user', 'user_name()')
go
insert jdbc_function_escapes values ('convertsql_binary',
'convert(varbinary(255), %1)')
go
insert jdbc_function_escapes values ('convertsql_bit',  
    'convert(bit, %1)')
go
insert jdbc_function_escapes values ('convertsql_char',
'convert(varchar(255), %1)')
go
insert jdbc_function_escapes values ('convertsql_date',
'convert(datetime, %1)')
go
insert jdbc_function_escapes values ('convertsql_decimal',
'convert(decimal(36, 18), %1)')
go
insert jdbc_function_escapes values ('convertsql_double',
'convert(float, %1)')
go
insert jdbc_function_escapes values ('convertsql_float',
'convert(float, %1)')
go
insert jdbc_function_escapes values ('convertsql_integer',
'convert(int, %1)')
go
insert jdbc_function_escapes values ('convertsql_longvarbinary',
'convert(varbinary(255), %1)')
go
insert jdbc_function_escapes values ('convertsql_longvarchar',
'convert(varchar(255), %1)')
go
insert jdbc_function_escapes values ('convertsql_real',
'convert(real, %1)')
go
insert jdbc_function_escapes values ('convertsql_smallint',
'convert(smallint, %1)')
go
insert jdbc_function_escapes values ('convertsql_time',
'convert(datetime, %1)')
go
insert jdbc_function_escapes values ('convertsql_timestamp',
'convert(datetime, %1)')
go
insert jdbc_function_escapes values ('convertsql_tinyint',
'convert(tinyint, %1)')
go
insert jdbc_function_escapes values ('convertsql_varbinary',
'convert(varbinary(255), %1)')
go
insert jdbc_function_escapes values ('convertsql_varchar',
'convert(varchar(255), %1)')
go

/*
**  End of jdbc_function_escapes
*/



/*
**  sp_jdbc_convert_datatype
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name = 'sp_jdbc_convert_datatype')
    begin
        drop procedure sp_jdbc_convert_datatype
    end
go
/** SECTION END: CLEANUP **/

create procedure sp_jdbc_convert_datatype (
@source int,
@destination int)
as

    if @@trancount = 0
    begin
    set chained off
    end
     
    set transaction isolation level 1

/* Make source non-negative */
select @source = @source + 7
/* Put the strange date numbers into this area between 0-19*/
if (@source > 90)
select @source = @source - 82

/*Convert destination the same way*/
/* Put the strange date numbers into this area between 0-19*/
if (@destination > 90)
select @destination = @destination - 82

/* Need 8 added instead of 7 because substring starts at 1 instead */
/* of 0 */
select @destination = @destination + 8

/* Check the conversion. If the bit string in the table has a 1  
** on the place's number of the destination's value we have to  
** return true, else false
*/
if ((select substring(conversion,@destination,1)
        from master.dbo.spt_jdbc_conversion
        where datatype = @source) = '1')

select 1
else  
select 0
go

exec sp_procxmode 'sp_jdbc_convert_datatype', 'anymode'
go

grant execute on sp_jdbc_convert_datatype to public
go

commit
go

/*
**  End of sp_jdbc_convert_datatype
*/


/*
**  sp_jdbc_function_escapes
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name =
    'sp_jdbc_function_escapes')
    begin
        drop procedure sp_jdbc_function_escapes
    end
go
/** SECTION END: CLEANUP **/

create procedure sp_jdbc_function_escapes
as

    if @@trancount = 0
    begin
    set chained off
    end
     
    set transaction isolation level 1

    select *  
    from master.dbo.jdbc_function_escapes

go

exec sp_procxmode 'sp_jdbc_function_escapes', 'anymode'
go

grant execute on sp_jdbc_function_escapes to public
go

/*
**  End of sp_jdbc_function_escapes
*/



/*
**  sp_jdbc_fkeys
*/

/* The following code is taken from the ODBC handling of  
 * primary keys, and foreign keys, and modified slightly  
 * for JDBC compliance.
 * ODBC sp_fkeys --> sp_jdbc_fkeys
 *      sp_pkeys --> sp_jdbc_pkeys
 *      #pid     --> #jpid
 *      #fid     --> #fid
 */


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select *
        from sysobjects
                where sysstat & 7 = 4
                        and name = 'sp_jdbc_fkeys')
begin
        drop procedure sp_jdbc_fkeys
end
go
/** SECTION END: CLEANUP **/

/*
** parameters: @pktable_name - table name for primary key
**             @pktable_owner - (schema) a schema name pattern; "" retrieves  
** those without a schema
**             @pktable_qualifier - (catalog name) a catalog name; "" retrieves
**              those without a catalog; null means drop catalog name from the
**                  selection criteria  
**             @fktable_name - table name for foreign key
**             @fktable_owner - (schema) a schema name pattern; "" retrieves  
** those  without a schema
**             @fktable_qualifier - (catalog name) a catalog name; "" retrieves
**              those without a catalog; null means drop catalog name from the
**              selection criteria  
**
** note: there is one raiserror message: 18040
**
** messages for 'sp_jdbc_fkeys'               18039, 18040
**
** 17461, 'Object does not exist in this database.'
** 18040, 'Catalog procedure %1! can not be run in a transaction.', sp_jdbc_fkeys
** 18043 ' Primary key table name or foreign key table name or both must be
** given'
** 18044, '%1! table qualifier must be name of current database.' [Primary
** key | Foreign key]
**
*/

CREATE PROCEDURE sp_jdbc_fkeys
    @pktable_name       varchar(64) = null,
    @pktable_owner      varchar(32) = null,
    @pktable_qualifier  varchar(32) = null,
    @fktable_name       varchar(64) = null,
    @fktable_owner      varchar(32) = null,
    @fktable_qualifier  varchar(32) = null
as
    declare @ftabid int, @ptabid int, @constrid int, @keycnt int, @primkey int
    declare @fokey1 int, @fokey2 int,  @fokey3 int,  @fokey4 int, @fokey5  int
    declare @fokey6 int, @fokey7 int,  @fokey8 int,  @fokey9 int, @fokey10 int
    declare @fokey11 int,@fokey12 int, @fokey13 int, @fokey14 int,@fokey15 int
    declare @refkey1 int,@refkey2 int, @refkey3 int, @refkey4 int,@refkey5  int
    declare @refkey6 int,@refkey7 int, @refkey8 int, @refkey9 int,@refkey10 int
    declare @refkey11 int, @refkey12 int, @refkey13 int, @refkey14 int
    declare @refkey15 int, @refkey16 int, @fokey16 int, @status int, @i int
    declare @msg varchar(255)
    declare @msg2 varchar(50)
    declare @export int, @import int
    declare @notDeferrable int   
    select @notDeferrable = 7        
    select @import = 0
    select @export = 0
     
    /* if table_owner is null, include all in search */
    if (@fktable_owner is null) select @fktable_owner = '%'
    if (@pktable_owner is null) select @pktable_owner = '%'

    set nocount on
     
    if (@@trancount = 0)
    begin
        set chained off
    end
    else
    begin
        /* if inside a transaction */
        /* catalog procedure sp_jdbc_fkeys can not be run in a transaction.*/
        exec sp_getmessage 18040, @msg output
        raiserror 18040 @msg, 'sp_fkeys'
        return (1)
    end

    set transaction isolation level 1

    if (@pktable_name is null) and (@fktable_name is null)
    begin
        /* If neither primary key nor foreign key table names given */
        /*
        ** 18043 'Primary key table name or foreign key table name
        ** or both must be given'
        */
        exec  sp_getmessage 18043, @msg output
        raiserror 18043 @msg
        return (1)
    end
else
begin
if (substring(@pktable_name,1,1)= '#') or 
           (substring(@fktable_name,1,1)='#')   
begin
/* We won't allow temptables here
**  
** Error 177: cannot create a temporary object (with
** '#' as the first character name.
*/
exec sp_getmessage 17676, @msg out
raiserror 17676 @msg
return(1)
end
end
    if @fktable_qualifier is not null
    begin
        if db_name() != @fktable_qualifier
        begin
            exec sp_getmessage 18039, @msg out
            raiserror 18039 @msg
            return (1)
        end
    end
    else
    begin
        /*
        ** Now make sure that foreign table qualifier is pointing to the
        ** current database in case it is not specified.
        */
        select @fktable_qualifier = db_name()
    end

    if @pktable_qualifier is not null
    begin
        if db_name() != @pktable_qualifier
        begin
            exec sp_getmessage 18039, @msg output
            raiserror 18039 @msg
            return (1)
        end
    end
    else
    begin
        /*
        ** Now make sure that primary table qualifier is pointing to the
        ** current database in case it is not specified.
        */
        select @pktable_qualifier = db_name()
    end

    create table #jpid (pid int, uid smallint, name varchar(30))
    create table #jfid (fid int, uid smallint, name varchar(30))

    if @pktable_name is not null
    begin
select @export = 1
if ((select count(*) from sysobjects  
            where name = @pktable_name
            and user_name(uid) like @pktable_owner ESCAPE '\'
            and type in ('S', 'U')) = 0)
        begin
            exec sp_getmessage 17674, @msg output
            raiserror 17674 @msg
            return (1)
        end
         
        insert into #jpid
        select id, uid, name
        from sysobjects
        where name = @pktable_name
        and user_name(uid) like @pktable_owner ESCAPE '\'
        and type in ('S', 'U')
    end
    else
    begin
        insert into #jpid
        select id, uid, name
        from sysobjects  
        where type in ('S', 'U')
        and user_name(uid) like @pktable_owner ESCAPE '\'
    end

    if @fktable_name is not null
    begin
        select @import = 1
        if ((select count(*)
            from sysobjects
            where name = @fktable_name
            and type in ('S', 'U')
            and user_name(uid) like @fktable_owner ESCAPE '\') = 0)
        begin
            exec sp_getmessage 17674, @msg output
            raiserror 17674 @msg
            return (1)
        end
        insert into #jfid
        select id, uid, name
            from sysobjects
            where name = @fktable_name
            and type in ('S', 'U')
            and user_name(uid) like @fktable_owner ESCAPE '\'
    end
    else
    begin
        insert into #jfid
        select id, uid, name
            from sysobjects where
            type in ('S', 'U')
            and user_name(uid) like @fktable_owner ESCAPE '\'
    end

    create table #jfkey_res(  
        pktable_qualifier  varchar(32) null,
        pktable_owner      varchar(32) null,
        pktable_name       varchar(32) null,
        pkcolumn_name      varchar(32) null,
        fktable_qualifier  varchar(32) null,
        fktable_owner      varchar(32) null,
        fktable_name       varchar(32) null,
        fkcolumn_name      varchar(32) null,
        key_seq            smallint,
        update_rule        smallint,
        delete_rule        smallint,
        constrid           varchar(32),
        primkey            varchar(32) null)
    create table #jpkeys(seq int, keys varchar(30) null)
    create table #jfkeys(seq int, keys varchar(30) null)

    /*
    ** Since there are possibly multiple rows in sysreferences
    ** that describe foreign and primary key relationships among
    ** two tables, so we declare a cursor on the selection from
    ** sysreferences and process the output at row by row basis.
    */

    declare jcurs_sysreferences cursor
        for
        select tableid, reftabid, constrid, keycnt,
            fokey1, fokey2, fokey3, fokey4, fokey5, fokey6, fokey7, fokey8,
            fokey9, fokey10, fokey11, fokey12, fokey13, fokey14, fokey15,
            fokey16, refkey1, refkey2, refkey3, refkey4, refkey5,
            refkey6, refkey7, refkey8, refkey9, refkey10, refkey11,
            refkey12, refkey13, refkey14, refkey15, refkey16
            from sysreferences
            where tableid in (
                    select fid from #jfid)
            and reftabid in (
                    select pid from #jpid)
            and frgndbname is NULL and pmrydbname is NULL
            for read only

    open  jcurs_sysreferences

    fetch  jcurs_sysreferences into @ftabid, @ptabid, @constrid, @keycnt,
        @fokey1, @fokey2, @fokey3,  @fokey4, @fokey5, @fokey6, @fokey7, @fokey8,
        @fokey9, @fokey10, @fokey11, @fokey12, @fokey13, @fokey14, @fokey15,
        @fokey16, @refkey1, @refkey2, @refkey3, @refkey4, @refkey5, @refkey6,
        @refkey7, @refkey8, @refkey9, @refkey10, @refkey11, @refkey12,
        @refkey13, @refkey14, @refkey15, @refkey16

    while (@@sqlstatus = 0)
    begin
        /*
        ** For each row of sysreferences which describes a foreign-
        ** primary key relationship, do the following.
        */
         
        /*
        ** First store the column names that belong to primary keys
        ** in table #pkeys for later retrieval.
        */
         
        delete #jpkeys
        insert #jpkeys values(1, col_name(@ptabid,@refkey1))
        insert #jpkeys values(2, col_name(@ptabid,@refkey2))
        insert #jpkeys values(3, col_name(@ptabid,@refkey3))
        insert #jpkeys values(4, col_name(@ptabid,@refkey4))
        insert #jpkeys values(5, col_name(@ptabid,@refkey5))
        insert #jpkeys values(6, col_name(@ptabid,@refkey6))
        insert #jpkeys values(7, col_name(@ptabid,@refkey7))
        insert #jpkeys values(8, col_name(@ptabid,@refkey8))
        insert #jpkeys values(9, col_name(@ptabid,@refkey9))
        insert #jpkeys values(10, col_name(@ptabid,@refkey10))
        insert #jpkeys values(11, col_name(@ptabid,@refkey11))
        insert #jpkeys values(12, col_name(@ptabid,@refkey12))
        insert #jpkeys values(13, col_name(@ptabid,@refkey13))
        insert #jpkeys values(14, col_name(@ptabid,@refkey14))
        insert #jpkeys values(15, col_name(@ptabid,@refkey15))
        insert #jpkeys values(16, col_name(@ptabid,@refkey16))
         
        /*
        ** Second store the column names that belong to foreign keys
        ** in table #jfkeys for later retrieval.
        */
         
        delete #jfkeys
        insert #jfkeys values(1, col_name(@ftabid,@fokey1))
        insert #jfkeys values(2, col_name(@ftabid,@fokey2))
        insert #jfkeys values(3, col_name(@ftabid,@fokey3))
        insert #jfkeys values(4, col_name(@ftabid,@fokey4))
        insert #jfkeys values(5, col_name(@ftabid,@fokey5))
        insert #jfkeys values(6, col_name(@ftabid,@fokey6))
        insert #jfkeys values(7, col_name(@ftabid,@fokey7))
        insert #jfkeys values(8, col_name(@ftabid,@fokey8))
        insert #jfkeys values(9, col_name(@ftabid,@fokey9))
        insert #jfkeys values(10, col_name(@ftabid,@fokey10))
        insert #jfkeys values(11, col_name(@ftabid,@fokey11))
        insert #jfkeys values(12, col_name(@ftabid,@fokey12))
        insert #jfkeys values(13, col_name(@ftabid,@fokey13))
        insert #jfkeys values(14, col_name(@ftabid,@fokey14))
        insert #jfkeys values(15, col_name(@ftabid,@fokey15))
        insert #jfkeys values(16, col_name(@ftabid,@fokey16))
         
        /*
        ** For each column of the current foreign-primary key relation,
        ** create a row into result table: #jfkey_res.
        */
         
        select @i = 1
        while (@i <= @keycnt)
        begin
            insert into #jfkey_res
                select @pktable_qualifier,
                (select user_name(uid) from #jpid where  
                    pid = @ptabid),
                object_name(@ptabid),  
                (select keys from #jpkeys where seq = @i),
                    @fktable_qualifier,
                (select user_name(uid) from #jfid where  
                    fid = @ftabid),
                object_name(@ftabid),
                (select keys from #jfkeys where seq = @i),  
                @i, 1, 1,
                /*Foreign key name*/  
                object_name(@constrid),
                /* Primary key name */
                (select name from sysindexes where id = @ftabid
                    and status > 2048 and status < 32768)
            select @i = @i + 1
        end
         
        /*
        ** Go to the next foreign-primary key relationship if any.
        */
         
        fetch  jcurs_sysreferences into @ftabid, @ptabid, @constrid,  
            @keycnt,@fokey1, @fokey2, @fokey3,  @fokey4, @fokey5, @fokey6,  
            @fokey7, @fokey8, @fokey9, @fokey10, @fokey11, @fokey12,  
            @fokey13, @fokey14, @fokey15, @fokey16, @refkey1, @refkey2,  
            @refkey3, @refkey4, @refkey5, @refkey6, @refkey7, @refkey8,  
            @refkey9, @refkey10, @refkey11, @refkey12, @refkey13, @refkey14,
            @refkey15, @refkey16
    end

    close jcurs_sysreferences
    deallocate cursor jcurs_sysreferences

    /*
    ** Everything is now in the result table #jfkey_res, so go ahead
    ** and select from the table now.
    */
    if (@export = 1) and (@import = 0)
    begin
       select pktable_qualifier as PKTABLE_CAT,
           pktable_owner as PKTABLE_SCHEM,
           pktable_name as PKTABLE_NAME,
           pkcolumn_name as PKCOLUMN_NAME,
           fktable_qualifier as FKTABLE_CAT,  
           fktable_owner as FKTABLE_SCHEM,  
           fktable_name as FKTABLE_NAME,  
           fkcolumn_name as FKCOLUMN_NAME,
           key_seq as KEY_SEQ,  
           update_rule as UPDATE_RULE,  
           delete_rule as DELETE_RULE,
           constrid as FK_NAME,
           primkey as PK_NAME,  
           @notDeferrable  as DEFERRABILITY
      from #jfkey_res  
      where pktable_owner like @pktable_owner ESCAPE '\'
      order by fktable_name,fktable_owner,key_seq, fktable_qualifier
    end

    if (@export = 0) and (@import = 1)
    begin
        select pktable_qualifier as PKTABLE_CAT,
            pktable_owner as PKTABLE_SCHEM,
            pktable_name as PKTABLE_NAME,
            pkcolumn_name as PKCOLUMN_NAME,
            fktable_qualifier as FKTABLE_CAT,  
            fktable_owner as FKTABLE_SCHEM,  
            fktable_name as FKTABLE_NAME,  
            fkcolumn_name as FKCOLUMN_NAME,
            key_seq as KEY_SEQ,  
            update_rule as UPDATE_RULE,  
            delete_rule as DELETE_RULE,
            constrid as FK_NAME,
            primkey as PK_NAME,  
            @notDeferrable  as DEFERRABILITY
        from #jfkey_res  
        where fktable_owner like @fktable_owner ESCAPE '\'
        order by fktable_name,fktable_owner,key_seq, fktable_qualifier
    end

    if (@export = 1) and (@import = 1)
    begin
        select pktable_qualifier as PKTABLE_CAT,
           pktable_owner as PKTABLE_SCHEM,
           pktable_name as PKTABLE_NAME,
           pkcolumn_name as PKCOLUMN_NAME,
           fktable_qualifier as FKTABLE_CAT,  
           fktable_owner as FKTABLE_SCHEM,  
           fktable_name as FKTABLE_NAME,  
           fkcolumn_name as FKCOLUMN_NAME,
           key_seq as KEY_SEQ,  
           update_rule as UPDATE_RULE,  
           delete_rule as DELETE_RULE,
           constrid as FK_NAME,
           primkey as PK_NAME,  
           @notDeferrable  as DEFERRABILITY
        from #jfkey_res  
        where pktable_owner like @pktable_owner ESCAPE '\'
        and fktable_owner like @fktable_owner ESCAPE '\'
        order by fktable_name,fktable_owner,key_seq, fktable_qualifier
    end
        
go

/*
**  End of sp_jdbc_fkeys
*/


/*  
**  sp_jdbc_exportkey
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name =
    'sp_jdbc_exportkey')
    begin
        drop procedure sp_jdbc_exportkey
    end
go
/** SECTION END: CLEANUP **/


CREATE PROCEDURE sp_jdbc_exportkey (
@table_qualifier varchar(32) = null,
@table_owner varchar(32) = null,
@table_name varchar(32))
as
    exec sp_jdbc_fkeys  
        @table_name, @table_owner, @table_qualifier, NULL, NULL, NULL
go
exec sp_procxmode 'sp_jdbc_exportkey', 'anymode'
go

grant execute on sp_jdbc_exportkey to public
go

/*  
**  End of sp_jdbc_exportkey
*/


/*  
** sp_jdbc_importkey
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name =
    'sp_jdbc_importkey')
    begin
        drop procedure sp_jdbc_importkey
    end
go
/** SECTION END: CLEANUP **/

CREATE PROCEDURE sp_jdbc_importkey (
@table_qualifier varchar(32) = null,
@table_owner varchar(32) = null,
@table_name varchar(32))
as
    exec sp_jdbc_fkeys
        NULL, NULL, NULL, @table_name, @table_owner, @table_qualifier
go

exec sp_procxmode 'sp_jdbc_importkey', 'anymode'
go

grant execute on sp_jdbc_importkey to public
go

/*  
** End of sp_jdbc_importkey
*/



/*
**  sp_jdbc_getcrossreferences
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects
where name = 'sp_jdbc_getcrossreferences')
begin
drop procedure sp_jdbc_getcrossreferences
end
go
/** SECTION END: CLEANUP **/


CREATE PROCEDURE sp_jdbc_getcrossreferences
   @pktable_qualifier varchar(32) = null,
   @pktable_owner varchar(32) = null,
   @pktable_name varchar(32),
   @fktable_qualifier varchar(32) = null ,
   @fktable_owner varchar(32) = null,
   @fktable_name varchar(32)
as
exec sp_jdbc_fkeys  
        @pktable_name, @pktable_owner, @pktable_qualifier,
        @fktable_name, @fktable_owner, @fktable_qualifier
go

exec sp_procxmode 'sp_jdbc_getcrossreferences', 'anymode'
go
grant execute on sp_jdbc_getcrossreferences to public
go
commit
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_getcrossreferences
*/


/*  
**  sp_jdbc_getschemas
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name = 'sp_jdbc_getschemas')
    begin
        drop procedure sp_jdbc_getschemas
    end
go
/** SECTION END: CLEANUP **/


CREATE PROCEDURE sp_jdbc_getschemas  
as

    if @@trancount = 0
    begin
    set chained off
    end
     
    set transaction isolation level 1

    select TABLE_SCHEM=name  from sysusers where suid >= -2 order by name
go

exec sp_procxmode 'sp_jdbc_getschemas', 'anymode'
go

grant execute on sp_jdbc_getschemas to public
go

commit  
go
dump transaction sybsystemprocs with truncate_only  
go

/*  
**  End of sp_jdbc_getschemas
*/

/*
**  sp_jdbc_getcolumnprivileges  
*/

use sybsystemprocs  
go

if exists (select * from sysobjects where name = 'sp_jdbc_getcolumnprivileges')
    begin
        drop procedure sp_jdbc_getcolumnprivileges
    end
go
/** SECTION END: CLEANUP **/

create procedure sp_jdbc_getcolumnprivileges (
    @table_qualifier varchar(32) = null,
    @table_owner varchar(32) = null,
    @table_name varchar(64)= null,
    @column_name varchar(32) = null)
as         
    declare @max_uid smallint         
    declare @grantor_name varchar (32)     
    declare @grantee_name varchar (32)     
    declare @col_count smallint         
    declare @grantee    smallint 
    declare @action tinyint 
    declare @columns varbinary (32) 
    declare @protecttype tinyint 
    declare @grantor    smallint 
    declare @grp_id smallint 
    declare @grant_type tinyint 
    declare @revoke_type tinyint 
    declare @select_action tinyint 
    declare @update_action tinyint 
    declare @reference_action tinyint 
    declare @insert_action tinyint 
    declare @delete_action tinyint 
    declare @public_select varbinary (32)   
    declare @public_reference varbinary (32) 
    declare @public_update varbinary (32) 
    declare @public_insert tinyint 
    declare @public_delete tinyint 
    declare @grp_select varbinary (32)   
    declare @grp_update varbinary (32)   
    declare @grp_reference varbinary (32)   
    declare @grp_delete tinyint 
    declare @grp_insert tinyint 
    declare @inherit_select varbinary (32) 
    declare @inherit_update varbinary (32)   
    declare @inherit_reference varbinary (32)   
    declare @inherit_insert tinyint 
    declare @inherit_delete tinyint 
    declare @select_go varbinary (32) 
    declare @update_go varbinary (32) 
    declare @reference_go varbinary (32) 
    declare @insert_go tinyint 
    declare @delete_go tinyint 
    declare @prev_grantor tinyint 
    declare @col_pos tinyint 
    declare @owner_id smallint 
    declare @dbid smallint 
    declare @grantable varchar (3) 
    declare @is_printable tinyint 
    declare @curr_column varchar (32)     
    declare @save_column_name varchar(32)
    declare @msg             varchar (255)
    declare @actual_table_name varchar(64)
    declare @searchstr       char(3)
    declare @tab_id          int

    select @grant_type = 1
    select @revoke_type = 2
    select @select_action = 193
    select @reference_action = 151
    select @update_action = 197
    select @delete_action = 196
    select @insert_action = 195
    select @max_uid = 16383
    select @dbid = db_id()
    select @searchstr = 'SUV' /* Only search for SYSTEM USER and VIEW tables */

    set nocount on
    if @@trancount = 0
    begin
           set chained off
    end
    else
    begin
         /* we are inside a transaction. catalog procedure sp_column privileges
         ** can't be run inside a transaction  
         */
         exec sp_getmessage 18040, @msg  output
         raiserror 18040, @msg, 'sp_column_privileges'
         return (1)
    end
  
    set transaction isolation level 1
  
    /*  If this is a temporary table; object does not belong to  
    **  this database; (we should be in the tempdb)
    */
    if (@table_name like '#%' and db_name() != 'tempdb')
    begin
        /*  
        ** 17676, 'This may be a temporary object. Please execute  
        ** procedure from tempdb.'
        */
        exec sp_getmessage 17676, @msg out
        raiserror 17676 @msg
        return (1)
    end
  
    /*
    ** The table_qualifier should be same as the database name. Do the sanity  
    ** check if it is specified
    */
    if (@table_qualifier is null) or (@table_qualifier = '')
        /* set the table qualifier name */
        select @table_qualifier = db_name ()
    else
    begin
        if db_name() != @table_qualifier
        begin
             exec sp_getmessage 18039, @msg out
             raiserror 18039 @msg
             return (1)
        end
    end
    
    /*  
    ** if the table owner is not specified, it will be taken as the id of the
    ** user executing this procedure. Otherwise find the explicit table name  
    ** prefixed by the owner id
    */
     
    /*
    ** NOTE: SQL Server allows an underscore '_' in the table owner, even  
    **       though '_' is a single character wildcard.
    */
    if (charindex('%',@table_owner) > 0)
begin
  exec sp_getmessage 17993, @msg output
  raiserror 17993 @msg, @table_owner
  return(1)
end

    if (@table_owner is null)
    begin
        exec sp_getmessage 17993, @msg output
raiserror 17993 @msg, 'NULL'
return(1)
    end
    else
    begin
        exec sp_jdbc_escapeliteralforlike @table_owner output
    end

    if (@table_name is null)  
begin
  exec sp_getmessage 17993, @msg output
  raiserror 17993 @msg, 'NULL'
  return(1)
end

    select @actual_table_name = @table_name
    exec sp_jdbc_escapeliteralforlike @table_name output

     
    if (select count(*) from sysobjects  
        where user_name(uid) like @table_owner ESCAPE '\'
        and name like @table_name ESCAPE '\'
        AND charindex(substring(type,1,1),@searchstr) != 0
        ) = 0
    begin
        exec sp_getmessage 17674, @msg output
        raiserror 17674 @msg
        return 1
    end

    create table #sysprotects
(uid smallint,
action tinyint,
protecttype tinyint,
columns varbinary (32) NULL,
grantor smallint)

/*
** This table contains all the groups including PUBLIC that users, who
** have been granted privilege on this table, belong to. Also it includes
** groups that have been explicitly granted privileges on the table object
*/
    create table #useful_groups
(grp_id smallint)

/*
** create a table that contains the list of grantors for the object requested.
** We will do a cartesian product of this table with sysusers in the
** current database to capture all grantor/grantee tuples
*/

    create table #distinct_grantors
(grantor smallint)

/*
** We need to create a table which will contain a row for every object
** privilege to be returned to the client.   
*/

    create table #column_privileges  
(grantee_gid smallint,
grantor smallint,
grantee smallint,
insertpriv tinyint,
insert_go tinyint NULL,
deletepriv tinyint,
delete_go tinyint NULL,
selectpriv varbinary (32) NULL,
select_go varbinary (32) NULL,
updatepriv varbinary (32) NULL,
update_go varbinary (32) NULL,
referencepriv varbinary (32) NULL,
reference_go varbinary (32) NULL)

/*
** Results Table
*/
    create table #results_table
(table_qualifier varchar (32),
  table_owner varchar (32),
  table_name varchar (32),
  column_name varchar (32) NULL,
  grantor varchar (32),
  grantee varchar (32),
  privilege varchar (32),
  is_grantable varchar (3))
/*
** this cursor scans the distinct grantor, group_id pairs
*/
    declare grp_cursor cursor for
select distinct grp_id, grantor  
from #useful_groups, #distinct_grantors
order by grantor

/*  
** this cursor scans all the protection tuples that represent
** grant/revokes to users only
*/
    declare user_protect cursor for
select uid, action, protecttype, columns, grantor
from   #sysprotects
where  (uid > 0) and
       (uid <= @max_uid)


/*
** this cursor is used to scan #column_privileges table to output results
*/
    declare col_priv_cursor cursor for
        select grantor, grantee, insertpriv, insert_go, deletepriv, delete_go,
    selectpriv, select_go, updatepriv, update_go, referencepriv,  
            reference_go
from #column_privileges

    DECLARE jcurs_tab_id CURSOR FOR
select id from sysobjects  
        where user_name(uid) like @table_owner ESCAPE '\'
        and name like @table_name ESCAPE '\'
        and (charindex(substring(type,1,1),@searchstr) != 0)

    OPEN  jcurs_tab_id

    FETCH jcurs_tab_id INTO @tab_id

    while (@@sqlstatus = 0)
    begin
        if @column_name is null
            select @column_name = '%'
        else
        begin
            if not exists (select * from syscolumns
               where (id = @tab_id) and (name like @column_name ESCAPE '\' ))
            begin
                exec sp_getmessage 17563, @msg output
                raiserror 17563 @msg, @column_name
                return (1)
            end
        end                      
        select @save_column_name = @column_name
        /*  
        ** compute the table owner id
        */
     
        select @owner_id = uid
        from   sysobjects
        where  id = @tab_id
      
        /*
        ** get table owner name
        */
     
        select @table_owner = name  
        from sysusers  
        where uid = @owner_id
/*
** column count is needed for privilege bit-map manipulation
*/
    select @col_count = count (*)  
    from   syscolumns
    where  id = @tab_id


/*  
** populate the temporary sysprotects table #sysprotects
*/
insert into #sysprotects  
       select uid, action, protecttype, columns, grantor
    from sysprotects 
            where (id = @tab_id) and ((action = @select_action) or
(action = @update_action) or (action = @reference_action) or
  (action = @insert_action) or (action = @delete_action))
/*  
** insert privilege tuples for the table owner. There is no explicit grants
** of these privileges to the owner. So these tuples are not there in  
** sysprotects table
*/
    insert into #sysprotects  
        values (@owner_id, @select_action, 0, 0x01, @owner_id)
    insert into #sysprotects
values (@owner_id, @update_action, 0, 0x01, @owner_id)
    insert into #sysprotects  
        values (@owner_id, @reference_action, 0, 0x01, @owner_id)
    insert into #sysprotects
values (@owner_id, @insert_action, 0, 0x00, @owner_id)
    insert into #sysprotects
values (@owner_id, @delete_action, 0, 0x00, @owner_id)
/*  
** populate the #distinct_grantors table with all grantors that have granted
** the privilege to users or to gid or to public on the table_name
*/
    insert into #distinct_grantors  
        select distinct grantor from #sysprotects
/*  
** Populate the #column_privilegs table as a cartesian product of the table
** #distinct_grantors and all the users, other than groups, in the current  
** database
*/


    insert into #column_privileges
        select gid, g.grantor, su.uid, 0, 0, 0, 0, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00
from sysusers su, #distinct_grantors g
where (su.uid > 0) and
    (su.uid <= @max_uid)
/*
** populate #useful_groups with only those groups whose members have been  
** granted/revoked privilges on the @tab_id in the current database. It also  
** contains those groups that have been granted/revoked privileges explicitly
*/
    insert into #useful_groups
select distinct gid
from   sysusers su, #sysprotects sp
where  (su.uid = sp.uid)  

    open grp_cursor
    fetch grp_cursor into @grp_id, @grantor

    /*  
    ** This loop computes all the inherited privilegs of users due
    ** their membership in a group
    */

    while (@@sqlstatus != 2)
    begin

/*  
** initialize variables  
*/
select @public_select = 0x00
  select @public_update = 0x00
select @public_reference = 0x00
select @public_delete = 0
select @public_insert = 0


/* get the select privileges granted to PUBLIC */

if (exists (select * from #sysprotects  
       where (grantor = @grantor) and  
   (uid = 0) and
   (action = @select_action)))
begin
      /* note there can't be any revoke row for PUBLIC */
      select @public_select = columns
      from #sysprotects
      where (grantor = @grantor) and  
    (uid = 0) and
    (action = @select_action)
         end


/* get the update privilege granted to public */
if (exists (select * from #sysprotects  
       where (grantor = @grantor) and  
   (uid = 0) and
   (action = @update_action)))
begin
      /* note there can't be any revoke row for PUBLIC */
      select @public_update = columns
      from #sysprotects
      where (grantor = @grantor) and  
    (uid = 0) and
    (action = @update_action)
         end

/* get the reference privileges granted to public */
if (exists (select * from #sysprotects  
       where (grantor = @grantor) and  
   (uid = 0) and
   (action = @reference_action)))
begin
      /* note there can't be any revoke row for PUBLIC */
      select @public_reference = columns
      from #sysprotects
      where (grantor = @grantor) and  
    (uid = 0) and
    (action = @reference_action)
         end


/* get the delete privilege granted to public */
if (exists (select * from #sysprotects  
       where (grantor = @grantor) and  
   (uid = 0) and
   (action = @delete_action)))
begin
      /* note there can't be any revoke row for PUBLIC */
      select @public_delete = 1
         end

/* get the insert privileges granted to public */
if (exists (select * from #sysprotects  
       where (grantor = @grantor) and  
   (uid = 0) and
   (action = @insert_action)))
begin
      /* note there can't be any revoke row for PUBLIC */
      select @public_insert = 1
         end


/*
** initialize group privileges  
*/

select @grp_select = 0x00
select @grp_update = 0x00
select @grp_reference = 0x00
select @grp_insert = 0
select @grp_delete = 0

/*  
** if the group id is other than PUBLIC, we need to find the grants to
** the group also  
*/

if (@grp_id <> 0)
begin
/* find select privilege granted to group */
if (exists (select * from #sysprotects  
              where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @grant_type) and
          (action = @select_action)))
begin
      select @grp_select = columns
      from #sysprotects
      where (grantor = @grantor) and  
         (uid = @grp_id) and
      (protecttype = @grant_type) and  
          (action = @select_action)
                end

/* find update privileges granted to group */
if (exists (select * from #sysprotects  
              where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @grant_type) and
          (action = @update_action)))
begin
      select @grp_update = columns
      from #sysprotects
      where (grantor = @grantor) and  
         (uid = @grp_id) and
      (protecttype = @grant_type) and  
          (action = @update_action)
                end

/* find reference privileges granted to group */
if (exists (select * from #sysprotects  
              where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @grant_type) and
          (action = @reference_action)))
begin
      select @grp_reference = columns
      from #sysprotects
      where (grantor = @grantor) and  
         (uid = @grp_id) and
      (protecttype = @grant_type) and  
          (action = @reference_action)
                end

/* find delete privileges granted to group */
if (exists (select * from #sysprotects  
              where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @grant_type) and
          (action = @delete_action)))
begin

      select @grp_delete = 1
                end

/* find insert privilege granted to group */
if (exists (select * from #sysprotects  
              where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @grant_type) and
          (action = @insert_action)))
begin

      select @grp_insert = 1

                end

end

/* at this stage we have computed all the grants to PUBLIC as well as
** the group by a specific grantor that we are interested in. Now we will
** use this info to compute the overall inherited privilegs by the users
** due to their membership to the group or to PUBLIC  
*/

exec sybsystemprocs.dbo.syb_aux_privunion @public_select, @grp_select,
     @col_count, @inherit_select output
exec sybsystemprocs.dbo.syb_aux_privunion @public_update, @grp_update,
             @col_count, @inherit_update output
exec sybsystemprocs.dbo.syb_aux_privunion @public_reference,  
             @grp_reference, @col_count, @inherit_reference output

select @inherit_insert = @public_insert + @grp_insert
select @inherit_delete = @public_delete + @grp_delete

/*
** initialize group privileges to store revokes
*/

select @grp_select = 0x00
select @grp_update = 0x00
select @grp_reference = 0x00
select @grp_insert = 0
select @grp_delete = 0

         /*  
** now we need to find if there are any revokes on the group under
  ** consideration. We will subtract all privileges that are revoked   
** from the group from the inherited privileges
*/

if (@grp_id <> 0)
begin
     /* check if there is a revoke row for select privilege*/
     if (exists (select * from #sysprotects  
                   where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @revoke_type) and
          (action = @select_action)))
     begin
      select @grp_select = columns
      from #sysprotects
      where (grantor = @grantor) and  
         (uid = @grp_id) and
      (protecttype = @revoke_type) and  
          (action = @select_action)
             end
/* check if there is a revoke row for update privileges */
       if (exists (select * from #sysprotects  
           where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @revoke_type) and
          (action = @update_action)))
     begin
      select @grp_update = columns
      from #sysprotects
      where (grantor = @grantor) and  
         (uid = @grp_id) and
      (protecttype = @revoke_type) and  
          (action = @update_action)
             end

     /* check if there is a revoke row for reference privilege */
     if (exists (select * from #sysprotects  
           where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @revoke_type) and
          (action = @reference_action)))
     begin
       select @grp_reference = columns
      from #sysprotects
      where (grantor = @grantor) and  
         (uid = @grp_id) and
      (protecttype = @revoke_type) and  
          (action = @reference_action)
             end

/* check if there is a revoke row for delete privilege */
     if (exists (select * from #sysprotects  
           where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @revoke_type) and
          (action = @delete_action)))
     begin
      select @grp_delete = 1
             end

/* check if there is a revoke row for insert privilege */
     if (exists (select * from #sysprotects  
           where (grantor = @grantor) and  
          (uid = @grp_id) and
  (protecttype = @revoke_type) and
          (action = @insert_action)))
     begin
       select @grp_insert = 1
             end


/*  
** now subtract the revoked privileges from the group
*/

       exec sybsystemprocs.dbo.syb_aux_privexor @inherit_select,
@grp_select, @col_count, @inherit_select output

     exec sybsystemprocs.dbo.syb_aux_privexor @inherit_update,
        @grp_update, @col_count, @inherit_update output

       exec sybsystemprocs.dbo.syb_aux_privexor @inherit_reference,
        @grp_reference, @col_count, @inherit_reference output

     if (@grp_delete = 1)
select @inherit_delete = 0

     if (@grp_insert = 1)
select @inherit_insert = 0

end

/*
** now update all the tuples in #column_privileges table for this
** grantor and group id
*/

update #column_privileges
set
insertpriv = @inherit_insert,
deletepriv = @inherit_delete,
        selectpriv = @inherit_select,
updatepriv = @inherit_update,
referencepriv = @inherit_reference
where (grantor     = @grantor) and
       (grantee_gid = @grp_id)

/*
** the following update updates the privileges for those users
** whose groups have not been explicitly granted privileges by the
** grantor. So they will all have all the privileges of the PUBLIC
** that were granted by the current grantor
*/

select @prev_grantor = @grantor   
         fetch grp_cursor into @grp_id, @grantor

if ((@prev_grantor <> @grantor) or (@@sqlstatus = 2))
begin
/* Either we are at the end of the fetch or we are switching to
** a different grantor.  
*/

       update #column_privileges  
       set
insertpriv = @public_insert,
deletepriv = @public_delete,
        selectpriv = @public_select,
updatepriv = @public_update,
referencepriv = @public_reference
from #column_privileges cp
where (cp.grantor = @prev_grantor) and
             (not EXISTS (select *  
       from #useful_groups ug
       where ug.grp_id = cp.grantee_gid))
         end
    end
    close grp_cursor

    /*  
    ** At this stage, we have populated the #column_privileges table with
    ** all the inherited privileges
    ** Now we will go through each user grant or revoke in table #sysprotects
    ** and update the privileges in #column_privileges table
    */
    open user_protect

    fetch user_protect into @grantee, @action, @protecttype, @columns, @grantor

    while (@@sqlstatus != 2)
    begin
/*
** In this loop, we can find grant row, revoke row or grant with grant option
** row. We use protecttype to figure that. If it is grant, then the user  
** specific privileges are added to the user's inherited privileges. If it  
** is a revoke,then the revoked privileges are subtracted from the inherited  
** privileges. If it is a grant with grant option, we just store it as is  
** because privileges can only be granted with grant option to individual users
*/

/*  
** for select action
*/
        if (@action = @select_action)
begin
    /* get the inherited select privilege */
    select @inherit_select = selectpriv
    from   #column_privileges
    where  (grantee = @grantee) and
   (grantor = @grantor)

    if (@protecttype = @grant_type)
     /* the grantee has a individual grant */
    exec sybsystemprocs.dbo.syb_aux_privunion @inherit_select,  
@columns, @col_count, @inherit_select output

    else  
    if (@protecttype = @revoke_type)
/* it is a revoke row */
        exec sybsystemprocs.dbo.syb_aux_privexor @inherit_select,  
@columns, @col_count, @inherit_select output

    else
     /* it is a grant with grant option */
        select @select_go = @columns
           /* modify the privileges for this user */
    if ((@protecttype = @revoke_type) or (@protecttype = @grant_type))
    begin
        update #column_privileges
     set selectpriv = @inherit_select
     where (grantor = @grantor) and
      (grantee = @grantee)
    end
    else
    begin
               update #column_privileges
     set select_go = @select_go
     where (grantor = @grantor) and
      (grantee = @grantee)
    end
end
/*
** update action
*/
if (@action = @update_action)
begin
     /* find out the inherited update privilege */
     select @inherit_update = updatepriv
     from   #column_privileges
     where  (grantee = @grantee) and
    (grantor = @grantor)


     if (@protecttype = @grant_type)
     /* user has an individual grant */
exec sybsystemprocs.dbo.syb_aux_privunion @inherit_update, @columns,  
  @col_count, @inherit_update output

     else  
if (@protecttype = @revoke_type)
     exec sybsystemprocs.dbo.syb_aux_privexor @inherit_update, @columns,  
      @col_count, @inherit_update output

        else
     /* it is a grant with grant option */
     select @update_go = @columns


       /* modify the privileges for this user */

     if ((@protecttype = @revoke_type) or (@protecttype = @grant_type))
     begin
       update #column_privileges
       set updatepriv = @inherit_update
       where (grantor = @grantor) and
        (grantee = @grantee)
     end
     else
     begin
       update #column_privileges
       set update_go = @update_go
       where (grantor = @grantor) and
        (grantee = @grantee)
     end
end

/* it is the reference privilege */
if (@action = @reference_action)
begin
     select @inherit_reference = referencepriv
     from   #column_privileges
     where  (grantee = @grantee) and
    (grantor = @grantor)


     if (@protecttype = @grant_type)
     /* the grantee has a individual grant */
exec sybsystemprocs.dbo.syb_aux_privunion @inherit_reference, @columns,  
  @col_count, @inherit_reference output

     else  
if (@protecttype = @revoke_type)
/* it is a revoke row */
     exec sybsystemprocs.dbo.syb_aux_privexor @inherit_reference, @columns,  
      @col_count, @inherit_reference output

        else
     /* it is a grant with grant option */
     select @reference_go = @columns


       /* modify the privileges for this user */

     if ((@protecttype = @revoke_type) or (@protecttype = @grant_type))
     begin
       update #column_privileges
       set referencepriv = @inherit_reference
       where (grantor = @grantor) and
        (grantee = @grantee)
     end
     else
     begin
       update #column_privileges
       set reference_go = @reference_go
       where (grantor = @grantor) and
        (grantee = @grantee)
     end

end

/*
** insert action
*/

if (@action = @insert_action)
begin
     if (@protecttype = @grant_type)
   select @inherit_insert = 1
     else
if (@protecttype = @revoke_type)
      select @inherit_insert = 0
else
      select @insert_go = 1

      
       /* modify the privileges for this user */

     if ((@protecttype = @revoke_type) or (@protecttype = @grant_type))
     begin
       update #column_privileges
       set insertpriv = @inherit_insert
       where (grantor = @grantor) and
        (grantee = @grantee)
     end
     else
     begin
       update #column_privileges
       set insert_go = @insert_go
       where (grantor = @grantor) and
        (grantee = @grantee)
     end

end

/*  
** delete action
*/

if (@action = @delete_action)
begin
     if (@protecttype = @grant_type)
   select @inherit_delete = 1
     else
if (@protecttype = @revoke_type)
      select @inherit_delete = 0
else
      select @delete_go = 1

      
       /* modify the privileges for this user */

     if ((@protecttype = @revoke_type) or (@protecttype = @grant_type))
     begin
       update #column_privileges
       set deletepriv = @inherit_delete
       where (grantor = @grantor) and
        (grantee = @grantee)
     end
     else
     begin
       update #column_privileges
       set delete_go = @delete_go
       where (grantor = @grantor) and
        (grantee = @grantee)
     end

end

        fetch user_protect into @grantee,@action,@protecttype,@columns,@grantor
    end

    close user_protect

    open col_priv_cursor
    fetch col_priv_cursor into @grantor, @grantee, @inherit_insert, @insert_go,
         @inherit_delete, @delete_go, @inherit_select, @select_go,
@inherit_update, @update_go, @inherit_reference, @reference_go

    while (@@sqlstatus != 2)
    begin

        /*  
        ** name of the grantor/grantee
        */
        select @grantor_name = name from sysusers where  uid = @grantor
        select @grantee_name = name from sysusers where  uid = @grantee

        if (@column_name = '%')
        begin
    select @col_pos = 1
      while (@col_pos <= @col_count)
    begin
          select @curr_column = col_name (@tab_id, @col_pos)
          /*  
        ** check for insert privileges
        */
        exec sybsystemprocs.dbo.syb_aux_printprivs  
     1, @col_pos, @inherit_insert,@insert_go,
                     0x00, 0x00, 0, @grantable output, @is_printable output
                if (@is_printable = 1)
        begin
    insert into #results_table
    values (@table_qualifier, @table_owner, @actual_table_name,  
            @curr_column, @grantor_name, @grantee_name,  
    'INSERT', @grantable)
        end

        /*  
        ** check for select privileges
        */
                exec sybsystemprocs.dbo.syb_aux_printprivs  
     1, @col_pos, 0, 0, @inherit_select,  
     @select_go, 1, @grantable output, @is_printable output

                if (@is_printable = 1)
        begin
    insert into #results_table
    values (@table_qualifier, @table_owner, @actual_table_name,  
      @curr_column, @grantor_name,@grantee_name,'SELECT',
    @grantable)
                end
        /*  
        ** check for update privileges
        */
        exec sybsystemprocs.dbo.syb_aux_printprivs  
     1, @col_pos, 0, 0, @inherit_update,  
     @update_go, 1, @grantable output, @is_printable output
          if (@is_printable = 1)
        begin
    insert into #results_table
    values (@table_qualifier, @table_owner, @actual_table_name,  
    @curr_column, @grantor_name, @grantee_name,  
    'UPDATE', @grantable)
                end
        /*
        ** check for reference privs
        */

        exec sybsystemprocs.dbo.syb_aux_printprivs  
     1, @col_pos, 0, 0, @inherit_reference,  
     @reference_go, 1, @grantable output, @is_printable output
            if (@is_printable = 1)
        begin
    insert into #results_table
            values (@table_qualifier, @table_owner, @actual_table_name,  
            @curr_column, @grantor_name, @grantee_name,  
            'REFERENCE', @grantable)
        end
           select @col_pos = @col_pos + 1
            end
        end
        else
        begin
           /*  
           ** At this point, we are either printing privilege information for a
           ** a specific column or for table_privileges
           */
            select @col_pos = colid
    from syscolumns
    where (id = @tab_id) and
        (name = @column_name)

    /*  
    ** check for insert privileges
    */
    exec sybsystemprocs.dbo.syb_aux_printprivs  
1, @col_pos, @inherit_insert, @insert_go,  
0x00, 0x00, 0, @grantable output, @is_printable output
    if (@is_printable = 1)
    begin
          insert into #results_table
values (@table_qualifier,@table_owner,@actual_table_name,@column_name,
@grantor_name, @grantee_name, 'INSERT', @grantable)
    end

    /*  
    ** check for delete privileges
    */

            exec sybsystemprocs.dbo.syb_aux_printprivs  
        1, @col_pos, @inherit_delete, @delete_go,
0x00, 0x00, 0, @grantable output, @is_printable output
        if (@is_printable = 1)
    begin
insert into #results_table
values (@table_qualifier, @table_owner, @actual_table_name,  
        @column_name, @grantor_name, @grantee_name,  
                        'DELETE', @grantable)
    end

    /*  
    ** check for select privileges
    */
    exec sybsystemprocs.dbo.syb_aux_printprivs  
1, @col_pos, 0, 0, @inherit_select,  
                @select_go, 1, @grantable output, @is_printable output
    if (@is_printable = 1)
    begin
         insert into #results_table
       values (@table_qualifier, @table_owner, @actual_table_name,  
                       @column_name, @grantor_name, @grantee_name, 'SELECT',  
                       @grantable)
    end
    /*  
    ** check for update privileges
    */
    exec sybsystemprocs.dbo.syb_aux_printprivs  
1, @col_pos, 0, 0, @inherit_update,   
@update_go, 1, @grantable output, @is_printable output
    if (@is_printable = 1)
    begin
        insert into #results_table
        values (@table_qualifier, @table_owner, @actual_table_name,  
        @column_name, @grantor_name, @grantee_name, 'UPDATE',  
                        @grantable)
    end
    /*
    ** check for reference privs
    */
      exec sybsystemprocs.dbo.syb_aux_printprivs  
1, @col_pos, 0, 0, @inherit_reference,  
                @reference_go, 1, @grantable output, @is_printable output
        if (@is_printable = 1)
    begin
  insert into #results_table
        values (@table_qualifier, @table_owner, @actual_table_name,  
        @column_name, @grantor_name, @grantee_name,  
                        'REFERENCE', @grantable)
    end
end

        fetch col_priv_cursor into @grantor, @grantee, @inherit_insert,
            @insert_go, @inherit_delete, @delete_go, @inherit_select,
            @select_go, @inherit_update, @update_go, @inherit_reference,  
            @reference_go
        end
        close col_priv_cursor
        FETCH jcurs_tab_id INTO @tab_id
    end
     
/*
** Outputting the results table
*/
/* Changed to get the requested output order*/
select distinct table_qualifier TABLE_CAT, table_owner TABLE_SCHEM,
       table_name TABLE_NAME, column_name COLUMN_NAME ,  
       grantor GRANTOR, grantee GRANTEE,  
       privilege PRIVILEGE, is_grantable IS_GRANTABLE  
from #results_table
        where column_name like @save_column_name
order by column_name, privilege

    set nocount off
    return(0)
go

exec sp_procxmode 'sp_jdbc_getcolumnprivileges', 'anymode'
go

grant execute on sp_jdbc_getcolumnprivileges to public
go

dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_getcolumnprivileges  
*/


/*
**  sp_jdbc_gettableprivileges  
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name = 'sp_jdbc_gettableprivileges')
    begin
        drop procedure sp_jdbc_gettableprivileges
    end
go
/** SECTION END: CLEANUP **/


create procedure sp_jdbc_gettableprivileges (
    @table_qualifier    varchar(32),
    @table_owner        varchar(32) = null,
    @table_name         varchar(32)= null)
as         

    declare @tablename varchar(128)
    declare @tableowner varchar(128)
    declare @privlist varchar(128)
    declare @privdef  varchar(128)
    declare @searchstr char(3)  
     
    select @searchstr = 'SUV' /* SYSTEM USER VIEW types only */     
     
    select @privlist = '193      ' + /* SELECT    */
                       '151      ' + /* REFERENCE */
                       '197      ' + /* UPDATE    */
                       '196      ' + /* DELETE    */
                       '195      '   /* INSERT    */
                        
    select @privdef =  'SELECT   ' +
                       'REFERENCE' +
                       'UPDATE   ' +
                       'DELETE   ' +
                       'INSERT   '
         
                   
    select @tablename = @table_name
    select @tableowner = @table_owner
          
    if (@tableowner is null)
    begin
        select @tableowner ='%'
    end
     
    if (@tablename is null)
    begin
        select @tablename ='%'
    end
     
    SELECT 'TABLE_CAT' = db_name(), 'TABLE_SCHEM' = user_name(uid),  
        'TABLE_NAME' = name, 'GRANTOR' = user_name(uid),  
        'GRANTEE' = user_name(uid), 'PRIVILEGE' = 'SELECT', 'IS_GRANTABLE' = 'YES'
    FROM sysobjects
    WHERE name LIKE @tablename ESCAPE '\'
        AND user_name(uid) LIKE @tableowner ESCAPE '\'
        AND charindex(substring(type,1,1),@searchstr)! = 0
    UNION
    SELECT 'TABLE_CAT' = db_name(), 'TABLE_SCHEM' = user_name(uid),  
        'TABLE_NAME' = name, 'GRANTOR' = user_name(uid),  
        'GRANTEE' = user_name(uid), 'PRIVILEGE' = 'INSERT', 'IS_GRANTABLE' = 'YES'
    FROM sysobjects
    WHERE name LIKE @tablename ESCAPE '\'
        AND user_name(uid) LIKE @tableowner ESCAPE '\'
        AND charindex(substring(type,1,1),@searchstr)! = 0
    UNION
    SELECT 'TABLE_CAT' = db_name(), 'TABLE_SCHEM' = user_name(uid),  
        'TABLE_NAME' = name, 'GRANTOR' = user_name(uid),  
        'GRANTEE' = user_name(uid), 'PRIVILEGE' = 'DELETE', 'IS_GRANTABLE' = 'YES'
    FROM sysobjects
    WHERE name LIKE @tablename ESCAPE '\'
        AND user_name(uid) LIKE @tableowner ESCAPE '\'
        AND charindex(substring(type,1,1),@searchstr)! = 0
    UNION
    SELECT 'TABLE_CAT' = db_name(), 'TABLE_SCHEM' = user_name(uid),  
        'TABLE_NAME' = name, 'GRANTOR' = user_name(uid),  
        'GRANTEE' = user_name(uid), 'PRIVILEGE' = 'UPDATE', 'IS_GRANTABLE' = 'YES'
    FROM sysobjects
    WHERE name LIKE @tablename ESCAPE '\'
        AND user_name(uid) LIKE @tableowner ESCAPE '\'
        AND charindex(substring(type,1,1),@searchstr)! = 0
    UNION
    SELECT 'TABLE_CAT' = db_name(), 'TABLE_SCHEM' = user_name(uid),  
        'TABLE_NAME' = name, 'GRANTOR' = user_name(uid),  
        'GRANTEE' = user_name(uid), 'PRIVILEGE' = 'REFERENCE', 'IS_GRANTABLE' = 'YES'
    FROM sysobjects
    WHERE name LIKE @tablename ESCAPE '\'
        AND user_name(uid) LIKE @tableowner ESCAPE '\'
        AND charindex(substring(type,1,1),@searchstr)! = 0
    UNION
    SELECT 'TABLE_CAT' = db_name(), 'TABLE_SCHEM' = user_name(o.uid),  
        'TABLE_NAME' = o.name, 'GRANTOR' = user_name(p.grantor),
    'GRANTEE' = user_name(p.uid),  
        'PRIVILEGE' =  
            rtrim(substring( @privdef,  
                    charindex(rtrim(convert(char,p.action)), @privlist), 9)),
        substring('YESNO ', (p.protecttype * 3)+1, 3)
    FROM sysprotects p, sysobjects o  
    WHERE o.id = p.id and protecttype < 2
        AND o.name LIKE @tablename ESCAPE '\'
        AND user_name(o.uid) LIKE @tableowner ESCAPE '\'
        AND p.action in (193, 151, 197, 196, 195)
        AND charindex(substring(type,1,1),@searchstr)! = 0
    ORDER BY TABLE_SCHEM, TABLE_NAME, PRIVILEGE

go

exec sp_procxmode 'sp_jdbc_gettableprivileges', 'anymode'
go

grant execute on sp_jdbc_gettableprivileges to public
go

dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_gettableprivileges  
*/



/*  
** sp_jdbc_getcatalogs
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name = 'sp_jdbc_getcatalogs')
    begin
        drop procedure sp_jdbc_getcatalogs
    end
go
/** SECTION END: CLEANUP **/
  

CREATE PROCEDURE sp_jdbc_getcatalogs  
as

    if @@trancount = 0
    begin
    set chained off
    end
     
    set transaction isolation level 1

    select TABLE_CAT=name from master..sysdatabases order by name
go
  
exec sp_procxmode 'sp_jdbc_getcatalogs', 'anymode'
go
  
grant execute on sp_jdbc_getcatalogs to public
go

commit
go
dump transaction sybsystemprocs with truncate_only  
go

/*  
**  End of sp_jdbc_getcatalogs
*/


/*
**  sp_jdbc_primarykey
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select *
from sysobjects
where sysstat & 7 = 4
and name = 'sp_jdbc_primarykey')
begin
drop procedure sp_jdbc_primarykey
end
go
/** SECTION END: CLEANUP **/

/*
** Altered from the ODBC sp_pkeys defined in sycsp11.sql.
**
** To facilitate eventually combining scripts for ODBC and JDBC,
** only the ordering of the arguments and the final select have been modified.
*/
/*
** note: there is one raiserror message: 18040
**
** messages for 'sp_jdbc_primarykey'               18039, 18040
**
** 17461, 'Object does not exist in this database.'
** 18039, 'table qualifier must be name of current database.'
** 18040, 'catalog procedure %1! can not be run in a transaction.', sp_jdbc_primarykey
**
*/

create procedure sp_jdbc_primarykey
   @table_qualifier varchar(32),
   @table_owner varchar(32),
   @table_name varchar(64)
as
    declare @msg varchar(255)
    declare @keycnt smallint
    declare @indexid smallint
    declare @indexname varchar(30)
    declare @i int
    declare @id int
    declare @uid smallint
    declare @actual_table_name varchar(64)
     
    select @actual_table_name = @table_name

    select @id = NULL

set nocount on

if (@@trancount = 0)
begin
set chained off
end
else
begin 
/* if inside a transaction */
/* catalog procedure sp_jdbc_primarykey can not be run in a transaction.*/
exec sp_getmessage 18040, @msg output
raiserror 18040 @msg, 'sp_jdbc_primarykey'
return (1)
end

set transaction isolation level 1

if @table_qualifier is not null
begin
if db_name() != @table_qualifier
begin 
/* if qualifier doesn't match current database */
/* 'table qualifier must be name of current database'*/
exec sp_getmessage 18039, @msg output
raiserror 18039 @msg  
return (2)
end
end
     
    exec sp_jdbc_escapeliteralforlike @table_name

if @table_owner is null
begin
        select @table_owner = '%'
end

if (select count(*) from sysobjects
        where user_name(uid) like @table_owner ESCAPE '\'
        and name = @table_name) = 0
begin 
/* 17461, 'Object does not exist in this database.' */
exec sp_getmessage 17674, @msg output
raiserror 17674 @msg  
return (3)
end

create table #pkeys(
table_qualifier varchar(32),
table_owner     varchar(32),
table_name      varchar(32),
column_name     varchar(32),
key_seq smallint,
             index_name     varchar(30))


    DECLARE jcurs_sysuserobjects CURSOR
        FOR
    select id, uid  
        from sysobjects
        where user_name(uid) like @table_owner ESCAPE '\'
        and name = @table_name
        FOR READ ONLY

    OPEN  jcurs_sysuserobjects

    FETCH jcurs_sysuserobjects INTO @id, @uid  
     
    while (@@sqlstatus = 0)
    begin
         
        /*
        **  now we search for primary key (only declarative) constraints
        **  There is only one primary key per table.
        */
     
    select @keycnt = keycnt, @indexid = indid, @indexname = name
    from   sysindexes
    where  id = @id
    and indid > 0 /* make sure it is an index */
    and status2 & 2 = 2 /* make sure it is a declarative constr */
    and status & 2048 = 2048 /* make sure it is a primary key */
     
        /*
        ** For non-clustered indexes, keycnt as returned from sysindexes is one
        ** greater than the actual key count. So we need to reduce it by one to
        ** get the actual number of keys.
        */
    if (@indexid >= 2)
    begin
    select @keycnt = @keycnt - 1
    end
     
    select @i = 1
     
    while @i <= @keycnt
    begin
    insert into #pkeys values
    (db_name(), user_name(@uid), @actual_table_name,
    index_col(@actual_table_name, @indexid, @i, @uid), @i, @indexname)
    select @i = @i + 1
    end
     
        /*
        ** Go to the next user/object
        */
        FETCH jcurs_sysuserobjects INTO @id, @uid  
    end

    close jcurs_sysuserobjects
    deallocate cursor jcurs_sysuserobjects

    /*
    ** Original ODBC query:
    **
** select table_qualifier, table_owner, table_name, column_name, key_seq
** from #pkeys
** order by table_qualifier, table_owner, table_name, key_seq
    */
    /*
    ** Primary keys are not explicitly named, so name is always null.
    */
    select table_qualifier as TABLE_CAT,
        table_owner as TABLE_SCHEM,
        table_name as TABLE_NAME,
        column_name as COLUMN_NAME,
        key_seq as KEY_SEQ,
        index_name as PK_NAME
from #pkeys
order by column_name
     
    drop table #pkeys
return (0)
go
exec sp_procxmode 'sp_jdbc_primarykey', 'anymode'
go
grant execute on sp_jdbc_primarykey to public
go
use sybsystemprocs  
go

/*
**  End of sp_jdbc_primarykey
*/



/*
**  sp_sql_type_name
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name = 'sp_sql_type_name')
begin
        drop procedure sp_sql_type_name
end
go
/** SECTION END: CLEANUP **/
  
/*
**  Implements RSMDA.getColumnTypeName
**  create a procedure that will query  
**  spt_jdatatype_info for the correct jdbc mapped datatype or
**  the datasource specific systable, to retrieve the correct type
**  or user defined datatype name, based on the parameters
**  @datatype = the protocol datatype value
**  @usrtype = the data source specifc user defined datatype value
*/
create procedure sp_sql_type_name
        @datatype  tinyint,
        @usrtype   smallint
as
BEGIN

    if @@trancount = 0
    begin
    set chained off
    end
     
    set transaction isolation level 1

/* special case for types numericn and decimaln, they do not seem
** to have the correct mapping of usertype & datatype
*/
   /* if a usertype is greater than 100 that means it is a  
    * user defined datatype, and it needs to be reference in
    * the datasource specific systype table
    */
   if (@usrtype > 100)  
   begin
      select name from systypes
         where type = @datatype
         and usertype = @usrtype
   end
   /* SPECIAL CASE,  
    * numericn, and decimaln are always returned for a numeric
    * and decimal value, and do not have entries in the spt_jdatatype
    * info tables, therefore need to account for them by looking in
    * systables.
    */
   else if (@datatype = 108 or @datatype = 106)
   begin
       select name  from systypes
          where type = @datatype
   end
   /* simply check spt_jdatatype_info for  
    * the predefined jdbc mapping for the types
    */
   else
   begin
       select j.type_name as name  
       from sybsystemprocs.dbo.spt_jdatatype_info j
       where j.ss_dtype = @datatype
   end
END
go
/* end of sp_sql_type_name */
exec sp_procxmode 'sp_sql_type_name', 'anymode'
go
grant execute on sp_sql_type_name to public
go
commit
go
dump transaction sybsystemprocs with truncate_only  
go


/*
**  End of sp_sql_type_name
*/



/*
**  sp_jdbc_getbestrowidentifier
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select *
from sysobjects where name = 'sp_jdbc_getbestrowidentifier')
begin
drop procedure sp_jdbc_getbestrowidentifier
end
go
/** SECTION END: CLEANUP **/


/* Get a description of a table's optimal set of columns that uniquely  
** identifies a row
** Usually it's the unique primary key index column or the identity field
*/

create procedure sp_jdbc_getbestrowidentifier (
@table_qualifier varchar(32) = null,
@table_owner varchar(32) = null,
@table_name varchar(32),
@scope int,
@nullable smallint)
as
declare @indid              int
declare @table_id           int
declare @dbname             char(30)
declare @owner             char(30)
declare @full_table_name    char(70)
declare @msg                char(70)

if @@trancount = 0
begin
set chained off
end

set transaction isolation level 1

        if exists (select * from sysobjects where name = '#bestinfo')
        begin
       drop table #bestinfo
        end
        create table #bestinfo (
            SCOPE smallint, COLUMN_NAME varchar(32),
            DATA_TYPE smallint, TYPE_NAME varchar(32),
            COLUMN_SIZE int, BUFFER_LENGTH varchar(255),
            DECIMAL_DIGITS smallint, PSEUDO_COLUMN smallint)

/* get database name */
select @dbname = db_name()

/* we don't want a temp table unless we're in tempdb */
if @table_name like '#%' and @dbname != 'tempdb'
begin 
exec sp_getmessage 17676, @msg output
raiserror 17676 @msg
return (1)
end

if @table_qualifier is not null
begin
/* if qualifier doesn't match current database */
if @dbname != @table_qualifier
begin 
exec sp_getmessage 18039, @msg output
raiserror 18039 @msg
return (1)
end
end

    if (@table_owner is null)  
    begin
        select @table_owner ='%'
    end
    else
    begin
         
        if (charindex('%',@table_owner) > 0)
        begin
            exec sp_getmessage 17993, @msg output
            raiserror 17993 @msg, @table_owner
            return(1)
        end
         
        /*
        ** if there is a '_' character in @table_owner,  
        ** then we need to make it work literally in the like
        ** clause.
        */
        if (charindex('_', @table_owner) > 0)
        begin
            exec sp_jdbc_escapeliteralforlike
                @table_owner output
        end
    end
     
     
    if (@table_name is null)  
    begin
       exec sp_getmessage 17993, @msg output
       raiserror 17993 @msg, 'NULL'
       return(1)
    end
     
    if ((select count(*)  
        from sysobjects
        where user_name(uid) like @table_owner ESCAPE '\'
        and name = @table_name) = 0)
    begin
      exec sp_getmessage 17674, @msg output
      raiserror 17674 @msg, @table_name
      return
    end

    declare owner_cur cursor for  
    select @table_owner = user_name(uid) from sysobjects  
    where name like @table_name ESCAPE '\'  
                and user_name(uid) like @table_owner ESCAPE '\'  
    open owner_cur
    fetch owner_cur into @owner
    while (@@sqlstatus = 0)
    begin
        select @full_table_name = @owner + '.' + @table_name

        /* get object ID */
        select @table_id = object_id(@full_table_name)

        /* ROWID, now find the id of the 'best' index for this table */

        select @indid = (
            select min(indid)
            from sysindexes
            where
                id = @table_id
                and indid > 0) /* eliminate table row */
         
        /* Sybase's only PSEUDO_COLUMN is called SYB_IDENTITY_COL and */
        /* is only generated when dboption 'auto identity' is set on */
        if exists (select name from syscolumns where id=@table_id and name =
            'SYB_IDENTITY_COL')
        begin
            insert into #bestinfo values (
                convert(smallint, 0), 'SYB_IDENTITY_COL', 2, 'NUMERIC', 10,
                'not used', 0, 2)
        end
        else
        begin
            insert into #bestinfo  
    select
                convert(smallint, 0),index_col(@full_table_name,indid,c.colid),
                d.data_type + convert(smallint, isnull(d.aux,
                        ascii(substring('666AAA@@@CB??GG',
                        2*(d.ss_dtype%35+1)+2-8/c2.length,1))
                        -60)),
                rtrim(substring(d.type_name, 1 + isnull(d.aux,
                        ascii(substring('III<<<MMMI<<A<A',
                        2*(d.ss_dtype%35+1)+2-8/c2.length, 1))
                        -60), 13)),
                isnull(d.data_precision, convert(int,c2.length))
                        + isnull(d.aux, convert(int,
                        ascii(substring('???AAAFFFCKFOLS',
                        2*(d.ss_dtype%35+1)+2-8/c2.length,1))
                        -60)),
                'not used',
                    /*isnull(d.length, convert(int,c2.length))
                        + convert(int, isnull(d.aux,
                        ascii(substring('AAA<BB<DDDHJSPP',
                        2*(d.ss_dtype%35+1)+2-8/c2.length, 1))
                        -64)),*/
                d.numeric_scale + convert(smallint,
                        isnull(d.aux,
                        ascii(substring('<<<<<<<<<<<<<<?',
                        2*(d.ss_dtype%35+1)+2-8/c2.length, 1))
                        -60)),
                1
    from
            sysindexes x,
            syscolumns c,
            sybsystemprocs.dbo.spt_jdatatype_info d,
            systypes t,
            syscolumns c2 /* self-join to generate list of index
                    ** columns and to extract datatype names */
            where
            x.id = @table_id
            and c2.name = index_col(@full_table_name, @indid,c.colid)
            and c2.id =x.id
            and c.id = x.id
            and c.colid < keycnt + (x.status & 16) / 16
            and x.indid = @indid
            and c2.type = d.ss_dtype
            and c2.usertype *= t.usertype
        end

        fetch owner_cur into @owner
    end
    select * from #bestinfo
    drop table #bestinfo
    return (0)
go
exec sp_procxmode 'sp_jdbc_getbestrowidentifier', 'anymode'
go
grant execute on sp_jdbc_getbestrowidentifier to public
go
commit
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_getbestrowidentifier
*/

/**
 * sp_jdbc_getisolationlevels
 */
  
/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs
go

if exists (select * from sysobjects where name = 'sp_jdbc_getisolationlevels')
begin
    drop procedure sp_jdbc_getisolationlevels
end
go
/** SECTION END: CLEANUP **/

/**
 * <P> This procedure is used to determine which transaction isolation
 * levels are supported by this ASE server.  This proc is registered
 * with the spt_mda table to be executed when the user calls:
 * <CODE> DatabaseMetaData.supportsTransactionIsolationLevel(int) </CODE>.
 * If the int specified is found in the row returned by this procedure,
 * then that level is supported.  The levels are indicated by using the
 * integer mappings found in the java.sql.Connection interface.
 * <UL> All ASE versions currently support these levels:
 *              <LI> TRANSACTION_SERIALIZABLE  (8) and
 *              <LI> TRANSACTION_READ_COMMITTED  (2)            </UL>
 * <UL> ASE versions after 10.1 added support for these levels:
 *              <LI>  TRANSACTION_READ_UNCOMMITTED (1).         </UL>
 * <P> This procedure accesses the @@version string, determines the
 * version of ASE, and returns the appropriate levels.
 * <P> WARNING:  Should future versions of ASE support more transaction
 * isolation levels (e.g., TRANSACTION_REPEATABLE_READ (4)), this proc
 * must be modified.
 */
  
create procedure sp_jdbc_getisolationlevels as

    declare
      @startVersion    int,         /* index of version # in @@version    */
      @versionNum      varchar(20), /* whole version number (eg 11.5.1)   */
      @versionFloat    float,       /* major & minor ver # (eg 11.5)      */
      @minorVersion    varchar(15), /* minor version (eg 5.1)             */
      @earliestVersion float,       /* this ver supports READ_UNCOMMITTED */
      @firstDecimal    int,         /* index of 1st decimal point         */
      @secondDecimal   int,         /* index of 2nd decimal point         */
      @endVersion      int     /* index of end of version number     */

    /* server must be at least 10.1.x to support levels 8, 2, AND 1. */
    select @earliestVersion = 10.1   

    /* find where the version number is in this mess of characters */
    select @startVersion = patindex('%/[0-9]%.%[0-9]/%', @@version) +1

    /* could not find version number in expected format within @@version */
    if (@startVersion <= 1)
    begin
select 0 /* returning TRANSACTION_NONE */
return 2
    end

    select @versionNum = substring(@@version, @startVersion, 20)
         
    /* Find the first decimal point in this version number */
    select @firstDecimal = charindex('.', @versionNum)
     
    /* extract the minor version and any "sub-minor" version (eg 5.1) */
    select @minorVersion = substring(@versionNum, @firstDecimal + 1, 15)

    /* Find the second decimal point in this version number */
    /* if none found, then "pretend" to have one at the end */
    /* of the version number (where the "/" is)             */

    select @secondDecimal = charindex('.',@minorVersion)
    select @endVersion = charindex('/',@minorVersion)
    if ((@secondDecimal = 0) or (@endVersion < @secondDecimal))
       select @secondDecimal = @endVersion

    /* Compute major and minor versions as a float (eg "11.5" --> 11.5F) */
    select @versionFloat = convert(float, substring(@versionNum, 1,
                                           @secondDecimal+@firstDecimal - 1))
     
    if (@versionFloat >= @earliestVersion)
       select 8,2,1
    else
       select 8,2
    
    return (0)    
go

exec sp_procxmode 'sp_jdbc_getisolationlevels', 'anymode'
go

grant execute on sp_jdbc_getisolationlevels to public
go

commit
go


/*
**  sp_jdbc_getindexinfo
*/

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select *
from sysobjects
where name = 'sp_jdbc_getindexinfo')
begin
drop procedure sp_jdbc_getindexinfo
end
go
/** SECTION END: CLEANUP **/


/* getindexinfo returns information on the indexes of a page
** is unique is set to TRUE only indexes on indexes where it's value's must
** be unique are returned.
** approximate is a little needless because rowcnt() and data_pgs()
** garantee alwys accurate data
*/
create procedure sp_jdbc_getindexinfo (
@table_qualifier varchar(32) = NULL,
@table_owner varchar(32) = NULL,
@table_name varchar(32),
@unique varchar(5) ,
@approximate char(5))
as
    declare @indid              int
    declare @lastindid          int
    declare @full_table_name    char(70)
    declare @msg                varchar(250)
    declare @tableid            int
     
    /*
    ** Verify table qualifier is name of current database.
    */
    if @table_qualifier is not null
    begin
    if db_name() != @table_qualifier
    begin /* If qualifier doesn't match current database */
    /*
    ** 18039, 'Table qualifier must be name of current database.'
    */
    exec sp_getmessage 18039, @msg output
    raiserror 18039 @msg
    return (1)
    end
    end
    select @table_qualifier = db_name()
     
    if @@trancount > 0
    begin
    /*
    ** 18040, 'Catalog procedure '%1!' can not be run in a transaction.
    */
    exec sp_getmessage 18040, @msg output
    raiserror 18040 @msg, 'sp_jdbc_getindexinfo'
    return (1)
    end
    else
    begin
    set chained off
    end
     
    set transaction isolation level 1
     
     
    if (@table_owner is null)
    begin
        select @table_owner ='%'
    end
     
    if (@table_name is null)  
    begin
       exec sp_getmessage 17993, @msg output
       raiserror 17993 @msg, 'NULL'
       return(1)
    end

    if ((select count(*)  
        from sysobjects  
        where user_name(uid) like @table_owner ESCAPE '\'
        and name = @table_name) = 0)
    begin
        exec sp_getmessage 17674, @msg output
        raiserror 17674 @msg
        return
    end

    create table #TmpIndex(
    table_qualifier varchar(32),
    table_owner varchar(32),
    table_name varchar(32),
    index_qualifier varchar(32) null,
    index_name varchar(32) null,
    non_unique varchar(5),
    type smallint,
    seq_in_index smallint null,
    column_name varchar(32) null,
    collation char(1) null,
    index_id int null,
    cardinality int null,
    pages int null,
    filter_condition varchar(32) null,
    status smallint,
        table_id    int)


    DECLARE jcurs_sysuserobjects CURSOR
        FOR
    select id
        from sysobjects
        where user_name(uid) like @table_owner ESCAPE '\'
        and name = @table_name
        FOR READ ONLY

    OPEN  jcurs_sysuserobjects

    FETCH jcurs_sysuserobjects INTO @tableid  
     
    while (@@sqlstatus = 0)
    begin
        /*
        ** build the full_table_name for use below in  
        ** obtaining the index column via the INDEX_COL()
        ** internal function
        */
        select @full_table_name = user_name(uid) + '.' + name
        from sysobjects
        where id = @tableid

        /*
        ** Start at lowest index id, while loop through indexes.  
        ** Create a row in #TmpIndex for every column in sysindexes, each is
        ** followed by an row in #TmpIndex with table statistics for the preceding
        ** index.
        */
        select @indid = min(indid)
        from sysindexes
        where id = @tableid
       and indid > 0
       and indid < 255

        while @indid is not NULL
        begin
        insert #TmpIndex /* Add all columns that are in index */
        select
        db_name(), /* table_qualifier */
        user_name(o.uid), /* table_owner    */
        o.name, /* table_name    */
        o.name, /* index_qualifier */
        x.name, /* index_name    */
        'FALSE', /* non_unique    */
        1, /* SQL_INDEX_CLUSTERED */
        colid, /* seq_in_index    */
        INDEX_COL(@full_table_name,indid,colid),/* column_name    */
        'A', /* collation    */
        @indid, /* index_id    */
        rowcnt(x.doampg), /* cardinality    */
        data_pgs(x.id,doampg), /* pages    */
        null, /* Filter condition not available */
        /* in SQL Server*/
        x.status, /* Status */ 
                @tableid    /* table id, internal use for updating the non_unique field */
        from sysindexes x, syscolumns c, sysobjects o
        where x.id = @tableid
        and x.id = o.id
        and x.id = c.id
        and c.colid < keycnt+(x.status&16)/16
        and x.indid = @indid
         
            /*
            ** only update the inserts for the current
            ** owner.table
            */
            update #TmpIndex
                set non_unique = 'TRUE'
                where status&2 != 2 /* If non-unique index */
                and table_id = @tableid
     
        /*
        ** Save last index and increase index id to next higher value.
        */
        select @lastindid = @indid
        select @indid = NULL
         
        select @indid = min(indid)
        from sysindexes
        where id = @tableid
        and indid > @lastindid
        and indid < 255
        end
         
        /*  
        ** Now add row with table statistics  
        */
        insert #TmpIndex
        select
        db_name(), /* table_qualifier */
        user_name(o.uid), /* table_owner    */
        o.name, /* table_name    */
        null, /* index_qualifier */
        null, /* index_name    */
        'FALSE', /* non_unique    */
        0, /* SQL_table_STAT  */
        null, /* seq_in_index */
        null, /* column_name    */
        null, /* collation    */
        0, /* index_id    */
        rowcnt(x.doampg), /* cardinality    */
        data_pgs(x.id,doampg), /* pages    */
        null, /* Filter condition not available */
        /* in SQL Server*/
        0, /* Status */
                @tableid    /* tableid */
        from sysindexes x, sysobjects o
        where o.id = @tableid
        and x.id = o.id
        and (x.indid = 0 or x.indid = 1) 
        /*   
        ** If there are no indexes
        ** then table stats are in a row with indid = 0
        */

        /*
        ** Go to the next user/object
        */
        FETCH jcurs_sysuserobjects INTO @tableid  
    end

    close jcurs_sysuserobjects
    deallocate cursor jcurs_sysuserobjects

    update #TmpIndex
        set
            type = 3, /* SQL_INDEX_OTHER */
            cardinality = NULL,
            pages = NULL
        where index_id > 1 /* If non-clustered index */
            
    if (@unique!='1')
    begin
    /* If all indexes desired */
    select
    table_qualifier TABLE_CAT,
    table_owner TABLE_SCHEM,
    table_name TABLE_NAME,
    non_unique NON_UNIQUE,
    index_qualifier INDEX_QUALIFIER,
    index_name INDEX_NAME,
    type TYPE,
    seq_in_index ORDINAL_POSITION,
    column_name COLUMN_NAME,
    collation ASC_OR_DESC,
    cardinality CARDINALITY,
    pages PAGES,
    filter_condition FILTER_CONDITION 
    from #TmpIndex
    order by non_unique, type, index_name, seq_in_index
    end
    else 
    begin
    /* else only unique indexes desired */
    select
    table_qualifier TABLE_CAT,
    table_owner TABLE_SCHEM,
    table_name TABLE_NAME,
    non_unique NON_UNIQUE,
    index_qualifier INDEX_QUALIFIER,
    index_name INDEX_NAME,
    type TYPE,
    seq_in_index ORDINAL_POSITION,
    column_name COLUMN_NAME,
    collation ASC_OR_DESC,
    cardinality CARDINALITY,
    pages PAGES,
    filter_condition FILTER_CONDITION
    from #TmpIndex
    where non_unique = 'FALSE' 
    order by non_unique, type, index_name, seq_in_index
     
    end
     
    drop table #TmpIndex
     
    return (0)

go

exec sp_procxmode 'sp_jdbc_getindexinfo', 'anymode'
go
grant execute on sp_jdbc_getindexinfo to public
go
commit
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_getindexinfo
*/


/*
**  sp_jdbc_stored_procedures
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects
where name = 'sp_jdbc_stored_procedures')
begin
drop procedure sp_jdbc_stored_procedures
end
go
/** SECTION END: CLEANUP **/


/*
** Altered from the ODBC sp_jdbc_procedures defined in sycsp11.sql.
**
** New column 'PROCEDURE_TYPE' was added to support JDBC spec. This
** column is to indicate if the procedure returns a result. If 0,
** column will be evalued as DatabaseMetadata.procedureResultUnknown;
** this means that the procedure MAY return a result.
*/
/*
** Messages for 'sp_jdbc_stored_procedures' 18041
**
** 18041, 'Stored Procedure qualifier must be name of current database.'
**
*/
create procedure sp_jdbc_stored_procedures
@sp_qualifier varchar(32) = null, /* stored procedure qualifier;  
** For the SQL Server, the only valid
** values are NULL or the current  
** database name
*/
@sp_owner varchar(32) = null, /* stored procedure owner */
@sp_name varchar(36) = null /* stored procedure name */
as

declare @msg varchar(90)

if @@trancount = 0
begin
set chained off
end

set transaction isolation level 1

/* If qualifier is specified */
if @sp_qualifier is not null
begin
/* If qualifier doesn't match current database */
if db_name() != @sp_qualifier
begin
/* If qualifier is not specified */
if @sp_qualifier = ''
begin
/* in this case, we need to return an empty  
** result set because the user has requested a  
** database with an empty name  
*/
select @sp_name = ''
select @sp_owner = ''
end

/* qualifier is specified and does not match current database */
else
begin 
/*  
** 18041, 'Stored Procedure qualifer must be name of
** current database'
*/
exec sp_getmessage 18041, @msg out
raiserror 18041 @msg
return (1)
end
end
end

/* If procedure name not supplied, match all */
if @sp_name is null
begin   
select @sp_name = '%'
end

/* If procedure owner not supplied, match all */
if @sp_owner is null 
select @sp_owner = '%'

/*  
** Retrieve the stored procedures and associated info on them
*/
select  PROCEDURE_CAT = db_name(),
PROCEDURE_SCHEM = user_name(o.uid),
PROCEDURE_NAME = o.name +';'+ ltrim(str(p.number,5)),
num_input_params = -1, /* Constant since value unknown */
num_output_params = -1,         /* Constant since value unknown */
num_result_sets = -1, /* Constant since value unknown */
REMARKS = convert(varchar(254),null), /* Remarks are NULL */
PROCEDURE_TYPE = 0
from sysobjects o,sysprocedures p,sysusers u
where o.name like @sp_name ESCAPE '\'
and p.sequence = 0
and user_name(o.uid) like @sp_owner ESCAPE '\'
and o.type = 'P' /* Object type of Procedure */
and p.id = o.id
and u.uid = user_id() /* constrain sysusers uid for use in  
** subquery  
*/

and (suser_id() = 1 /* User is the System Administrator */
     or  o.uid = user_id() /* User created the object */
/* here's the magic..select the highest  
** precedence of permissions in the  
** order (user,group,public)   
*/

     /*
     ** The value of protecttype is
     **
     ** 0  for grant with grant
     ** 1  for grant and,
     ** 2  for revoke
     **
     ** As protecttype is of type tinyint, protecttype/2 is
     ** integer division and will yield 0 for both types of
     ** grants and will yield 1 for revoke, i.e., when
     ** the value of protecttype is 2.  The XOR (^) operation
     ** will reverse the bits and thus (protecttype/2)^1 will
     ** yield a value of 1 for grants and will yield a
     ** value of zero for revoke.
     **
     ** Normal uids have values upto 16383, roles have uids
     ** from 16384 upto 16389 and uids of groups start from
     ** 16390 onwards.
     **
     ** If there are several entries in the sysprotects table
     ** with the same Object ID, then the following expression
     ** will prefer an individual uid entry over a group entry
     ** and prefer a group entry over a role entry.
     **
     ** For example, let us say there are two users u1 and u2
     ** with uids 4 and 5 respectiveley and both u1 and u2
     ** belong to a group g12 whose uid is 16390.  procedure p1
     ** is owned by user u0 and user u0 performs the following
     ** actions:
     **
     ** grant exec on p1 to g12
     ** revoke grant on p1 from u1
     **
     ** There will be two entries in sysprotects for the object
     ** p1, one for the group g12 where protecttype = grant (1)
     ** and one for u1 where protecttype = revoke (2).
     **
     ** For the group g12, the following expression will
     ** evaluate to:
     **
     ** (((+)*abs(16390-16383))*2) + ((1/2)^1))
     ** = ((14) + (0)^1) = 14 + 1 = 15
     **
     ** For the user entry u1, it will evaluate to:
     **
     ** (((+)*abs(4-16383)*2) + ((2/2)^1))
     ** = ((abs(-16379)*2 + (1)^1)
     ** = 16379*2 + 0 = 32758
     **
     ** As the expression evaluates to a bigger number for the
     ** user entry u1, select max() will chose 32758 which,
     ** ANDed with 1 gives 0, i.e., sp_jdbc_stored_procedures will
     ** not display this particular procedure to the user.
     **
     ** When the user u2 invokes sp_jdbc_stored_procedures, there is
     ** only one entry for u2, which is the entry for the group
     ** g12, and so this entry will be selected thus allowing
     ** the procedure in question to be displayed.
     **
     ** Notice that multiplying by 2 makes the number an
     ** even number (meaning the last digit is 0) so what
     ** matters at the end is (protecttype/2)^1.
     **
     */

     or ((select max(((sign(uid)*abs(uid-16383))*2)
     + ((protecttype/2)^1))
   from sysprotects p
   where p.id = o.id /* outer join to correlate  
** with all rows in sysobjects  
*/
   /*
   ** get rows for public, current users, user's groups
   */
   and (p.uid = 0  /* get rows for public */
        or p.uid = user_id() /* current user */
        or p.uid = u.gid) /* users group */
      
   /*
   ** check for SELECT, EXECUTE privilege.
   */
           and (action in (193,224)) /* check for SELECT,EXECUTE  
** privilege  
*/
   )&1 /* more magic...normalize GRANT */
      ) = 1 /* final magic...compare Grants */
    )
order by PROCEDURE_SCHEM, PROCEDURE_NAME
go
exec sp_procxmode 'sp_jdbc_stored_procedures', 'anymode'
go
grant execute on sp_jdbc_stored_procedures to public
go
commit
go
dump transaction sybsystemprocs with truncate_only  
go


/*
**  End of sp_jdbc_stored_procedures
*/



/*
**  sp_jdbc_getprocedurecolumns
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name =
    'sp_jdbc_getprocedurecolumns')
    begin
        drop procedure sp_jdbc_getprocedurecolumns
    end
go
/** SECTION END: CLEANUP **/


create procedure sp_jdbc_getprocedurecolumns (
@sp_qualifier   varchar(32) = null,     /* stored procedure qualifier*/
@sp_owner       varchar(32) = null,     /* stored procedure owner */
@sp_name        varchar(32),            /* stored procedure name */
@column_name    varchar(32) = null)
as
declare @msg varchar(250)
declare @group_num              int
declare @semi_position          int

if @@trancount = 0
begin
set chained off
end

set transaction isolation level 1

if @sp_qualifier is not null
begin
if db_name() != @sp_qualifier
begin
if @sp_qualifier = ''
begin
select @sp_name = ''
select @sp_owner = ''
end
else
begin 
/*  
** 18041, 'Stored Procedure qualifer must be name of
** current database'
*/
exec sp_getmessage 18041, @msg out
raiserror 18041 @msg
return (1)
end
end
end
else
select @sp_qualifier = db_name()

select @semi_position = charindex(';',@sp_name)
if (@semi_position > 0)
begin   /* If group number separator (;) found */
    select @group_num = convert(int,substring(@sp_name, @semi_position + 1, 2))
    select @sp_name = substring(@sp_name, 1, @semi_position -1)
end
else
begin   /* No group separator, so default to group number of 1 */
    select @group_num = 1
end       

if (@sp_owner is null) select @sp_owner ='%'
if (@sp_name is null) select @sp_name ='%'
if (@column_name is null) select @column_name ='%'

/*
 * build a temporary table for holding the results.
 * The following is from the JDBC specification at
 * DatabaseMetaData.getProcedureColumns
 */
create table #jproccols_res
    (PROCEDURE_CAT   varchar(32)  null,
     PROCEDURE_SCHEM varchar(32)  null,
     PROCEDURE_NAME  varchar(32)  not null,
     COLUMN_NAME     varchar(32)  not null,
     COLUMN_TYPE     smallint     not null,  
     DATA_TYPE       smallint     not null,
     TYPE_NAME       varchar(32)  not null,
     "PRECISION"     int          not null,
     LENGTH          int          not null,
     SCALE           smallint     not null,  
     RADIX           smallint     not null,  
     NULLABLE        smallint     not null,
     REMARKS         varchar(255) null,
     colid           int          not null /* hidden, used for ordering */
    )

/*
 * insert defined parameters (if any)
 */
INSERT INTO #jproccols_res
SELECT DISTINCT
    PROCEDURE_CAT   = db_name(),
    PROCEDURE_SCHEM = user_name(o.uid),
    PROCEDURE_NAME  = o.name+';'+ ltrim(str(p.number,5)),
    COLUMN_NAME      = c.name,
    COLUMN_TYPE     = convert(smallint, 0), /*No distinction possible in SQL Server */
    DATA_TYPE       = jdt.data_type,
    TYPE_NAME       = jdt.type_name,
    'PRECISION'     = (isnull(convert(int, c.prec),
                      isnull(convert(int, jdt.data_precision),
                      convert(int, c.length)))
                      +isnull(jdt.aux, convert(int,
                      ascii(substring('???AAAFFFCKFOLS',
                      2*(jdt.ss_dtype%35+1)+2-8/c.length,1))-60))),     
    LENGTH          = (isnull(convert(int, c.length),  
                      convert(int, jdt.length)) +
                      convert(int, isnull(jdt.aux,
                      ascii(substring('AAA<BB<DDDHJSPP',
                      2*(jdt.ss_dtype%35+1)+2-8/c.length,
                      1))-64))),
    SCALE           = (isnull(isnull(convert(smallint, c.scale),  
                       convert(smallint, jdt.numeric_scale)), 0) +
                        convert(smallint, isnull(jdt.aux,
                        ascii(substring('<<<<<<<<<<<<<<?',
                        2*(jdt.ss_dtype%35+1)+2-8/c.length,
                        1))-60))),     
    RADIX           = convert(smallint, 0),  
    NULLABLE        = convert(smallint, 2),  /* procedureNullableUnknown */
    REMARKS         = printfmt,
    colid           = c.colid /* parameter position order */
FROM syscolumns c, sysobjects o, sysusers u, sysprocedures p,
     sybsystemprocs.dbo.spt_jdatatype_info jdt
WHERE jdt.ss_dtype = c.type  
    and c.id = o.id and p.id = o.id  
    and user_name(o.uid) like @sp_owner ESCAPE '\'
    and u.uid = user_id()
    and o.type ='P'
    and o.name like @sp_name ESCAPE '\'
    and c.name like @column_name ESCAPE '\'
    and c.number = @group_num
    and p.number = @group_num


/*
 * add the 'return parameter'
 */
INSERT INTO #jproccols_res     
SELECT DISTINCT
    PROCEDURE_CAT   = db_name(),
    PROCEDURE_SCHEM = user_name(o.uid),
    PROCEDURE_NAME  = o.name+';'+ ltrim(str(p.number,5)),
    COLUMN_NAME     = 'RETURN_VALUE',
    COLUMN_TYPE     = convert(smallint, 5), /* procedureColumnReturn */
    DATA_TYPE       = jdt.data_type,
    TYPE_NAME       = jdt.type_name,
    'PRECISION'     = (isnull(convert(int, jdt.data_precision),
                      convert(int, jdt.length))
                      +isnull(jdt.aux, convert(int,
                      ascii(substring('???AAAFFFCKFOLS',
                      2*(jdt.ss_dtype%35+1)+2-8/jdt.length,1))-60))),     
    LENGTH          = (isnull(jdt.length, convert(int, t.length)) +
                      convert(int, isnull(jdt.aux,
                      ascii(substring('AAA<BB<DDDHJSPP',
                      2*(jdt.ss_dtype%35+1)+2-8/t.length,
                      1))-64))),
    SCALE           = (convert(smallint, jdt.numeric_scale) +
                        convert(smallint, isnull(jdt.aux,
                        ascii(substring('<<<<<<<<<<<<<<?',
                        2*(jdt.ss_dtype%35+1)+2-8/jdt.length,
                        1))-60))),     
    RADIX           = convert(smallint, 0),  
    NULLABLE        = convert(smallint, 0), /* procedureNoNulls */
    REMARKS         = 'procedureColumnReturn',
    colid           = 0 /* always the first parameter */
FROM sybsystemprocs.dbo.spt_jdatatype_info jdt,
     sysobjects o, sysusers u, sysprocedures p,
     systypes t
WHERE jdt.ss_dtype = 56 /* return parameter is an int */
    and t.type = jdt.ss_dtype
    and p.id = o.id  
    and user_name(o.uid) like @sp_owner ESCAPE '\'
    and u.uid = user_id()
    and o.type ='P'
    and o.name like @sp_name ESCAPE '\'
    and 'RETURN_VALUE' like @column_name ESCAPE '\'
    and p.number = @group_num


/*
 * return the data to the client
 */
SELECT PROCEDURE_CAT, PROCEDURE_SCHEM, PROCEDURE_NAME, COLUMN_NAME,
    COLUMN_TYPE, DATA_TYPE, TYPE_NAME, "PRECISION", LENGTH, SCALE,
    RADIX, NULLABLE, REMARKS
FROM #jproccols_res
ORDER BY PROCEDURE_SCHEM, PROCEDURE_NAME, colid

/*  
 * cleanup
 */
DROP TABLE #jproccols_res
go

exec sp_procxmode 'sp_jdbc_getprocedurecolumns', 'anymode'
go
grant execute on sp_jdbc_getprocedurecolumns to public
go
commit
go

/*
**  End of sp_jdbc_getprocedurecolumns
*/


/*
**  sp_jdbc_getversioncolumns
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

if exists (select * from sysobjects where name = 'sp_jdbc_getversioncolumns')
begin
drop procedure sp_jdbc_getversioncolumns
end
go
/** SECTION END: CLEANUP **/

create procedure sp_jdbc_getversioncolumns (
@table_qualifier varchar(32) = null,
@table_owner varchar(32) = null,
@table_name varchar(32))
as
declare @indid int
declare @table_id int
declare @dbname char(30)
declare @full_table_name char(70)
declare @msg char(70)
declare @owner char(32)

create table #versionhelp (SCOPE smallint null, COLUMN_NAME varchar(32) null,
DATA_TYPE int null, TYPE_NAME varchar(8) null, COLUMN_SIZE int null,
BUFFER_LENGTH smallint null, DECIMAL_DIGITS smallint null,   
PSEUDO_COLUMN smallint null)

if @@trancount = 0
begin
set chained off
end

set transaction isolation level 1

/* get database name */
select @dbname = db_name()

/* we don't want a temp table unless we're in tempdb */
if @table_name like '#%' and @dbname != 'tempdb'
begin 
exec sp_getmessage 17676, @msg output
raiserror 17676 @msg
return (1)
end

if @table_qualifier is not null
begin
/* if qualifier doesn't match current database */
if @dbname != @table_qualifier
begin 
exec sp_getmessage 18039, @msg output
raiserror 18039 @msg
return (1)
end
end

    if (@table_owner is null) select @table_owner = '%'
    else
    begin
        /*         
        ** NOTE: SQL Server allows an underscore '_' in the table owner, even  
        **       though it is a single character wildcard.
        */
        if (charindex('%',@table_owner) > 0)
        begin
            exec sp_getmessage 17993, @msg output
            raiserror 17993 @msg, @table_owner
            return(1)
        end
        exec sp_jdbc_escapeliteralforlike @table_owner output
    end
     
    if (@table_name is null)  
    begin
       exec sp_getmessage 17993, @msg output
       raiserror 17993 @msg, 'NULL'
       return(1)
    end
     
    if (select count(*)  
        from sysobjects
        where user_name(uid)  
        like @table_owner ESCAPE '\'
      and name = @table_name) = 0  
    begin
      exec sp_getmessage 17674, @msg output
      raiserror 17674 @msg
      return 1
    end
    else  
    begin
declare version_cur cursor for
             select @table_owner = user_name(uid) from sysobjects  
    where name = @table_name and user_name(uid) like @table_owner

open version_cur
fetch version_cur into @owner

while (@@sqlstatus = 0)
        begin
           if @owner is null
      begin /* if unqualified table name */
select @full_table_name = @table_name
      end
    else
    begin /* qualified table name */
select @full_table_name = @owner + '.' + @table_name
    end

    /* get object ID */
    select @table_id = object_id(@full_table_name)

    insert into #versionhelp select
convert(smallint, 0),
c.name ,
(select data_type from  
sybsystemprocs.dbo.spt_jdatatype_info
where type_name = 'binary'),
'BINARY',
isnull(d.data_precision,
convert(int,c.length))
+ isnull(d.aux, convert(int,
ascii(substring('???AAAFFFCKFOLS',
2*(d.ss_dtype%35+1)+2-8/c.length,1))
-60)),
18, /* Number of chars = 2^4 byte + '0x' */
isnull(d.numeric_scale + convert(smallint,
isnull(d.aux,
ascii(substring('<<<<<<<<<<<<<<?',
2*(d.ss_dtype%35+1)+2-8/c.length, 1))
-60)),0),
1
  from
systypes t, syscolumns c,  
sybsystemprocs.dbo.spt_jdatatype_info d
where
c.id = @table_id
and c.type = d.ss_dtype
and c.usertype = 80 /* TIMESTAMP */
and t.usertype = 80 /* TIMESTAMP */
    fetch version_cur into @owner
end
    end
    select * from #versionhelp
go
exec sp_procxmode 'sp_jdbc_getversioncolumns', 'anymode'
go
grant execute on sp_jdbc_getversioncolumns to public
go
commit
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_jdbc_getversioncolumns
*/



/*
**  sp_default_charset
*/

/*  
** obtain the SQL server default charset
*/


/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go
  
if exists (select * from sysobjects where name = 'sp_default_charset')
begin
        drop procedure sp_default_charset
end
go
/** SECTION END: CLEANUP **/
  

/*
**  create a procedure that will query the datasource
**  specific syscharset, and sysconfigures tables, and do a join to  
**  determine what is the correct charset that has been set as a default
**  on the server.
*/
create procedure sp_default_charset
as

    if @@trancount = 0
    begin
    set chained off
    end
     
    set transaction isolation level 1

    select name as DEFAULT_CHARSET from master.dbo.syscharsets
       where ((select value from master.dbo.sysconfigures       
               where config=131)  /* default charset id */
              = master.dbo.syscharsets.id)
go
exec sp_procxmode 'sp_default_charset', 'anymode'
go
grant execute on sp_default_charset to public
go
dump transaction sybsystemprocs with truncate_only  
go

/*
**  End of sp_default_charset
*/

/*  
** JDBC 2.0
**  
** DatabaseMetaData.getUDTs(catalog, schema, typeNamePattern, int types[])
**
** NOT SUPPORTED
*/
/** SECTION BEGIN: CLEANUP **/
if exists (select * from sysobjects where name = 'sp_jdbc_getudts')
begin
        drop procedure sp_jdbc_getudts
end
go
/** SECTION END: CLEANUP **/
create procedure sp_jdbc_getudts (
        @table_qualifier        varchar(128) = NULL,
        @table_owner            varchar(128) = NULL,
        @type_name_pattern      varchar(128),
        @types                  varchar(128))
as
    declare @empty_string varchar(1)
    declare @empty_int int
     
    select @empty_string = ''
    select @empty_int = 0

    /* not supported, return an empty result set */     
    select  
        TYPE_CAT = @empty_string,
        TYPE_SCHEM = @empty_string,
        TYPE_NAME = @empty_string,
        CLASS_NAME = @empty_string,
        DATA_TYPE = @empty_int,
        REMARDS = @empty_string
    where
        1 = 2
go

/* end of dbo.sp_jdbc_getudts */
exec sp_procxmode 'sp_jdbc_getudts', 'anymode'
go
grant execute on sp_jdbc_getudts to public
go
dump transaction sybsystemprocs with truncate_only  
go

/** SECTION BEGIN: CLEANUP **/
use sybsystemprocs  
go

sp_configure 'allow updates', 0
go
/** SECTION END: CLEANUP **/

/*
**  End of sql_server.sql
*/
