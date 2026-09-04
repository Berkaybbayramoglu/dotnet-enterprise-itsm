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
} ì
e/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IWebhookDispatcher.cs
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
IWebhookDispatcher #
{ 
Task 
DispatchEventAsync	 
( 
string "
eventKey# +
,+ ,
object- 3
payload4 ;
); <
;< =
} ¯4
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
< 	
IEnumerable	 
< 
	StatusDto 
> 
>  &
GetAllowedTransitionsAsync! ;
(; <
int< ?
ticketId@ H
,H I
intJ M
userIdN T
)T U
;U V
Task 
AssignTicketAsync	 
( 
int 
ticketId '
,' (
AssignTicketDto) 8
dto9 <
)< =
;= >
Task 
TransferTicketAsync	 
( 
int  
ticketId! )
,) *
TransferTicketDto+ <
dto= @
)@ A
;A B
Task 
< 	
IEnumerable	 
< 
TicketAssigneeDto &
>& '
>' ("
GetAssignmentTreeAsync) ?
(? @
int@ C
ticketIdD L
)L M
;M N
Task 
< 	
TicketCommentDto	 
> 
AddCommentAsync *
(* +
int+ .
ticketId/ 7
,7 8
CreateCommentDto9 I
dtoJ M
)M N
;N O
Task 
< 	
TicketCommentDto	 
> 
UpdateCommentAsync -
(- .
int. 1
ticketId2 :
,: ;
int< ?
	commentId@ I
,I J
UpdateCommentDtoK [
dto\ _
,_ `
inta d
userIde k
,k l
boolm q
hasEditPermr }
)} ~
;~ 
Task 
DeleteCommentAsync	 
( 
int 
ticketId  (
,( )
int* -
	commentId. 7
,7 8
int9 <
userId= C
,C D
boolE I
hasDeletePermJ W
)W X
;X Y
Task 
RestoreCommentAsync	 
( 
int  
ticketId! )
,) *
int+ .
	commentId/ 8
,8 9
int: =
userId> D
,D E
boolF J
hasDeletePermK X
)X Y
;Y Z
Task 
< 	
IEnumerable	 
< 
TicketCommentDto %
>% &
>& '
GetCommentsAsync( 8
(8 9
int9 <
ticketId= E
,E F
boolG K
includeInternalL [
)[ \
;\ ]
Task 
< 	
TicketAttachmentDto	 
> 
AddAttachmentAsync 0
(0 1
int1 4
ticketId5 =
,= >
	IFormFile? H
fileI M
,M N
intO R
userIdS Y
)Y Z
;Z [
Task 
< 	
IEnumerable	 
< 
TicketAttachmentDto (
>( )
>) *
GetAttachmentsAsync+ >
(> ?
int? B
ticketIdC K
)K L
;L M
Task 
< 	
(	 

string
 
FilePath 
, 
string !
ContentType" -
,- .
string/ 5
FileName6 >
)> ?
>? @&
GetAttachmentFileInfoAsyncA [
([ \
int\ _
ticketId` h
,h i
intj m
attachmentIdn z
)z {
;{ |
Task !
DeleteAttachmentAsync	 
( 
int "
ticketId# +
,+ ,
int- 0
attachmentId1 =
,= >
int? B
userIdC I
,I J
boolK O
hasManagePermP ]
)] ^
;^ _
Task 
AddWatcherAsync	 
( 
int 
ticketId %
,% &
int' *
userId+ 1
)1 2
;2 3
Task 
RemoveWatcherAsync	 
( 
int 
ticketId  (
,( )
int* -
userId. 4
)4 5
;5 6
Task 
< 	
IEnumerable	 
< 
TicketWatcherDto %
>% &
>& '
GetWatchersAsync( 8
(8 9
int9 <
ticketId= E
)E F
;F G
Task   
<   	
IEnumerable  	 
<   
TimelineEventDto   %
>  % &
>  & '
GetTimelineAsync  ( 8
(  8 9
int  9 <
ticketId  = E
,  E F
bool  G K
includeInternal  L [
)  [ \
;  \ ]
Task!! 
<!! 	
PagedResult!!	 
<!! 
	TicketDto!! 
>!! 
>!!  
SearchTicketsAsync!!! 3
(!!3 4!
TicketSearchFilterDto!!4 I
filter!!J P
,!!P Q
int!!R U
userId!!V \
)!!\ ]
;!!] ^
Task"" 
<"" 	
TicketSurveyDto""	 
>"" 
SubmitSurveyAsync"" +
(""+ ,
int"", /
ticketId""0 8
,""8 9!
SubmitTicketSurveyDto"": O
dto""P S
,""S T
int""U X
userId""Y _
)""_ `
;""` a
Task## 
<## 	
IEnumerable##	 
<## 
UserDto## 
>## 
>## *
GetEligibleUsersForTicketAsync## =
(##= >
int##> A
ticketId##B J
)##J K
;##K L
}$$ ä
`/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IEmailService.cs
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
IEmailService 
{ 
Task 
SendEmailAsync	 
( 
string 
to !
,! "
string# )
subject* 1
,1 2
string3 9
body: >
,> ?
bool@ D
isHtmlE K
=L M
trueN R
)R S
;S T
} ‰
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/ISlaService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
ISlaService 
{ 
Task		 
<		 	
IEnumerable			 
<		 
SlaPolicyDto		 !
>		! "
>		" #
GetPoliciesAsync		$ 4
(		4 5
int		5 8
?		8 9
	projectId		: C
=		D E
null		F J
)		J K
;		K L
Task

 
<

 	
SlaPolicyDto

	 
>

 
CreatePolicyAsync

 (
(

( )
CreateSlaPolicyDto

) ;
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
UpdatePolicyAsync	 
( 
int 
id !
,! "
UpdateSlaPolicyDto# 5
dto6 9
)9 :
;: ;
Task 
DeletePolicyAsync	 
( 
int 
id !
)! "
;" #
Task 
< 	
IEnumerable	 
< 
SlaTargetDto !
>! "
>" #
GetTargetsAsync$ 3
(3 4
int4 7
policyId8 @
)@ A
;A B
Task 
< 	
SlaTargetDto	 
> 
CreateTargetAsync (
(( )
CreateSlaTargetDto) ;
dto< ?
)? @
;@ A
Task 
UpdateTargetAsync	 
( 
int 
id !
,! "
UpdateSlaTargetDto# 5
dto6 9
)9 :
;: ;
Task 
DeleteTargetAsync	 
( 
int 
id !
)! "
;" #
} ü
]/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/ISlaEngine.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 

ISlaEngine 
{ 
Task "
AttachSlaToTicketAsync	 
(  
int  #
ticketId$ ,
), -
;- .
Task		 *
ProcessTicketStatusChangeAsync			 '
(		' (
int		( +
ticketId		, 4
,		4 5
int		6 9
oldStatusId		: E
,		E F
int		G J
newStatusId		K V
)		V W
;		W X
Task

 %
ProcessTicketCommentAsync

	 "
(

" #
int

# &
ticketId

' /
,

/ 0
bool

1 5

isInternal

6 @
)

@ A
;

A B
Task 
CheckBreachesAsync	 
( 
DateTime $
nowUtc% +
)+ ,
;, -
} â
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/ISignalRPusher.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
ISignalRPusher 
{ 
Task !
PushNotificationAsync	 
( 
int "
userId# )
,) *
object+ 1
payload2 9
)9 :
;: ;
} ¢
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
} À
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IReportService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
IReportService 
{ 
Task		 
<		 	
Stream			 
>		 #
ExportTicketsToCsvAsync		 (
(		( )!
TicketSearchFilterDto		) >
filter		? E
,		E F
int		G J
userId		K Q
)		Q R
;		R S
}

 —
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
}99 Ê	
g/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/INotificationService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface  
INotificationService %
{ 
Task		 
<		 	
IEnumerable			 
<		 
NotificationDto		 $
>		$ %
>		% &%
GetUserNotificationsAsync		' @
(		@ A
int		A D
userId		E K
)		K L
;		L M
Task

 
MarkAsReadAsync

	 
(

 
int

 
notificationId

 +
,

+ ,
int

- 0
userId

1 7
)

7 8
;

8 9
Task 
MarkAllAsReadAsync	 
( 
int 
userId  &
)& '
;' (
Task #
DeleteNotificationAsync	  
(  !
int! $
notificationId% 3
,3 4
int5 8
userId9 ?
)? @
;@ A
Task '
DeleteAllNotificationsAsync	 $
($ %
int% (
userId) /
)/ 0
;0 1
} ¯
j/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/INotificationDispatcher.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface #
INotificationDispatcher (
{ 
Task 
DispatchEventAsync	 
( 
string "
eventKey# +
,+ ,
int- 0
ticketId1 9
,9 :
int; >
?> ?
triggerUserId@ M
=N O
nullP T
,T U
stringV \
?\ ]
additionalContext^ o
=p q
nullr v
)v w
;w x
} ‚
h/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IKnowledgeBaseService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface !
IKnowledgeBaseService &
{ 
Task		 
<		 	
IEnumerable			 
<		 
KbCategoryDto		 "
>		" #
>		# $
GetCategoriesAsync		% 7
(		7 8
)		8 9
;		9 :
Task

 
<

 	
KbCategoryDto

	 
>

 
CreateCategoryAsync

 +
(

+ ,
CreateKbCategoryDto

, ?
dto

@ C
)

C D
;

D E
Task 
UpdateCategoryAsync	 
( 
int  
id! #
,# $
CreateKbCategoryDto% 8
dto9 <
)< =
;= >
Task 
DeleteCategoryAsync	 
( 
int  
id! #
)# $
;$ %
Task 
< 	
IEnumerable	 
< 
KbArticleSummaryDto (
>( )
>) *
SearchArticlesAsync+ >
(> ?
int? B
userIdC I
,I J
stringK Q
?Q R
keywordS Z
,Z [
int\ _
?_ `

categoryIda k
)k l
;l m
Task 
< 	
KbArticleDto	 
? 
> 
GetArticleAsync '
(' (
int( +
id, .
,. /
int0 3
userId4 :
): ;
;; <
Task 
< 	
KbArticleDto	 
> 
CreateArticleAsync )
() *
CreateKbArticleDto* <
dto= @
,@ A
intB E
authorIdF N
)N O
;O P
Task 
UpdateArticleAsync	 
( 
int 
id  "
," #
UpdateKbArticleDto$ 6
dto7 :
,: ;
int< ?
currentUserId@ M
)M N
;N O
Task 
ReviewArticleAsync	 
( 
int 
id  "
," #
ReviewKbArticleDto$ 6
dto7 :
,: ;
int< ?

reviewerId@ J
)J K
;K L
Task 
DeleteArticleAsync	 
( 
int 
id  "
," #
int$ '
currentUserId( 5
)5 6
;6 7
} ≈
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
 ¯
