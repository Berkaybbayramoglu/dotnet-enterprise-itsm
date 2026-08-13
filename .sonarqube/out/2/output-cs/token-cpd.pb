œ
c/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IWorkflowService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
IWorkflowService !
{ 
Task 
< 	
IEnumerable	 
< 
WorkflowDto  
>  !
>! "
GetWorkflowsAsync# 4
(4 5
int5 8
?8 9
	projectId: C
=D E
nullF J
)J K
;K L
Task		 
<		 	
WorkflowDto			 
?		 
>		  
GetWorkflowByIdAsync		 +
(		+ ,
int		, /
id		0 2
)		2 3
;		3 4
Task

 
<

 	
WorkflowDto

	 
>

 
CreateWorkflowAsync

 )
(

) *
CreateWorkflowDto

* ;
dto

< ?
)

? @
;

@ A
Task 
UpdateWorkflowAsync	 
( 
int  
id! #
,# $
UpdateWorkflowDto% 6
dto7 :
): ;
;; <
Task 
DeleteWorkflowAsync	 
( 
int  
id! #
)# $
;$ %
Task 
< 	
IEnumerable	 
< !
WorkflowTransitionDto *
>* +
>+ ,+
GetTransitionsByWorkflowIdAsync- L
(L M
intM P

workflowIdQ [
)[ \
;\ ]
Task 
< 	!
WorkflowTransitionDto	 
? 
>  "
GetTransitionByIdAsync! 7
(7 8
int8 ;
id< >
)> ?
;? @
Task 
< 	!
WorkflowTransitionDto	 
> !
CreateTransitionAsync  5
(5 6'
CreateWorkflowTransitionDto6 Q
dtoR U
)U V
;V W
Task !
UpdateTransitionAsync	 
( 
int "
id# %
,% &'
UpdateWorkflowTransitionDto' B
dtoC F
)F G
;G H
Task !
DeleteTransitionAsync	 
( 
int "
id# %
)% &
;& '
} ç
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/ITicketService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
ITicketService 
{ 
Task 
< 	
	TicketDto	 
> 
CreateTicketAsync %
(% &
CreateTicketDto& 5
dto6 9
)9 :
;: ;
Task		 
<		 	
	TicketDto			 
?		 
>		 
GetTicketByIdAsync		 '
(		' (
int		( +
id		, .
)		. /
;		/ 0
Task

 
UpdateTicketAsync

	 
(

 
int

 
id

 !
,

! "
UpdateTicketDto

# 2
dto

3 6
,

6 7
int

8 ;
currentUserId

< I
)

I J
;

J K
Task 
ChangeStatusAsync	 
( 
int 
ticketId '
,' (
ChangeStatusDto) 8
dto9 <
)< =
;= >
Task 
AssignTicketAsync	 
( 
int 
ticketId '
,' (
AssignTicketDto) 8
dto9 <
)< =
;= >
Task 
TransferTicketAsync	 
( 
int  
ticketId! )
,) *
TransferTicketDto+ <
dto= @
)@ A
;A B
Task 
< 	
TicketCommentDto	 
> 
AddCommentAsync *
(* +
int+ .
ticketId/ 7
,7 8
CreateCommentDto9 I
dtoJ M
)M N
;N O
Task 
< 	
IEnumerable	 
< 
TicketCommentDto %
>% &
>& '
GetCommentsAsync( 8
(8 9
int9 <
ticketId= E
,E F
boolG K
includeInternalL [
)[ \
;\ ]
Task 
< 	
TicketAttachmentDto	 
> 
AddAttachmentAsync 0
(0 1
int1 4
ticketId5 =
,= >
	IFormFile? H
fileI M
,M N
intO R
userIdS Y
)Y Z
;Z [
Task 
< 	
IEnumerable	 
< 
TicketAttachmentDto (
>( )
>) *
GetAttachmentsAsync+ >
(> ?
int? B
ticketIdC K
)K L
;L M
Task 
AddWatcherAsync	 
( 
int 
ticketId %
,% &
int' *
userId+ 1
)1 2
;2 3
Task 
RemoveWatcherAsync	 
( 
int 
ticketId  (
,( )
int* -
userId. 4
)4 5
;5 6
Task 
< 	
IEnumerable	 
< 
TicketWatcherDto %
>% &
>& '
GetWatchersAsync( 8
(8 9
int9 <
ticketId= E
)E F
;F G
Task 
< 	
IEnumerable	 
< 
TimelineEventDto %
>% &
>& '
GetTimelineAsync( 8
(8 9
int9 <
ticketId= E
,E F
boolG K
includeInternalL [
)[ \
;\ ]
} ¢
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IRepository.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
IRepository 
< 
T 
> 
where  %
T& '
:( )

BaseEntity* 4
{ 
Task 
< 	
IEnumerable	 
< 
T 
> 
> 
GetAllAsync $
($ %

Expression% /
</ 0
Func0 4
<4 5
T5 6
,6 7
bool8 <
>< =
>= >
?> ?
	predicate@ I
=J K
nullL P
)P Q
;Q R
Task		 
<		 	
T			 

?		
 
>		 
GetByIdAsync		 
(		 
int		 
id		  
)		  !
;		! "
Task

 
<

 	
T

	 

>


 
AddAsync

 
(

 
T

 
entity

 
)

 
;

 
Task 
UpdateAsync	 
( 
T 
entity 
) 
; 
Task 
DeleteAsync	 
( 
int 
id 
) 
; 
} —
h/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IPermissionCalculator.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface !
IPermissionCalculator &
{ 
Task 
< 	
HashSet	 
< 
string 
> 
> .
"CalculateEffectivePermissionsAsync <
(< =
int= @
userIdA G
)G H
;H I
} ∞5
g/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IOrganizationService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
IDepartmentService #
{ 
Task 
< 	
IEnumerable	 
< 
DepartmentDto "
>" #
># $
GetAllAsync% 0
(0 1
)1 2
;2 3
Task 
< 	
DepartmentDto	 
? 
> 
GetByIdAsync %
(% &
int& )
id* ,
), -
;- .
Task		 
<		 	
DepartmentDto			 
>		 
CreateAsync		 #
(		# $
CreateDepartmentDto		$ 7
dto		8 ;
)		; <
;		< =
Task

 
UpdateAsync

	 
(

 
int

 
id

 
,

 
UpdateDepartmentDto

 0
dto

1 4
)

4 5
;

5 6
Task 
DeleteAsync	 
( 
int 
id 
) 
; 
} 
public 
	interface 
IGroupService 
{ 
Task 
< 	
IEnumerable	 
< 
GroupDto 
> 
> 
GetAllAsync  +
(+ ,
), -
;- .
Task 
< 	
GroupDto	 
? 
> 
GetByIdAsync  
(  !
int! $
id% '
)' (
;( )
Task 
< 	
GroupDto	 
> 
CreateAsync 
( 
CreateGroupDto -
dto. 1
)1 2
;2 3
Task 
UpdateAsync	 
( 
int 
id 
, 
UpdateGroupDto +
dto, /
)/ 0
;0 1
Task 
DeleteAsync	 
( 
int 
id 
) 
; 
Task 
AddMemberAsync	 
( 
int 
groupId #
,# $
int% (
userId) /
)/ 0
;0 1
Task 
RemoveMemberAsync	 
( 
int 
groupId &
,& '
int( +
userId, 2
)2 3
;3 4
} 
public 
	interface 
IUserService 
{ 
Task 
< 	
IEnumerable	 
< 
UserDto 
> 
> 
GetAllAsync *
(* +
)+ ,
;, -
Task 
< 	
UserDto	 
? 
> 
GetByIdAsync 
(  
int  #
id$ &
)& '
;' (
Task 
< 	
UserDto	 
> 
CreateAsync 
( 
CreateUserDto +
dto, /
)/ 0
;0 1
Task 
UpdateAsync	 
( 
int 
id 
, 
UpdateUserDto *
dto+ .
). /
;/ 0
Task 
DeleteAsync	 
( 
int 
id 
) 
; 
Task   
AssignRoleAsync  	 
(   
int   
userId   #
,  # $
int  % (
roleId  ) /
)  / 0
;  0 1
Task!! 
RevokeRoleAsync!!	 
(!! 
int!! 
userId!! #
,!!# $
int!!% (
roleId!!) /
)!!/ 0
;!!0 1
Task"" &
AddPermissionOverrideAsync""	 #
(""# $
int""$ '
userId""( .
,"". /
int""0 3
permissionId""4 @
,""@ A
bool""B F
	isGranted""G P
)""P Q
;""Q R
}## 
public%% 
	interface%% 
IProjectService%%  
{&& 
Task'' 
<'' 	
IEnumerable''	 
<'' 

ProjectDto'' 
>''  
>''  !
GetAllAsync''" -
(''- .
)''. /
;''/ 0
Task(( 
<(( 	

ProjectDto((	 
?(( 
>(( 
GetByIdAsync(( "
(((" #
int((# &
id((' )
)(() *
;((* +
Task)) 
<)) 	

ProjectDto))	 
>)) 
CreateAsync))  
())  !
CreateProjectDto))! 1
dto))2 5
)))5 6
;))6 7
Task** 
UpdateAsync**	 
(** 
int** 
id** 
,** 
UpdateProjectDto** -
dto**. 1
)**1 2
;**2 3
Task++ 
DeleteAsync++	 
(++ 
int++ 
id++ 
)++ 
;++ 
Task,, 
AddMemberAsync,,	 
(,, 
int,, 
	projectId,, %
,,,% &
int,,' *
userId,,+ 1
),,1 2
;,,2 3
Task-- 
RemoveMemberAsync--	 
(-- 
int-- 
	projectId-- (
,--( )
int--* -
userId--. 4
)--4 5
;--5 6
}.. 
public00 
	interface00 
IRoleService00 
{11 
Task22 
<22 	
IEnumerable22	 
<22 
RoleDto22 
>22 
>22 
GetAllAsync22 *
(22* +
)22+ ,
;22, -
Task33 
<33 	
RoleDto33	 
?33 
>33 
GetByIdAsync33 
(33  
int33  #
id33$ &
)33& '
;33' (
Task44 
<44 	
RoleDto44	 
>44 
CreateAsync44 
(44 
CreateRoleDto44 +
dto44, /
)44/ 0
;440 1
Task55 
UpdateAsync55	 
(55 
int55 
id55 
,55 
UpdateRoleDto55 *
dto55+ .
)55. /
;55/ 0
Task66 
DeleteAsync66	 
(66 
int66 
id66 
)66 
;66 
Task77 !
AssignPermissionAsync77	 
(77 
int77 "
roleId77# )
,77) *
int77+ .
permissionId77/ ;
)77; <
;77< =
Task88 !
RevokePermissionAsync88	 
(88 
int88 "
roleId88# )
,88) *
int88+ .
permissionId88/ ;
)88; <
;88< =
}99 ∏(
W/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/TicketDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
	TicketDto 
( 
int 
Id 
, 
string  &
TicketNumber' 3
,3 4
string5 ;
Title< A
,A B
stringC I
DescriptionJ U
,U V
intW Z
	ProjectId[ d
,d e
intf i

CategoryIdj t
,t u
intv y
TypeId	z Ä
,
Ä Å
int
Ç Ö
StatusId
Ü é
,
é è
int
ê ì

PriorityId
î û
,
û ü
int
† £
RequesterUserId
§ ≥
,
≥ ¥
int
µ ∏
?
∏ π
AssignedUserId
∫ »
,
» …
int
  Õ
?
Õ Œ
AssignedGroupId
œ ﬁ
)
ﬁ ﬂ
;
ﬂ ‡
public 
record 
CreateTicketDto 
( 
string $
Title% *
,* +
string, 2
Description3 >
,> ?
int@ C
	ProjectIdD M
,M N
intO R

CategoryIdS ]
,] ^
int_ b
TypeIdc i
,i j
intk n

PriorityIdo y
,y z
int{ ~
RequesterUserId	 é
,
é è

Dictionary
ê ö
<
ö õ
string
õ °
,
° ¢
string
£ ©
>
© ™
CustomFields
´ ∑
)
∑ ∏
;
∏ π
public 
record 
UpdateTicketDto 
( 
string $
Title% *
,* +
string, 2
Description3 >
,> ?
int@ C

CategoryIdD N
,N O
intP S

PriorityIdT ^
,^ _

Dictionary` j
<j k
stringk q
,q r
strings y
>y z
CustomFields	{ á
)
á à
;
à â
public 
record 
TicketHistoryDto 
( 
int "
Id# %
,% &
int' *
TicketId+ 3
,3 4
string5 ;
	FieldName< E
,E F
stringG M
?M N
OldValueO W
,W X
stringY _
?_ `
NewValuea i
,i j
stringk q
Actionr x
,x y
DateTime	z Ç
	CreatedAt
É å
)
å ç
;
ç é
public 
record 
TicketCommentDto 
( 
int "
Id# %
,% &
int' *
TicketId+ 3
,3 4
int5 8
AuthorUserId9 E
,E F
stringG M
ContentN U
,U V
boolW [

IsInternal\ f
,f g
DateTimeh p
	CreatedAtq z
)z {
;{ |
public		 
record		 
CreateCommentDto		 
(		 
string		 %
Content		& -
,		- .
bool		/ 3

IsInternal		4 >
,		> ?
int		@ C
AuthorUserId		D P
)		P Q
;		Q R
public 
record 
TicketAttachmentDto !
(! "
int" %
Id& (
,( )
int* -
TicketId. 6
,6 7
string8 >
FileName? G
,G H
stringI O
FilePathP X
,X Y
longZ ^
FileSize_ g
,g h
stringi o
ContentTypep {
,{ |
int	} Ä
UploadedByUserId
Å ë
,
ë í
DateTime
ì õ
	CreatedAt
ú •
)
• ¶
;
¶ ß
public 
record 
TicketWatcherDto 
( 
int "
TicketId# +
,+ ,
int- 0
UserId1 7
)7 8
;8 9
public 
record 
TimelineEventDto 
( 
string %
	EventType& /
,/ 0
DateTime1 9
	Timestamp: C
,C D
objectE K
DataL P
)P Q
;Q R
public 
record 
AssignTicketDto 
( 
int !
UserId" (
,( )
int* -
AssignerUserId. <
)< =
;= >
public 
record 
TransferTicketDto 
(  
int  #
?# $
	ProjectId% .
,. /
int0 3
?3 4
GroupId5 <
,< =
int> A
TransferrerUserIdB S
)S T
;T U
public 
record 
ChangeStatusDto 
( 
int !
NewStatusId" -
,- .
int/ 2
UserId3 9
)9 :
;: ;∫
f/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IDynamicFormService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
IDynamicFormService $
{ 
Task 
< 	
IEnumerable	 
< 
FieldDefinitionDto '
>' (
>( )$
GetFieldDefinitionsAsync* B
(B C
)C D
;D E
Task		 
<		 	
FieldDefinitionDto			 
?		 
>		 '
GetFieldDefinitionByIdAsync		 9
(		9 :
int		: =
id		> @
)		@ A
;		A B
Task

 
<

 	
FieldDefinitionDto

	 
>

 &
CreateFieldDefinitionAsync

 7
(

7 8$
CreateFieldDefinitionDto

8 P
dto

Q T
)

T U
;

U V
Task &
UpdateFieldDefinitionAsync	 #
(# $
int$ '
id( *
,* +$
UpdateFieldDefinitionDto, D
dtoE H
)H I
;I J
Task &
DeleteFieldDefinitionAsync	 #
(# $
int$ '
id( *
)* +
;+ ,
Task 
< 	
IEnumerable	 
< 
FieldOptionDto #
># $
>$ % 
GetFieldOptionsAsync& :
(: ;
int; >
fieldDefinitionId? P
)P Q
;Q R
Task 
< 	
FieldOptionDto	 
? 
> #
GetFieldOptionByIdAsync 1
(1 2
int2 5
id6 8
)8 9
;9 :
Task 
< 	
FieldOptionDto	 
> "
CreateFieldOptionAsync /
(/ 0 
CreateFieldOptionDto0 D
dtoE H
)H I
;I J
Task "
UpdateFieldOptionAsync	 
(  
int  #
id$ &
,& ' 
UpdateFieldOptionDto( <
dto= @
)@ A
;A B
Task "
DeleteFieldOptionAsync	 
(  
int  #
id$ &
)& '
;' (
Task 
< 	
IEnumerable	 
< !
FormFieldPlacementDto *
>* +
>+ ,
GetPlacementsAsync- ?
(? @
int@ C
?C D
	projectIdE N
,N O
intP S
?S T

categoryIdU _
,_ `
inta d
?d e
ticketTypeIdf r
)r s
;s t
Task 
< 	!
FormFieldPlacementDto	 
? 
>  !
GetPlacementByIdAsync! 6
(6 7
int7 :
id; =
)= >
;> ?
Task 
< 	!
FormFieldPlacementDto	 
>  
CreatePlacementAsync  4
(4 5'
CreateFormFieldPlacementDto5 P
dtoQ T
)T U
;U V
Task  
UpdatePlacementAsync	 
( 
int !
id" $
,$ %'
UpdateFormFieldPlacementDto& A
dtoB E
)E F
;F G
Task  
DeletePlacementAsync	 
( 
int !
id" $
)$ %
;% &
} ó 
b/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/ICatalogService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
ICatalogService  
{ 
Task 
< 	
IEnumerable	 
< 
CategoryDto  
>  !
>! "
GetCategoriesAsync# 5
(5 6
int6 9
?9 :
	projectId; D
=E F
nullG K
)K L
;L M
Task		 
<		 	
CategoryDto			 
?		 
>		  
GetCategoryByIdAsync		 +
(		+ ,
int		, /
id		0 2
)		2 3
;		3 4
Task

 
<

 	
CategoryDto

	 
>

 
CreateCategoryAsync

 )
(

) *
CreateCategoryDto

* ;
dto

< ?
)

? @
;

@ A
Task 
UpdateCategoryAsync	 
( 
int  
id! #
,# $
UpdateCategoryDto% 6
dto7 :
): ;
;; <
Task 
DeleteCategoryAsync	 
( 
int  
id! #
)# $
;$ %
Task 
< 	
IEnumerable	 
< 
TicketTypeDto "
>" #
># $
GetTicketTypesAsync% 8
(8 9
)9 :
;: ;
Task 
< 	
TicketTypeDto	 
? 
> "
GetTicketTypeByIdAsync /
(/ 0
int0 3
id4 6
)6 7
;7 8
Task 
< 	
TicketTypeDto	 
> !
CreateTicketTypeAsync -
(- .
CreateTicketTypeDto. A
dtoB E
)E F
;F G
Task !
UpdateTicketTypeAsync	 
( 
int "
id# %
,% &
UpdateTicketTypeDto' :
dto; >
)> ?
;? @
Task !
DeleteTicketTypeAsync	 
( 
int "
id# %
)% &
;& '
Task 
< 	
IEnumerable	 
< 
	StatusDto 
> 
>  
GetStatusesAsync! 1
(1 2
)2 3
;3 4
Task 
< 	
	StatusDto	 
? 
> 
GetStatusByIdAsync '
(' (
int( +
id, .
). /
;/ 0
Task 
< 	
	StatusDto	 
> 
CreateStatusAsync %
(% &
CreateStatusDto& 5
dto6 9
)9 :
;: ;
Task 
UpdateStatusAsync	 
( 
int 
id !
,! "
UpdateStatusDto# 2
dto3 6
)6 7
;7 8
Task 
DeleteStatusAsync	 
( 
int 
id !
)! "
;" #
Task 
< 	
IEnumerable	 
< 
PriorityDto  
>  !
>! "
GetPrioritiesAsync# 5
(5 6
)6 7
;7 8
Task 
< 	
PriorityDto	 
? 
>  
GetPriorityByIdAsync +
(+ ,
int, /
id0 2
)2 3
;3 4
Task 
< 	
PriorityDto	 
> 
CreatePriorityAsync )
() *
CreatePriorityDto* ;
dto< ?
)? @
;@ A
Task   
UpdatePriorityAsync  	 
(   
int    
id  ! #
,  # $
UpdatePriorityDto  % 6
dto  7 :
)  : ;
;  ; <
Task!! 
DeletePriorityAsync!!	 
(!! 
int!!  
id!!! #
)!!# $
;!!$ %
}"" ∑	
_/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IAuthService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
ITokenService 
{ 
string 

GenerateToken 
( 
int 
userId #
,# $
string% +
username, 4
,4 5
IEnumerable6 A
<A B
stringB H
>H I
rolesJ O
,O P
IEnumerableQ \
<\ ]
string] c
>c d
permissionse p
)p q
;q r
} 
public

 
	interface

 
IAuthService

 
{ 
Task 
< 	
AuthResponseDto	 
> 

LoginAsync $
($ %
LoginRequestDto% 4
request5 <
)< =
;= >
Task 
< 	
MeResponseDto	 
> 

GetMeAsync "
(" #
int# &
userId' -
)- .
;. /
} £
Y/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/WorkflowDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
WorkflowDto 
( 
int 
Id  
,  !
string" (
Name) -
,- .
string/ 5
?5 6
Description7 B
,B C
intD G
?G H
	ProjectIdI R
,R S
boolT X
IsActiveY a
)a b
;b c
public 
record 
CreateWorkflowDto 
(  
string  &
Name' +
,+ ,
string- 3
?3 4
Description5 @
,@ A
intB E
?E F
	ProjectIdG P
)P Q
;Q R
public 
record 
UpdateWorkflowDto 
(  
string  &
Name' +
,+ ,
string- 3
?3 4
Description5 @
,@ A
intB E
?E F
	ProjectIdG P
,P Q
boolR V
IsActiveW _
)_ `
;` a
public		 
record		 !
WorkflowTransitionDto		 #
(		# $
int		$ '
Id		( *
,		* +
int		, /

WorkflowId		0 :
,		: ;
int		< ?
FromStatusId		@ L
,		L M
int		N Q

ToStatusId		R \
,		\ ]
string		^ d
TransitionName		e s
,		s t
string		u {
?		{ |"
RequiredPermissionKey			} í
,
		í ì
int
		î ó
	SortOrder
		ò °
,
		° ¢
bool
		£ ß
IsActive
		® ∞
)
		∞ ±
;
		± ≤
public

 
record

 '
CreateWorkflowTransitionDto

 )
(

) *
int

* -

WorkflowId

. 8
,

8 9
int

: =
FromStatusId

> J
,

J K
int

L O

ToStatusId

P Z
,

Z [
string

\ b
TransitionName

c q
,

q r
string

s y
?

y z"
RequiredPermissionKey	

{ ê
,


ê ë
int


í ï
	SortOrder


ñ ü
)


ü †
;


† °
public 
record '
UpdateWorkflowTransitionDto )
() *
int* -
FromStatusId. :
,: ;
int< ?

ToStatusId@ J
,J K
stringL R
TransitionNameS a
,a b
stringc i
?i j"
RequiredPermissionKey	k Ä
,
Ä Å
int
Ç Ö
	SortOrder
Ü è
,
è ê
bool
ë ï
IsActive
ñ û
)
û ü
;
ü †≈
f/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IFileStorageService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
IFileStorageService $
{ 
Task 
< 	
string	 
> 
SaveFileAsync 
( 
	IFormFile (
file) -
,- .
int/ 2
ticketId3 ;
); <
;< =
Task		 
DeleteFileAsync			 
(		 
string		 
filePath		  (
)		( )
;		) *
}

 ∞%
]/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/OrganizationDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
DepartmentDto 
( 
int 
Id  "
," #
string$ *
Name+ /
,/ 0
string1 7
?7 8
Description9 D
,D E
boolF J
IsActiveK S
)S T
;T U
public 
record 
CreateDepartmentDto !
(! "
string" (
Name) -
,- .
string/ 5
?5 6
Description7 B
)B C
;C D
public 
record 
UpdateDepartmentDto !
(! "
string" (
Name) -
,- .
string/ 5
?5 6
Description7 B
,B C
boolD H
IsActiveI Q
)Q R
;R S
public 
record 
GroupDto 
( 
int 
Id 
, 
string %
Name& *
,* +
bool, 0
IsActive1 9
,9 :
int; >
DepartmentId? K
)K L
;L M
public 
record 
CreateGroupDto 
( 
string #
Name$ (
,( )
int* -
DepartmentId. :
): ;
;; <
public		 
record		 
UpdateGroupDto		 
(		 
string		 #
Name		$ (
,		( )
bool		* .
IsActive		/ 7
,		7 8
int		9 <
DepartmentId		= I
)		I J
;		J K
public 
record 
UserDto 
( 
int 
Id 
, 
string $
Username% -
,- .
string/ 5
Email6 ;
,; <
string= C
	FirstNameD M
,M N
stringO U
LastNameV ^
,^ _
bool` d
IsActivee m
,m n
into r
?r s
DepartmentId	t Ä
)
Ä Å
;
Å Ç
public 
record 
CreateUserDto 
( 
string "
Username# +
,+ ,
string- 3
Email4 9
,9 :
string; A
	FirstNameB K
,K L
stringM S
LastNameT \
,\ ]
string^ d
Passworde m
,m n
into r
?r s
DepartmentId	t Ä
)
Ä Å
;
Å Ç
public 
record 
UpdateUserDto 
( 
string "
Email# (
,( )
string* 0
	FirstName1 :
,: ;
string< B
LastNameC K
,K L
boolM Q
IsActiveR Z
,Z [
int\ _
?_ `
DepartmentIda m
)m n
;n o
public 
record 

ProjectDto 
( 
int 
Id 
,  
string! '
Name( ,
,, -
string. 4

ProjectKey5 ?
,? @
stringA G
?G H
DescriptionI T
,T U
boolV Z
IsActive[ c
)c d
;d e
public 
record 
CreateProjectDto 
( 
string %
Name& *
,* +
string, 2

ProjectKey3 =
,= >
string? E
?E F
DescriptionG R
)R S
;S T
public 
record 
UpdateProjectDto 
( 
string %
Name& *
,* +
string, 2

ProjectKey3 =
,= >
string? E
?E F
DescriptionG R
,R S
boolT X
IsActiveY a
)a b
;b c
public 
record 
RoleDto 
( 
int 
Id 
, 
string $
Name% )
,) *
bool+ /
IsActive0 8
)8 9
;9 :
public 
record 
CreateRoleDto 
( 
string "
Name# '
)' (
;( )
public 
record 
UpdateRoleDto 
( 
string "
Name# '
,' (
bool) -
IsActive. 6
)6 7
;7 8˙%
X/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/CatalogDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
CategoryDto 
( 
int 
Id  
,  !
string" (
Name) -
,- .
int/ 2
	ProjectId3 <
,< =
int> A
?A B
ParentCategoryIdC S
,S T
stringU [
?[ \
Description] h
,h i
intj m
?m n#
DefaultAssigneeGroupId	o Ö
,
Ö Ü
bool
á ã
IsActive
å î
)
î ï
;
ï ñ
public 
record 
CreateCategoryDto 
(  
string  &
Name' +
,+ ,
int- 0
	ProjectId1 :
,: ;
int< ?
?? @
ParentCategoryIdA Q
,Q R
stringS Y
?Y Z
Description[ f
,f g
inth k
?k l#
DefaultAssigneeGroupId	m É
)
É Ñ
;
Ñ Ö
public 
record 
UpdateCategoryDto 
(  
string  &
Name' +
,+ ,
int- 0
	ProjectId1 :
,: ;
int< ?
?? @
ParentCategoryIdA Q
,Q R
stringS Y
?Y Z
Description[ f
,f g
inth k
?k l#
DefaultAssigneeGroupId	m É
,
É Ñ
bool
Ö â
IsActive
ä í
)
í ì
;
ì î
public		 
record		 
TicketTypeDto		 
(		 
int		 
Id		  "
,		" #
string		$ *
Name		+ /
,		/ 0
bool		1 5
IsActive		6 >
)		> ?
;		? @
public

 
record

 
CreateTicketTypeDto

 !
(

! "
string

" (
Name

) -
)

- .
;

. /
public 
record 
UpdateTicketTypeDto !
(! "
string" (
Name) -
,- .
bool/ 3
IsActive4 <
)< =
;= >
public 
record 
	StatusDto 
( 
int 
Id 
, 
string  &
Name' +
,+ ,
string- 3
?3 4
ColorHex5 =
,= >
int? B
	SortOrderC L
,L M
boolN R
IsClosedStatusS a
,a b
boolc g
IsSystemDefaulth w
,w x
booly }
IsActive	~ Ü
)
Ü á
;
á à
public 
record 
CreateStatusDto 
( 
string $
Name% )
,) *
string+ 1
?1 2
ColorHex3 ;
,; <
int= @
	SortOrderA J
,J K
boolL P
IsClosedStatusQ _
,_ `
boola e
IsSystemDefaultf u
)u v
;v w
public 
record 
UpdateStatusDto 
( 
string $
Name% )
,) *
string+ 1
?1 2
ColorHex3 ;
,; <
int= @
	SortOrderA J
,J K
boolL P
IsClosedStatusQ _
,_ `
boola e
IsSystemDefaultf u
,u v
boolw {
IsActive	| Ñ
)
Ñ Ö
;
Ö Ü
public 
record 
PriorityDto 
( 
int 
Id  
,  !
string" (
Name) -
,- .
string/ 5
?5 6
ColorHex7 ?
,? @
intA D
WeightE K
,K L
intM P
SeverityLevelQ ^
,^ _
bool` d
IsActivee m
)m n
;n o
public 
record 
CreatePriorityDto 
(  
string  &
Name' +
,+ ,
string- 3
?3 4
ColorHex5 =
,= >
int? B
WeightC I
,I J
intK N
SeverityLevelO \
)\ ]
;] ^
public 
record 
UpdatePriorityDto 
(  
string  &
Name' +
,+ ,
string- 3
?3 4
ColorHex5 =
,= >
int? B
WeightC I
,I J
intK N
SeverityLevelO \
,\ ]
bool^ b
IsActivec k
)k l
;l mí 
\/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/DynamicFormDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
FieldDefinitionDto  
(  !
int! $
Id% '
,' (
string) /
Key0 3
,3 4
string5 ;
Label< A
,A B
stringC I
	FieldTypeJ S
,S T
stringU [
?[ \
ValidationRegex] l
,l m
booln r
IsActives {
){ |
;| }
public 
record $
CreateFieldDefinitionDto &
(& '
string' -
Key. 1
,1 2
string3 9
Label: ?
,? @
stringA G
	FieldTypeH Q
,Q R
stringS Y
?Y Z
ValidationRegex[ j
)j k
;k l
public 
record $
UpdateFieldDefinitionDto &
(& '
string' -
Key. 1
,1 2
string3 9
Label: ?
,? @
stringA G
	FieldTypeH Q
,Q R
stringS Y
?Y Z
ValidationRegex[ j
,j k
booll p
IsActiveq y
)y z
;z {
public		 
record		 
FieldOptionDto		 
(		 
int		  
Id		! #
,		# $
int		% (
FieldDefinitionId		) :
,		: ;
string		< B
Value		C H
,		H I
string		J P
Label		Q V
,		V W
int		X [
	SortOrder		\ e
,		e f
bool		g k
IsActive		l t
)		t u
;		u v
public

 
record

  
CreateFieldOptionDto

 "
(

" #
int

# &
FieldDefinitionId

' 8
,

8 9
string

: @
Value

A F
,

F G
string

H N
Label

O T
,

T U
int

V Y
	SortOrder

Z c
)

c d
;

d e
public 
record  
UpdateFieldOptionDto "
(" #
string# )
Value* /
,/ 0
string1 7
Label8 =
,= >
int? B
	SortOrderC L
,L M
boolN R
IsActiveS [
)[ \
;\ ]
public 
record !
FormFieldPlacementDto #
(# $
int$ '
Id( *
,* +
int, /
FieldDefinitionId0 A
,A B
intC F
?F G
	ProjectIdH Q
,Q R
intS V
?V W

CategoryIdX b
,b c
intd g
?g h
TicketTypeIdi u
,u v
intw z
	SortOrder	{ Ñ
,
Ñ Ö
bool
Ü ä

IsRequired
ã ï
,
ï ñ
bool
ó õ
IsActive
ú §
)
§ •
;
• ¶
public 
record '
CreateFormFieldPlacementDto )
() *
int* -
FieldDefinitionId. ?
,? @
intA D
?D E
	ProjectIdF O
,O P
intQ T
?T U

CategoryIdV `
,` a
intb e
?e f
TicketTypeIdg s
,s t
intu x
	SortOrder	y Ç
,
Ç É
bool
Ñ à

IsRequired
â ì
)
ì î
;
î ï
public 
record '
UpdateFormFieldPlacementDto )
() *
int* -
?- .
	ProjectId/ 8
,8 9
int: =
?= >

CategoryId? I
,I J
intK N
?N O
TicketTypeIdP \
,\ ]
int^ a
	SortOrderb k
,k l
boolm q

IsRequiredr |
,| }
bool	~ Ç
IsActive
É ã
)
ã å
;
å ç‰
U/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/AuthDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
LoginRequestDto 
( 
string $
Username% -
,- .
string/ 5
Password6 >
)> ?
;? @
public 
record 
AuthResponseDto 
( 
string 

Token 
, 
DateTime 
	ExpiresAt 
, 
string 

Username 
, 
IEnumerable		 
<		 
string		 
>		 
Roles		 
,		 
IEnumerable

 
<

 
string

 
>

 
Permissions

 #
)

# $
;

$ %
public 
record 
MeResponseDto 
( 
int 
Id 

,
 
string 

Username 
, 
string 

Email 
, 
IEnumerable 
< 
string 
> 
Groups 
, 
IEnumerable 
< 
string 
> 
Roles 
, 
IEnumerable 
< 
string 
> 
Permissions #
)# $
;$ %“
e/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Constants/PermissionConstants.cs
	namespace 	
ItsTool
 
. 
Application 
. 
	Constants '
;' (
public 
static 
class 
PermissionConstants '
{ 
public 

const 
string 
TicketCreate $
=% &
$str' 6
;6 7
public 

const 
string 

TicketView "
=# $
$str% 2
;2 3
public 

const 
string 

TicketEdit "
=# $
$str% 2
;2 3
public 

const 
string 
TicketAssign $
=% &
$str' 6
;6 7
public		 

const		 
string		 
TicketTransfer		 &
=		' (
$str		) :
;		: ;
public

 

const

 
string

 
TicketResolve

 %
=

& '
$str

( 8
;

8 9
public 

const 
string 
TicketClose #
=$ %
$str& 4
;4 5
public 

const 
string !
TicketCommentInternal -
=. /
$str0 I
;I J
public 

const 
string 

ReportView "
=# $
$str% 2
;2 3
public 

const 
string 
AdminManage #
=$ %
$str& 4
;4 5
public 

const 
string 
ConfigManage $
=% &
$str' 6
;6 7
public 

static 
IReadOnlyList 
<  
string  &
>& '
AllPermissions( 6
=>7 9
new: =
[= >
]> ?
{ 
TicketCreate 
, 

TicketView  
,  !

TicketEdit" ,
,, -
TicketAssign. :
,: ;
TicketTransfer< J
,J K
TicketResolve 
, 
TicketClose "
," #!
TicketCommentInternal$ 9
,9 :

ReportView; E
,E F
AdminManageG R
,R S
ConfigManageT `
} 
; 
} 