h/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IEmailTemplateService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface !
IEmailTemplateService &
{ 
string 

GenerateEmailBody 
( 
string #
eventKey$ ,
,, -

Dictionary. 8
<8 9
string9 ?
,? @
stringA G
>G H
templateDataI U
)U V
;V W
} ÷
f/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/ISystemAuditService.cs
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
ISystemAuditService $
{ 
Task 
LogAuditAsync	 
( 
string 

entityType (
,( )
string* 0

entityName1 ;
,; <
string= C
entityIdD L
,L M
stringN T
actionU [
,[ \
string] c
?c d
	fieldNamee n
=o p
nullq u
,u v
stringw }
?} ~
oldValue	 á
=
à â
null
ä é
,
é è
string
ê ñ
?
ñ ó
newValue
ò †
=
° ¢
null
£ ß
)
ß ®
;
® ©
} ì
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IEmailQueue.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
class 
EmailMessage 
{ 
public 

string 
To 
{ 
get 
; 
set 
;  
}! "
=# $
string% +
.+ ,
Empty, 1
;1 2
public		 

string		 
Subject		 
{		 
get		 
;		  
set		! $
;		$ %
}		& '
=		( )
string		* 0
.		0 1
Empty		1 6
;		6 7
public

 

string

 
Body

 
{

 
get

 
;

 
set

 !
;

! "
}

# $
=

% &
string

' -
.

- .
Empty

. 3
;

3 4
public 

bool 
IsHtml 
{ 
get 
; 
set !
;! "
}# $
=% &
true' +
;+ ,
} 
public 
	interface 
IEmailQueue 
{ 
	ValueTask 
QueueEmailAsync 
( 
EmailMessage *
message+ 2
)2 3
;3 4
	ValueTask 
< 
EmailMessage 
> 
DequeueEmailAsync -
(- .
CancellationToken. ?
cancellationToken@ Q
)Q R
;R S
} 
i/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IEmailIngestionService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface "
IEmailIngestionService '
{ 
Task %
ProcessIncomingEmailAsync	 "
(" #
EmailIngestionDto# 4
dto5 8
)8 9
;9 :
}		 ∫
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
} û
d/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IDashboardService.cs
	namespace 	
ItsTool
 
. 
Application 
. 

Interfaces (
;( )
public 
	interface 
IDashboardService "
{ 
Task		 
<		 	 
DashboardOverviewDto			 
>		 
GetOverviewAsync		 /
(		/ 0
int		0 3
userId		4 :
)		: ;
;		; <
Task

 
<

 	%
DashboardDistributionsDto

	 "
>

" #!
GetDistributionsAsync

$ 9
(

9 :
int

: =
userId

> D
)

D E
;

E F
Task 
< 	
IEnumerable	 
< !
DepartmentWorkloadDto *
>* +
>+ ,&
GetDepartmentWorkloadAsync- G
(G H
intH K
userIdL R
)R S
;S T
Task 
< 	
SlaComplianceDto	 
> !
GetSlaComplianceAsync 0
(0 1
int1 4
userId5 ;
); <
;< =
Task 
< 	
IEnumerable	 
< 
TicketSurveyDto $
>$ %
>% &!
GetRecentSurveysAsync' <
(< =
int= @
userIdA G
)G H
;H I
} ó 
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
} ÷
d/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/Interfaces/IAssignmentEngine.cs
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
IAssignmentEngine "
{ 
Task 
AssignTicketAsync	 
( 
Ticket !
ticket" (
)( )
;) *
}		 £
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
ü †˙%
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
;l mÏ#
\/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/TicketSearchDto.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
class !
TicketSearchFilterDto "
{ 
public 

int 
? 
	ProjectId 
{ 
get 
;  
set! $
;$ %
}& '
public		 

int		 
?		 

CategoryId		 
{		 
get		  
;		  !
set		" %
;		% &
}		' (
public

 

int

 
?

 
TypeId

 
{

 
get

 
;

 
set

 !
;

! "
}

# $
public 

int 
? 
StatusId 
{ 
get 
; 
set  #
;# $
}% &
public 

int 
? 

PriorityId 
{ 
get  
;  !
set" %
;% &
}' (
public 

int 
? 
AssigneeUserId 
{  
get! $
;$ %
set& )
;) *
}+ ,
public 

bool 
? 

Unassigned 
{ 
get !
;! "
set# &
;& '
}( )
public 

int 
? 
RequesterUserId 
{  !
get" %
;% &
set' *
;* +
}, -
public 

int 
? 
ExcludeStatusId 
{  !
get" %
;% &
set' *
;* +
}, -
public 

DateTime 
? 
FromDate 
{ 
get  #
;# $
set% (
;( )
}* +
public 

DateTime 
? 
ToDate 
{ 
get !
;! "
set# &
;& '
}( )
public 

string 
? 
Keyword 
{ 
get  
;  !
set" %
;% &
}' (
public 

string 
? 
	SlaStatus 
{ 
get "
;" #
set$ '
;' (
}) *
public 

int 
Page 
{ 
get 
; 
set 
; 
}  !
=" #
$num$ %
;% &
public 

int 
PageSize 
{ 
get 
; 
set "
;" #
}$ %
=& '
$num( *
;* +
public 

string 
? 
SortBy 
{ 
get 
;  
set! $
;$ %
}& '
public 

bool 
SortDescending 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
true/ 3
;3 4
} 
public 
class 
PagedResult 
< 
T 
> 
{ 
public 

IEnumerable 
< 
T 
> 
Items 
{  !
get" %
;% &
set' *
;* +
}, -
=. /
new0 3
List4 8
<8 9
T9 :
>: ;
(; <
)< =
;= >
public 

int 

TotalCount 
{ 
get 
;  
set! $
;$ %
}& '
public   

int   
Page   
{   
get   
;   
set   
;   
}    !
public!! 

int!! 
PageSize!! 
{!! 
get!! 
;!! 
set!! "
;!!" #
}!!$ %
public"" 

int"" 

TotalPages"" 
=>"" 
("" 
int"" !
)""! "
Math""" &
.""& '
Ceiling""' .
("". /

TotalCount""/ 9
/"": ;
(""< =
double""= C
)""C D
PageSize""D L
)""L M
;""M N
}## ´?
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
record 
TicketAssigneeDto 
(  
int  #
Id$ &
,& '
int( +
?+ ,
UserId- 3
,3 4
int5 8
?8 9
GroupId: A
,A B
intC F
?F G
ParentAssignmentIdH Z
,Z [
int\ _
AssignedByUserId` p
,p q
boolr v
IsActivew 
,	 Ä
DateTime
Å â
	CreatedAt
ä ì
,
ì î
string
ï õ
?
õ ú
AssigneeName
ù ©
=
™ ´
null
¨ ∞
,
∞ ±
bool
≤ ∂
IsAssigneeDeleted
∑ »
=
…  
false
À –
)
– —
;
— “
public 
record 
	TicketDto 
( 
int 
Id 
, 
string  &
TicketNumber' 3
,3 4
string5 ;
Title< A
,A B
stringC I
DescriptionJ U
,U V
intW Z
?Z [
	ProjectId\ e
,e f
intg j

CategoryIdk u
,u v
intw z
TypeId	{ Å
,
Å Ç
int
É Ü
StatusId
á è
,
è ê
int
ë î

PriorityId
ï ü
,
ü †
int
° §
RequesterUserId
• ¥
,
¥ µ
List
∂ ∫
<
∫ ª
TicketAssigneeDto
ª Ã
>
Ã Õ
Assignments
Œ Ÿ
,
Ÿ ⁄

Dictionary
€ Â
<
Â Ê
string
Ê Ï
,
Ï Ì
string
Ó Ù
>
Ù ı
?
ı ˆ
CustomFields
˜ É
=
Ñ Ö
null
Ü ä
,
ä ã
DateTime
å î
?
î ï 
EstimatedStartDate
ñ ®
=
© ™
null
´ Ø
,
Ø ∞
DateTime
± π
?
π ∫
EstimatedEndDate
ª À
=
Ã Õ
null
Œ “
)
“ ”
;
” ‘
public 
record 
CreateTicketDto 
( 
string $
Title% *
,* +
string, 2
Description3 >
,> ?
int@ C
?C D
	ProjectIdE N
,N O
intP S

CategoryIdT ^
,^ _
int` c
TypeIdd j
,j k
intl o

PriorityIdp z
,z {
int| 
RequesterUserId
Ä è
,
è ê

Dictionary
ë õ
<
õ ú
string
ú ¢
,
¢ £
string
§ ™
>
™ ´
CustomFields
¨ ∏
,
∏ π
DateTime
∫ ¬
?
¬ √ 
EstimatedStartDate
ƒ ÷
=
◊ ÿ
null
Ÿ ›
,
› ﬁ
DateTime
ﬂ Á
?
Á Ë
EstimatedEndDate
È ˘
=
˙ ˚
null
¸ Ä
)
Ä Å
;
Å Ç
public 
record 
UpdateTicketDto 
( 
string $
Title% *
,* +
string, 2
Description3 >
,> ?
int@ C

CategoryIdD N
,N O
intP S

PriorityIdT ^
,^ _

Dictionary` j
<j k
stringk q
,q r
strings y
>y z
CustomFields	{ á
,
á à
DateTime
â ë
?
ë í 
EstimatedStartDate
ì •
=
¶ ß
null
® ¨
,
¨ ≠
DateTime
Æ ∂
?
∂ ∑
EstimatedEndDate
∏ »
=
…  
null
À œ
)
œ –
;
– —
public		 
record		 
TicketHistoryDto		 
(		 
int		 "
Id		# %
,		% &
int		' *
TicketId		+ 3
,		3 4
string		5 ;
	FieldName		< E
,		E F
string		G M
?		M N
OldValue		O W
,		W X
string		Y _
?		_ `
NewValue		a i
,		i j
string		k q
Action		r x
,		x y
DateTime			z Ç
	CreatedAt
		É å
)
		å ç
;
		ç é
public

 
record

 
TicketCommentDto

 
(

 
int

 "
Id

# %
,

% &
int

' *
TicketId

+ 3
,

3 4
int

5 8
AuthorUserId

9 E
,

E F
string

G M
Content

N U
,

U V
bool

W [

IsInternal

\ f
,

f g
DateTime

h p
	CreatedAt

q z
,

z {
int

| 
?	

 Ä
ParentCommentId


Å ê
=


ë í
null


ì ó
,


ó ò
bool


ô ù
IsEdited


û ¶
=


ß ®
false


© Æ
,


Æ Ø
DateTime


∞ ∏
?


∏ π
	UpdatedAt


∫ √
=


ƒ ≈
null


∆  
)


  À
;


À Ã
public 
record 
CreateCommentDto 
( 
string %
Content& -
,- .
bool/ 3

IsInternal4 >
,> ?
int@ C
AuthorUserIdD P
,P Q
intR U
?U V
ParentCommentIdW f
=g h
nulli m
,m n
into r
[r s
]s t
?t u
MentionedUserIds	v Ü
=
á à
null
â ç
)
ç é
;
é è
public 
record 
UpdateCommentDto 
( 
string %
Content& -
,- .
List/ 3
<3 4
int4 7
>7 8
?8 9
MentionedUserIds: J
=K L
nullM Q
)Q R
;R S
public 
record 
TicketAttachmentDto !
(! "
int" %
Id& (
,( )
int* -
TicketId. 6
,6 7
string8 >
FileName? G
,G H
stringI O
FilePathP X
,X Y
longZ ^
FileSize_ g
,g h
stringi o
ContentTypep {
,{ |
int	} Ä
UploadedByUserId
Å ë
,
ë í
DateTime
ì õ
	CreatedAt
ú •
)
• ¶
;
¶ ß
public 
record 
TicketWatcherDto 
( 
int "
TicketId# +
,+ ,
int- 0
UserId1 7
)7 8
;8 9
public 
record 
TimelineEventDto 
( 
string %
	EventType& /
,/ 0
DateTime1 9
	Timestamp: C
,C D
objectE K
DataL P
)P Q
;Q R
public 
record 
AssignTicketDto 
( 
List "
<" #
int# &
>& '
UserIds( /
,/ 0
List1 5
<5 6
int6 9
>9 :
GroupIds; C
,C D
intE H
AssignerUserIdI W
,W X
intY \
?\ ]
ParentAssignmentId^ p
=q r
nulls w
)w x
;x y
public 
record 
TransferTicketDto 
(  
int  #
?# $
	ProjectId% .
,. /
int0 3
?3 4
GroupId5 <
,< =
int> A
TransferrerUserIdB S
)S T
;T U
public 
record 
ChangeStatusDto 
( 
int !
NewStatusId" -
,- .
int/ 2
UserId3 9
)9 :
;: ;ø
T/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/SlaDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
SlaPolicyDto 
( 
int 
Id !
,! "
string# )
Name* .
,. /
string0 6
?6 7
Description8 C
,C D
intE H
?H I
	ProjectIdJ S
,S T
boolU Y
IsActiveZ b
)b c
;c d
public 
record 
CreateSlaPolicyDto  
(  !
string! '
Name( ,
,, -
string. 4
?4 5
Description6 A
,A B
intC F
?F G
	ProjectIdH Q
)Q R
;R S
public 
record 
UpdateSlaPolicyDto  
(  !
string! '
Name( ,
,, -
string. 4
?4 5
Description6 A
,A B
intC F
?F G
	ProjectIdH Q
,Q R
boolS W
IsActiveX `
)` a
;a b
public

 
record

 
SlaTargetDto

 
(

 
int

 
Id

 !
,

! "
int

# &
SlaPolicyId

' 2
,

2 3
int

4 7

PriorityId

8 B
,

B C
int

D G
?

G H
TicketTypeId

I U
,

U V
int

W Z 
FirstResponseMinutes

[ o
,

o p
int

q t
ResolutionMinutes	

u Ü
,


Ü á
bool


à å
IsActive


ç ï
)


ï ñ
;


ñ ó
public 
record 
CreateSlaTargetDto  
(  !
int! $
SlaPolicyId% 0
,0 1
int2 5

PriorityId6 @
,@ A
intB E
?E F
TicketTypeIdG S
,S T
intU X 
FirstResponseMinutesY m
,m n
into r
ResolutionMinutes	s Ñ
)
Ñ Ö
;
Ö Ü
public 
record 
UpdateSlaTargetDto  
(  !
int! $

PriorityId% /
,/ 0
int1 4
?4 5
TicketTypeId6 B
,B C
intD G 
FirstResponseMinutesH \
,\ ]
int^ a
ResolutionMinutesb s
,s t
boolu y
IsActive	z Ç
)
Ç É
;
É ÑË
\/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/SavedFilterDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
SavedFilterDto 
( 
int  
Id! #
,# $
int% (
UserId) /
,/ 0
string1 7
Name8 <
,< =
string> D
	QueryJsonE N
)N O
;O P
public 
record  
CreateSavedFilterDto "
(" #
string# )
Name* .
,. /
string0 6
	QueryJson7 @
)@ A
;A Bå9
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
,S T
stringU [
?[ \
Color] b
)b c
;c d
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
,B C
stringD J
?J K
ColorL Q
)Q R
;R S
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
,Q R
stringS Y
?Y Z
Color[ `
)` a
;a b
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
,
Ä Å
int
Ç Ö
[
Ö Ü
]
Ü á
RoleIds
à è
,
è ê

Dictionary
ë õ
<
õ ú
int
ú ü
,
ü †
bool
° •
>
• ¶!
PermissionOverrides
ß ∫
,
∫ ª
string
º ¬
?
¬ √
ProfilePhoto
ƒ –
,
– —
int
“ ’
[
’ ÷
]
÷ ◊
GroupIds
ÿ ‡
,
‡ ·
DateTime
‚ Í
	CreatedAt
Î Ù
)
Ù ı
;
ı ˆ
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
,
Ä Å
string
Ç à
?
à â
ProfilePhoto
ä ñ
,
ñ ó
int
ò õ
[
õ ú
]
ú ù
?
ù û
GroupIds
ü ß
)
ß ®
;
® ©
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
,m n
stringo u
?u v
ProfilePhoto	w É
,
É Ñ
int
Ö à
[
à â
]
â ä
?
ä ã
GroupIds
å î
)
î ï
;
ï ñ
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
,T U
stringV \
Status] c
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
,R S
stringT Z
Status[ a
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
,) *
string+ 1
?1 2
Description3 >
,> ?
bool@ D
IsActiveE M
,M N
stringO U
[U V
]V W
?W X
PermissionsY d
)d e
;e f
public 
record 
CreateRoleDto 
( 
string "
Name# '
,' (
string) /
?/ 0
Description1 <
,< =
string> D
[D E
]E F
?F G
PermissionsH S
)S T
;T U
public 
record 
UpdateRoleDto 
( 
string "
Name# '
,' (
string) /
?/ 0
Description1 <
,< =
bool> B
IsActiveC K
,K L
stringM S
[S T
]T U
?U V
PermissionsW b
)b c
;c d
public 
record 
PermissionDto 
( 
int 
Id  "
," #
string$ *
Name+ /
,/ 0
string1 7
Key8 ;
,; <
string= C
?C D
DescriptionE P
)P Q
;Q R
public 
record 
CreatePermissionDto !
(! "
string" (
Name) -
,- .
string/ 5
Key6 9
,9 :
string; A
?A B
DescriptionC N
)N O
;O P
public 
record 
UpdatePermissionDto !
(! "
string" (
Name) -
,- .
string/ 5
Key6 9
,9 :
string; A
?A B
DescriptionC N
)N O
;O PÚ
]/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/NotificationDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
NotificationDto 
( 
int !
Id" $
,$ %
int& )
UserId* 0
,0 1
string2 8
Type9 =
,= >
string? E
TitleF K
,K L
stringM S
BodyT X
,X Y
boolZ ^
IsRead_ e
,e f
intg j
EntityIdk s
,s t
stringu {

EntityType	| Ü
,
Ü á
string
à é
Priority
è ó
,
ó ò
DateTime
ô °
	CreatedAt
¢ ´
)
´ ¨
;
¨ ≠è
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/KnowledgeBaseDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
KbCategoryDto 
( 
int 
Id  "
," #
string$ *
Name+ /
,/ 0
int1 4
?4 5
ParentId6 >
)> ?
;? @
public 
record 
CreateKbCategoryDto !
(! "
string" (
Name) -
,- .
int/ 2
?2 3
ParentId4 <
)< =
;= >
public		 
record		 
KbArticleDto		 
(		 
int		 
Id		 !
,		! "
int		# &

CategoryId		' 1
,		1 2
string		3 9
Title		: ?
,		? @
string		A G
Content		H O
,		O P
int		Q T
AuthorUserId		U a
,		a b
string		c i
?		i j

AuthorName		k u
,		u v
string		w }
?		} ~
AuthorDepartment			 è
,
		è ê
ArticleStatus
		ë û
Status
		ü •
,
		• ¶
ArticleVisibility
		ß ∏

Visibility
		π √
,
		√ ƒ
int
		≈ »
	ViewCount
		… “
,
		“ ”
DateTime
		‘ ‹
	CreatedAt
		› Ê
,
		Ê Á
string
		Ë Ó
?
		Ó Ô
ManagerFeedback
		 ˇ
)
		ˇ Ä
;
		Ä Å
public

 
record

 
KbArticleSummaryDto

 !
(

! "
int

" %
Id

& (
,

( )
int

* -

CategoryId

. 8
,

8 9
string

: @
Title

A F
,

F G
int

H K
AuthorUserId

L X
,

X Y
string

Z `
?

` a

AuthorName

b l
,

l m
string

n t
?

t u
AuthorDepartment	

v Ü
,


Ü á
ArticleStatus


à ï
Status


ñ ú
,


ú ù
ArticleVisibility


û Ø

Visibility


∞ ∫
,


∫ ª
int


º ø
	ViewCount


¿ …
,


…  
DateTime


À ”
	CreatedAt


‘ ›
,


› ﬁ
string


ﬂ Â
?


Â Ê
ManagerFeedback


Á ˆ
)


ˆ ˜
;


˜ ¯
public 
record 
CreateKbArticleDto  
(  !
int! $

CategoryId% /
,/ 0
string1 7
Title8 =
,= >
string? E
ContentF M
,M N
ArticleStatusO \
Status] c
,c d
ArticleVisibilitye v

Visibility	w Å
)
Å Ç
;
Ç É
public 
record 
UpdateKbArticleDto  
(  !
int! $

CategoryId% /
,/ 0
string1 7
Title8 =
,= >
string? E
ContentF M
,M N
ArticleStatusO \
Status] c
,c d
ArticleVisibilitye v

Visibility	w Å
)
Å Ç
;
Ç É
public 
record 
ReviewKbArticleDto  
(  !
ArticleStatus! .
Status/ 5
,5 6
string7 =
?= >
Feedback? G
)G H
;H I†
_/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/EmailIngestionDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
EmailIngestionDto 
(  
string 

	MessageId 
, 
string 

From 
, 
string 

Subject 
, 
string 

Body 
) 
; í 
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
å çﬁ
Z/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/DashboardDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record  
DashboardOverviewDto "
(" #
int# &
OpenTickets' 2
,2 3
int4 7
CriticalTickets8 G
,G H
intI L
SlaBreachedTicketsM _
,_ `
inta d
SlaRiskTicketse s
,s t
intu x
UnassignedTickets	y ä
,
ä ã
double
å í
CsatAverage
ì û
)
û ü
;
ü †
public 
record !
TicketDistributionDto #
(# $
string$ *
Key+ .
,. /
int0 3
Count4 9
)9 :
;: ;
public

 
record

 %
DashboardDistributionsDto

 '
(

' (
IEnumerable 
< !
TicketDistributionDto %
>% &
ByStatus' /
,/ 0
IEnumerable 
< !
TicketDistributionDto %
>% &

ByPriority' 1
,1 2
IEnumerable 
< !
TicketDistributionDto %
>% &
	ByProject' 0
,0 1
IEnumerable 
< !
TicketDistributionDto %
>% &

ByCategory' 1
) 
; 
public 
record 
AgentWorkloadDto 
( 
int "
UserId# )
,) *
string+ 1
UserName2 :
,: ;
int< ?
OpenTicketCount@ O
)O P
;P Q
public 
record !
DepartmentWorkloadDto #
(# $
int$ '
DepartmentId( 4
,4 5
string6 <
DepartmentName= K
,K L
intM P
OpenTicketCountQ `
,` a
IEnumerableb m
<m n
AgentWorkloadDton ~
>~ 
Members
Ä á
)
á à
;
à â
public 
record 
SlaComplianceDto 
( 
double 
'
FirstResponseComplianceRate &
,& '
double 
$
ResolutionComplianceRate #
,# $
double 
(
AverageResolutionTimeMinutes '
) 
; ø
]/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/TicketSurveyDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
TicketSurveyDto 
( 
int 
Id 

,
 
int 
TicketId 
, 
int 
Rating 
, 
string		 

?		
 
Comment		 
,		 
DateTime

 
SubmittedAt

 
) 
; 
public 
record !
SubmitTicketSurveyDto #
(# $
int 
Rating 
, 
string 

?
 
Comment 
) 
; ›
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
,# $
IEnumerable 
< 
string 
> 
	Overrides !
,! "
int 
KbArticleCount 
, 
string 

?
 
ProfilePhoto 
) 
; º
Y/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/AuditLogDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
AuditLogFilterDto 
(  
int 
? 
UserId	 
, 
string 

?
 
Action 
, 
string 

?
 
Ticket 
, 
DateTime		 
?		 
FromDate		 
,		 
DateTime

 
?

 
ToDate

 
,

 
int 
Page 
= 
$num 
, 
int 
PageSize 
= 
$num 
) 
; 
public 
record 
AuditLogItemDto 
( 
int 
Id 

,
 
int 
? 
TicketId	 
, 
string 

Action 
, 
string 

	FieldName 
, 
string 

?
 
OldValue 
, 
string 

?
 
NewValue 
, 
string 

	CreatedBy 
, 
DateTime 
	CreatedAt 
, 
string 

?
 

EntityType 
= 
null 
, 
string 

?
 

EntityName 
= 
null 
, 
string 

?
 
EntityId 
= 
null 
) 
; 
public 
record  
PaginatedAuditLogDto "
(" #
System 

.
 
Collections 
. 
Generic 
. 
IEnumerable *
<* +
AuditLogItemDto+ :
>: ;
Items< A
,A B
int 

TotalCount 
, 
int   
Page   
,   
int!! 
PageSize!! 
)"" 
;"" å
_/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Application/DTOs/AssignmentRuleDtos.cs
	namespace 	
ItsTool
 
. 
Application 
. 
DTOs "
;" #
public 
record 
AssignmentRuleDto 
(  
int  #
Id$ &
,& '
string( .
Name/ 3
,3 4
int5 8
?8 9
	ProjectId: C
,C D
intE H
?H I

CategoryIdJ T
,T U
intV Y
?Y Z
TicketTypeId[ g
,g h
inti l
?l m

PriorityIdn x
,x y
intz }
?} ~
TargetGroupId	 å
,
å ç
int
é ë
?
ë í
TargetUserId
ì ü
,
ü †
int
° §
	SortOrder
• Æ
,
Æ Ø
bool
∞ ¥
IsActive
µ Ω
)
Ω æ
;
æ ø
public 
record #
CreateAssignmentRuleDto %
(% &
string& ,
Name- 1
,1 2
int3 6
?6 7
	ProjectId8 A
,A B
intC F
?F G

CategoryIdH R
,R S
intT W
?W X
TicketTypeIdY e
,e f
intg j
?j k

PriorityIdl v
,v w
intx {
?{ |
TargetGroupId	} ä
,
ä ã
int
å è
?
è ê
TargetUserId
ë ù
,
ù û
int
ü ¢
	SortOrder
£ ¨
,
¨ ≠
bool
Æ ≤
IsActive
≥ ª
)
ª º
;
º Ω
public 
record #
UpdateAssignmentRuleDto %
(% &
string& ,
Name- 1
,1 2
int3 6
?6 7
	ProjectId8 A
,A B
intC F
?F G

CategoryIdH R
,R S
intT W
?W X
TicketTypeIdY e
,e f
intg j
?j k

PriorityIdl v
,v w
intx {
?{ |
TargetGroupId	} ä
,
ä ã
int
å è
?
è ê
TargetUserId
ë ù
,
ù û
int
ü ¢
	SortOrder
£ ¨
,
¨ ≠
bool
Æ ≤
IsActive
≥ ª
)
ª º
;
º Ωª!
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
string 
TicketReopen $
=% &
$str' 6
;6 7
public 

const 
string !
TicketCommentInternal -
=. /
$str0 I
;I J
public 

const 
string 
TicketCommentEdit )
=* +
$str, A
;A B
public 

const 
string 
TicketCommentReply *
=+ ,
$str- C
;C D
public 

const 
string 
TicketCommentDelete +
=, -
$str. E
;E F
public 

const 
string 

ReportView "
=# $
$str% 2
;2 3
public 

const 
string 
AdminManage #
=$ %
$str& 4
;4 5
public 

const 
string 
ConfigManage $
=% &
$str' 6
;6 7
public 

const 
string 
	SlaManage !
=" #
$str$ 0
;0 1
public 

const 
string 
	AuditView !
=" #
$str$ 0
;0 1
public 

const 
string 
KbManage  
=! "
$str# .
;. /
public 

const 
string 
KbView 
=  
$str! *
;* +
public 

const 
string 
SurveySubmit $
=% &
$str' 6
;6 7
public 

const 
string 
TicketComment %
=& '
$str( 8
;8 9
public 

static 
IReadOnlyList 
<  
string  &
>& '
AllPermissions( 6
=>7 9
new: =
[= >
]> ?
{ 
TicketCreate 
, 

TicketView  
,  !

TicketEdit" ,
,, -
TicketAssign. :
,: ;
TicketTransfer< J
,J K
TicketResolve 
, 
TicketClose "
," #
TicketReopen$ 0
,0 1!
TicketCommentInternal2 G
,G H
TicketCommentEditI Z
,Z [
TicketCommentReply\ n
,n o 
TicketCommentDelete	p É
,
É Ñ

ReportView
Ö è
,
è ê
AdminManage
ë ú
,
ú ù
ConfigManage
û ™
,
™ ´
	SlaManage
¨ µ
,
µ ∂
	AuditView
∑ ¿
,
¿ ¡
KbManage   
,   
KbView   
,   
SurveySubmit   &
,  & '
TicketComment  ( 5
}!! 
;!! 
}"" 