õk
c/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/WorkflowService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 
WorkflowService 
: 
IWorkflowService /
{		 
private

 
readonly

 
IRepository

  
<

  !
Workflow

! )
>

) *
_workflowRepo

+ 8
;

8 9
private 
readonly 
IRepository  
<  !
WorkflowTransition! 3
>3 4
_transitionRepo5 D
;D E
public 

WorkflowService 
( 
IRepository &
<& '
Workflow' /
>/ 0
workflowRepo1 =
,= >
IRepository? J
<J K
WorkflowTransitionK ]
>] ^
transitionRepo_ m
)m n
{ 
_workflowRepo 
= 
workflowRepo $
;$ %
_transitionRepo 
= 
transitionRepo (
;( )
} 
public 

async 
Task 
< 
IEnumerable !
<! "
WorkflowDto" -
>- .
>. /
GetWorkflowsAsync0 A
(A B
intB E
?E F
	projectIdG P
=Q R
nullS W
)W X
{ 
var 
list 
= 
await 
_workflowRepo &
.& '
GetAllAsync' 2
(2 3
w3 4
=>5 7
	projectId8 A
==B D
nullE I
||J L
wM N
.N O
	ProjectIdO X
==Y [
	projectId\ e
)e f
;f g
return 
list 
. 
Select 
( 
w 
=> 
new  #
WorkflowDto$ /
(/ 0
w0 1
.1 2
Id2 4
,4 5
w6 7
.7 8
Name8 <
,< =
w> ?
.? @
Description@ K
,K L
wM N
.N O
	ProjectIdO X
,X Y
wZ [
.[ \
IsActive\ d
)d e
)e f
;f g
} 
public 

async 
Task 
< 
WorkflowDto !
?! "
>" # 
GetWorkflowByIdAsync$ 8
(8 9
int9 <
id= ?
)? @
{ 
var 
w 
= 
await 
_workflowRepo #
.# $
GetByIdAsync$ 0
(0 1
id1 3
)3 4
;4 5
if 

( 
w 
== 
null 
) 
return 
null "
;" #
return 
new 
WorkflowDto 
( 
w  
.  !
Id! #
,# $
w% &
.& '
Name' +
,+ ,
w- .
.. /
Description/ :
,: ;
w< =
.= >
	ProjectId> G
,G H
wI J
.J K
IsActiveK S
)S T
;T U
} 
public   

async   
Task   
<   
WorkflowDto   !
>  ! "
CreateWorkflowAsync  # 6
(  6 7
CreateWorkflowDto  7 H
dto  I L
)  L M
{!! 
var"" 
w"" 
="" 
new"" 
Workflow"" 
{"" 
Name"" #
=""$ %
dto""& )
."") *
Name""* .
,"". /
Description""0 ;
=""< =
dto""> A
.""A B
Description""B M
,""M N
	ProjectId""O X
=""Y Z
dto""[ ^
.""^ _
	ProjectId""_ h
}""i j
;""j k
await## 
_workflowRepo## 
.## 
AddAsync## $
(##$ %
w##% &
)##& '
;##' (
return$$ 
new$$ 
WorkflowDto$$ 
($$ 
w$$  
.$$  !
Id$$! #
,$$# $
w$$% &
.$$& '
Name$$' +
,$$+ ,
w$$- .
.$$. /
Description$$/ :
,$$: ;
w$$< =
.$$= >
	ProjectId$$> G
,$$G H
w$$I J
.$$J K
IsActive$$K S
)$$S T
;$$T U
}%% 
public'' 

async'' 
Task'' 
UpdateWorkflowAsync'' )
('') *
int''* -
id''. 0
,''0 1
UpdateWorkflowDto''2 C
dto''D G
)''G H
{(( 
var)) 
w)) 
=)) 
await)) 
_workflowRepo)) #
.))# $
GetByIdAsync))$ 0
())0 1
id))1 3
)))3 4
;))4 5
if** 

(** 
w** 
==** 
null** 
)** 
throw** 
new**   
KeyNotFoundException**! 5
(**5 6
$str**6 J
)**J K
;**K L
w++ 	
.++	 

Name++
 
=++ 
dto++ 
.++ 
Name++ 
;++ 
w++ 
.++ 
Description++ (
=++) *
dto+++ .
.++. /
Description++/ :
;++: ;
w++< =
.++= >
	ProjectId++> G
=++H I
dto++J M
.++M N
	ProjectId++N W
;++W X
w++Y Z
.++Z [
IsActive++[ c
=++d e
dto++f i
.++i j
IsActive++j r
;++r s
await,, 
_workflowRepo,, 
.,, 
UpdateAsync,, '
(,,' (
w,,( )
),,) *
;,,* +
}-- 
public// 

async// 
Task// 
DeleteWorkflowAsync// )
(//) *
int//* -
id//. 0
)//0 1
=>//2 4
await//5 :
_workflowRepo//; H
.//H I
DeleteAsync//I T
(//T U
id//U W
)//W X
;//X Y
public11 

async11 
Task11 
<11 
IEnumerable11 !
<11! "!
WorkflowTransitionDto11" 7
>117 8
>118 9+
GetTransitionsByWorkflowIdAsync11: Y
(11Y Z
int11Z ]

workflowId11^ h
)11h i
{22 
var33 
list33 
=33 
await33 
_transitionRepo33 (
.33( )
GetAllAsync33) 4
(334 5
t335 6
=>337 9
t33: ;
.33; <

WorkflowId33< F
==33G I

workflowId33J T
)33T U
;33U V
return44 
list44 
.44 
Select44 
(44 
t44 
=>44 
new44  #!
WorkflowTransitionDto44$ 9
(449 :
t44: ;
.44; <
Id44< >
,44> ?
t44@ A
.44A B

WorkflowId44B L
,44L M
t44N O
.44O P
FromStatusId44P \
,44\ ]
t44^ _
.44_ `

ToStatusId44` j
,44j k
t44l m
.44m n
TransitionName44n |
,44| }
t44~ 
.	44 Ä#
RequiredPermissionKey
44Ä ï
,
44ï ñ
t
44ó ò
.
44ò ô
	SortOrder
44ô ¢
,
44¢ £
t
44§ •
.
44• ¶
IsActive
44¶ Æ
)
44Æ Ø
)
44Ø ∞
;
44∞ ±
}55 
public77 

async77 
Task77 
<77 !
WorkflowTransitionDto77 +
?77+ ,
>77, -"
GetTransitionByIdAsync77. D
(77D E
int77E H
id77I K
)77K L
{88 
var99 
t99 
=99 
await99 
_transitionRepo99 %
.99% &
GetByIdAsync99& 2
(992 3
id993 5
)995 6
;996 7
if:: 

(:: 
t:: 
==:: 
null:: 
):: 
return:: 
null:: "
;::" #
return;; 
new;; !
WorkflowTransitionDto;; (
(;;( )
t;;) *
.;;* +
Id;;+ -
,;;- .
t;;/ 0
.;;0 1

WorkflowId;;1 ;
,;;; <
t;;= >
.;;> ?
FromStatusId;;? K
,;;K L
t;;M N
.;;N O

ToStatusId;;O Y
,;;Y Z
t;;[ \
.;;\ ]
TransitionName;;] k
,;;k l
t;;m n
.;;n o"
RequiredPermissionKey	;;o Ñ
,
;;Ñ Ö
t
;;Ü á
.
;;á à
	SortOrder
;;à ë
,
;;ë í
t
;;ì î
.
;;î ï
IsActive
;;ï ù
)
;;ù û
;
;;û ü
}<< 
public>> 

async>> 
Task>> 
<>> !
WorkflowTransitionDto>> +
>>>+ ,!
CreateTransitionAsync>>- B
(>>B C'
CreateWorkflowTransitionDto>>C ^
dto>>_ b
)>>b c
{?? 
if@@ 

(@@ 
dto@@ 
.@@ 
FromStatusId@@ 
==@@ 
dto@@  #
.@@# $

ToStatusId@@$ .
)@@. /
throw@@0 5
new@@6 9%
InvalidOperationException@@: S
(@@S T
$str	@@T Å
)
@@Å Ç
;
@@Ç É
varBB 
tBB 
=BB 
newBB 
WorkflowTransitionBB &
{CC 	

WorkflowIdDD 
=DD 
dtoDD 
.DD 

WorkflowIdDD '
,DD' (
FromStatusIdEE 
=EE 
dtoEE 
.EE 
FromStatusIdEE +
,EE+ ,

ToStatusIdFF 
=FF 
dtoFF 
.FF 

ToStatusIdFF '
,FF' (
TransitionNameGG 
=GG 
dtoGG  
.GG  !
TransitionNameGG! /
,GG/ 0!
RequiredPermissionKeyHH !
=HH" #
dtoHH$ '
.HH' (!
RequiredPermissionKeyHH( =
,HH= >
	SortOrderII 
=II 
dtoII 
.II 
	SortOrderII %
}JJ 	
;JJ	 

awaitKK 
_transitionRepoKK 
.KK 
AddAsyncKK &
(KK& '
tKK' (
)KK( )
;KK) *
returnLL 
newLL !
WorkflowTransitionDtoLL (
(LL( )
tLL) *
.LL* +
IdLL+ -
,LL- .
tLL/ 0
.LL0 1

WorkflowIdLL1 ;
,LL; <
tLL= >
.LL> ?
FromStatusIdLL? K
,LLK L
tLLM N
.LLN O

ToStatusIdLLO Y
,LLY Z
tLL[ \
.LL\ ]
TransitionNameLL] k
,LLk l
tLLm n
.LLn o"
RequiredPermissionKey	LLo Ñ
,
LLÑ Ö
t
LLÜ á
.
LLá à
	SortOrder
LLà ë
,
LLë í
t
LLì î
.
LLî ï
IsActive
LLï ù
)
LLù û
;
LLû ü
}MM 
publicOO 

asyncOO 
TaskOO !
UpdateTransitionAsyncOO +
(OO+ ,
intOO, /
idOO0 2
,OO2 3'
UpdateWorkflowTransitionDtoOO4 O
dtoOOP S
)OOS T
{PP 
ifQQ 

(QQ 
dtoQQ 
.QQ 
FromStatusIdQQ 
==QQ 
dtoQQ  #
.QQ# $

ToStatusIdQQ$ .
)QQ. /
throwQQ0 5
newQQ6 9%
InvalidOperationExceptionQQ: S
(QQS T
$str	QQT Å
)
QQÅ Ç
;
QQÇ É
varSS 
tSS 
=SS 
awaitSS 
_transitionRepoSS %
.SS% &
GetByIdAsyncSS& 2
(SS2 3
idSS3 5
)SS5 6
;SS6 7
ifTT 

(TT 
tTT 
==TT 
nullTT 
)TT 
throwTT 
newTT   
KeyNotFoundExceptionTT! 5
(TT5 6
$strTT6 L
)TTL M
;TTM N
tVV 	
.VV	 

FromStatusIdVV
 
=VV 
dtoVV 
.VV 
FromStatusIdVV )
;VV) *
tWW 	
.WW	 


ToStatusIdWW
 
=WW 
dtoWW 
.WW 

ToStatusIdWW %
;WW% &
tXX 	
.XX	 

TransitionNameXX
 
=XX 
dtoXX 
.XX 
TransitionNameXX -
;XX- .
tYY 	
.YY	 
!
RequiredPermissionKeyYY
 
=YY  !
dtoYY" %
.YY% &!
RequiredPermissionKeyYY& ;
;YY; <
tZZ 	
.ZZ	 

	SortOrderZZ
 
=ZZ 
dtoZZ 
.ZZ 
	SortOrderZZ #
;ZZ# $
t[[ 	
.[[	 

IsActive[[
 
=[[ 
dto[[ 
.[[ 
IsActive[[ !
;[[! "
await\\ 
_transitionRepo\\ 
.\\ 
UpdateAsync\\ )
(\\) *
t\\* +
)\\+ ,
;\\, -
}]] 
public__ 

async__ 
Task__ !
DeleteTransitionAsync__ +
(__+ ,
int__, /
id__0 2
)__2 3
=>__4 6
await__7 <
_transitionRepo__= L
.__L M
DeleteAsync__M X
(__X Y
id__Y [
)__[ \
;__\ ]
}`` ÑE
e/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/WebhookDispatcher.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 
WebhookDispatcher 
:  
IWebhookDispatcher! 3
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly 

HttpClient 
_httpClient  +
;+ ,
private 
readonly 
ILogger 
< 
WebhookDispatcher .
>. /
_logger0 7
;7 8
public 

WebhookDispatcher 
( 
ItsToolDbContext -
context. 5
,5 6

HttpClient7 A

httpClientB L
,L M
ILoggerN U
<U V
WebhookDispatcherV g
>g h
loggeri o
)o p
{ 
_context 
= 
context 
; 
_httpClient 
= 

httpClient  
;  !
_logger 
= 
logger 
; 
} 
public 

async 
Task 
DispatchEventAsync (
(( )
string) /
eventKey0 8
,8 9
object: @
payloadA H
)H I
{ 
var 
subscriptions 
= 
await !
_context" *
.* + 
WebhookSubscriptions+ ?
.   
Where   
(   
w   
=>   
w   
.   
IsActive   "
&&  # %
!  & '
w  ' (
.  ( )
	IsDeleted  ) 2
)  2 3
.!! 
ToListAsync!! 
(!! 
)!! 
;!! 
var## 

activeSubs## 
=## 
subscriptions## &
.##& '
Where##' ,
(##, -
w##- .
=>##/ 1
w##2 3
.##3 4
	EventsCsv##4 =
.##= >
Split##> C
(##C D
$char##D G
)##G H
.##H I
Select##I O
(##O P
e##P Q
=>##R T
e##U V
.##V W
Trim##W [
(##[ \
)##\ ]
)##] ^
.##^ _
Contains##_ g
(##g h
eventKey##h p
)##p q
)##q r
.##r s
ToList##s y
(##y z
)##z {
;##{ |
if%% 

(%% 

activeSubs%% 
.%% 
Count%% 
==%% 
$num%%  !
)%%! "
return%%# )
;%%) *
var'' 
jsonPayload'' 
='' 
JsonSerializer'' (
.''( )
	Serialize'') 2
(''2 3
new''3 6
{(( 	
@event)) 
=)) 
eventKey)) 
,)) 
	timestamp** 
=** 
DateTime**  
.**  !
UtcNow**! '
,**' (
data++ 
=++ 
payload++ 
},, 	
),,	 

;,,
 
var.. 
contentBytes.. 
=.. 
Encoding.. #
...# $
UTF8..$ (
...( )
GetBytes..) 1
(..1 2
jsonPayload..2 =
)..= >
;..> ?
_11 	
=11
 
Task11 
.11 
Run11 
(11 
async11 
(11 
)11 
=>11  
{22 	
foreach33 
(33 
var33 
sub33 
in33 

activeSubs33  *
)33* +
{44 
await55 
SendWebhookAsync55 &
(55& '
sub55' *
,55* +
contentBytes55, 8
,558 9
jsonPayload55: E
)55E F
;55F G
}66 
}77 	
)77	 

;77
 
}88 
private:: 
async:: 
Task:: 
SendWebhookAsync:: '
(::' (
Domain::( .
.::. /
Entities::/ 7
.::7 8
Config::8 >
.::> ?
WebhookSubscription::? R
sub::S V
,::V W
byte::X \
[::\ ]
]::] ^
contentBytes::_ k
,::k l
string::m s
jsonPayload::t 
)	:: Ä
{;; 
var<< 
retryPolicy<< 
=<< 
Policy<<  
.== 
Handle== 
<==  
HttpRequestException== (
>==( )
(==) *
)==* +
.>> 
Or>> 
<>> !
TaskCanceledException>> %
>>>% &
(>>& '
)>>' (
.?? 
WaitAndRetryAsync?? 
(?? 
$num??  
,??  !
retryAttempt??" .
=>??/ 1
TimeSpan??2 :
.??: ;
FromSeconds??; F
(??F G
$num??G H
)??H I
,??I J
(@@ 
	exception@@ 
,@@ 
timeSpan@@  
,@@  !

retryCount@@" ,
,@@, -
context@@. 5
)@@5 6
=>@@7 9
{AA 
_loggerBB 
.BB 

LogWarningBB "
(BB" #
$strBB# I
,BBI J

retryCountBBK U
,BBU V
subBBW Z
.BBZ [
UrlBB[ ^
)BB^ _
;BB_ `
}CC 
)CC 
;CC 
tryEE 
{FF 	
awaitGG 
retryPolicyGG 
.GG 
ExecuteAsyncGG *
(GG* +
asyncGG+ 0
(GG1 2
)GG2 3
=>GG4 6
{HH 
usingII 
varII 
requestII !
=II" #
newII$ '
HttpRequestMessageII( :
(II: ;

HttpMethodII; E
.IIE F
PostIIF J
,IIJ K
subIIL O
.IIO P
UrlIIP S
)IIS T
;IIT U
requestKK 
.KK 
ContentKK 
=KK  !
newKK" %
StringContentKK& 3
(KK3 4
jsonPayloadKK4 ?
,KK? @
EncodingKKA I
.KKI J
UTF8KKJ N
,KKN O
$strKKP b
)KKb c
;KKc d
usingNN 
(NN 
varNN 
hmacNN 
=NN  !
newNN" %

HMACSHA256NN& 0
(NN0 1
EncodingNN1 9
.NN9 :
UTF8NN: >
.NN> ?
GetBytesNN? G
(NNG H
subNNH K
.NNK L
SecretNNL R
)NNR S
)NNS T
)NNT U
{OO 
varPP 
hashPP 
=PP 
hmacPP #
.PP# $
ComputeHashPP$ /
(PP/ 0
contentBytesPP0 <
)PP< =
;PP= >
varQQ 
	signatureQQ !
=QQ" #
BitConverterQQ$ 0
.QQ0 1
ToStringQQ1 9
(QQ9 :
hashQQ: >
)QQ> ?
.QQ? @
ReplaceQQ@ G
(QQG H
$strQQH K
,QQK L
$strQQM O
)QQO P
.QQP Q
ToLowerQQQ X
(QQX Y
)QQY Z
;QQZ [
requestRR 
.RR 
HeadersRR #
.RR# $
AddRR$ '
(RR' (
$strRR( :
,RR: ;
	signatureRR< E
)RRE F
;RRF G
}SS 
usingVV 
varVV 
ctsVV 
=VV 
newVV  #
SystemVV$ *
.VV* +
	ThreadingVV+ 4
.VV4 5#
CancellationTokenSourceVV5 L
(VVL M
TimeSpanVVM U
.VVU V
FromSecondsVVV a
(VVa b
$numVVb c
)VVc d
)VVd e
;VVe f
varXX 
responseXX 
=XX 
awaitXX $
_httpClientXX% 0
.XX0 1
	SendAsyncXX1 :
(XX: ;
requestXX; B
,XXB C
ctsXXD G
.XXG H
TokenXXH M
)XXM N
;XXN O
responseYY 
.YY #
EnsureSuccessStatusCodeYY 0
(YY0 1
)YY1 2
;YY2 3
_logger[[ 
.[[ 
LogInformation[[ &
([[& '
$str[[' K
,[[K L
sub[[M P
.[[P Q
Url[[Q T
)[[T U
;[[U V
}\\ 
)\\ 
;\\ 
}]] 	
catch^^ 
(^^ 
	Exception^^ 
ex^^ 
)^^ 
{__ 	
_logger`` 
.`` 
LogError`` 
(`` 
ex`` 
,``  
$str``! I
,``I J
sub``K N
.``N O
Url``O R
)``R S
;``S T
}aa 	
}bb 
}cc ¯n
_/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/UserService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public

 
class

 
UserService

 
:

 
IUserService

 '
{ 
private 
readonly 
IRepository  
<  !
User! %
>% &
_repository' 2
;2 3
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

UserService 
( 
IRepository "
<" #
User# '
>' (

repository) 3
,3 4
ItsToolDbContext5 E
contextF M
)M N
{ 
_repository 
= 

repository  
;  !
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
IEnumerable !
<! "
UserDto" )
>) *
>* +
GetAllAsync, 7
(7 8
)8 9
{ 
var 
users 
= 
await 
_context "
." #
Users# (
.( )
Where) .
(. /
u/ 0
=>1 3
!4 5
u5 6
.6 7
	IsDeleted7 @
)@ A
.A B
IncludeB I
(I J
uJ K
=>L N
uO P
.P Q
	UserRolesQ Z
)Z [
.[ \
Include\ c
(c d
ud e
=>f h
ui j
.j k
PermissionOverridesk ~
)~ 
.	 Ä
ToListAsync
Ä ã
(
ã å
)
å ç
;
ç é
return 
users 
. 
Select 
( 
u 
=>  
new! $
UserDto% ,
(, -
u 
. 
Id 
, 
u 
. 
Username 
, 
u 
.  
Email  %
,% &
u' (
.( )
	FirstName) 2
,2 3
u4 5
.5 6
LastName6 >
,> ?
u@ A
.A B
IsActiveB J
,J K
uL M
.M N
DepartmentIdN Z
,Z [
u 
. 
	UserRoles 
. 
Select 
( 
ur !
=>" $
ur% '
.' (
RoleId( .
). /
./ 0
ToArray0 7
(7 8
)8 9
,9 :
u 
. 
PermissionOverrides !
.! "
ToDictionary" .
(. /
po/ 1
=>2 4
po5 7
.7 8
PermissionId8 D
,D E
poF H
=>I K
poL N
.N O
	IsGrantedO X
)X Y
,Y Z
u 
. 
ProfilePhoto 
) 	
)	 

;
 
} 
public   

async   
Task   
<   
UserDto   
?   
>   
GetByIdAsync    ,
(  , -
int  - 0
id  1 3
)  3 4
{!! 
var"" 
user"" 
="" 
await"" 
_context"" !
.""! "
Users""" '
.""' (
Where""( -
(""- .
u"". /
=>""0 2
!""3 4
u""4 5
.""5 6
	IsDeleted""6 ?
)""? @
.""@ A
Include""A H
(""H I
u""I J
=>""K M
u""N O
.""O P
	UserRoles""P Y
)""Y Z
.""Z [
Include""[ b
(""b c
u""c d
=>""e g
u""h i
.""i j
PermissionOverrides""j }
)""} ~
.""~  
FirstOrDefaultAsync	"" í
(
""í ì
u
""ì î
=>
""ï ó
u
""ò ô
.
""ô ö
Id
""ö ú
==
""ù ü
id
""† ¢
)
""¢ £
;
""£ §
if## 

(## 
user## 
==## 
null## 
)## 
return##  
null##! %
;##% &
return$$ 
new$$ 
UserDto$$ 
($$ 
user%% 
.%% 
Id%% 
,%% 
user%% 
.%% 
Username%% "
,%%" #
user%%$ (
.%%( )
Email%%) .
,%%. /
user%%0 4
.%%4 5
	FirstName%%5 >
,%%> ?
user%%@ D
.%%D E
LastName%%E M
,%%M N
user%%O S
.%%S T
IsActive%%T \
,%%\ ]
user%%^ b
.%%b c
DepartmentId%%c o
,%%o p
user&& 
.&& 
	UserRoles&& 
.&& 
Select&& !
(&&! "
ur&&" $
=>&&% '
ur&&( *
.&&* +
RoleId&&+ 1
)&&1 2
.&&2 3
ToArray&&3 :
(&&: ;
)&&; <
,&&< =
user'' 
.'' 
PermissionOverrides'' $
.''$ %
ToDictionary''% 1
(''1 2
po''2 4
=>''5 7
po''8 :
.'': ;
PermissionId''; G
,''G H
po''I K
=>''L N
po''O Q
.''Q R
	IsGranted''R [
)''[ \
,''\ ]
user(( 
.(( 
ProfilePhoto(( 
))) 	
;))	 

}** 
public,, 

async,, 
Task,, 
<,, 
UserDto,, 
>,, 
CreateAsync,, *
(,,* +
CreateUserDto,,+ 8
dto,,9 <
),,< =
{-- 
var.. 
user.. 
=.. 
new.. 
User.. 
{// 	
Username00 
=00 
dto00 
.00 
Username00 #
,00# $
Email11 
=11 
dto11 
.11 
Email11 
,11 
	FirstName22 
=22 
dto22 
.22 
	FirstName22 %
,22% &
LastName33 
=33 
dto33 
.33 
LastName33 #
,33# $
PasswordHash44 
=44 
BCrypt44 !
.44! "
Net44" %
.44% &
BCrypt44& ,
.44, -
HashPassword44- 9
(449 :
dto44: =
.44= >
Password44> F
)44F G
,44G H
DepartmentId55 
=55 
dto55 
.55 
DepartmentId55 +
,55+ ,
ProfilePhoto66 
=66 
dto66 
.66 
ProfilePhoto66 +
}77 	
;77	 

await88 
_repository88 
.88 
AddAsync88 "
(88" #
user88# '
)88' (
;88( )
return99 
new99 
UserDto99 
(99 
user99 
.99  
Id99  "
,99" #
user99$ (
.99( )
Username99) 1
,991 2
user993 7
.997 8
Email998 =
,99= >
user99? C
.99C D
	FirstName99D M
,99M N
user99O S
.99S T
LastName99T \
,99\ ]
user99^ b
.99b c
IsActive99c k
,99k l
user99m q
.99q r
DepartmentId99r ~
,99~ 
Array
99Ä Ö
.
99Ö Ü
Empty
99Ü ã
<
99ã å
int
99å è
>
99è ê
(
99ê ë
)
99ë í
,
99í ì
new
99î ó

Dictionary
99ò ¢
<
99¢ £
int
99£ ¶
,
99¶ ß
bool
99® ¨
>
99¨ ≠
(
99≠ Æ
)
99Æ Ø
,
99Ø ∞
user
99± µ
.
99µ ∂
ProfilePhoto
99∂ ¬
)
99¬ √
;
99√ ƒ
}:: 
public<< 

async<< 
Task<< 
UpdateAsync<< !
(<<! "
int<<" %
id<<& (
,<<( )
UpdateUserDto<<* 7
dto<<8 ;
)<<; <
{== 
var>> 
user>> 
=>> 
await>> 
_repository>> $
.>>$ %
GetByIdAsync>>% 1
(>>1 2
id>>2 4
)>>4 5
;>>5 6
if?? 

(?? 
user?? 
==?? 
null?? 
)?? 
throw?? 
new??  # 
KeyNotFoundException??$ 8
(??8 9
$str??9 I
)??I J
;??J K
userAA 
.AA 
EmailAA 
=AA 
dtoAA 
.AA 
EmailAA 
;AA 
userBB 
.BB 
	FirstNameBB 
=BB 
dtoBB 
.BB 
	FirstNameBB &
;BB& '
userCC 
.CC 
LastNameCC 
=CC 
dtoCC 
.CC 
LastNameCC $
;CC$ %
userDD 
.DD 
IsActiveDD 
=DD 
dtoDD 
.DD 
IsActiveDD $
;DD$ %
userEE 
.EE 
DepartmentIdEE 
=EE 
dtoEE 
.EE  
DepartmentIdEE  ,
;EE, -
userFF 
.FF 
ProfilePhotoFF 
=FF 
dtoFF 
.FF  
ProfilePhotoFF  ,
;FF, -
awaitGG 
_repositoryGG 
.GG 
UpdateAsyncGG %
(GG% &
userGG& *
)GG* +
;GG+ ,
}HH 
publicJJ 

asyncJJ 
TaskJJ 
DeleteAsyncJJ !
(JJ! "
intJJ" %
idJJ& (
)JJ( )
{KK 
awaitLL 
_repositoryLL 
.LL 
DeleteAsyncLL %
(LL% &
idLL& (
)LL( )
;LL) *
}MM 
publicOO 

asyncOO 
TaskOO 
AssignRoleAsyncOO %
(OO% &
intOO& )
userIdOO* 0
,OO0 1
intOO2 5
roleIdOO6 <
)OO< =
{PP 
varQQ 
existsQQ 
=QQ 
awaitQQ 
_contextQQ #
.QQ# $
	UserRolesQQ$ -
.QQ- .
AnyAsyncQQ. 6
(QQ6 7
urQQ7 9
=>QQ: <
urQQ= ?
.QQ? @
UserIdQQ@ F
==QQG I
userIdQQJ P
&&QQQ S
urQQT V
.QQV W
RoleIdQQW ]
==QQ^ `
roleIdQQa g
)QQg h
;QQh i
ifRR 

(RR 
!RR 
existsRR 
)RR 
{SS 	
_contextTT 
.TT 
	UserRolesTT 
.TT 
AddTT "
(TT" #
newTT# &
UserRoleTT' /
{TT0 1
UserIdTT2 8
=TT9 :
userIdTT; A
,TTA B
RoleIdTTC I
=TTJ K
roleIdTTL R
}TTS T
)TTT U
;TTU V
awaitUU 
_contextUU 
.UU 
SaveChangesAsyncUU +
(UU+ ,
)UU, -
;UU- .
}VV 	
}WW 
publicYY 

asyncYY 
TaskYY 
RevokeRoleAsyncYY %
(YY% &
intYY& )
userIdYY* 0
,YY0 1
intYY2 5
roleIdYY6 <
)YY< =
{ZZ 
var[[ 
ur[[ 
=[[ 
await[[ 
_context[[ 
.[[  
	UserRoles[[  )
.[[) *
FirstOrDefaultAsync[[* =
([[= >
x[[> ?
=>[[@ B
x[[C D
.[[D E
UserId[[E K
==[[L N
userId[[O U
&&[[V X
x[[Y Z
.[[Z [
RoleId[[[ a
==[[b d
roleId[[e k
)[[k l
;[[l m
if\\ 

(\\ 
ur\\ 
!=\\ 
null\\ 
)\\ 
{]] 	
_context^^ 
.^^ 
	UserRoles^^ 
.^^ 
Remove^^ %
(^^% &
ur^^& (
)^^( )
;^^) *
await__ 
_context__ 
.__ 
SaveChangesAsync__ +
(__+ ,
)__, -
;__- .
}`` 	
}aa 
publiccc 

asynccc 
Taskcc &
AddPermissionOverrideAsynccc 0
(cc0 1
intcc1 4
userIdcc5 ;
,cc; <
intcc= @
permissionIdccA M
,ccM N
boolccO S
	isGrantedccT ]
)cc] ^
{dd 
varee 
overee 
=ee 
awaitee 
_contextee !
.ee! "#
UserPermissionOverridesee" 9
.ff 
FirstOrDefaultAsyncff  
(ff  !
off! "
=>ff# %
off& '
.ff' (
UserIdff( .
==ff/ 1
userIdff2 8
&&ff9 ;
off< =
.ff= >
PermissionIdff> J
==ffK M
permissionIdffN Z
)ffZ [
;ff[ \
ifhh 

(hh 
overhh 
!=hh 
nullhh 
)hh 
{ii 	
overjj 
.jj 
	IsGrantedjj 
=jj 
	isGrantedjj &
;jj& '
}kk 	
elsell 
{mm 	
_contextnn 
.nn #
UserPermissionOverridesnn ,
.nn, -
Addnn- 0
(nn0 1
newnn1 4"
UserPermissionOverridenn5 K
{oo 
UserIdpp 
=pp 
userIdpp 
,pp  
PermissionIdqq 
=qq 
permissionIdqq +
,qq+ ,
	IsGrantedrr 
=rr 
	isGrantedrr %
}ss 
)ss 
;ss 
}tt 	
awaituu 
_contextuu 
.uu 
SaveChangesAsyncuu '
(uu' (
)uu( )
;uu) *
}vv 
}ww ´Ï
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/TicketService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 
TicketService 
: 
ITicketService +
{ 
private 
const 
string !
TicketNotFoundMessage .
=/ 0
$str1 D
;D E
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly 
IFileStorageService (
_fileStorage) 5
;5 6
private 
readonly !
IPermissionCalculator *!
_permissionCalculator+ @
;@ A
private 
readonly 

ISlaEngine 

_slaEngine  *
;* +
private 
readonly 
IAssignmentEngine &
_assignmentEngine' 8
;8 9
private 
readonly #
INotificationDispatcher ,#
_notificationDispatcher- D
;D E
public 

TicketService 
( 
ItsToolDbContext )
context* 1
,1 2
IFileStorageService3 F
fileStorageG R
,R S!
IPermissionCalculatorT i 
permissionCalculatorj ~
,~ 

ISlaEngine
Ä ä
	slaEngine
ã î
,
î ï
IAssignmentEngine
ñ ß
assignmentEngine
® ∏
,
∏ π%
INotificationDispatcher
∫ —$
notificationDispatcher
“ Ë
)
Ë È
{ 
_context 
= 
context 
; 
_fileStorage 
= 
fileStorage "
;" #!
_permissionCalculator 
=  
permissionCalculator  4
;4 5

_slaEngine 
= 
	slaEngine 
; 
_assignmentEngine 
= 
assignmentEngine ,
;, -#
_notificationDispatcher 
=  !"
notificationDispatcher" 8
;8 9
}   
private"" 
async"" 
Task"" 
<"" 
string"" 
>"" %
GenerateTicketNumberAsync"" 8
(""8 9
int""9 <
	projectId""= F
)""F G
{## 
var$$ 
project$$ 
=$$ 
await$$ 
_context$$ $
.$$$ %
Projects$$% -
.$$- .
	FindAsync$$. 7
($$7 8
	projectId$$8 A
)$$A B
;$$B C
if%% 

(%% 
project%% 
==%% 
null%% 
)%% 
throw%% "
new%%# & 
KeyNotFoundException%%' ;
(%%; <
$str%%< P
)%%P Q
;%%Q R
var'' 
sequence'' 
='' 
await'' 
_context'' %
.''% &
ProjectSequences''& 6
.''6 7
FirstOrDefaultAsync''7 J
(''J K
ps''K M
=>''N P
ps''Q S
.''S T
	ProjectId''T ]
==''^ `
	projectId''a j
)''j k
;''k l
if(( 

((( 
sequence(( 
==(( 
null(( 
)(( 
{)) 	
sequence** 
=** 
new** 
ProjectSequence** *
{**+ ,
	ProjectId**- 6
=**7 8
	projectId**9 B
,**B C
CurrentValue**D P
=**Q R
$num**S T
}**U V
;**V W
_context++ 
.++ 
ProjectSequences++ %
.++% &
Add++& )
(++) *
sequence++* 2
)++2 3
;++3 4
},, 	
else-- 
{.. 	
sequence// 
.// 
CurrentValue// !
++//! #
;//# $
}00 	
await22 
_context22 
.22 
SaveChangesAsync22 '
(22' (
)22( )
;22) *
return33 
$"33 
{33 
project33 
.33 

ProjectKey33 $
}33$ %
$str33% &
{33& '
sequence33' /
.33/ 0
CurrentValue330 <
}33< =
"33= >
;33> ?
}44 
private66 
async66 
Task66 &
ValidateDynamicFieldsAsync66 1
(661 2
int662 5
	projectId666 ?
,66? @
int66A D

categoryId66E O
,66O P
int66Q T
typeId66U [
,66[ \

Dictionary66] g
<66g h
string66h n
,66n o
string66p v
>66v w
customFields	66x Ñ
)
66Ñ Ö
{77 
var88 

placements88 
=88 
await88 
_context88 '
.88' (
FormFieldPlacements88( ;
.99 
Include99 
(99 
p99 
=>99 
p99 
.99 
FieldDefinition99 +
)99+ ,
.:: 
Where:: 
(:: 
p:: 
=>:: 
!:: 
p:: 
.:: 
	IsDeleted:: $
&&::% '
p::( )
.::) *
IsActive::* 2
&&::3 5
p::6 7
.::7 8
	ProjectId::8 A
==::B D
	projectId::E N
&&::O Q
p::R S
.::S T

CategoryId::T ^
==::_ a

categoryId::b l
&&::m o
p::p q
.::q r
TicketTypeId::r ~
==	:: Å
typeId
::Ç à
)
::à â
.;; 
ToListAsync;; 
(;; 
);; 
;;; 
foreach== 
(== 
var== 
p== 
in== 

placements== $
)==$ %
{>> 	
var?? 
def?? 
=?? 
p?? 
.?? 
FieldDefinition?? '
!??' (
;??( )
customFields@@ 
.@@ 
TryGetValue@@ $
(@@$ %
def@@% (
.@@( )
Key@@) ,
,@@, -
out@@. 1
var@@2 5
val@@6 9
)@@9 :
;@@: ;!
ValidateRequiredFieldBB !
(BB! "
pBB" #
,BB# $
defBB% (
,BB( )
valBB* -
)BB- .
;BB. /
ifDD 
(DD 
!DD 
stringDD 
.DD 
IsNullOrWhiteSpaceDD *
(DD* +
valDD+ .
)DD. /
)DD/ 0
{EE 
ValidateRegexFormatFF #
(FF# $
defFF$ '
,FF' (
valFF) ,
)FF, -
;FF- .
awaitGG %
ValidateFieldOptionsAsyncGG /
(GG/ 0
defGG0 3
,GG3 4
valGG5 8
)GG8 9
;GG9 :
}HH 
}II 	
}JJ 
privateLL 
staticLL 
voidLL !
ValidateRequiredFieldLL -
(LL- .
FormFieldPlacementLL. @
	placementLLA J
,LLJ K
FieldDefinitionLLL [
defLL\ _
,LL_ `
stringLLa g
?LLg h
valLLi l
)LLl m
{MM 
ifNN 

(NN 
	placementNN 
.NN 

IsRequiredNN  
&&NN! #
stringNN$ *
.NN* +
IsNullOrWhiteSpaceNN+ =
(NN= >
valNN> A
)NNA B
)NNB C
throwOO 
newOO %
InvalidOperationExceptionOO /
(OO/ 0
$"OO0 2
$strOO2 8
{OO8 9
defOO9 <
.OO< =
LabelOO= B
}OOB C
$strOOC P
"OOP Q
)OOQ R
;OOR S
}PP 
privateRR 
staticRR 
voidRR 
ValidateRegexFormatRR +
(RR+ ,
FieldDefinitionRR, ;
defRR< ?
,RR? @
stringRRA G
valRRH K
)RRK L
{SS 
ifTT 

(TT 
!TT 
stringTT 
.TT 
IsNullOrWhiteSpaceTT &
(TT& '
defTT' *
.TT* +
ValidationRegexTT+ :
)TT: ;
)TT; <
{UU 	
tryVV 
{WW 
ifXX 
(XX 
!XX 
RegexXX 
.XX 
IsMatchXX "
(XX" #
valXX# &
,XX& '
defXX( +
.XX+ ,
ValidationRegexXX, ;
,XX; <
RegexOptionsXX= I
.XXI J
NoneXXJ N
,XXN O
TimeSpanXXP X
.XXX Y
FromSecondsXXY d
(XXd e
$numXXe f
)XXf g
)XXg h
)XXh i
throwYY 
newYY %
InvalidOperationExceptionYY 7
(YY7 8
$"YY8 :
$strYY: @
{YY@ A
defYYA D
.YYD E
LabelYYE J
}YYJ K
$strYYK ^
"YY^ _
)YY_ `
;YY` a
}ZZ 
catch[[ 
([[ &
RegexMatchTimeoutException[[ -
)[[- .
{\\ 
throw]] 
new]] %
InvalidOperationException]] 3
(]]3 4
$"]]4 6
$str]]6 <
{]]< =
def]]= @
.]]@ A
Label]]A F
}]]F G
$str]]G Z
"]]Z [
)]][ \
;]]\ ]
}^^ 
}__ 	
}`` 
privatebb 
asyncbb 
Taskbb %
ValidateFieldOptionsAsyncbb 0
(bb0 1
FieldDefinitionbb1 @
defbbA D
,bbD E
stringbbF L
valbbM P
)bbP Q
{cc 
ifdd 

(dd 
defdd 
.dd 
	FieldTypedd 
==dd 
	FieldTypedd &
.dd& '
Dropdowndd' /
||dd0 2
defdd3 6
.dd6 7
	FieldTypedd7 @
==ddA C
	FieldTypeddD M
.ddM N
MultiSelectddN Y
)ddY Z
{ee 	
varff 
optionsff 
=ff 
awaitff 
_contextff  (
.ff( )
FieldOptionsff) 5
.ff5 6
Whereff6 ;
(ff; <
off< =
=>ff> @
offA B
.ffB C
FieldDefinitionIdffC T
==ffU W
defffX [
.ff[ \
Idff\ ^
&&ff_ a
!ffb c
offc d
.ffd e
	IsDeletedffe n
)ffn o
.ffo p
Selectffp v
(ffv w
offw x
=>ffy {
off| }
.ff} ~
Value	ff~ É
)
ffÉ Ñ
.
ffÑ Ö
ToListAsync
ffÖ ê
(
ffê ë
)
ffë í
;
ffí ì
ifgg 
(gg 
!gg 
optionsgg 
.gg 
Containsgg !
(gg! "
valgg" %
)gg% &
)gg& '
throwhh 
newhh %
InvalidOperationExceptionhh 3
(hh3 4
$"hh4 6
$strhh6 <
{hh< =
defhh= @
.hh@ A
LabelhhA F
}hhF G
$strhhG `
"hh` a
)hha b
;hhb c
}ii 	
}jj 
publicll 

asyncll 
Taskll 
<ll 
	TicketDtoll 
>ll  
CreateTicketAsyncll! 2
(ll2 3
CreateTicketDtoll3 B
dtollC F
)llF G
{mm 
varnn 
numbernn 
=nn 
awaitnn %
GenerateTicketNumberAsyncnn 4
(nn4 5
dtonn5 8
.nn8 9
	ProjectIdnn9 B
)nnB C
;nnC D
awaitoo &
ValidateDynamicFieldsAsyncoo (
(oo( )
dtooo) ,
.oo, -
	ProjectIdoo- 6
,oo6 7
dtooo8 ;
.oo; <

CategoryIdoo< F
,ooF G
dtoooH K
.ooK L
TypeIdooL R
,ooR S
dtoooT W
.ooW X
CustomFieldsooX d
)ood e
;ooe f
varrr 
defaultStatusrr 
=rr 
awaitrr !
_contextrr" *
.rr* +
Statusesrr+ 3
.rr3 4
FirstOrDefaultAsyncrr4 G
(rrG H
srrH I
=>rrJ L
srrM N
.rrN O
IsSystemDefaultrrO ^
&&rr_ a
!rrb c
srrc d
.rrd e
	IsDeletedrre n
)rrn o
;rro p
ifss 

(ss 
defaultStatusss 
==ss 
nullss !
)ss! "
throwss# (
newss) ,%
InvalidOperationExceptionss- F
(ssF G
$strssG i
)ssi j
;ssj k
varuu 
tuu 
=uu 
newuu 
Ticketuu 
{vv 	
TicketNumberww 
=ww 
numberww !
,ww! "
Titlexx 
=xx 
dtoxx 
.xx 
Titlexx 
,xx 
Descriptionyy 
=yy 
dtoyy 
.yy 
Descriptionyy )
,yy) *
	ProjectIdzz 
=zz 
dtozz 
.zz 
	ProjectIdzz %
,zz% &

CategoryId{{ 
={{ 
dto{{ 
.{{ 

CategoryId{{ '
,{{' (
TypeId|| 
=|| 
dto|| 
.|| 
TypeId|| 
,||  

PriorityId}} 
=}} 
dto}} 
.}} 

PriorityId}} '
,}}' (
RequesterUserId~~ 
=~~ 
dto~~ !
.~~! "
RequesterUserId~~" 1
,~~1 2
StatusId 
= 
defaultStatus $
.$ %
Id% '
}
ÄÄ 	
;
ÄÄ	 

_context
ÅÅ 
.
ÅÅ 
Tickets
ÅÅ 
.
ÅÅ 
Add
ÅÅ 
(
ÅÅ 
t
ÅÅ 
)
ÅÅ 
;
ÅÅ  
await
ÇÇ 
_context
ÇÇ 
.
ÇÇ 
SaveChangesAsync
ÇÇ '
(
ÇÇ' (
)
ÇÇ( )
;
ÇÇ) *
foreach
ÑÑ 
(
ÑÑ 
var
ÑÑ 
kvp
ÑÑ 
in
ÑÑ 
dto
ÑÑ 
.
ÑÑ  
CustomFields
ÑÑ  ,
)
ÑÑ, -
{
ÖÖ 	
var
ÜÜ 
def
ÜÜ 
=
ÜÜ 
await
ÜÜ 
_context
ÜÜ $
.
ÜÜ$ %
FieldDefinitions
ÜÜ% 5
.
ÜÜ5 6!
FirstOrDefaultAsync
ÜÜ6 I
(
ÜÜI J
fd
ÜÜJ L
=>
ÜÜM O
fd
ÜÜP R
.
ÜÜR S
Key
ÜÜS V
==
ÜÜW Y
kvp
ÜÜZ ]
.
ÜÜ] ^
Key
ÜÜ^ a
)
ÜÜa b
;
ÜÜb c
if
áá 
(
áá 
def
áá 
!=
áá 
null
áá 
)
áá 
{
àà 
_context
ââ 
.
ââ 
TicketFieldValues
ââ *
.
ââ* +
Add
ââ+ .
(
ââ. /
new
ââ/ 2
TicketFieldValue
ââ3 C
{
ää 
TicketId
ãã 
=
ãã 
t
ãã  
.
ãã  !
Id
ãã! #
,
ãã# $
FieldDefinitionId
åå %
=
åå& '
def
åå( +
.
åå+ ,
Id
åå, .
,
åå. /
ValueString
çç 
=
çç  !
kvp
çç" %
.
çç% &
Value
çç& +
}
éé 
)
éé 
;
éé 
}
èè 
}
êê 	
_context
íí 
.
íí 
TicketHistories
íí  
.
íí  !
Add
íí! $
(
íí$ %
new
íí% (
TicketHistory
íí) 6
{
ìì 	
TicketId
îî 
=
îî 
t
îî 
.
îî 
Id
îî 
,
îî 
Action
ïï 
=
ïï 
$str
ïï 
,
ïï 
	FieldName
ññ 
=
ññ 
$str
ññ  
,
ññ  !
NewValue
óó 
=
óó 
t
óó 
.
óó 
TicketNumber
óó %
,
óó% &
	CreatedBy
òò 
=
òò 
dto
òò 
.
òò 
RequesterUserId
òò +
.
òò+ ,
ToString
òò, 4
(
òò4 5
)
òò5 6
}
ôô 	
)
ôô	 

;
ôô
 
await
öö 
_context
öö 
.
öö 
SaveChangesAsync
öö '
(
öö' (
)
öö( )
;
öö) *
await
ùù 
_assignmentEngine
ùù 
.
ùù  
AssignTicketAsync
ùù  1
(
ùù1 2
t
ùù2 3
)
ùù3 4
;
ùù4 5
await
ûû 
_context
ûû 
.
ûû 
SaveChangesAsync
ûû '
(
ûû' (
)
ûû( )
;
ûû) *
await
†† 

_slaEngine
†† 
.
†† $
AttachSlaToTicketAsync
†† /
(
††/ 0
t
††0 1
.
††1 2
Id
††2 4
)
††4 5
;
††5 6
await
°° %
_notificationDispatcher
°° %
.
°°% & 
DispatchEventAsync
°°& 8
(
°°8 9
$str
°°9 I
,
°°I J
t
°°K L
.
°°L M
Id
°°M O
,
°°O P
dto
°°Q T
.
°°T U
RequesterUserId
°°U d
,
°°d e
$str°°f Ü
)°°Ü á
;°°á à
return
££ 
new
££ 
	TicketDto
££ 
(
££ 
t
££ 
.
££ 
Id
££ !
,
££! "
t
££# $
.
££$ %
TicketNumber
££% 1
,
££1 2
t
££3 4
.
££4 5
Title
££5 :
,
££: ;
t
££< =
.
££= >
Description
££> I
,
££I J
t
££K L
.
££L M
	ProjectId
££M V
,
££V W
t
££X Y
.
££Y Z

CategoryId
££Z d
,
££d e
t
££f g
.
££g h
TypeId
££h n
,
££n o
t
££p q
.
££q r
StatusId
££r z
,
££z {
t
££| }
.
££} ~

PriorityId££~ à
,££à â
t££ä ã
.££ã å
RequesterUserId££å õ
,££õ ú
t££ù û
.££û ü
AssignedUserId££ü ≠
,££≠ Æ
t££Ø ∞
.££∞ ±
AssignedGroupId££± ¿
,££¿ ¡
null££¬ ∆
)££∆ «
;££« »
}
§§ 
public
¶¶ 

async
¶¶ 
Task
¶¶ 
<
¶¶ 
	TicketDto
¶¶ 
?
¶¶  
>
¶¶  ! 
GetTicketByIdAsync
¶¶" 4
(
¶¶4 5
int
¶¶5 8
id
¶¶9 ;
)
¶¶; <
{
ßß 
var
®® 
t
®® 
=
®® 
await
®® 
_context
®® 
.
®® 
Tickets
®® &
.
®®& '!
FirstOrDefaultAsync
®®' :
(
®®: ;
x
®®; <
=>
®®= ?
x
®®@ A
.
®®A B
Id
®®B D
==
®®E G
id
®®H J
&&
®®K M
!
®®N O
x
®®O P
.
®®P Q
	IsDeleted
®®Q Z
)
®®Z [
;
®®[ \
if
©© 

(
©© 
t
©© 
==
©© 
null
©© 
)
©© 
return
©© 
null
©© "
;
©©" #
var
´´ 
customFields
´´ 
=
´´ 
await
´´  
_context
´´! )
.
´´) *
TicketFieldValues
´´* ;
.
¨¨ 
Include
¨¨ 
(
¨¨ 
tfv
¨¨ 
=>
¨¨ 
tfv
¨¨ 
.
¨¨  
FieldDefinition
¨¨  /
)
¨¨/ 0
.
≠≠ 
Where
≠≠ 
(
≠≠ 
tfv
≠≠ 
=>
≠≠ 
tfv
≠≠ 
.
≠≠ 
TicketId
≠≠ &
==
≠≠' )
id
≠≠* ,
)
≠≠, -
.
ÆÆ 
ToDictionaryAsync
ÆÆ 
(
ÆÆ 
tfv
ÆÆ "
=>
ÆÆ# %
tfv
ÆÆ& )
.
ÆÆ) *
FieldDefinition
ÆÆ* 9
!
ÆÆ9 :
.
ÆÆ: ;
Key
ÆÆ; >
,
ÆÆ> ?
tfv
ÆÆ@ C
=>
ÆÆD F
tfv
ÆÆG J
.
ÆÆJ K
ValueString
ÆÆK V
)
ÆÆV W
;
ÆÆW X
return
∞∞ 
new
∞∞ 
	TicketDto
∞∞ 
(
∞∞ 
t
∞∞ 
.
∞∞ 
Id
∞∞ !
,
∞∞! "
t
∞∞# $
.
∞∞$ %
TicketNumber
∞∞% 1
,
∞∞1 2
t
∞∞3 4
.
∞∞4 5
Title
∞∞5 :
,
∞∞: ;
t
∞∞< =
.
∞∞= >
Description
∞∞> I
,
∞∞I J
t
∞∞K L
.
∞∞L M
	ProjectId
∞∞M V
,
∞∞V W
t
∞∞X Y
.
∞∞Y Z

CategoryId
∞∞Z d
,
∞∞d e
t
∞∞f g
.
∞∞g h
TypeId
∞∞h n
,
∞∞n o
t
∞∞p q
.
∞∞q r
StatusId
∞∞r z
,
∞∞z {
t
∞∞| }
.
∞∞} ~

PriorityId∞∞~ à
,∞∞à â
t∞∞ä ã
.∞∞ã å
RequesterUserId∞∞å õ
,∞∞õ ú
t∞∞ù û
.∞∞û ü
AssignedUserId∞∞ü ≠
,∞∞≠ Æ
t∞∞Ø ∞
.∞∞∞ ±
AssignedGroupId∞∞± ¿
,∞∞¿ ¡
customFields∞∞¬ Œ
)∞∞Œ œ
;∞∞œ –
}
±± 
public
≥≥ 

async
≥≥ 
Task
≥≥ 
UpdateTicketAsync
≥≥ '
(
≥≥' (
int
≥≥( +
id
≥≥, .
,
≥≥. /
UpdateTicketDto
≥≥0 ?
dto
≥≥@ C
,
≥≥C D
int
≥≥E H
currentUserId
≥≥I V
)
≥≥V W
{
¥¥ 
var
µµ 
t
µµ 
=
µµ 
await
µµ 
_context
µµ 
.
µµ 
Tickets
µµ &
.
µµ& '!
FirstOrDefaultAsync
µµ' :
(
µµ: ;
x
µµ; <
=>
µµ= ?
x
µµ@ A
.
µµA B
Id
µµB D
==
µµE G
id
µµH J
&&
µµK M
!
µµN O
x
µµO P
.
µµP Q
	IsDeleted
µµQ Z
)
µµZ [
;
µµ[ \
if
∂∂ 

(
∂∂ 
t
∂∂ 
==
∂∂ 
null
∂∂ 
)
∂∂ 
throw
∂∂ 
new
∂∂  "
KeyNotFoundException
∂∂! 5
(
∂∂5 6#
TicketNotFoundMessage
∂∂6 K
)
∂∂K L
;
∂∂L M
await
∏∏ (
ValidateDynamicFieldsAsync
∏∏ (
(
∏∏( )
t
∏∏) *
.
∏∏* +
	ProjectId
∏∏+ 4
,
∏∏4 5
dto
∏∏6 9
.
∏∏9 :

CategoryId
∏∏: D
,
∏∏D E
t
∏∏F G
.
∏∏G H
TypeId
∏∏H N
,
∏∏N O
dto
∏∏P S
.
∏∏S T
CustomFields
∏∏T `
)
∏∏` a
;
∏∏a b
var
∫∫ 
historyEntries
∫∫ 
=
∫∫ 
new
∫∫  
List
∫∫! %
<
∫∫% &
TicketHistory
∫∫& 3
>
∫∫3 4
(
∫∫4 5
)
∫∫5 6
;
∫∫6 7
void
ºº 
	CheckDiff
ºº 
(
ºº 
string
ºº 
	fieldName
ºº '
,
ºº' (
string
ºº) /
?
ºº/ 0
oldVal
ºº1 7
,
ºº7 8
string
ºº9 ?
?
ºº? @
newVal
ººA G
)
ººG H
{
ΩΩ 	
if
ææ 
(
ææ 
oldVal
ææ 
!=
ææ 
newVal
ææ  
)
ææ  !
{
øø 
historyEntries
¿¿ 
.
¿¿ 
Add
¿¿ "
(
¿¿" #
new
¿¿# &
TicketHistory
¿¿' 4
{
¡¡ 
TicketId
¬¬ 
=
¬¬ 
id
¬¬ !
,
¬¬! "
Action
√√ 
=
√√ 
$str
√√ &
,
√√& '
	FieldName
ƒƒ 
=
ƒƒ 
	fieldName
ƒƒ  )
,
ƒƒ) *
OldValue
≈≈ 
=
≈≈ 
oldVal
≈≈ %
,
≈≈% &
NewValue
∆∆ 
=
∆∆ 
newVal
∆∆ %
,
∆∆% &
	CreatedBy
«« 
=
«« 
currentUserId
««  -
.
««- .
ToString
««. 6
(
««6 7
)
««7 8
}
»» 
)
»» 
;
»» 
}
…… 
}
   	
	CheckDiff
ÃÃ 
(
ÃÃ 
$str
ÃÃ 
,
ÃÃ 
t
ÃÃ 
.
ÃÃ 
Title
ÃÃ "
,
ÃÃ" #
dto
ÃÃ$ '
.
ÃÃ' (
Title
ÃÃ( -
)
ÃÃ- .
;
ÃÃ. /
	CheckDiff
ÕÕ 
(
ÕÕ 
$str
ÕÕ 
,
ÕÕ  
t
ÕÕ! "
.
ÕÕ" #
Description
ÕÕ# .
,
ÕÕ. /
dto
ÕÕ0 3
.
ÕÕ3 4
Description
ÕÕ4 ?
)
ÕÕ? @
;
ÕÕ@ A
	CheckDiff
ŒŒ 
(
ŒŒ 
$str
ŒŒ 
,
ŒŒ 
t
ŒŒ  !
.
ŒŒ! "

CategoryId
ŒŒ" ,
.
ŒŒ, -
ToString
ŒŒ- 5
(
ŒŒ5 6
)
ŒŒ6 7
,
ŒŒ7 8
dto
ŒŒ9 <
.
ŒŒ< =

CategoryId
ŒŒ= G
.
ŒŒG H
ToString
ŒŒH P
(
ŒŒP Q
)
ŒŒQ R
)
ŒŒR S
;
ŒŒS T
	CheckDiff
œœ 
(
œœ 
$str
œœ 
,
œœ 
t
œœ  !
.
œœ! "

PriorityId
œœ" ,
.
œœ, -
ToString
œœ- 5
(
œœ5 6
)
œœ6 7
,
œœ7 8
dto
œœ9 <
.
œœ< =

PriorityId
œœ= G
.
œœG H
ToString
œœH P
(
œœP Q
)
œœQ R
)
œœR S
;
œœS T
t
—— 	
.
——	 

Title
——
 
=
—— 
dto
—— 
.
—— 
Title
—— 
;
—— 
t
““ 	
.
““	 

Description
““
 
=
““ 
dto
““ 
.
““ 
Description
““ '
;
““' (
t
”” 	
.
””	 


CategoryId
””
 
=
”” 
dto
”” 
.
”” 

CategoryId
”” %
;
””% &
t
‘‘ 	
.
‘‘	 


PriorityId
‘‘
 
=
‘‘ 
dto
‘‘ 
.
‘‘ 

PriorityId
‘‘ %
;
‘‘% &
var
◊◊ 
existingFields
◊◊ 
=
◊◊ 
await
◊◊ "
_context
◊◊# +
.
◊◊+ ,
TicketFieldValues
◊◊, =
.
ÿÿ 
Include
ÿÿ 
(
ÿÿ 
f
ÿÿ 
=>
ÿÿ 
f
ÿÿ 
.
ÿÿ 
FieldDefinition
ÿÿ +
)
ÿÿ+ ,
.
ŸŸ 
Where
ŸŸ 
(
ŸŸ 
f
ŸŸ 
=>
ŸŸ 
f
ŸŸ 
.
ŸŸ 
TicketId
ŸŸ "
==
ŸŸ# %
id
ŸŸ& (
)
ŸŸ( )
.
⁄⁄ 
ToListAsync
⁄⁄ 
(
⁄⁄ 
)
⁄⁄ 
;
⁄⁄ 
foreach
‹‹ 
(
‹‹ 
var
‹‹ 
kvp
‹‹ 
in
‹‹ 
dto
‹‹ 
.
‹‹  
CustomFields
‹‹  ,
)
‹‹, -
{
›› 	
var
ﬁﬁ 
def
ﬁﬁ 
=
ﬁﬁ 
await
ﬁﬁ 
_context
ﬁﬁ $
.
ﬁﬁ$ %
FieldDefinitions
ﬁﬁ% 5
.
ﬁﬁ5 6!
FirstOrDefaultAsync
ﬁﬁ6 I
(
ﬁﬁI J
fd
ﬁﬁJ L
=>
ﬁﬁM O
fd
ﬁﬁP R
.
ﬁﬁR S
Key
ﬁﬁS V
==
ﬁﬁW Y
kvp
ﬁﬁZ ]
.
ﬁﬁ] ^
Key
ﬁﬁ^ a
)
ﬁﬁa b
;
ﬁﬁb c
if
ﬂﬂ 
(
ﬂﬂ 
def
ﬂﬂ 
==
ﬂﬂ 
null
ﬂﬂ 
)
ﬂﬂ 
continue
ﬂﬂ %
;
ﬂﬂ% &
var
·· 
existing
·· 
=
·· 
existingFields
·· )
.
··) *
FirstOrDefault
··* 8
(
··8 9
f
··9 :
=>
··; =
f
··> ?
.
··? @
FieldDefinitionId
··@ Q
==
··R T
def
··U X
.
··X Y
Id
··Y [
)
··[ \
;
··\ ]
if
‚‚ 
(
‚‚ 
existing
‚‚ 
==
‚‚ 
null
‚‚  
)
‚‚  !
{
„„ 
_context
‰‰ 
.
‰‰ 
TicketFieldValues
‰‰ *
.
‰‰* +
Add
‰‰+ .
(
‰‰. /
new
‰‰/ 2
TicketFieldValue
‰‰3 C
{
ÂÂ 
TicketId
ÊÊ 
=
ÊÊ 
id
ÊÊ !
,
ÊÊ! "
FieldDefinitionId
ÁÁ %
=
ÁÁ& '
def
ÁÁ( +
.
ÁÁ+ ,
Id
ÁÁ, .
,
ÁÁ. /
ValueString
ËË 
=
ËË  !
kvp
ËË" %
.
ËË% &
Value
ËË& +
}
ÈÈ 
)
ÈÈ 
;
ÈÈ 
	CheckDiff
ÍÍ 
(
ÍÍ 
kvp
ÍÍ 
.
ÍÍ 
Key
ÍÍ !
,
ÍÍ! "
null
ÍÍ# '
,
ÍÍ' (
kvp
ÍÍ) ,
.
ÍÍ, -
Value
ÍÍ- 2
)
ÍÍ2 3
;
ÍÍ3 4
}
ÎÎ 
else
ÏÏ 
{
ÌÌ 
if
ÓÓ 
(
ÓÓ 
existing
ÓÓ 
.
ÓÓ 
ValueString
ÓÓ (
!=
ÓÓ) +
kvp
ÓÓ, /
.
ÓÓ/ 0
Value
ÓÓ0 5
)
ÓÓ5 6
{
ÔÔ 
	CheckDiff
 
(
 
kvp
 !
.
! "
Key
" %
,
% &
existing
' /
.
/ 0
ValueString
0 ;
,
; <
kvp
= @
.
@ A
Value
A F
)
F G
;
G H
existing
ÒÒ 
.
ÒÒ 
ValueString
ÒÒ (
=
ÒÒ) *
kvp
ÒÒ+ .
.
ÒÒ. /
Value
ÒÒ/ 4
;
ÒÒ4 5
}
ÚÚ 
}
ÛÛ 
}
ÙÙ 	
if
ˆˆ 

(
ˆˆ 
historyEntries
ˆˆ 
.
ˆˆ 
Count
ˆˆ  
>
ˆˆ! "
$num
ˆˆ# $
)
ˆˆ$ %
{
˜˜ 	
_context
¯¯ 
.
¯¯ 
TicketHistories
¯¯ $
.
¯¯$ %
AddRange
¯¯% -
(
¯¯- .
historyEntries
¯¯. <
)
¯¯< =
;
¯¯= >
}
˘˘ 	
await
˙˙ 
_context
˙˙ 
.
˙˙ 
SaveChangesAsync
˙˙ '
(
˙˙' (
)
˙˙( )
;
˙˙) *
}
˚˚ 
public
˛˛ 

async
˛˛ 
Task
˛˛ 
<
˛˛ 
IEnumerable
˛˛ !
<
˛˛! "
	StatusDto
˛˛" +
>
˛˛+ ,
>
˛˛, -(
GetAllowedTransitionsAsync
˛˛. H
(
˛˛H I
int
˛˛I L
ticketId
˛˛M U
,
˛˛U V
int
˛˛W Z
userId
˛˛[ a
)
˛˛a b
{
ˇˇ 
var
ÄÄ 
t
ÄÄ 
=
ÄÄ 
await
ÄÄ 
_context
ÄÄ 
.
ÄÄ 
Tickets
ÄÄ &
.
ÄÄ& '!
FirstOrDefaultAsync
ÄÄ' :
(
ÄÄ: ;
x
ÄÄ; <
=>
ÄÄ= ?
x
ÄÄ@ A
.
ÄÄA B
Id
ÄÄB D
==
ÄÄE G
ticketId
ÄÄH P
&&
ÄÄQ S
!
ÄÄT U
x
ÄÄU V
.
ÄÄV W
	IsDeleted
ÄÄW `
)
ÄÄ` a
;
ÄÄa b
if
ÅÅ 

(
ÅÅ 
t
ÅÅ 
==
ÅÅ 
null
ÅÅ 
)
ÅÅ 
throw
ÅÅ 
new
ÅÅ  "
KeyNotFoundException
ÅÅ! 5
(
ÅÅ5 6#
TicketNotFoundMessage
ÅÅ6 K
)
ÅÅK L
;
ÅÅL M
var
ÉÉ 
wf
ÉÉ 
=
ÉÉ 
await
ÉÉ 
_context
ÉÉ 
.
ÉÉ  
	Workflows
ÉÉ  )
.
ÑÑ 
Where
ÑÑ 
(
ÑÑ 
w
ÑÑ 
=>
ÑÑ 
(
ÑÑ 
w
ÑÑ 
.
ÑÑ 
	ProjectId
ÑÑ $
==
ÑÑ% '
t
ÑÑ( )
.
ÑÑ) *
	ProjectId
ÑÑ* 3
||
ÑÑ4 6
w
ÑÑ7 8
.
ÑÑ8 9
	ProjectId
ÑÑ9 B
==
ÑÑC E
null
ÑÑF J
)
ÑÑJ K
&&
ÑÑL N
!
ÑÑO P
w
ÑÑP Q
.
ÑÑQ R
	IsDeleted
ÑÑR [
)
ÑÑ[ \
.
ÖÖ 
OrderByDescending
ÖÖ 
(
ÖÖ 
w
ÖÖ  
=>
ÖÖ! #
w
ÖÖ$ %
.
ÖÖ% &
	ProjectId
ÖÖ& /
==
ÖÖ0 2
t
ÖÖ3 4
.
ÖÖ4 5
	ProjectId
ÖÖ5 >
?
ÖÖ? @
$num
ÖÖA B
:
ÖÖC D
$num
ÖÖE F
)
ÖÖF G
.
ÜÜ !
FirstOrDefaultAsync
ÜÜ  
(
ÜÜ  !
)
ÜÜ! "
;
ÜÜ" #
if
áá 

(
áá 
wf
áá 
==
áá 
null
áá 
)
áá 
return
áá 

Enumerable
áá )
.
áá) *
Empty
áá* /
<
áá/ 0
	StatusDto
áá0 9
>
áá9 :
(
áá: ;
)
áá; <
;
áá< =
var
ââ 
	userPerms
ââ 
=
ââ 
await
ââ #
_permissionCalculator
ââ 3
.
ââ3 40
"CalculateEffectivePermissionsAsync
ââ4 V
(
ââV W
userId
ââW ]
)
ââ] ^
;
ââ^ _
var
ãã 
transitions
ãã 
=
ãã 
await
ãã 
_context
ãã  (
.
ãã( )!
WorkflowTransitions
ãã) <
.
åå 
Include
åå 
(
åå 
wt
åå 
=>
åå 
wt
åå 
.
åå 
ToStatus
åå &
)
åå& '
.
çç 
Where
çç 
(
çç 
wt
çç 
=>
çç 
wt
çç 
.
çç 

WorkflowId
çç &
==
çç' )
wf
çç* ,
.
çç, -
Id
çç- /
&&
çç0 2
wt
çç3 5
.
çç5 6
FromStatusId
çç6 B
==
ççC E
t
ççF G
.
ççG H
StatusId
ççH P
&&
ççQ S
!
ççT U
wt
ççU W
.
ççW X
	IsDeleted
ççX a
&&
ççb d
wt
ççe g
.
ççg h
IsActive
ççh p
)
ççp q
.
éé 
ToListAsync
éé 
(
éé 
)
éé 
;
éé 
var
êê 
allowed
êê 
=
êê 
transitions
êê !
.
êê! "
Where
êê" '
(
êê' (
wt
êê( *
=>
êê+ -
string
ëë 
.
ëë 
IsNullOrEmpty
ëë  
(
ëë  !
wt
ëë! #
.
ëë# $#
RequiredPermissionKey
ëë$ 9
)
ëë9 :
||
ëë; =
	userPerms
ëë> G
.
ëëG H
Contains
ëëH P
(
ëëP Q
wt
ëëQ S
.
ëëS T#
RequiredPermissionKey
ëëT i
)
ëëi j
)
ëëj k
.
íí 
Select
íí 
(
íí 
wt
íí 
=>
íí 
new
íí 
	StatusDto
íí '
(
íí' (
wt
ìì 
.
ìì 
ToStatus
ìì 
!
ìì 
.
ìì 
Id
ìì 
,
ìì  
wt
îî 
.
îî 
ToStatus
îî 
.
îî 
Name
îî  
,
îî  !
null
ïï 
,
ïï 
wt
ññ 
.
ññ 
ToStatus
ññ 
.
ññ 
	SortOrder
ññ %
,
ññ% &
wt
óó 
.
óó 
ToStatus
óó 
.
óó 
IsClosedStatus
óó *
,
óó* +
wt
òò 
.
òò 
ToStatus
òò 
.
òò 
IsSystemDefault
òò +
,
òò+ ,
true
ôô 
)
öö 
)
öö 
.
õõ 
OrderBy
õõ 
(
õõ 
s
õõ 
=>
õõ 
s
õõ 
.
õõ 
	SortOrder
õõ %
)
õõ% &
.
úú 
ToList
úú 
(
úú 
)
úú 
;
úú 
var
üü 
currentStatus
üü 
=
üü 
await
üü !
_context
üü" *
.
üü* +
Statuses
üü+ 3
.
üü3 4!
FirstOrDefaultAsync
üü4 G
(
üüG H
s
üüH I
=>
üüJ L
s
üüM N
.
üüN O
Id
üüO Q
==
üüR T
t
üüU V
.
üüV W
StatusId
üüW _
)
üü_ `
;
üü` a
if
†† 

(
†† 
currentStatus
†† 
!=
†† 
null
†† !
&&
††" $
!
††% &
allowed
††& -
.
††- .
Any
††. 1
(
††1 2
a
††2 3
=>
††4 6
a
††7 8
.
††8 9
Id
††9 ;
==
††< >
currentStatus
††? L
.
††L M
Id
††M O
)
††O P
)
††P Q
{
°° 	
allowed
¢¢ 
.
¢¢ 
Insert
¢¢ 
(
¢¢ 
$num
¢¢ 
,
¢¢ 
new
¢¢ !
	StatusDto
¢¢" +
(
¢¢+ ,
currentStatus
££ 
.
££ 
Id
££  
,
££  !
currentStatus
§§ 
.
§§ 
Name
§§ "
,
§§" #
null
•• 
,
•• 
currentStatus
¶¶ 
.
¶¶ 
	SortOrder
¶¶ '
,
¶¶' (
currentStatus
ßß 
.
ßß 
IsClosedStatus
ßß ,
,
ßß, -
currentStatus
®® 
.
®® 
IsSystemDefault
®® -
,
®®- .
true
©© 
)
™™ 
)
™™ 
;
™™ 
}
´´ 	
return
≠≠ 
allowed
≠≠ 
;
≠≠ 
}
ÆÆ 
public
∞∞ 

async
∞∞ 
Task
∞∞ 
ChangeStatusAsync
∞∞ '
(
∞∞' (
int
∞∞( +
ticketId
∞∞, 4
,
∞∞4 5
ChangeStatusDto
∞∞6 E
dto
∞∞F I
)
∞∞I J
{
±± 
var
≤≤ 
t
≤≤ 
=
≤≤ 
await
≤≤ 
_context
≤≤ 
.
≤≤ 
Tickets
≤≤ &
.
≤≤& '!
FirstOrDefaultAsync
≤≤' :
(
≤≤: ;
x
≤≤; <
=>
≤≤= ?
x
≤≤@ A
.
≤≤A B
Id
≤≤B D
==
≤≤E G
ticketId
≤≤H P
&&
≤≤Q S
!
≤≤T U
x
≤≤U V
.
≤≤V W
	IsDeleted
≤≤W `
)
≤≤` a
;
≤≤a b
if
≥≥ 

(
≥≥ 
t
≥≥ 
==
≥≥ 
null
≥≥ 
)
≥≥ 
throw
≥≥ 
new
≥≥  "
KeyNotFoundException
≥≥! 5
(
≥≥5 6#
TicketNotFoundMessage
≥≥6 K
)
≥≥K L
;
≥≥L M
if
¥¥ 

(
¥¥ 
t
¥¥ 
.
¥¥ 
StatusId
¥¥ 
==
¥¥ 
dto
¥¥ 
.
¥¥ 
NewStatusId
¥¥ )
)
¥¥) *
return
¥¥+ 1
;
¥¥1 2
var
∂∂ 
transitionName
∂∂ 
=
∂∂ 
await
∂∂ "%
ValidateTransitionAsync
∂∂# :
(
∂∂: ;
t
∂∂; <
,
∂∂< =
dto
∂∂> A
.
∂∂A B
NewStatusId
∂∂B M
,
∂∂M N
dto
∂∂O R
.
∂∂R S
UserId
∂∂S Y
)
∂∂Y Z
;
∂∂Z [
var
∏∏ 
	oldStatus
∏∏ 
=
∏∏ 
t
∏∏ 
.
∏∏ 
StatusId
∏∏ "
;
∏∏" #
t
ππ 	
.
ππ	 

StatusId
ππ
 
=
ππ 
dto
ππ 
.
ππ 
NewStatusId
ππ $
;
ππ$ %
_context
ªª 
.
ªª 
TicketHistories
ªª  
.
ªª  !
Add
ªª! $
(
ªª$ %
new
ªª% (
TicketHistory
ªª) 6
{
ºº 	
TicketId
ΩΩ 
=
ΩΩ 
t
ΩΩ 
.
ΩΩ 
Id
ΩΩ 
,
ΩΩ 
Action
ææ 
=
ææ 
transitionName
ææ #
.
ææ# $
Contains
ææ$ ,
(
ææ, -
$str
ææ- 5
,
ææ5 6
StringComparison
ææ7 G
.
ææG H
OrdinalIgnoreCase
ææH Y
)
ææY Z
?
ææ[ \
$str
ææ] g
:
ææh i
$str
ææj y
,
ææy z
	FieldName
øø 
=
øø 
$str
øø "
,
øø" #
OldValue
¿¿ 
=
¿¿ 
	oldStatus
¿¿  
.
¿¿  !
ToString
¿¿! )
(
¿¿) *
)
¿¿* +
,
¿¿+ ,
NewValue
¡¡ 
=
¡¡ 
dto
¡¡ 
.
¡¡ 
NewStatusId
¡¡ &
.
¡¡& '
ToString
¡¡' /
(
¡¡/ 0
)
¡¡0 1
,
¡¡1 2
	CreatedBy
¬¬ 
=
¬¬ 
dto
¬¬ 
.
¬¬ 
UserId
¬¬ "
.
¬¬" #
ToString
¬¬# +
(
¬¬+ ,
)
¬¬, -
}
√√ 	
)
√√	 

;
√√
 
await
≈≈ 
_context
≈≈ 
.
≈≈ 
SaveChangesAsync
≈≈ '
(
≈≈' (
)
≈≈( )
;
≈≈) *
await
«« 

_slaEngine
«« 
.
«« ,
ProcessTicketStatusChangeAsync
«« 7
(
««7 8
t
««8 9
.
««9 :
Id
««: <
,
««< =
	oldStatus
««> G
,
««G H
dto
««I L
.
««L M
NewStatusId
««M X
)
««X Y
;
««Y Z
if
   

(
   
dto
   
.
   
NewStatusId
   
==
   
$num
    
&&
  ! #
	oldStatus
  $ -
!=
  . 0
$num
  1 2
)
  2 3
{
ÀÀ 	
await
ÃÃ %
_notificationDispatcher
ÃÃ )
.
ÃÃ) * 
DispatchEventAsync
ÃÃ* <
(
ÃÃ< =
$str
ÃÃ= S
,
ÃÃS T
t
ÃÃU V
.
ÃÃV W
Id
ÃÃW Y
,
ÃÃY Z
dto
ÃÃ[ ^
.
ÃÃ^ _
UserId
ÃÃ_ e
,
ÃÃe f
$strÃÃg Æ
)ÃÃÆ Ø
;ÃÃØ ∞
}
ÕÕ 	
}
ŒŒ 
private
–– 
async
–– 
Task
–– 
<
–– 
string
–– 
>
–– %
ValidateTransitionAsync
–– 6
(
––6 7
Ticket
––7 =
t
––> ?
,
––? @
int
––A D
newStatusId
––E P
,
––P Q
int
––R U
userId
––V \
)
––\ ]
{
—— 
var
““ 
wf
““ 
=
““ 
await
““ 
_context
““ 
.
““  
	Workflows
““  )
.
”” 
Where
”” 
(
”” 
w
”” 
=>
”” 
(
”” 
w
”” 
.
”” 
	ProjectId
”” $
==
””% '
t
””( )
.
””) *
	ProjectId
””* 3
||
””4 6
w
””7 8
.
””8 9
	ProjectId
””9 B
==
””C E
null
””F J
)
””J K
&&
””L N
!
””O P
w
””P Q
.
””Q R
	IsDeleted
””R [
)
””[ \
.
‘‘ 
OrderByDescending
‘‘ 
(
‘‘ 
w
‘‘  
=>
‘‘! #
w
‘‘$ %
.
‘‘% &
	ProjectId
‘‘& /
==
‘‘0 2
t
‘‘3 4
.
‘‘4 5
	ProjectId
‘‘5 >
?
‘‘? @
$num
‘‘A B
:
‘‘C D
$num
‘‘E F
)
‘‘F G
.
’’ !
FirstOrDefaultAsync
’’  
(
’’  !
)
’’! "
;
’’" #
if
÷÷ 

(
÷÷ 
wf
÷÷ 
==
÷÷ 
null
÷÷ 
)
÷÷ 
throw
÷÷ 
new
÷÷ !'
InvalidOperationException
÷÷" ;
(
÷÷; <
$str
÷÷< \
)
÷÷\ ]
;
÷÷] ^
var
ÿÿ 

transition
ÿÿ 
=
ÿÿ 
await
ÿÿ 
_context
ÿÿ '
.
ÿÿ' (!
WorkflowTransitions
ÿÿ( ;
.
ÿÿ; <!
FirstOrDefaultAsync
ÿÿ< O
(
ÿÿO P
wt
ÿÿP R
=>
ÿÿS U
wt
ŸŸ 
.
ŸŸ 

WorkflowId
ŸŸ 
==
ŸŸ 
wf
ŸŸ 
.
ŸŸ  
Id
ŸŸ  "
&&
ŸŸ# %
wt
ŸŸ& (
.
ŸŸ( )
FromStatusId
ŸŸ) 5
==
ŸŸ6 8
t
ŸŸ9 :
.
ŸŸ: ;
StatusId
ŸŸ; C
&&
ŸŸD F
wt
ŸŸG I
.
ŸŸI J

ToStatusId
ŸŸJ T
==
ŸŸU W
newStatusId
ŸŸX c
&&
ŸŸd f
!
ŸŸg h
wt
ŸŸh j
.
ŸŸj k
	IsDeleted
ŸŸk t
&&
ŸŸu w
wt
ŸŸx z
.
ŸŸz {
IsActiveŸŸ{ É
)ŸŸÉ Ñ
;ŸŸÑ Ö
if
€€ 

(
€€ 

transition
€€ 
==
€€ 
null
€€ 
)
€€ 
throw
€€  %
new
€€& )'
InvalidOperationException
€€* C
(
€€C D
$str
€€D `
)
€€` a
;
€€a b
if
›› 

(
›› 
!
›› 
string
›› 
.
›› 
IsNullOrEmpty
›› !
(
››! "

transition
››" ,
.
››, -#
RequiredPermissionKey
››- B
)
››B C
)
››C D
{
ﬁﬁ 	
var
ﬂﬂ 
perms
ﬂﬂ 
=
ﬂﬂ 
await
ﬂﬂ #
_permissionCalculator
ﬂﬂ 3
.
ﬂﬂ3 40
"CalculateEffectivePermissionsAsync
ﬂﬂ4 V
(
ﬂﬂV W
userId
ﬂﬂW ]
)
ﬂﬂ] ^
;
ﬂﬂ^ _
if
‡‡ 
(
‡‡ 
!
‡‡ 
perms
‡‡ 
.
‡‡ 
Contains
‡‡ 
(
‡‡  

transition
‡‡  *
.
‡‡* +#
RequiredPermissionKey
‡‡+ @
)
‡‡@ A
)
‡‡A B
throw
·· 
new
·· )
UnauthorizedAccessException
·· 5
(
··5 6
$"
··6 8
$str
··8 U
{
··U V

transition
··V `
.
··` a#
RequiredPermissionKey
··a v
}
··v w
"
··w x
)
··x y
;
··y z
}
‚‚ 	
return
„„ 

transition
„„ 
.
„„ 
TransitionName
„„ (
;
„„( )
}
‰‰ 
public
ÊÊ 

async
ÊÊ 
Task
ÊÊ 
AssignTicketAsync
ÊÊ '
(
ÊÊ' (
int
ÊÊ( +
ticketId
ÊÊ, 4
,
ÊÊ4 5
AssignTicketDto
ÊÊ6 E
dto
ÊÊF I
)
ÊÊI J
{
ÁÁ 
var
ËË 
t
ËË 
=
ËË 
await
ËË 
_context
ËË 
.
ËË 
Tickets
ËË &
.
ËË& '!
FirstOrDefaultAsync
ËË' :
(
ËË: ;
x
ËË; <
=>
ËË= ?
x
ËË@ A
.
ËËA B
Id
ËËB D
==
ËËE G
ticketId
ËËH P
&&
ËËQ S
!
ËËT U
x
ËËU V
.
ËËV W
	IsDeleted
ËËW `
)
ËË` a
;
ËËa b
if
ÈÈ 

(
ÈÈ 
t
ÈÈ 
==
ÈÈ 
null
ÈÈ 
)
ÈÈ 
throw
ÈÈ 
new
ÈÈ  "
KeyNotFoundException
ÈÈ! 5
(
ÈÈ5 6#
TicketNotFoundMessage
ÈÈ6 K
)
ÈÈK L
;
ÈÈL M
var
ÎÎ 
perms
ÎÎ 
=
ÎÎ 
await
ÎÎ #
_permissionCalculator
ÎÎ /
.
ÎÎ/ 00
"CalculateEffectivePermissionsAsync
ÎÎ0 R
(
ÎÎR S
dto
ÎÎS V
.
ÎÎV W
AssignerUserId
ÎÎW e
)
ÎÎe f
;
ÎÎf g
if
ÏÏ 

(
ÏÏ 
!
ÏÏ 
perms
ÏÏ 
.
ÏÏ 
Contains
ÏÏ 
(
ÏÏ 
$str
ÏÏ +
)
ÏÏ+ ,
)
ÏÏ, -
throw
ÏÏ. 3
new
ÏÏ4 7)
UnauthorizedAccessException
ÏÏ8 S
(
ÏÏS T
$str
ÏÏT w
)
ÏÏw x
;
ÏÏx y
var
ÓÓ 
oldAssignee
ÓÓ 
=
ÓÓ 
t
ÓÓ 
.
ÓÓ 
AssignedUserId
ÓÓ *
;
ÓÓ* +
t
ÔÔ 	
.
ÔÔ	 

AssignedUserId
ÔÔ
 
=
ÔÔ 
dto
ÔÔ 
.
ÔÔ 
UserId
ÔÔ %
;
ÔÔ% &
_context
ÒÒ 
.
ÒÒ 
TicketHistories
ÒÒ  
.
ÒÒ  !
Add
ÒÒ! $
(
ÒÒ$ %
new
ÒÒ% (
TicketHistory
ÒÒ) 6
{
ÚÚ 	
TicketId
ÛÛ 
=
ÛÛ 
t
ÛÛ 
.
ÛÛ 
Id
ÛÛ 
,
ÛÛ 
Action
ÙÙ 
=
ÙÙ 
$str
ÙÙ 
,
ÙÙ  
	FieldName
ıı 
=
ıı 
$str
ıı (
,
ıı( )
OldValue
ˆˆ 
=
ˆˆ 
oldAssignee
ˆˆ "
?
ˆˆ" #
.
ˆˆ# $
ToString
ˆˆ$ ,
(
ˆˆ, -
)
ˆˆ- .
,
ˆˆ. /
NewValue
˜˜ 
=
˜˜ 
dto
˜˜ 
.
˜˜ 
UserId
˜˜ !
.
˜˜! "
ToString
˜˜" *
(
˜˜* +
)
˜˜+ ,
,
˜˜, -
	CreatedBy
¯¯ 
=
¯¯ 
dto
¯¯ 
.
¯¯ 
AssignerUserId
¯¯ *
.
¯¯* +
ToString
¯¯+ 3
(
¯¯3 4
)
¯¯4 5
}
˘˘ 	
)
˘˘	 

;
˘˘
 
await
˚˚ 
_context
˚˚ 
.
˚˚ 
SaveChangesAsync
˚˚ '
(
˚˚' (
)
˚˚( )
;
˚˚) *
await
¸¸ %
_notificationDispatcher
¸¸ %
.
¸¸% & 
DispatchEventAsync
¸¸& 8
(
¸¸8 9
$str
¸¸9 J
,
¸¸J K
t
¸¸L M
.
¸¸M N
Id
¸¸N P
,
¸¸P Q
dto
¸¸R U
.
¸¸U V
AssignerUserId
¸¸V d
,
¸¸d e
$"
¸¸f h
$str
¸¸h {
{
¸¸{ |
dto
¸¸| 
.¸¸ Ä
UserId¸¸Ä Ü
}¸¸Ü á
"¸¸á à
)¸¸à â
;¸¸â ä
}
˝˝ 
public
ˇˇ 

async
ˇˇ 
Task
ˇˇ !
TransferTicketAsync
ˇˇ )
(
ˇˇ) *
int
ˇˇ* -
ticketId
ˇˇ. 6
,
ˇˇ6 7
TransferTicketDto
ˇˇ8 I
dto
ˇˇJ M
)
ˇˇM N
{
ÄÄ 
var
ÅÅ 
t
ÅÅ 
=
ÅÅ 
await
ÅÅ 
_context
ÅÅ 
.
ÅÅ 
Tickets
ÅÅ &
.
ÅÅ& '!
FirstOrDefaultAsync
ÅÅ' :
(
ÅÅ: ;
x
ÅÅ; <
=>
ÅÅ= ?
x
ÅÅ@ A
.
ÅÅA B
Id
ÅÅB D
==
ÅÅE G
ticketId
ÅÅH P
&&
ÅÅQ S
!
ÅÅT U
x
ÅÅU V
.
ÅÅV W
	IsDeleted
ÅÅW `
)
ÅÅ` a
;
ÅÅa b
if
ÇÇ 

(
ÇÇ 
t
ÇÇ 
==
ÇÇ 
null
ÇÇ 
)
ÇÇ 
throw
ÇÇ 
new
ÇÇ  "
KeyNotFoundException
ÇÇ! 5
(
ÇÇ5 6#
TicketNotFoundMessage
ÇÇ6 K
)
ÇÇK L
;
ÇÇL M
var
ÑÑ 
perms
ÑÑ 
=
ÑÑ 
await
ÑÑ #
_permissionCalculator
ÑÑ /
.
ÑÑ/ 00
"CalculateEffectivePermissionsAsync
ÑÑ0 R
(
ÑÑR S
dto
ÑÑS V
.
ÑÑV W
TransferrerUserId
ÑÑW h
)
ÑÑh i
;
ÑÑi j
if
ÖÖ 

(
ÖÖ 
!
ÖÖ 
perms
ÖÖ 
.
ÖÖ 
Contains
ÖÖ 
(
ÖÖ 
$str
ÖÖ -
)
ÖÖ- .
)
ÖÖ. /
throw
ÖÖ0 5
new
ÖÖ6 9)
UnauthorizedAccessException
ÖÖ: U
(
ÖÖU V
$str
ÖÖV {
)
ÖÖ{ |
;
ÖÖ| }
var
áá 
oldProj
áá 
=
áá 
t
áá 
.
áá 
	ProjectId
áá !
;
áá! "
var
àà 
oldGroup
àà 
=
àà 
t
àà 
.
àà 
AssignedGroupId
àà (
;
àà( )
if
ää 

(
ää 
dto
ää 
.
ää 
	ProjectId
ää 
.
ää 
HasValue
ää "
)
ää" #
t
ää$ %
.
ää% &
	ProjectId
ää& /
=
ää0 1
dto
ää2 5
.
ää5 6
	ProjectId
ää6 ?
.
ää? @
Value
ää@ E
;
ääE F
if
ãã 

(
ãã 
dto
ãã 
.
ãã 
GroupId
ãã 
.
ãã 
HasValue
ãã  
)
ãã  !
t
ãã" #
.
ãã# $
AssignedGroupId
ãã$ 3
=
ãã4 5
dto
ãã6 9
.
ãã9 :
GroupId
ãã: A
.
ããA B
Value
ããB G
;
ããG H
_context
çç 
.
çç 
TicketHistories
çç  
.
çç  !
Add
çç! $
(
çç$ %
new
çç% (
TicketHistory
çç) 6
{
éé 	
TicketId
èè 
=
èè 
t
èè 
.
èè 
Id
èè 
,
èè 
Action
êê 
=
êê 
$str
êê "
,
êê" #
	FieldName
ëë 
=
ëë 
$str
ëë "
,
ëë" #
OldValue
íí 
=
íí 
$"
íí 
$str
íí 
{
íí 
oldProj
íí &
}
íí& '
$str
íí' ,
{
íí, -
oldGroup
íí- 5
}
íí5 6
"
íí6 7
,
íí7 8
NewValue
ìì 
=
ìì 
$"
ìì 
$str
ìì 
{
ìì 
t
ìì  
.
ìì  !
	ProjectId
ìì! *
}
ìì* +
$str
ìì+ 0
{
ìì0 1
t
ìì1 2
.
ìì2 3
AssignedGroupId
ìì3 B
}
ììB C
"
ììC D
,
ììD E
	CreatedBy
îî 
=
îî 
dto
îî 
.
îî 
TransferrerUserId
îî -
.
îî- .
ToString
îî. 6
(
îî6 7
)
îî7 8
}
ïï 	
)
ïï	 

;
ïï
 
await
óó 
_context
óó 
.
óó 
SaveChangesAsync
óó '
(
óó' (
)
óó( )
;
óó) *
}
òò 
public
öö 

async
öö 
Task
öö 
<
öö 
TicketCommentDto
öö &
>
öö& '
AddCommentAsync
öö( 7
(
öö7 8
int
öö8 ;
ticketId
öö< D
,
ööD E
CreateCommentDto
ööF V
dto
ööW Z
)
ööZ [
{
õõ 
var
úú 
c
úú 
=
úú 
new
úú 
TicketComment
úú !
{
ùù 	
TicketId
ûû 
=
ûû 
ticketId
ûû 
,
ûû  
Content
üü 
=
üü 
dto
üü 
.
üü 
Content
üü !
,
üü! "

IsInternal
†† 
=
†† 
dto
†† 
.
†† 

IsInternal
†† '
,
††' (
AuthorUserId
°° 
=
°° 
dto
°° 
.
°° 
AuthorUserId
°° +
}
¢¢ 	
;
¢¢	 

_context
££ 
.
££ 
TicketComments
££ 
.
££  
Add
££  #
(
££# $
c
££$ %
)
££% &
;
££& '
_context
•• 
.
•• 
TicketHistories
••  
.
••  !
Add
••! $
(
••$ %
new
••% (
TicketHistory
••) 6
{
¶¶ 	
TicketId
ßß 
=
ßß 
ticketId
ßß 
,
ßß  
Action
®® 
=
®® 
$str
®® #
,
®®# $
	FieldName
©© 
=
©© 
$str
©© !
,
©©! "
NewValue
™™ 
=
™™ 
c
™™ 
.
™™ 
Id
™™ 
.
™™ 
ToString
™™ $
(
™™$ %
)
™™% &
,
™™& '
	CreatedBy
´´ 
=
´´ 
dto
´´ 
.
´´ 
AuthorUserId
´´ (
.
´´( )
ToString
´´) 1
(
´´1 2
)
´´2 3
}
¨¨ 	
)
¨¨	 

;
¨¨
 
await
ÆÆ 
_context
ÆÆ 
.
ÆÆ 
SaveChangesAsync
ÆÆ '
(
ÆÆ' (
)
ÆÆ( )
;
ÆÆ) *
await
∞∞ 

_slaEngine
∞∞ 
.
∞∞ '
ProcessTicketCommentAsync
∞∞ 2
(
∞∞2 3
ticketId
∞∞3 ;
,
∞∞; <
dto
∞∞= @
.
∞∞@ A

IsInternal
∞∞A K
)
∞∞K L
;
∞∞L M
await
±± %
_notificationDispatcher
±± %
.
±±% & 
DispatchEventAsync
±±& 8
(
±±8 9
$str
±±9 O
,
±±O P
ticketId
±±Q Y
,
±±Y Z
dto
±±[ ^
.
±±^ _
AuthorUserId
±±_ k
,
±±k l
$str±±m á
)±±á à
;±±à â
return
≥≥ 
new
≥≥ 
TicketCommentDto
≥≥ #
(
≥≥# $
c
≥≥$ %
.
≥≥% &
Id
≥≥& (
,
≥≥( )
c
≥≥* +
.
≥≥+ ,
TicketId
≥≥, 4
,
≥≥4 5
c
≥≥6 7
.
≥≥7 8
AuthorUserId
≥≥8 D
,
≥≥D E
c
≥≥F G
.
≥≥G H
Content
≥≥H O
,
≥≥O P
c
≥≥Q R
.
≥≥R S

IsInternal
≥≥S ]
,
≥≥] ^
c
≥≥_ `
.
≥≥` a
	CreatedAt
≥≥a j
)
≥≥j k
;
≥≥k l
}
¥¥ 
public
∂∂ 

async
∂∂ 
Task
∂∂ 
<
∂∂ 
IEnumerable
∂∂ !
<
∂∂! "
TicketCommentDto
∂∂" 2
>
∂∂2 3
>
∂∂3 4
GetCommentsAsync
∂∂5 E
(
∂∂E F
int
∂∂F I
ticketId
∂∂J R
,
∂∂R S
bool
∂∂T X
includeInternal
∂∂Y h
)
∂∂h i
{
∑∑ 
var
∏∏ 
q
∏∏ 
=
∏∏ 
_context
∏∏ 
.
∏∏ 
TicketComments
∏∏ '
.
∏∏' (
Where
∏∏( -
(
∏∏- .
c
∏∏. /
=>
∏∏0 2
c
∏∏3 4
.
∏∏4 5
TicketId
∏∏5 =
==
∏∏> @
ticketId
∏∏A I
&&
∏∏J L
!
∏∏M N
c
∏∏N O
.
∏∏O P
	IsDeleted
∏∏P Y
)
∏∏Y Z
;
∏∏Z [
if
ππ 

(
ππ 
!
ππ 
includeInternal
ππ 
)
ππ 
q
ππ 
=
ππ  !
q
ππ" #
.
ππ# $
Where
ππ$ )
(
ππ) *
c
ππ* +
=>
ππ, .
!
ππ/ 0
c
ππ0 1
.
ππ1 2

IsInternal
ππ2 <
)
ππ< =
;
ππ= >
var
ªª 
list
ªª 
=
ªª 
await
ªª 
q
ªª 
.
ªª 
OrderBy
ªª "
(
ªª" #
c
ªª# $
=>
ªª% '
c
ªª( )
.
ªª) *
	CreatedAt
ªª* 3
)
ªª3 4
.
ªª4 5
ToListAsync
ªª5 @
(
ªª@ A
)
ªªA B
;
ªªB C
return
ºº 
list
ºº 
.
ºº 
Select
ºº 
(
ºº 
c
ºº 
=>
ºº 
new
ºº  #
TicketCommentDto
ºº$ 4
(
ºº4 5
c
ºº5 6
.
ºº6 7
Id
ºº7 9
,
ºº9 :
c
ºº; <
.
ºº< =
TicketId
ºº= E
,
ººE F
c
ººG H
.
ººH I
AuthorUserId
ººI U
,
ººU V
c
ººW X
.
ººX Y
Content
ººY `
,
ºº` a
c
ººb c
.
ººc d

IsInternal
ººd n
,
ººn o
c
ººp q
.
ººq r
	CreatedAt
ººr {
)
ºº{ |
)
ºº| }
;
ºº} ~
}
ΩΩ 
public
øø 

async
øø 
Task
øø 
<
øø !
TicketAttachmentDto
øø )
>
øø) * 
AddAttachmentAsync
øø+ =
(
øø= >
int
øø> A
ticketId
øøB J
,
øøJ K
	IFormFile
øøL U
file
øøV Z
,
øøZ [
int
øø\ _
userId
øø` f
)
øøf g
{
¿¿ 
var
¡¡ 
path
¡¡ 
=
¡¡ 
await
¡¡ 
_fileStorage
¡¡ %
.
¡¡% &
SaveFileAsync
¡¡& 3
(
¡¡3 4
file
¡¡4 8
,
¡¡8 9
ticketId
¡¡: B
)
¡¡B C
;
¡¡C D
var
√√ 
a
√√ 
=
√√ 
new
√√ 
TicketAttachment
√√ $
{
ƒƒ 	
TicketId
≈≈ 
=
≈≈ 
ticketId
≈≈ 
,
≈≈  
FileName
∆∆ 
=
∆∆ 
file
∆∆ 
.
∆∆ 
FileName
∆∆ $
,
∆∆$ %
FilePath
«« 
=
«« 
path
«« 
,
«« 
FileSize
»» 
=
»» 
file
»» 
.
»» 
Length
»» "
,
»»" #
ContentType
…… 
=
…… 
file
…… 
.
…… 
ContentType
…… *
,
……* +
UploadedByUserId
   
=
   
userId
   %
}
ÀÀ 	
;
ÀÀ	 

_context
ÃÃ 
.
ÃÃ 
TicketAttachments
ÃÃ "
.
ÃÃ" #
Add
ÃÃ# &
(
ÃÃ& '
a
ÃÃ' (
)
ÃÃ( )
;
ÃÃ) *
_context
ŒŒ 
.
ŒŒ 
TicketHistories
ŒŒ  
.
ŒŒ  !
Add
ŒŒ! $
(
ŒŒ$ %
new
ŒŒ% (
TicketHistory
ŒŒ) 6
{
œœ 	
TicketId
–– 
=
–– 
ticketId
–– 
,
––  
Action
—— 
=
—— 
$str
—— &
,
——& '
	FieldName
““ 
=
““ 
$str
““ $
,
““$ %
NewValue
”” 
=
”” 
a
”” 
.
”” 
FileName
”” !
,
””! "
	CreatedBy
‘‘ 
=
‘‘ 
userId
‘‘ 
.
‘‘ 
ToString
‘‘ '
(
‘‘' (
)
‘‘( )
}
’’ 	
)
’’	 

;
’’
 
await
◊◊ 
_context
◊◊ 
.
◊◊ 
SaveChangesAsync
◊◊ '
(
◊◊' (
)
◊◊( )
;
◊◊) *
return
ÿÿ 
new
ÿÿ !
TicketAttachmentDto
ÿÿ &
(
ÿÿ& '
a
ÿÿ' (
.
ÿÿ( )
Id
ÿÿ) +
,
ÿÿ+ ,
a
ÿÿ- .
.
ÿÿ. /
TicketId
ÿÿ/ 7
,
ÿÿ7 8
a
ÿÿ9 :
.
ÿÿ: ;
FileName
ÿÿ; C
,
ÿÿC D
a
ÿÿE F
.
ÿÿF G
FilePath
ÿÿG O
,
ÿÿO P
a
ÿÿQ R
.
ÿÿR S
FileSize
ÿÿS [
,
ÿÿ[ \
a
ÿÿ] ^
.
ÿÿ^ _
ContentType
ÿÿ_ j
,
ÿÿj k
a
ÿÿl m
.
ÿÿm n
UploadedByUserId
ÿÿn ~
,
ÿÿ~ 
aÿÿÄ Å
.ÿÿÅ Ç
	CreatedAtÿÿÇ ã
)ÿÿã å
;ÿÿå ç
}
ŸŸ 
public
€€ 

async
€€ 
Task
€€ 
<
€€ 
IEnumerable
€€ !
<
€€! "!
TicketAttachmentDto
€€" 5
>
€€5 6
>
€€6 7!
GetAttachmentsAsync
€€8 K
(
€€K L
int
€€L O
ticketId
€€P X
)
€€X Y
{
‹‹ 
var
›› 
list
›› 
=
›› 
await
›› 
_context
›› !
.
››! "
TicketAttachments
››" 3
.
››3 4
Where
››4 9
(
››9 :
a
››: ;
=>
››< >
a
››? @
.
››@ A
TicketId
››A I
==
››J L
ticketId
››M U
&&
››V X
!
››Y Z
a
››Z [
.
››[ \
	IsDeleted
››\ e
)
››e f
.
››f g
ToListAsync
››g r
(
››r s
)
››s t
;
››t u
return
ﬁﬁ 
list
ﬁﬁ 
.
ﬁﬁ 
Select
ﬁﬁ 
(
ﬁﬁ 
a
ﬁﬁ 
=>
ﬁﬁ 
new
ﬁﬁ  #!
TicketAttachmentDto
ﬁﬁ$ 7
(
ﬁﬁ7 8
a
ﬁﬁ8 9
.
ﬁﬁ9 :
Id
ﬁﬁ: <
,
ﬁﬁ< =
a
ﬁﬁ> ?
.
ﬁﬁ? @
TicketId
ﬁﬁ@ H
,
ﬁﬁH I
a
ﬁﬁJ K
.
ﬁﬁK L
FileName
ﬁﬁL T
,
ﬁﬁT U
a
ﬁﬁV W
.
ﬁﬁW X
FilePath
ﬁﬁX `
,
ﬁﬁ` a
a
ﬁﬁb c
.
ﬁﬁc d
FileSize
ﬁﬁd l
,
ﬁﬁl m
a
ﬁﬁn o
.
ﬁﬁo p
ContentType
ﬁﬁp {
,
ﬁﬁ{ |
a
ﬁﬁ} ~
.
ﬁﬁ~ 
UploadedByUserIdﬁﬁ è
,ﬁﬁè ê
aﬁﬁë í
.ﬁﬁí ì
	CreatedAtﬁﬁì ú
)ﬁﬁú ù
)ﬁﬁù û
;ﬁﬁû ü
}
ﬂﬂ 
public
·· 

async
·· 
Task
·· 
AddWatcherAsync
·· %
(
··% &
int
··& )
ticketId
··* 2
,
··2 3
int
··4 7
userId
··8 >
)
··> ?
{
‚‚ 
var
„„ 
exists
„„ 
=
„„ 
await
„„ 
_context
„„ #
.
„„# $
TicketWatchers
„„$ 2
.
„„2 3
AnyAsync
„„3 ;
(
„„; <
w
„„< =
=>
„„> @
w
„„A B
.
„„B C
TicketId
„„C K
==
„„L N
ticketId
„„O W
&&
„„X Z
w
„„[ \
.
„„\ ]
UserId
„„] c
==
„„d f
userId
„„g m
&&
„„n p
!
„„q r
w
„„r s
.
„„s t
	IsDeleted
„„t }
)
„„} ~
;
„„~ 
if
‰‰ 

(
‰‰ 
!
‰‰ 
exists
‰‰ 
)
‰‰ 
{
ÂÂ 	
_context
ÊÊ 
.
ÊÊ 
TicketWatchers
ÊÊ #
.
ÊÊ# $
Add
ÊÊ$ '
(
ÊÊ' (
new
ÊÊ( +
TicketWatcher
ÊÊ, 9
{
ÊÊ: ;
TicketId
ÊÊ< D
=
ÊÊE F
ticketId
ÊÊG O
,
ÊÊO P
UserId
ÊÊQ W
=
ÊÊX Y
userId
ÊÊZ `
}
ÊÊa b
)
ÊÊb c
;
ÊÊc d
await
ÁÁ 
_context
ÁÁ 
.
ÁÁ 
SaveChangesAsync
ÁÁ +
(
ÁÁ+ ,
)
ÁÁ, -
;
ÁÁ- .
}
ËË 	
}
ÈÈ 
public
ÎÎ 

async
ÎÎ 
Task
ÎÎ  
RemoveWatcherAsync
ÎÎ (
(
ÎÎ( )
int
ÎÎ) ,
ticketId
ÎÎ- 5
,
ÎÎ5 6
int
ÎÎ7 :
userId
ÎÎ; A
)
ÎÎA B
{
ÏÏ 
var
ÌÌ 
w
ÌÌ 
=
ÌÌ 
await
ÌÌ 
_context
ÌÌ 
.
ÌÌ 
TicketWatchers
ÌÌ -
.
ÌÌ- .!
FirstOrDefaultAsync
ÌÌ. A
(
ÌÌA B
x
ÌÌB C
=>
ÌÌD F
x
ÌÌG H
.
ÌÌH I
TicketId
ÌÌI Q
==
ÌÌR T
ticketId
ÌÌU ]
&&
ÌÌ^ `
x
ÌÌa b
.
ÌÌb c
UserId
ÌÌc i
==
ÌÌj l
userId
ÌÌm s
&&
ÌÌt v
!
ÌÌw x
x
ÌÌx y
.
ÌÌy z
	IsDeletedÌÌz É
)ÌÌÉ Ñ
;ÌÌÑ Ö
if
ÓÓ 

(
ÓÓ 
w
ÓÓ 
!=
ÓÓ 
null
ÓÓ 
)
ÓÓ 
{
ÔÔ 	
_context
 
.
 
TicketWatchers
 #
.
# $
Remove
$ *
(
* +
w
+ ,
)
, -
;
- .
await
ÒÒ 
_context
ÒÒ 
.
ÒÒ 
SaveChangesAsync
ÒÒ +
(
ÒÒ+ ,
)
ÒÒ, -
;
ÒÒ- .
}
ÚÚ 	
}
ÛÛ 
public
ıı 

async
ıı 
Task
ıı 
<
ıı 
IEnumerable
ıı !
<
ıı! "
TicketWatcherDto
ıı" 2
>
ıı2 3
>
ıı3 4
GetWatchersAsync
ıı5 E
(
ııE F
int
ııF I
ticketId
ııJ R
)
ııR S
{
ˆˆ 
var
˜˜ 
list
˜˜ 
=
˜˜ 
await
˜˜ 
_context
˜˜ !
.
˜˜! "
TicketWatchers
˜˜" 0
.
˜˜0 1
Where
˜˜1 6
(
˜˜6 7
w
˜˜7 8
=>
˜˜9 ;
w
˜˜< =
.
˜˜= >
TicketId
˜˜> F
==
˜˜G I
ticketId
˜˜J R
&&
˜˜S U
!
˜˜V W
w
˜˜W X
.
˜˜X Y
	IsDeleted
˜˜Y b
)
˜˜b c
.
˜˜c d
ToListAsync
˜˜d o
(
˜˜o p
)
˜˜p q
;
˜˜q r
return
¯¯ 
list
¯¯ 
.
¯¯ 
Select
¯¯ 
(
¯¯ 
w
¯¯ 
=>
¯¯ 
new
¯¯  #
TicketWatcherDto
¯¯$ 4
(
¯¯4 5
w
¯¯5 6
.
¯¯6 7
TicketId
¯¯7 ?
,
¯¯? @
w
¯¯A B
.
¯¯B C
UserId
¯¯C I
)
¯¯I J
)
¯¯J K
;
¯¯K L
}
˘˘ 
public
˚˚ 

async
˚˚ 
Task
˚˚ 
<
˚˚ 
IEnumerable
˚˚ !
<
˚˚! "
TimelineEventDto
˚˚" 2
>
˚˚2 3
>
˚˚3 4
GetTimelineAsync
˚˚5 E
(
˚˚E F
int
˚˚F I
ticketId
˚˚J R
,
˚˚R S
bool
˚˚T X
includeInternal
˚˚Y h
)
˚˚h i
{
¸¸ 
var
˝˝ 
events
˝˝ 
=
˝˝ 
new
˝˝ 
List
˝˝ 
<
˝˝ 
TimelineEventDto
˝˝ .
>
˝˝. /
(
˝˝/ 0
)
˝˝0 1
;
˝˝1 2
var
ˇˇ 
	histories
ˇˇ 
=
ˇˇ 
await
ˇˇ 
_context
ˇˇ &
.
ˇˇ& '
TicketHistories
ˇˇ' 6
.
ˇˇ6 7
Where
ˇˇ7 <
(
ˇˇ< =
h
ˇˇ= >
=>
ˇˇ? A
h
ˇˇB C
.
ˇˇC D
TicketId
ˇˇD L
==
ˇˇM O
ticketId
ˇˇP X
&&
ˇˇY [
!
ˇˇ\ ]
h
ˇˇ] ^
.
ˇˇ^ _
	IsDeleted
ˇˇ_ h
)
ˇˇh i
.
ˇˇi j
ToListAsync
ˇˇj u
(
ˇˇu v
)
ˇˇv w
;
ˇˇw x
events
ÄÄ 
.
ÄÄ 
AddRange
ÄÄ 
(
ÄÄ 
	histories
ÄÄ !
.
ÄÄ! "
Select
ÄÄ" (
(
ÄÄ( )
h
ÄÄ) *
=>
ÄÄ+ -
new
ÄÄ. 1
TimelineEventDto
ÄÄ2 B
(
ÄÄB C
$str
ÄÄC L
,
ÄÄL M
h
ÄÄN O
.
ÄÄO P
	CreatedAt
ÄÄP Y
,
ÄÄY Z
h
ÄÄ[ \
)
ÄÄ\ ]
)
ÄÄ] ^
)
ÄÄ^ _
;
ÄÄ_ `
var
ÇÇ 
comments
ÇÇ 
=
ÇÇ 
await
ÇÇ 
_context
ÇÇ %
.
ÇÇ% &
TicketComments
ÇÇ& 4
.
ÇÇ4 5
Where
ÇÇ5 :
(
ÇÇ: ;
c
ÇÇ; <
=>
ÇÇ= ?
c
ÇÇ@ A
.
ÇÇA B
TicketId
ÇÇB J
==
ÇÇK M
ticketId
ÇÇN V
&&
ÇÇW Y
!
ÇÇZ [
c
ÇÇ[ \
.
ÇÇ\ ]
	IsDeleted
ÇÇ] f
)
ÇÇf g
.
ÇÇg h
ToListAsync
ÇÇh s
(
ÇÇs t
)
ÇÇt u
;
ÇÇu v
if
ÉÉ 

(
ÉÉ 
!
ÉÉ 
includeInternal
ÉÉ 
)
ÉÉ 
comments
ÉÉ &
=
ÉÉ' (
comments
ÉÉ) 1
.
ÉÉ1 2
Where
ÉÉ2 7
(
ÉÉ7 8
c
ÉÉ8 9
=>
ÉÉ: <
!
ÉÉ= >
c
ÉÉ> ?
.
ÉÉ? @

IsInternal
ÉÉ@ J
)
ÉÉJ K
.
ÉÉK L
ToList
ÉÉL R
(
ÉÉR S
)
ÉÉS T
;
ÉÉT U
events
ÑÑ 
.
ÑÑ 
AddRange
ÑÑ 
(
ÑÑ 
comments
ÑÑ  
.
ÑÑ  !
Select
ÑÑ! '
(
ÑÑ' (
c
ÑÑ( )
=>
ÑÑ* ,
new
ÑÑ- 0
TimelineEventDto
ÑÑ1 A
(
ÑÑA B
$str
ÑÑB K
,
ÑÑK L
c
ÑÑM N
.
ÑÑN O
	CreatedAt
ÑÑO X
,
ÑÑX Y
c
ÑÑZ [
)
ÑÑ[ \
)
ÑÑ\ ]
)
ÑÑ] ^
;
ÑÑ^ _
var
ÜÜ 
attachments
ÜÜ 
=
ÜÜ 
await
ÜÜ 
_context
ÜÜ  (
.
ÜÜ( )
TicketAttachments
ÜÜ) :
.
ÜÜ: ;
Where
ÜÜ; @
(
ÜÜ@ A
a
ÜÜA B
=>
ÜÜC E
a
ÜÜF G
.
ÜÜG H
TicketId
ÜÜH P
==
ÜÜQ S
ticketId
ÜÜT \
&&
ÜÜ] _
!
ÜÜ` a
a
ÜÜa b
.
ÜÜb c
	IsDeleted
ÜÜc l
)
ÜÜl m
.
ÜÜm n
ToListAsync
ÜÜn y
(
ÜÜy z
)
ÜÜz {
;
ÜÜ{ |
events
áá 
.
áá 
AddRange
áá 
(
áá 
attachments
áá #
.
áá# $
Select
áá$ *
(
áá* +
a
áá+ ,
=>
áá- /
new
áá0 3
TimelineEventDto
áá4 D
(
ááD E
$str
ááE Q
,
ááQ R
a
ááS T
.
ááT U
	CreatedAt
ááU ^
,
áá^ _
a
áá` a
)
ááa b
)
ááb c
)
áác d
;
áád e
return
ââ 
events
ââ 
.
ââ 
OrderBy
ââ 
(
ââ 
e
ââ 
=>
ââ  "
e
ââ# $
.
ââ$ %
	Timestamp
ââ% .
)
ââ. /
;
ââ/ 0
}
ää 
public
åå 

async
åå 
Task
åå 
<
åå 
PagedResult
åå !
<
åå! "
	TicketDto
åå" +
>
åå+ ,
>
åå, - 
SearchTicketsAsync
åå. @
(
åå@ A#
TicketSearchFilterDto
ååA V
filter
ååW ]
,
åå] ^
int
åå_ b
userId
ååc i
)
ååi j
{
çç 
var
éé 
perms
éé 
=
éé 
await
éé #
_permissionCalculator
éé /
.
éé/ 00
"CalculateEffectivePermissionsAsync
éé0 R
(
ééR S
userId
ééS Y
)
ééY Z
;
ééZ [
var
êê 
query
êê 
=
êê 
_context
êê 
.
êê 
Tickets
êê $
.
ëë 
Include
ëë 
(
ëë 
t
ëë 
=>
ëë 
t
ëë 
.
ëë 
	TicketSla
ëë %
)
ëë% &
.
íí 
Where
íí 
(
íí 
t
íí 
=>
íí 
!
íí 
t
íí 
.
íí 
	IsDeleted
íí $
)
íí$ %
;
íí% &
query
îî 
=
îî 
await
îî  
ApplySecurityScope
îî (
(
îî( )
query
îî) .
,
îî. /
perms
îî0 5
,
îî5 6
userId
îî7 =
)
îî= >
;
îî> ?
query
ïï 
=
ïï 
ApplyBasicFilters
ïï !
(
ïï! "
query
ïï" '
,
ïï' (
filter
ïï) /
)
ïï/ 0
;
ïï0 1
query
ññ 
=
ññ '
ApplyKeywordAndSlaFilters
ññ )
(
ññ) *
query
ññ* /
,
ññ/ 0
filter
ññ1 7
)
ññ7 8
;
ññ8 9
query
òò 
=
òò 
filter
òò 
.
òò 
SortDescending
òò %
?
ôô 
query
ôô 
.
ôô 
OrderByDescending
ôô %
(
ôô% &
e
ôô& '
=>
ôô( *
EF
ôô+ -
.
ôô- .
Property
ôô. 6
<
ôô6 7
object
ôô7 =
>
ôô= >
(
ôô> ?
e
ôô? @
,
ôô@ A
filter
ôôB H
.
ôôH I
SortBy
ôôI O
??
ôôP R
$str
ôôS ^
)
ôô^ _
)
ôô_ `
:
öö 
query
öö 
.
öö 
OrderBy
öö 
(
öö 
e
öö 
=>
öö  
EF
öö! #
.
öö# $
Property
öö$ ,
<
öö, -
object
öö- 3
>
öö3 4
(
öö4 5
e
öö5 6
,
öö6 7
filter
öö8 >
.
öö> ?
SortBy
öö? E
??
ööF H
$str
ööI T
)
ööT U
)
ööU V
;
ööV W
var
úú 

totalCount
úú 
=
úú 
await
úú 
query
úú $
.
úú$ %

CountAsync
úú% /
(
úú/ 0
)
úú0 1
;
úú1 2
var
ûû 
tickets
ûû 
=
ûû 
await
ûû 
query
ûû !
.
üü 
Skip
üü 
(
üü 
(
üü 
filter
üü 
.
üü 
Page
üü 
-
üü  
$num
üü! "
)
üü" #
*
üü$ %
filter
üü& ,
.
üü, -
PageSize
üü- 5
)
üü5 6
.
†† 
Take
†† 
(
†† 
filter
†† 
.
†† 
PageSize
†† !
)
††! "
.
°° 
Select
°° 
(
°° 
t
°° 
=>
°° 
new
°° 
	TicketDto
°° &
(
°°& '
t
°°' (
.
°°( )
Id
°°) +
,
°°+ ,
t
°°- .
.
°°. /
TicketNumber
°°/ ;
,
°°; <
t
°°= >
.
°°> ?
Title
°°? D
,
°°D E
t
°°F G
.
°°G H
Description
°°H S
,
°°S T
t
°°U V
.
°°V W
	ProjectId
°°W `
,
°°` a
t
°°b c
.
°°c d

CategoryId
°°d n
,
°°n o
t
°°p q
.
°°q r
TypeId
°°r x
,
°°x y
t
°°z {
.
°°{ |
StatusId°°| Ñ
,°°Ñ Ö
t°°Ü á
.°°á à

PriorityId°°à í
,°°í ì
t°°î ï
.°°ï ñ
RequesterUserId°°ñ •
,°°• ¶
t°°ß ®
.°°® ©
AssignedUserId°°© ∑
,°°∑ ∏
t°°π ∫
.°°∫ ª
AssignedGroupId°°ª  
,°°  À
null°°Ã –
)°°– —
)°°— “
.
¢¢ 
ToListAsync
¢¢ 
(
¢¢ 
)
¢¢ 
;
¢¢ 
return
§§ 
new
§§ 
PagedResult
§§ 
<
§§ 
	TicketDto
§§ (
>
§§( )
{
•• 	
Items
¶¶ 
=
¶¶ 
tickets
¶¶ 
,
¶¶ 

TotalCount
ßß 
=
ßß 

totalCount
ßß #
,
ßß# $
Page
®® 
=
®® 
filter
®® 
.
®® 
Page
®® 
,
®® 
PageSize
©© 
=
©© 
filter
©© 
.
©© 
PageSize
©© &
}
™™ 	
;
™™	 

}
´´ 
private
≠≠ 
async
≠≠ 
Task
≠≠ 
<
≠≠ 

IQueryable
≠≠ !
<
≠≠! "
Ticket
≠≠" (
>
≠≠( )
>
≠≠) * 
ApplySecurityScope
≠≠+ =
(
≠≠= >

IQueryable
≠≠> H
<
≠≠H I
Ticket
≠≠I O
>
≠≠O P
query
≠≠Q V
,
≠≠V W
HashSet
≠≠X _
<
≠≠_ `
string
≠≠` f
>
≠≠f g
perms
≠≠h m
,
≠≠m n
int
≠≠o r
userId
≠≠s y
)
≠≠y z
{
ÆÆ 
if
ØØ 

(
ØØ 
!
ØØ 
perms
ØØ 
.
ØØ 
Contains
ØØ 
(
ØØ 
$str
ØØ )
)
ØØ) *
)
ØØ* +
{
∞∞ 	
var
±± 
isAgent
±± 
=
±± 
perms
±± 
.
±±  
Contains
±±  (
(
±±( )
$str
±±) 6
)
±±6 7
||
±±8 :
perms
±±; @
.
±±@ A
Contains
±±A I
(
±±I J
$str
±±J Z
)
±±Z [
||
±±\ ^
perms
±±_ d
.
±±d e
Contains
±±e m
(
±±m n
$str
±±n }
)
±±} ~
;
±±~ 
if
≤≤ 
(
≤≤ 
isAgent
≤≤ 
)
≤≤ 
{
≥≥ 
var
¥¥ 
userGroupIds
¥¥  
=
¥¥! "
await
¥¥# (
_context
¥¥) 1
.
¥¥1 2
GroupMembers
¥¥2 >
.
µµ 
Where
µµ 
(
µµ 
gm
µµ 
=>
µµ  
gm
µµ! #
.
µµ# $
UserId
µµ$ *
==
µµ+ -
userId
µµ. 4
&&
µµ5 7
!
µµ8 9
gm
µµ9 ;
.
µµ; <
	IsDeleted
µµ< E
)
µµE F
.
∂∂ 
Select
∂∂ 
(
∂∂ 
gm
∂∂ 
=>
∂∂ !
gm
∂∂" $
.
∂∂$ %
GroupId
∂∂% ,
)
∂∂, -
.
∑∑ 
ToListAsync
∑∑  
(
∑∑  !
)
∑∑! "
;
∑∑" #
return
ππ 
query
ππ 
.
ππ 
Where
ππ "
(
ππ" #
t
ππ# $
=>
ππ% '
t
ππ( )
.
ππ) *
AssignedUserId
ππ* 8
==
ππ9 ;
userId
ππ< B
||
ππC E
(
∫∫( )
t
∫∫) *
.
∫∫* +
AssignedGroupId
∫∫+ :
.
∫∫: ;
HasValue
∫∫; C
&&
∫∫D F
userGroupIds
∫∫G S
.
∫∫S T
Contains
∫∫T \
(
∫∫\ ]
t
∫∫] ^
.
∫∫^ _
AssignedGroupId
∫∫_ n
.
∫∫n o
Value
∫∫o t
)
∫∫t u
)
∫∫u v
||
∫∫w y
t
ªª( )
.
ªª) *
RequesterUserId
ªª* 9
==
ªª: <
userId
ªª= C
)
ªªC D
;
ªªD E
}
ºº 
return
ΩΩ 
query
ΩΩ 
.
ΩΩ 
Where
ΩΩ 
(
ΩΩ 
t
ΩΩ  
=>
ΩΩ! #
t
ΩΩ$ %
.
ΩΩ% &
RequesterUserId
ΩΩ& 5
==
ΩΩ6 8
userId
ΩΩ9 ?
)
ΩΩ? @
;
ΩΩ@ A
}
ææ 	
return
øø 
query
øø 
;
øø 
}
¿¿ 
private
¬¬ 
static
¬¬ 

IQueryable
¬¬ 
<
¬¬ 
Ticket
¬¬ $
>
¬¬$ %
ApplyBasicFilters
¬¬& 7
(
¬¬7 8

IQueryable
¬¬8 B
<
¬¬B C
Ticket
¬¬C I
>
¬¬I J
query
¬¬K P
,
¬¬P Q#
TicketSearchFilterDto
¬¬R g
filter
¬¬h n
)
¬¬n o
{
√√ 
if
ƒƒ 

(
ƒƒ 
filter
ƒƒ 
.
ƒƒ 
	ProjectId
ƒƒ 
.
ƒƒ 
HasValue
ƒƒ %
)
ƒƒ% &
query
ƒƒ' ,
=
ƒƒ- .
query
ƒƒ/ 4
.
ƒƒ4 5
Where
ƒƒ5 :
(
ƒƒ: ;
t
ƒƒ; <
=>
ƒƒ= ?
t
ƒƒ@ A
.
ƒƒA B
	ProjectId
ƒƒB K
==
ƒƒL N
filter
ƒƒO U
.
ƒƒU V
	ProjectId
ƒƒV _
.
ƒƒ_ `
Value
ƒƒ` e
)
ƒƒe f
;
ƒƒf g
if
≈≈ 

(
≈≈ 
filter
≈≈ 
.
≈≈ 

CategoryId
≈≈ 
.
≈≈ 
HasValue
≈≈ &
)
≈≈& '
query
≈≈( -
=
≈≈. /
query
≈≈0 5
.
≈≈5 6
Where
≈≈6 ;
(
≈≈; <
t
≈≈< =
=>
≈≈> @
t
≈≈A B
.
≈≈B C

CategoryId
≈≈C M
==
≈≈N P
filter
≈≈Q W
.
≈≈W X

CategoryId
≈≈X b
.
≈≈b c
Value
≈≈c h
)
≈≈h i
;
≈≈i j
if
∆∆ 

(
∆∆ 
filter
∆∆ 
.
∆∆ 
TypeId
∆∆ 
.
∆∆ 
HasValue
∆∆ "
)
∆∆" #
query
∆∆$ )
=
∆∆* +
query
∆∆, 1
.
∆∆1 2
Where
∆∆2 7
(
∆∆7 8
t
∆∆8 9
=>
∆∆: <
t
∆∆= >
.
∆∆> ?
TypeId
∆∆? E
==
∆∆F H
filter
∆∆I O
.
∆∆O P
TypeId
∆∆P V
.
∆∆V W
Value
∆∆W \
)
∆∆\ ]
;
∆∆] ^
if
«« 

(
«« 
filter
«« 
.
«« 
StatusId
«« 
.
«« 
HasValue
«« $
)
««$ %
query
««& +
=
««, -
query
««. 3
.
««3 4
Where
««4 9
(
««9 :
t
««: ;
=>
««< >
t
««? @
.
««@ A
StatusId
««A I
==
««J L
filter
««M S
.
««S T
StatusId
««T \
.
««\ ]
Value
««] b
)
««b c
;
««c d
if
»» 

(
»» 
filter
»» 
.
»» 
ExcludeStatusId
»» "
.
»»" #
HasValue
»»# +
)
»»+ ,
query
»»- 2
=
»»3 4
query
»»5 :
.
»»: ;
Where
»»; @
(
»»@ A
t
»»A B
=>
»»C E
t
»»F G
.
»»G H
StatusId
»»H P
!=
»»Q S
filter
»»T Z
.
»»Z [
ExcludeStatusId
»»[ j
.
»»j k
Value
»»k p
)
»»p q
;
»»q r
if
…… 

(
…… 
filter
…… 
.
…… 

PriorityId
…… 
.
…… 
HasValue
…… &
)
……& '
query
……( -
=
……. /
query
……0 5
.
……5 6
Where
……6 ;
(
……; <
t
……< =
=>
……> @
t
……A B
.
……B C

PriorityId
……C M
==
……N P
filter
……Q W
.
……W X

PriorityId
……X b
.
……b c
Value
……c h
)
……h i
;
……i j
if
   

(
   
filter
   
.
   
AssigneeUserId
   !
.
  ! "
HasValue
  " *
)
  * +
query
  , 1
=
  2 3
query
  4 9
.
  9 :
Where
  : ?
(
  ? @
t
  @ A
=>
  B D
t
  E F
.
  F G
AssignedUserId
  G U
==
  V X
filter
  Y _
.
  _ `
AssigneeUserId
  ` n
.
  n o
Value
  o t
)
  t u
;
  u v
if
ÀÀ 

(
ÀÀ 
filter
ÀÀ 
.
ÀÀ 

Unassigned
ÀÀ 
==
ÀÀ  
true
ÀÀ! %
)
ÀÀ% &
query
ÀÀ' ,
=
ÀÀ- .
query
ÀÀ/ 4
.
ÀÀ4 5
Where
ÀÀ5 :
(
ÀÀ: ;
t
ÀÀ; <
=>
ÀÀ= ?
t
ÀÀ@ A
.
ÀÀA B
AssignedUserId
ÀÀB P
==
ÀÀQ S
null
ÀÀT X
)
ÀÀX Y
;
ÀÀY Z
if
ÃÃ 

(
ÃÃ 
filter
ÃÃ 
.
ÃÃ 
RequesterUserId
ÃÃ "
.
ÃÃ" #
HasValue
ÃÃ# +
)
ÃÃ+ ,
query
ÃÃ- 2
=
ÃÃ3 4
query
ÃÃ5 :
.
ÃÃ: ;
Where
ÃÃ; @
(
ÃÃ@ A
t
ÃÃA B
=>
ÃÃC E
t
ÃÃF G
.
ÃÃG H
RequesterUserId
ÃÃH W
==
ÃÃX Z
filter
ÃÃ[ a
.
ÃÃa b
RequesterUserId
ÃÃb q
.
ÃÃq r
Value
ÃÃr w
)
ÃÃw x
;
ÃÃx y
if
ÕÕ 

(
ÕÕ 
filter
ÕÕ 
.
ÕÕ 
FromDate
ÕÕ 
.
ÕÕ 
HasValue
ÕÕ $
)
ÕÕ$ %
query
ÕÕ& +
=
ÕÕ, -
query
ÕÕ. 3
.
ÕÕ3 4
Where
ÕÕ4 9
(
ÕÕ9 :
t
ÕÕ: ;
=>
ÕÕ< >
t
ÕÕ? @
.
ÕÕ@ A
	CreatedAt
ÕÕA J
>=
ÕÕK M
filter
ÕÕN T
.
ÕÕT U
FromDate
ÕÕU ]
.
ÕÕ] ^
Value
ÕÕ^ c
)
ÕÕc d
;
ÕÕd e
if
ŒŒ 

(
ŒŒ 
filter
ŒŒ 
.
ŒŒ 
ToDate
ŒŒ 
.
ŒŒ 
HasValue
ŒŒ "
)
ŒŒ" #
query
ŒŒ$ )
=
ŒŒ* +
query
ŒŒ, 1
.
ŒŒ1 2
Where
ŒŒ2 7
(
ŒŒ7 8
t
ŒŒ8 9
=>
ŒŒ: <
t
ŒŒ= >
.
ŒŒ> ?
	CreatedAt
ŒŒ? H
<=
ŒŒI K
filter
ŒŒL R
.
ŒŒR S
ToDate
ŒŒS Y
.
ŒŒY Z
Value
ŒŒZ _
)
ŒŒ_ `
;
ŒŒ` a
return
œœ 
query
œœ 
;
œœ 
}
–– 
private
““ 
static
““ 

IQueryable
““ 
<
““ 
Ticket
““ $
>
““$ %'
ApplyKeywordAndSlaFilters
““& ?
(
““? @

IQueryable
““@ J
<
““J K
Ticket
““K Q
>
““Q R
query
““S X
,
““X Y#
TicketSearchFilterDto
““Z o
filter
““p v
)
““v w
{
”” 
if
‘‘ 

(
‘‘ 
!
‘‘ 
string
‘‘ 
.
‘‘  
IsNullOrWhiteSpace
‘‘ &
(
‘‘& '
filter
‘‘' -
.
‘‘- .
Keyword
‘‘. 5
)
‘‘5 6
)
‘‘6 7
{
’’ 	
var
÷÷ 
kw
÷÷ 
=
÷÷ 
filter
÷÷ 
.
÷÷ 
Keyword
÷÷ #
;
÷÷# $
query
◊◊ 
=
◊◊ 
query
◊◊ 
.
◊◊ 
Where
◊◊ 
(
◊◊  
t
◊◊  !
=>
◊◊" $
t
ÿÿ 
.
ÿÿ 
TicketNumber
ÿÿ 
.
ÿÿ 
Contains
ÿÿ '
(
ÿÿ' (
kw
ÿÿ( *
,
ÿÿ* +
StringComparison
ÿÿ, <
.
ÿÿ< =
OrdinalIgnoreCase
ÿÿ= N
)
ÿÿN O
||
ÿÿP R
t
ŸŸ 
.
ŸŸ 
Title
ŸŸ 
.
ŸŸ 
Contains
ŸŸ  
(
ŸŸ  !
kw
ŸŸ! #
,
ŸŸ# $
StringComparison
ŸŸ% 5
.
ŸŸ5 6
OrdinalIgnoreCase
ŸŸ6 G
)
ŸŸG H
||
ŸŸI K
t
⁄⁄ 
.
⁄⁄ 
Description
⁄⁄ 
.
⁄⁄ 
Contains
⁄⁄ &
(
⁄⁄& '
kw
⁄⁄' )
,
⁄⁄) *
StringComparison
⁄⁄+ ;
.
⁄⁄; <
OrdinalIgnoreCase
⁄⁄< M
)
⁄⁄M N
)
⁄⁄N O
;
⁄⁄O P
}
€€ 	
if
›› 

(
›› 
!
›› 
string
›› 
.
››  
IsNullOrWhiteSpace
›› &
(
››& '
filter
››' -
.
››- .
	SlaStatus
››. 7
)
››7 8
)
››8 9
{
ﬁﬁ 	
var
ﬂﬂ 
s
ﬂﬂ 
=
ﬂﬂ 
filter
ﬂﬂ 
.
ﬂﬂ 
	SlaStatus
ﬂﬂ $
.
ﬂﬂ$ %
ToLower
ﬂﬂ% ,
(
ﬂﬂ, -
)
ﬂﬂ- .
;
ﬂﬂ. /
if
‡‡ 
(
‡‡ 
s
‡‡ 
==
‡‡ 
$str
‡‡ 
)
‡‡  
query
·· 
=
·· 
query
·· 
.
·· 
Where
·· #
(
··# $
t
··$ %
=>
··& (
t
··) *
.
··* +
	TicketSla
··+ 4
!=
··5 7
null
··8 <
&&
··= ?
(
··@ A
t
··A B
.
··B C
	TicketSla
··C L
.
··L M#
FirstResponseBreached
··M b
||
··c e
t
··f g
.
··g h
	TicketSla
··h q
.
··q r!
ResolutionBreached··r Ñ
)··Ñ Ö
)··Ö Ü
;··Ü á
else
‚‚ 
if
‚‚ 
(
‚‚ 
s
‚‚ 
==
‚‚ 
$str
‚‚ #
)
‚‚# $
query
„„ 
=
„„ 
query
„„ 
.
„„ 
Where
„„ #
(
„„# $
t
„„$ %
=>
„„& (
t
„„) *
.
„„* +
	TicketSla
„„+ 4
!=
„„5 7
null
„„8 <
&&
„„= ?
(
„„@ A
t
„„A B
.
„„B C
	TicketSla
„„C L
.
„„L M!
FirstResponseWarned
„„M `
||
„„a c
t
„„d e
.
„„e f
	TicketSla
„„f o
.
„„o p
ResolutionWarned„„p Ä
)„„Ä Å
&&„„Ç Ñ
!„„Ö Ü
(„„Ü á
t„„á à
.„„à â
	TicketSla„„â í
.„„í ì%
FirstResponseBreached„„ì ®
||„„© ´
t„„¨ ≠
.„„≠ Æ
	TicketSla„„Æ ∑
.„„∑ ∏"
ResolutionBreached„„∏  
)„„  À
)„„À Ã
;„„Ã Õ
else
‰‰ 
if
‰‰ 
(
‰‰ 
s
‰‰ 
==
‰‰ 
$str
‰‰ #
)
‰‰# $
query
ÂÂ 
=
ÂÂ 
query
ÂÂ 
.
ÂÂ 
Where
ÂÂ #
(
ÂÂ# $
t
ÂÂ$ %
=>
ÂÂ& (
t
ÂÂ) *
.
ÂÂ* +
	TicketSla
ÂÂ+ 4
!=
ÂÂ5 7
null
ÂÂ8 <
&&
ÂÂ= ?
!
ÂÂ@ A
t
ÂÂA B
.
ÂÂB C
	TicketSla
ÂÂC L
.
ÂÂL M!
FirstResponseWarned
ÂÂM `
&&
ÂÂa c
!
ÂÂd e
t
ÂÂe f
.
ÂÂf g
	TicketSla
ÂÂg p
.
ÂÂp q
ResolutionWarnedÂÂq Å
&&ÂÂÇ Ñ
!ÂÂÖ Ü
tÂÂÜ á
.ÂÂá à
	TicketSlaÂÂà ë
.ÂÂë í%
FirstResponseBreachedÂÂí ß
&&ÂÂ® ™
!ÂÂ´ ¨
tÂÂ¨ ≠
.ÂÂ≠ Æ
	TicketSlaÂÂÆ ∑
.ÂÂ∑ ∏"
ResolutionBreachedÂÂ∏  
)ÂÂ  À
;ÂÂÀ Ã
}
ÊÊ 	
return
ÁÁ 
query
ÁÁ 
;
ÁÁ 
}
ËË 
public
ÍÍ 

async
ÍÍ 
Task
ÍÍ 
<
ÍÍ 
TicketSurveyDto
ÍÍ %
>
ÍÍ% &
SubmitSurveyAsync
ÍÍ' 8
(
ÍÍ8 9
int
ÍÍ9 <
ticketId
ÍÍ= E
,
ÍÍE F#
SubmitTicketSurveyDto
ÍÍG \
dto
ÍÍ] `
,
ÍÍ` a
int
ÍÍb e
userId
ÍÍf l
)
ÍÍl m
{
ÎÎ 
var
ÏÏ 
ticket
ÏÏ 
=
ÏÏ 
await
ÏÏ 
_context
ÏÏ #
.
ÏÏ# $
Tickets
ÏÏ$ +
.
ÏÏ+ ,!
FirstOrDefaultAsync
ÏÏ, ?
(
ÏÏ? @
t
ÏÏ@ A
=>
ÏÏB D
t
ÏÏE F
.
ÏÏF G
Id
ÏÏG I
==
ÏÏJ L
ticketId
ÏÏM U
&&
ÏÏV X
!
ÏÏY Z
t
ÏÏZ [
.
ÏÏ[ \
	IsDeleted
ÏÏ\ e
)
ÏÏe f
;
ÏÏf g
if
ÌÌ 

(
ÌÌ 
ticket
ÌÌ 
==
ÌÌ 
null
ÌÌ 
)
ÌÌ 
throw
ÌÌ !
new
ÌÌ" %"
KeyNotFoundException
ÌÌ& :
(
ÌÌ: ;
$str
ÌÌ; M
)
ÌÌM N
;
ÌÌN O
if
ÔÔ 

(
ÔÔ 
ticket
ÔÔ 
.
ÔÔ 
RequesterUserId
ÔÔ "
!=
ÔÔ# %
userId
ÔÔ& ,
)
ÔÔ, -
throw
 
new
 )
UnauthorizedAccessException
 1
(
1 2
$str
2 j
)
j k
;
k l
if
ÛÛ 

(
ÛÛ 
ticket
ÛÛ 
.
ÛÛ 
StatusId
ÛÛ 
!=
ÛÛ 
$num
ÛÛ  
)
ÛÛ  !
throw
ÙÙ 
new
ÙÙ '
InvalidOperationException
ÙÙ /
(
ÙÙ/ 0
$str
ÙÙ0 b
)
ÙÙb c
;
ÙÙc d
var
ˆˆ 
existingSurvey
ˆˆ 
=
ˆˆ 
await
ˆˆ "
_context
ˆˆ# +
.
ˆˆ+ ,
TicketSurveys
ˆˆ, 9
.
ˆˆ9 :
AnyAsync
ˆˆ: B
(
ˆˆB C
s
ˆˆC D
=>
ˆˆE G
s
ˆˆH I
.
ˆˆI J
TicketId
ˆˆJ R
==
ˆˆS U
ticketId
ˆˆV ^
)
ˆˆ^ _
;
ˆˆ_ `
if
˜˜ 

(
˜˜ 
existingSurvey
˜˜ 
)
˜˜ 
throw
¯¯ 
new
¯¯ '
InvalidOperationException
¯¯ /
(
¯¯/ 0
$str
¯¯0 e
)
¯¯e f
;
¯¯f g
if
˙˙ 

(
˙˙ 
dto
˙˙ 
.
˙˙ 
Rating
˙˙ 
<
˙˙ 
$num
˙˙ 
||
˙˙ 
dto
˙˙ !
.
˙˙! "
Rating
˙˙" (
>
˙˙) *
$num
˙˙+ ,
)
˙˙, -
throw
˚˚ 
new
˚˚ '
InvalidOperationException
˚˚ /
(
˚˚/ 0
$str
˚˚0 P
)
˚˚P Q
;
˚˚Q R
var
˝˝ 
survey
˝˝ 
=
˝˝ 
new
˝˝ 
TicketSurvey
˝˝ %
{
˛˛ 	
TicketId
ˇˇ 
=
ˇˇ 
ticketId
ˇˇ 
,
ˇˇ  
Rating
ÄÄ 
=
ÄÄ 
dto
ÄÄ 
.
ÄÄ 
Rating
ÄÄ 
,
ÄÄ  
Comment
ÅÅ 
=
ÅÅ 
dto
ÅÅ 
.
ÅÅ 
Comment
ÅÅ !
}
ÇÇ 	
;
ÇÇ	 

_context
ÑÑ 
.
ÑÑ 
TicketSurveys
ÑÑ 
.
ÑÑ 
Add
ÑÑ "
(
ÑÑ" #
survey
ÑÑ# )
)
ÑÑ) *
;
ÑÑ* +
await
ÖÖ 
_context
ÖÖ 
.
ÖÖ 
SaveChangesAsync
ÖÖ '
(
ÖÖ' (
)
ÖÖ( )
;
ÖÖ) *
return
áá 
new
áá 
TicketSurveyDto
áá "
(
áá" #
survey
áá# )
.
áá) *
Id
áá* ,
,
áá, -
survey
áá. 4
.
áá4 5
TicketId
áá5 =
,
áá= >
survey
áá? E
.
ááE F
Rating
ááF L
,
ááL M
survey
ááN T
.
ááT U
Comment
ááU \
,
áá\ ]
survey
áá^ d
.
áád e
SubmittedAt
ááe p
)
ááp q
;
ááq r
}
àà 
}ââ ∆
f/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/SystemAuditService.cs
	namespace		 	
ItsTool		
 
.		 
Infrastructure		  
.		  !
Services		! )
;		) *
public 
class 
SystemAuditService 
:  !
ISystemAuditService" 5
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly  
IHttpContextAccessor ) 
_httpContextAccessor* >
;> ?
public 

SystemAuditService 
( 
ItsToolDbContext .
context/ 6
,6 7 
IHttpContextAccessor8 L
httpContextAccessorM `
)` a
{ 
_context 
= 
context 
;  
_httpContextAccessor 
= 
httpContextAccessor 2
;2 3
} 
public 

async 
Task 
LogAuditAsync #
(# $
string$ *

entityName+ 5
,5 6
string7 =
entityId> F
,F G
stringH N
actionO U
,U V
stringW ]
?] ^
	fieldName_ h
=i j
nullk o
,o p
stringq w
?w x
oldValue	y Å
=
Ç É
null
Ñ à
,
à â
string
ä ê
?
ê ë
newValue
í ö
=
õ ú
null
ù °
)
° ¢
{ 
var 
	userIdStr 
=  
_httpContextAccessor ,
., -
HttpContext- 8
?8 9
.9 :
User: >
?> ?
.? @
	FindFirst@ I
(I J

ClaimTypesJ T
.T U
NameIdentifierU c
)c d
?d e
.e f
Valuef k
??l n
$stro w
;w x
var 
log 
= 
new 
SystemAuditLog $
{ 	

EntityName 
= 

entityName #
,# $
EntityId 
= 
entityId 
,  
Action 
= 
action 
, 
	FieldName 
= 
	fieldName !
,! "
OldValue   
=   
oldValue   
,    
NewValue!! 
=!! 
newValue!! 
,!!  
	CreatedBy"" 
="" 
	userIdStr"" !
,""! "
	CreatedAt## 
=## 
DateTime##  
.##  !
UtcNow##! '
}$$ 	
;$$	 

_context&& 
.&& 
SystemAuditLogs&&  
.&&  !
Add&&! $
(&&$ %
log&&% (
)&&( )
;&&) *
await'' 
_context'' 
.'' 
SaveChangesAsync'' '
(''' (
)''( )
;'') *
}(( 
})) π	
d/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/StubEmailService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 
StubEmailService 
: 
IEmailService  -
{ 
public		 

Task		 
SendEmailAsync		 
(		 
string		 %
to		& (
,		( )
string		* 0
subject		1 8
,		8 9
string		: @
body		A E
)		E F
{

 
Console 
. 
	WriteLine 
( 
$" 
$str -
{- .
to. 0
}0 1
$str1 <
{< =
subject= D
}D E
"E F
)F G
;G H
Console 
. 
	WriteLine 
( 
$" 
$str /
{/ 0
body0 4
}4 5
"5 6
)6 7
;7 8
return 
Task 
. 
CompletedTask !
;! "
} 
} Ô)
d/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/SmtpEmailService.cs
	namespace		 	
ItsTool		
 
.		 
Infrastructure		  
.		  !
Services		! )
;		) *
public 
class 
SmtpEmailService 
: 
IEmailService  -
{ 
private 
readonly 
IConfiguration #
_config$ +
;+ ,
private 
readonly 
ILogger 
< 
SmtpEmailService -
>- .
_logger/ 6
;6 7
public 

SmtpEmailService 
( 
IConfiguration *
config+ 1
,1 2
ILogger3 :
<: ;
SmtpEmailService; K
>K L
loggerM S
)S T
{ 
_config 
= 
config 
; 
_logger 
= 
logger 
; 
} 
public 

async 
Task 
SendEmailAsync $
($ %
string% +
to, .
,. /
string0 6
subject7 >
,> ?
string@ F
bodyG K
)K L
{ 
var 
host 
= 
_config 
[ 
$str &
]& '
;' (
var 
portStr 
= 
_config 
[ 
$str )
]) *
;* +
var 
user 
= 
_config 
[ 
$str *
]* +
;+ ,
var 
pass 
= 
_config 
[ 
$str *
]* +
;+ ,
if 

( 
string 
. 
IsNullOrEmpty  
(  !
host! %
)% &
||' )
string* 0
.0 1
IsNullOrEmpty1 >
(> ?
portStr? F
)F G
)G H
{ 	
_logger 
. 

LogWarning 
( 
$str S
,S T
toU W
)W X
;X Y
return   
;   
}!! 	
try## 
{$$ 	
var%% 
message%% 
=%% 
new%% 
MimeMessage%% )
(%%) *
)%%* +
;%%+ ,
message&& 
.&& 
From&& 
.&& 
Add&& 
(&& 
new&&  
MailboxAddress&&! /
(&&/ 0
$str&&0 ;
,&&; <
user&&= A
??&&B D
$str&&E Y
)&&Y Z
)&&Z [
;&&[ \
message'' 
.'' 
To'' 
.'' 
Add'' 
('' 
new'' 
MailboxAddress'' -
(''- .
$str''. 0
,''0 1
to''2 4
)''4 5
)''5 6
;''6 7
message(( 
.(( 
Subject(( 
=(( 
subject(( %
;((% &
message** 
.** 
Body** 
=** 
new** 
TextPart** '
(**' (
$str**( .
)**. /
{++ 
Text,, 
=,, 
body,, 
}-- 
;-- 
using// 
var// 
client// 
=// 
new// "

SmtpClient//# -
(//- .
)//. /
;/// 0
await00 
client00 
.00 
ConnectAsync00 %
(00% &
host00& *
,00* +
int00, /
.00/ 0
Parse000 5
(005 6
portStr006 =
)00= >
,00> ?
MailKit00@ G
.00G H
Security00H P
.00P Q
SecureSocketOptions00Q d
.00d e
Auto00e i
)00i j
;00j k
if22 
(22 
!22 
string22 
.22 
IsNullOrEmpty22 %
(22% &
user22& *
)22* +
&&22, .
!22/ 0
string220 6
.226 7
IsNullOrEmpty227 D
(22D E
pass22E I
)22I J
)22J K
{33 
await44 
client44 
.44 
AuthenticateAsync44 .
(44. /
user44/ 3
,443 4
pass445 9
)449 :
;44: ;
}55 
await77 
client77 
.77 
	SendAsync77 "
(77" #
message77# *
)77* +
;77+ ,
await88 
client88 
.88 
DisconnectAsync88 (
(88( )
true88) -
)88- .
;88. /
_logger99 
.99 
LogInformation99 "
(99" #
$str99# N
,99N O
to99P R
,99R S
subject99T [
)99[ \
;99\ ]
}:: 	
catch;; 
(;; 
	Exception;; 
ex;; 
);; 
{<< 	
_logger== 
.== 
LogError== 
(== 
ex== 
,==  
$str==! ?
,==? @
to==A C
)==C D
;==D E
}>> 	
}?? 
}@@ âd
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/SlaService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 

SlaService 
: 
ISlaService %
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
const 
string 
PolicyNotFound '
=( )
$str* A
;A B
private 
const 
string 
TargetNotFound '
=( )
$str* A
;A B
public 


SlaService 
( 
ItsToolDbContext &
context' .
). /
{ 
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
IEnumerable !
<! "
SlaPolicyDto" .
>. /
>/ 0
GetPoliciesAsync1 A
(A B
intB E
?E F
	projectIdG P
=Q R
nullS W
)W X
{ 
var 
list 
= 
await 
_context !
.! "
SlaPolicies" -
. 
Where 
( 
p 
=> 
! 
p 
. 
	IsDeleted $
&&% '
(( )
	projectId) 2
==3 5
null6 :
||; =
p> ?
.? @
	ProjectId@ I
==J L
	projectIdM V
)V W
)W X
. 
ToListAsync 
( 
) 
; 
return 
list 
. 
Select 
( 
p 
=> 
new  #
SlaPolicyDto$ 0
(0 1
p1 2
.2 3
Id3 5
,5 6
p7 8
.8 9
Name9 =
,= >
p? @
.@ A
DescriptionA L
,L M
pN O
.O P
	ProjectIdP Y
,Y Z
p[ \
.\ ]
IsActive] e
)e f
)f g
;g h
} 
public!! 

async!! 
Task!! 
<!! 
SlaPolicyDto!! "
>!!" #
CreatePolicyAsync!!$ 5
(!!5 6
CreateSlaPolicyDto!!6 H
dto!!I L
)!!L M
{"" 
var## 
policy## 
=## 
new## 
	SlaPolicy## "
{$$ 	
Name%% 
=%% 
dto%% 
.%% 
Name%% 
,%% 
Description&& 
=&& 
dto&& 
.&& 
Description&& )
,&&) *
	ProjectId'' 
='' 
dto'' 
.'' 
	ProjectId'' %
}(( 	
;((	 

_context)) 
.)) 
SlaPolicies)) 
.)) 
Add))  
())  !
policy))! '
)))' (
;))( )
await** 
_context** 
.** 
SaveChangesAsync** '
(**' (
)**( )
;**) *
return++ 
new++ 
SlaPolicyDto++ 
(++  
policy++  &
.++& '
Id++' )
,++) *
policy+++ 1
.++1 2
Name++2 6
,++6 7
policy++8 >
.++> ?
Description++? J
,++J K
policy++L R
.++R S
	ProjectId++S \
,++\ ]
policy++^ d
.++d e
IsActive++e m
)++m n
;++n o
},, 
public.. 

async.. 
Task.. 
UpdatePolicyAsync.. '
(..' (
int..( +
id.., .
,... /
UpdateSlaPolicyDto..0 B
dto..C F
)..F G
{// 
var00 
policy00 
=00 
await00 
_context00 #
.00# $
SlaPolicies00$ /
.00/ 0
FirstOrDefaultAsync000 C
(00C D
p00D E
=>00F H
p00I J
.00J K
Id00K M
==00N P
id00Q S
&&00T V
!00W X
p00X Y
.00Y Z
	IsDeleted00Z c
)00c d
;00d e
if11 

(11 
policy11 
==11 
null11 
)11 
throw11 !
new11" % 
KeyNotFoundException11& :
(11: ;
PolicyNotFound11; I
)11I J
;11J K
policy33 
.33 
Name33 
=33 
dto33 
.33 
Name33 
;33 
policy44 
.44 
Description44 
=44 
dto44  
.44  !
Description44! ,
;44, -
policy55 
.55 
	ProjectId55 
=55 
dto55 
.55 
	ProjectId55 (
;55( )
policy66 
.66 
IsActive66 
=66 
dto66 
.66 
IsActive66 &
;66& '
await77 
_context77 
.77 
SaveChangesAsync77 '
(77' (
)77( )
;77) *
}88 
public:: 

async:: 
Task:: 
DeletePolicyAsync:: '
(::' (
int::( +
id::, .
)::. /
{;; 
var<< 
policy<< 
=<< 
await<< 
_context<< #
.<<# $
SlaPolicies<<$ /
.<</ 0
FirstOrDefaultAsync<<0 C
(<<C D
p<<D E
=><<F H
p<<I J
.<<J K
Id<<K M
==<<N P
id<<Q S
&&<<T V
!<<W X
p<<X Y
.<<Y Z
	IsDeleted<<Z c
)<<c d
;<<d e
if== 

(== 
policy== 
!=== 
null== 
)== 
{>> 	
policy?? 
.?? 
	IsDeleted?? 
=?? 
true?? #
;??# $
policy@@ 
.@@ 
IsActive@@ 
=@@ 
false@@ #
;@@# $
awaitAA 
_contextAA 
.AA 
SaveChangesAsyncAA +
(AA+ ,
)AA, -
;AA- .
}BB 	
}CC 
publicEE 

asyncEE 
TaskEE 
<EE 
IEnumerableEE !
<EE! "
SlaTargetDtoEE" .
>EE. /
>EE/ 0
GetTargetsAsyncEE1 @
(EE@ A
intEEA D
policyIdEEE M
)EEM N
{FF 
varGG 
listGG 
=GG 
awaitGG 
_contextGG !
.GG! "

SlaTargetsGG" ,
.HH 
WhereHH 
(HH 
tHH 
=>HH 
tHH 
.HH 
SlaPolicyIdHH %
==HH& (
policyIdHH) 1
&&HH2 4
!HH5 6
tHH6 7
.HH7 8
	IsDeletedHH8 A
)HHA B
.II 
ToListAsyncII 
(II 
)II 
;II 
returnKK 
listKK 
.KK 
SelectKK 
(KK 
tKK 
=>KK 
newKK  #
SlaTargetDtoKK$ 0
(KK0 1
tKK1 2
.KK2 3
IdKK3 5
,KK5 6
tKK7 8
.KK8 9
SlaPolicyIdKK9 D
,KKD E
tKKF G
.KKG H

PriorityIdKKH R
,KKR S
tKKT U
.KKU V
TicketTypeIdKKV b
,KKb c
tKKd e
.KKe f 
FirstResponseMinutesKKf z
,KKz {
tKK| }
.KK} ~
ResolutionMinutes	KK~ è
,
KKè ê
t
KKë í
.
KKí ì
IsActive
KKì õ
)
KKõ ú
)
KKú ù
;
KKù û
}LL 
publicNN 

asyncNN 
TaskNN 
<NN 
SlaTargetDtoNN "
>NN" #
CreateTargetAsyncNN$ 5
(NN5 6
CreateSlaTargetDtoNN6 H
dtoNNI L
)NNL M
{OO 
varPP 
targetPP 
=PP 
newPP 
	SlaTargetPP "
{QQ 	
SlaPolicyIdRR 
=RR 
dtoRR 
.RR 
SlaPolicyIdRR )
,RR) *

PriorityIdSS 
=SS 
dtoSS 
.SS 

PriorityIdSS '
,SS' (
TicketTypeIdTT 
=TT 
dtoTT 
.TT 
TicketTypeIdTT +
,TT+ , 
FirstResponseMinutesUU  
=UU! "
dtoUU# &
.UU& ' 
FirstResponseMinutesUU' ;
,UU; <
ResolutionMinutesVV 
=VV 
dtoVV  #
.VV# $
ResolutionMinutesVV$ 5
}WW 	
;WW	 

_contextXX 
.XX 

SlaTargetsXX 
.XX 
AddXX 
(XX  
targetXX  &
)XX& '
;XX' (
awaitYY 
_contextYY 
.YY 
SaveChangesAsyncYY '
(YY' (
)YY( )
;YY) *
returnZZ 
newZZ 
SlaTargetDtoZZ 
(ZZ  
targetZZ  &
.ZZ& '
IdZZ' )
,ZZ) *
targetZZ+ 1
.ZZ1 2
SlaPolicyIdZZ2 =
,ZZ= >
targetZZ? E
.ZZE F

PriorityIdZZF P
,ZZP Q
targetZZR X
.ZZX Y
TicketTypeIdZZY e
,ZZe f
targetZZg m
.ZZm n!
FirstResponseMinutes	ZZn Ç
,
ZZÇ É
target
ZZÑ ä
.
ZZä ã
ResolutionMinutes
ZZã ú
,
ZZú ù
target
ZZû §
.
ZZ§ •
IsActive
ZZ• ≠
)
ZZ≠ Æ
;
ZZÆ Ø
}[[ 
public]] 

async]] 
Task]] 
UpdateTargetAsync]] '
(]]' (
int]]( +
id]], .
,]]. /
UpdateSlaTargetDto]]0 B
dto]]C F
)]]F G
{^^ 
var__ 
target__ 
=__ 
await__ 
_context__ #
.__# $

SlaTargets__$ .
.__. /
FirstOrDefaultAsync__/ B
(__B C
t__C D
=>__E G
t__H I
.__I J
Id__J L
==__M O
id__P R
&&__S U
!__V W
t__W X
.__X Y
	IsDeleted__Y b
)__b c
;__c d
if`` 

(`` 
target`` 
==`` 
null`` 
)`` 
throw`` !
new``" % 
KeyNotFoundException``& :
(``: ;
TargetNotFound``; I
)``I J
;``J K
targetbb 
.bb 

PriorityIdbb 
=bb 
dtobb 
.bb  

PriorityIdbb  *
;bb* +
targetcc 
.cc 
TicketTypeIdcc 
=cc 
dtocc !
.cc! "
TicketTypeIdcc" .
;cc. /
targetdd 
.dd  
FirstResponseMinutesdd #
=dd$ %
dtodd& )
.dd) * 
FirstResponseMinutesdd* >
;dd> ?
targetee 
.ee 
ResolutionMinutesee  
=ee! "
dtoee# &
.ee& '
ResolutionMinutesee' 8
;ee8 9
targetff 
.ff 
IsActiveff 
=ff 
dtoff 
.ff 
IsActiveff &
;ff& '
awaitgg 
_contextgg 
.gg 
SaveChangesAsyncgg '
(gg' (
)gg( )
;gg) *
}hh 
publicjj 

asyncjj 
Taskjj 
DeleteTargetAsyncjj '
(jj' (
intjj( +
idjj, .
)jj. /
{kk 
varll 
targetll 
=ll 
awaitll 
_contextll #
.ll# $

SlaTargetsll$ .
.ll. /
FirstOrDefaultAsyncll/ B
(llB C
tllC D
=>llE G
tllH I
.llI J
IdllJ L
==llM O
idllP R
&&llS U
!llV W
tllW X
.llX Y
	IsDeletedllY b
)llb c
;llc d
ifmm 

(mm 
targetmm 
!=mm 
nullmm 
)mm 
{nn 	
targetoo 
.oo 
	IsDeletedoo 
=oo 
trueoo #
;oo# $
targetpp 
.pp 
IsActivepp 
=pp 
falsepp #
;pp# $
awaitqq 
_contextqq 
.qq 
SaveChangesAsyncqq +
(qq+ ,
)qq, -
;qq- .
}rr 	
}ss 
}tt êé
]/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/SlaEngine.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 
	SlaEngine 
: 

ISlaEngine #
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly 
IEmailService "
_emailService# 0
;0 1
private 
readonly #
INotificationDispatcher ,#
_notificationDispatcher- D
;D E
public 

	SlaEngine 
( 
ItsToolDbContext %
context& -
,- .
IEmailService/ <
emailService= I
,I J#
INotificationDispatcherK b"
notificationDispatcherc y
)y z
{ 
_context 
= 
context 
; 
_emailService 
= 
emailService $
;$ %#
_notificationDispatcher 
=  !"
notificationDispatcher" 8
;8 9
} 
private 
async 
Task 
< 
DateTime 
>  !
CalculateDueTimeAsync! 6
(6 7
DateTime7 ?
startTimeUtc@ L
,L M
intN Q
minutesToAddR ^
)^ _
{ 
var 
holidays 
= 
await 
_context %
.% &
Holidays& .
.. /
ToListAsync/ :
(: ;
); <
;< =
var 
businessHours 
= 
await !
_context" *
.* +
BusinessHours+ 8
.8 9
ToListAsync9 D
(D E
)E F
;F G
var   
currentTime   
=   
startTimeUtc   &
;  & '
var!! 
minutesRemaining!! 
=!! 
minutesToAdd!! +
;!!+ ,
while## 
(## 
minutesRemaining## 
>##  !
$num##" #
)### $
{$$ 	
if%% 
(%% 
!%% 
IsWorkingDay%% 
(%% 
currentTime%% )
,%%) *
holidays%%+ 3
,%%3 4
businessHours%%5 B
)%%B C
)%%C D
{&& 
currentTime'' 
='' 
currentTime'' )
.'') *
Date''* .
.''. /
AddDays''/ 6
(''6 7
$num''7 8
)''8 9
;''9 :
continue(( 
;(( 
})) 
var++ 
bh++ 
=++ 
GetWorkingWindow++ %
(++% &
currentTime++& 1
,++1 2
businessHours++3 @
)++@ A
;++A B
var,, 
(,, 
newTime,, 
,,, 
	remaining,, #
),,# $
=,,% &#
ConsumeMinutesWithinDay,,' >
(,,> ?
currentTime,,? J
,,,J K
minutesRemaining,,L \
,,,\ ]
bh,,^ `
.,,` a
	StartTime,,a j
,,,j k
bh,,l n
.,,n o
EndTime,,o v
),,v w
;,,w x
currentTime.. 
=.. 
newTime.. !
;..! "
minutesRemaining// 
=// 
	remaining// (
;//( )
}00 	
return22 
currentTime22 
;22 
}33 
public55 

static55 
bool55 
IsWorkingDay55 #
(55# $
DateTime55$ ,
date55- 1
,551 2
List553 7
<557 8
Holiday558 ?
>55? @
holidays55A I
,55I J
List55K O
<55O P
BusinessHour55P \
>55\ ]
businessHours55^ k
)55k l
{66 
if77 

(77 
holidays77 
.77 
Any77 
(77 
h77 
=>77 
h77 
.77  
Date77  $
.77$ %
Date77% )
==77* ,
date77- 1
.771 2
Date772 6
)776 7
)777 8
return779 ?
false77@ E
;77E F
var88 
bh88 
=88 
businessHours88 
.88 
FirstOrDefault88 -
(88- .
b88. /
=>880 2
b883 4
.884 5
	DayOfWeek885 >
==88? A
date88B F
.88F G
	DayOfWeek88G P
)88P Q
;88Q R
return99 
bh99 
!=99 
null99 
&&99 
bh99 
.99  
IsWorkingDay99  ,
;99, -
}:: 
public<< 

static<< 
BusinessHour<< 
GetWorkingWindow<< /
(<</ 0
DateTime<<0 8
date<<9 =
,<<= >
List<<? C
<<<C D
BusinessHour<<D P
><<P Q
businessHours<<R _
)<<_ `
{== 
return>> 
businessHours>> 
.>> 
First>> "
(>>" #
b>># $
=>>>% '
b>>( )
.>>) *
	DayOfWeek>>* 3
==>>4 6
date>>7 ;
.>>; <
	DayOfWeek>>< E
)>>E F
;>>F G
}?? 
publicAA 

staticAA 
(AA 
DateTimeAA 
newTimeAA #
,AA# $
intAA% (
minutesRemainingAA) 9
)AA9 :#
ConsumeMinutesWithinDayAA; R
(AAR S
DateTimeAAS [
currentTimeAA\ g
,AAg h
intAAi l
minutesRemainingAAm }
,AA} ~
TimeSpan	AA á
	startTime
AAà ë
,
AAë í
TimeSpan
AAì õ
endTime
AAú £
)
AA£ §
{BB 
varCC 
currentDayTimeCC 
=CC 
currentTimeCC (
.CC( )
	TimeOfDayCC) 2
;CC2 3
ifEE 

(EE 
currentDayTimeEE 
<EE 
	startTimeEE &
)EE& '
{FF 	
returnGG 
(GG 
currentTimeGG 
.GG  
DateGG  $
.GG$ %
AddGG% (
(GG( )
	startTimeGG) 2
)GG2 3
,GG3 4
minutesRemainingGG5 E
)GGE F
;GGF G
}HH 	
ifJJ 

(JJ 
currentDayTimeJJ 
>=JJ 
endTimeJJ %
)JJ% &
{KK 	
returnLL 
(LL 
currentTimeLL 
.LL  
DateLL  $
.LL$ %
AddDaysLL% ,
(LL, -
$numLL- .
)LL. /
,LL/ 0
minutesRemainingLL1 A
)LLA B
;LLB C
}MM 	
varOO 
minutesToEoDOO 
=OO 
(OO 
intOO 
)OO  
(OO  !
endTimeOO! (
-OO) *
currentDayTimeOO+ 9
)OO9 :
.OO: ;
TotalMinutesOO; G
;OOG H
ifQQ 

(QQ 
minutesRemainingQQ 
<=QQ 
minutesToEoDQQ  ,
)QQ, -
{RR 	
returnSS 
(SS 
currentTimeSS 
.SS  

AddMinutesSS  *
(SS* +
minutesRemainingSS+ ;
)SS; <
,SS< =
$numSS> ?
)SS? @
;SS@ A
}TT 	
returnVV 
(VV 
currentTimeVV 
.VV 
DateVV  
.VV  !
AddDaysVV! (
(VV( )
$numVV) *
)VV* +
.VV+ ,
AddVV, /
(VV/ 0
	startTimeVV0 9
)VV9 :
,VV: ;
minutesRemainingVV< L
-VVM N
minutesToEoDVVO [
)VV[ \
;VV\ ]
}WW 
publicYY 

asyncYY 
TaskYY "
AttachSlaToTicketAsyncYY ,
(YY, -
intYY- 0
ticketIdYY1 9
)YY9 :
{ZZ 
var[[ 
ticket[[ 
=[[ 
await[[ 
_context[[ #
.[[# $
Tickets[[$ +
.[[+ ,
	FindAsync[[, 5
([[5 6
ticketId[[6 >
)[[> ?
;[[? @
if\\ 

(\\ 
ticket\\ 
==\\ 
null\\ 
)\\ 
return\\ "
;\\" #
var^^ 
policy^^ 
=^^ 
await^^ 
_context^^ #
.^^# $
SlaPolicies^^$ /
.__ 
FirstOrDefaultAsync__  
(__  !
p__! "
=>__# %
p__& '
.__' (
IsActive__( 0
&&__1 3
(__4 5
p__5 6
.__6 7
	ProjectId__7 @
==__A C
ticket__D J
.__J K
	ProjectId__K T
||__U W
p__X Y
.__Y Z
	ProjectId__Z c
==__d f
null__g k
)__k l
)__l m
;__m n
ifaa 

(aa 
policyaa 
==aa 
nullaa 
)aa 
returnaa "
;aa" #
varcc 
targetcc 
=cc 
awaitcc 
_contextcc #
.cc# $

SlaTargetscc$ .
.dd 
FirstOrDefaultAsyncdd  
(dd  !
tdd! "
=>dd# %
tdd& '
.dd' (
SlaPolicyIddd( 3
==dd4 6
policydd7 =
.dd= >
Iddd> @
&&ddA C
tddD E
.ddE F

PriorityIdddF P
==ddQ S
ticketddT Z
.ddZ [

PriorityIddd[ e
&&ddf h
(ee& '
tee' (
.ee( )
TicketTypeIdee) 5
==ee6 8
ticketee9 ?
.ee? @
TypeIdee@ F
||eeG I
teeJ K
.eeK L
TicketTypeIdeeL X
==eeY [
nullee\ `
)ee` a
)eea b
;eeb c
ifgg 

(gg 
targetgg 
==gg 
nullgg 
)gg 
returngg "
;gg" #
varii 
nowii 
=ii 
DateTimeii 
.ii 
UtcNowii !
;ii! "
varjj 
firstResponseDuejj 
=jj 
awaitjj $!
CalculateDueTimeAsyncjj% :
(jj: ;
nowjj; >
,jj> ?
targetjj@ F
.jjF G 
FirstResponseMinutesjjG [
)jj[ \
;jj\ ]
varkk 
resolutionDuekk 
=kk 
awaitkk !!
CalculateDueTimeAsynckk" 7
(kk7 8
nowkk8 ;
,kk; <
targetkk= C
.kkC D
ResolutionMinuteskkD U
)kkU V
;kkV W
varmm 
slamm 
=mm 
newmm 
	TicketSlamm 
{nn 	
TicketIdoo 
=oo 
ticketoo 
.oo 
Idoo  
,oo  !
FirstResponseDueAtpp 
=pp  
firstResponseDuepp! 1
,pp1 2
ResolutionDueAtqq 
=qq 
resolutionDueqq +
}rr 	
;rr	 

_contexttt 
.tt 

TicketSlastt 
.tt 
Addtt 
(tt  
slatt  #
)tt# $
;tt$ %
awaituu 
_contextuu 
.uu 
SaveChangesAsyncuu '
(uu' (
)uu( )
;uu) *
}vv 
publicxx 

asyncxx 
Taskxx *
ProcessTicketStatusChangeAsyncxx 4
(xx4 5
intxx5 8
ticketIdxx9 A
,xxA B
intxxC F
oldStatusIdxxG R
,xxR S
intxxT W
newStatusIdxxX c
)xxc d
{yy 
varzz 
slazz 
=zz 
awaitzz 
_contextzz  
.zz  !

TicketSlaszz! +
.zz+ ,
FirstOrDefaultAsynczz, ?
(zz? @
szz@ A
=>zzB D
szzE F
.zzF G
TicketIdzzG O
==zzP R
ticketIdzzS [
)zz[ \
;zz\ ]
if{{ 

({{ 
sla{{ 
=={{ 
null{{ 
){{ 
return{{ 
;{{  
if}} 

(}} 
sla}} 
.}} 
FirstResponseMetAt}} "
==}}# %
null}}& *
)}}* +
sla~~ 
.~~ 
FirstResponseMetAt~~ "
=~~# $
DateTime~~% -
.~~- .
UtcNow~~. 4
;~~4 5
var
ÄÄ 
	oldStatus
ÄÄ 
=
ÄÄ 
await
ÄÄ 
_context
ÄÄ &
.
ÄÄ& '
Statuses
ÄÄ' /
.
ÄÄ/ 0
	FindAsync
ÄÄ0 9
(
ÄÄ9 :
oldStatusId
ÄÄ: E
)
ÄÄE F
;
ÄÄF G
var
ÅÅ 
	newStatus
ÅÅ 
=
ÅÅ 
await
ÅÅ 
_context
ÅÅ &
.
ÅÅ& '
Statuses
ÅÅ' /
.
ÅÅ/ 0
	FindAsync
ÅÅ0 9
(
ÅÅ9 :
newStatusId
ÅÅ: E
)
ÅÅE F
;
ÅÅF G
if
ÇÇ 

(
ÇÇ 
	oldStatus
ÇÇ 
==
ÇÇ 
null
ÇÇ 
||
ÇÇ  
	newStatus
ÇÇ! *
==
ÇÇ+ -
null
ÇÇ. 2
)
ÇÇ2 3
return
ÇÇ4 :
;
ÇÇ: ;
var
ÑÑ 
now
ÑÑ 
=
ÑÑ 
DateTime
ÑÑ 
.
ÑÑ 
UtcNow
ÑÑ !
;
ÑÑ! "
if
ÜÜ 

(
ÜÜ 
!
ÜÜ 
	oldStatus
ÜÜ 
.
ÜÜ 
	PausesSla
ÜÜ  
&&
ÜÜ! #
	newStatus
ÜÜ$ -
.
ÜÜ- .
	PausesSla
ÜÜ. 7
)
ÜÜ7 8
{
áá 	

ApplyPause
àà 
(
àà 
sla
àà 
,
àà 
now
àà 
)
àà  
;
àà  !
}
ââ 	
else
ää 
if
ää 
(
ää 
	oldStatus
ää 
.
ää 
	PausesSla
ää $
&&
ää% '
!
ää( )
	newStatus
ää) 2
.
ää2 3
	PausesSla
ää3 <
&&
ää= ?
sla
ää@ C
.
ääC D
PausedAt
ääD L
.
ääL M
HasValue
ääM U
)
ääU V
{
ãã 	
await
åå 
ApplyResumeAsync
åå "
(
åå" #
sla
åå# &
,
åå& '
now
åå( +
)
åå+ ,
;
åå, -
}
çç 	
if
èè 

(
èè 
	newStatus
èè 
.
èè 
IsClosedStatus
èè $
&&
èè% '
sla
èè( +
.
èè+ ,
ResolutionMetAt
èè, ;
==
èè< >
null
èè? C
)
èèC D
sla
êê 
.
êê 
ResolutionMetAt
êê 
=
êê  !
now
êê" %
;
êê% &
await
íí 
_context
íí 
.
íí 
SaveChangesAsync
íí '
(
íí' (
)
íí( )
;
íí) *
}
ìì 
private
ïï 
static
ïï 
void
ïï 

ApplyPause
ïï "
(
ïï" #
	TicketSla
ïï# ,
sla
ïï- 0
,
ïï0 1
DateTime
ïï2 :
now
ïï; >
)
ïï> ?
{
ññ 
sla
óó 
.
óó 
PausedAt
óó 
=
óó 
now
óó 
;
óó 
}
òò 
private
öö 
async
öö 
Task
öö 
ApplyResumeAsync
öö '
(
öö' (
	TicketSla
öö( 1
sla
öö2 5
,
öö5 6
DateTime
öö7 ?
now
öö@ C
)
ööC D
{
õõ 
if
úú 

(
úú 
!
úú 
sla
úú 
.
úú 
PausedAt
úú 
.
úú 
HasValue
úú "
)
úú" #
return
úú$ *
;
úú* +
var
ûû 
pausedDuration
ûû 
=
ûû 
now
ûû  
-
ûû! "
sla
ûû# &
.
ûû& '
PausedAt
ûû' /
.
ûû/ 0
Value
ûû0 5
;
ûû5 6
sla
üü 
.
üü  
TotalPausedMinutes
üü 
+=
üü !
(
üü" #
int
üü# &
)
üü& '
pausedDuration
üü' 5
.
üü5 6
TotalMinutes
üü6 B
;
üüB C
if
°° 

(
°° 
sla
°° 
.
°°  
FirstResponseDueAt
°° "
.
°°" #
HasValue
°°# +
)
°°+ ,
sla
¢¢ 
.
¢¢  
FirstResponseDueAt
¢¢ "
=
¢¢# $
await
¢¢% *#
CalculateDueTimeAsync
¢¢+ @
(
¢¢@ A
now
¢¢A D
,
¢¢D E
(
¢¢F G
int
¢¢G J
)
¢¢J K
(
¢¢K L
sla
¢¢L O
.
¢¢O P 
FirstResponseDueAt
¢¢P b
.
¢¢b c
Value
¢¢c h
-
¢¢i j
sla
¢¢k n
.
¢¢n o
PausedAt
¢¢o w
.
¢¢w x
Value
¢¢x }
)
¢¢} ~
.
¢¢~ 
TotalMinutes¢¢ ã
)¢¢ã å
;¢¢å ç
if
§§ 

(
§§ 
sla
§§ 
.
§§ 
ResolutionDueAt
§§ 
.
§§  
HasValue
§§  (
)
§§( )
sla
•• 
.
•• 
ResolutionDueAt
•• 
=
••  !
await
••" '#
CalculateDueTimeAsync
••( =
(
••= >
now
••> A
,
••A B
(
••C D
int
••D G
)
••G H
(
••H I
sla
••I L
.
••L M
ResolutionDueAt
••M \
.
••\ ]
Value
••] b
-
••c d
sla
••e h
.
••h i
PausedAt
••i q
.
••q r
Value
••r w
)
••w x
.
••x y
TotalMinutes••y Ö
)••Ö Ü
;••Ü á
sla
ßß 
.
ßß 
PausedAt
ßß 
=
ßß 
null
ßß 
;
ßß 
}
®® 
public
™™ 

async
™™ 
Task
™™ '
ProcessTicketCommentAsync
™™ /
(
™™/ 0
int
™™0 3
ticketId
™™4 <
,
™™< =
bool
™™> B

isInternal
™™C M
)
™™M N
{
´´ 
if
¨¨ 

(
¨¨ 

isInternal
¨¨ 
)
¨¨ 
return
¨¨ 
;
¨¨ 
var
ÆÆ 
sla
ÆÆ 
=
ÆÆ 
await
ÆÆ 
_context
ÆÆ  
.
ÆÆ  !

TicketSlas
ÆÆ! +
.
ÆÆ+ ,!
FirstOrDefaultAsync
ÆÆ, ?
(
ÆÆ? @
s
ÆÆ@ A
=>
ÆÆB D
s
ÆÆE F
.
ÆÆF G
TicketId
ÆÆG O
==
ÆÆP R
ticketId
ÆÆS [
)
ÆÆ[ \
;
ÆÆ\ ]
if
ØØ 

(
ØØ 
sla
ØØ 
!=
ØØ 
null
ØØ 
&&
ØØ 
sla
ØØ 
.
ØØ  
FirstResponseMetAt
ØØ 1
==
ØØ2 4
null
ØØ5 9
)
ØØ9 :
{
∞∞ 	
sla
±± 
.
±±  
FirstResponseMetAt
±± "
=
±±# $
DateTime
±±% -
.
±±- .
UtcNow
±±. 4
;
±±4 5
await
≤≤ 
_context
≤≤ 
.
≤≤ 
SaveChangesAsync
≤≤ +
(
≤≤+ ,
)
≤≤, -
;
≤≤- .
}
≥≥ 	
}
¥¥ 
public
∂∂ 

async
∂∂ 
Task
∂∂  
CheckBreachesAsync
∂∂ (
(
∂∂( )
DateTime
∂∂) 1
nowUtc
∂∂2 8
)
∂∂8 9
{
∑∑ 
var
∏∏ 

activeSlas
∏∏ 
=
∏∏ 
await
∏∏ 
_context
∏∏ '
.
∏∏' (

TicketSlas
∏∏( 2
.
ππ 
Include
ππ 
(
ππ 
s
ππ 
=>
ππ 
s
ππ 
.
ππ 
Ticket
ππ "
)
ππ" #
.
∫∫ 
Where
∫∫ 
(
∫∫ 
s
∫∫ 
=>
∫∫ 
s
∫∫ 
.
∫∫ 
PausedAt
∫∫ "
==
∫∫# %
null
∫∫& *
&&
∫∫+ -
(
∫∫. /
!
∫∫/ 0
s
∫∫0 1
.
∫∫1 2
ResolutionMetAt
∫∫2 A
.
∫∫A B
HasValue
∫∫B J
||
∫∫K M
!
∫∫N O
s
∫∫O P
.
∫∫P Q 
FirstResponseMetAt
∫∫Q c
.
∫∫c d
HasValue
∫∫d l
)
∫∫l m
)
∫∫m n
.
ªª 
ToListAsync
ªª 
(
ªª 
)
ªª 
;
ªª 
foreach
ΩΩ 
(
ΩΩ 
var
ΩΩ 
sla
ΩΩ 
in
ΩΩ 

activeSlas
ΩΩ &
)
ΩΩ& '
{
ææ 	
if
øø 
(
øø 
sla
øø 
.
øø 
Ticket
øø 
==
øø 
null
øø "
)
øø" #
continue
øø$ ,
;
øø, -
var
¿¿ 
targetUserId
¿¿ 
=
¿¿ 
sla
¿¿ "
.
¿¿" #
Ticket
¿¿# )
.
¿¿) *
AssignedUserId
¿¿* 8
??
¿¿9 ;
sla
¿¿< ?
.
¿¿? @
Ticket
¿¿@ F
.
¿¿F G
RequesterUserId
¿¿G V
;
¿¿V W
await
¬¬ %
CheckFirstResponseAsync
¬¬ )
(
¬¬) *
sla
¬¬* -
,
¬¬- .
targetUserId
¬¬/ ;
,
¬¬; <
nowUtc
¬¬= C
)
¬¬C D
;
¬¬D E
await
√√ "
CheckResolutionAsync
√√ &
(
√√& '
sla
√√' *
,
√√* +
targetUserId
√√, 8
,
√√8 9
nowUtc
√√: @
)
√√@ A
;
√√A B
}
ƒƒ 	
await
∆∆ 
_context
∆∆ 
.
∆∆ 
SaveChangesAsync
∆∆ '
(
∆∆' (
)
∆∆( )
;
∆∆) *
}
«« 
private
…… 
async
…… 
Task
…… %
CheckFirstResponseAsync
…… .
(
……. /
	TicketSla
……/ 8
sla
……9 <
,
……< =
int
……> A
targetUserId
……B N
,
……N O
DateTime
……P X
nowUtc
……Y _
)
……_ `
{
   
if
ÀÀ 

(
ÀÀ 
sla
ÀÀ 
.
ÀÀ  
FirstResponseMetAt
ÀÀ "
.
ÀÀ" #
HasValue
ÀÀ# +
||
ÀÀ, .
!
ÀÀ/ 0
sla
ÀÀ0 3
.
ÀÀ3 4 
FirstResponseDueAt
ÀÀ4 F
.
ÀÀF G
HasValue
ÀÀG O
)
ÀÀO P
return
ÀÀQ W
;
ÀÀW X
var
ÕÕ 
(
ÕÕ 
warn
ÕÕ 
,
ÕÕ 
breach
ÕÕ 
)
ÕÕ 
=
ÕÕ 
EvaluateMetric
ÕÕ +
(
ÕÕ+ ,
sla
ÕÕ, /
.
ÕÕ/ 0 
FirstResponseDueAt
ÕÕ0 B
.
ÕÕB C
Value
ÕÕC H
,
ÕÕH I
sla
ÕÕJ M
.
ÕÕM N!
FirstResponseWarned
ÕÕN a
,
ÕÕa b
sla
ÕÕc f
.
ÕÕf g#
FirstResponseBreached
ÕÕg |
,
ÕÕ| }
nowUtcÕÕ~ Ñ
)ÕÕÑ Ö
;ÕÕÖ Ü
if
œœ 

(
œœ 
breach
œœ 
)
œœ 
{
–– 	
sla
—— 
.
—— #
FirstResponseBreached
—— %
=
——& '
true
——( ,
;
——, -
await
““ %
_notificationDispatcher
““ )
.
““) * 
DispatchEventAsync
““* <
(
““< =
$str
““= I
,
““I J
sla
““K N
.
““N O
TicketId
““O W
,
““W X
null
““Y ]
,
““] ^
$str
““_ }
)
““} ~
;
““~ 
await
”” 
TryEscalateAsync
”” "
(
””" #
sla
””# &
)
””& '
;
””' (
}
‘‘ 	
else
’’ 
if
’’ 
(
’’ 
warn
’’ 
)
’’ 
{
÷÷ 	
sla
◊◊ 
.
◊◊ !
FirstResponseWarned
◊◊ #
=
◊◊$ %
true
◊◊& *
;
◊◊* +
await
ÿÿ %
CreateNotificationAsync
ÿÿ )
(
ÿÿ) *
targetUserId
ÿÿ* 6
,
ÿÿ6 7
sla
ÿÿ8 ;
.
ÿÿ; <
TicketId
ÿÿ< D
,
ÿÿD E
$str
ÿÿF S
,
ÿÿS T
$str
ÿÿU }
)
ÿÿ} ~
;
ÿÿ~ 
}
ŸŸ 	
}
⁄⁄ 
private
‹‹ 
async
‹‹ 
Task
‹‹ "
CheckResolutionAsync
‹‹ +
(
‹‹+ ,
	TicketSla
‹‹, 5
sla
‹‹6 9
,
‹‹9 :
int
‹‹; >
targetUserId
‹‹? K
,
‹‹K L
DateTime
‹‹M U
nowUtc
‹‹V \
)
‹‹\ ]
{
›› 
if
ﬁﬁ 

(
ﬁﬁ 
sla
ﬁﬁ 
.
ﬁﬁ 
ResolutionMetAt
ﬁﬁ 
.
ﬁﬁ  
HasValue
ﬁﬁ  (
||
ﬁﬁ) +
!
ﬁﬁ, -
sla
ﬁﬁ- 0
.
ﬁﬁ0 1
ResolutionDueAt
ﬁﬁ1 @
.
ﬁﬁ@ A
HasValue
ﬁﬁA I
)
ﬁﬁI J
return
ﬁﬁK Q
;
ﬁﬁQ R
var
‡‡ 
(
‡‡ 
warn
‡‡ 
,
‡‡ 
breach
‡‡ 
)
‡‡ 
=
‡‡ 
EvaluateMetric
‡‡ +
(
‡‡+ ,
sla
‡‡, /
.
‡‡/ 0
ResolutionDueAt
‡‡0 ?
.
‡‡? @
Value
‡‡@ E
,
‡‡E F
sla
‡‡G J
.
‡‡J K
ResolutionWarned
‡‡K [
,
‡‡[ \
sla
‡‡] `
.
‡‡` a 
ResolutionBreached
‡‡a s
,
‡‡s t
nowUtc
‡‡u {
)
‡‡{ |
;
‡‡| }
if
‚‚ 

(
‚‚ 
breach
‚‚ 
)
‚‚ 
{
„„ 	
sla
‰‰ 
.
‰‰  
ResolutionBreached
‰‰ "
=
‰‰# $
true
‰‰% )
;
‰‰) *
await
ÂÂ %
_notificationDispatcher
ÂÂ )
.
ÂÂ) * 
DispatchEventAsync
ÂÂ* <
(
ÂÂ< =
$str
ÂÂ= I
,
ÂÂI J
sla
ÂÂK N
.
ÂÂN O
TicketId
ÂÂO W
,
ÂÂW X
null
ÂÂY ]
,
ÂÂ] ^
$str
ÂÂ_ y
)
ÂÂy z
;
ÂÂz {
await
ÊÊ 
TryEscalateAsync
ÊÊ "
(
ÊÊ" #
sla
ÊÊ# &
)
ÊÊ& '
;
ÊÊ' (
}
ÁÁ 	
else
ËË 
if
ËË 
(
ËË 
warn
ËË 
)
ËË 
{
ÈÈ 	
sla
ÍÍ 
.
ÍÍ 
ResolutionWarned
ÍÍ  
=
ÍÍ! "
true
ÍÍ# '
;
ÍÍ' (
await
ÎÎ %
CreateNotificationAsync
ÎÎ )
(
ÎÎ) *
targetUserId
ÎÎ* 6
,
ÎÎ6 7
sla
ÎÎ8 ;
.
ÎÎ; <
TicketId
ÎÎ< D
,
ÎÎD E
$str
ÎÎF S
,
ÎÎS T
$str
ÎÎU y
)
ÎÎy z
;
ÎÎz {
}
ÏÏ 	
}
ÌÌ 
private
ÔÔ 
async
ÔÔ 
Task
ÔÔ 
TryEscalateAsync
ÔÔ '
(
ÔÔ' (
	TicketSla
ÔÔ( 1
sla
ÔÔ2 5
)
ÔÔ5 6
{
 
if
ÒÒ 

(
ÒÒ 
sla
ÒÒ 
.
ÒÒ 
EscalatedAt
ÒÒ 
.
ÒÒ 
HasValue
ÒÒ $
||
ÒÒ% '
sla
ÒÒ( +
.
ÒÒ+ ,
Ticket
ÒÒ, 2
==
ÒÒ3 5
null
ÒÒ6 :
)
ÒÒ: ;
return
ÒÒ< B
;
ÒÒB C
var
ÛÛ 
target
ÛÛ 
=
ÛÛ 
await
ÛÛ 
_context
ÛÛ #
.
ÛÛ# $

SlaTargets
ÛÛ$ .
.
ÛÛ. /!
FirstOrDefaultAsync
ÛÛ/ B
(
ÛÛB C
t
ÛÛC D
=>
ÛÛE G
t
ÛÛH I
.
ÛÛI J

PriorityId
ÛÛJ T
==
ÛÛU W
sla
ÛÛX [
.
ÛÛ[ \
Ticket
ÛÛ\ b
.
ÛÛb c

PriorityId
ÛÛc m
&&
ÛÛn p
(
ÛÛq r
t
ÛÛr s
.
ÛÛs t
TicketTypeIdÛÛt Ä
==ÛÛÅ É
slaÛÛÑ á
.ÛÛá à
TicketÛÛà é
.ÛÛé è
TypeIdÛÛè ï
||ÛÛñ ò
tÛÛô ö
.ÛÛö õ
TicketTypeIdÛÛõ ß
==ÛÛ® ™
nullÛÛ´ Ø
)ÛÛØ ∞
)ÛÛ∞ ±
;ÛÛ± ≤
if
ÙÙ 

(
ÙÙ 
target
ÙÙ 
==
ÙÙ 
null
ÙÙ 
)
ÙÙ 
return
ÙÙ "
;
ÙÙ" #
var
ˆˆ 
policy
ˆˆ 
=
ˆˆ 
await
ˆˆ 
_context
ˆˆ #
.
ˆˆ# $
SlaPolicies
ˆˆ$ /
.
ˆˆ/ 0!
FirstOrDefaultAsync
ˆˆ0 C
(
ˆˆC D
p
ˆˆD E
=>
ˆˆF H
p
ˆˆI J
.
ˆˆJ K
Id
ˆˆK M
==
ˆˆN P
target
ˆˆQ W
.
ˆˆW X
SlaPolicyId
ˆˆX c
)
ˆˆc d
;
ˆˆd e
if
¯¯ 

(
¯¯ 
policy
¯¯ 
!=
¯¯ 
null
¯¯ 
&&
¯¯ 
policy
¯¯ $
.
¯¯$ %
EscalateOnBreach
¯¯% 5
)
¯¯5 6
{
˘˘ 	
sla
˙˙ 
.
˙˙ 
EscalatedAt
˙˙ 
=
˙˙ 
DateTime
˙˙ &
.
˙˙& '
UtcNow
˙˙' -
;
˙˙- .
var
˝˝ 
higherPriority
˝˝ 
=
˝˝  
await
˝˝! &
_context
˝˝' /
.
˝˝/ 0

Priorities
˝˝0 :
.
˛˛ 
Where
˛˛ 
(
˛˛ 
p
˛˛ 
=>
˛˛ 
p
˛˛ 
.
˛˛ 
SeverityLevel
˛˛ +
>
˛˛, -
sla
˛˛. 1
.
˛˛1 2
Ticket
˛˛2 8
.
˛˛8 9
Priority
˛˛9 A
!
˛˛A B
.
˛˛B C
SeverityLevel
˛˛C P
)
˛˛P Q
.
ˇˇ 
OrderBy
ˇˇ 
(
ˇˇ 
p
ˇˇ 
=>
ˇˇ 
p
ˇˇ 
.
ˇˇ  
SeverityLevel
ˇˇ  -
)
ˇˇ- .
.
ÄÄ !
FirstOrDefaultAsync
ÄÄ $
(
ÄÄ$ %
)
ÄÄ% &
;
ÄÄ& '
if
ÇÇ 
(
ÇÇ 
higherPriority
ÇÇ 
!=
ÇÇ !
null
ÇÇ" &
)
ÇÇ& '
{
ÉÉ 
var
ÑÑ 
oldPriority
ÑÑ 
=
ÑÑ  !
sla
ÑÑ" %
.
ÑÑ% &
Ticket
ÑÑ& ,
.
ÑÑ, -

PriorityId
ÑÑ- 7
.
ÑÑ7 8
ToString
ÑÑ8 @
(
ÑÑ@ A
)
ÑÑA B
;
ÑÑB C
sla
ÖÖ 
.
ÖÖ 
Ticket
ÖÖ 
.
ÖÖ 

PriorityId
ÖÖ %
=
ÖÖ& '
higherPriority
ÖÖ( 6
.
ÖÖ6 7
Id
ÖÖ7 9
;
ÖÖ9 :
_context
áá 
.
áá 
TicketHistories
áá (
.
áá( )
Add
áá) ,
(
áá, -
new
áá- 0
Domain
áá1 7
.
áá7 8
Entities
áá8 @
.
áá@ A
Ticket
ááA G
.
ááG H
TicketHistory
ááH U
{
àà 
TicketId
ââ 
=
ââ 
sla
ââ "
.
ââ" #
TicketId
ââ# +
,
ââ+ ,
Action
ää 
=
ää 
$str
ää (
,
ää( )
	FieldName
ãã 
=
ãã 
$str
ãã  ,
,
ãã, -
OldValue
åå 
=
åå 
oldPriority
åå *
,
åå* +
NewValue
çç 
=
çç 
higherPriority
çç -
.
çç- .
Id
çç. 0
.
çç0 1
ToString
çç1 9
(
çç9 :
)
çç: ;
,
çç; <
	CreatedBy
éé 
=
éé 
$str
éé  (
}
èè 
)
èè 
;
èè 
}
êê 
}
ëë 	
}
íí 
private
îî 
static
îî 
(
îî 
bool
îî 
warn
îî 
,
îî 
bool
îî #
breach
îî$ *
)
îî* +
EvaluateMetric
îî, :
(
îî: ;
DateTime
îî; C
dueAt
îîD I
,
îîI J
bool
îîK O
warned
îîP V
,
îîV W
bool
îîX \
breached
îî] e
,
îîe f
DateTime
îîg o
now
îîp s
)
îîs t
{
ïï 
var
ññ 
timeRemaining
ññ 
=
ññ 
(
ññ 
dueAt
ññ "
-
ññ# $
now
ññ% (
)
ññ( )
.
ññ) *
TotalMinutes
ññ* 6
;
ññ6 7
if
òò 

(
òò 
timeRemaining
òò 
<=
òò 
$num
òò 
&&
òò !
!
òò" #
breached
òò# +
)
òò+ ,
return
ôô 
(
ôô 
false
ôô 
,
ôô 
true
ôô 
)
ôô  
;
ôô  !
if
õõ 

(
õõ 
timeRemaining
õõ 
>
õõ 
$num
õõ 
&&
õõ  
timeRemaining
õõ! .
<=
õõ/ 1
$num
õõ2 5
&&
õõ6 8
!
õõ9 :
warned
õõ: @
)
õõ@ A
return
úú 
(
úú 
true
úú 
,
úú 
false
úú 
)
úú  
;
úú  !
return
ûû 
(
ûû 
false
ûû 
,
ûû 
false
ûû 
)
ûû 
;
ûû 
}
üü 
private
°° 
async
°° 
Task
°° %
CreateNotificationAsync
°° .
(
°°. /
int
°°/ 2
userId
°°3 9
,
°°9 :
int
°°; >
ticketId
°°? G
,
°°G H
string
°°I O
title
°°P U
,
°°U V
string
°°W ]
message
°°^ e
)
°°e f
{
¢¢ 
_context
££ 
.
££ 
Notifications
££ 
.
££ 
Add
££ "
(
££" #
new
££# &
Domain
££' -
.
££- .
Entities
££. 6
.
££6 7
Notification
££7 C
.
££C D
Notification
££D P
{
§§ 	
UserId
•• 
=
•• 
userId
•• 
,
•• 
Title
¶¶ 
=
¶¶ 
title
¶¶ 
,
¶¶ 
Message
ßß 
=
ßß 
message
ßß 
,
ßß 
RelatedEntityId
®® 
=
®® 
ticketId
®® &
,
®®& '
RelatedEntityType
©© 
=
©© 
$str
©©  (
}
™™ 	
)
™™	 

;
™™
 
var
≠≠ 
user
≠≠ 
=
≠≠ 
await
≠≠ 
_context
≠≠ !
.
≠≠! "
Users
≠≠" '
.
≠≠' (
	FindAsync
≠≠( 1
(
≠≠1 2
userId
≠≠2 8
)
≠≠8 9
;
≠≠9 :
if
ÆÆ 

(
ÆÆ 
user
ÆÆ 
!=
ÆÆ 
null
ÆÆ 
)
ÆÆ 
{
ØØ 	
await
∞∞ 
_emailService
∞∞ 
.
∞∞  
SendEmailAsync
∞∞  .
(
∞∞. /
user
∞∞/ 3
.
∞∞3 4
Email
∞∞4 9
,
∞∞9 :
title
∞∞; @
,
∞∞@ A
message
∞∞B I
)
∞∞I J
;
∞∞J K
}
±± 	
}
≤≤ 
}≥≥ Î9
_/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/RoleService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public		 
class		 
RoleService		 
:		 
IRoleService		 '
{

 
private 
readonly 
IRepository  
<  !
Role! %
>% &
_repository' 2
;2 3
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

RoleService 
( 
IRepository "
<" #
Role# '
>' (

repository) 3
,3 4
ItsToolDbContext5 E
contextF M
)M N
{ 
_repository 
= 

repository  
;  !
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
IEnumerable !
<! "
RoleDto" )
>) *
>* +
GetAllAsync, 7
(7 8
)8 9
{ 
var 
roles 
= 
await 
_repository %
.% &
GetAllAsync& 1
(1 2
)2 3
;3 4
return 
roles 
. 
Select 
( 
r 
=>  
new! $
RoleDto% ,
(, -
r- .
.. /
Id/ 1
,1 2
r3 4
.4 5
Name5 9
,9 :
r; <
.< =
IsActive= E
)E F
)F G
;G H
} 
public 

async 
Task 
< 
RoleDto 
? 
> 
GetByIdAsync  ,
(, -
int- 0
id1 3
)3 4
{ 
var 
r 
= 
await 
_repository !
.! "
GetByIdAsync" .
(. /
id/ 1
)1 2
;2 3
if 

( 
r 
== 
null 
) 
return 
null "
;" #
return 
new 
RoleDto 
( 
r 
. 
Id 
,  
r! "
." #
Name# '
,' (
r) *
.* +
IsActive+ 3
)3 4
;4 5
} 
public!! 

async!! 
Task!! 
<!! 
RoleDto!! 
>!! 
CreateAsync!! *
(!!* +
CreateRoleDto!!+ 8
dto!!9 <
)!!< =
{"" 
var## 
r## 
=## 
new## 
Role## 
{## 
Name## 
=##  !
dto##" %
.##% &
Name##& *
}##+ ,
;##, -
await$$ 
_repository$$ 
.$$ 
AddAsync$$ "
($$" #
r$$# $
)$$$ %
;$$% &
return%% 
new%% 
RoleDto%% 
(%% 
r%% 
.%% 
Id%% 
,%%  
r%%! "
.%%" #
Name%%# '
,%%' (
r%%) *
.%%* +
IsActive%%+ 3
)%%3 4
;%%4 5
}&& 
public(( 

async(( 
Task(( 
UpdateAsync(( !
(((! "
int((" %
id((& (
,((( )
UpdateRoleDto((* 7
dto((8 ;
)((; <
{)) 
var** 
r** 
=** 
await** 
_repository** !
.**! "
GetByIdAsync**" .
(**. /
id**/ 1
)**1 2
;**2 3
if++ 

(++ 
r++ 
==++ 
null++ 
)++ 
throw++ 
new++   
KeyNotFoundException++! 5
(++5 6
$str++6 F
)++F G
;++G H
r-- 	
.--	 

Name--
 
=-- 
dto-- 
.-- 
Name-- 
;-- 
r.. 	
...	 

IsActive..
 
=.. 
dto.. 
... 
IsActive.. !
;..! "
await// 
_repository// 
.// 
UpdateAsync// %
(//% &
r//& '
)//' (
;//( )
}00 
public22 

async22 
Task22 
DeleteAsync22 !
(22! "
int22" %
id22& (
)22( )
{33 
await44 
_repository44 
.44 
DeleteAsync44 %
(44% &
id44& (
)44( )
;44) *
}55 
public77 

async77 
Task77 !
AssignPermissionAsync77 +
(77+ ,
int77, /
roleId770 6
,776 7
int778 ;
permissionId77< H
)77H I
{88 
var99 
exists99 
=99 
await99 
_context99 #
.99# $
RolePermissions99$ 3
.993 4
AnyAsync994 <
(99< =
rp99= ?
=>99@ B
rp99C E
.99E F
RoleId99F L
==99M O
roleId99P V
&&99W Y
rp99Z \
.99\ ]
PermissionId99] i
==99j l
permissionId99m y
)99y z
;99z {
if:: 

(:: 
!:: 
exists:: 
):: 
{;; 	
_context<< 
.<< 
RolePermissions<< $
.<<$ %
Add<<% (
(<<( )
new<<) ,
RolePermission<<- ;
{<<< =
RoleId<<> D
=<<E F
roleId<<G M
,<<M N
PermissionId<<O [
=<<\ ]
permissionId<<^ j
}<<k l
)<<l m
;<<m n
await== 
_context== 
.== 
SaveChangesAsync== +
(==+ ,
)==, -
;==- .
}>> 	
}?? 
publicAA 

asyncAA 
TaskAA !
RevokePermissionAsyncAA +
(AA+ ,
intAA, /
roleIdAA0 6
,AA6 7
intAA8 ;
permissionIdAA< H
)AAH I
{BB 
varCC 
rpCC 
=CC 
awaitCC 
_contextCC 
.CC  
RolePermissionsCC  /
.CC/ 0
FirstOrDefaultAsyncCC0 C
(CCC D
xCCD E
=>CCF H
xCCI J
.CCJ K
RoleIdCCK Q
==CCR T
roleIdCCU [
&&CC\ ^
xCC_ `
.CC` a
PermissionIdCCa m
==CCn p
permissionIdCCq }
)CC} ~
;CC~ 
ifDD 

(DD 
rpDD 
!=DD 
nullDD 
)DD 
{EE 	
_contextFF 
.FF 
RolePermissionsFF $
.FF$ %
RemoveFF% +
(FF+ ,
rpFF, .
)FF. /
;FF/ 0
awaitGG 
_contextGG 
.GG 
SaveChangesAsyncGG +
(GG+ ,
)GG, -
;GG- .
}HH 	
}II 
}JJ ≤¨
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/ReportService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 
ReportService 
: 
IReportService +
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly !
IPermissionCalculator *!
_permissionCalculator+ @
;@ A
public 

ReportService 
( 
ItsToolDbContext )
context* 1
,1 2!
IPermissionCalculator3 H 
permissionCalculatorI ]
)] ^
{ 
_context 
= 
context 
; !
_permissionCalculator 
=  
permissionCalculator  4
;4 5
} 
public 

async 
Task 
< 
Stream 
> #
ExportTicketsToCsvAsync 5
(5 6!
TicketSearchFilterDto6 K
filterL R
,R S
intT W
userIdX ^
)^ _
{ 
var 
perms 
= 
await !
_permissionCalculator /
./ 0.
"CalculateEffectivePermissionsAsync0 R
(R S
userIdS Y
)Y Z
;Z [
var 
query 
= 
_context 
. 
Tickets $
. 
Include 
( 
t 
=> 
t 
. 
Project #
)# $
. 
Include 
( 
t 
=> 
t 
. 
Category $
)$ %
.   
Include   
(   
t   
=>   
t   
.   
Type    
)    !
.!! 
Include!! 
(!! 
t!! 
=>!! 
t!! 
.!! 
Status!! "
)!!" #
."" 
Include"" 
("" 
t"" 
=>"" 
t"" 
."" 
Priority"" $
)""$ %
.## 
Include## 
(## 
t## 
=>## 
t## 
.## 
RequesterUser## )
)##) *
.$$ 
Include$$ 
($$ 
t$$ 
=>$$ 
t$$ 
.$$ 
AssignedUser$$ (
)$$( )
.%% 
Include%% 
(%% 
t%% 
=>%% 
t%% 
.%% 
	TicketSla%% %
)%%% &
.&& 
Where&& 
(&& 
t&& 
=>&& 
!&& 
t&& 
.&& 
	IsDeleted&& $
)&&$ %
;&&% &
query(( 
=(( 
await(( 
ApplySecurityScope(( (
(((( )
query(() .
,((. /
perms((0 5
,((5 6
userId((7 =
)((= >
;((> ?
query)) 
=)) 
ApplyBasicFilters)) !
())! "
query))" '
,))' (
filter))) /
)))/ 0
;))0 1
query** 
=** %
ApplyKeywordAndSlaFilters** )
(**) *
query*** /
,**/ 0
filter**1 7
)**7 8
;**8 9
query,, 
=,, 
query,, 
.,, 
OrderByDescending,, '
(,,' (
t,,( )
=>,,* ,
t,,- .
.,,. /
	CreatedAt,,/ 8
),,8 9
;,,9 :
var-- 
tickets-- 
=-- 
await-- 
query-- !
.--! "
Take--" &
(--& '
$num--' ,
)--, -
.--- .
ToListAsync--. 9
(--9 :
)--: ;
;--; <
return// 
await// "
GenerateCsvStreamAsync// +
(//+ ,
tickets//, 3
)//3 4
;//4 5
}00 
private22 
async22 
Task22 
<22 

IQueryable22 !
<22! "
Ticket22" (
>22( )
>22) *
ApplySecurityScope22+ =
(22= >

IQueryable22> H
<22H I
Ticket22I O
>22O P
query22Q V
,22V W
System22X ^
.22^ _
Collections22_ j
.22j k
Generic22k r
.22r s
HashSet22s z
<22z {
string	22{ Å
>
22Å Ç
perms
22É à
,
22à â
int
22ä ç
userId
22é î
)
22î ï
{33 
if44 

(44 
!44 
perms44 
.44 
Contains44 
(44 
$str44 )
)44) *
)44* +
{55 	
var66 
isAgent66 
=66 
perms66 
.66  
Contains66  (
(66( )
$str66) 8
)668 9
||66: <
perms66= B
.66B C
Contains66C K
(66K L
$str66L [
)66[ \
;66\ ]
if77 
(77 
isAgent77 
)77 
{88 
var99 
userGroupIds99  
=99! "
await99# (
_context99) 1
.991 2
GroupMembers992 >
.:: 
Where:: 
(:: 
gm:: 
=>::  
gm::! #
.::# $
UserId::$ *
==::+ -
userId::. 4
&&::5 7
!::8 9
gm::9 ;
.::; <
	IsDeleted::< E
)::E F
.;; 
Select;; 
(;; 
gm;; 
=>;; !
gm;;" $
.;;$ %
GroupId;;% ,
);;, -
.<< 
ToListAsync<<  
(<<  !
)<<! "
;<<" #
return>> 
query>> 
.>> 
Where>> "
(>>" #
t>># $
=>>>% '
t>>( )
.>>) *
AssignedUserId>>* 8
==>>9 ;
userId>>< B
||>>C E
(??( )
t??) *
.??* +
AssignedGroupId??+ :
.??: ;
HasValue??; C
&&??D F
userGroupIds??G S
.??S T
Contains??T \
(??\ ]
t??] ^
.??^ _
AssignedGroupId??_ n
.??n o
Value??o t
)??t u
)??u v
||??w y
t@@( )
.@@) *
RequesterUserId@@* 9
==@@: <
userId@@= C
)@@C D
;@@D E
}AA 
returnBB 
queryBB 
.BB 
WhereBB 
(BB 
tBB  
=>BB! #
tBB$ %
.BB% &
RequesterUserIdBB& 5
==BB6 8
userIdBB9 ?
)BB? @
;BB@ A
}CC 	
returnDD 
queryDD 
;DD 
}EE 
privateGG 
staticGG 

IQueryableGG 
<GG 
TicketGG $
>GG$ %
ApplyBasicFiltersGG& 7
(GG7 8

IQueryableGG8 B
<GGB C
TicketGGC I
>GGI J
queryGGK P
,GGP Q!
TicketSearchFilterDtoGGR g
filterGGh n
)GGn o
{HH 
ifII 

(II 
filterII 
.II 
	ProjectIdII 
.II 
HasValueII %
)II% &
queryII' ,
=II- .
queryII/ 4
.II4 5
WhereII5 :
(II: ;
tII; <
=>II= ?
tII@ A
.IIA B
	ProjectIdIIB K
==IIL N
filterIIO U
.IIU V
	ProjectIdIIV _
.II_ `
ValueII` e
)IIe f
;IIf g
ifJJ 

(JJ 
filterJJ 
.JJ 

CategoryIdJJ 
.JJ 
HasValueJJ &
)JJ& '
queryJJ( -
=JJ. /
queryJJ0 5
.JJ5 6
WhereJJ6 ;
(JJ; <
tJJ< =
=>JJ> @
tJJA B
.JJB C

CategoryIdJJC M
==JJN P
filterJJQ W
.JJW X

CategoryIdJJX b
.JJb c
ValueJJc h
)JJh i
;JJi j
ifKK 

(KK 
filterKK 
.KK 
TypeIdKK 
.KK 
HasValueKK "
)KK" #
queryKK$ )
=KK* +
queryKK, 1
.KK1 2
WhereKK2 7
(KK7 8
tKK8 9
=>KK: <
tKK= >
.KK> ?
TypeIdKK? E
==KKF H
filterKKI O
.KKO P
TypeIdKKP V
.KKV W
ValueKKW \
)KK\ ]
;KK] ^
ifLL 

(LL 
filterLL 
.LL 
StatusIdLL 
.LL 
HasValueLL $
)LL$ %
queryLL& +
=LL, -
queryLL. 3
.LL3 4
WhereLL4 9
(LL9 :
tLL: ;
=>LL< >
tLL? @
.LL@ A
StatusIdLLA I
==LLJ L
filterLLM S
.LLS T
StatusIdLLT \
.LL\ ]
ValueLL] b
)LLb c
;LLc d
ifMM 

(MM 
filterMM 
.MM 

PriorityIdMM 
.MM 
HasValueMM &
)MM& '
queryMM( -
=MM. /
queryMM0 5
.MM5 6
WhereMM6 ;
(MM; <
tMM< =
=>MM> @
tMMA B
.MMB C

PriorityIdMMC M
==MMN P
filterMMQ W
.MMW X

PriorityIdMMX b
.MMb c
ValueMMc h
)MMh i
;MMi j
ifNN 

(NN 
filterNN 
.NN 
AssigneeUserIdNN !
.NN! "
HasValueNN" *
)NN* +
queryNN, 1
=NN2 3
queryNN4 9
.NN9 :
WhereNN: ?
(NN? @
tNN@ A
=>NNB D
tNNE F
.NNF G
AssignedUserIdNNG U
==NNV X
filterNNY _
.NN_ `
AssigneeUserIdNN` n
.NNn o
ValueNNo t
)NNt u
;NNu v
ifOO 

(OO 
filterOO 
.OO 
RequesterUserIdOO "
.OO" #
HasValueOO# +
)OO+ ,
queryOO- 2
=OO3 4
queryOO5 :
.OO: ;
WhereOO; @
(OO@ A
tOOA B
=>OOC E
tOOF G
.OOG H
RequesterUserIdOOH W
==OOX Z
filterOO[ a
.OOa b
RequesterUserIdOOb q
.OOq r
ValueOOr w
)OOw x
;OOx y
ifPP 

(PP 
filterPP 
.PP 
FromDatePP 
.PP 
HasValuePP $
)PP$ %
queryPP& +
=PP, -
queryPP. 3
.PP3 4
WherePP4 9
(PP9 :
tPP: ;
=>PP< >
tPP? @
.PP@ A
	CreatedAtPPA J
>=PPK M
filterPPN T
.PPT U
FromDatePPU ]
.PP] ^
ValuePP^ c
)PPc d
;PPd e
ifQQ 

(QQ 
filterQQ 
.QQ 
ToDateQQ 
.QQ 
HasValueQQ "
)QQ" #
queryQQ$ )
=QQ* +
queryQQ, 1
.QQ1 2
WhereQQ2 7
(QQ7 8
tQQ8 9
=>QQ: <
tQQ= >
.QQ> ?
	CreatedAtQQ? H
<=QQI K
filterQQL R
.QQR S
ToDateQQS Y
.QQY Z
ValueQQZ _
)QQ_ `
;QQ` a
returnRR 
queryRR 
;RR 
}SS 
privateUU 
staticUU 

IQueryableUU 
<UU 
TicketUU $
>UU$ %%
ApplyKeywordAndSlaFiltersUU& ?
(UU? @

IQueryableUU@ J
<UUJ K
TicketUUK Q
>UUQ R
queryUUS X
,UUX Y!
TicketSearchFilterDtoUUZ o
filterUUp v
)UUv w
{VV 
ifWW 

(WW 
!WW 
stringWW 
.WW 
IsNullOrWhiteSpaceWW &
(WW& '
filterWW' -
.WW- .
KeywordWW. 5
)WW5 6
)WW6 7
{XX 	
varYY 
kwYY 
=YY 
filterYY 
.YY 
KeywordYY #
;YY# $
queryZZ 
=ZZ 
queryZZ 
.ZZ 
WhereZZ 
(ZZ  
tZZ  !
=>ZZ" $
t[[ 
.[[ 
TicketNumber[[ 
.[[ 
Contains[[ '
([[' (
kw[[( *
,[[* +
StringComparison[[, <
.[[< =
OrdinalIgnoreCase[[= N
)[[N O
||[[P R
t\\ 
.\\ 
Title\\ 
.\\ 
Contains\\  
(\\  !
kw\\! #
,\\# $
StringComparison\\% 5
.\\5 6
OrdinalIgnoreCase\\6 G
)\\G H
||\\I K
t]] 
.]] 
Description]] 
.]] 
Contains]] &
(]]& '
kw]]' )
,]]) *
StringComparison]]+ ;
.]]; <
OrdinalIgnoreCase]]< M
)]]M N
)]]N O
;]]O P
}^^ 	
if`` 

(`` 
!`` 
string`` 
.`` 
IsNullOrWhiteSpace`` &
(``& '
filter``' -
.``- .
	SlaStatus``. 7
)``7 8
)``8 9
{aa 	
varbb 
sbb 
=bb 
filterbb 
.bb 
	SlaStatusbb $
.bb$ %
ToLowerbb% ,
(bb, -
)bb- .
;bb. /
ifcc 
(cc 
scc 
==cc 
$strcc 
)cc  
querydd 
=dd 
querydd 
.dd 
Wheredd #
(dd# $
tdd$ %
=>dd& (
tdd) *
.dd* +
	TicketSladd+ 4
!=dd5 7
nulldd8 <
&&dd= ?
(dd@ A
tddA B
.ddB C
	TicketSladdC L
.ddL M!
FirstResponseBreachedddM b
||ddc e
tddf g
.ddg h
	TicketSladdh q
.ddq r
ResolutionBreached	ddr Ñ
)
ddÑ Ö
)
ddÖ Ü
;
ddÜ á
elseee 
ifee 
(ee 
see 
==ee 
$stree #
)ee# $
queryff 
=ff 
queryff 
.ff 
Whereff #
(ff# $
tff$ %
=>ff& (
tff) *
.ff* +
	TicketSlaff+ 4
!=ff5 7
nullff8 <
&&ff= ?
(ff@ A
tffA B
.ffB C
	TicketSlaffC L
.ffL M
FirstResponseWarnedffM `
||ffa c
tffd e
.ffe f
	TicketSlafff o
.ffo p
ResolutionWarned	ffp Ä
)
ffÄ Å
&&
ffÇ Ñ
!
ffÖ Ü
(
ffÜ á
t
ffá à
.
ffà â
	TicketSla
ffâ í
.
ffí ì#
FirstResponseBreached
ffì ®
||
ff© ´
t
ff¨ ≠
.
ff≠ Æ
	TicketSla
ffÆ ∑
.
ff∑ ∏ 
ResolutionBreached
ff∏  
)
ff  À
)
ffÀ Ã
;
ffÃ Õ
elsegg 
ifgg 
(gg 
sgg 
==gg 
$strgg #
)gg# $
queryhh 
=hh 
queryhh 
.hh 
Wherehh #
(hh# $
thh$ %
=>hh& (
thh) *
.hh* +
	TicketSlahh+ 4
!=hh5 7
nullhh8 <
&&hh= ?
!hh@ A
thhA B
.hhB C
	TicketSlahhC L
.hhL M
FirstResponseWarnedhhM `
&&hha c
!hhd e
thhe f
.hhf g
	TicketSlahhg p
.hhp q
ResolutionWarned	hhq Å
&&
hhÇ Ñ
!
hhÖ Ü
t
hhÜ á
.
hhá à
	TicketSla
hhà ë
.
hhë í#
FirstResponseBreached
hhí ß
&&
hh® ™
!
hh´ ¨
t
hh¨ ≠
.
hh≠ Æ
	TicketSla
hhÆ ∑
.
hh∑ ∏ 
ResolutionBreached
hh∏  
)
hh  À
;
hhÀ Ã
}ii 	
returnjj 
queryjj 
;jj 
}kk 
privatemm 
staticmm 
asyncmm 
Taskmm 
<mm 
Streammm $
>mm$ %"
GenerateCsvStreamAsyncmm& <
(mm< =
Systemmm= C
.mmC D
CollectionsmmD O
.mmO P
GenericmmP W
.mmW X
ListmmX \
<mm\ ]
Domainmm] c
.mmc d
Entitiesmmd l
.mml m
Ticketmmm s
.mms t
Ticketmmt z
>mmz {
tickets	mm| É
)
mmÉ Ñ
{nn 
varoo 
msoo 
=oo 
newoo 
MemoryStreamoo !
(oo! "
)oo" #
;oo# $
varpp 
swpp 
=pp 
newpp 
StreamWriterpp !
(pp! "
mspp" $
,pp$ %
Encodingpp& .
.pp. /
UTF8pp/ 3
)pp3 4
;pp4 5
awaitrr 
swrr 
.rr 
WriteLineAsyncrr 
(rr  
$str	rr  Ç
)
rrÇ É
;
rrÉ Ñ
foreachtt 
(tt 
vartt 
ttt 
intt 
ticketstt !
)tt! "
{uu 	
varvv 
	slaStatusvv 
=vv 
$strvv &
;vv& '
ifww 
(ww 
tww 
.ww 
	TicketSlaww 
!=ww 
nullww #
)ww# $
{xx 
ifyy 
(yy 
tyy 
.yy 
	TicketSlayy 
.yy  !
FirstResponseBreachedyy  5
||yy6 8
tyy9 :
.yy: ;
	TicketSlayy; D
.yyD E
ResolutionBreachedyyE W
)yyW X
	slaStatusyyY b
=yyc d
$stryye o
;yyo p
elsezz 
ifzz 
(zz 
tzz 
.zz 
	TicketSlazz $
.zz$ %
FirstResponseWarnedzz% 8
||zz9 ;
tzz< =
.zz= >
	TicketSlazz> G
.zzG H
ResolutionWarnedzzH X
)zzX Y
	slaStatuszzZ c
=zzd e
$strzzf o
;zzo p
}{{ 
var}} 
line}} 
=}} 
$"}} 
$str}} 
{}} 
	EscapeCsv}} %
(}}% &
t}}& '
.}}' (
TicketNumber}}( 4
)}}4 5
}}}5 6
$str}}6 ;
{}}; <
	EscapeCsv}}< E
(}}E F
t}}F G
.}}G H
Title}}H M
)}}M N
}}}N O
$str}}O T
{}}T U
	EscapeCsv}}U ^
(}}^ _
t}}_ `
.}}` a
Project}}a h
?}}h i
.}}i j
Name}}j n
)}}n o
}}}o p
$str}}p u
{}}u v
	EscapeCsv}}v 
(	}} Ä
t
}}Ä Å
.
}}Å Ç
Category
}}Ç ä
?
}}ä ã
.
}}ã å
Name
}}å ê
)
}}ê ë
}
}}ë í
$str
}}í ó
{
}}ó ò
	EscapeCsv
}}ò °
(
}}° ¢
t
}}¢ £
.
}}£ §
Type
}}§ ®
?
}}® ©
.
}}© ™
Name
}}™ Æ
)
}}Æ Ø
}
}}Ø ∞
$str
}}∞ µ
{
}}µ ∂
	EscapeCsv
}}∂ ø
(
}}ø ¿
t
}}¿ ¡
.
}}¡ ¬
Status
}}¬ »
?
}}» …
.
}}…  
Name
}}  Œ
)
}}Œ œ
}
}}œ –
$str
}}– ’
{
}}’ ÷
	EscapeCsv
}}÷ ﬂ
(
}}ﬂ ‡
t
}}‡ ·
.
}}· ‚
Priority
}}‚ Í
?
}}Í Î
.
}}Î Ï
Name
}}Ï 
)
}} Ò
}
}}Ò Ú
$str
}}Ú ˜
{
}}˜ ¯
	EscapeCsv
}}¯ Å
(
}}Å Ç
t
}}Ç É
.
}}É Ñ
RequesterUser
}}Ñ ë
?
}}ë í
.
}}í ì
	FirstName
}}ì ú
+
}}ù û
$str
}}ü ¢
+
}}£ §
t
}}• ¶
.
}}¶ ß
RequesterUser
}}ß ¥
?
}}¥ µ
.
}}µ ∂
LastName
}}∂ æ
)
}}æ ø
}
}}ø ¿
$str
}}¿ ≈
{
}}≈ ∆
	EscapeCsv
}}∆ œ
(
}}œ –
t
}}– —
.
}}— “
AssignedUser
}}“ ﬁ
?
}}ﬁ ﬂ
.
}}ﬂ ‡
	FirstName
}}‡ È
+
}}Í Î
$str
}}Ï Ô
+
}} Ò
t
}}Ú Û
.
}}Û Ù
AssignedUser
}}Ù Ä
?
}}Ä Å
.
}}Å Ç
LastName
}}Ç ä
)
}}ä ã
}
}}ã å
$str
}}å ë
{
}}ë í
t
}}í ì
.
}}ì î
	CreatedAt
}}î ù
:
}}ù û
$str
}}û ±
}
}}± ≤
$str
}}≤ ∑
{
}}∑ ∏
	slaStatus
}}∏ ¡
}
}}¡ ¬
$str
}}¬ ƒ
"
}}ƒ ≈
;
}}≈ ∆
await~~ 
sw~~ 
.~~ 
WriteLineAsync~~ #
(~~# $
line~~$ (
)~~( )
;~~) *
} 	
await
ÅÅ 
sw
ÅÅ 
.
ÅÅ 

FlushAsync
ÅÅ 
(
ÅÅ 
)
ÅÅ 
;
ÅÅ 
ms
ÇÇ 

.
ÇÇ
 
Position
ÇÇ 
=
ÇÇ 
$num
ÇÇ 
;
ÇÇ 
return
ÉÉ 
ms
ÉÉ 
;
ÉÉ 
}
ÑÑ 
private
ÜÜ 
static
ÜÜ 
string
ÜÜ 
	EscapeCsv
ÜÜ #
(
ÜÜ# $
string
ÜÜ$ *
?
ÜÜ* +
field
ÜÜ, 1
)
ÜÜ1 2
{
áá 
if
àà 

(
àà 
string
àà 
.
àà 
IsNullOrEmpty
àà  
(
àà  !
field
àà! &
)
àà& '
)
àà' (
return
àà) /
$str
àà0 2
;
àà2 3
return
ââ 
field
ââ 
.
ââ 
Replace
ââ 
(
ââ 
$str
ââ !
,
ââ! "
$str
ââ# )
)
ââ) *
;
ââ* +
}
ää 
}ãã íF
b/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/ProjectService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public

 
class

 
ProjectService

 
:

 
IProjectService

 -
{ 
private 
readonly 
IRepository  
<  !
Project! (
>( )
_repository* 5
;5 6
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

ProjectService 
( 
IRepository %
<% &
Project& -
>- .

repository/ 9
,9 :
ItsToolDbContext; K
contextL S
)S T
{ 
_repository 
= 

repository  
;  !
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
IEnumerable !
<! "

ProjectDto" ,
>, -
>- .
GetAllAsync/ :
(: ;
); <
{ 
var 
projects 
= 
await 
_repository (
.( )
GetAllAsync) 4
(4 5
)5 6
;6 7
return 
projects 
. 
Select 
( 
p  
=>! #
new$ '

ProjectDto( 2
(2 3
p3 4
.4 5
Id5 7
,7 8
p9 :
.: ;
Name; ?
,? @
pA B
.B C

ProjectKeyC M
,M N
pO P
.P Q
DescriptionQ \
,\ ]
p^ _
._ `
Status` f
.f g
ToStringg o
(o p
)p q
)q r
)r s
;s t
} 
public 

async 
Task 
< 

ProjectDto  
?  !
>! "
GetByIdAsync# /
(/ 0
int0 3
id4 6
)6 7
{ 
var 
p 
= 
await 
_repository !
.! "
GetByIdAsync" .
(. /
id/ 1
)1 2
;2 3
if 

( 
p 
== 
null 
) 
return 
null "
;" #
return 
new 

ProjectDto 
( 
p 
.  
Id  "
," #
p$ %
.% &
Name& *
,* +
p, -
.- .

ProjectKey. 8
,8 9
p: ;
.; <
Description< G
,G H
pI J
.J K
StatusK Q
.Q R
ToStringR Z
(Z [
)[ \
)\ ]
;] ^
}   
public"" 

async"" 
Task"" 
<"" 

ProjectDto""  
>""  !
CreateAsync""" -
(""- .
CreateProjectDto"". >
dto""? B
)""B C
{## 
var$$ 
p$$ 
=$$ 
new$$ 
Project$$ 
{%% 	
Name&& 
=&& 
dto&& 
.&& 
Name&& 
,&& 

ProjectKey'' 
='' 
dto'' 
.'' 

ProjectKey'' '
,''' (
Description(( 
=(( 
dto(( 
.(( 
Description(( )
,(() *
Status)) 
=)) 
ProjectStatus)) "
.))" #
Active))# )
}** 	
;**	 

await++ 
_repository++ 
.++ 
AddAsync++ "
(++" #
p++# $
)++$ %
;++% &
return,, 
new,, 

ProjectDto,, 
(,, 
p,, 
.,,  
Id,,  "
,,," #
p,,$ %
.,,% &
Name,,& *
,,,* +
p,,, -
.,,- .

ProjectKey,,. 8
,,,8 9
p,,: ;
.,,; <
Description,,< G
,,,G H
p,,I J
.,,J K
Status,,K Q
.,,Q R
ToString,,R Z
(,,Z [
),,[ \
),,\ ]
;,,] ^
}-- 
public// 

async// 
Task// 
UpdateAsync// !
(//! "
int//" %
id//& (
,//( )
UpdateProjectDto//* :
dto//; >
)//> ?
{00 
var11 
p11 
=11 
await11 
_repository11 !
.11! "
GetByIdAsync11" .
(11. /
id11/ 1
)111 2
;112 3
if22 

(22 
p22 
==22 
null22 
)22 
throw22 
new22   
KeyNotFoundException22! 5
(225 6
$str226 I
)22I J
;22J K
p44 	
.44	 

Name44
 
=44 
dto44 
.44 
Name44 
;44 
p55 	
.55	 


ProjectKey55
 
=55 
dto55 
.55 

ProjectKey55 %
;55% &
p66 	
.66	 

Description66
 
=66 
dto66 
.66 
Description66 '
;66' (
if88 

(88 
Enum88 
.88 
TryParse88 
<88 
ProjectStatus88 '
>88' (
(88( )
dto88) ,
.88, -
Status88- 3
,883 4
true885 9
,889 :
out88; >
var88? B
status88C I
)88I J
)88J K
{99 	
p:: 
.:: 
Status:: 
=:: 
status:: 
;:: 
};; 	
await== 
_repository== 
.== 
UpdateAsync== %
(==% &
p==& '
)==' (
;==( )
}>> 
public@@ 

async@@ 
Task@@ 
DeleteAsync@@ !
(@@! "
int@@" %
id@@& (
)@@( )
{AA 
awaitBB 
_repositoryBB 
.BB 
DeleteAsyncBB %
(BB% &
idBB& (
)BB( )
;BB) *
}CC 
publicEE 

asyncEE 
TaskEE 
AddMemberAsyncEE $
(EE$ %
intEE% (
	projectIdEE) 2
,EE2 3
intEE4 7
userIdEE8 >
)EE> ?
{FF 
varGG 
existsGG 
=GG 
awaitGG 
_contextGG #
.GG# $
ProjectMembersGG$ 2
.GG2 3
AnyAsyncGG3 ;
(GG; <
pmGG< >
=>GG? A
pmGGB D
.GGD E
	ProjectIdGGE N
==GGO Q
	projectIdGGR [
&&GG\ ^
pmGG_ a
.GGa b
UserIdGGb h
==GGi k
userIdGGl r
)GGr s
;GGs t
ifHH 

(HH 
!HH 
existsHH 
)HH 
{II 	
_contextJJ 
.JJ 
ProjectMembersJJ #
.JJ# $
AddJJ$ '
(JJ' (
newJJ( +
ProjectMemberJJ, 9
{JJ: ;
	ProjectIdJJ< E
=JJF G
	projectIdJJH Q
,JJQ R
UserIdJJS Y
=JJZ [
userIdJJ\ b
}JJc d
)JJd e
;JJe f
awaitKK 
_contextKK 
.KK 
SaveChangesAsyncKK +
(KK+ ,
)KK, -
;KK- .
}LL 	
}MM 
publicOO 

asyncOO 
TaskOO 
RemoveMemberAsyncOO '
(OO' (
intOO( +
	projectIdOO, 5
,OO5 6
intOO7 :
userIdOO; A
)OOA B
{PP 
varQQ 
pmQQ 
=QQ 
awaitQQ 
_contextQQ 
.QQ  
ProjectMembersQQ  .
.QQ. /
FirstOrDefaultAsyncQQ/ B
(QQB C
xQQC D
=>QQE G
xQQH I
.QQI J
	ProjectIdQQJ S
==QQT V
	projectIdQQW `
&&QQa c
xQQd e
.QQe f
UserIdQQf l
==QQm o
userIdQQp v
)QQv w
;QQw x
ifRR 

(RR 
pmRR 
!=RR 
nullRR 
)RR 
{SS 	
_contextTT 
.TT 
ProjectMembersTT #
.TT# $
RemoveTT$ *
(TT* +
pmTT+ -
)TT- .
;TT. /
awaitUU 
_contextUU 
.UU 
SaveChangesAsyncUU +
(UU+ ,
)UU, -
;UU- .
}VV 	
}WW 
}XX ·=
h/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/PermissionCalculator.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class  
PermissionCalculator !
:" #!
IPermissionCalculator$ 9
{ 
private		 
readonly		 
ItsToolDbContext		 %
_context		& .
;		. /
public 
 
PermissionCalculator 
(  
ItsToolDbContext  0
context1 8
)8 9
{ 
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
HashSet 
< 
string $
>$ %
>% &.
"CalculateEffectivePermissionsAsync' I
(I J
intJ M
userIdN T
)T U
{ 
var 
permissions 
= 
new 
HashSet %
<% &
string& ,
>, -
(- .
). /
;/ 0
var 
userRolePerms 
= 
await !
_context" *
.* +
	UserRoles+ 4
. 
Where 
( 
ur 
=> 
ur 
. 
UserId "
==# %
userId& ,
&&- /
ur0 2
.2 3
Role3 7
!=8 :
null; ?
&&@ B
urC E
.E F
RoleF J
.J K
IsActiveK S
&&T V
!W X
urX Z
.Z [
Role[ _
._ `
	IsDeleted` i
&&j l
!m n
urn p
.p q
	IsDeletedq z
)z {
. 
Join 
( 
_context 
. 
RolePermissions *
,* +
ur 
=> 
ur 
. 
RoleId !
,! "
rp 
=> 
rp 
. 
RoleId !
,! "
( 
ur 
, 
rp 
) 
=> 
rp  
)  !
. 
Where 
( 
rp 
=> 
! 
rp 
. 
	IsDeleted &
&&' )
rp* ,
., -

Permission- 7
!=8 :
null; ?
&&@ B
rpC E
.E F

PermissionF P
.P Q
IsActiveQ Y
&&Z \
!] ^
rp^ `
.` a

Permissiona k
.k l
	IsDeletedl u
)u v
. 
Select 
( 
rp 
=> 
rp 
. 

Permission '
!' (
.( )
Key) ,
), -
. 
ToListAsync 
( 
) 
; 
foreach 
( 
var 
p 
in 
userRolePerms '
)' (
{   	
permissions!! 
.!! 
Add!! 
(!! 
p!! 
)!! 
;!! 
}"" 	
var%% 
groupRolePerms%% 
=%% 
await%% "
_context%%# +
.%%+ ,
GroupMembers%%, 8
.&& 
Where&& 
(&& 
gm&& 
=>&& 
gm&& 
.&& 
UserId&& "
==&&# %
userId&&& ,
&&&&- /
!&&0 1
gm&&1 3
.&&3 4
	IsDeleted&&4 =
&&&&> @
gm&&A C
.&&C D
Group&&D I
!=&&J L
null&&M Q
&&&&R T
gm&&U W
.&&W X
Group&&X ]
.&&] ^
IsActive&&^ f
&&&&g i
!&&j k
gm&&k m
.&&m n
Group&&n s
.&&s t
	IsDeleted&&t }
)&&} ~
.'' 
Join'' 
('' 
_context'' 
.'' 

GroupRoles'' %
,''% &
gm(( 
=>(( 
gm(( 
.(( 
GroupId(( "
,((" #
gr)) 
=>)) 
gr)) 
.)) 
GroupId)) "
,))" #
(** 
gm** 
,** 
gr** 
)** 
=>** 
gr**  
)**  !
.++ 
Where++ 
(++ 
gr++ 
=>++ 
!++ 
gr++ 
.++ 
	IsDeleted++ &
)++& '
.,, 
Join,, 
(,, 
_context,, 
.,, 
RolePermissions,, *
,,,* +
gr-- 
=>-- 
gr-- 
.-- 
RoleId-- !
,--! "
rp.. 
=>.. 
rp.. 
... 
RoleId.. !
,..! "
(// 
gr// 
,// 
rp// 
)// 
=>// 
rp//  
)//  !
.00 
Where00 
(00 
rp00 
=>00 
!00 
rp00 
.00 
	IsDeleted00 &
&&00' )
rp00* ,
.00, -

Permission00- 7
!=008 :
null00; ?
&&00@ B
rp00C E
.00E F

Permission00F P
.00P Q
IsActive00Q Y
&&00Z \
!00] ^
rp00^ `
.00` a

Permission00a k
.00k l
	IsDeleted00l u
)00u v
.11 
Select11 
(11 
rp11 
=>11 
rp11 
.11 

Permission11 '
!11' (
.11( )
Key11) ,
)11, -
.22 
ToListAsync22 
(22 
)22 
;22 
foreach44 
(44 
var44 
p44 
in44 
groupRolePerms44 (
)44( )
{55 	
permissions66 
.66 
Add66 
(66 
p66 
)66 
;66 
}77 	
var:: 
	overrides:: 
=:: 
await:: 
_context:: &
.::& '#
UserPermissionOverrides::' >
.;; 
Include;; 
(;; 
o;; 
=>;; 
o;; 
.;; 

Permission;; &
);;& '
.<< 
Where<< 
(<< 
o<< 
=><< 
o<< 
.<< 
UserId<<  
==<<! #
userId<<$ *
&&<<+ -
o<<. /
.<</ 0
	IsGranted<<0 9
&&<<: <
!<<= >
o<<> ?
.<<? @
	IsDeleted<<@ I
&&<<J L
o<<M N
.<<N O

Permission<<O Y
!=<<Z \
null<<] a
&&<<b d
o<<e f
.<<f g

Permission<<g q
.<<q r
IsActive<<r z
&&<<{ }
!<<~ 
o	<< Ä
.
<<Ä Å

Permission
<<Å ã
.
<<ã å
	IsDeleted
<<å ï
)
<<ï ñ
.== 
Select== 
(== 
o== 
=>== 
o== 
.== 

Permission== %
!==% &
.==& '
Key==' *
)==* +
.>> 
ToListAsync>> 
(>> 
)>> 
;>> 
foreach@@ 
(@@ 
var@@ 
p@@ 
in@@ 
	overrides@@ #
)@@# $
{AA 	
permissionsBB 
.BB 
AddBB 
(BB 
pBB 
)BB 
;BB 
}CC 	
returnEE 
permissionsEE 
;EE 
}FF 
}GG «%
g/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/NotificationService.cs
	namespace		 	
ItsTool		
 
.		 
Infrastructure		  
.		  !
Services		! )
;		) *
public 
class 
NotificationService  
:! " 
INotificationService# 7
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

NotificationService 
( 
ItsToolDbContext /
context0 7
)7 8
{ 
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
IEnumerable !
<! "
NotificationDto" 1
>1 2
>2 3%
GetUserNotificationsAsync4 M
(M N
intN Q
userIdR X
)X Y
{ 
var 
list 
= 
await 
_context !
.! "
Notifications" /
. 
Where 
( 
n 
=> 
n 
. 
UserId  
==! #
userId$ *
&&+ -
!. /
n/ 0
.0 1
	IsDeleted1 :
): ;
. 
OrderByDescending 
( 
n  
=>! #
n$ %
.% &
	CreatedAt& /
)/ 0
. 
ToListAsync 
( 
) 
; 
return 
list 
. 
Select 
( 
n 
=> 
new  #
NotificationDto$ 3
(3 4
n4 5
.5 6
Id6 8
,8 9
n: ;
.; <
UserId< B
,B C
nD E
.E F
TitleF K
,K L
nM N
.N O
MessageO V
,V W
nX Y
.Y Z
IsReadZ `
,` a
nb c
.c d
RelatedEntityIdd s
,s t
nu v
.v w
RelatedEntityType	w à
,
à â
n
ä ã
.
ã å
	CreatedAt
å ï
)
ï ñ
)
ñ ó
;
ó ò
} 
public 

async 
Task 
MarkAsReadAsync %
(% &
int& )
notificationId* 8
,8 9
int: =
userId> D
)D E
{ 
var   
notif   
=   
await   
_context   "
.  " #
Notifications  # 0
.  0 1
FirstOrDefaultAsync  1 D
(  D E
n  E F
=>  G I
n  J K
.  K L
Id  L N
==  O Q
notificationId  R `
&&  a c
n  d e
.  e f
UserId  f l
==  m o
userId  p v
&&  w y
!  z {
n  { |
.  | }
	IsDeleted	  } Ü
)
  Ü á
;
  á à
if!! 

(!! 
notif!! 
!=!! 
null!! 
&&!! 
!!! 
notif!! #
.!!# $
IsRead!!$ *
)!!* +
{"" 	
notif## 
.## 
IsRead## 
=## 
true## 
;##  
await$$ 
_context$$ 
.$$ 
SaveChangesAsync$$ +
($$+ ,
)$$, -
;$$- .
}%% 	
}&& 
public(( 

async(( 
Task(( 
MarkAllAsReadAsync(( (
(((( )
int(() ,
userId((- 3
)((3 4
{)) 
var** 
unread** 
=** 
await** 
_context** #
.**# $
Notifications**$ 1
.**1 2
Where**2 7
(**7 8
n**8 9
=>**: <
n**= >
.**> ?
UserId**? E
==**F H
userId**I O
&&**P R
!**S T
n**T U
.**U V
IsRead**V \
&&**] _
!**` a
n**a b
.**b c
	IsDeleted**c l
)**l m
.**m n
ToListAsync**n y
(**y z
)**z {
;**{ |
foreach++ 
(++ 
var++ 
n++ 
in++ 
unread++  
)++  !
{,, 	
n-- 
.-- 
IsRead-- 
=-- 
true-- 
;-- 
}.. 	
await// 
_context// 
.// 
SaveChangesAsync// '
(//' (
)//( )
;//) *
}00 
}11 º^
j/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/NotificationDispatcher.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public

 
class

 "
NotificationDispatcher

 #
:

$ %#
INotificationDispatcher

& =
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly 
IEmailService "
_emailService# 0
;0 1
private 
readonly 
IWebhookDispatcher '
_webhookDispatcher( :
;: ;
public 
"
NotificationDispatcher !
(! "
ItsToolDbContext" 2
context3 :
,: ;
IEmailService< I
emailServiceJ V
,V W
IWebhookDispatcherX j
webhookDispatcherk |
)| }
{ 
_context 
= 
context 
; 
_emailService 
= 
emailService $
;$ %
_webhookDispatcher 
= 
webhookDispatcher .
;. /
} 
public 

async 
Task 
DispatchEventAsync (
(( )
string) /
eventKey0 8
,8 9
int: =
ticketId> F
,F G
intH K
?K L
triggerUserIdM Z
=[ \
null] a
,a b
stringc i
?i j
additionalContextk |
=} ~
null	 É
)
É Ñ
{ 
var 
rules 
= 
await 
_context "
." #
NotificationRules# 4
. 
Where 
( 
r 
=> 
r 
. 
EventKey "
==# %
eventKey& .
&&/ 1
r2 3
.3 4
IsActive4 <
&&= ?
!@ A
rA B
.B C
	IsDeletedC L
)L M
. 
ToListAsync 
( 
) 
; 
if 

( 
rules 
. 
Count 
== 
$num 
) 
return $
;$ %
var 
ticket 
= 
await 
_context #
.# $
Tickets$ +
.+ ,
FirstOrDefaultAsync, ?
(? @
t@ A
=>B D
tE F
.F G
IdG I
==J L
ticketIdM U
&&V X
!Y Z
tZ [
.[ \
	IsDeleted\ e
)e f
;f g
if   

(   
ticket   
==   
null   
)   
return   "
;  " #
var"" 
targetUserIds"" 
="" 
await"" !!
GetTargetUserIdsAsync""" 7
(""7 8
rules""8 =
,""= >
ticket""? E
,""E F
triggerUserId""G T
)""T U
;""U V
await$$ %
ProcessNotificationsAsync$$ '
($$' (
targetUserIds$$( 5
,$$5 6
eventKey$$7 ?
,$$? @
ticket$$A G
,$$G H
additionalContext$$I Z
)$$Z [
;$$[ \
await&& 
_context&& 
.&& 
SaveChangesAsync&& '
(&&' (
)&&( )
;&&) *
await)) 
_webhookDispatcher))  
.))  !
DispatchEventAsync))! 3
())3 4
eventKey))4 <
,))< =
new))> A
{))B C
ticketId))D L
=))M N
ticketId))O W
,))W X
triggerUserId))Y f
=))g h
triggerUserId))i v
,))v w
context))x 
=
))Ä Å
additionalContext
))Ç ì
}
))î ï
)
))ï ñ
;
))ñ ó
}** 
private,, 
async,, 
Task,, 
<,, 
System,, 
.,, 
Collections,, )
.,,) *
Generic,,* 1
.,,1 2
HashSet,,2 9
<,,9 :
int,,: =
>,,= >
>,,> ?!
GetTargetUserIdsAsync,,@ U
(,,U V
System,,V \
.,,\ ]
Collections,,] h
.,,h i
Generic,,i p
.,,p q
IEnumerable,,q |
<,,| }
NotificationRule	,,} ç
>
,,ç é
rules
,,è î
,
,,î ï
Domain
,,ñ ú
.
,,ú ù
Entities
,,ù •
.
,,• ¶
Ticket
,,¶ ¨
.
,,¨ ≠
Ticket
,,≠ ≥
ticket
,,¥ ∫
,
,,∫ ª
int
,,º ø
?
,,ø ¿
triggerUserId
,,¡ Œ
)
,,Œ œ
{-- 
var.. 
targetUserIds.. 
=.. 
new.. 
System..  &
...& '
Collections..' 2
...2 3
Generic..3 :
...: ;
HashSet..; B
<..B C
int..C F
>..F G
(..G H
)..H I
;..I J
foreach00 
(00 
var00 
rule00 
in00 
rules00 "
)00" #
{11 	
switch22 
(22 
rule22 
.22 

TargetRole22 #
.22# $
ToLower22$ +
(22+ ,
)22, -
)22- .
{33 
case44 
$str44  
:44  !
targetUserIds55 !
.55! "
Add55" %
(55% &
ticket55& ,
.55, -
RequesterUserId55- <
)55< =
;55= >
break66 
;66 
case77 
$str77 
:77  
if88 
(88 
ticket88 
.88 
AssignedUserId88 -
.88- .
HasValue88. 6
)886 7
targetUserIds99 %
.99% &
Add99& )
(99) *
ticket99* 0
.990 1
AssignedUserId991 ?
.99? @
Value99@ E
)99E F
;99F G
break:: 
;:: 
case;; 
$str;; %
:;;% &
var<< 
members<< 
=<<  !
await<<" '
_context<<( 0
.<<0 1
ProjectMembers<<1 ?
.== 
Where== 
(== 
pm== !
=>==" $
pm==% '
.==' (
	ProjectId==( 1
====2 4
ticket==5 ;
.==; <
	ProjectId==< E
&&==F H
!==I J
pm==J L
.==L M
	IsDeleted==M V
)==V W
.>> 
ToListAsync>> $
(>>$ %
)>>% &
;>>& '
foreach?? 
(?? 
var??  
m??! "
in??# %
members??& -
)??- .
{@@ 
targetUserIdsAA %
.AA% &
AddAA& )
(AA) *
mAA* +
.AA+ ,
UserIdAA, 2
)AA2 3
;AA3 4
}BB 
breakCC 
;CC 
}DD 
}EE 	
ifGG 

(GG 
triggerUserIdGG 
.GG 
HasValueGG "
)GG" #
{HH 	
targetUserIdsII 
.II 
RemoveII  
(II  !
triggerUserIdII! .
.II. /
ValueII/ 4
)II4 5
;II5 6
}JJ 	
returnLL 
targetUserIdsLL 
;LL 
}MM 
privateOO 
asyncOO 
TaskOO %
ProcessNotificationsAsyncOO 0
(OO0 1
SystemOO1 7
.OO7 8
CollectionsOO8 C
.OOC D
GenericOOD K
.OOK L
HashSetOOL S
<OOS T
intOOT W
>OOW X
targetUserIdsOOY f
,OOf g
stringOOh n
eventKeyOOo w
,OOw x
DomainOOy 
.	OO Ä
Entities
OOÄ à
.
OOà â
Ticket
OOâ è
.
OOè ê
Ticket
OOê ñ
ticket
OOó ù
,
OOù û
string
OOü •
?
OO• ¶
additionalContext
OOß ∏
)
OO∏ π
{PP 
foreachQQ 
(QQ 
varQQ 
targetIdQQ 
inQQ  
targetUserIdsQQ! .
)QQ. /
{RR 	
varSS 
existsSS 
=SS 
awaitSS 
_contextSS '
.SS' (
NotificationsSS( 5
.SS5 6
AnyAsyncSS6 >
(SS> ?
nSS? @
=>SSA C
nTT 
.TT 
UserIdTT 
==TT 
targetIdTT $
&&TT% '
nUU 
.UU 
RelatedEntityIdUU !
==UU" $
ticketUU% +
.UU+ ,
IdUU, .
&&UU/ 1
nVV 
.VV 
RelatedEntityTypeVV #
==VV$ &
$strVV' /
&&VV0 2
nWW 
.WW 
TitleWW 
==WW 
eventKeyWW #
&&WW$ &
!XX 
nXX 
.XX 
	IsDeletedXX 
)XX 
;XX 
ifZZ 
(ZZ 
!ZZ 
existsZZ 
)ZZ 
{[[ 
_context\\ 
.\\ 
Notifications\\ &
.\\& '
Add\\' *
(\\* +
new\\+ .
Notification\\/ ;
{]] 
UserId^^ 
=^^ 
targetId^^ %
,^^% &
Title__ 
=__ 
eventKey__ $
,__$ %
Message`` 
=`` 
additionalContext`` /
??``0 2
$"``3 5
$str``5 ;
{``; <
eventKey``< D
}``D E
$str``E Y
{``Y Z
ticket``Z `
.``` a
TicketNumber``a m
}``m n
"``n o
,``o p
RelatedEntityIdaa #
=aa$ %
ticketaa& ,
.aa, -
Idaa- /
,aa/ 0
RelatedEntityTypebb %
=bb& '
$strbb( 0
}cc 
)cc 
;cc 
ifee 
(ee 
eventKeyee 
==ee 
$stree  1
||ee2 4
eventKeyee5 =
==ee> @
$streeA M
)eeM N
{ff 
awaitgg &
SendEmailNotificationAsyncgg 4
(gg4 5
targetIdgg5 =
,gg= >
eventKeygg? G
,ggG H
ticketggI O
,ggO P
additionalContextggQ b
)ggb c
;ggc d
}hh 
}ii 
}jj 	
}kk 
privatemm 
asyncmm 
Taskmm &
SendEmailNotificationAsyncmm 1
(mm1 2
intmm2 5
targetIdmm6 >
,mm> ?
stringmm@ F
eventKeymmG O
,mmO P
DomainmmQ W
.mmW X
EntitiesmmX `
.mm` a
Ticketmma g
.mmg h
Ticketmmh n
ticketmmo u
,mmu v
stringmmw }
?mm} ~
additionalContext	mm ê
)
mmê ë
{nn 
varoo 
uoo 
=oo 
awaitoo 
_contextoo 
.oo 
Usersoo $
.oo$ %
	FindAsyncoo% .
(oo. /
targetIdoo/ 7
)oo7 8
;oo8 9
ifpp 

(pp 
upp 
!=pp 
nullpp 
)pp 
{qq 	
awaitrr 
_emailServicerr 
.rr  
SendEmailAsyncrr  .
(rr. /
urr/ 0
.rr0 1
Emailrr1 6
,rr6 7
$"rr8 :
$strrr: M
{rrM N
eventKeyrrN V
}rrV W
"rrW X
,rrX Y
additionalContextrrZ k
??rrl n
$"rro q
$strrrq w
{rrw x
eventKey	rrx Ä
}
rrÄ Å
$str
rrÅ Ö
{
rrÖ Ü
ticket
rrÜ å
.
rrå ç
TicketNumber
rrç ô
}
rrô ö
"
rrö õ
)
rrõ ú
;
rrú ù
}ss 	
}tt 
}uu Ç$
k/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/LocalFileStorageService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class #
LocalFileStorageService $
:% &
IFileStorageService' :
{ 
private		 
readonly		 
string		 
	_basePath		 %
;		% &
public 
#
LocalFileStorageService "
(" #
IConfiguration# 1
configuration2 ?
)? @
{ 
	_basePath 
= 
configuration !
[! "
$str" 8
]8 9
??: <
$str= F
;F G
if 

( 
! 
	Directory 
. 
Exists 
( 
	_basePath '
)' (
)( )
{ 	
	Directory 
. 
CreateDirectory %
(% &
	_basePath& /
)/ 0
;0 1
} 	
} 
public 

async 
Task 
< 
string 
> 
SaveFileAsync +
(+ ,
	IFormFile, 5
file6 :
,: ;
int< ?
ticketId@ H
)H I
{ 
var 
allowedTypes 
= 
new 
[ 
]  
{! "
$str# /
,/ 0
$str1 <
,< =
$str> O
,O P
$str	Q ö
,
ö õ
$str
ú ﬂ
}
‡ ·
;
· ‚
if 

( 
! 
allowedTypes 
. 
Contains "
(" #
file# '
.' (
ContentType( 3
)3 4
)4 5
throw 
new %
InvalidOperationException /
(/ 0
$str0 H
)H I
;I J
if 

( 
file 
. 
Length 
> 
$num 
* 
$num #
*$ %
$num& *
)* +
throw 
new %
InvalidOperationException /
(/ 0
$str0 O
)O P
;P Q
var 
ticketFolder 
= 
Path 
.  
Combine  '
(' (
	_basePath( 1
,1 2
ticketId3 ;
.; <
ToString< D
(D E
)E F
)F G
;G H
if 

( 
! 
	Directory 
. 
Exists 
( 
ticketFolder *
)* +
)+ ,
	Directory 
. 
CreateDirectory %
(% &
ticketFolder& 2
)2 3
;3 4
var!! 
fileName!! 
=!! 
$"!! 
{!! 
Guid!! 
.!! 
NewGuid!! &
(!!& '
)!!' (
}!!( )
$str!!) *
{!!* +
file!!+ /
.!!/ 0
FileName!!0 8
}!!8 9
"!!9 :
;!!: ;
var"" 
filePath"" 
="" 
Path"" 
."" 
Combine"" #
(""# $
ticketFolder""$ 0
,""0 1
fileName""2 :
)"": ;
;""; <
using$$ 
($$ 
var$$ 
stream$$ 
=$$ 
new$$ 

FileStream$$  *
($$* +
filePath$$+ 3
,$$3 4
FileMode$$5 =
.$$= >
Create$$> D
)$$D E
)$$E F
{%% 	
await&& 
file&& 
.&& 
CopyToAsync&& "
(&&" #
stream&&# )
)&&) *
;&&* +
}'' 	
return)) 
filePath)) 
;)) 
}** 
public,, 

Task,, 
DeleteFileAsync,, 
(,,  
string,,  &
filePath,,' /
),,/ 0
{-- 
if.. 

(.. 
File.. 
... 
Exists.. 
(.. 
filePath..  
)..  !
)..! "
File// 
.// 
Delete// 
(// 
filePath//  
)//  !
;//! "
return00 
Task00 
.00 
CompletedTask00 !
;00! "
}11 
}22 îñ
h/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/KnowledgeBaseService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class  
KnowledgeBaseService !
:" #!
IKnowledgeBaseService$ 9
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly !
IPermissionCalculator *!
_permissionCalculator+ @
;@ A
public 
 
KnowledgeBaseService 
(  
ItsToolDbContext  0
context1 8
,8 9!
IPermissionCalculator: O 
permissionCalculatorP d
)d e
{ 
_context 
= 
context 
; !
_permissionCalculator 
=  
permissionCalculator  4
;4 5
} 
public 

async 
Task 
< 
IEnumerable !
<! "
KbCategoryDto" /
>/ 0
>0 1
GetCategoriesAsync2 D
(D E
)E F
{ 
var 
list 
= 
await 
_context !
.! "
KnowledgeCategories" 5
.5 6
Where6 ;
(; <
c< =
=>> @
!A B
cB C
.C D
	IsDeletedD M
)M N
.N O
ToListAsyncO Z
(Z [
)[ \
;\ ]
return 
list 
. 
Select 
( 
c 
=> 
new  #
KbCategoryDto$ 1
(1 2
c2 3
.3 4
Id4 6
,6 7
c8 9
.9 :
Name: >
,> ?
c@ A
.A B
ParentIdB J
)J K
)K L
;L M
} 
public 

async 
Task 
< 
KbCategoryDto #
># $
CreateCategoryAsync% 8
(8 9
CreateKbCategoryDto9 L
dtoM P
)P Q
{ 
var   
cat   
=   
new   
KnowledgeCategory   '
{  ( )
Name  * .
=  / 0
dto  1 4
.  4 5
Name  5 9
,  9 :
ParentId  ; C
=  D E
dto  F I
.  I J
ParentId  J R
}  S T
;  T U
_context!! 
.!! 
KnowledgeCategories!! $
.!!$ %
Add!!% (
(!!( )
cat!!) ,
)!!, -
;!!- .
await"" 
_context"" 
."" 
SaveChangesAsync"" '
(""' (
)""( )
;"") *
return## 
new## 
KbCategoryDto##  
(##  !
cat##! $
.##$ %
Id##% '
,##' (
cat##) ,
.##, -
Name##- 1
,##1 2
cat##3 6
.##6 7
ParentId##7 ?
)##? @
;##@ A
}$$ 
public&& 

async&& 
Task&& 
UpdateCategoryAsync&& )
(&&) *
int&&* -
id&&. 0
,&&0 1
CreateKbCategoryDto&&2 E
dto&&F I
)&&I J
{'' 
var(( 
cat(( 
=(( 
await(( 
_context((  
.((  !
KnowledgeCategories((! 4
.((4 5
FirstOrDefaultAsync((5 H
(((H I
c((I J
=>((K M
c((N O
.((O P
Id((P R
==((S U
id((V X
&&((Y [
!((\ ]
c((] ^
.((^ _
	IsDeleted((_ h
)((h i
;((i j
if)) 

()) 
cat)) 
==)) 
null)) 
))) 
throw)) 
new)) " 
KeyNotFoundException))# 7
())7 8
$str))8 M
)))M N
;))N O
cat** 
.** 
Name** 
=** 
dto** 
.** 
Name** 
;** 
cat++ 
.++ 
ParentId++ 
=++ 
dto++ 
.++ 
ParentId++ #
;++# $
await,, 
_context,, 
.,, 
SaveChangesAsync,, '
(,,' (
),,( )
;,,) *
}-- 
public// 

async// 
Task// 
DeleteCategoryAsync// )
(//) *
int//* -
id//. 0
)//0 1
{00 
var11 
cat11 
=11 
await11 
_context11  
.11  !
KnowledgeCategories11! 4
.114 5
FirstOrDefaultAsync115 H
(11H I
c11I J
=>11K M
c11N O
.11O P
Id11P R
==11S U
id11V X
&&11Y [
!11\ ]
c11] ^
.11^ _
	IsDeleted11_ h
)11h i
;11i j
if22 

(22 
cat22 
!=22 
null22 
)22 
{33 	
cat44 
.44 
	IsDeleted44 
=44 
true44  
;44  !
await55 
_context55 
.55 
SaveChangesAsync55 +
(55+ ,
)55, -
;55- .
}66 	
}77 
public99 

async99 
Task99 
<99 
IEnumerable99 !
<99! "
KbArticleSummaryDto99" 5
>995 6
>996 7
SearchArticlesAsync998 K
(99K L
int99L O
userId99P V
,99V W
string99X ^
?99^ _
keyword99` g
,99g h
int99i l
?99l m

categoryId99n x
)99x y
{:: 
var;; 
perms;; 
=;; 
await;; !
_permissionCalculator;; /
.;;/ 0.
"CalculateEffectivePermissionsAsync;;0 R
(;;R S
userId;;S Y
);;Y Z
;;;Z [
bool<< 
canManageKb<< 
=<< 
perms<<  
.<<  !
Contains<<! )
(<<) *
$str<<* 5
)<<5 6
;<<6 7
bool== 
isStaff== 
=== 
perms== 
.== 
Contains== %
(==% &
$str==& 5
)==5 6
||==7 9
perms==: ?
.==? @
Contains==@ H
(==H I
$str==I X
)==X Y
||==Z \
perms==] b
.==b c
Contains==c k
(==k l
$str==l y
)==y z
;==z {
var?? 
query?? 
=?? 
_context?? 
.?? 
KnowledgeArticles?? .
.@@ 
Where@@ 
(@@ 
a@@ 
=>@@ 
!@@ 
a@@ 
.@@ 
	IsDeleted@@ $
)@@$ %
;@@% &
ifBB 

(BB 
!BB 
canManageKbBB 
)BB 
{CC 	
queryDD 
=DD 
queryDD 
.DD 
WhereDD 
(DD  
aDD  !
=>DD" $
aDD% &
.DD& '
StatusDD' -
==DD. 0
ArticleStatusDD1 >
.DD> ?
	PublishedDD? H
)DDH I
;DDI J
}EE 	
ifGG 

(GG 
!GG 
isStaffGG 
&&GG 
!GG 
canManageKbGG $
)GG$ %
{HH 	
queryII 
=II 
queryII 
.II 
WhereII 
(II  
aII  !
=>II" $
aII% &
.II& '

VisibilityII' 1
==II2 4
ArticleVisibilityII5 F
.IIF G
PublicIIG M
)IIM N
;IIN O
}JJ 	
ifLL 

(LL 

categoryIdLL 
.LL 
HasValueLL 
)LL  
{MM 	
queryNN 
=NN 
queryNN 
.NN 
WhereNN 
(NN  
aNN  !
=>NN" $
aNN% &
.NN& '

CategoryIdNN' 1
==NN2 4

categoryIdNN5 ?
.NN? @
ValueNN@ E
)NNE F
;NNF G
}OO 	
ifQQ 

(QQ 
!QQ 
stringQQ 
.QQ 
IsNullOrWhiteSpaceQQ &
(QQ& '
keywordQQ' .
)QQ. /
)QQ/ 0
{RR 	
varSS 
kwSS 
=SS 
keywordSS 
;SS 
queryTT 
=TT 
queryTT 
.TT 
WhereTT 
(TT  
aTT  !
=>TT" $
aTT% &
.TT& '
TitleTT' ,
.TT, -
ContainsTT- 5
(TT5 6
kwTT6 8
,TT8 9
StringComparisonTT: J
.TTJ K
OrdinalIgnoreCaseTTK \
)TT\ ]
||TT^ `
aTTa b
.TTb c
ContentTTc j
.TTj k
ContainsTTk s
(TTs t
kwTTt v
,TTv w
StringComparison	TTx à
.
TTà â
OrdinalIgnoreCase
TTâ ö
)
TTö õ
)
TTõ ú
;
TTú ù
}UU 	
varWW 
listWW 
=WW 
awaitWW 
queryWW 
.WW 
OrderByDescendingWW 0
(WW0 1
aWW1 2
=>WW3 5
aWW6 7
.WW7 8
	CreatedAtWW8 A
)WWA B
.WWB C
ToListAsyncWWC N
(WWN O
)WWO P
;WWP Q
returnYY 
listYY 
.YY 
SelectYY 
(YY 
aYY 
=>YY 
newYY  #
KbArticleSummaryDtoYY$ 7
(YY7 8
aYY8 9
.YY9 :
IdYY: <
,YY< =
aYY> ?
.YY? @

CategoryIdYY@ J
,YYJ K
aYYL M
.YYM N
TitleYYN S
,YYS T
aYYU V
.YYV W
AuthorUserIdYYW c
,YYc d
aYYe f
.YYf g
StatusYYg m
,YYm n
aYYo p
.YYp q

VisibilityYYq {
,YY{ |
aYY} ~
.YY~ 
	ViewCount	YY à
,
YYà â
a
YYä ã
.
YYã å
	CreatedAt
YYå ï
)
YYï ñ
)
YYñ ó
;
YYó ò
}ZZ 
public\\ 

async\\ 
Task\\ 
<\\ 
KbArticleDto\\ "
?\\" #
>\\# $
GetArticleAsync\\% 4
(\\4 5
int\\5 8
id\\9 ;
,\\; <
int\\= @
userId\\A G
)\\G H
{]] 
var^^ 
perms^^ 
=^^ 
await^^ !
_permissionCalculator^^ /
.^^/ 0.
"CalculateEffectivePermissionsAsync^^0 R
(^^R S
userId^^S Y
)^^Y Z
;^^Z [
bool__ 
canManageKb__ 
=__ 
perms__  
.__  !
Contains__! )
(__) *
$str__* 5
)__5 6
;__6 7
bool`` 
isStaff`` 
=`` 
perms`` 
.`` 
Contains`` %
(``% &
$str``& 5
)``5 6
||``7 9
perms``: ?
.``? @
Contains``@ H
(``H I
$str``I X
)``X Y
||``Z \
perms``] b
.``b c
Contains``c k
(``k l
$str``l y
)``y z
;``z {
varbb 
articlebb 
=bb 
awaitbb 
_contextbb $
.bb$ %
KnowledgeArticlesbb% 6
.bb6 7
FirstOrDefaultAsyncbb7 J
(bbJ K
abbK L
=>bbM O
abbP Q
.bbQ R
IdbbR T
==bbU W
idbbX Z
&&bb[ ]
!bb^ _
abb_ `
.bb` a
	IsDeletedbba j
)bbj k
;bbk l
ifcc 

(cc 
articlecc 
==cc 
nullcc 
)cc 
returncc #
nullcc$ (
;cc( )
ifff 

(ff 
articleff 
.ff 
Statusff 
==ff 
ArticleStatusff +
.ff+ ,
Draftff, 1
&&ff2 4
!ff5 6
canManageKbff6 A
)ffA B
returnffC I
nullffJ N
;ffN O
ifgg 

(gg 
articlegg 
.gg 

Visibilitygg 
==gg !
ArticleVisibilitygg" 3
.gg3 4
Internalgg4 <
&&gg= ?
!gg@ A
isStaffggA H
&&ggI K
!ggL M
canManageKbggM X
)ggX Y
returnggZ `
nullgga e
;gge f
ifjj 

(jj 
articlejj 
.jj 
Statusjj 
==jj 
ArticleStatusjj +
.jj+ ,
	Publishedjj, 5
)jj5 6
{kk 	
articlell 
.ll 
	ViewCountll 
++ll 
;ll  
awaitmm 
_contextmm 
.mm 
SaveChangesAsyncmm +
(mm+ ,
)mm, -
;mm- .
}nn 	
returnpp 
newpp 
KbArticleDtopp 
(pp  
articlepp  '
.pp' (
Idpp( *
,pp* +
articlepp, 3
.pp3 4

CategoryIdpp4 >
,pp> ?
articlepp@ G
.ppG H
TitleppH M
,ppM N
articleppO V
.ppV W
ContentppW ^
,pp^ _
articlepp` g
.ppg h
AuthorUserIdpph t
,ppt u
articleppv }
.pp} ~
Status	pp~ Ñ
,
ppÑ Ö
article
ppÜ ç
.
ppç é

Visibility
ppé ò
,
ppò ô
article
ppö °
.
pp° ¢
	ViewCount
pp¢ ´
,
pp´ ¨
article
pp≠ ¥
.
pp¥ µ
	CreatedAt
ppµ æ
)
ppæ ø
;
ppø ¿
}qq 
publicss 

asyncss 
Taskss 
<ss 
KbArticleDtoss "
>ss" #
CreateArticleAsyncss$ 6
(ss6 7
CreateKbArticleDtoss7 I
dtossJ M
,ssM N
intssO R
authorIdssS [
)ss[ \
{tt 
varuu 
articleuu 
=uu 
newuu 
KnowledgeArticleuu *
{vv 	

CategoryIdww 
=ww 
dtoww 
.ww 

CategoryIdww '
,ww' (
Titlexx 
=xx 
dtoxx 
.xx 
Titlexx 
,xx 
Contentyy 
=yy 
dtoyy 
.yy 
Contentyy !
,yy! "
Statuszz 
=zz 
dtozz 
.zz 
Statuszz 
,zz  

Visibility{{ 
={{ 
dto{{ 
.{{ 

Visibility{{ '
,{{' (
AuthorUserId|| 
=|| 
authorId|| #
}}} 	
;}}	 

_context~~ 
.~~ 
KnowledgeArticles~~ "
.~~" #
Add~~# &
(~~& '
article~~' .
)~~. /
;~~/ 0
await 
_context 
. 
SaveChangesAsync '
(' (
)( )
;) *
return
ÅÅ 
new
ÅÅ 
KbArticleDto
ÅÅ 
(
ÅÅ  
article
ÅÅ  '
.
ÅÅ' (
Id
ÅÅ( *
,
ÅÅ* +
article
ÅÅ, 3
.
ÅÅ3 4

CategoryId
ÅÅ4 >
,
ÅÅ> ?
article
ÅÅ@ G
.
ÅÅG H
Title
ÅÅH M
,
ÅÅM N
article
ÅÅO V
.
ÅÅV W
Content
ÅÅW ^
,
ÅÅ^ _
article
ÅÅ` g
.
ÅÅg h
AuthorUserId
ÅÅh t
,
ÅÅt u
article
ÅÅv }
.
ÅÅ} ~
StatusÅÅ~ Ñ
,ÅÅÑ Ö
articleÅÅÜ ç
.ÅÅç é

VisibilityÅÅé ò
,ÅÅò ô
articleÅÅö °
.ÅÅ° ¢
	ViewCountÅÅ¢ ´
,ÅÅ´ ¨
articleÅÅ≠ ¥
.ÅÅ¥ µ
	CreatedAtÅÅµ æ
)ÅÅæ ø
;ÅÅø ¿
}
ÇÇ 
public
ÑÑ 

async
ÑÑ 
Task
ÑÑ  
UpdateArticleAsync
ÑÑ (
(
ÑÑ( )
int
ÑÑ) ,
id
ÑÑ- /
,
ÑÑ/ 0 
UpdateKbArticleDto
ÑÑ1 C
dto
ÑÑD G
)
ÑÑG H
{
ÖÖ 
var
ÜÜ 
article
ÜÜ 
=
ÜÜ 
await
ÜÜ 
_context
ÜÜ $
.
ÜÜ$ %
KnowledgeArticles
ÜÜ% 6
.
ÜÜ6 7!
FirstOrDefaultAsync
ÜÜ7 J
(
ÜÜJ K
a
ÜÜK L
=>
ÜÜM O
a
ÜÜP Q
.
ÜÜQ R
Id
ÜÜR T
==
ÜÜU W
id
ÜÜX Z
&&
ÜÜ[ ]
!
ÜÜ^ _
a
ÜÜ_ `
.
ÜÜ` a
	IsDeleted
ÜÜa j
)
ÜÜj k
;
ÜÜk l
if
áá 

(
áá 
article
áá 
==
áá 
null
áá 
)
áá 
throw
áá "
new
áá# &"
KeyNotFoundException
áá' ;
(
áá; <
$str
áá< P
)
ááP Q
;
ááQ R
article
ââ 
.
ââ 

CategoryId
ââ 
=
ââ 
dto
ââ  
.
ââ  !

CategoryId
ââ! +
;
ââ+ ,
article
ää 
.
ää 
Title
ää 
=
ää 
dto
ää 
.
ää 
Title
ää !
;
ää! "
article
ãã 
.
ãã 
Content
ãã 
=
ãã 
dto
ãã 
.
ãã 
Content
ãã %
;
ãã% &
article
åå 
.
åå 
Status
åå 
=
åå 
dto
åå 
.
åå 
Status
åå #
;
åå# $
article
çç 
.
çç 

Visibility
çç 
=
çç 
dto
çç  
.
çç  !

Visibility
çç! +
;
çç+ ,
await
éé 
_context
éé 
.
éé 
SaveChangesAsync
éé '
(
éé' (
)
éé( )
;
éé) *
}
èè 
public
ëë 

async
ëë 
Task
ëë  
DeleteArticleAsync
ëë (
(
ëë( )
int
ëë) ,
id
ëë- /
)
ëë/ 0
{
íí 
var
ìì 
article
ìì 
=
ìì 
await
ìì 
_context
ìì $
.
ìì$ %
KnowledgeArticles
ìì% 6
.
ìì6 7!
FirstOrDefaultAsync
ìì7 J
(
ììJ K
a
ììK L
=>
ììM O
a
ììP Q
.
ììQ R
Id
ììR T
==
ììU W
id
ììX Z
&&
ìì[ ]
!
ìì^ _
a
ìì_ `
.
ìì` a
	IsDeleted
ììa j
)
ììj k
;
ììk l
if
îî 

(
îî 
article
îî 
!=
îî 
null
îî 
)
îî 
{
ïï 	
article
ññ 
.
ññ 
	IsDeleted
ññ 
=
ññ 
true
ññ  $
;
ññ$ %
await
óó 
_context
óó 
.
óó 
SaveChangesAsync
óó +
(
óó+ ,
)
óó, -
;
óó- .
}
òò 	
}
ôô 
}öö Œ>
`/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/GroupService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public		 
class		 
GroupService		 
:		 
IGroupService		 )
{

 
private 
readonly 
IRepository  
<  !
Group! &
>& '
_repository( 3
;3 4
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

GroupService 
( 
IRepository #
<# $
Group$ )
>) *

repository+ 5
,5 6
ItsToolDbContext7 G
contextH O
)O P
{ 
_repository 
= 

repository  
;  !
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
IEnumerable !
<! "
GroupDto" *
>* +
>+ ,
GetAllAsync- 8
(8 9
)9 :
{ 
var 
groups 
= 
await 
_repository &
.& '
GetAllAsync' 2
(2 3
)3 4
;4 5
return 
groups 
. 
Select 
( 
g 
=> !
new" %
GroupDto& .
(. /
g/ 0
.0 1
Id1 3
,3 4
g5 6
.6 7
Name7 ;
,; <
g= >
.> ?
IsActive? G
,G H
gI J
.J K
DepartmentIdK W
??X Z
$num[ \
)\ ]
)] ^
;^ _
} 
public 

async 
Task 
< 
GroupDto 
? 
>  
GetByIdAsync! -
(- .
int. 1
id2 4
)4 5
{ 
var 
group 
= 
await 
_repository %
.% &
GetByIdAsync& 2
(2 3
id3 5
)5 6
;6 7
if 

( 
group 
== 
null 
) 
return !
null" &
;& '
return 
new 
GroupDto 
( 
group !
.! "
Id" $
,$ %
group& +
.+ ,
Name, 0
,0 1
group2 7
.7 8
IsActive8 @
,@ A
groupB G
.G H
DepartmentIdH T
??U W
$numX Y
)Y Z
;Z [
} 
public!! 

async!! 
Task!! 
<!! 
GroupDto!! 
>!! 
CreateAsync!!  +
(!!+ ,
CreateGroupDto!!, :
dto!!; >
)!!> ?
{"" 
var## 
group## 
=## 
new## 
Group## 
{$$ 	
Name%% 
=%% 
dto%% 
.%% 
Name%% 
,%% 
DepartmentId&& 
=&& 
dto&& 
.&& 
DepartmentId&& +
}'' 	
;''	 

await(( 
_repository(( 
.(( 
AddAsync(( "
(((" #
group((# (
)((( )
;(() *
return)) 
new)) 
GroupDto)) 
()) 
group)) !
.))! "
Id))" $
,))$ %
group))& +
.))+ ,
Name)), 0
,))0 1
group))2 7
.))7 8
IsActive))8 @
,))@ A
group))B G
.))G H
DepartmentId))H T
??))U W
$num))X Y
)))Y Z
;))Z [
}** 
public,, 

async,, 
Task,, 
UpdateAsync,, !
(,,! "
int,," %
id,,& (
,,,( )
UpdateGroupDto,,* 8
dto,,9 <
),,< =
{-- 
var.. 
group.. 
=.. 
await.. 
_repository.. %
...% &
GetByIdAsync..& 2
(..2 3
id..3 5
)..5 6
;..6 7
if// 

(// 
group// 
==// 
null// 
)// 
throw//  
new//! $ 
KeyNotFoundException//% 9
(//9 :
$str//: K
)//K L
;//L M
group11 
.11 
Name11 
=11 
dto11 
.11 
Name11 
;11 
group22 
.22 
IsActive22 
=22 
dto22 
.22 
IsActive22 %
;22% &
group33 
.33 
DepartmentId33 
=33 
dto33  
.33  !
DepartmentId33! -
;33- .
await44 
_repository44 
.44 
UpdateAsync44 %
(44% &
group44& +
)44+ ,
;44, -
}55 
public77 

async77 
Task77 
DeleteAsync77 !
(77! "
int77" %
id77& (
)77( )
{88 
await99 
_repository99 
.99 
DeleteAsync99 %
(99% &
id99& (
)99( )
;99) *
}:: 
public<< 

async<< 
Task<< 
AddMemberAsync<< $
(<<$ %
int<<% (
groupId<<) 0
,<<0 1
int<<2 5
userId<<6 <
)<<< =
{== 
var>> 
exists>> 
=>> 
await>> 
_context>> #
.>># $
GroupMembers>>$ 0
.>>0 1
AnyAsync>>1 9
(>>9 :
gm>>: <
=>>>= ?
gm>>@ B
.>>B C
GroupId>>C J
==>>K M
groupId>>N U
&&>>V X
gm>>Y [
.>>[ \
UserId>>\ b
==>>c e
userId>>f l
)>>l m
;>>m n
if?? 

(?? 
!?? 
exists?? 
)?? 
{@@ 	
_contextAA 
.AA 
GroupMembersAA !
.AA! "
AddAA" %
(AA% &
newAA& )
GroupMemberAA* 5
{AA6 7
GroupIdAA8 ?
=AA@ A
groupIdAAB I
,AAI J
UserIdAAK Q
=AAR S
userIdAAT Z
}AA[ \
)AA\ ]
;AA] ^
awaitBB 
_contextBB 
.BB 
SaveChangesAsyncBB +
(BB+ ,
)BB, -
;BB- .
}CC 	
}DD 
publicFF 

asyncFF 
TaskFF 
RemoveMemberAsyncFF '
(FF' (
intFF( +
groupIdFF, 3
,FF3 4
intFF5 8
userIdFF9 ?
)FF? @
{GG 
varHH 
memberHH 
=HH 
awaitHH 
_contextHH #
.HH# $
GroupMembersHH$ 0
.HH0 1
FirstOrDefaultAsyncHH1 D
(HHD E
gmHHE G
=>HHH J
gmHHK M
.HHM N
GroupIdHHN U
==HHV X
groupIdHHY `
&&HHa c
gmHHd f
.HHf g
UserIdHHg m
==HHn p
userIdHHq w
)HHw x
;HHx y
ifII 

(II 
memberII 
!=II 
nullII 
)II 
{JJ 	
_contextKK 
.KK 
GroupMembersKK !
.KK! "
RemoveKK" (
(KK( )
memberKK) /
)KK/ 0
;KK0 1
awaitLL 
_contextLL 
.LL 
SaveChangesAsyncLL +
(LL+ ,
)LL, -
;LL- .
}MM 	
}NN 
}OO éT
i/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/EmailIngestionService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class !
EmailIngestionService "
:# $"
IEmailIngestionService% ;
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 
!
EmailIngestionService  
(  !
ItsToolDbContext! 1
context2 9
)9 :
{ 
_context 
= 
context 
; 
} 
public 

async 
Task %
ProcessIncomingEmailAsync /
(/ 0
EmailIngestionDto0 A
dtoB E
)E F
{ 
if 

( 
string 
. 
IsNullOrEmpty  
(  !
dto! $
.$ %
	MessageId% .
). /
)/ 0
return1 7
;7 8
var 
existingTicket 
= 
await "
_context# +
.+ ,
Tickets, 3
.3 4
FirstOrDefaultAsync4 G
(G H
tH I
=>J L
tM N
.N O
ExternalMessageIdO `
==a c
dtod g
.g h
	MessageIdh q
)q r
;r s
if 

( 
existingTicket 
!= 
null "
)" #
return$ *
;* +
var!! 
user!! 
=!! 
await!! 
_context!! !
.!!! "
Users!!" '
.!!' (
FirstOrDefaultAsync!!( ;
(!!; <
u!!< =
=>!!> @
string!!A G
.!!G H
Equals!!H N
(!!N O
u!!O P
.!!P Q
Email!!Q V
,!!V W
dto!!X [
.!![ \
From!!\ `
,!!` a
StringComparison!!b r
.!!r s
OrdinalIgnoreCase	!!s Ñ
)
!!Ñ Ö
)
!!Ö Ü
;
!!Ü á
if"" 

("" 
user"" 
=="" 
null"" 
)"" 
{## 	
user$$ 
=$$ 
new$$ 
User$$ 
{%% 
Username&& 
=&& 
dto&& 
.&& 
From&& #
,&&# $
Email'' 
='' 
dto'' 
.'' 
From''  
,''  !
	FirstName(( 
=(( 
$str(( &
,((& '
LastName)) 
=)) 
$str)) !
,))! "
PasswordHash** 
=** 
BCrypt** %
.**% &
Net**& )
.**) *
BCrypt*** 0
.**0 1
HashPassword**1 =
(**= >
Guid**> B
.**B C
NewGuid**C J
(**J K
)**K L
.**L M
ToString**M U
(**U V
)**V W
)**W X
}++ 
;++ 
_context,, 
.,, 
Users,, 
.,, 
Add,, 
(,, 
user,, #
),,# $
;,,$ %
await-- 
_context-- 
.-- 
SaveChangesAsync-- +
(--+ ,
)--, -
;--- .
}.. 	
int11 
	projectId11 
=11 
$num11 
;11 
try22 
{33 	
var44 
match44 
=44 
Regex44 
.44 
Match44 #
(44# $
dto44$ '
.44' (
Subject44( /
,44/ 0
$str441 =
,44= >
RegexOptions44? K
.44K L
None44L P
,44P Q
TimeSpan44R Z
.44Z [
FromSeconds44[ f
(44f g
$num44g h
)44h i
)44i j
;44j k
if55 
(55 
match55 
.55 
Success55 
)55 
{66 
var77 
pKey77 
=77 
match77  
.77  !
Groups77! '
[77' (
$num77( )
]77) *
.77* +
Value77+ 0
.770 1
ToUpper771 8
(778 9
)779 :
;77: ;
var88 
project88 
=88 
await88 #
_context88$ ,
.88, -
Projects88- 5
.885 6
FirstOrDefaultAsync886 I
(88I J
p88J K
=>88L N
p88O P
.88P Q

ProjectKey88Q [
==88\ ^
pKey88_ c
)88c d
;88d e
if99 
(99 
project99 
!=99 
null99 #
)99# $
{:: 
	projectId;; 
=;; 
project;;  '
.;;' (
Id;;( *
;;;* +
}<< 
}== 
}>> 	
catch?? 
(?? &
RegexMatchTimeoutException?? )
)??) *
{@@ 	
}BB 	
varEE 
projEE 
=EE 
awaitEE 
_contextEE !
.EE! "
ProjectsEE" *
.EE* +
	FindAsyncEE+ 4
(EE4 5
	projectIdEE5 >
)EE> ?
;EE? @
varFF 
seqFF 
=FF 
awaitFF 
_contextFF  
.FF  !
ProjectSequencesFF! 1
.FF1 2
FirstOrDefaultAsyncFF2 E
(FFE F
sFFF G
=>FFH J
sFFK L
.FFL M
	ProjectIdFFM V
==FFW Y
	projectIdFFZ c
)FFc d
;FFd e
ifGG 

(GG 
seqGG 
==GG 
nullGG 
)GG 
{GG 
seqHH 
=HH 
newHH 
ItsToolHH 
.HH 
DomainHH $
.HH$ %
EntitiesHH% -
.HH- .
ProjectHH. 5
.HH5 6
ProjectSequenceHH6 E
{HHF G
	ProjectIdHHH Q
=HHR S
	projectIdHHT ]
,HH] ^
CurrentValueHH_ k
=HHl m
$numHHn o
}HHp q
;HHq r
_contextII 
.II 
ProjectSequencesII %
.II% &
AddII& )
(II) *
seqII* -
)II- .
;II. /
}JJ 	
seqKK 
.KK 
CurrentValueKK 
++KK 
;KK 
varLL 
tNumberLL 
=LL 
$"LL 
{LL 
projLL 
?LL 
.LL 

ProjectKeyLL )
??LL* ,
$strLL- 0
}LL0 1
$strLL1 2
{LL2 3
seqLL3 6
.LL6 7
CurrentValueLL7 C
}LLC D
"LLD E
;LLE F
varOO 
categoryOO 
=OO 
awaitOO 
_contextOO %
.OO% &

CategoriesOO& 0
.OO0 1
FirstOrDefaultAsyncOO1 D
(OOD E
)OOE F
;OOF G
varPP 
typePP 
=PP 
awaitPP 
_contextPP !
.PP! "
TicketTypesPP" -
.PP- .
FirstOrDefaultAsyncPP. A
(PPA B
)PPB C
;PPC D
varQQ 
priorityQQ 
=QQ 
awaitQQ 
_contextQQ %
.QQ% &

PrioritiesQQ& 0
.QQ0 1
FirstOrDefaultAsyncQQ1 D
(QQD E
)QQE F
;QQF G
varRR 
statusRR 
=RR 
awaitRR 
_contextRR #
.RR# $
StatusesRR$ ,
.RR, -
FirstOrDefaultAsyncRR- @
(RR@ A
sRRA B
=>RRC E
sRRF G
.RRG H
IsSystemDefaultRRH W
)RRW X
;RRX Y
ifTT 

(TT 
categoryTT 
==TT 
nullTT 
||TT 
typeTT  $
==TT% '
nullTT( ,
||TT- /
priorityTT0 8
==TT9 ;
nullTT< @
||TTA C
statusTTD J
==TTK M
nullTTN R
)TTR S
{UU 	
throwVV 
newVV %
InvalidOperationExceptionVV /
(VV/ 0
$strVV0 i
)VVi j
;VVj k
}WW 	
varZZ 
ticketZZ 
=ZZ 
newZZ 
TicketZZ 
{[[ 	
TicketNumber\\ 
=\\ 
tNumber\\ "
,\\" #
Title]] 
=]] 
string]] 
.]] 
IsNullOrWhiteSpace]] -
(]]- .
dto]]. 1
.]]1 2
Subject]]2 9
)]]9 :
?]]; <
$str]]= K
:]]L M
dto]]N Q
.]]Q R
Subject]]R Y
,]]Y Z
Description^^ 
=^^ 
dto^^ 
.^^ 
Body^^ "
,^^" #
	ProjectId__ 
=__ 
	projectId__ !
,__! "

CategoryId`` 
=`` 
category`` !
.``! "
Id``" $
,``$ %
TypeIdaa 
=aa 
typeaa 
.aa 
Idaa 
,aa 

PriorityIdbb 
=bb 
prioritybb !
.bb! "
Idbb" $
,bb$ %
StatusIdcc 
=cc 
statuscc 
.cc 
Idcc  
,cc  !
RequesterUserIddd 
=dd 
userdd "
.dd" #
Iddd# %
,dd% &
ExternalMessageIdee 
=ee 
dtoee  #
.ee# $
	MessageIdee$ -
}ff 	
;ff	 

_contexthh 
.hh 
Ticketshh 
.hh 
Addhh 
(hh 
tickethh #
)hh# $
;hh$ %
awaitii 
_contextii 
.ii 
SaveChangesAsyncii '
(ii' (
)ii( )
;ii) *
_contextkk 
.kk 
TicketHistorieskk  
.kk  !
Addkk! $
(kk$ %
newkk% (
TicketHistorykk) 6
{ll 	
TicketIdmm 
=mm 
ticketmm 
.mm 
Idmm  
,mm  !
Actionnn 
=nn 
$strnn &
,nn& '
	FieldNameoo 
=oo 
$stroo  
,oo  !
NewValuepp 
=pp 
dtopp 
.pp 
	MessageIdpp $
,pp$ %
	CreatedByqq 
=qq 
userqq 
.qq 
Idqq 
.qq  
ToStringqq  (
(qq( )
)qq) *
}rr 	
)rr	 

;rr
 
awaittt 
_contexttt 
.tt 
SaveChangesAsynctt '
(tt' (
)tt( )
;tt) *
}xx 
}yy ∫¬
f/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/DynamicFormService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public		 
class		 
DynamicFormService		 
:		  !
IDynamicFormService		" 5
{

 
private 
readonly 
IRepository  
<  !
FieldDefinition! 0
>0 1
_defRepo2 :
;: ;
private 
readonly 
IRepository  
<  !
FieldOption! ,
>, -
_optRepo. 6
;6 7
private 
readonly 
IRepository  
<  !
FormFieldPlacement! 3
>3 4
_placementRepo5 C
;C D
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

DynamicFormService 
( 
IRepository 
< 
FieldDefinition #
># $
defRepo% ,
,, -
IRepository 
< 
FieldOption 
>  
optRepo! (
,( )
IRepository 
< 
FormFieldPlacement &
>& '
placementRepo( 5
,5 6
ItsToolDbContext 
context  
)  !
{ 
_defRepo 
= 
defRepo 
; 
_optRepo 
= 
optRepo 
; 
_placementRepo 
= 
placementRepo &
;& '
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
IEnumerable !
<! "
FieldDefinitionDto" 4
>4 5
>5 6$
GetFieldDefinitionsAsync7 O
(O P
)P Q
{ 
var 
list 
= 
await 
_defRepo !
.! "
GetAllAsync" -
(- .
). /
;/ 0
return 
list 
. 
Select 
( 
f 
=> 
new  #
FieldDefinitionDto$ 6
(6 7
f7 8
.8 9
Id9 ;
,; <
f= >
.> ?
Key? B
,B C
fD E
.E F
LabelF K
,K L
fM N
.N O
	FieldTypeO X
.X Y
ToStringY a
(a b
)b c
,c d
fe f
.f g
ValidationRegexg v
,v w
fx y
.y z
IsActive	z Ç
)
Ç É
)
É Ñ
;
Ñ Ö
}   
public"" 

async"" 
Task"" 
<"" 
FieldDefinitionDto"" (
?""( )
>"") *'
GetFieldDefinitionByIdAsync""+ F
(""F G
int""G J
id""K M
)""M N
{## 
var$$ 
f$$ 
=$$ 
await$$ 
_defRepo$$ 
.$$ 
GetByIdAsync$$ +
($$+ ,
id$$, .
)$$. /
;$$/ 0
if%% 

(%% 
f%% 
==%% 
null%% 
)%% 
return%% 
null%% "
;%%" #
return&& 
new&& 
FieldDefinitionDto&& %
(&&% &
f&&& '
.&&' (
Id&&( *
,&&* +
f&&, -
.&&- .
Key&&. 1
,&&1 2
f&&3 4
.&&4 5
Label&&5 :
,&&: ;
f&&< =
.&&= >
	FieldType&&> G
.&&G H
ToString&&H P
(&&P Q
)&&Q R
,&&R S
f&&T U
.&&U V
ValidationRegex&&V e
,&&e f
f&&g h
.&&h i
IsActive&&i q
)&&q r
;&&r s
}'' 
public)) 

async)) 
Task)) 
<)) 
FieldDefinitionDto)) (
>))( )&
CreateFieldDefinitionAsync))* D
())D E$
CreateFieldDefinitionDto))E ]
dto))^ a
)))a b
{** 
var++ 
exists++ 
=++ 
await++ 
_context++ #
.++# $
FieldDefinitions++$ 4
.++4 5
AnyAsync++5 =
(++= >
f++> ?
=>++@ B
f++C D
.++D E
Key++E H
==++I K
dto++L O
.++O P
Key++P S
&&++T V
!++W X
f++X Y
.++Y Z
	IsDeleted++Z c
)++c d
;++d e
if,, 

(,, 
exists,, 
),, 
throw,, 
new,, %
InvalidOperationException,, 7
(,,7 8
$str,,8 ^
),,^ _
;,,_ `
if.. 

(.. 
!.. 
Enum.. 
... 
TryParse.. 
<.. 
	FieldType.. $
>..$ %
(..% &
dto..& )
...) *
	FieldType..* 3
,..3 4
true..5 9
,..9 :
out..; >
var..? B
fType..C H
)..H I
)..I J
throw..K P
new..Q T
ArgumentException..U f
(..f g
$str..g z
)..z {
;..{ |
var00 
f00 
=00 
new00 
FieldDefinition00 #
{00$ %
Key00& )
=00* +
dto00, /
.00/ 0
Key000 3
,003 4
Label005 :
=00; <
dto00= @
.00@ A
Label00A F
,00F G
	FieldType00H Q
=00R S
fType00T Y
,00Y Z
ValidationRegex00[ j
=00k l
dto00m p
.00p q
ValidationRegex	00q Ä
}
00Å Ç
;
00Ç É
await11 
_defRepo11 
.11 
AddAsync11 
(11  
f11  !
)11! "
;11" #
return22 
new22 
FieldDefinitionDto22 %
(22% &
f22& '
.22' (
Id22( *
,22* +
f22, -
.22- .
Key22. 1
,221 2
f223 4
.224 5
Label225 :
,22: ;
f22< =
.22= >
	FieldType22> G
.22G H
ToString22H P
(22P Q
)22Q R
,22R S
f22T U
.22U V
ValidationRegex22V e
,22e f
f22g h
.22h i
IsActive22i q
)22q r
;22r s
}33 
public55 

async55 
Task55 &
UpdateFieldDefinitionAsync55 0
(550 1
int551 4
id555 7
,557 8$
UpdateFieldDefinitionDto559 Q
dto55R U
)55U V
{66 
var77 
f77 
=77 
await77 
_defRepo77 
.77 
GetByIdAsync77 +
(77+ ,
id77, .
)77. /
;77/ 0
if88 

(88 
f88 
==88 
null88 
)88 
throw88 
new88   
KeyNotFoundException88! 5
(885 6
$str886 Q
)88Q R
;88R S
var:: 
exists:: 
=:: 
await:: 
_context:: #
.::# $
FieldDefinitions::$ 4
.::4 5
AnyAsync::5 =
(::= >
fd::> @
=>::A C
fd::D F
.::F G
Key::G J
==::K M
dto::N Q
.::Q R
Key::R U
&&::V X
fd::Y [
.::[ \
Id::\ ^
!=::_ a
id::b d
&&::e g
!::h i
fd::i k
.::k l
	IsDeleted::l u
)::u v
;::v w
if;; 

(;; 
exists;; 
);; 
throw;; 
new;; %
InvalidOperationException;; 7
(;;7 8
$str;;8 ^
);;^ _
;;;_ `
if== 

(== 
!== 
Enum== 
.== 
TryParse== 
<== 
	FieldType== $
>==$ %
(==% &
dto==& )
.==) *
	FieldType==* 3
,==3 4
true==5 9
,==9 :
out==; >
var==? B
fType==C H
)==H I
)==I J
throw==K P
new==Q T
ArgumentException==U f
(==f g
$str==g z
)==z {
;=={ |
f?? 	
.??	 

Key??
 
=?? 
dto?? 
.?? 
Key?? 
;?? 
f?? 
.?? 
Label??  
=??! "
dto??# &
.??& '
Label??' ,
;??, -
f??. /
.??/ 0
	FieldType??0 9
=??: ;
fType??< A
;??A B
f??C D
.??D E
ValidationRegex??E T
=??U V
dto??W Z
.??Z [
ValidationRegex??[ j
;??j k
f??l m
.??m n
IsActive??n v
=??w x
dto??y |
.??| }
IsActive	??} Ö
;
??Ö Ü
await@@ 
_defRepo@@ 
.@@ 
UpdateAsync@@ "
(@@" #
f@@# $
)@@$ %
;@@% &
}AA 
publicCC 

asyncCC 
TaskCC &
DeleteFieldDefinitionAsyncCC 0
(CC0 1
intCC1 4
idCC5 7
)CC7 8
=>CC9 ;
awaitCC< A
_defRepoCCB J
.CCJ K
DeleteAsyncCCK V
(CCV W
idCCW Y
)CCY Z
;CCZ [
publicEE 

asyncEE 
TaskEE 
<EE 
IEnumerableEE !
<EE! "
FieldOptionDtoEE" 0
>EE0 1
>EE1 2 
GetFieldOptionsAsyncEE3 G
(EEG H
intEEH K
fieldDefinitionIdEEL ]
)EE] ^
{FF 
varGG 
listGG 
=GG 
awaitGG 
_optRepoGG !
.GG! "
GetAllAsyncGG" -
(GG- .
oGG. /
=>GG0 2
oGG3 4
.GG4 5
FieldDefinitionIdGG5 F
==GGG I
fieldDefinitionIdGGJ [
)GG[ \
;GG\ ]
returnHH 
listHH 
.HH 
SelectHH 
(HH 
oHH 
=>HH 
newHH  #
FieldOptionDtoHH$ 2
(HH2 3
oHH3 4
.HH4 5
IdHH5 7
,HH7 8
oHH9 :
.HH: ;
FieldDefinitionIdHH; L
,HHL M
oHHN O
.HHO P
ValueHHP U
,HHU V
oHHW X
.HHX Y
LabelHHY ^
,HH^ _
oHH` a
.HHa b
	SortOrderHHb k
,HHk l
oHHm n
.HHn o
IsActiveHHo w
)HHw x
)HHx y
;HHy z
}II 
publicKK 

asyncKK 
TaskKK 
<KK 
FieldOptionDtoKK $
?KK$ %
>KK% &#
GetFieldOptionByIdAsyncKK' >
(KK> ?
intKK? B
idKKC E
)KKE F
{LL 
varMM 
oMM 
=MM 
awaitMM 
_optRepoMM 
.MM 
GetByIdAsyncMM +
(MM+ ,
idMM, .
)MM. /
;MM/ 0
ifNN 

(NN 
oNN 
==NN 
nullNN 
)NN 
returnNN 
nullNN "
;NN" #
returnOO 
newOO 
FieldOptionDtoOO !
(OO! "
oOO" #
.OO# $
IdOO$ &
,OO& '
oOO( )
.OO) *
FieldDefinitionIdOO* ;
,OO; <
oOO= >
.OO> ?
ValueOO? D
,OOD E
oOOF G
.OOG H
LabelOOH M
,OOM N
oOOO P
.OOP Q
	SortOrderOOQ Z
,OOZ [
oOO\ ]
.OO] ^
IsActiveOO^ f
)OOf g
;OOg h
}PP 
publicRR 

asyncRR 
TaskRR 
<RR 
FieldOptionDtoRR $
>RR$ %"
CreateFieldOptionAsyncRR& <
(RR< = 
CreateFieldOptionDtoRR= Q
dtoRRR U
)RRU V
{SS 
varTT 
oTT 
=TT 
newTT 
FieldOptionTT 
{TT  !
FieldDefinitionIdTT" 3
=TT4 5
dtoTT6 9
.TT9 :
FieldDefinitionIdTT: K
,TTK L
ValueTTM R
=TTS T
dtoTTU X
.TTX Y
ValueTTY ^
,TT^ _
LabelTT` e
=TTf g
dtoTTh k
.TTk l
LabelTTl q
,TTq r
	SortOrderTTs |
=TT} ~
dto	TT Ç
.
TTÇ É
	SortOrder
TTÉ å
}
TTç é
;
TTé è
awaitUU 
_optRepoUU 
.UU 
AddAsyncUU 
(UU  
oUU  !
)UU! "
;UU" #
returnVV 
newVV 
FieldOptionDtoVV !
(VV! "
oVV" #
.VV# $
IdVV$ &
,VV& '
oVV( )
.VV) *
FieldDefinitionIdVV* ;
,VV; <
oVV= >
.VV> ?
ValueVV? D
,VVD E
oVVF G
.VVG H
LabelVVH M
,VVM N
oVVO P
.VVP Q
	SortOrderVVQ Z
,VVZ [
oVV\ ]
.VV] ^
IsActiveVV^ f
)VVf g
;VVg h
}WW 
publicYY 

asyncYY 
TaskYY "
UpdateFieldOptionAsyncYY ,
(YY, -
intYY- 0
idYY1 3
,YY3 4 
UpdateFieldOptionDtoYY5 I
dtoYYJ M
)YYM N
{ZZ 
var[[ 
o[[ 
=[[ 
await[[ 
_optRepo[[ 
.[[ 
GetByIdAsync[[ +
([[+ ,
id[[, .
)[[. /
;[[/ 0
if\\ 

(\\ 
o\\ 
==\\ 
null\\ 
)\\ 
throw\\ 
new\\   
KeyNotFoundException\\! 5
(\\5 6
$str\\6 M
)\\M N
;\\N O
o]] 	
.]]	 

Value]]
 
=]] 
dto]] 
.]] 
Value]] 
;]] 
o]] 
.]] 
Label]] $
=]]% &
dto]]' *
.]]* +
Label]]+ 0
;]]0 1
o]]2 3
.]]3 4
	SortOrder]]4 =
=]]> ?
dto]]@ C
.]]C D
	SortOrder]]D M
;]]M N
o]]O P
.]]P Q
IsActive]]Q Y
=]]Z [
dto]]\ _
.]]_ `
IsActive]]` h
;]]h i
await^^ 
_optRepo^^ 
.^^ 
UpdateAsync^^ "
(^^" #
o^^# $
)^^$ %
;^^% &
}__ 
publicaa 

asyncaa 
Taskaa "
DeleteFieldOptionAsyncaa ,
(aa, -
intaa- 0
idaa1 3
)aa3 4
=>aa5 7
awaitaa8 =
_optRepoaa> F
.aaF G
DeleteAsyncaaG R
(aaR S
idaaS U
)aaU V
;aaV W
publiccc 

asynccc 
Taskcc 
<cc 
IEnumerablecc !
<cc! "!
FormFieldPlacementDtocc" 7
>cc7 8
>cc8 9
GetPlacementsAsynccc: L
(ccL M
intccM P
?ccP Q
	projectIdccR [
,cc[ \
intcc] `
?cc` a

categoryIdccb l
,ccl m
intccn q
?ccq r
ticketTypeIdccs 
)	cc Ä
{dd 
varee 
listee 
=ee 
awaitee 
_placementRepoee '
.ee' (
GetAllAsyncee( 3
(ee3 4
pee4 5
=>ee6 8
pff 
.ff 
	ProjectIdff 
==ff 
	projectIdff $
&&ff% '
pff( )
.ff) *

CategoryIdff* 4
==ff5 7

categoryIdff8 B
&&ffC E
pffF G
.ffG H
TicketTypeIdffH T
==ffU W
ticketTypeIdffX d
)ffd e
;ffe f
returngg 
listgg 
.gg 
Selectgg 
(gg 
pgg 
=>gg 
newgg  #!
FormFieldPlacementDtogg$ 9
(gg9 :
pgg: ;
.gg; <
Idgg< >
,gg> ?
pgg@ A
.ggA B
FieldDefinitionIdggB S
,ggS T
pggU V
.ggV W
	ProjectIdggW `
,gg` a
pggb c
.ggc d

CategoryIdggd n
,ggn o
pggp q
.ggq r
TicketTypeIdggr ~
,gg~ 
p
ggÄ Å
.
ggÅ Ç
	SortOrder
ggÇ ã
,
ggã å
p
ggç é
.
ggé è

IsRequired
ggè ô
,
ggô ö
p
ggõ ú
.
ggú ù
IsActive
ggù •
)
gg• ¶
)
gg¶ ß
;
ggß ®
}hh 
publicjj 

asyncjj 
Taskjj 
<jj !
FormFieldPlacementDtojj +
?jj+ ,
>jj, -!
GetPlacementByIdAsyncjj. C
(jjC D
intjjD G
idjjH J
)jjJ K
{kk 
varll 
pll 
=ll 
awaitll 
_placementRepoll $
.ll$ %
GetByIdAsyncll% 1
(ll1 2
idll2 4
)ll4 5
;ll5 6
ifmm 

(mm 
pmm 
==mm 
nullmm 
)mm 
returnmm 
nullmm "
;mm" #
returnnn 
newnn !
FormFieldPlacementDtonn (
(nn( )
pnn) *
.nn* +
Idnn+ -
,nn- .
pnn/ 0
.nn0 1
FieldDefinitionIdnn1 B
,nnB C
pnnD E
.nnE F
	ProjectIdnnF O
,nnO P
pnnQ R
.nnR S

CategoryIdnnS ]
,nn] ^
pnn_ `
.nn` a
TicketTypeIdnna m
,nnm n
pnno p
.nnp q
	SortOrdernnq z
,nnz {
pnn| }
.nn} ~

IsRequired	nn~ à
,
nnà â
p
nnä ã
.
nnã å
IsActive
nnå î
)
nnî ï
;
nnï ñ
}oo 
publicqq 

asyncqq 
Taskqq 
<qq !
FormFieldPlacementDtoqq +
>qq+ , 
CreatePlacementAsyncqq- A
(qqA B'
CreateFormFieldPlacementDtoqqB ]
dtoqq^ a
)qqa b
{rr 
varss 
existsss 
=ss 
awaitss 
_contextss #
.ss# $
FormFieldPlacementsss$ 7
.ss7 8
AnyAsyncss8 @
(ss@ A
pssA B
=>ssC E
ptt 
.tt 
FieldDefinitionIdtt 
==tt  "
dtott# &
.tt& '
FieldDefinitionIdtt' 8
&&tt9 ;
puu 
.uu 
	ProjectIduu 
==uu 
dtouu 
.uu 
	ProjectIduu (
&&uu) +
pvv 
.vv 

CategoryIdvv 
==vv 
dtovv 
.vv  

CategoryIdvv  *
&&vv+ -
pww 
.ww 
TicketTypeIdww 
==ww 
dtoww !
.ww! "
TicketTypeIdww" .
&&ww/ 1
!xx 
pxx 
.xx 
	IsDeletedxx 
)xx 
;xx 
ifzz 

(zz 
existszz 
)zz 
throwzz 
newzz %
InvalidOperationExceptionzz 7
(zz7 8
$strzz8 e
)zze f
;zzf g
var|| 
p|| 
=|| 
new|| 
FormFieldPlacement|| &
{||' (
FieldDefinitionId||) :
=||; <
dto||= @
.||@ A
FieldDefinitionId||A R
,||R S
	ProjectId||T ]
=||^ _
dto||` c
.||c d
	ProjectId||d m
,||m n

CategoryId||o y
=||z {
dto||| 
.	|| Ä

CategoryId
||Ä ä
,
||ä ã
TicketTypeId
||å ò
=
||ô ö
dto
||õ û
.
||û ü
TicketTypeId
||ü ´
,
||´ ¨
	SortOrder
||≠ ∂
=
||∑ ∏
dto
||π º
.
||º Ω
	SortOrder
||Ω ∆
,
||∆ «

IsRequired
||» “
=
||” ‘
dto
||’ ÿ
.
||ÿ Ÿ

IsRequired
||Ÿ „
}
||‰ Â
;
||Â Ê
await}} 
_placementRepo}} 
.}} 
AddAsync}} %
(}}% &
p}}& '
)}}' (
;}}( )
return~~ 
new~~ !
FormFieldPlacementDto~~ (
(~~( )
p~~) *
.~~* +
Id~~+ -
,~~- .
p~~/ 0
.~~0 1
FieldDefinitionId~~1 B
,~~B C
p~~D E
.~~E F
	ProjectId~~F O
,~~O P
p~~Q R
.~~R S

CategoryId~~S ]
,~~] ^
p~~_ `
.~~` a
TicketTypeId~~a m
,~~m n
p~~o p
.~~p q
	SortOrder~~q z
,~~z {
p~~| }
.~~} ~

IsRequired	~~~ à
,
~~à â
p
~~ä ã
.
~~ã å
IsActive
~~å î
)
~~î ï
;
~~ï ñ
} 
public
ÅÅ 

async
ÅÅ 
Task
ÅÅ "
UpdatePlacementAsync
ÅÅ *
(
ÅÅ* +
int
ÅÅ+ .
id
ÅÅ/ 1
,
ÅÅ1 2)
UpdateFormFieldPlacementDto
ÅÅ3 N
dto
ÅÅO R
)
ÅÅR S
{
ÇÇ 
var
ÉÉ 
p
ÉÉ 
=
ÉÉ 
await
ÉÉ 
_placementRepo
ÉÉ $
.
ÉÉ$ %
GetByIdAsync
ÉÉ% 1
(
ÉÉ1 2
id
ÉÉ2 4
)
ÉÉ4 5
;
ÉÉ5 6
if
ÑÑ 

(
ÑÑ 
p
ÑÑ 
==
ÑÑ 
null
ÑÑ 
)
ÑÑ 
throw
ÑÑ 
new
ÑÑ  "
KeyNotFoundException
ÑÑ! 5
(
ÑÑ5 6
$str
ÑÑ6 T
)
ÑÑT U
;
ÑÑU V
var
ÜÜ 
exists
ÜÜ 
=
ÜÜ 
await
ÜÜ 
_context
ÜÜ #
.
ÜÜ# $!
FormFieldPlacements
ÜÜ$ 7
.
ÜÜ7 8
AnyAsync
ÜÜ8 @
(
ÜÜ@ A
fp
ÜÜA C
=>
ÜÜD F
fp
áá 
.
áá 
Id
áá 
!=
áá 
id
áá 
&&
áá 
fp
àà 
.
àà 
FieldDefinitionId
àà  
==
àà! #
p
àà$ %
.
àà% &
FieldDefinitionId
àà& 7
&&
àà8 :
fp
ââ 
.
ââ 
	ProjectId
ââ 
==
ââ 
dto
ââ 
.
ââ  
	ProjectId
ââ  )
&&
ââ* ,
fp
ää 
.
ää 

CategoryId
ää 
==
ää 
dto
ää  
.
ää  !

CategoryId
ää! +
&&
ää, .
fp
ãã 
.
ãã 
TicketTypeId
ãã 
==
ãã 
dto
ãã "
.
ãã" #
TicketTypeId
ãã# /
&&
ãã0 2
!
åå 
fp
åå 
.
åå 
	IsDeleted
åå 
)
åå 
;
åå 
if
éé 

(
éé 
exists
éé 
)
éé 
throw
éé 
new
éé '
InvalidOperationException
éé 7
(
éé7 8
$str
éé8 e
)
éée f
;
ééf g
p
êê 	
.
êê	 

	ProjectId
êê
 
=
êê 
dto
êê 
.
êê 
	ProjectId
êê #
;
êê# $
p
êê% &
.
êê& '

CategoryId
êê' 1
=
êê2 3
dto
êê4 7
.
êê7 8

CategoryId
êê8 B
;
êêB C
p
êêD E
.
êêE F
TicketTypeId
êêF R
=
êêS T
dto
êêU X
.
êêX Y
TicketTypeId
êêY e
;
êêe f
p
êêg h
.
êêh i
	SortOrder
êêi r
=
êês t
dto
êêu x
.
êêx y
	SortOrderêêy Ç
;êêÇ É
pêêÑ Ö
.êêÖ Ü

IsRequiredêêÜ ê
=êêë í
dtoêêì ñ
.êêñ ó

IsRequiredêêó °
;êê° ¢
pêê£ §
.êê§ •
IsActiveêê• ≠
=êêÆ Ø
dtoêê∞ ≥
.êê≥ ¥
IsActiveêê¥ º
;êêº Ω
await
ëë 
_placementRepo
ëë 
.
ëë 
UpdateAsync
ëë (
(
ëë( )
p
ëë) *
)
ëë* +
;
ëë+ ,
}
íí 
public
îî 

async
îî 
Task
îî "
DeletePlacementAsync
îî *
(
îî* +
int
îî+ .
id
îî/ 1
)
îî1 2
=>
îî3 5
await
îî6 ;
_placementRepo
îî< J
.
îîJ K
DeleteAsync
îîK V
(
îîV W
id
îîW Y
)
îîY Z
;
îîZ [
}ïï ﬁ)
e/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/DepartmentService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 
DepartmentService 
:  
IDepartmentService! 3
{ 
private		 
readonly		 
IRepository		  
<		  !

Department		! +
>		+ ,
_repository		- 8
;		8 9
public 

DepartmentService 
( 
IRepository (
<( )

Department) 3
>3 4

repository5 ?
)? @
{ 
_repository 
= 

repository  
;  !
} 
public 

async 
Task 
< 
IEnumerable !
<! "
DepartmentDto" /
>/ 0
>0 1
GetAllAsync2 =
(= >
)> ?
{ 
var 
depts 
= 
await 
_repository %
.% &
GetAllAsync& 1
(1 2
)2 3
;3 4
return 
depts 
. 
Select 
( 
d 
=>  
new! $
DepartmentDto% 2
(2 3
d3 4
.4 5
Id5 7
,7 8
d9 :
.: ;
Name; ?
,? @
dA B
.B C
DescriptionC N
,N O
dP Q
.Q R
IsActiveR Z
)Z [
)[ \
;\ ]
} 
public 

async 
Task 
< 
DepartmentDto #
?# $
>$ %
GetByIdAsync& 2
(2 3
int3 6
id7 9
)9 :
{ 
var 
dept 
= 
await 
_repository $
.$ %
GetByIdAsync% 1
(1 2
id2 4
)4 5
;5 6
if 

( 
dept 
== 
null 
) 
return  
null! %
;% &
return 
new 
DepartmentDto  
(  !
dept! %
.% &
Id& (
,( )
dept* .
.. /
Name/ 3
,3 4
dept5 9
.9 :
Description: E
,E F
deptG K
.K L
IsActiveL T
)T U
;U V
} 
public 

async 
Task 
< 
DepartmentDto #
># $
CreateAsync% 0
(0 1
CreateDepartmentDto1 D
dtoE H
)H I
{ 
var 
dept 
= 
new 

Department !
{   	
Name!! 
=!! 
dto!! 
.!! 
Name!! 
,!! 
Description"" 
="" 
dto"" 
."" 
Description"" )
}## 	
;##	 

await$$ 
_repository$$ 
.$$ 
AddAsync$$ "
($$" #
dept$$# '
)$$' (
;$$( )
return%% 
new%% 
DepartmentDto%%  
(%%  !
dept%%! %
.%%% &
Id%%& (
,%%( )
dept%%* .
.%%. /
Name%%/ 3
,%%3 4
dept%%5 9
.%%9 :
Description%%: E
,%%E F
dept%%G K
.%%K L
IsActive%%L T
)%%T U
;%%U V
}&& 
public(( 

async(( 
Task(( 
UpdateAsync(( !
(((! "
int((" %
id((& (
,((( )
UpdateDepartmentDto((* =
dto((> A
)((A B
{)) 
var** 
dept** 
=** 
await** 
_repository** $
.**$ %
GetByIdAsync**% 1
(**1 2
id**2 4
)**4 5
;**5 6
if++ 

(++ 
dept++ 
==++ 
null++ 
)++ 
throw++ 
new++  # 
KeyNotFoundException++$ 8
(++8 9
$str++9 O
)++O P
;++P Q
dept-- 
.-- 
Name-- 
=-- 
dto-- 
.-- 
Name-- 
;-- 
dept.. 
... 
Description.. 
=.. 
dto.. 
... 
Description.. *
;..* +
dept// 
.// 
IsActive// 
=// 
dto// 
.// 
IsActive// $
;//$ %
await00 
_repository00 
.00 
UpdateAsync00 %
(00% &
dept00& *
)00* +
;00+ ,
}11 
public33 

async33 
Task33 
DeleteAsync33 !
(33! "
int33" %
id33& (
)33( )
{44 
await55 
_repository55 
.55 
DeleteAsync55 %
(55% &
id55& (
)55( )
;55) *
}66 
}77 ¿Â
d/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/DashboardService.cs
	namespace

 	
ItsTool


 
.

 
Infrastructure

  
.

  !
Services

! )
;

) *
public 
class 
DashboardService 
: 
IDashboardService  1
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly !
IPermissionCalculator *!
_permissionCalculator+ @
;@ A
public 

DashboardService 
( 
ItsToolDbContext ,
context- 4
,4 5!
IPermissionCalculator6 K 
permissionCalculatorL `
)` a
{ 
_context 
= 
context 
; !
_permissionCalculator 
=  
permissionCalculator  4
;4 5
} 
private 
async 
Task 
< 

IQueryable !
<! "
Ticket" (
>( )
>) *&
GetScopedTicketsQueryAsync+ E
(E F
intF I
userIdJ P
)P Q
{ 
var 
perms 
= 
await !
_permissionCalculator /
./ 0.
"CalculateEffectivePermissionsAsync0 R
(R S
userIdS Y
)Y Z
;Z [
var 
query 
= 
_context 
. 
Tickets $
. 
Include 
( 
t 
=> 
t 
. 
	TicketSla %
)% &
. 
Include 
( 
t 
=> 
t 
. 
Status "
)" #
. 
Include 
( 
t 
=> 
t 
. 
Priority $
)$ %
. 
Include 
( 
t 
=> 
t 
. 
Project #
)# $
.   
Include   
(   
t   
=>   
t   
.   
Category   $
)  $ %
.!! 
Include!! 
(!! 
t!! 
=>!! 
t!! 
.!! 
AssignedUser!! (
)!!( )
."" 
Where"" 
("" 
t"" 
=>"" 
!"" 
t"" 
."" 
	IsDeleted"" $
)""$ %
;""% &
if$$ 

($$ 
perms$$ 
.$$ 
Contains$$ 
($$ 
$str$$ (
)$$( )
)$$) *
{%% 	
return'' 
query'' 
;'' 
}(( 	
var** 
isAgent** 
=** 
perms** 
.** 
Contains** $
(**$ %
$str**% 4
)**4 5
||**6 8
perms**9 >
.**> ?
Contains**? G
(**G H
$str**H W
)**W X
;**X Y
if++ 

(++ 
isAgent++ 
)++ 
{,, 	
var-- 
userGroupIds-- 
=-- 
await-- $
_context--% -
.--- .
GroupMembers--. :
... 
Where.. 
(.. 
gm.. 
=>.. 
gm.. 
...  
UserId..  &
==..' )
userId..* 0
&&..1 3
!..4 5
gm..5 7
...7 8
	IsDeleted..8 A
)..A B
.// 
Select// 
(// 
gm// 
=>// 
gm//  
.//  !
GroupId//! (
)//( )
.00 
ToListAsync00 
(00 
)00 
;00 
return22 
query22 
.22 
Where22 
(22 
t22  
=>22! #
t22$ %
.22% &
AssignedUserId22& 4
==225 7
userId228 >
||22? A
(33$ %
t33% &
.33& '
AssignedGroupId33' 6
.336 7
HasValue337 ?
&&33@ B
userGroupIds33C O
.33O P
Contains33P X
(33X Y
t33Y Z
.33Z [
AssignedGroupId33[ j
.33j k
Value33k p
)33p q
)33q r
||33s u
t44$ %
.44% &
RequesterUserId44& 5
==446 8
userId449 ?
)44? @
;44@ A
}55 	
return88 
query88 
.88 
Where88 
(88 
t88 
=>88 
t88  !
.88! "
RequesterUserId88" 1
==882 4
userId885 ;
)88; <
;88< =
}99 
public;; 

async;; 
Task;; 
<;;  
DashboardOverviewDto;; *
>;;* +
GetOverviewAsync;;, <
(;;< =
int;;= @
userId;;A G
);;G H
{<< 
var== 
query== 
=== 
await== &
GetScopedTicketsQueryAsync== 4
(==4 5
userId==5 ;
)==; <
;==< =
var?? 
openTicketsCount?? 
=?? 
await?? $
query??% *
.??* +

CountAsync??+ 5
(??5 6
t??6 7
=>??8 :
t??; <
.??< =
Status??= C
!=??D F
null??G K
&&??L N
!??O P
t??P Q
.??Q R
Status??R X
.??X Y
IsClosedStatus??Y g
)??g h
;??h i
var@@  
criticalTicketsCount@@  
=@@! "
await@@# (
query@@) .
.@@. /

CountAsync@@/ 9
(@@9 :
t@@: ;
=>@@< >
t@@? @
.@@@ A
Priority@@A I
!=@@J L
null@@M Q
&&@@R T
t@@U V
.@@V W
Priority@@W _
.@@_ `
SeverityLevel@@` m
==@@n p
$num@@q r
&&@@s u
t@@v w
.@@w x
Status@@x ~
!=	@@ Å
null
@@Ç Ü
&&
@@á â
!
@@ä ã
t
@@ã å
.
@@å ç
Status
@@ç ì
.
@@ì î
IsClosedStatus
@@î ¢
)
@@¢ £
;
@@£ §
varAA 
slaBreachedCountAA 
=AA 
awaitAA $
queryAA% *
.AA* +

CountAsyncAA+ 5
(AA5 6
tAA6 7
=>AA8 :
tAA; <
.AA< =
	TicketSlaAA= F
!=AAG I
nullAAJ N
&&AAO Q
(AAR S
tAAS T
.AAT U
	TicketSlaAAU ^
.AA^ _!
FirstResponseBreachedAA_ t
||AAu w
tAAx y
.AAy z
	TicketSla	AAz É
.
AAÉ Ñ 
ResolutionBreached
AAÑ ñ
)
AAñ ó
&&
AAò ö
t
AAõ ú
.
AAú ù
Status
AAù £
!=
AA§ ¶
null
AAß ´
&&
AA¨ Æ
!
AAØ ∞
t
AA∞ ±
.
AA± ≤
Status
AA≤ ∏
.
AA∏ π
IsClosedStatus
AAπ «
)
AA« »
;
AA» …
varBB 
slaRiskCountBB 
=BB 
awaitBB  
queryBB! &
.BB& '

CountAsyncBB' 1
(BB1 2
tBB2 3
=>BB4 6
tBB7 8
.BB8 9
	TicketSlaBB9 B
!=BBC E
nullBBF J
&&BBK M
(BBN O
tBBO P
.BBP Q
	TicketSlaBBQ Z
.BBZ [
FirstResponseWarnedBB[ n
||BBo q
tBBr s
.BBs t
	TicketSlaBBt }
.BB} ~
ResolutionWarned	BB~ é
)
BBé è
&&
BBê í
!
BBì î
(
BBî ï
t
BBï ñ
.
BBñ ó
	TicketSla
BBó †
.
BB† °#
FirstResponseBreached
BB° ∂
||
BB∑ π
t
BB∫ ª
.
BBª º
	TicketSla
BBº ≈
.
BB≈ ∆ 
ResolutionBreached
BB∆ ÿ
)
BBÿ Ÿ
&&
BB⁄ ‹
t
BB› ﬁ
.
BBﬁ ﬂ
Status
BBﬂ Â
!=
BBÊ Ë
null
BBÈ Ì
&&
BBÓ 
!
BBÒ Ú
t
BBÚ Û
.
BBÛ Ù
Status
BBÙ ˙
.
BB˙ ˚
IsClosedStatus
BB˚ â
)
BBâ ä
;
BBä ã
varCC 
unassignedCountCC 
=CC 
awaitCC #
queryCC$ )
.CC) *

CountAsyncCC* 4
(CC4 5
tCC5 6
=>CC7 9
tCC: ;
.CC; <
AssignedUserIdCC< J
==CCK M
nullCCN R
&&CCS U
tCCV W
.CCW X
StatusCCX ^
!=CC_ a
nullCCb f
&&CCg i
!CCj k
tCCk l
.CCl m
StatusCCm s
.CCs t
IsClosedStatus	CCt Ç
)
CCÇ É
;
CCÉ Ñ
varEE 
	csatQueryEE 
=EE 
_contextEE  
.EE  !
TicketSurveysEE! .
.EE. /
AsQueryableEE/ :
(EE: ;
)EE; <
;EE< =
varFF 
csatAverageFF 
=FF 
awaitFF 
	csatQueryFF  )
.FF) *
AnyAsyncFF* 2
(FF2 3
)FF3 4
?FF5 6
awaitFF7 <
	csatQueryFF= F
.FFF G
AverageAsyncFFG S
(FFS T
sFFT U
=>FFV X
sFFY Z
.FFZ [
RatingFF[ a
)FFa b
:FFc d
$numFFe h
;FFh i
returnHH 
newHH  
DashboardOverviewDtoHH '
(HH' (
openTicketsCountHH( 8
,HH8 9 
criticalTicketsCountHH: N
,HHN O
slaBreachedCountHHP `
,HH` a
slaRiskCountHHb n
,HHn o
unassignedCountHHp 
,	HH Ä
csatAverage
HHÅ å
)
HHå ç
;
HHç é
}II 
publicKK 

asyncKK 
TaskKK 
<KK %
DashboardDistributionsDtoKK /
>KK/ 0!
GetDistributionsAsyncKK1 F
(KKF G
intKKG J
userIdKKK Q
)KKQ R
{LL 
varMM 
queryMM 
=MM 
awaitMM &
GetScopedTicketsQueryAsyncMM 4
(MM4 5
userIdMM5 ;
)MM; <
;MM< =
varOO 
byStatusOO 
=OO 
awaitOO 
queryOO "
.PP 
WherePP 
(PP 
tPP 
=>PP 
tPP 
.PP 
StatusPP  
!=PP! #
nullPP$ (
)PP( )
.QQ 
GroupByQQ 
(QQ 
tQQ 
=>QQ 
tQQ 
.QQ 
StatusQQ "
!QQ" #
.QQ# $
NameQQ$ (
)QQ( )
.RR 
SelectRR 
(RR 
gRR 
=>RR 
newRR !
TicketDistributionDtoRR 2
(RR2 3
gRR3 4
.RR4 5
KeyRR5 8
,RR8 9
gRR: ;
.RR; <
CountRR< A
(RRA B
)RRB C
)RRC D
)RRD E
.SS 
ToListAsyncSS 
(SS 
)SS 
;SS 
varUU 

byPriorityUU 
=UU 
awaitUU 
queryUU $
.VV 
WhereVV 
(VV 
tVV 
=>VV 
tVV 
.VV 
PriorityVV "
!=VV# %
nullVV& *
)VV* +
.WW 
GroupByWW 
(WW 
tWW 
=>WW 
tWW 
.WW 
PriorityWW $
!WW$ %
.WW% &
NameWW& *
)WW* +
.XX 
SelectXX 
(XX 
gXX 
=>XX 
newXX !
TicketDistributionDtoXX 2
(XX2 3
gXX3 4
.XX4 5
KeyXX5 8
,XX8 9
gXX: ;
.XX; <
CountXX< A
(XXA B
)XXB C
)XXC D
)XXD E
.YY 
ToListAsyncYY 
(YY 
)YY 
;YY 
var[[ 
	byProject[[ 
=[[ 
await[[ 
query[[ #
.\\ 
Where\\ 
(\\ 
t\\ 
=>\\ 
t\\ 
.\\ 
Project\\ !
!=\\" $
null\\% )
)\\) *
.]] 
GroupBy]] 
(]] 
t]] 
=>]] 
t]] 
.]] 
Project]] #
!]]# $
.]]$ %
Name]]% )
)]]) *
.^^ 
Select^^ 
(^^ 
g^^ 
=>^^ 
new^^ !
TicketDistributionDto^^ 2
(^^2 3
g^^3 4
.^^4 5
Key^^5 8
,^^8 9
g^^: ;
.^^; <
Count^^< A
(^^A B
)^^B C
)^^C D
)^^D E
.__ 
ToListAsync__ 
(__ 
)__ 
;__ 
varaa 

byCategoryaa 
=aa 
awaitaa 
queryaa $
.bb 
Wherebb 
(bb 
tbb 
=>bb 
tbb 
.bb 
Categorybb "
!=bb# %
nullbb& *
)bb* +
.cc 
GroupBycc 
(cc 
tcc 
=>cc 
tcc 
.cc 
Categorycc $
!cc$ %
.cc% &
Namecc& *
)cc* +
.dd 
Selectdd 
(dd 
gdd 
=>dd 
newdd !
TicketDistributionDtodd 2
(dd2 3
gdd3 4
.dd4 5
Keydd5 8
,dd8 9
gdd: ;
.dd; <
Countdd< A
(ddA B
)ddB C
)ddC D
)ddD E
.ee 
ToListAsyncee 
(ee 
)ee 
;ee 
returngg 
newgg %
DashboardDistributionsDtogg ,
(gg, -
byStatusgg- 5
,gg5 6

byPrioritygg7 A
,ggA B
	byProjectggC L
,ggL M

byCategoryggN X
)ggX Y
;ggY Z
}hh 
publicjj 

asyncjj 
Taskjj 
<jj 
IEnumerablejj !
<jj! "!
DepartmentWorkloadDtojj" 7
>jj7 8
>jj8 9&
GetDepartmentWorkloadAsyncjj: T
(jjT U
intjjU X
userIdjjY _
)jj_ `
{kk 
varll 
activeUsersll 
=ll 
awaitll 
_contextll  (
.ll( )
Usersll) .
.mm 
Includemm 
(mm 
umm 
=>mm 
umm 
.mm 

Departmentmm &
)mm& '
.nn 
Wherenn 
(nn 
unn 
=>nn 
!nn 
unn 
.nn 
	IsDeletednn $
&&nn% '
unn( )
.nn) *
IsActivenn* 2
)nn2 3
.oo 
ToListAsyncoo 
(oo 
)oo 
;oo 
varqq 
queryqq 
=qq 
awaitqq &
GetScopedTicketsQueryAsyncqq 4
(qq4 5
userIdqq5 ;
)qq; <
;qq< =
varss #
openTicketsCountPerUserss #
=ss$ %
awaitss& +
queryss, 1
.tt 
Wherett 
(tt 
ttt 
=>tt 
ttt 
.tt 
AssignedUserIdtt (
!=tt) +
nulltt, 0
&&tt1 3
ttt4 5
.tt5 6
Statustt6 <
!=tt= ?
nulltt@ D
&&ttE G
!ttH I
tttI J
.ttJ K
StatusttK Q
.ttQ R
IsClosedStatusttR `
)tt` a
.uu 
GroupByuu 
(uu 
tuu 
=>uu 
tuu 
.uu 
AssignedUserIduu *
)uu* +
.vv 
Selectvv 
(vv 
gvv 
=>vv 
newvv 
{vv 
UserIdvv %
=vv& '
gvv( )
.vv) *
Keyvv* -
,vv- .
Countvv/ 4
=vv5 6
gvv7 8
.vv8 9
Countvv9 >
(vv> ?
)vv? @
}vvA B
)vvB C
.ww 
ToDictionaryAsyncww 
(ww 
kww  
=>ww! #
kww$ %
.ww% &
UserIdww& ,
??ww- /
$numww0 1
,ww1 2
vww3 4
=>ww5 7
vww8 9
.ww9 :
Countww: ?
)ww? @
;ww@ A
varyy 
workloadyy 
=yy 
activeUsersyy "
.zz 
GroupByzz 
(zz 
uzz 
=>zz 
newzz 
{zz 
DepartmentIdzz  ,
=zz- .
uzz/ 0
.zz0 1
DepartmentIdzz1 =
??zz> @
$numzzA B
,zzB C
DepartmentNamezzD R
=zzS T
uzzU V
.zzV W

DepartmentzzW a
?zza b
.zzb c
Namezzc g
??zzh j
$strzzk z
}zz{ |
)zz| }
.{{ 
Select{{ 
({{ 
g{{ 
=>{{ 
new{{ !
DepartmentWorkloadDto{{ 2
({{2 3
g|| 
.|| 
Key|| 
.|| 
DepartmentId|| "
,||" #
g}} 
.}} 
Key}} 
.}} 
DepartmentName}} $
,}}$ %
g~~ 
.~~ 
Sum~~ 
(~~ 
u~~ 
=>~~ #
openTicketsCountPerUser~~ 2
.~~2 3
GetValueOrDefault~~3 D
(~~D E
u~~E F
.~~F G
Id~~G I
,~~I J
$num~~K L
)~~L M
)~~M N
,~~N O
g 
. 
Select 
( 
u 
=> 
new !
AgentWorkloadDto" 2
(2 3
u
ÄÄ 
.
ÄÄ 
Id
ÄÄ 
,
ÄÄ 
$"
ÅÅ 
{
ÅÅ 
u
ÅÅ 
.
ÅÅ 
	FirstName
ÅÅ "
}
ÅÅ" #
$str
ÅÅ# $
{
ÅÅ$ %
u
ÅÅ% &
.
ÅÅ& '
LastName
ÅÅ' /
}
ÅÅ/ 0
"
ÅÅ0 1
,
ÅÅ1 2%
openTicketsCountPerUser
ÇÇ +
.
ÇÇ+ ,
GetValueOrDefault
ÇÇ, =
(
ÇÇ= >
u
ÇÇ> ?
.
ÇÇ? @
Id
ÇÇ@ B
,
ÇÇB C
$num
ÇÇD E
)
ÇÇE F
)
ÉÉ 
)
ÉÉ 
.
ÉÉ 
OrderByDescending
ÉÉ $
(
ÉÉ$ %
a
ÉÉ% &
=>
ÉÉ' )
a
ÉÉ* +
.
ÉÉ+ ,
OpenTicketCount
ÉÉ, ;
)
ÉÉ; <
.
ÉÉ< =
ToList
ÉÉ= C
(
ÉÉC D
)
ÉÉD E
)
ÑÑ 
)
ÑÑ 
.
ÖÖ 
Where
ÖÖ 
(
ÖÖ 
w
ÖÖ 
=>
ÖÖ 
w
ÖÖ 
.
ÖÖ 
DepartmentId
ÖÖ &
!=
ÖÖ' )
$num
ÖÖ* +
||
ÖÖ, .
w
ÖÖ/ 0
.
ÖÖ0 1
OpenTicketCount
ÖÖ1 @
>
ÖÖA B
$num
ÖÖC D
)
ÖÖD E
.
ÜÜ 
OrderByDescending
ÜÜ 
(
ÜÜ 
w
ÜÜ  
=>
ÜÜ! #
w
ÜÜ$ %
.
ÜÜ% &
OpenTicketCount
ÜÜ& 5
)
ÜÜ5 6
.
áá 
ThenBy
áá 
(
áá 
w
áá 
=>
áá 
w
áá 
.
áá 
DepartmentName
áá )
)
áá) *
.
àà 
ToList
àà 
(
àà 
)
àà 
;
àà 
return
ää 
workload
ää 
;
ää 
}
ãã 
public
çç 

async
çç 
Task
çç 
<
çç 
SlaComplianceDto
çç &
>
çç& '#
GetSlaComplianceAsync
çç( =
(
çç= >
int
çç> A
userId
ççB H
)
ççH I
{
éé 
var
èè 
query
èè 
=
èè 
await
èè (
GetScopedTicketsQueryAsync
èè 4
(
èè4 5
userId
èè5 ;
)
èè; <
;
èè< =
var
ëë 
ticketsWithSla
ëë 
=
ëë 
await
ëë "
query
ëë# (
.
íí 
Where
íí 
(
íí 
t
íí 
=>
íí 
t
íí 
.
íí 
	TicketSla
íí #
!=
íí$ &
null
íí' +
)
íí+ ,
.
ìì 
Select
ìì 
(
ìì 
t
ìì 
=>
ìì 
new
ìì 
{
ìì 
t
îî 
.
îî 
	TicketSla
îî 
!
îî 
.
îî  
FirstResponseDueAt
îî /
,
îî/ 0
t
ïï 
.
ïï 
	TicketSla
ïï 
.
ïï  
FirstResponseMetAt
ïï .
,
ïï. /
t
ññ 
.
ññ 
	TicketSla
ññ 
.
ññ 
ResolutionDueAt
ññ +
,
ññ+ ,
t
óó 
.
óó 
	TicketSla
óó 
.
óó 
ResolutionMetAt
óó +
,
óó+ ,
t
òò 
.
òò 
	TicketSla
òò 
.
òò #
FirstResponseBreached
òò 1
,
òò1 2
t
ôô 
.
ôô 
	TicketSla
ôô 
.
ôô  
ResolutionBreached
ôô .
,
ôô. /
	CreatedAt
öö 
=
öö 
t
öö 
.
öö 
	CreatedAt
öö '
,
öö' (

ResolvedAt
õõ 
=
õõ 
t
õõ 
.
õõ 
Status
õõ %
!=
õõ& (
null
õõ) -
&&
õõ. 0
t
õõ1 2
.
õõ2 3
Status
õõ3 9
.
õõ9 :
IsClosedStatus
õõ: H
?
õõI J
t
õõK L
.
õõL M
	TicketSla
õõM V
.
õõV W
ResolutionMetAt
õõW f
??
õõg i
DateTime
õõj r
.
õõr s
UtcNow
õõs y
:
õõz {
(
õõ| }
DateTimeõõ} Ö
?õõÖ Ü
)õõÜ á
nullõõá ã
}
úú 
)
úú 
.
ùù 
ToListAsync
ùù 
(
ùù 
)
ùù 
;
ùù 
if
üü 

(
üü 
ticketsWithSla
üü 
.
üü 
Count
üü  
==
üü! #
$num
üü$ %
)
üü% &
return
üü' -
new
üü. 1
SlaComplianceDto
üü2 B
(
üüB C
$num
üüC F
,
üüF G
$num
üüH K
,
üüK L
$num
üüM N
)
üüN O
;
üüO P
var
°° #
firstResponseEligible
°° !
=
°°" #
ticketsWithSla
°°$ 2
.
°°2 3
Where
°°3 8
(
°°8 9
t
°°9 :
=>
°°; =
t
°°> ?
.
°°? @ 
FirstResponseDueAt
°°@ R
!=
°°S U
null
°°V Z
)
°°Z [
.
°°[ \
ToList
°°\ b
(
°°b c
)
°°c d
;
°°d e
var
¢¢ 
frCompliant
¢¢ 
=
¢¢ #
firstResponseEligible
¢¢ /
.
¢¢/ 0
Count
¢¢0 5
(
¢¢5 6
t
¢¢6 7
=>
¢¢8 :
!
¢¢; <
t
¢¢< =
.
¢¢= >#
FirstResponseBreached
¢¢> S
)
¢¢S T
;
¢¢T U
var
££ 
frRate
££ 
=
££ #
firstResponseEligible
££ *
.
££* +
Count
££+ 0
>
££1 2
$num
££3 4
?
££5 6
(
££7 8
frCompliant
££8 C
/
££D E
(
££F G
double
££G M
)
££M N#
firstResponseEligible
££N c
.
££c d
Count
££d i
)
££i j
*
££k l
$num
££m p
:
££q r
$num
££s v
;
££v w
var
•• 
resEligible
•• 
=
•• 
ticketsWithSla
•• (
.
••( )
Where
••) .
(
••. /
t
••/ 0
=>
••1 3
t
••4 5
.
••5 6
ResolutionDueAt
••6 E
!=
••F H
null
••I M
)
••M N
.
••N O
ToList
••O U
(
••U V
)
••V W
;
••W X
var
¶¶ 
resCompliant
¶¶ 
=
¶¶ 
resEligible
¶¶ &
.
¶¶& '
Count
¶¶' ,
(
¶¶, -
t
¶¶- .
=>
¶¶/ 1
!
¶¶2 3
t
¶¶3 4
.
¶¶4 5 
ResolutionBreached
¶¶5 G
)
¶¶G H
;
¶¶H I
var
ßß 
resRate
ßß 
=
ßß 
resEligible
ßß !
.
ßß! "
Count
ßß" '
>
ßß( )
$num
ßß* +
?
ßß, -
(
ßß. /
resCompliant
ßß/ ;
/
ßß< =
(
ßß> ?
double
ßß? E
)
ßßE F
resEligible
ßßF Q
.
ßßQ R
Count
ßßR W
)
ßßW X
*
ßßY Z
$num
ßß[ ^
:
ßß_ `
$num
ßßa d
;
ßßd e
var
©© 
resolvedTickets
©© 
=
©© 
ticketsWithSla
©© ,
.
©©, -
Where
©©- 2
(
©©2 3
t
©©3 4
=>
©©5 7
t
©©8 9
.
©©9 :

ResolvedAt
©©: D
!=
©©E G
null
©©H L
)
©©L M
.
©©M N
ToList
©©N T
(
©©T U
)
©©U V
;
©©V W
var
™™ 
avgTime
™™ 
=
™™ 
resolvedTickets
™™ %
.
™™% &
Count
™™& +
>
™™, -
$num
™™. /
?
™™0 1
resolvedTickets
™™2 A
.
™™A B
Average
™™B I
(
™™I J
t
™™J K
=>
™™L N
(
™™O P
t
™™P Q
.
™™Q R

ResolvedAt
™™R \
!
™™\ ]
.
™™] ^
Value
™™^ c
-
™™d e
t
™™f g
.
™™g h
	CreatedAt
™™h q
)
™™q r
.
™™r s
TotalMinutes
™™s 
)™™ Ä
:™™Å Ç
$num™™É Ü
;™™Ü á
return
¨¨ 
new
¨¨ 
SlaComplianceDto
¨¨ #
(
¨¨# $
frRate
¨¨$ *
,
¨¨* +
resRate
¨¨, 3
,
¨¨3 4
avgTime
¨¨5 <
)
¨¨< =
;
¨¨= >
}
≠≠ 
public
ØØ 

async
ØØ 
Task
ØØ 
<
ØØ 
IEnumerable
ØØ !
<
ØØ! "
TicketSurveyDto
ØØ" 1
>
ØØ1 2
>
ØØ2 3#
GetRecentSurveysAsync
ØØ4 I
(
ØØI J
int
ØØJ M
userId
ØØN T
)
ØØT U
{
∞∞ 
var
±± 
perms
±± 
=
±± 
await
±± #
_permissionCalculator
±± /
.
±±/ 00
"CalculateEffectivePermissionsAsync
±±0 R
(
±±R S
userId
±±S Y
)
±±Y Z
;
±±Z [
var
∑∑ 
query
∑∑ 
=
∑∑ 
_context
∑∑ 
.
∑∑ 
TicketSurveys
∑∑ *
.
∑∑* +
AsQueryable
∑∑+ 6
(
∑∑6 7
)
∑∑7 8
;
∑∑8 9
if
ππ 

(
ππ 
!
ππ 
perms
ππ 
.
ππ 
Contains
ππ 
(
ππ 
$str
ππ )
)
ππ) *
)
ππ* +
{
∫∫ 	
var
ΩΩ 
scopedTickets
ΩΩ 
=
ΩΩ 
await
ΩΩ  %(
GetScopedTicketsQueryAsync
ΩΩ& @
(
ΩΩ@ A
userId
ΩΩA G
)
ΩΩG H
;
ΩΩH I
var
ææ 
scopedTicketIds
ææ 
=
ææ  !
await
ææ" '
scopedTickets
ææ( 5
.
ææ5 6
Select
ææ6 <
(
ææ< =
t
ææ= >
=>
ææ? A
t
ææB C
.
ææC D
Id
ææD F
)
ææF G
.
ææG H
ToListAsync
ææH S
(
ææS T
)
ææT U
;
ææU V
query
øø 
=
øø 
query
øø 
.
øø 
Where
øø 
(
øø  
s
øø  !
=>
øø" $
scopedTicketIds
øø% 4
.
øø4 5
Contains
øø5 =
(
øø= >
s
øø> ?
.
øø? @
TicketId
øø@ H
)
øøH I
)
øøI J
;
øøJ K
}
¿¿ 	
var
¬¬ 
surveys
¬¬ 
=
¬¬ 
await
¬¬ 
query
¬¬ !
.
√√ 
Include
√√ 
(
√√ 
s
√√ 
=>
√√ 
s
√√ 
.
√√ 
Ticket
√√ "
)
√√" #
.
ƒƒ 
OrderByDescending
ƒƒ 
(
ƒƒ 
s
ƒƒ  
=>
ƒƒ! #
s
ƒƒ$ %
.
ƒƒ% &
	CreatedAt
ƒƒ& /
)
ƒƒ/ 0
.
≈≈ 
Take
≈≈ 
(
≈≈ 
$num
≈≈ 
)
≈≈ 
.
∆∆ 
Select
∆∆ 
(
∆∆ 
s
∆∆ 
=>
∆∆ 
new
∆∆ 
TicketSurveyDto
∆∆ ,
(
∆∆, -
s
∆∆- .
.
∆∆. /
Id
∆∆/ 1
,
∆∆1 2
s
∆∆3 4
.
∆∆4 5
TicketId
∆∆5 =
,
∆∆= >
s
∆∆? @
.
∆∆@ A
Rating
∆∆A G
,
∆∆G H
s
∆∆I J
.
∆∆J K
Comment
∆∆K R
,
∆∆R S
s
∆∆T U
.
∆∆U V
	CreatedAt
∆∆V _
)
∆∆_ `
)
∆∆` a
.
«« 
ToListAsync
«« 
(
«« 
)
«« 
;
«« 
return
…… 
surveys
…… 
;
…… 
}
   
}ÀÀ ´≈
b/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/CatalogService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public		 
class		 
CatalogService		 
:		 
ICatalogService		 -
{

 
private 
readonly 
IRepository  
<  !
Category! )
>) *
_categoryRepo+ 8
;8 9
private 
readonly 
IRepository  
<  !

TicketType! +
>+ ,
_ticketTypeRepo- <
;< =
private 
readonly 
IRepository  
<  !
Status! '
>' (
_statusRepo) 4
;4 5
private 
readonly 
IRepository  
<  !
Priority! )
>) *
_priorityRepo+ 8
;8 9
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

CatalogService 
( 
IRepository 
< 
Category 
> 
categoryRepo *
,* +
IRepository 
< 

TicketType 
> 
ticketTypeRepo  .
,. /
IRepository 
< 
Status 
> 

statusRepo &
,& '
IRepository 
< 
Priority 
> 
priorityRepo *
,* +
ItsToolDbContext 
context  
)  !
{ 
_categoryRepo 
= 
categoryRepo $
;$ %
_ticketTypeRepo 
= 
ticketTypeRepo (
;( )
_statusRepo 
= 

statusRepo  
;  !
_priorityRepo 
= 
priorityRepo $
;$ %
_context 
= 
context 
; 
} 
public   

async   
Task   
<   
IEnumerable   !
<  ! "
CategoryDto  " -
>  - .
>  . /
GetCategoriesAsync  0 B
(  B C
int  C F
?  F G
	projectId  H Q
=  R S
null  T X
)  X Y
{!! 
var"" 
list"" 
="" 
await"" 
_categoryRepo"" &
.""& '
GetAllAsync""' 2
(""2 3
c""3 4
=>""5 7
	projectId""8 A
==""B D
null""E I
||""J L
c""M N
.""N O
	ProjectId""O X
==""Y [
	projectId""\ e
)""e f
;""f g
return## 
list## 
.## 
Select## 
(## 
c## 
=>## 
new##  #
CategoryDto##$ /
(##/ 0
c##0 1
.##1 2
Id##2 4
,##4 5
c##6 7
.##7 8
Name##8 <
,##< =
c##> ?
.##? @
	ProjectId##@ I
,##I J
c##K L
.##L M
ParentCategoryId##M ]
,##] ^
c##_ `
.##` a
Description##a l
,##l m
c##n o
.##o p#
DefaultAssigneeGroupId	##p Ü
,
##Ü á
c
##à â
.
##â ä
IsActive
##ä í
)
##í ì
)
##ì î
;
##î ï
}$$ 
public&& 

async&& 
Task&& 
<&& 
CategoryDto&& !
?&&! "
>&&" # 
GetCategoryByIdAsync&&$ 8
(&&8 9
int&&9 <
id&&= ?
)&&? @
{'' 
var(( 
c(( 
=(( 
await(( 
_categoryRepo(( #
.((# $
GetByIdAsync(($ 0
(((0 1
id((1 3
)((3 4
;((4 5
if)) 

()) 
c)) 
==)) 
null)) 
))) 
return)) 
null)) "
;))" #
return** 
new** 
CategoryDto** 
(** 
c**  
.**  !
Id**! #
,**# $
c**% &
.**& '
Name**' +
,**+ ,
c**- .
.**. /
	ProjectId**/ 8
,**8 9
c**: ;
.**; <
ParentCategoryId**< L
,**L M
c**N O
.**O P
Description**P [
,**[ \
c**] ^
.**^ _"
DefaultAssigneeGroupId**_ u
,**u v
c**w x
.**x y
IsActive	**y Å
)
**Å Ç
;
**Ç É
}++ 
public-- 

async-- 
Task-- 
<-- 
CategoryDto-- !
>--! "
CreateCategoryAsync--# 6
(--6 7
CreateCategoryDto--7 H
dto--I L
)--L M
{.. 
var// 
c// 
=// 
new// 
Category// 
{// 
Name// #
=//$ %
dto//& )
.//) *
Name//* .
,//. /
	ProjectId//0 9
=//: ;
dto//< ?
.//? @
	ProjectId//@ I
,//I J
ParentCategoryId//K [
=//\ ]
dto//^ a
.//a b
ParentCategoryId//b r
,//r s
Description//t 
=
//Ä Å
dto
//Ç Ö
.
//Ö Ü
Description
//Ü ë
,
//ë í$
DefaultAssigneeGroupId
//ì ©
=
//™ ´
dto
//¨ Ø
.
//Ø ∞$
DefaultAssigneeGroupId
//∞ ∆
}
//« »
;
//» …
await00 
_categoryRepo00 
.00 
AddAsync00 $
(00$ %
c00% &
)00& '
;00' (
return11 
new11 
CategoryDto11 
(11 
c11  
.11  !
Id11! #
,11# $
c11% &
.11& '
Name11' +
,11+ ,
c11- .
.11. /
	ProjectId11/ 8
,118 9
c11: ;
.11; <
ParentCategoryId11< L
,11L M
c11N O
.11O P
Description11P [
,11[ \
c11] ^
.11^ _"
DefaultAssigneeGroupId11_ u
,11u v
c11w x
.11x y
IsActive	11y Å
)
11Å Ç
;
11Ç É
}22 
public44 

async44 
Task44 
UpdateCategoryAsync44 )
(44) *
int44* -
id44. 0
,440 1
UpdateCategoryDto442 C
dto44D G
)44G H
{55 
var66 
c66 
=66 
await66 
_categoryRepo66 #
.66# $
GetByIdAsync66$ 0
(660 1
id661 3
)663 4
;664 5
if77 

(77 
c77 
==77 
null77 
)77 
throw77 
new77   
KeyNotFoundException77! 5
(775 6
$str776 J
)77J K
;77K L
c88 	
.88	 

Name88
 
=88 
dto88 
.88 
Name88 
;88 
c88 
.88 
	ProjectId88 &
=88' (
dto88) ,
.88, -
	ProjectId88- 6
;886 7
c888 9
.889 :
ParentCategoryId88: J
=88K L
dto88M P
.88P Q
ParentCategoryId88Q a
;88a b
c88c d
.88d e
Description88e p
=88q r
dto88s v
.88v w
Description	88w Ç
;
88Ç É
c
88Ñ Ö
.
88Ö Ü$
DefaultAssigneeGroupId
88Ü ú
=
88ù û
dto
88ü ¢
.
88¢ £$
DefaultAssigneeGroupId
88£ π
;
88π ∫
c
88ª º
.
88º Ω
IsActive
88Ω ≈
=
88∆ «
dto
88» À
.
88À Ã
IsActive
88Ã ‘
;
88‘ ’
await99 
_categoryRepo99 
.99 
UpdateAsync99 '
(99' (
c99( )
)99) *
;99* +
}:: 
public<< 

async<< 
Task<< 
DeleteCategoryAsync<< )
(<<) *
int<<* -
id<<. 0
)<<0 1
=><<2 4
await<<5 :
_categoryRepo<<; H
.<<H I
DeleteAsync<<I T
(<<T U
id<<U W
)<<W X
;<<X Y
public?? 

async?? 
Task?? 
<?? 
IEnumerable?? !
<??! "
TicketTypeDto??" /
>??/ 0
>??0 1
GetTicketTypesAsync??2 E
(??E F
)??F G
{@@ 
varAA 
listAA 
=AA 
awaitAA 
_ticketTypeRepoAA (
.AA( )
GetAllAsyncAA) 4
(AA4 5
)AA5 6
;AA6 7
returnBB 
listBB 
.BB 
SelectBB 
(BB 
tBB 
=>BB 
newBB  #
TicketTypeDtoBB$ 1
(BB1 2
tBB2 3
.BB3 4
IdBB4 6
,BB6 7
tBB8 9
.BB9 :
NameBB: >
,BB> ?
tBB@ A
.BBA B
IsActiveBBB J
)BBJ K
)BBK L
;BBL M
}CC 
publicEE 

asyncEE 
TaskEE 
<EE 
TicketTypeDtoEE #
?EE# $
>EE$ %"
GetTicketTypeByIdAsyncEE& <
(EE< =
intEE= @
idEEA C
)EEC D
{FF 
varGG 
tGG 
=GG 
awaitGG 
_ticketTypeRepoGG %
.GG% &
GetByIdAsyncGG& 2
(GG2 3
idGG3 5
)GG5 6
;GG6 7
ifHH 

(HH 
tHH 
==HH 
nullHH 
)HH 
returnHH 
nullHH "
;HH" #
returnII 
newII 
TicketTypeDtoII  
(II  !
tII! "
.II" #
IdII# %
,II% &
tII' (
.II( )
NameII) -
,II- .
tII/ 0
.II0 1
IsActiveII1 9
)II9 :
;II: ;
}JJ 
publicLL 

asyncLL 
TaskLL 
<LL 
TicketTypeDtoLL #
>LL# $!
CreateTicketTypeAsyncLL% :
(LL: ;
CreateTicketTypeDtoLL; N
dtoLLO R
)LLR S
{MM 
varNN 
tNN 
=NN 
newNN 

TicketTypeNN 
{NN  
NameNN! %
=NN& '
dtoNN( +
.NN+ ,
NameNN, 0
}NN1 2
;NN2 3
awaitOO 
_ticketTypeRepoOO 
.OO 
AddAsyncOO &
(OO& '
tOO' (
)OO( )
;OO) *
returnPP 
newPP 
TicketTypeDtoPP  
(PP  !
tPP! "
.PP" #
IdPP# %
,PP% &
tPP' (
.PP( )
NamePP) -
,PP- .
tPP/ 0
.PP0 1
IsActivePP1 9
)PP9 :
;PP: ;
}QQ 
publicSS 

asyncSS 
TaskSS !
UpdateTicketTypeAsyncSS +
(SS+ ,
intSS, /
idSS0 2
,SS2 3
UpdateTicketTypeDtoSS4 G
dtoSSH K
)SSK L
{TT 
varUU 
tUU 
=UU 
awaitUU 
_ticketTypeRepoUU %
.UU% &
GetByIdAsyncUU& 2
(UU2 3
idUU3 5
)UU5 6
;UU6 7
ifVV 

(VV 
tVV 
==VV 
nullVV 
)VV 
throwVV 
newVV   
KeyNotFoundExceptionVV! 5
(VV5 6
$strVV6 L
)VVL M
;VVM N
tWW 	
.WW	 

NameWW
 
=WW 
dtoWW 
.WW 
NameWW 
;WW 
tWW 
.WW 
IsActiveWW %
=WW& '
dtoWW( +
.WW+ ,
IsActiveWW, 4
;WW4 5
awaitXX 
_ticketTypeRepoXX 
.XX 
UpdateAsyncXX )
(XX) *
tXX* +
)XX+ ,
;XX, -
}YY 
public[[ 

async[[ 
Task[[ !
DeleteTicketTypeAsync[[ +
([[+ ,
int[[, /
id[[0 2
)[[2 3
=>[[4 6
await[[7 <
_ticketTypeRepo[[= L
.[[L M
DeleteAsync[[M X
([[X Y
id[[Y [
)[[[ \
;[[\ ]
public^^ 

async^^ 
Task^^ 
<^^ 
IEnumerable^^ !
<^^! "
	StatusDto^^" +
>^^+ ,
>^^, -
GetStatusesAsync^^. >
(^^> ?
)^^? @
{__ 
var`` 
list`` 
=`` 
await`` 
_statusRepo`` $
.``$ %
GetAllAsync``% 0
(``0 1
)``1 2
;``2 3
returnaa 
listaa 
.aa 
Selectaa 
(aa 
saa 
=>aa 
newaa  #
	StatusDtoaa$ -
(aa- .
saa. /
.aa/ 0
Idaa0 2
,aa2 3
saa4 5
.aa5 6
Nameaa6 :
,aa: ;
saa< =
.aa= >
ColorHexaa> F
,aaF G
saaH I
.aaI J
	SortOrderaaJ S
,aaS T
saaU V
.aaV W
IsClosedStatusaaW e
,aae f
saag h
.aah i
IsSystemDefaultaai x
,aax y
saaz {
.aa{ |
IsActive	aa| Ñ
)
aaÑ Ö
)
aaÖ Ü
;
aaÜ á
}bb 
publicdd 

asyncdd 
Taskdd 
<dd 
	StatusDtodd 
?dd  
>dd  !
GetStatusByIdAsyncdd" 4
(dd4 5
intdd5 8
iddd9 ;
)dd; <
{ee 
varff 
sff 
=ff 
awaitff 
_statusRepoff !
.ff! "
GetByIdAsyncff" .
(ff. /
idff/ 1
)ff1 2
;ff2 3
ifgg 

(gg 
sgg 
==gg 
nullgg 
)gg 
returngg 
nullgg "
;gg" #
returnhh 
newhh 
	StatusDtohh 
(hh 
shh 
.hh 
Idhh !
,hh! "
shh# $
.hh$ %
Namehh% )
,hh) *
shh+ ,
.hh, -
ColorHexhh- 5
,hh5 6
shh7 8
.hh8 9
	SortOrderhh9 B
,hhB C
shhD E
.hhE F
IsClosedStatushhF T
,hhT U
shhV W
.hhW X
IsSystemDefaulthhX g
,hhg h
shhi j
.hhj k
IsActivehhk s
)hhs t
;hht u
}ii 
publickk 

asynckk 
Taskkk 
<kk 
	StatusDtokk 
>kk  
CreateStatusAsynckk! 2
(kk2 3
CreateStatusDtokk3 B
dtokkC F
)kkF G
{ll 
varmm 
smm 
=mm 
newmm 
Statusmm 
{mm 
Namemm !
=mm" #
dtomm$ '
.mm' (
Namemm( ,
,mm, -
ColorHexmm. 6
=mm7 8
dtomm9 <
.mm< =
ColorHexmm= E
,mmE F
	SortOrdermmG P
=mmQ R
dtommS V
.mmV W
	SortOrdermmW `
,mm` a
IsClosedStatusmmb p
=mmq r
dtomms v
.mmv w
IsClosedStatus	mmw Ö
,
mmÖ Ü
IsSystemDefault
mmá ñ
=
mmó ò
dto
mmô ú
.
mmú ù
IsSystemDefault
mmù ¨
}
mm≠ Æ
;
mmÆ Ø
awaitnn 
_statusReponn 
.nn 
AddAsyncnn "
(nn" #
snn# $
)nn$ %
;nn% &
returnoo 
newoo 
	StatusDtooo 
(oo 
soo 
.oo 
Idoo !
,oo! "
soo# $
.oo$ %
Nameoo% )
,oo) *
soo+ ,
.oo, -
ColorHexoo- 5
,oo5 6
soo7 8
.oo8 9
	SortOrderoo9 B
,ooB C
sooD E
.ooE F
IsClosedStatusooF T
,ooT U
sooV W
.ooW X
IsSystemDefaultooX g
,oog h
sooi j
.ooj k
IsActiveook s
)oos t
;oot u
}pp 
publicrr 

asyncrr 
Taskrr 
UpdateStatusAsyncrr '
(rr' (
intrr( +
idrr, .
,rr. /
UpdateStatusDtorr0 ?
dtorr@ C
)rrC D
{ss 
vartt 
stt 
=tt 
awaittt 
_statusRepott !
.tt! "
GetByIdAsynctt" .
(tt. /
idtt/ 1
)tt1 2
;tt2 3
ifuu 

(uu 
suu 
==uu 
nulluu 
)uu 
throwuu 
newuu   
KeyNotFoundExceptionuu! 5
(uu5 6
$struu6 H
)uuH I
;uuI J
svv 	
.vv	 

Namevv
 
=vv 
dtovv 
.vv 
Namevv 
;vv 
svv 
.vv 
ColorHexvv %
=vv& '
dtovv( +
.vv+ ,
ColorHexvv, 4
;vv4 5
svv6 7
.vv7 8
	SortOrdervv8 A
=vvB C
dtovvD G
.vvG H
	SortOrdervvH Q
;vvQ R
svvS T
.vvT U
IsClosedStatusvvU c
=vvd e
dtovvf i
.vvi j
IsClosedStatusvvj x
;vvx y
svvz {
.vv{ |
IsSystemDefault	vv| ã
=
vvå ç
dto
vvé ë
.
vvë í
IsSystemDefault
vví °
;
vv° ¢
s
vv£ §
.
vv§ •
IsActive
vv• ≠
=
vvÆ Ø
dto
vv∞ ≥
.
vv≥ ¥
IsActive
vv¥ º
;
vvº Ω
awaitww 
_statusRepoww 
.ww 
UpdateAsyncww %
(ww% &
sww& '
)ww' (
;ww( )
}xx 
publiczz 

asynczz 
Taskzz 
DeleteStatusAsynczz '
(zz' (
intzz( +
idzz, .
)zz. /
{{{ 
var|| 
inUse|| 
=|| 
await|| 
_context|| "
.||" #
WorkflowTransitions||# 6
.||6 7
AnyAsync||7 ?
(||? @
wt||@ B
=>||C E
!||F G
wt||G I
.||I J
	IsDeleted||J S
&&||T V
(||W X
wt||X Z
.||Z [
FromStatusId||[ g
==||h j
id||k m
||||n p
wt||q s
.||s t

ToStatusId||t ~
==	|| Å
id
||Ç Ñ
)
||Ñ Ö
)
||Ö Ü
;
||Ü á
if}} 

(}} 
inUse}} 
)}} 
{~~ 	
throw
ÇÇ 
new
ÇÇ '
InvalidOperationException
ÇÇ /
(
ÇÇ/ 0
$strÇÇ0 Ñ
)ÇÇÑ Ö
;ÇÇÖ Ü
}
ÉÉ 	
await
ÑÑ 
_statusRepo
ÑÑ 
.
ÑÑ 
DeleteAsync
ÑÑ %
(
ÑÑ% &
id
ÑÑ& (
)
ÑÑ( )
;
ÑÑ) *
}
ÖÖ 
public
àà 

async
àà 
Task
àà 
<
àà 
IEnumerable
àà !
<
àà! "
PriorityDto
àà" -
>
àà- .
>
àà. / 
GetPrioritiesAsync
àà0 B
(
ààB C
)
ààC D
{
ââ 
var
ää 
list
ää 
=
ää 
await
ää 
_priorityRepo
ää &
.
ää& '
GetAllAsync
ää' 2
(
ää2 3
)
ää3 4
;
ää4 5
return
ãã 
list
ãã 
.
ãã 
Select
ãã 
(
ãã 
p
ãã 
=>
ãã 
new
ãã  #
PriorityDto
ãã$ /
(
ãã/ 0
p
ãã0 1
.
ãã1 2
Id
ãã2 4
,
ãã4 5
p
ãã6 7
.
ãã7 8
Name
ãã8 <
,
ãã< =
p
ãã> ?
.
ãã? @
ColorHex
ãã@ H
,
ããH I
p
ããJ K
.
ããK L
Weight
ããL R
,
ããR S
p
ããT U
.
ããU V
SeverityLevel
ããV c
,
ããc d
p
ããe f
.
ããf g
IsActive
ããg o
)
ãão p
)
ããp q
;
ããq r
}
åå 
public
éé 

async
éé 
Task
éé 
<
éé 
PriorityDto
éé !
?
éé! "
>
éé" #"
GetPriorityByIdAsync
éé$ 8
(
éé8 9
int
éé9 <
id
éé= ?
)
éé? @
{
èè 
var
êê 
p
êê 
=
êê 
await
êê 
_priorityRepo
êê #
.
êê# $
GetByIdAsync
êê$ 0
(
êê0 1
id
êê1 3
)
êê3 4
;
êê4 5
if
ëë 

(
ëë 
p
ëë 
==
ëë 
null
ëë 
)
ëë 
return
ëë 
null
ëë "
;
ëë" #
return
íí 
new
íí 
PriorityDto
íí 
(
íí 
p
íí  
.
íí  !
Id
íí! #
,
íí# $
p
íí% &
.
íí& '
Name
íí' +
,
íí+ ,
p
íí- .
.
íí. /
ColorHex
íí/ 7
,
íí7 8
p
íí9 :
.
íí: ;
Weight
íí; A
,
ííA B
p
ííC D
.
ííD E
SeverityLevel
ííE R
,
ííR S
p
ííT U
.
ííU V
IsActive
ííV ^
)
íí^ _
;
íí_ `
}
ìì 
public
ïï 

async
ïï 
Task
ïï 
<
ïï 
PriorityDto
ïï !
>
ïï! "!
CreatePriorityAsync
ïï# 6
(
ïï6 7
CreatePriorityDto
ïï7 H
dto
ïïI L
)
ïïL M
{
ññ 
var
óó 
p
óó 
=
óó 
new
óó 
Priority
óó 
{
óó 
Name
óó #
=
óó$ %
dto
óó& )
.
óó) *
Name
óó* .
,
óó. /
ColorHex
óó0 8
=
óó9 :
dto
óó; >
.
óó> ?
ColorHex
óó? G
,
óóG H
Weight
óóI O
=
óóP Q
dto
óóR U
.
óóU V
Weight
óóV \
,
óó\ ]
SeverityLevel
óó^ k
=
óól m
dto
óón q
.
óóq r
SeverityLevel
óór 
}óóÄ Å
;óóÅ Ç
await
òò 
_priorityRepo
òò 
.
òò 
AddAsync
òò $
(
òò$ %
p
òò% &
)
òò& '
;
òò' (
return
ôô 
new
ôô 
PriorityDto
ôô 
(
ôô 
p
ôô  
.
ôô  !
Id
ôô! #
,
ôô# $
p
ôô% &
.
ôô& '
Name
ôô' +
,
ôô+ ,
p
ôô- .
.
ôô. /
ColorHex
ôô/ 7
,
ôô7 8
p
ôô9 :
.
ôô: ;
Weight
ôô; A
,
ôôA B
p
ôôC D
.
ôôD E
SeverityLevel
ôôE R
,
ôôR S
p
ôôT U
.
ôôU V
IsActive
ôôV ^
)
ôô^ _
;
ôô_ `
}
öö 
public
úú 

async
úú 
Task
úú !
UpdatePriorityAsync
úú )
(
úú) *
int
úú* -
id
úú. 0
,
úú0 1
UpdatePriorityDto
úú2 C
dto
úúD G
)
úúG H
{
ùù 
var
ûû 
p
ûû 
=
ûû 
await
ûû 
_priorityRepo
ûû #
.
ûû# $
GetByIdAsync
ûû$ 0
(
ûû0 1
id
ûû1 3
)
ûû3 4
;
ûû4 5
if
üü 

(
üü 
p
üü 
==
üü 
null
üü 
)
üü 
throw
üü 
new
üü  "
KeyNotFoundException
üü! 5
(
üü5 6
$str
üü6 J
)
üüJ K
;
üüK L
p
†† 	
.
††	 

Name
††
 
=
†† 
dto
†† 
.
†† 
Name
†† 
;
†† 
p
†† 
.
†† 
ColorHex
†† %
=
††& '
dto
††( +
.
††+ ,
ColorHex
††, 4
;
††4 5
p
††6 7
.
††7 8
Weight
††8 >
=
††? @
dto
††A D
.
††D E
Weight
††E K
;
††K L
p
††M N
.
††N O
SeverityLevel
††O \
=
††] ^
dto
††_ b
.
††b c
SeverityLevel
††c p
;
††p q
p
††r s
.
††s t
IsActive
††t |
=
††} ~
dto†† Ç
.††Ç É
IsActive††É ã
;††ã å
await
°° 
_priorityRepo
°° 
.
°° 
UpdateAsync
°° '
(
°°' (
p
°°( )
)
°°) *
;
°°* +
}
¢¢ 
public
§§ 

async
§§ 
Task
§§ !
DeletePriorityAsync
§§ )
(
§§) *
int
§§* -
id
§§. 0
)
§§0 1
=>
§§2 4
await
§§5 :
_priorityRepo
§§; H
.
§§H I
DeleteAsync
§§I T
(
§§T U
id
§§U W
)
§§W X
;
§§X Y
}•• ˛R
_/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/AuthService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public		 
class		 
AuthService		 
:		 
IAuthService		 '
{

 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly 
ITokenService "
_tokenService# 0
;0 1
private 
readonly !
IPermissionCalculator *!
_permissionCalculator+ @
;@ A
private 
readonly 
IConfiguration #
_configuration$ 2
;2 3
public 

AuthService 
( 
ItsToolDbContext 
context  
,  !
ITokenService 
tokenService "
," #!
IPermissionCalculator  
permissionCalculator 2
,2 3
IConfiguration 
configuration $
)$ %
{ 
_context 
= 
context 
; 
_tokenService 
= 
tokenService $
;$ %!
_permissionCalculator 
=  
permissionCalculator  4
;4 5
_configuration 
= 
configuration &
;& '
} 
public 

async 
Task 
< 
AuthResponseDto %
>% &

LoginAsync' 1
(1 2
LoginRequestDto2 A
requestB I
)I J
{ 
var 
user 
= 
await 
_context !
.! "
Users" '
.   
FirstOrDefaultAsync    
(    !
u  ! "
=>  # %
(!! 
string!! 
.!! 
Equals!! 
(!! 
u!!  
.!!  !
Username!!! )
,!!) *
request!!+ 2
.!!2 3
Username!!3 ;
,!!; <
StringComparison!!= M
.!!M N
OrdinalIgnoreCase!!N _
)!!_ `
||!!a c
string"" 
."" 
Equals"" 
("" 
u""  
.""  !
Email""! &
,""& '
request""( /
.""/ 0
Username""0 8
,""8 9
StringComparison"": J
.""J K
OrdinalIgnoreCase""K \
)""\ ]
)""] ^
&&""_ a
u## 
.## 
IsActive## 
&&## 
!## 
u##  
.##  !
	IsDeleted##! *
)##* +
;##+ ,
if%% 

(%% 
user%% 
==%% 
null%% 
||%% 
!%% 
BCrypt%% #
.%%# $
Net%%$ '
.%%' (
BCrypt%%( .
.%%. /
Verify%%/ 5
(%%5 6
request%%6 =
.%%= >
Password%%> F
,%%F G
user%%H L
.%%L M
PasswordHash%%M Y
)%%Y Z
)%%Z [
{&& 	
throw'' 
new'' '
UnauthorizedAccessException'' 1
(''1 2
$str''2 H
)''H I
;''I J
}(( 	
var** 
roles** 
=** 
await** 
_context** "
.**" #
	UserRoles**# ,
.++ 
Where++ 
(++ 
ur++ 
=>++ 
ur++ 
.++ 
UserId++ "
==++# %
user++& *
.++* +
Id+++ -
&&++. 0
ur++1 3
.++3 4
Role++4 8
!=++9 ;
null++< @
&&++A C
ur++D F
.++F G
Role++G K
.++K L
IsActive++L T
)++T U
.,, 
Select,, 
(,, 
ur,, 
=>,, 
ur,, 
.,, 
Role,, !
!,,! "
.,," #
Name,,# '
),,' (
.-- 
ToListAsync-- 
(-- 
)-- 
;-- 
var// 
permissions// 
=// 
await// !
_permissionCalculator//  5
.//5 6.
"CalculateEffectivePermissionsAsync//6 X
(//X Y
user//Y ]
.//] ^
Id//^ `
)//` a
;//a b
var11 
token11 
=11 
_tokenService11 !
.11! "
GenerateToken11" /
(11/ 0
user110 4
.114 5
Id115 7
,117 8
user119 =
.11= >
Username11> F
,11F G
roles11H M
,11M N
permissions11O Z
)11Z [
;11[ \
var33 
expiryMinutes33 
=33 
double33 "
.33" #
Parse33# (
(33( )
_configuration33) 7
[337 8
$str338 K
]33K L
??33M O
$str33P U
)33U V
;33V W
return55 
new55 
AuthResponseDto55 "
(55" #
Token66 
:66 
token66 
,66 
	ExpiresAt77 
:77 
DateTime77 
.77  
UtcNow77  &
.77& '

AddMinutes77' 1
(771 2
expiryMinutes772 ?
)77? @
,77@ A
Username88 
:88 
user88 
.88 
Username88 #
,88# $
Roles99 
:99 
roles99 
,99 
Permissions:: 
::: 
permissions:: $
);; 	
;;;	 

}<< 
public>> 

async>> 
Task>> 
<>> 
MeResponseDto>> #
>>># $

GetMeAsync>>% /
(>>/ 0
int>>0 3
userId>>4 :
)>>: ;
{?? 
var@@ 
user@@ 
=@@ 
await@@ 
_context@@ !
.@@! "
Users@@" '
.AA 
FirstOrDefaultAsyncAA  
(AA  !
uAA! "
=>AA# %
uAA& '
.AA' (
IdAA( *
==AA+ -
userIdAA. 4
&&AA5 7
uAA8 9
.AA9 :
IsActiveAA: B
&&AAC E
!AAF G
uAAG H
.AAH I
	IsDeletedAAI R
)AAR S
;AAS T
ifCC 

(CC 
userCC 
==CC 
nullCC 
)CC 
throwDD 
newDD '
UnauthorizedAccessExceptionDD 1
(DD1 2
$strDD2 C
)DDC D
;DDD E
varFF 
rolesFF 
=FF 
awaitFF 
_contextFF "
.FF" #
	UserRolesFF# ,
.GG 
WhereGG 
(GG 
urGG 
=>GG 
urGG 
.GG 
UserIdGG "
==GG# %
userGG& *
.GG* +
IdGG+ -
&&GG. 0
urGG1 3
.GG3 4
RoleGG4 8
!=GG9 ;
nullGG< @
&&GGA C
urGGD F
.GGF G
RoleGGG K
.GGK L
IsActiveGGL T
)GGT U
.HH 
SelectHH 
(HH 
urHH 
=>HH 
urHH 
.HH 
RoleHH !
!HH! "
.HH" #
NameHH# '
)HH' (
.II 
ToListAsyncII 
(II 
)II 
;II 
varKK 
groupsKK 
=KK 
awaitKK 
_contextKK #
.KK# $
GroupMembersKK$ 0
.LL 
WhereLL 
(LL 
gmLL 
=>LL 
gmLL 
.LL 
UserIdLL "
==LL# %
userLL& *
.LL* +
IdLL+ -
&&LL. 0
gmLL1 3
.LL3 4
GroupLL4 9
!=LL: <
nullLL= A
&&LLB D
gmLLE G
.LLG H
GroupLLH M
.LLM N
IsActiveLLN V
)LLV W
.MM 
SelectMM 
(MM 
gmMM 
=>MM 
gmMM 
.MM 
GroupMM "
!MM" #
.MM# $
NameMM$ (
)MM( )
.NN 
ToListAsyncNN 
(NN 
)NN 
;NN 
varPP 
permissionsPP 
=PP 
awaitPP !
_permissionCalculatorPP  5
.PP5 6.
"CalculateEffectivePermissionsAsyncPP6 X
(PPX Y
userPPY ]
.PP] ^
IdPP^ `
)PP` a
;PPa b
varRR 
	overridesRR 
=RR 
awaitRR 
_contextRR &
.RR& '#
UserPermissionOverridesRR' >
.SS 
IncludeSS 
(SS 
oSS 
=>SS 
oSS 
.SS 

PermissionSS &
)SS& '
.TT 
WhereTT 
(TT 
oTT 
=>TT 
oTT 
.TT 
UserIdTT  
==TT! #
userTT$ (
.TT( )
IdTT) +
&&TT, .
oTT/ 0
.TT0 1
	IsGrantedTT1 :
&&TT; =
!TT> ?
oTT? @
.TT@ A
	IsDeletedTTA J
&&TTK M
oTTN O
.TTO P

PermissionTTP Z
!=TT[ ]
nullTT^ b
&&TTc e
oTTf g
.TTg h

PermissionTTh r
.TTr s
IsActiveTTs {
&&TT| ~
!	TT Ä
o
TTÄ Å
.
TTÅ Ç

Permission
TTÇ å
.
TTå ç
	IsDeleted
TTç ñ
)
TTñ ó
.UU 
SelectUU 
(UU 
oUU 
=>UU 
oUU 
.UU 

PermissionUU %
!UU% &
.UU& '
KeyUU' *
)UU* +
.VV 
ToListAsyncVV 
(VV 
)VV 
;VV 
returnXX 
newXX 
MeResponseDtoXX  
(XX  !
IdYY 
:YY 
userYY 
.YY 
IdYY 
,YY 
UsernameZZ 
:ZZ 
userZZ 
.ZZ 
UsernameZZ #
,ZZ# $
Email[[ 
:[[ 
user[[ 
.[[ 
Email[[ 
,[[ 
Groups\\ 
:\\ 
groups\\ 
,\\ 
Roles]] 
:]] 
roles]] 
,]] 
Permissions^^ 
:^^ 
permissions^^ $
,^^$ %
	Overrides__ 
:__ 
	overrides__  
)`` 	
;``	 

}aa 
}bb Ì
d/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/AssignmentEngine.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public

 
class

 
AssignmentEngine

 
:

 
IAssignmentEngine

  1
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

AssignmentEngine 
( 
ItsToolDbContext ,
context- 4
)4 5
{ 
_context 
= 
context 
; 
} 
public 

async 
Task 
AssignTicketAsync '
(' (
Ticket( .
ticket/ 5
)5 6
{ 
var 
rules 
= 
await 
_context "
." #
AssignmentRules# 2
. 
Where 
( 
r 
=> 
r 
. 
IsActive "
&&# %
!& '
r' (
.( )
	IsDeleted) 2
)2 3
. 
OrderBy 
( 
r 
=> 
r 
. 
	SortOrder %
)% &
. 
ToListAsync 
( 
) 
; 
foreach 
( 
var 
rule 
in 
rules "
)" #
{ 	
if 
( 
rule 
. 
	ProjectId 
. 
HasValue '
&&( *
rule+ /
./ 0
	ProjectId0 9
.9 :
Value: ?
!=@ B
ticketC I
.I J
	ProjectIdJ S
)S T
continueU ]
;] ^
if 
( 
rule 
. 

CategoryId 
.  
HasValue  (
&&) +
rule, 0
.0 1

CategoryId1 ;
.; <
Value< A
!=B D
ticketE K
.K L

CategoryIdL V
)V W
continueX `
;` a
if 
( 
rule 
. 
TicketTypeId !
.! "
HasValue" *
&&+ -
rule. 2
.2 3
TicketTypeId3 ?
.? @
Value@ E
!=F H
ticketI O
.O P
TypeIdP V
)V W
continueX `
;` a
if 
( 
rule 
. 

PriorityId 
.  
HasValue  (
&&) +
rule, 0
.0 1

PriorityId1 ;
.; <
Value< A
!=B D
ticketE K
.K L

PriorityIdL V
)V W
continueX `
;` a
ticket"" 
."" 
AssignedGroupId"" "
=""# $
rule""% )
."") *
TargetGroupId""* 7
;""7 8
ticket## 
.## 
AssignedUserId## !
=##" #
rule##$ (
.##( )
TargetUserId##) 5
;##5 6
return&& 
;&& 
}'' 	
}(( 
})) Ö"
`/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Security/TokenService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Security! )
;) *
public

 
class

 
TokenService

 
:

 
ITokenService

 )
{ 
private 
readonly 
IConfiguration #
_configuration$ 2
;2 3
public 

TokenService 
( 
IConfiguration &
configuration' 4
)4 5
{ 
_configuration 
= 
configuration &
;& '
} 
public 

string 
GenerateToken 
(  
int  #
userId$ *
,* +
string, 2
username3 ;
,; <
IEnumerable= H
<H I
stringI O
>O P
rolesQ V
,V W
IEnumerableX c
<c d
stringd j
>j k
permissionsl w
)w x
{ 
var 
claims 
= 
new 
List 
< 
Claim #
># $
{ 	
new 
Claim 
( #
JwtRegisteredClaimNames -
.- .
Sub. 1
,1 2
userId3 9
.9 :
ToString: B
(B C
)C D
)D E
,E F
new 
Claim 
( 

ClaimTypes  
.  !
Name! %
,% &
username' /
)/ 0
} 	
;	 

foreach 
( 
var 
role 
in 
roles "
)" #
{ 	
claims 
. 
Add 
( 
new 
Claim  
(  !

ClaimTypes! +
.+ ,
Role, 0
,0 1
role2 6
)6 7
)7 8
;8 9
} 	
foreach   
(   
var   
perm   
in   
permissions   (
)  ( )
{!! 	
claims"" 
."" 
Add"" 
("" 
new"" 
Claim""  
(""  !
$str""! -
,""- .
perm""/ 3
)""3 4
)""4 5
;""5 6
}## 	
var%% 
key%% 
=%% 
new%%  
SymmetricSecurityKey%% *
(%%* +
Encoding%%+ 3
.%%3 4
UTF8%%4 8
.%%8 9
GetBytes%%9 A
(%%A B
_configuration%%B P
[%%P Q
$str%%Q ]
]%%] ^
!%%^ _
)%%_ `
)%%` a
;%%a b
var&& 
creds&& 
=&& 
new&& 
SigningCredentials&& *
(&&* +
key&&+ .
,&&. /
SecurityAlgorithms&&0 B
.&&B C

HmacSha256&&C M
)&&M N
;&&N O
var(( 
expiryMinutes(( 
=(( 
double(( "
.((" #
Parse((# (
(((( )
_configuration(() 7
[((7 8
$str((8 K
]((K L
??((M O
$str((P U
)((U V
;((V W
var** 
token** 
=** 
new** 
JwtSecurityToken** (
(**( )
issuer++ 
:++ 
_configuration++ "
[++" #
$str++# /
]++/ 0
,++0 1
audience,, 
:,, 
_configuration,, $
[,,$ %
$str,,% 3
],,3 4
,,,4 5
claims-- 
:-- 
claims-- 
,-- 
expires.. 
:.. 
DateTime.. 
... 
UtcNow.. $
...$ %

AddMinutes..% /
(../ 0
expiryMinutes..0 =
)..= >
,..> ?
signingCredentials// 
:// 
creds//  %
)00 	
;00	 

return22 
new22 #
JwtSecurityTokenHandler22 *
(22* +
)22+ ,
.22, -

WriteToken22- 7
(227 8
token228 =
)22= >
;22> ?
}33 
}44 ò
{/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260825123956_AddProjectStatus3State.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public 

partial 
class "
AddProjectStatus3State /
:0 1
	Migration2 ;
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
int' *
>* +
(+ ,
name 
: 
$str 
, 
table 
: 
$str !
,! "
type 
: 
$str 
,  
nullable 
: 
false 
,  
defaultValue 
: 
$num 
)  
;  !
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str 
, 
table 
: 
$str !
)! "
;" #
} 	
} 
}  
x/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260825120248_AddUserProfilePhoto.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public 

partial 
class 
AddUserProfilePhoto ,
:- .
	Migration/ 8
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str $
,$ %
table 
: 
$str 
, 
type 
: 
$str 
, 
nullable 
: 
true 
) 
;  
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str $
,$ %
table 
: 
$str 
) 
;  
} 	
} 
} ‡/
v/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260819125432_AddSystemAuditLog.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public

 

partial

 
class

 
AddSystemAuditLog

 *
:

+ ,
	Migration

- 6
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str '
,' (
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }

EntityName 
=  
table! &
.& '
Column' -
<- .
string. 4
>4 5
(5 6
type6 :
:: ;
$str< B
,B C
nullableD L
:L M
falseN S
)S T
,T U
EntityId 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: @
,@ A
nullableB J
:J K
falseL Q
)Q R
,R S
Action 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 >
,> ?
nullable@ H
:H I
falseJ O
)O P
,P Q
	FieldName 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
OldValue 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: @
,@ A
nullableB J
:J K
trueL P
)P Q
,Q R
NewValue 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: @
,@ A
nullableB J
:J K
trueL P
)P Q
,Q R
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
falsec h
)h i
,i j
	CreatedBy 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
	UpdatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
truec g
)g h
,h i
	UpdatedBy 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
IsActive 
= 
table $
.$ %
Column% +
<+ ,
bool, 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
	IsDeleted   
=   
table    %
.  % &
Column  & ,
<  , -
bool  - 1
>  1 2
(  2 3
type  3 7
:  7 8
$str  9 B
,  B C
nullable  D L
:  L M
false  N S
)  S T
,  T U
	DeletedAt!! 
=!! 
table!!  %
.!!% &
Column!!& ,
<!!, -
DateTime!!- 5
>!!5 6
(!!6 7
type!!7 ;
:!!; <
$str!!= W
,!!W X
nullable!!Y a
:!!a b
true!!c g
)!!g h
}"" 
,"" 
constraints## 
:## 
table## "
=>### %
{$$ 
table%% 
.%% 

PrimaryKey%% $
(%%$ %
$str%%% 9
,%%9 :
x%%; <
=>%%= ?
x%%@ A
.%%A B
Id%%B D
)%%D E
;%%E F
}&& 
)&& 
;&& 
}'' 	
	protected** 
override** 
void** 
Down**  $
(**$ %
MigrationBuilder**% 5
migrationBuilder**6 F
)**F G
{++ 	
migrationBuilder,, 
.,, 
	DropTable,, &
(,,& '
name-- 
:-- 
$str-- '
)--' (
;--( )
}.. 	
}// 
}00 ©8
w/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260817064219_AddPhase11Entities.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public

 

partial

 
class

 
AddPhase11Entities

 +
:

, -
	Migration

. 7
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
DateTime' /
>/ 0
(0 1
name 
: 
$str #
,# $
table 
: 
$str #
,# $
type 
: 
$str 0
,0 1
nullable 
: 
true 
) 
;  
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str )
,) *
table 
: 
$str  
,  !
type 
: 
$str 
, 
nullable 
: 
true 
) 
;  
migrationBuilder 
. 
	AddColumn &
<& '
bool' +
>+ ,
(, -
name 
: 
$str (
,( )
table 
: 
$str $
,$ %
type 
: 
$str 
,  
nullable 
: 
false 
,  
defaultValue   
:   
false   #
)  # $
;  $ %
migrationBuilder"" 
."" 
CreateTable"" (
(""( )
name## 
:## 
$str## ,
,##, -
columns$$ 
:$$ 
table$$ 
=>$$ !
new$$" %
{%% 
Id&& 
=&& 
table&& 
.&& 
Column&& %
<&&% &
int&&& )
>&&) *
(&&* +
type&&+ /
:&&/ 0
$str&&1 :
,&&: ;
nullable&&< D
:&&D E
false&&F K
)&&K L
.'' 

Annotation'' #
(''# $
$str''$ D
,''D E)
NpgsqlValueGenerationStrategy''F c
.''c d#
IdentityByDefaultColumn''d {
)''{ |
,''| }
Url(( 
=(( 
table(( 
.((  
Column((  &
<((& '
string((' -
>((- .
(((. /
type((/ 3
:((3 4
$str((5 ;
,((; <
nullable((= E
:((E F
false((G L
)((L M
,((M N
	EventsCsv)) 
=)) 
table))  %
.))% &
Column))& ,
<)), -
string))- 3
>))3 4
())4 5
type))5 9
:))9 :
$str)); A
,))A B
nullable))C K
:))K L
false))M R
)))R S
,))S T
Secret** 
=** 
table** "
.**" #
Column**# )
<**) *
string*** 0
>**0 1
(**1 2
type**2 6
:**6 7
$str**8 >
,**> ?
nullable**@ H
:**H I
false**J O
)**O P
,**P Q
IsActive++ 
=++ 
table++ $
.++$ %
Column++% +
<+++ ,
bool++, 0
>++0 1
(++1 2
type++2 6
:++6 7
$str++8 A
,++A B
nullable++C K
:++K L
false++M R
)++R S
,++S T
	CreatedAt,, 
=,, 
table,,  %
.,,% &
Column,,& ,
<,,, -
DateTime,,- 5
>,,5 6
(,,6 7
type,,7 ;
:,,; <
$str,,= W
,,,W X
nullable,,Y a
:,,a b
false,,c h
),,h i
,,,i j
	CreatedBy-- 
=-- 
table--  %
.--% &
Column--& ,
<--, -
string--- 3
>--3 4
(--4 5
type--5 9
:--9 :
$str--; A
,--A B
nullable--C K
:--K L
true--M Q
)--Q R
,--R S
	UpdatedAt.. 
=.. 
table..  %
...% &
Column..& ,
<.., -
DateTime..- 5
>..5 6
(..6 7
type..7 ;
:..; <
$str..= W
,..W X
nullable..Y a
:..a b
true..c g
)..g h
,..h i
	UpdatedBy// 
=// 
table//  %
.//% &
Column//& ,
<//, -
string//- 3
>//3 4
(//4 5
type//5 9
://9 :
$str//; A
,//A B
nullable//C K
://K L
true//M Q
)//Q R
,//R S
	IsDeleted00 
=00 
table00  %
.00% &
Column00& ,
<00, -
bool00- 1
>001 2
(002 3
type003 7
:007 8
$str009 B
,00B C
nullable00D L
:00L M
false00N S
)00S T
,00T U
	DeletedAt11 
=11 
table11  %
.11% &
Column11& ,
<11, -
DateTime11- 5
>115 6
(116 7
type117 ;
:11; <
$str11= W
,11W X
nullable11Y a
:11a b
true11c g
)11g h
}22 
,22 
constraints33 
:33 
table33 "
=>33# %
{44 
table55 
.55 

PrimaryKey55 $
(55$ %
$str55% >
,55> ?
x55@ A
=>55B D
x55E F
.55F G
Id55G I
)55I J
;55J K
}66 
)66 
;66 
}77 	
	protected:: 
override:: 
void:: 
Down::  $
(::$ %
MigrationBuilder::% 5
migrationBuilder::6 F
)::F G
{;; 	
migrationBuilder<< 
.<< 
	DropTable<< &
(<<& '
name== 
:== 
$str== ,
)==, -
;==- .
migrationBuilder?? 
.?? 

DropColumn?? '
(??' (
name@@ 
:@@ 
$str@@ #
,@@# $
tableAA 
:AA 
$strAA #
)AA# $
;AA$ %
migrationBuilderCC 
.CC 

DropColumnCC '
(CC' (
nameDD 
:DD 
$strDD )
,DD) *
tableEE 
:EE 
$strEE  
)EE  !
;EE! "
migrationBuilderGG 
.GG 

DropColumnGG '
(GG' (
nameHH 
:HH 
$strHH (
,HH( )
tableII 
:II 
$strII $
)II$ %
;II% &
}JJ 	
}KK 
}LL Õ1
t/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260817062033_AddTicketSurvey.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public

 

partial

 
class

 
AddTicketSurvey

 (
:

) *
	Migration

+ 4
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str %
,% &
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
TicketId 
= 
table $
.$ %
Column% +
<+ ,
int, /
>/ 0
(0 1
type1 5
:5 6
$str7 @
,@ A
nullableB J
:J K
falseL Q
)Q R
,R S
Rating 
= 
table "
." #
Column# )
<) *
int* -
>- .
(. /
type/ 3
:3 4
$str5 >
,> ?
nullable@ H
:H I
falseJ O
)O P
,P Q
Comment 
= 
table #
.# $
Column$ *
<* +
string+ 1
>1 2
(2 3
type3 7
:7 8
$str9 ?
,? @
nullableA I
:I J
trueK O
)O P
,P Q
SubmittedAt 
=  !
table" '
.' (
Column( .
<. /
DateTime/ 7
>7 8
(8 9
type9 =
:= >
$str? Y
,Y Z
nullable[ c
:c d
falsee j
)j k
,k l
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
falsec h
)h i
,i j
	CreatedBy 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
	UpdatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
truec g
)g h
,h i
	UpdatedBy 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
IsActive 
= 
table $
.$ %
Column% +
<+ ,
bool, 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
	IsDeleted 
= 
table  %
.% &
Column& ,
<, -
bool- 1
>1 2
(2 3
type3 7
:7 8
$str9 B
,B C
nullableD L
:L M
falseN S
)S T
,T U
	DeletedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
truec g
)g h
}   
,   
constraints!! 
:!! 
table!! "
=>!!# %
{"" 
table## 
.## 

PrimaryKey## $
(##$ %
$str##% 7
,##7 8
x##9 :
=>##; =
x##> ?
.##? @
Id##@ B
)##B C
;##C D
table$$ 
.$$ 

ForeignKey$$ $
($$$ %
name%% 
:%% 
$str%% A
,%%A B
column&& 
:&& 
x&&  !
=>&&" $
x&&% &
.&&& '
TicketId&&' /
,&&/ 0
principalTable'' &
:''& '
$str''( 1
,''1 2
principalColumn(( '
:((' (
$str(() -
,((- .
onDelete))  
:))  !
ReferentialAction))" 3
.))3 4
Cascade))4 ;
))); <
;))< =
}** 
)** 
;** 
migrationBuilder,, 
.,, 
CreateIndex,, (
(,,( )
name-- 
:-- 
$str-- 1
,--1 2
table.. 
:.. 
$str.. &
,..& '
column// 
:// 
$str// "
)//" #
;//# $
}00 	
	protected33 
override33 
void33 
Down33  $
(33$ %
MigrationBuilder33% 5
migrationBuilder336 F
)33F G
{44 	
migrationBuilder55 
.55 
	DropTable55 &
(55& '
name66 
:66 
$str66 %
)66% &
;66& '
}77 	
}88 
}99 ÛÄ
v/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260817055743_AddPhase9Entities.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public

 

partial

 
class

 
AddPhase9Entities

 *
:

+ ,
	Migration

- 6
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str '
,' (
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
Name 
= 
table  
.  !
Column! '
<' (
string( .
>. /
(/ 0
type0 4
:4 5
$str6 <
,< =
nullable> F
:F G
falseH M
)M N
,N O
	ProjectId 
= 
table  %
.% &
Column& ,
<, -
int- 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S

CategoryId 
=  
table! &
.& '
Column' -
<- .
int. 1
>1 2
(2 3
type3 7
:7 8
$str9 B
,B C
nullableD L
:L M
trueN R
)R S
,S T
TicketTypeId  
=! "
table# (
.( )
Column) /
</ 0
int0 3
>3 4
(4 5
type5 9
:9 :
$str; D
,D E
nullableF N
:N O
trueP T
)T U
,U V

PriorityId 
=  
table! &
.& '
Column' -
<- .
int. 1
>1 2
(2 3
type3 7
:7 8
$str9 B
,B C
nullableD L
:L M
trueN R
)R S
,S T
TargetGroupId !
=" #
table$ )
.) *
Column* 0
<0 1
int1 4
>4 5
(5 6
type6 :
:: ;
$str< E
,E F
nullableG O
:O P
trueQ U
)U V
,V W
TargetUserId  
=! "
table# (
.( )
Column) /
</ 0
int0 3
>3 4
(4 5
type5 9
:9 :
$str; D
,D E
nullableF N
:N O
trueP T
)T U
,U V
	SortOrder 
= 
table  %
.% &
Column& ,
<, -
int- 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
IsActive 
= 
table $
.$ %
Column% +
<+ ,
bool, 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
falsec h
)h i
,i j
	CreatedBy 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
	UpdatedAt   
=   
table    %
.  % &
Column  & ,
<  , -
DateTime  - 5
>  5 6
(  6 7
type  7 ;
:  ; <
$str  = W
,  W X
nullable  Y a
:  a b
true  c g
)  g h
,  h i
	UpdatedBy!! 
=!! 
table!!  %
.!!% &
Column!!& ,
<!!, -
string!!- 3
>!!3 4
(!!4 5
type!!5 9
:!!9 :
$str!!; A
,!!A B
nullable!!C K
:!!K L
true!!M Q
)!!Q R
,!!R S
	IsDeleted"" 
="" 
table""  %
.""% &
Column""& ,
<"", -
bool""- 1
>""1 2
(""2 3
type""3 7
:""7 8
$str""9 B
,""B C
nullable""D L
:""L M
false""N S
)""S T
,""T U
	DeletedAt## 
=## 
table##  %
.##% &
Column##& ,
<##, -
DateTime##- 5
>##5 6
(##6 7
type##7 ;
:##; <
$str##= W
,##W X
nullable##Y a
:##a b
true##c g
)##g h
}$$ 
,$$ 
constraints%% 
:%% 
table%% "
=>%%# %
{&& 
table'' 
.'' 

PrimaryKey'' $
(''$ %
$str''% 9
,''9 :
x''; <
=>''= ?
x''@ A
.''A B
Id''B D
)''D E
;''E F
table(( 
.(( 

ForeignKey(( $
((($ %
name)) 
:)) 
$str)) H
,))H I
column** 
:** 
x**  !
=>**" $
x**% &
.**& '

CategoryId**' 1
,**1 2
principalTable++ &
:++& '
$str++( 4
,++4 5
principalColumn,, '
:,,' (
$str,,) -
),,- .
;,,. /
table-- 
.-- 

ForeignKey-- $
(--$ %
name.. 
:.. 
$str.. G
,..G H
column// 
:// 
x//  !
=>//" $
x//% &
.//& '
TargetGroupId//' 4
,//4 5
principalTable00 &
:00& '
$str00( 0
,000 1
principalColumn11 '
:11' (
$str11) -
)11- .
;11. /
table22 
.22 

ForeignKey22 $
(22$ %
name33 
:33 
$str33 H
,33H I
column44 
:44 
x44  !
=>44" $
x44% &
.44& '

PriorityId44' 1
,441 2
principalTable55 &
:55& '
$str55( 4
,554 5
principalColumn66 '
:66' (
$str66) -
)66- .
;66. /
table77 
.77 

ForeignKey77 $
(77$ %
name88 
:88 
$str88 E
,88E F
column99 
:99 
x99  !
=>99" $
x99% &
.99& '
	ProjectId99' 0
,990 1
principalTable:: &
:::& '
$str::( 2
,::2 3
principalColumn;; '
:;;' (
$str;;) -
);;- .
;;;. /
table<< 
.<< 

ForeignKey<< $
(<<$ %
name== 
:== 
$str== K
,==K L
column>> 
:>> 
x>>  !
=>>>" $
x>>% &
.>>& '
TicketTypeId>>' 3
,>>3 4
principalTable?? &
:??& '
$str??( 5
,??5 6
principalColumn@@ '
:@@' (
$str@@) -
)@@- .
;@@. /
tableAA 
.AA 

ForeignKeyAA $
(AA$ %
nameBB 
:BB 
$strBB E
,BBE F
columnCC 
:CC 
xCC  !
=>CC" $
xCC% &
.CC& '
TargetUserIdCC' 3
,CC3 4
principalTableDD &
:DD& '
$strDD( /
,DD/ 0
principalColumnEE '
:EE' (
$strEE) -
)EE- .
;EE. /
}FF 
)FF 
;FF 
migrationBuilderHH 
.HH 
CreateTableHH (
(HH( )
nameII 
:II 
$strII $
,II$ %
columnsJJ 
:JJ 
tableJJ 
=>JJ !
newJJ" %
{KK 
IdLL 
=LL 
tableLL 
.LL 
ColumnLL %
<LL% &
intLL& )
>LL) *
(LL* +
typeLL+ /
:LL/ 0
$strLL1 :
,LL: ;
nullableLL< D
:LLD E
falseLLF K
)LLK L
.MM 

AnnotationMM #
(MM# $
$strMM$ D
,MMD E)
NpgsqlValueGenerationStrategyMMF c
.MMc d#
IdentityByDefaultColumnMMd {
)MM{ |
,MM| }
UserIdNN 
=NN 
tableNN "
.NN" #
ColumnNN# )
<NN) *
intNN* -
>NN- .
(NN. /
typeNN/ 3
:NN3 4
$strNN5 >
,NN> ?
nullableNN@ H
:NNH I
falseNNJ O
)NNO P
,NNP Q
NameOO 
=OO 
tableOO  
.OO  !
ColumnOO! '
<OO' (
stringOO( .
>OO. /
(OO/ 0
typeOO0 4
:OO4 5
$strOO6 <
,OO< =
nullableOO> F
:OOF G
falseOOH M
)OOM N
,OON O
	QueryJsonPP 
=PP 
tablePP  %
.PP% &
ColumnPP& ,
<PP, -
stringPP- 3
>PP3 4
(PP4 5
typePP5 9
:PP9 :
$strPP; A
,PPA B
nullablePPC K
:PPK L
falsePPM R
)PPR S
,PPS T
	CreatedAtQQ 
=QQ 
tableQQ  %
.QQ% &
ColumnQQ& ,
<QQ, -
DateTimeQQ- 5
>QQ5 6
(QQ6 7
typeQQ7 ;
:QQ; <
$strQQ= W
,QQW X
nullableQQY a
:QQa b
falseQQc h
)QQh i
,QQi j
	CreatedByRR 
=RR 
tableRR  %
.RR% &
ColumnRR& ,
<RR, -
stringRR- 3
>RR3 4
(RR4 5
typeRR5 9
:RR9 :
$strRR; A
,RRA B
nullableRRC K
:RRK L
trueRRM Q
)RRQ R
,RRR S
	UpdatedAtSS 
=SS 
tableSS  %
.SS% &
ColumnSS& ,
<SS, -
DateTimeSS- 5
>SS5 6
(SS6 7
typeSS7 ;
:SS; <
$strSS= W
,SSW X
nullableSSY a
:SSa b
trueSSc g
)SSg h
,SSh i
	UpdatedByTT 
=TT 
tableTT  %
.TT% &
ColumnTT& ,
<TT, -
stringTT- 3
>TT3 4
(TT4 5
typeTT5 9
:TT9 :
$strTT; A
,TTA B
nullableTTC K
:TTK L
trueTTM Q
)TTQ R
,TTR S
IsActiveUU 
=UU 
tableUU $
.UU$ %
ColumnUU% +
<UU+ ,
boolUU, 0
>UU0 1
(UU1 2
typeUU2 6
:UU6 7
$strUU8 A
,UUA B
nullableUUC K
:UUK L
falseUUM R
)UUR S
,UUS T
	IsDeletedVV 
=VV 
tableVV  %
.VV% &
ColumnVV& ,
<VV, -
boolVV- 1
>VV1 2
(VV2 3
typeVV3 7
:VV7 8
$strVV9 B
,VVB C
nullableVVD L
:VVL M
falseVVN S
)VVS T
,VVT U
	DeletedAtWW 
=WW 
tableWW  %
.WW% &
ColumnWW& ,
<WW, -
DateTimeWW- 5
>WW5 6
(WW6 7
typeWW7 ;
:WW; <
$strWW= W
,WWW X
nullableWWY a
:WWa b
trueWWc g
)WWg h
}XX 
,XX 
constraintsYY 
:YY 
tableYY "
=>YY# %
{ZZ 
table[[ 
.[[ 

PrimaryKey[[ $
([[$ %
$str[[% 6
,[[6 7
x[[8 9
=>[[: <
x[[= >
.[[> ?
Id[[? A
)[[A B
;[[B C
table\\ 
.\\ 

ForeignKey\\ $
(\\$ %
name]] 
:]] 
$str]] <
,]]< =
column^^ 
:^^ 
x^^  !
=>^^" $
x^^% &
.^^& '
UserId^^' -
,^^- .
principalTable__ &
:__& '
$str__( /
,__/ 0
principalColumn`` '
:``' (
$str``) -
,``- .
onDeleteaa  
:aa  !
ReferentialActionaa" 3
.aa3 4
Cascadeaa4 ;
)aa; <
;aa< =
}bb 
)bb 
;bb 
migrationBuilderdd 
.dd 
CreateIndexdd (
(dd( )
nameee 
:ee 
$stree 5
,ee5 6
tableff 
:ff 
$strff (
,ff( )
columngg 
:gg 
$strgg $
)gg$ %
;gg% &
migrationBuilderii 
.ii 
CreateIndexii (
(ii( )
namejj 
:jj 
$strjj 5
,jj5 6
tablekk 
:kk 
$strkk (
,kk( )
columnll 
:ll 
$strll $
)ll$ %
;ll% &
migrationBuildernn 
.nn 
CreateIndexnn (
(nn( )
nameoo 
:oo 
$stroo 4
,oo4 5
tablepp 
:pp 
$strpp (
,pp( )
columnqq 
:qq 
$strqq #
)qq# $
;qq$ %
migrationBuilderss 
.ss 
CreateIndexss (
(ss( )
namett 
:tt 
$strtt 8
,tt8 9
tableuu 
:uu 
$struu (
,uu( )
columnvv 
:vv 
$strvv '
)vv' (
;vv( )
migrationBuilderxx 
.xx 
CreateIndexxx (
(xx( )
nameyy 
:yy 
$stryy 7
,yy7 8
tablezz 
:zz 
$strzz (
,zz( )
column{{ 
:{{ 
$str{{ &
){{& '
;{{' (
migrationBuilder}} 
.}} 
CreateIndex}} (
(}}( )
name~~ 
:~~ 
$str~~ 7
,~~7 8
table 
: 
$str (
,( )
column
ÄÄ 
:
ÄÄ 
$str
ÄÄ &
)
ÄÄ& '
;
ÄÄ' (
migrationBuilder
ÇÇ 
.
ÇÇ 
CreateIndex
ÇÇ (
(
ÇÇ( )
name
ÉÉ 
:
ÉÉ 
$str
ÉÉ .
,
ÉÉ. /
table
ÑÑ 
:
ÑÑ 
$str
ÑÑ %
,
ÑÑ% &
column
ÖÖ 
:
ÖÖ 
$str
ÖÖ  
)
ÖÖ  !
;
ÖÖ! "
}
ÜÜ 	
	protected
ââ 
override
ââ 
void
ââ 
Down
ââ  $
(
ââ$ %
MigrationBuilder
ââ% 5
migrationBuilder
ââ6 F
)
ââF G
{
ää 	
migrationBuilder
ãã 
.
ãã 
	DropTable
ãã &
(
ãã& '
name
åå 
:
åå 
$str
åå '
)
åå' (
;
åå( )
migrationBuilder
éé 
.
éé 
	DropTable
éé &
(
éé& '
name
èè 
:
èè 
$str
èè $
)
èè$ %
;
èè% &
}
êê 	
}
ëë 
}íí ¸
w/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260814130918_UpdateKbVisibility.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public 

partial 
class 
UpdateKbVisibility +
:, -
	Migration. 7
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	DropIndex &
(& '
name 
: 
$str .
,. /
table 
: 
$str #
)# $
;$ %
migrationBuilder 
. 
	AddColumn &
<& '
int' *
>* +
(+ ,
name 
: 
$str "
," #
table 
: 
$str *
,* +
type 
: 
$str 
,  
nullable 
: 
false 
,  
defaultValue 
: 
$num 
)  
;  !
migrationBuilder 
. 
CreateIndex (
(( )
name 
: 
$str .
,. /
table 
: 
$str #
,# $
column 
: 
$str "
," #
unique 
: 
true 
) 
; 
} 	
	protected   
override   
void   
Down    $
(  $ %
MigrationBuilder  % 5
migrationBuilder  6 F
)  F G
{!! 	
migrationBuilder"" 
."" 
	DropIndex"" &
(""& '
name## 
:## 
$str## .
,##. /
table$$ 
:$$ 
$str$$ #
)$$# $
;$$$ %
migrationBuilder&& 
.&& 

DropColumn&& '
(&&' (
name'' 
:'' 
$str'' "
,''" #
table(( 
:(( 
$str(( *
)((* +
;((+ ,
migrationBuilder** 
.** 
CreateIndex** (
(**( )
name++ 
:++ 
$str++ .
,++. /
table,, 
:,, 
$str,, #
,,,# $
column-- 
:-- 
$str-- "
)--" #
;--# $
}.. 	
}// 
}00 ®í
{/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260814041907_AddSlaAndNotifications.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public

 

partial

 
class

 "
AddSlaAndNotifications

 /
:

0 1
	Migration

2 ;
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
bool' +
>+ ,
(, -
name 
: 
$str !
,! "
table 
: 
$str !
,! "
type 
: 
$str 
,  
nullable 
: 
false 
,  
defaultValue 
: 
false #
)# $
;$ %
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str (
,( )
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
	ProjectId 
= 
table  %
.% &
Column& ,
<, -
int- 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
CurrentValue  
=! "
table# (
.( )
Column) /
</ 0
int0 3
>3 4
(4 5
type5 9
:9 :
$str; D
,D E
nullableF N
:N O
falseP U
)U V
,V W
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
falsec h
)h i
,i j
	CreatedBy 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
	UpdatedAt   
=   
table    %
.  % &
Column  & ,
<  , -
DateTime  - 5
>  5 6
(  6 7
type  7 ;
:  ; <
$str  = W
,  W X
nullable  Y a
:  a b
true  c g
)  g h
,  h i
	UpdatedBy!! 
=!! 
table!!  %
.!!% &
Column!!& ,
<!!, -
string!!- 3
>!!3 4
(!!4 5
type!!5 9
:!!9 :
$str!!; A
,!!A B
nullable!!C K
:!!K L
true!!M Q
)!!Q R
,!!R S
IsActive"" 
="" 
table"" $
.""$ %
Column""% +
<""+ ,
bool"", 0
>""0 1
(""1 2
type""2 6
:""6 7
$str""8 A
,""A B
nullable""C K
:""K L
false""M R
)""R S
,""S T
	IsDeleted## 
=## 
table##  %
.##% &
Column##& ,
<##, -
bool##- 1
>##1 2
(##2 3
type##3 7
:##7 8
$str##9 B
,##B C
nullable##D L
:##L M
false##N S
)##S T
,##T U
	DeletedAt$$ 
=$$ 
table$$  %
.$$% &
Column$$& ,
<$$, -
DateTime$$- 5
>$$5 6
($$6 7
type$$7 ;
:$$; <
$str$$= W
,$$W X
nullable$$Y a
:$$a b
true$$c g
)$$g h
}%% 
,%% 
constraints&& 
:&& 
table&& "
=>&&# %
{'' 
table(( 
.(( 

PrimaryKey(( $
((($ %
$str((% :
,((: ;
x((< =
=>((> @
x((A B
.((B C
Id((C E
)((E F
;((F G
table)) 
.)) 

ForeignKey)) $
())$ %
name** 
:** 
$str** F
,**F G
column++ 
:++ 
x++  !
=>++" $
x++% &
.++& '
	ProjectId++' 0
,++0 1
principalTable,, &
:,,& '
$str,,( 2
,,,2 3
principalColumn-- '
:--' (
$str--) -
,--- .
onDelete..  
:..  !
ReferentialAction.." 3
...3 4
Cascade..4 ;
)..; <
;..< =
}// 
)// 
;// 
migrationBuilder11 
.11 
CreateTable11 (
(11( )
name22 
:22 
$str22 )
,22) *
columns33 
:33 
table33 
=>33 !
new33" %
{44 
Id55 
=55 
table55 
.55 
Column55 %
<55% &
int55& )
>55) *
(55* +
type55+ /
:55/ 0
$str551 :
,55: ;
nullable55< D
:55D E
false55F K
)55K L
.66 

Annotation66 #
(66# $
$str66$ D
,66D E)
NpgsqlValueGenerationStrategy66F c
.66c d#
IdentityByDefaultColumn66d {
)66{ |
,66| }
TicketId77 
=77 
table77 $
.77$ %
Column77% +
<77+ ,
int77, /
>77/ 0
(770 1
type771 5
:775 6
$str777 @
,77@ A
nullable77B J
:77J K
false77L Q
)77Q R
,77R S
FileName88 
=88 
table88 $
.88$ %
Column88% +
<88+ ,
string88, 2
>882 3
(883 4
type884 8
:888 9
$str88: @
,88@ A
nullable88B J
:88J K
false88L Q
)88Q R
,88R S
FilePath99 
=99 
table99 $
.99$ %
Column99% +
<99+ ,
string99, 2
>992 3
(993 4
type994 8
:998 9
$str99: @
,99@ A
nullable99B J
:99J K
false99L Q
)99Q R
,99R S
FileSize:: 
=:: 
table:: $
.::$ %
Column::% +
<::+ ,
long::, 0
>::0 1
(::1 2
type::2 6
:::6 7
$str::8 @
,::@ A
nullable::B J
:::J K
false::L Q
)::Q R
,::R S
ContentType;; 
=;;  !
table;;" '
.;;' (
Column;;( .
<;;. /
string;;/ 5
>;;5 6
(;;6 7
type;;7 ;
:;;; <
$str;;= C
,;;C D
nullable;;E M
:;;M N
false;;O T
);;T U
,;;U V
UploadedByUserId<< $
=<<% &
table<<' ,
.<<, -
Column<<- 3
<<<3 4
int<<4 7
><<7 8
(<<8 9
type<<9 =
:<<= >
$str<<? H
,<<H I
nullable<<J R
:<<R S
false<<T Y
)<<Y Z
,<<Z [
	CreatedAt== 
=== 
table==  %
.==% &
Column==& ,
<==, -
DateTime==- 5
>==5 6
(==6 7
type==7 ;
:==; <
$str=== W
,==W X
nullable==Y a
:==a b
false==c h
)==h i
,==i j
	CreatedBy>> 
=>> 
table>>  %
.>>% &
Column>>& ,
<>>, -
string>>- 3
>>>3 4
(>>4 5
type>>5 9
:>>9 :
$str>>; A
,>>A B
nullable>>C K
:>>K L
true>>M Q
)>>Q R
,>>R S
	UpdatedAt?? 
=?? 
table??  %
.??% &
Column??& ,
<??, -
DateTime??- 5
>??5 6
(??6 7
type??7 ;
:??; <
$str??= W
,??W X
nullable??Y a
:??a b
true??c g
)??g h
,??h i
	UpdatedBy@@ 
=@@ 
table@@  %
.@@% &
Column@@& ,
<@@, -
string@@- 3
>@@3 4
(@@4 5
type@@5 9
:@@9 :
$str@@; A
,@@A B
nullable@@C K
:@@K L
true@@M Q
)@@Q R
,@@R S
IsActiveAA 
=AA 
tableAA $
.AA$ %
ColumnAA% +
<AA+ ,
boolAA, 0
>AA0 1
(AA1 2
typeAA2 6
:AA6 7
$strAA8 A
,AAA B
nullableAAC K
:AAK L
falseAAM R
)AAR S
,AAS T
	IsDeletedBB 
=BB 
tableBB  %
.BB% &
ColumnBB& ,
<BB, -
boolBB- 1
>BB1 2
(BB2 3
typeBB3 7
:BB7 8
$strBB9 B
,BBB C
nullableBBD L
:BBL M
falseBBN S
)BBS T
,BBT U
	DeletedAtCC 
=CC 
tableCC  %
.CC% &
ColumnCC& ,
<CC, -
DateTimeCC- 5
>CC5 6
(CC6 7
typeCC7 ;
:CC; <
$strCC= W
,CCW X
nullableCCY a
:CCa b
trueCCc g
)CCg h
}DD 
,DD 
constraintsEE 
:EE 
tableEE "
=>EE# %
{FF 
tableGG 
.GG 

PrimaryKeyGG $
(GG$ %
$strGG% ;
,GG; <
xGG= >
=>GG? A
xGGB C
.GGC D
IdGGD F
)GGF G
;GGG H
tableHH 
.HH 

ForeignKeyHH $
(HH$ %
nameII 
:II 
$strII E
,IIE F
columnJJ 
:JJ 
xJJ  !
=>JJ" $
xJJ% &
.JJ& '
TicketIdJJ' /
,JJ/ 0
principalTableKK &
:KK& '
$strKK( 1
,KK1 2
principalColumnLL '
:LL' (
$strLL) -
,LL- .
onDeleteMM  
:MM  !
ReferentialActionMM" 3
.MM3 4
CascadeMM4 ;
)MM; <
;MM< =
tableNN 
.NN 

ForeignKeyNN $
(NN$ %
nameOO 
:OO 
$strOO K
,OOK L
columnPP 
:PP 
xPP  !
=>PP" $
xPP% &
.PP& '
UploadedByUserIdPP' 7
,PP7 8
principalTableQQ &
:QQ& '
$strQQ( /
,QQ/ 0
principalColumnRR '
:RR' (
$strRR) -
,RR- .
onDeleteSS  
:SS  !
ReferentialActionSS" 3
.SS3 4
CascadeSS4 ;
)SS; <
;SS< =
}TT 
)TT 
;TT 
migrationBuilderVV 
.VV 
CreateTableVV (
(VV( )
nameWW 
:WW 
$strWW &
,WW& '
columnsXX 
:XX 
tableXX 
=>XX !
newXX" %
{YY 
IdZZ 
=ZZ 
tableZZ 
.ZZ 
ColumnZZ %
<ZZ% &
intZZ& )
>ZZ) *
(ZZ* +
typeZZ+ /
:ZZ/ 0
$strZZ1 :
,ZZ: ;
nullableZZ< D
:ZZD E
falseZZF K
)ZZK L
.[[ 

Annotation[[ #
([[# $
$str[[$ D
,[[D E)
NpgsqlValueGenerationStrategy[[F c
.[[c d#
IdentityByDefaultColumn[[d {
)[[{ |
,[[| }
TicketId\\ 
=\\ 
table\\ $
.\\$ %
Column\\% +
<\\+ ,
int\\, /
>\\/ 0
(\\0 1
type\\1 5
:\\5 6
$str\\7 @
,\\@ A
nullable\\B J
:\\J K
false\\L Q
)\\Q R
,\\R S
AuthorUserId]]  
=]]! "
table]]# (
.]]( )
Column]]) /
<]]/ 0
int]]0 3
>]]3 4
(]]4 5
type]]5 9
:]]9 :
$str]]; D
,]]D E
nullable]]F N
:]]N O
false]]P U
)]]U V
,]]V W
Content^^ 
=^^ 
table^^ #
.^^# $
Column^^$ *
<^^* +
string^^+ 1
>^^1 2
(^^2 3
type^^3 7
:^^7 8
$str^^9 ?
,^^? @
nullable^^A I
:^^I J
false^^K P
)^^P Q
,^^Q R

IsInternal__ 
=__  
table__! &
.__& '
Column__' -
<__- .
bool__. 2
>__2 3
(__3 4
type__4 8
:__8 9
$str__: C
,__C D
nullable__E M
:__M N
false__O T
)__T U
,__U V
	CreatedAt`` 
=`` 
table``  %
.``% &
Column``& ,
<``, -
DateTime``- 5
>``5 6
(``6 7
type``7 ;
:``; <
$str``= W
,``W X
nullable``Y a
:``a b
false``c h
)``h i
,``i j
	CreatedByaa 
=aa 
tableaa  %
.aa% &
Columnaa& ,
<aa, -
stringaa- 3
>aa3 4
(aa4 5
typeaa5 9
:aa9 :
$straa; A
,aaA B
nullableaaC K
:aaK L
trueaaM Q
)aaQ R
,aaR S
	UpdatedAtbb 
=bb 
tablebb  %
.bb% &
Columnbb& ,
<bb, -
DateTimebb- 5
>bb5 6
(bb6 7
typebb7 ;
:bb; <
$strbb= W
,bbW X
nullablebbY a
:bba b
truebbc g
)bbg h
,bbh i
	UpdatedBycc 
=cc 
tablecc  %
.cc% &
Columncc& ,
<cc, -
stringcc- 3
>cc3 4
(cc4 5
typecc5 9
:cc9 :
$strcc; A
,ccA B
nullableccC K
:ccK L
trueccM Q
)ccQ R
,ccR S
IsActivedd 
=dd 
tabledd $
.dd$ %
Columndd% +
<dd+ ,
booldd, 0
>dd0 1
(dd1 2
typedd2 6
:dd6 7
$strdd8 A
,ddA B
nullableddC K
:ddK L
falseddM R
)ddR S
,ddS T
	IsDeletedee 
=ee 
tableee  %
.ee% &
Columnee& ,
<ee, -
boolee- 1
>ee1 2
(ee2 3
typeee3 7
:ee7 8
$stree9 B
,eeB C
nullableeeD L
:eeL M
falseeeN S
)eeS T
,eeT U
	DeletedAtff 
=ff 
tableff  %
.ff% &
Columnff& ,
<ff, -
DateTimeff- 5
>ff5 6
(ff6 7
typeff7 ;
:ff; <
$strff= W
,ffW X
nullableffY a
:ffa b
trueffc g
)ffg h
}gg 
,gg 
constraintshh 
:hh 
tablehh "
=>hh# %
{ii 
tablejj 
.jj 

PrimaryKeyjj $
(jj$ %
$strjj% 8
,jj8 9
xjj: ;
=>jj< >
xjj? @
.jj@ A
IdjjA C
)jjC D
;jjD E
tablekk 
.kk 

ForeignKeykk $
(kk$ %
namell 
:ll 
$strll B
,llB C
columnmm 
:mm 
xmm  !
=>mm" $
xmm% &
.mm& '
TicketIdmm' /
,mm/ 0
principalTablenn &
:nn& '
$strnn( 1
,nn1 2
principalColumnoo '
:oo' (
$stroo) -
,oo- .
onDeletepp  
:pp  !
ReferentialActionpp" 3
.pp3 4
Cascadepp4 ;
)pp; <
;pp< =
tableqq 
.qq 

ForeignKeyqq $
(qq$ %
namerr 
:rr 
$strrr D
,rrD E
columnss 
:ss 
xss  !
=>ss" $
xss% &
.ss& '
AuthorUserIdss' 3
,ss3 4
principalTablett &
:tt& '
$strtt( /
,tt/ 0
principalColumnuu '
:uu' (
$struu) -
,uu- .
onDeletevv  
:vv  !
ReferentialActionvv" 3
.vv3 4
Cascadevv4 ;
)vv; <
;vv< =
}ww 
)ww 
;ww 
migrationBuilderyy 
.yy 
CreateTableyy (
(yy( )
namezz 
:zz 
$strzz "
,zz" #
columns{{ 
:{{ 
table{{ 
=>{{ !
new{{" %
{|| 
Id}} 
=}} 
table}} 
.}} 
Column}} %
<}}% &
int}}& )
>}}) *
(}}* +
type}}+ /
:}}/ 0
$str}}1 :
,}}: ;
nullable}}< D
:}}D E
false}}F K
)}}K L
.~~ 

Annotation~~ #
(~~# $
$str~~$ D
,~~D E)
NpgsqlValueGenerationStrategy~~F c
.~~c d#
IdentityByDefaultColumn~~d {
)~~{ |
,~~| }
TicketId 
= 
table $
.$ %
Column% +
<+ ,
int, /
>/ 0
(0 1
type1 5
:5 6
$str7 @
,@ A
nullableB J
:J K
falseL Q
)Q R
,R S 
FirstResponseDueAt
ÄÄ &
=
ÄÄ' (
table
ÄÄ) .
.
ÄÄ. /
Column
ÄÄ/ 5
<
ÄÄ5 6
DateTime
ÄÄ6 >
>
ÄÄ> ?
(
ÄÄ? @
type
ÄÄ@ D
:
ÄÄD E
$str
ÄÄF `
,
ÄÄ` a
nullable
ÄÄb j
:
ÄÄj k
true
ÄÄl p
)
ÄÄp q
,
ÄÄq r
ResolutionDueAt
ÅÅ #
=
ÅÅ$ %
table
ÅÅ& +
.
ÅÅ+ ,
Column
ÅÅ, 2
<
ÅÅ2 3
DateTime
ÅÅ3 ;
>
ÅÅ; <
(
ÅÅ< =
type
ÅÅ= A
:
ÅÅA B
$str
ÅÅC ]
,
ÅÅ] ^
nullable
ÅÅ_ g
:
ÅÅg h
true
ÅÅi m
)
ÅÅm n
,
ÅÅn o
PausedAt
ÇÇ 
=
ÇÇ 
table
ÇÇ $
.
ÇÇ$ %
Column
ÇÇ% +
<
ÇÇ+ ,
DateTime
ÇÇ, 4
>
ÇÇ4 5
(
ÇÇ5 6
type
ÇÇ6 :
:
ÇÇ: ;
$str
ÇÇ< V
,
ÇÇV W
nullable
ÇÇX `
:
ÇÇ` a
true
ÇÇb f
)
ÇÇf g
,
ÇÇg h 
TotalPausedMinutes
ÉÉ &
=
ÉÉ' (
table
ÉÉ) .
.
ÉÉ. /
Column
ÉÉ/ 5
<
ÉÉ5 6
int
ÉÉ6 9
>
ÉÉ9 :
(
ÉÉ: ;
type
ÉÉ; ?
:
ÉÉ? @
$str
ÉÉA J
,
ÉÉJ K
nullable
ÉÉL T
:
ÉÉT U
false
ÉÉV [
)
ÉÉ[ \
,
ÉÉ\ ] 
FirstResponseMetAt
ÑÑ &
=
ÑÑ' (
table
ÑÑ) .
.
ÑÑ. /
Column
ÑÑ/ 5
<
ÑÑ5 6
DateTime
ÑÑ6 >
>
ÑÑ> ?
(
ÑÑ? @
type
ÑÑ@ D
:
ÑÑD E
$str
ÑÑF `
,
ÑÑ` a
nullable
ÑÑb j
:
ÑÑj k
true
ÑÑl p
)
ÑÑp q
,
ÑÑq r
ResolutionMetAt
ÖÖ #
=
ÖÖ$ %
table
ÖÖ& +
.
ÖÖ+ ,
Column
ÖÖ, 2
<
ÖÖ2 3
DateTime
ÖÖ3 ;
>
ÖÖ; <
(
ÖÖ< =
type
ÖÖ= A
:
ÖÖA B
$str
ÖÖC ]
,
ÖÖ] ^
nullable
ÖÖ_ g
:
ÖÖg h
true
ÖÖi m
)
ÖÖm n
,
ÖÖn o!
FirstResponseWarned
ÜÜ '
=
ÜÜ( )
table
ÜÜ* /
.
ÜÜ/ 0
Column
ÜÜ0 6
<
ÜÜ6 7
bool
ÜÜ7 ;
>
ÜÜ; <
(
ÜÜ< =
type
ÜÜ= A
:
ÜÜA B
$str
ÜÜC L
,
ÜÜL M
nullable
ÜÜN V
:
ÜÜV W
false
ÜÜX ]
)
ÜÜ] ^
,
ÜÜ^ _#
FirstResponseBreached
áá )
=
áá* +
table
áá, 1
.
áá1 2
Column
áá2 8
<
áá8 9
bool
áá9 =
>
áá= >
(
áá> ?
type
áá? C
:
ááC D
$str
ááE N
,
ááN O
nullable
ááP X
:
ááX Y
false
ááZ _
)
áá_ `
,
áá` a
ResolutionWarned
àà $
=
àà% &
table
àà' ,
.
àà, -
Column
àà- 3
<
àà3 4
bool
àà4 8
>
àà8 9
(
àà9 :
type
àà: >
:
àà> ?
$str
àà@ I
,
ààI J
nullable
ààK S
:
ààS T
false
ààU Z
)
ààZ [
,
àà[ \ 
ResolutionBreached
ââ &
=
ââ' (
table
ââ) .
.
ââ. /
Column
ââ/ 5
<
ââ5 6
bool
ââ6 :
>
ââ: ;
(
ââ; <
type
ââ< @
:
ââ@ A
$str
ââB K
,
ââK L
nullable
ââM U
:
ââU V
false
ââW \
)
ââ\ ]
,
ââ] ^
	CreatedAt
ää 
=
ää 
table
ää  %
.
ää% &
Column
ää& ,
<
ää, -
DateTime
ää- 5
>
ää5 6
(
ää6 7
type
ää7 ;
:
ää; <
$str
ää= W
,
ääW X
nullable
ääY a
:
ääa b
false
ääc h
)
ääh i
,
ääi j
	CreatedBy
ãã 
=
ãã 
table
ãã  %
.
ãã% &
Column
ãã& ,
<
ãã, -
string
ãã- 3
>
ãã3 4
(
ãã4 5
type
ãã5 9
:
ãã9 :
$str
ãã; A
,
ããA B
nullable
ããC K
:
ããK L
true
ããM Q
)
ããQ R
,
ããR S
	UpdatedAt
åå 
=
åå 
table
åå  %
.
åå% &
Column
åå& ,
<
åå, -
DateTime
åå- 5
>
åå5 6
(
åå6 7
type
åå7 ;
:
åå; <
$str
åå= W
,
ååW X
nullable
ååY a
:
ååa b
true
ååc g
)
ååg h
,
ååh i
	UpdatedBy
çç 
=
çç 
table
çç  %
.
çç% &
Column
çç& ,
<
çç, -
string
çç- 3
>
çç3 4
(
çç4 5
type
çç5 9
:
çç9 :
$str
çç; A
,
ççA B
nullable
ççC K
:
ççK L
true
ççM Q
)
ççQ R
,
ççR S
IsActive
éé 
=
éé 
table
éé $
.
éé$ %
Column
éé% +
<
éé+ ,
bool
éé, 0
>
éé0 1
(
éé1 2
type
éé2 6
:
éé6 7
$str
éé8 A
,
ééA B
nullable
ééC K
:
ééK L
false
ééM R
)
ééR S
,
ééS T
	IsDeleted
èè 
=
èè 
table
èè  %
.
èè% &
Column
èè& ,
<
èè, -
bool
èè- 1
>
èè1 2
(
èè2 3
type
èè3 7
:
èè7 8
$str
èè9 B
,
èèB C
nullable
èèD L
:
èèL M
false
èèN S
)
èèS T
,
èèT U
	DeletedAt
êê 
=
êê 
table
êê  %
.
êê% &
Column
êê& ,
<
êê, -
DateTime
êê- 5
>
êê5 6
(
êê6 7
type
êê7 ;
:
êê; <
$str
êê= W
,
êêW X
nullable
êêY a
:
êêa b
true
êêc g
)
êêg h
}
ëë 
,
ëë 
constraints
íí 
:
íí 
table
íí "
=>
íí# %
{
ìì 
table
îî 
.
îî 

PrimaryKey
îî $
(
îî$ %
$str
îî% 4
,
îî4 5
x
îî6 7
=>
îî8 :
x
îî; <
.
îî< =
Id
îî= ?
)
îî? @
;
îî@ A
table
ïï 
.
ïï 

ForeignKey
ïï $
(
ïï$ %
name
ññ 
:
ññ 
$str
ññ >
,
ññ> ?
column
óó 
:
óó 
x
óó  !
=>
óó" $
x
óó% &
.
óó& '
TicketId
óó' /
,
óó/ 0
principalTable
òò &
:
òò& '
$str
òò( 1
,
òò1 2
principalColumn
ôô '
:
ôô' (
$str
ôô) -
,
ôô- .
onDelete
öö  
:
öö  !
ReferentialAction
öö" 3
.
öö3 4
Cascade
öö4 ;
)
öö; <
;
öö< =
}
õõ 
)
õõ 
;
õõ 
migrationBuilder
ùù 
.
ùù 
CreateTable
ùù (
(
ùù( )
name
ûû 
:
ûû 
$str
ûû &
,
ûû& '
columns
üü 
:
üü 
table
üü 
=>
üü !
new
üü" %
{
†† 
Id
°° 
=
°° 
table
°° 
.
°° 
Column
°° %
<
°°% &
int
°°& )
>
°°) *
(
°°* +
type
°°+ /
:
°°/ 0
$str
°°1 :
,
°°: ;
nullable
°°< D
:
°°D E
false
°°F K
)
°°K L
.
¢¢ 

Annotation
¢¢ #
(
¢¢# $
$str
¢¢$ D
,
¢¢D E+
NpgsqlValueGenerationStrategy
¢¢F c
.
¢¢c d%
IdentityByDefaultColumn
¢¢d {
)
¢¢{ |
,
¢¢| }
TicketId
££ 
=
££ 
table
££ $
.
££$ %
Column
££% +
<
££+ ,
int
££, /
>
££/ 0
(
££0 1
type
££1 5
:
££5 6
$str
££7 @
,
££@ A
nullable
££B J
:
££J K
false
££L Q
)
££Q R
,
££R S
UserId
§§ 
=
§§ 
table
§§ "
.
§§" #
Column
§§# )
<
§§) *
int
§§* -
>
§§- .
(
§§. /
type
§§/ 3
:
§§3 4
$str
§§5 >
,
§§> ?
nullable
§§@ H
:
§§H I
false
§§J O
)
§§O P
,
§§P Q
	CreatedAt
•• 
=
•• 
table
••  %
.
••% &
Column
••& ,
<
••, -
DateTime
••- 5
>
••5 6
(
••6 7
type
••7 ;
:
••; <
$str
••= W
,
••W X
nullable
••Y a
:
••a b
false
••c h
)
••h i
,
••i j
	CreatedBy
¶¶ 
=
¶¶ 
table
¶¶  %
.
¶¶% &
Column
¶¶& ,
<
¶¶, -
string
¶¶- 3
>
¶¶3 4
(
¶¶4 5
type
¶¶5 9
:
¶¶9 :
$str
¶¶; A
,
¶¶A B
nullable
¶¶C K
:
¶¶K L
true
¶¶M Q
)
¶¶Q R
,
¶¶R S
	UpdatedAt
ßß 
=
ßß 
table
ßß  %
.
ßß% &
Column
ßß& ,
<
ßß, -
DateTime
ßß- 5
>
ßß5 6
(
ßß6 7
type
ßß7 ;
:
ßß; <
$str
ßß= W
,
ßßW X
nullable
ßßY a
:
ßßa b
true
ßßc g
)
ßßg h
,
ßßh i
	UpdatedBy
®® 
=
®® 
table
®®  %
.
®®% &
Column
®®& ,
<
®®, -
string
®®- 3
>
®®3 4
(
®®4 5
type
®®5 9
:
®®9 :
$str
®®; A
,
®®A B
nullable
®®C K
:
®®K L
true
®®M Q
)
®®Q R
,
®®R S
IsActive
©© 
=
©© 
table
©© $
.
©©$ %
Column
©©% +
<
©©+ ,
bool
©©, 0
>
©©0 1
(
©©1 2
type
©©2 6
:
©©6 7
$str
©©8 A
,
©©A B
nullable
©©C K
:
©©K L
false
©©M R
)
©©R S
,
©©S T
	IsDeleted
™™ 
=
™™ 
table
™™  %
.
™™% &
Column
™™& ,
<
™™, -
bool
™™- 1
>
™™1 2
(
™™2 3
type
™™3 7
:
™™7 8
$str
™™9 B
,
™™B C
nullable
™™D L
:
™™L M
false
™™N S
)
™™S T
,
™™T U
	DeletedAt
´´ 
=
´´ 
table
´´  %
.
´´% &
Column
´´& ,
<
´´, -
DateTime
´´- 5
>
´´5 6
(
´´6 7
type
´´7 ;
:
´´; <
$str
´´= W
,
´´W X
nullable
´´Y a
:
´´a b
true
´´c g
)
´´g h
}
¨¨ 
,
¨¨ 
constraints
≠≠ 
:
≠≠ 
table
≠≠ "
=>
≠≠# %
{
ÆÆ 
table
ØØ 
.
ØØ 

PrimaryKey
ØØ $
(
ØØ$ %
$str
ØØ% 8
,
ØØ8 9
x
ØØ: ;
=>
ØØ< >
x
ØØ? @
.
ØØ@ A
Id
ØØA C
)
ØØC D
;
ØØD E
table
∞∞ 
.
∞∞ 

ForeignKey
∞∞ $
(
∞∞$ %
name
±± 
:
±± 
$str
±± B
,
±±B C
column
≤≤ 
:
≤≤ 
x
≤≤  !
=>
≤≤" $
x
≤≤% &
.
≤≤& '
TicketId
≤≤' /
,
≤≤/ 0
principalTable
≥≥ &
:
≥≥& '
$str
≥≥( 1
,
≥≥1 2
principalColumn
¥¥ '
:
¥¥' (
$str
¥¥) -
,
¥¥- .
onDelete
µµ  
:
µµ  !
ReferentialAction
µµ" 3
.
µµ3 4
Cascade
µµ4 ;
)
µµ; <
;
µµ< =
table
∂∂ 
.
∂∂ 

ForeignKey
∂∂ $
(
∂∂$ %
name
∑∑ 
:
∑∑ 
$str
∑∑ >
,
∑∑> ?
column
∏∏ 
:
∏∏ 
x
∏∏  !
=>
∏∏" $
x
∏∏% &
.
∏∏& '
UserId
∏∏' -
,
∏∏- .
principalTable
ππ &
:
ππ& '
$str
ππ( /
,
ππ/ 0
principalColumn
∫∫ '
:
∫∫' (
$str
∫∫) -
,
∫∫- .
onDelete
ªª  
:
ªª  !
ReferentialAction
ªª" 3
.
ªª3 4
Cascade
ªª4 ;
)
ªª; <
;
ªª< =
}
ºº 
)
ºº 
;
ºº 
migrationBuilder
ææ 
.
ææ 
CreateIndex
ææ (
(
ææ( )
name
øø 
:
øø 
$str
øø 5
,
øø5 6
table
¿¿ 
:
¿¿ 
$str
¿¿ )
,
¿¿) *
column
¡¡ 
:
¡¡ 
$str
¡¡ #
)
¡¡# $
;
¡¡$ %
migrationBuilder
√√ 
.
√√ 
CreateIndex
√√ (
(
√√( )
name
ƒƒ 
:
ƒƒ 
$str
ƒƒ 5
,
ƒƒ5 6
table
≈≈ 
:
≈≈ 
$str
≈≈ *
,
≈≈* +
column
∆∆ 
:
∆∆ 
$str
∆∆ "
)
∆∆" #
;
∆∆# $
migrationBuilder
»» 
.
»» 
CreateIndex
»» (
(
»»( )
name
…… 
:
…… 
$str
…… =
,
……= >
table
   
:
   
$str
   *
,
  * +
column
ÀÀ 
:
ÀÀ 
$str
ÀÀ *
)
ÀÀ* +
;
ÀÀ+ ,
migrationBuilder
ÕÕ 
.
ÕÕ 
CreateIndex
ÕÕ (
(
ÕÕ( )
name
ŒŒ 
:
ŒŒ 
$str
ŒŒ 6
,
ŒŒ6 7
table
œœ 
:
œœ 
$str
œœ '
,
œœ' (
column
–– 
:
–– 
$str
–– &
)
––& '
;
––' (
migrationBuilder
““ 
.
““ 
CreateIndex
““ (
(
““( )
name
”” 
:
”” 
$str
”” 2
,
””2 3
table
‘‘ 
:
‘‘ 
$str
‘‘ '
,
‘‘' (
column
’’ 
:
’’ 
$str
’’ "
)
’’" #
;
’’# $
migrationBuilder
◊◊ 
.
◊◊ 
CreateIndex
◊◊ (
(
◊◊( )
name
ÿÿ 
:
ÿÿ 
$str
ÿÿ .
,
ÿÿ. /
table
ŸŸ 
:
ŸŸ 
$str
ŸŸ #
,
ŸŸ# $
column
⁄⁄ 
:
⁄⁄ 
$str
⁄⁄ "
)
⁄⁄" #
;
⁄⁄# $
migrationBuilder
‹‹ 
.
‹‹ 
CreateIndex
‹‹ (
(
‹‹( )
name
›› 
:
›› 
$str
›› 2
,
››2 3
table
ﬁﬁ 
:
ﬁﬁ 
$str
ﬁﬁ '
,
ﬁﬁ' (
column
ﬂﬂ 
:
ﬂﬂ 
$str
ﬂﬂ "
)
ﬂﬂ" #
;
ﬂﬂ# $
migrationBuilder
·· 
.
·· 
CreateIndex
·· (
(
··( )
name
‚‚ 
:
‚‚ 
$str
‚‚ 0
,
‚‚0 1
table
„„ 
:
„„ 
$str
„„ '
,
„„' (
column
‰‰ 
:
‰‰ 
$str
‰‰  
)
‰‰  !
;
‰‰! "
}
ÂÂ 	
	protected
ËË 
override
ËË 
void
ËË 
Down
ËË  $
(
ËË$ %
MigrationBuilder
ËË% 5
migrationBuilder
ËË6 F
)
ËËF G
{
ÈÈ 	
migrationBuilder
ÍÍ 
.
ÍÍ 
	DropTable
ÍÍ &
(
ÍÍ& '
name
ÎÎ 
:
ÎÎ 
$str
ÎÎ (
)
ÎÎ( )
;
ÎÎ) *
migrationBuilder
ÌÌ 
.
ÌÌ 
	DropTable
ÌÌ &
(
ÌÌ& '
name
ÓÓ 
:
ÓÓ 
$str
ÓÓ )
)
ÓÓ) *
;
ÓÓ* +
migrationBuilder
 
.
 
	DropTable
 &
(
& '
name
ÒÒ 
:
ÒÒ 
$str
ÒÒ &
)
ÒÒ& '
;
ÒÒ' (
migrationBuilder
ÛÛ 
.
ÛÛ 
	DropTable
ÛÛ &
(
ÛÛ& '
name
ÙÙ 
:
ÙÙ 
$str
ÙÙ "
)
ÙÙ" #
;
ÙÙ# $
migrationBuilder
ˆˆ 
.
ˆˆ 
	DropTable
ˆˆ &
(
ˆˆ& '
name
˜˜ 
:
˜˜ 
$str
˜˜ &
)
˜˜& '
;
˜˜' (
migrationBuilder
˘˘ 
.
˘˘ 

DropColumn
˘˘ '
(
˘˘' (
name
˙˙ 
:
˙˙ 
$str
˙˙ !
,
˙˙! "
table
˚˚ 
:
˚˚ 
$str
˚˚ !
)
˚˚! "
;
˚˚" #
}
¸¸ 	
}
˝˝ 
}˛˛ µ
r/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260814143005_AddTicketSlas.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public 

partial 
class 
AddTicketSlas &
:' (
	Migration) 2
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
} 	
} 
} àÑ
r/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Migrations/20260811202256_InitialCreate.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !

Migrations! +
{ 
public

 

partial

 
class

 
InitialCreate

 &
:

' (
	Migration

) 2
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str %
,% &
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
	DayOfWeek 
= 
table  %
.% &
Column& ,
<, -
int- 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
	StartTime 
= 
table  %
.% &
Column& ,
<, -
TimeSpan- 5
>5 6
(6 7
type7 ;
:; <
$str= G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
EndTime 
= 
table #
.# $
Column$ *
<* +
TimeSpan+ 3
>3 4
(4 5
type5 9
:9 :
$str; E
,E F
nullableG O
:O P
falseQ V
)V W
,W X
IsWorkingDay  
=! "
table# (
.( )
Column) /
</ 0
bool0 4
>4 5
(5 6
type6 :
:: ;
$str< E
,E F
nullableG O
:O P
falseQ V
)V W
,W X
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
falsec h
)h i
,i j
	CreatedBy 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
	UpdatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
truec g
)g h
,h i
	UpdatedBy 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; A
,A B
nullableC K
:K L
trueM Q
)Q R
,R S
IsActive 
= 
table $
.$ %
Column% +
<+ ,
bool, 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
	IsDeleted 
= 
table  %
.% &
Column& ,
<, -
bool- 1
>1 2
(2 3
type3 7
:7 8
$str9 B
,B C
nullableD L
:L M
falseN S
)S T
,T U
	DeletedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= W
,W X
nullableY a
:a b
truec g
)g h
}   
,   
constraints!! 
:!! 
table!! "
=>!!# %
{"" 
table## 
.## 

PrimaryKey## $
(##$ %
$str##% 7
,##7 8
x##9 :
=>##; =
x##> ?
.##? @
Id##@ B
)##B C
;##C D
}$$ 
)$$ 
;$$ 
migrationBuilder&& 
.&& 
CreateTable&& (
(&&( )
name'' 
:'' 
$str'' "
,''" #
columns(( 
:(( 
table(( 
=>(( !
new((" %
{)) 
Id** 
=** 
table** 
.** 
Column** %
<**% &
int**& )
>**) *
(*** +
type**+ /
:**/ 0
$str**1 :
,**: ;
nullable**< D
:**D E
false**F K
)**K L
.++ 

Annotation++ #
(++# $
$str++$ D
,++D E)
NpgsqlValueGenerationStrategy++F c
.++c d#
IdentityByDefaultColumn++d {
)++{ |
,++| }
Name,, 
=,, 
table,,  
.,,  !
Column,,! '
<,,' (
string,,( .
>,,. /
(,,/ 0
type,,0 4
:,,4 5
$str,,6 <
,,,< =
nullable,,> F
:,,F G
false,,H M
),,M N
,,,N O
	ProjectId-- 
=-- 
table--  %
.--% &
Column--& ,
<--, -
int--- 0
>--0 1
(--1 2
type--2 6
:--6 7
$str--8 A
,--A B
nullable--C K
:--K L
false--M R
)--R S
,--S T
ParentCategoryId.. $
=..% &
table..' ,
..., -
Column..- 3
<..3 4
int..4 7
>..7 8
(..8 9
type..9 =
:..= >
$str..? H
,..H I
nullable..J R
:..R S
true..T X
)..X Y
,..Y Z
Description// 
=//  !
table//" '
.//' (
Column//( .
<//. /
string/// 5
>//5 6
(//6 7
type//7 ;
://; <
$str//= C
,//C D
nullable//E M
://M N
true//O S
)//S T
,//T U"
DefaultAssigneeGroupId00 *
=00+ ,
table00- 2
.002 3
Column003 9
<009 :
int00: =
>00= >
(00> ?
type00? C
:00C D
$str00E N
,00N O
nullable00P X
:00X Y
true00Z ^
)00^ _
,00_ `
	CreatedAt11 
=11 
table11  %
.11% &
Column11& ,
<11, -
DateTime11- 5
>115 6
(116 7
type117 ;
:11; <
$str11= W
,11W X
nullable11Y a
:11a b
false11c h
)11h i
,11i j
	CreatedBy22 
=22 
table22  %
.22% &
Column22& ,
<22, -
string22- 3
>223 4
(224 5
type225 9
:229 :
$str22; A
,22A B
nullable22C K
:22K L
true22M Q
)22Q R
,22R S
	UpdatedAt33 
=33 
table33  %
.33% &
Column33& ,
<33, -
DateTime33- 5
>335 6
(336 7
type337 ;
:33; <
$str33= W
,33W X
nullable33Y a
:33a b
true33c g
)33g h
,33h i
	UpdatedBy44 
=44 
table44  %
.44% &
Column44& ,
<44, -
string44- 3
>443 4
(444 5
type445 9
:449 :
$str44; A
,44A B
nullable44C K
:44K L
true44M Q
)44Q R
,44R S
IsActive55 
=55 
table55 $
.55$ %
Column55% +
<55+ ,
bool55, 0
>550 1
(551 2
type552 6
:556 7
$str558 A
,55A B
nullable55C K
:55K L
false55M R
)55R S
,55S T
	IsDeleted66 
=66 
table66  %
.66% &
Column66& ,
<66, -
bool66- 1
>661 2
(662 3
type663 7
:667 8
$str669 B
,66B C
nullable66D L
:66L M
false66N S
)66S T
,66T U
	DeletedAt77 
=77 
table77  %
.77% &
Column77& ,
<77, -
DateTime77- 5
>775 6
(776 7
type777 ;
:77; <
$str77= W
,77W X
nullable77Y a
:77a b
true77c g
)77g h
}88 
,88 
constraints99 
:99 
table99 "
=>99# %
{:: 
table;; 
.;; 

PrimaryKey;; $
(;;$ %
$str;;% 4
,;;4 5
x;;6 7
=>;;8 :
x;;; <
.;;< =
Id;;= ?
);;? @
;;;@ A
}<< 
)<< 
;<< 
migrationBuilder>> 
.>> 
CreateTable>> (
(>>( )
name?? 
:?? 
$str?? #
,??# $
columns@@ 
:@@ 
table@@ 
=>@@ !
new@@" %
{AA 
IdBB 
=BB 
tableBB 
.BB 
ColumnBB %
<BB% &
intBB& )
>BB) *
(BB* +
typeBB+ /
:BB/ 0
$strBB1 :
,BB: ;
nullableBB< D
:BBD E
falseBBF K
)BBK L
.CC 

AnnotationCC #
(CC# $
$strCC$ D
,CCD E)
NpgsqlValueGenerationStrategyCCF c
.CCc d#
IdentityByDefaultColumnCCd {
)CC{ |
,CC| }
NameDD 
=DD 
tableDD  
.DD  !
ColumnDD! '
<DD' (
stringDD( .
>DD. /
(DD/ 0
typeDD0 4
:DD4 5
$strDD6 <
,DD< =
nullableDD> F
:DDF G
falseDDH M
)DDM N
,DDN O
DescriptionEE 
=EE  !
tableEE" '
.EE' (
ColumnEE( .
<EE. /
stringEE/ 5
>EE5 6
(EE6 7
typeEE7 ;
:EE; <
$strEE= C
,EEC D
nullableEEE M
:EEM N
trueEEO S
)EES T
,EET U
	CreatedAtFF 
=FF 
tableFF  %
.FF% &
ColumnFF& ,
<FF, -
DateTimeFF- 5
>FF5 6
(FF6 7
typeFF7 ;
:FF; <
$strFF= W
,FFW X
nullableFFY a
:FFa b
falseFFc h
)FFh i
,FFi j
	CreatedByGG 
=GG 
tableGG  %
.GG% &
ColumnGG& ,
<GG, -
stringGG- 3
>GG3 4
(GG4 5
typeGG5 9
:GG9 :
$strGG; A
,GGA B
nullableGGC K
:GGK L
trueGGM Q
)GGQ R
,GGR S
	UpdatedAtHH 
=HH 
tableHH  %
.HH% &
ColumnHH& ,
<HH, -
DateTimeHH- 5
>HH5 6
(HH6 7
typeHH7 ;
:HH; <
$strHH= W
,HHW X
nullableHHY a
:HHa b
trueHHc g
)HHg h
,HHh i
	UpdatedByII 
=II 
tableII  %
.II% &
ColumnII& ,
<II, -
stringII- 3
>II3 4
(II4 5
typeII5 9
:II9 :
$strII; A
,IIA B
nullableIIC K
:IIK L
trueIIM Q
)IIQ R
,IIR S
IsActiveJJ 
=JJ 
tableJJ $
.JJ$ %
ColumnJJ% +
<JJ+ ,
boolJJ, 0
>JJ0 1
(JJ1 2
typeJJ2 6
:JJ6 7
$strJJ8 A
,JJA B
nullableJJC K
:JJK L
falseJJM R
)JJR S
,JJS T
	IsDeletedKK 
=KK 
tableKK  %
.KK% &
ColumnKK& ,
<KK, -
boolKK- 1
>KK1 2
(KK2 3
typeKK3 7
:KK7 8
$strKK9 B
,KKB C
nullableKKD L
:KKL M
falseKKN S
)KKS T
,KKT U
	DeletedAtLL 
=LL 
tableLL  %
.LL% &
ColumnLL& ,
<LL, -
DateTimeLL- 5
>LL5 6
(LL6 7
typeLL7 ;
:LL; <
$strLL= W
,LLW X
nullableLLY a
:LLa b
trueLLc g
)LLg h
}MM 
,MM 
constraintsNN 
:NN 
tableNN "
=>NN# %
{OO 
tablePP 
.PP 

PrimaryKeyPP $
(PP$ %
$strPP% 5
,PP5 6
xPP7 8
=>PP9 ;
xPP< =
.PP= >
IdPP> @
)PP@ A
;PPA B
}QQ 
)QQ 
;QQ 
migrationBuilderSS 
.SS 
CreateTableSS (
(SS( )
nameTT 
:TT 
$strTT (
,TT( )
columnsUU 
:UU 
tableUU 
=>UU !
newUU" %
{VV 
IdWW 
=WW 
tableWW 
.WW 
ColumnWW %
<WW% &
intWW& )
>WW) *
(WW* +
typeWW+ /
:WW/ 0
$strWW1 :
,WW: ;
nullableWW< D
:WWD E
falseWWF K
)WWK L
.XX 

AnnotationXX #
(XX# $
$strXX$ D
,XXD E)
NpgsqlValueGenerationStrategyXXF c
.XXc d#
IdentityByDefaultColumnXXd {
)XX{ |
,XX| }
KeyYY 
=YY 
tableYY 
.YY  
ColumnYY  &
<YY& '
stringYY' -
>YY- .
(YY. /
typeYY/ 3
:YY3 4
$strYY5 ;
,YY; <
nullableYY= E
:YYE F
falseYYG L
)YYL M
,YYM N
LabelZZ 
=ZZ 
tableZZ !
.ZZ! "
ColumnZZ" (
<ZZ( )
stringZZ) /
>ZZ/ 0
(ZZ0 1
typeZZ1 5
:ZZ5 6
$strZZ7 =
,ZZ= >
nullableZZ? G
:ZZG H
falseZZI N
)ZZN O
,ZZO P
	FieldType[[ 
=[[ 
table[[  %
.[[% &
Column[[& ,
<[[, -
int[[- 0
>[[0 1
([[1 2
type[[2 6
:[[6 7
$str[[8 A
,[[A B
nullable[[C K
:[[K L
false[[M R
)[[R S
,[[S T
ValidationRegex\\ #
=\\$ %
table\\& +
.\\+ ,
Column\\, 2
<\\2 3
string\\3 9
>\\9 :
(\\: ;
type\\; ?
:\\? @
$str\\A G
,\\G H
nullable\\I Q
:\\Q R
true\\S W
)\\W X
,\\X Y
	CreatedAt]] 
=]] 
table]]  %
.]]% &
Column]]& ,
<]], -
DateTime]]- 5
>]]5 6
(]]6 7
type]]7 ;
:]]; <
$str]]= W
,]]W X
nullable]]Y a
:]]a b
false]]c h
)]]h i
,]]i j
	CreatedBy^^ 
=^^ 
table^^  %
.^^% &
Column^^& ,
<^^, -
string^^- 3
>^^3 4
(^^4 5
type^^5 9
:^^9 :
$str^^; A
,^^A B
nullable^^C K
:^^K L
true^^M Q
)^^Q R
,^^R S
	UpdatedAt__ 
=__ 
table__  %
.__% &
Column__& ,
<__, -
DateTime__- 5
>__5 6
(__6 7
type__7 ;
:__; <
$str__= W
,__W X
nullable__Y a
:__a b
true__c g
)__g h
,__h i
	UpdatedBy`` 
=`` 
table``  %
.``% &
Column``& ,
<``, -
string``- 3
>``3 4
(``4 5
type``5 9
:``9 :
$str``; A
,``A B
nullable``C K
:``K L
true``M Q
)``Q R
,``R S
IsActiveaa 
=aa 
tableaa $
.aa$ %
Columnaa% +
<aa+ ,
boolaa, 0
>aa0 1
(aa1 2
typeaa2 6
:aa6 7
$straa8 A
,aaA B
nullableaaC K
:aaK L
falseaaM R
)aaR S
,aaS T
	IsDeletedbb 
=bb 
tablebb  %
.bb% &
Columnbb& ,
<bb, -
boolbb- 1
>bb1 2
(bb2 3
typebb3 7
:bb7 8
$strbb9 B
,bbB C
nullablebbD L
:bbL M
falsebbN S
)bbS T
,bbT U
	DeletedAtcc 
=cc 
tablecc  %
.cc% &
Columncc& ,
<cc, -
DateTimecc- 5
>cc5 6
(cc6 7
typecc7 ;
:cc; <
$strcc= W
,ccW X
nullableccY a
:cca b
trueccc g
)ccg h
}dd 
,dd 
constraintsee 
:ee 
tableee "
=>ee# %
{ff 
tablegg 
.gg 

PrimaryKeygg $
(gg$ %
$strgg% :
,gg: ;
xgg< =
=>gg> @
xggA B
.ggB C
IdggC E
)ggE F
;ggF G
}hh 
)hh 
;hh 
migrationBuilderjj 
.jj 
CreateTablejj (
(jj( )
namekk 
:kk 
$strkk  
,kk  !
columnsll 
:ll 
tablell 
=>ll !
newll" %
{mm 
Idnn 
=nn 
tablenn 
.nn 
Columnnn %
<nn% &
intnn& )
>nn) *
(nn* +
typenn+ /
:nn/ 0
$strnn1 :
,nn: ;
nullablenn< D
:nnD E
falsennF K
)nnK L
.oo 

Annotationoo #
(oo# $
$stroo$ D
,ooD E)
NpgsqlValueGenerationStrategyooF c
.ooc d#
IdentityByDefaultColumnood {
)oo{ |
,oo| }
Datepp 
=pp 
tablepp  
.pp  !
Columnpp! '
<pp' (
DateTimepp( 0
>pp0 1
(pp1 2
typepp2 6
:pp6 7
$strpp8 R
,ppR S
nullableppT \
:pp\ ]
falsepp^ c
)ppc d
,ppd e
Nameqq 
=qq 
tableqq  
.qq  !
Columnqq! '
<qq' (
stringqq( .
>qq. /
(qq/ 0
typeqq0 4
:qq4 5
$strqq6 <
,qq< =
nullableqq> F
:qqF G
falseqqH M
)qqM N
,qqN O
IsRecurringrr 
=rr  !
tablerr" '
.rr' (
Columnrr( .
<rr. /
boolrr/ 3
>rr3 4
(rr4 5
typerr5 9
:rr9 :
$strrr; D
,rrD E
nullablerrF N
:rrN O
falserrP U
)rrU V
,rrV W
	CreatedAtss 
=ss 
tabless  %
.ss% &
Columnss& ,
<ss, -
DateTimess- 5
>ss5 6
(ss6 7
typess7 ;
:ss; <
$strss= W
,ssW X
nullablessY a
:ssa b
falsessc h
)ssh i
,ssi j
	CreatedBytt 
=tt 
tablett  %
.tt% &
Columntt& ,
<tt, -
stringtt- 3
>tt3 4
(tt4 5
typett5 9
:tt9 :
$strtt; A
,ttA B
nullablettC K
:ttK L
truettM Q
)ttQ R
,ttR S
	UpdatedAtuu 
=uu 
tableuu  %
.uu% &
Columnuu& ,
<uu, -
DateTimeuu- 5
>uu5 6
(uu6 7
typeuu7 ;
:uu; <
$struu= W
,uuW X
nullableuuY a
:uua b
trueuuc g
)uug h
,uuh i
	UpdatedByvv 
=vv 
tablevv  %
.vv% &
Columnvv& ,
<vv, -
stringvv- 3
>vv3 4
(vv4 5
typevv5 9
:vv9 :
$strvv; A
,vvA B
nullablevvC K
:vvK L
truevvM Q
)vvQ R
,vvR S
IsActiveww 
=ww 
tableww $
.ww$ %
Columnww% +
<ww+ ,
boolww, 0
>ww0 1
(ww1 2
typeww2 6
:ww6 7
$strww8 A
,wwA B
nullablewwC K
:wwK L
falsewwM R
)wwR S
,wwS T
	IsDeletedxx 
=xx 
tablexx  %
.xx% &
Columnxx& ,
<xx, -
boolxx- 1
>xx1 2
(xx2 3
typexx3 7
:xx7 8
$strxx9 B
,xxB C
nullablexxD L
:xxL M
falsexxN S
)xxS T
,xxT U
	DeletedAtyy 
=yy 
tableyy  %
.yy% &
Columnyy& ,
<yy, -
DateTimeyy- 5
>yy5 6
(yy6 7
typeyy7 ;
:yy; <
$stryy= W
,yyW X
nullableyyY a
:yya b
trueyyc g
)yyg h
}zz 
,zz 
constraints{{ 
:{{ 
table{{ "
=>{{# %
{|| 
table}} 
.}} 

PrimaryKey}} $
(}}$ %
$str}}% 2
,}}2 3
x}}4 5
=>}}6 8
x}}9 :
.}}: ;
Id}}; =
)}}= >
;}}> ?
}~~ 
)~~ 
;~~ 
migrationBuilder
ÄÄ 
.
ÄÄ 
CreateTable
ÄÄ (
(
ÄÄ( )
name
ÅÅ 
:
ÅÅ 
$str
ÅÅ +
,
ÅÅ+ ,
columns
ÇÇ 
:
ÇÇ 
table
ÇÇ 
=>
ÇÇ !
new
ÇÇ" %
{
ÉÉ 
Id
ÑÑ 
=
ÑÑ 
table
ÑÑ 
.
ÑÑ 
Column
ÑÑ %
<
ÑÑ% &
int
ÑÑ& )
>
ÑÑ) *
(
ÑÑ* +
type
ÑÑ+ /
:
ÑÑ/ 0
$str
ÑÑ1 :
,
ÑÑ: ;
nullable
ÑÑ< D
:
ÑÑD E
false
ÑÑF K
)
ÑÑK L
.
ÖÖ 

Annotation
ÖÖ #
(
ÖÖ# $
$str
ÖÖ$ D
,
ÖÖD E+
NpgsqlValueGenerationStrategy
ÖÖF c
.
ÖÖc d%
IdentityByDefaultColumn
ÖÖd {
)
ÖÖ{ |
,
ÖÖ| }
Name
ÜÜ 
=
ÜÜ 
table
ÜÜ  
.
ÜÜ  !
Column
ÜÜ! '
<
ÜÜ' (
string
ÜÜ( .
>
ÜÜ. /
(
ÜÜ/ 0
type
ÜÜ0 4
:
ÜÜ4 5
$str
ÜÜ6 <
,
ÜÜ< =
nullable
ÜÜ> F
:
ÜÜF G
false
ÜÜH M
)
ÜÜM N
,
ÜÜN O
ParentId
áá 
=
áá 
table
áá $
.
áá$ %
Column
áá% +
<
áá+ ,
int
áá, /
>
áá/ 0
(
áá0 1
type
áá1 5
:
áá5 6
$str
áá7 @
,
áá@ A
nullable
ááB J
:
ááJ K
true
ááL P
)
ááP Q
,
ááQ R
	CreatedAt
àà 
=
àà 
table
àà  %
.
àà% &
Column
àà& ,
<
àà, -
DateTime
àà- 5
>
àà5 6
(
àà6 7
type
àà7 ;
:
àà; <
$str
àà= W
,
ààW X
nullable
ààY a
:
ààa b
false
ààc h
)
ààh i
,
àài j
	CreatedBy
ââ 
=
ââ 
table
ââ  %
.
ââ% &
Column
ââ& ,
<
ââ, -
string
ââ- 3
>
ââ3 4
(
ââ4 5
type
ââ5 9
:
ââ9 :
$str
ââ; A
,
ââA B
nullable
ââC K
:
ââK L
true
ââM Q
)
ââQ R
,
ââR S
	UpdatedAt
ää 
=
ää 
table
ää  %
.
ää% &
Column
ää& ,
<
ää, -
DateTime
ää- 5
>
ää5 6
(
ää6 7
type
ää7 ;
:
ää; <
$str
ää= W
,
ääW X
nullable
ääY a
:
ääa b
true
ääc g
)
ääg h
,
ääh i
	UpdatedBy
ãã 
=
ãã 
table
ãã  %
.
ãã% &
Column
ãã& ,
<
ãã, -
string
ãã- 3
>
ãã3 4
(
ãã4 5
type
ãã5 9
:
ãã9 :
$str
ãã; A
,
ããA B
nullable
ããC K
:
ããK L
true
ããM Q
)
ããQ R
,
ããR S
IsActive
åå 
=
åå 
table
åå $
.
åå$ %
Column
åå% +
<
åå+ ,
bool
åå, 0
>
åå0 1
(
åå1 2
type
åå2 6
:
åå6 7
$str
åå8 A
,
ååA B
nullable
ååC K
:
ååK L
false
ååM R
)
ååR S
,
ååS T
	IsDeleted
çç 
=
çç 
table
çç  %
.
çç% &
Column
çç& ,
<
çç, -
bool
çç- 1
>
çç1 2
(
çç2 3
type
çç3 7
:
çç7 8
$str
çç9 B
,
ççB C
nullable
ççD L
:
ççL M
false
ççN S
)
ççS T
,
ççT U
	DeletedAt
éé 
=
éé 
table
éé  %
.
éé% &
Column
éé& ,
<
éé, -
DateTime
éé- 5
>
éé5 6
(
éé6 7
type
éé7 ;
:
éé; <
$str
éé= W
,
ééW X
nullable
ééY a
:
ééa b
true
ééc g
)
éég h
}
èè 
,
èè 
constraints
êê 
:
êê 
table
êê "
=>
êê# %
{
ëë 
table
íí 
.
íí 

PrimaryKey
íí $
(
íí$ %
$str
íí% =
,
íí= >
x
íí? @
=>
ííA C
x
ííD E
.
ííE F
Id
ííF H
)
ííH I
;
ííI J
table
ìì 
.
ìì 

ForeignKey
ìì $
(
ìì$ %
name
îî 
:
îî 
$str
îî S
,
îîS T
column
ïï 
:
ïï 
x
ïï  !
=>
ïï" $
x
ïï% &
.
ïï& '
ParentId
ïï' /
,
ïï/ 0
principalTable
ññ &
:
ññ& '
$str
ññ( =
,
ññ= >
principalColumn
óó '
:
óó' (
$str
óó) -
)
óó- .
;
óó. /
}
òò 
)
òò 
;
òò 
migrationBuilder
öö 
.
öö 
CreateTable
öö (
(
öö( )
name
õõ 
:
õõ 
$str
õõ )
,
õõ) *
columns
úú 
:
úú 
table
úú 
=>
úú !
new
úú" %
{
ùù 
Id
ûû 
=
ûû 
table
ûû 
.
ûû 
Column
ûû %
<
ûû% &
int
ûû& )
>
ûû) *
(
ûû* +
type
ûû+ /
:
ûû/ 0
$str
ûû1 :
,
ûû: ;
nullable
ûû< D
:
ûûD E
false
ûûF K
)
ûûK L
.
üü 

Annotation
üü #
(
üü# $
$str
üü$ D
,
üüD E+
NpgsqlValueGenerationStrategy
üüF c
.
üüc d%
IdentityByDefaultColumn
üüd {
)
üü{ |
,
üü| }
EventKey
†† 
=
†† 
table
†† $
.
††$ %
Column
††% +
<
††+ ,
string
††, 2
>
††2 3
(
††3 4
type
††4 8
:
††8 9
$str
††: @
,
††@ A
nullable
††B J
:
††J K
false
††L Q
)
††Q R
,
††R S

TargetRole
°° 
=
°°  
table
°°! &
.
°°& '
Column
°°' -
<
°°- .
string
°°. 4
>
°°4 5
(
°°5 6
type
°°6 :
:
°°: ;
$str
°°< B
,
°°B C
nullable
°°D L
:
°°L M
false
°°N S
)
°°S T
,
°°T U
	CreatedAt
¢¢ 
=
¢¢ 
table
¢¢  %
.
¢¢% &
Column
¢¢& ,
<
¢¢, -
DateTime
¢¢- 5
>
¢¢5 6
(
¢¢6 7
type
¢¢7 ;
:
¢¢; <
$str
¢¢= W
,
¢¢W X
nullable
¢¢Y a
:
¢¢a b
false
¢¢c h
)
¢¢h i
,
¢¢i j
	CreatedBy
££ 
=
££ 
table
££  %
.
££% &
Column
££& ,
<
££, -
string
££- 3
>
££3 4
(
££4 5
type
££5 9
:
££9 :
$str
££; A
,
££A B
nullable
££C K
:
££K L
true
££M Q
)
££Q R
,
££R S
	UpdatedAt
§§ 
=
§§ 
table
§§  %
.
§§% &
Column
§§& ,
<
§§, -
DateTime
§§- 5
>
§§5 6
(
§§6 7
type
§§7 ;
:
§§; <
$str
§§= W
,
§§W X
nullable
§§Y a
:
§§a b
true
§§c g
)
§§g h
,
§§h i
	UpdatedBy
•• 
=
•• 
table
••  %
.
••% &
Column
••& ,
<
••, -
string
••- 3
>
••3 4
(
••4 5
type
••5 9
:
••9 :
$str
••; A
,
••A B
nullable
••C K
:
••K L
true
••M Q
)
••Q R
,
••R S
IsActive
¶¶ 
=
¶¶ 
table
¶¶ $
.
¶¶$ %
Column
¶¶% +
<
¶¶+ ,
bool
¶¶, 0
>
¶¶0 1
(
¶¶1 2
type
¶¶2 6
:
¶¶6 7
$str
¶¶8 A
,
¶¶A B
nullable
¶¶C K
:
¶¶K L
false
¶¶M R
)
¶¶R S
,
¶¶S T
	IsDeleted
ßß 
=
ßß 
table
ßß  %
.
ßß% &
Column
ßß& ,
<
ßß, -
bool
ßß- 1
>
ßß1 2
(
ßß2 3
type
ßß3 7
:
ßß7 8
$str
ßß9 B
,
ßßB C
nullable
ßßD L
:
ßßL M
false
ßßN S
)
ßßS T
,
ßßT U
	DeletedAt
®® 
=
®® 
table
®®  %
.
®®% &
Column
®®& ,
<
®®, -
DateTime
®®- 5
>
®®5 6
(
®®6 7
type
®®7 ;
:
®®; <
$str
®®= W
,
®®W X
nullable
®®Y a
:
®®a b
true
®®c g
)
®®g h
}
©© 
,
©© 
constraints
™™ 
:
™™ 
table
™™ "
=>
™™# %
{
´´ 
table
¨¨ 
.
¨¨ 

PrimaryKey
¨¨ $
(
¨¨$ %
$str
¨¨% ;
,
¨¨; <
x
¨¨= >
=>
¨¨? A
x
¨¨B C
.
¨¨C D
Id
¨¨D F
)
¨¨F G
;
¨¨G H
}
≠≠ 
)
≠≠ 
;
≠≠ 
migrationBuilder
ØØ 
.
ØØ 
CreateTable
ØØ (
(
ØØ( )
name
∞∞ 
:
∞∞ 
$str
∞∞ %
,
∞∞% &
columns
±± 
:
±± 
table
±± 
=>
±± !
new
±±" %
{
≤≤ 
Id
≥≥ 
=
≥≥ 
table
≥≥ 
.
≥≥ 
Column
≥≥ %
<
≥≥% &
int
≥≥& )
>
≥≥) *
(
≥≥* +
type
≥≥+ /
:
≥≥/ 0
$str
≥≥1 :
,
≥≥: ;
nullable
≥≥< D
:
≥≥D E
false
≥≥F K
)
≥≥K L
.
¥¥ 

Annotation
¥¥ #
(
¥¥# $
$str
¥¥$ D
,
¥¥D E+
NpgsqlValueGenerationStrategy
¥¥F c
.
¥¥c d%
IdentityByDefaultColumn
¥¥d {
)
¥¥{ |
,
¥¥| }
UserId
µµ 
=
µµ 
table
µµ "
.
µµ" #
Column
µµ# )
<
µµ) *
int
µµ* -
>
µµ- .
(
µµ. /
type
µµ/ 3
:
µµ3 4
$str
µµ5 >
,
µµ> ?
nullable
µµ@ H
:
µµH I
false
µµJ O
)
µµO P
,
µµP Q
Title
∂∂ 
=
∂∂ 
table
∂∂ !
.
∂∂! "
Column
∂∂" (
<
∂∂( )
string
∂∂) /
>
∂∂/ 0
(
∂∂0 1
type
∂∂1 5
:
∂∂5 6
$str
∂∂7 =
,
∂∂= >
nullable
∂∂? G
:
∂∂G H
false
∂∂I N
)
∂∂N O
,
∂∂O P
Message
∑∑ 
=
∑∑ 
table
∑∑ #
.
∑∑# $
Column
∑∑$ *
<
∑∑* +
string
∑∑+ 1
>
∑∑1 2
(
∑∑2 3
type
∑∑3 7
:
∑∑7 8
$str
∑∑9 ?
,
∑∑? @
nullable
∑∑A I
:
∑∑I J
false
∑∑K P
)
∑∑P Q
,
∑∑Q R
IsRead
∏∏ 
=
∏∏ 
table
∏∏ "
.
∏∏" #
Column
∏∏# )
<
∏∏) *
bool
∏∏* .
>
∏∏. /
(
∏∏/ 0
type
∏∏0 4
:
∏∏4 5
$str
∏∏6 ?
,
∏∏? @
nullable
∏∏A I
:
∏∏I J
false
∏∏K P
)
∏∏P Q
,
∏∏Q R
RelatedEntityId
ππ #
=
ππ$ %
table
ππ& +
.
ππ+ ,
Column
ππ, 2
<
ππ2 3
int
ππ3 6
>
ππ6 7
(
ππ7 8
type
ππ8 <
:
ππ< =
$str
ππ> G
,
ππG H
nullable
ππI Q
:
ππQ R
true
ππS W
)
ππW X
,
ππX Y
RelatedEntityType
∫∫ %
=
∫∫& '
table
∫∫( -
.
∫∫- .
Column
∫∫. 4
<
∫∫4 5
string
∫∫5 ;
>
∫∫; <
(
∫∫< =
type
∫∫= A
:
∫∫A B
$str
∫∫C I
,
∫∫I J
nullable
∫∫K S
:
∫∫S T
true
∫∫U Y
)
∫∫Y Z
,
∫∫Z [
	CreatedAt
ªª 
=
ªª 
table
ªª  %
.
ªª% &
Column
ªª& ,
<
ªª, -
DateTime
ªª- 5
>
ªª5 6
(
ªª6 7
type
ªª7 ;
:
ªª; <
$str
ªª= W
,
ªªW X
nullable
ªªY a
:
ªªa b
false
ªªc h
)
ªªh i
,
ªªi j
	CreatedBy
ºº 
=
ºº 
table
ºº  %
.
ºº% &
Column
ºº& ,
<
ºº, -
string
ºº- 3
>
ºº3 4
(
ºº4 5
type
ºº5 9
:
ºº9 :
$str
ºº; A
,
ººA B
nullable
ººC K
:
ººK L
true
ººM Q
)
ººQ R
,
ººR S
	UpdatedAt
ΩΩ 
=
ΩΩ 
table
ΩΩ  %
.
ΩΩ% &
Column
ΩΩ& ,
<
ΩΩ, -
DateTime
ΩΩ- 5
>
ΩΩ5 6
(
ΩΩ6 7
type
ΩΩ7 ;
:
ΩΩ; <
$str
ΩΩ= W
,
ΩΩW X
nullable
ΩΩY a
:
ΩΩa b
true
ΩΩc g
)
ΩΩg h
,
ΩΩh i
	UpdatedBy
ææ 
=
ææ 
table
ææ  %
.
ææ% &
Column
ææ& ,
<
ææ, -
string
ææ- 3
>
ææ3 4
(
ææ4 5
type
ææ5 9
:
ææ9 :
$str
ææ; A
,
ææA B
nullable
ææC K
:
ææK L
true
ææM Q
)
ææQ R
,
ææR S
IsActive
øø 
=
øø 
table
øø $
.
øø$ %
Column
øø% +
<
øø+ ,
bool
øø, 0
>
øø0 1
(
øø1 2
type
øø2 6
:
øø6 7
$str
øø8 A
,
øøA B
nullable
øøC K
:
øøK L
false
øøM R
)
øøR S
,
øøS T
	IsDeleted
¿¿ 
=
¿¿ 
table
¿¿  %
.
¿¿% &
Column
¿¿& ,
<
¿¿, -
bool
¿¿- 1
>
¿¿1 2
(
¿¿2 3
type
¿¿3 7
:
¿¿7 8
$str
¿¿9 B
,
¿¿B C
nullable
¿¿D L
:
¿¿L M
false
¿¿N S
)
¿¿S T
,
¿¿T U
	DeletedAt
¡¡ 
=
¡¡ 
table
¡¡  %
.
¡¡% &
Column
¡¡& ,
<
¡¡, -
DateTime
¡¡- 5
>
¡¡5 6
(
¡¡6 7
type
¡¡7 ;
:
¡¡; <
$str
¡¡= W
,
¡¡W X
nullable
¡¡Y a
:
¡¡a b
true
¡¡c g
)
¡¡g h
}
¬¬ 
,
¬¬ 
constraints
√√ 
:
√√ 
table
√√ "
=>
√√# %
{
ƒƒ 
table
≈≈ 
.
≈≈ 

PrimaryKey
≈≈ $
(
≈≈$ %
$str
≈≈% 7
,
≈≈7 8
x
≈≈9 :
=>
≈≈; =
x
≈≈> ?
.
≈≈? @
Id
≈≈@ B
)
≈≈B C
;
≈≈C D
}
∆∆ 
)
∆∆ 
;
∆∆ 
migrationBuilder
»» 
.
»» 
CreateTable
»» (
(
»»( )
name
…… 
:
…… 
$str
…… #
,
……# $
columns
   
:
   
table
   
=>
   !
new
  " %
{
ÀÀ 
Id
ÃÃ 
=
ÃÃ 
table
ÃÃ 
.
ÃÃ 
Column
ÃÃ %
<
ÃÃ% &
int
ÃÃ& )
>
ÃÃ) *
(
ÃÃ* +
type
ÃÃ+ /
:
ÃÃ/ 0
$str
ÃÃ1 :
,
ÃÃ: ;
nullable
ÃÃ< D
:
ÃÃD E
false
ÃÃF K
)
ÃÃK L
.
ÕÕ 

Annotation
ÕÕ #
(
ÕÕ# $
$str
ÕÕ$ D
,
ÕÕD E+
NpgsqlValueGenerationStrategy
ÕÕF c
.
ÕÕc d%
IdentityByDefaultColumn
ÕÕd {
)
ÕÕ{ |
,
ÕÕ| }
Name
ŒŒ 
=
ŒŒ 
table
ŒŒ  
.
ŒŒ  !
Column
ŒŒ! '
<
ŒŒ' (
string
ŒŒ( .
>
ŒŒ. /
(
ŒŒ/ 0
type
ŒŒ0 4
:
ŒŒ4 5
$str
ŒŒ6 <
,
ŒŒ< =
nullable
ŒŒ> F
:
ŒŒF G
false
ŒŒH M
)
ŒŒM N
,
ŒŒN O
Key
œœ 
=
œœ 
table
œœ 
.
œœ  
Column
œœ  &
<
œœ& '
string
œœ' -
>
œœ- .
(
œœ. /
type
œœ/ 3
:
œœ3 4
$str
œœ5 ;
,
œœ; <
nullable
œœ= E
:
œœE F
false
œœG L
)
œœL M
,
œœM N
	CreatedAt
–– 
=
–– 
table
––  %
.
––% &
Column
––& ,
<
––, -
DateTime
––- 5
>
––5 6
(
––6 7
type
––7 ;
:
––; <
$str
––= W
,
––W X
nullable
––Y a
:
––a b
false
––c h
)
––h i
,
––i j
	CreatedBy
—— 
=
—— 
table
——  %
.
——% &
Column
——& ,
<
——, -
string
——- 3
>
——3 4
(
——4 5
type
——5 9
:
——9 :
$str
——; A
,
——A B
nullable
——C K
:
——K L
true
——M Q
)
——Q R
,
——R S
	UpdatedAt
““ 
=
““ 
table
““  %
.
““% &
Column
““& ,
<
““, -
DateTime
““- 5
>
““5 6
(
““6 7
type
““7 ;
:
““; <
$str
““= W
,
““W X
nullable
““Y a
:
““a b
true
““c g
)
““g h
,
““h i
	UpdatedBy
”” 
=
”” 
table
””  %
.
””% &
Column
””& ,
<
””, -
string
””- 3
>
””3 4
(
””4 5
type
””5 9
:
””9 :
$str
””; A
,
””A B
nullable
””C K
:
””K L
true
””M Q
)
””Q R
,
””R S
IsActive
‘‘ 
=
‘‘ 
table
‘‘ $
.
‘‘$ %
Column
‘‘% +
<
‘‘+ ,
bool
‘‘, 0
>
‘‘0 1
(
‘‘1 2
type
‘‘2 6
:
‘‘6 7
$str
‘‘8 A
,
‘‘A B
nullable
‘‘C K
:
‘‘K L
false
‘‘M R
)
‘‘R S
,
‘‘S T
	IsDeleted
’’ 
=
’’ 
table
’’  %
.
’’% &
Column
’’& ,
<
’’, -
bool
’’- 1
>
’’1 2
(
’’2 3
type
’’3 7
:
’’7 8
$str
’’9 B
,
’’B C
nullable
’’D L
:
’’L M
false
’’N S
)
’’S T
,
’’T U
	DeletedAt
÷÷ 
=
÷÷ 
table
÷÷  %
.
÷÷% &
Column
÷÷& ,
<
÷÷, -
DateTime
÷÷- 5
>
÷÷5 6
(
÷÷6 7
type
÷÷7 ;
:
÷÷; <
$str
÷÷= W
,
÷÷W X
nullable
÷÷Y a
:
÷÷a b
true
÷÷c g
)
÷÷g h
}
◊◊ 
,
◊◊ 
constraints
ÿÿ 
:
ÿÿ 
table
ÿÿ "
=>
ÿÿ# %
{
ŸŸ 
table
⁄⁄ 
.
⁄⁄ 

PrimaryKey
⁄⁄ $
(
⁄⁄$ %
$str
⁄⁄% 5
,
⁄⁄5 6
x
⁄⁄7 8
=>
⁄⁄9 ;
x
⁄⁄< =
.
⁄⁄= >
Id
⁄⁄> @
)
⁄⁄@ A
;
⁄⁄A B
}
€€ 
)
€€ 
;
€€ 
migrationBuilder
›› 
.
›› 
CreateTable
›› (
(
››( )
name
ﬁﬁ 
:
ﬁﬁ 
$str
ﬁﬁ "
,
ﬁﬁ" #
columns
ﬂﬂ 
:
ﬂﬂ 
table
ﬂﬂ 
=>
ﬂﬂ !
new
ﬂﬂ" %
{
‡‡ 
Id
·· 
=
·· 
table
·· 
.
·· 
Column
·· %
<
··% &
int
··& )
>
··) *
(
··* +
type
··+ /
:
··/ 0
$str
··1 :
,
··: ;
nullable
··< D
:
··D E
false
··F K
)
··K L
.
‚‚ 

Annotation
‚‚ #
(
‚‚# $
$str
‚‚$ D
,
‚‚D E+
NpgsqlValueGenerationStrategy
‚‚F c
.
‚‚c d%
IdentityByDefaultColumn
‚‚d {
)
‚‚{ |
,
‚‚| }
Name
„„ 
=
„„ 
table
„„  
.
„„  !
Column
„„! '
<
„„' (
string
„„( .
>
„„. /
(
„„/ 0
type
„„0 4
:
„„4 5
$str
„„6 <
,
„„< =
nullable
„„> F
:
„„F G
false
„„H M
)
„„M N
,
„„N O
	ProjectId
‰‰ 
=
‰‰ 
table
‰‰  %
.
‰‰% &
Column
‰‰& ,
<
‰‰, -
int
‰‰- 0
>
‰‰0 1
(
‰‰1 2
type
‰‰2 6
:
‰‰6 7
$str
‰‰8 A
,
‰‰A B
nullable
‰‰C K
:
‰‰K L
false
‰‰M R
)
‰‰R S
,
‰‰S T
Weight
ÂÂ 
=
ÂÂ 
table
ÂÂ "
.
ÂÂ" #
Column
ÂÂ# )
<
ÂÂ) *
int
ÂÂ* -
>
ÂÂ- .
(
ÂÂ. /
type
ÂÂ/ 3
:
ÂÂ3 4
$str
ÂÂ5 >
,
ÂÂ> ?
nullable
ÂÂ@ H
:
ÂÂH I
false
ÂÂJ O
)
ÂÂO P
,
ÂÂP Q
ColorHex
ÊÊ 
=
ÊÊ 
table
ÊÊ $
.
ÊÊ$ %
Column
ÊÊ% +
<
ÊÊ+ ,
string
ÊÊ, 2
>
ÊÊ2 3
(
ÊÊ3 4
type
ÊÊ4 8
:
ÊÊ8 9
$str
ÊÊ: @
,
ÊÊ@ A
nullable
ÊÊB J
:
ÊÊJ K
true
ÊÊL P
)
ÊÊP Q
,
ÊÊQ R
	SortOrder
ÁÁ 
=
ÁÁ 
table
ÁÁ  %
.
ÁÁ% &
Column
ÁÁ& ,
<
ÁÁ, -
int
ÁÁ- 0
>
ÁÁ0 1
(
ÁÁ1 2
type
ÁÁ2 6
:
ÁÁ6 7
$str
ÁÁ8 A
,
ÁÁA B
nullable
ÁÁC K
:
ÁÁK L
false
ÁÁM R
)
ÁÁR S
,
ÁÁS T
SeverityLevel
ËË !
=
ËË" #
table
ËË$ )
.
ËË) *
Column
ËË* 0
<
ËË0 1
int
ËË1 4
>
ËË4 5
(
ËË5 6
type
ËË6 :
:
ËË: ;
$str
ËË< E
,
ËËE F
nullable
ËËG O
:
ËËO P
false
ËËQ V
)
ËËV W
,
ËËW X
	CreatedAt
ÈÈ 
=
ÈÈ 
table
ÈÈ  %
.
ÈÈ% &
Column
ÈÈ& ,
<
ÈÈ, -
DateTime
ÈÈ- 5
>
ÈÈ5 6
(
ÈÈ6 7
type
ÈÈ7 ;
:
ÈÈ; <
$str
ÈÈ= W
,
ÈÈW X
nullable
ÈÈY a
:
ÈÈa b
false
ÈÈc h
)
ÈÈh i
,
ÈÈi j
	CreatedBy
ÍÍ 
=
ÍÍ 
table
ÍÍ  %
.
ÍÍ% &
Column
ÍÍ& ,
<
ÍÍ, -
string
ÍÍ- 3
>
ÍÍ3 4
(
ÍÍ4 5
type
ÍÍ5 9
:
ÍÍ9 :
$str
ÍÍ; A
,
ÍÍA B
nullable
ÍÍC K
:
ÍÍK L
true
ÍÍM Q
)
ÍÍQ R
,
ÍÍR S
	UpdatedAt
ÎÎ 
=
ÎÎ 
table
ÎÎ  %
.
ÎÎ% &
Column
ÎÎ& ,
<
ÎÎ, -
DateTime
ÎÎ- 5
>
ÎÎ5 6
(
ÎÎ6 7
type
ÎÎ7 ;
:
ÎÎ; <
$str
ÎÎ= W
,
ÎÎW X
nullable
ÎÎY a
:
ÎÎa b
true
ÎÎc g
)
ÎÎg h
,
ÎÎh i
	UpdatedBy
ÏÏ 
=
ÏÏ 
table
ÏÏ  %
.
ÏÏ% &
Column
ÏÏ& ,
<
ÏÏ, -
string
ÏÏ- 3
>
ÏÏ3 4
(
ÏÏ4 5
type
ÏÏ5 9
:
ÏÏ9 :
$str
ÏÏ; A
,
ÏÏA B
nullable
ÏÏC K
:
ÏÏK L
true
ÏÏM Q
)
ÏÏQ R
,
ÏÏR S
IsActive
ÌÌ 
=
ÌÌ 
table
ÌÌ $
.
ÌÌ$ %
Column
ÌÌ% +
<
ÌÌ+ ,
bool
ÌÌ, 0
>
ÌÌ0 1
(
ÌÌ1 2
type
ÌÌ2 6
:
ÌÌ6 7
$str
ÌÌ8 A
,
ÌÌA B
nullable
ÌÌC K
:
ÌÌK L
false
ÌÌM R
)
ÌÌR S
,
ÌÌS T
	IsDeleted
ÓÓ 
=
ÓÓ 
table
ÓÓ  %
.
ÓÓ% &
Column
ÓÓ& ,
<
ÓÓ, -
bool
ÓÓ- 1
>
ÓÓ1 2
(
ÓÓ2 3
type
ÓÓ3 7
:
ÓÓ7 8
$str
ÓÓ9 B
,
ÓÓB C
nullable
ÓÓD L
:
ÓÓL M
false
ÓÓN S
)
ÓÓS T
,
ÓÓT U
	DeletedAt
ÔÔ 
=
ÔÔ 
table
ÔÔ  %
.
ÔÔ% &
Column
ÔÔ& ,
<
ÔÔ, -
DateTime
ÔÔ- 5
>
ÔÔ5 6
(
ÔÔ6 7
type
ÔÔ7 ;
:
ÔÔ; <
$str
ÔÔ= W
,
ÔÔW X
nullable
ÔÔY a
:
ÔÔa b
true
ÔÔc g
)
ÔÔg h
}
 
,
 
constraints
ÒÒ 
:
ÒÒ 
table
ÒÒ "
=>
ÒÒ# %
{
ÚÚ 
table
ÛÛ 
.
ÛÛ 

PrimaryKey
ÛÛ $
(
ÛÛ$ %
$str
ÛÛ% 4
,
ÛÛ4 5
x
ÛÛ6 7
=>
ÛÛ8 :
x
ÛÛ; <
.
ÛÛ< =
Id
ÛÛ= ?
)
ÛÛ? @
;
ÛÛ@ A
}
ÙÙ 
)
ÙÙ 
;
ÙÙ 
migrationBuilder
ˆˆ 
.
ˆˆ 
CreateTable
ˆˆ (
(
ˆˆ( )
name
˜˜ 
:
˜˜ 
$str
˜˜  
,
˜˜  !
columns
¯¯ 
:
¯¯ 
table
¯¯ 
=>
¯¯ !
new
¯¯" %
{
˘˘ 
Id
˙˙ 
=
˙˙ 
table
˙˙ 
.
˙˙ 
Column
˙˙ %
<
˙˙% &
int
˙˙& )
>
˙˙) *
(
˙˙* +
type
˙˙+ /
:
˙˙/ 0
$str
˙˙1 :
,
˙˙: ;
nullable
˙˙< D
:
˙˙D E
false
˙˙F K
)
˙˙K L
.
˚˚ 

Annotation
˚˚ #
(
˚˚# $
$str
˚˚$ D
,
˚˚D E+
NpgsqlValueGenerationStrategy
˚˚F c
.
˚˚c d%
IdentityByDefaultColumn
˚˚d {
)
˚˚{ |
,
˚˚| }
Name
¸¸ 
=
¸¸ 
table
¸¸  
.
¸¸  !
Column
¸¸! '
<
¸¸' (
string
¸¸( .
>
¸¸. /
(
¸¸/ 0
type
¸¸0 4
:
¸¸4 5
$str
¸¸6 <
,
¸¸< =
nullable
¸¸> F
:
¸¸F G
false
¸¸H M
)
¸¸M N
,
¸¸N O

ProjectKey
˝˝ 
=
˝˝  
table
˝˝! &
.
˝˝& '
Column
˝˝' -
<
˝˝- .
string
˝˝. 4
>
˝˝4 5
(
˝˝5 6
type
˝˝6 :
:
˝˝: ;
$str
˝˝< B
,
˝˝B C
nullable
˝˝D L
:
˝˝L M
false
˝˝N S
)
˝˝S T
,
˝˝T U
Description
˛˛ 
=
˛˛  !
table
˛˛" '
.
˛˛' (
Column
˛˛( .
<
˛˛. /
string
˛˛/ 5
>
˛˛5 6
(
˛˛6 7
type
˛˛7 ;
:
˛˛; <
$str
˛˛= C
,
˛˛C D
nullable
˛˛E M
:
˛˛M N
true
˛˛O S
)
˛˛S T
,
˛˛T U#
CurrentTicketSequence
ˇˇ )
=
ˇˇ* +
table
ˇˇ, 1
.
ˇˇ1 2
Column
ˇˇ2 8
<
ˇˇ8 9
int
ˇˇ9 <
>
ˇˇ< =
(
ˇˇ= >
type
ˇˇ> B
:
ˇˇB C
$str
ˇˇD M
,
ˇˇM N
nullable
ˇˇO W
:
ˇˇW X
false
ˇˇY ^
)
ˇˇ^ _
,
ˇˇ_ `
	CreatedAt
ÄÄ 
=
ÄÄ 
table
ÄÄ  %
.
ÄÄ% &
Column
ÄÄ& ,
<
ÄÄ, -
DateTime
ÄÄ- 5
>
ÄÄ5 6
(
ÄÄ6 7
type
ÄÄ7 ;
:
ÄÄ; <
$str
ÄÄ= W
,
ÄÄW X
nullable
ÄÄY a
:
ÄÄa b
false
ÄÄc h
)
ÄÄh i
,
ÄÄi j
	CreatedBy
ÅÅ 
=
ÅÅ 
table
ÅÅ  %
.
ÅÅ% &
Column
ÅÅ& ,
<
ÅÅ, -
string
ÅÅ- 3
>
ÅÅ3 4
(
ÅÅ4 5
type
ÅÅ5 9
:
ÅÅ9 :
$str
ÅÅ; A
,
ÅÅA B
nullable
ÅÅC K
:
ÅÅK L
true
ÅÅM Q
)
ÅÅQ R
,
ÅÅR S
	UpdatedAt
ÇÇ 
=
ÇÇ 
table
ÇÇ  %
.
ÇÇ% &
Column
ÇÇ& ,
<
ÇÇ, -
DateTime
ÇÇ- 5
>
ÇÇ5 6
(
ÇÇ6 7
type
ÇÇ7 ;
:
ÇÇ; <
$str
ÇÇ= W
,
ÇÇW X
nullable
ÇÇY a
:
ÇÇa b
true
ÇÇc g
)
ÇÇg h
,
ÇÇh i
	UpdatedBy
ÉÉ 
=
ÉÉ 
table
ÉÉ  %
.
ÉÉ% &
Column
ÉÉ& ,
<
ÉÉ, -
string
ÉÉ- 3
>
ÉÉ3 4
(
ÉÉ4 5
type
ÉÉ5 9
:
ÉÉ9 :
$str
ÉÉ; A
,
ÉÉA B
nullable
ÉÉC K
:
ÉÉK L
true
ÉÉM Q
)
ÉÉQ R
,
ÉÉR S
IsActive
ÑÑ 
=
ÑÑ 
table
ÑÑ $
.
ÑÑ$ %
Column
ÑÑ% +
<
ÑÑ+ ,
bool
ÑÑ, 0
>
ÑÑ0 1
(
ÑÑ1 2
type
ÑÑ2 6
:
ÑÑ6 7
$str
ÑÑ8 A
,
ÑÑA B
nullable
ÑÑC K
:
ÑÑK L
false
ÑÑM R
)
ÑÑR S
,
ÑÑS T
	IsDeleted
ÖÖ 
=
ÖÖ 
table
ÖÖ  %
.
ÖÖ% &
Column
ÖÖ& ,
<
ÖÖ, -
bool
ÖÖ- 1
>
ÖÖ1 2
(
ÖÖ2 3
type
ÖÖ3 7
:
ÖÖ7 8
$str
ÖÖ9 B
,
ÖÖB C
nullable
ÖÖD L
:
ÖÖL M
false
ÖÖN S
)
ÖÖS T
,
ÖÖT U
	DeletedAt
ÜÜ 
=
ÜÜ 
table
ÜÜ  %
.
ÜÜ% &
Column
ÜÜ& ,
<
ÜÜ, -
DateTime
ÜÜ- 5
>
ÜÜ5 6
(
ÜÜ6 7
type
ÜÜ7 ;
:
ÜÜ; <
$str
ÜÜ= W
,
ÜÜW X
nullable
ÜÜY a
:
ÜÜa b
true
ÜÜc g
)
ÜÜg h
}
áá 
,
áá 
constraints
àà 
:
àà 
table
àà "
=>
àà# %
{
ââ 
table
ää 
.
ää 

PrimaryKey
ää $
(
ää$ %
$str
ää% 2
,
ää2 3
x
ää4 5
=>
ää6 8
x
ää9 :
.
ää: ;
Id
ää; =
)
ää= >
;
ää> ?
}
ãã 
)
ãã 
;
ãã 
migrationBuilder
çç 
.
çç 
CreateTable
çç (
(
çç( )
name
éé 
:
éé 
$str
éé 
,
éé 
columns
èè 
:
èè 
table
èè 
=>
èè !
new
èè" %
{
êê 
Id
ëë 
=
ëë 
table
ëë 
.
ëë 
Column
ëë %
<
ëë% &
int
ëë& )
>
ëë) *
(
ëë* +
type
ëë+ /
:
ëë/ 0
$str
ëë1 :
,
ëë: ;
nullable
ëë< D
:
ëëD E
false
ëëF K
)
ëëK L
.
íí 

Annotation
íí #
(
íí# $
$str
íí$ D
,
ííD E+
NpgsqlValueGenerationStrategy
ííF c
.
ííc d%
IdentityByDefaultColumn
ííd {
)
íí{ |
,
íí| }
Name
ìì 
=
ìì 
table
ìì  
.
ìì  !
Column
ìì! '
<
ìì' (
string
ìì( .
>
ìì. /
(
ìì/ 0
type
ìì0 4
:
ìì4 5
$str
ìì6 <
,
ìì< =
nullable
ìì> F
:
ììF G
false
ììH M
)
ììM N
,
ììN O
	CreatedAt
îî 
=
îî 
table
îî  %
.
îî% &
Column
îî& ,
<
îî, -
DateTime
îî- 5
>
îî5 6
(
îî6 7
type
îî7 ;
:
îî; <
$str
îî= W
,
îîW X
nullable
îîY a
:
îîa b
false
îîc h
)
îîh i
,
îîi j
	CreatedBy
ïï 
=
ïï 
table
ïï  %
.
ïï% &
Column
ïï& ,
<
ïï, -
string
ïï- 3
>
ïï3 4
(
ïï4 5
type
ïï5 9
:
ïï9 :
$str
ïï; A
,
ïïA B
nullable
ïïC K
:
ïïK L
true
ïïM Q
)
ïïQ R
,
ïïR S
	UpdatedAt
ññ 
=
ññ 
table
ññ  %
.
ññ% &
Column
ññ& ,
<
ññ, -
DateTime
ññ- 5
>
ññ5 6
(
ññ6 7
type
ññ7 ;
:
ññ; <
$str
ññ= W
,
ññW X
nullable
ññY a
:
ñña b
true
ññc g
)
ññg h
,
ññh i
	UpdatedBy
óó 
=
óó 
table
óó  %
.
óó% &
Column
óó& ,
<
óó, -
string
óó- 3
>
óó3 4
(
óó4 5
type
óó5 9
:
óó9 :
$str
óó; A
,
óóA B
nullable
óóC K
:
óóK L
true
óóM Q
)
óóQ R
,
óóR S
IsActive
òò 
=
òò 
table
òò $
.
òò$ %
Column
òò% +
<
òò+ ,
bool
òò, 0
>
òò0 1
(
òò1 2
type
òò2 6
:
òò6 7
$str
òò8 A
,
òòA B
nullable
òòC K
:
òòK L
false
òòM R
)
òòR S
,
òòS T
	IsDeleted
ôô 
=
ôô 
table
ôô  %
.
ôô% &
Column
ôô& ,
<
ôô, -
bool
ôô- 1
>
ôô1 2
(
ôô2 3
type
ôô3 7
:
ôô7 8
$str
ôô9 B
,
ôôB C
nullable
ôôD L
:
ôôL M
false
ôôN S
)
ôôS T
,
ôôT U
	DeletedAt
öö 
=
öö 
table
öö  %
.
öö% &
Column
öö& ,
<
öö, -
DateTime
öö- 5
>
öö5 6
(
öö6 7
type
öö7 ;
:
öö; <
$str
öö= W
,
ööW X
nullable
ööY a
:
ööa b
true
ööc g
)
öög h
}
õõ 
,
õõ 
constraints
úú 
:
úú 
table
úú "
=>
úú# %
{
ùù 
table
ûû 
.
ûû 

PrimaryKey
ûû $
(
ûû$ %
$str
ûû% /
,
ûû/ 0
x
ûû1 2
=>
ûû3 5
x
ûû6 7
.
ûû7 8
Id
ûû8 :
)
ûû: ;
;
ûû; <
}
üü 
)
üü 
;
üü 
migrationBuilder
°° 
.
°° 
CreateTable
°° (
(
°°( )
name
¢¢ 
:
¢¢ 
$str
¢¢ #
,
¢¢# $
columns
££ 
:
££ 
table
££ 
=>
££ !
new
££" %
{
§§ 
Id
•• 
=
•• 
table
•• 
.
•• 
Column
•• %
<
••% &
int
••& )
>
••) *
(
••* +
type
••+ /
:
••/ 0
$str
••1 :
,
••: ;
nullable
••< D
:
••D E
false
••F K
)
••K L
.
¶¶ 

Annotation
¶¶ #
(
¶¶# $
$str
¶¶$ D
,
¶¶D E+
NpgsqlValueGenerationStrategy
¶¶F c
.
¶¶c d%
IdentityByDefaultColumn
¶¶d {
)
¶¶{ |
,
¶¶| }
Name
ßß 
=
ßß 
table
ßß  
.
ßß  !
Column
ßß! '
<
ßß' (
string
ßß( .
>
ßß. /
(
ßß/ 0
type
ßß0 4
:
ßß4 5
$str
ßß6 <
,
ßß< =
nullable
ßß> F
:
ßßF G
false
ßßH M
)
ßßM N
,
ßßN O
Description
®® 
=
®®  !
table
®®" '
.
®®' (
Column
®®( .
<
®®. /
string
®®/ 5
>
®®5 6
(
®®6 7
type
®®7 ;
:
®®; <
$str
®®= C
,
®®C D
nullable
®®E M
:
®®M N
true
®®O S
)
®®S T
,
®®T U
	ProjectId
©© 
=
©© 
table
©©  %
.
©©% &
Column
©©& ,
<
©©, -
int
©©- 0
>
©©0 1
(
©©1 2
type
©©2 6
:
©©6 7
$str
©©8 A
,
©©A B
nullable
©©C K
:
©©K L
true
©©M Q
)
©©Q R
,
©©R S
	CreatedAt
™™ 
=
™™ 
table
™™  %
.
™™% &
Column
™™& ,
<
™™, -
DateTime
™™- 5
>
™™5 6
(
™™6 7
type
™™7 ;
:
™™; <
$str
™™= W
,
™™W X
nullable
™™Y a
:
™™a b
false
™™c h
)
™™h i
,
™™i j
	CreatedBy
´´ 
=
´´ 
table
´´  %
.
´´% &
Column
´´& ,
<
´´, -
string
´´- 3
>
´´3 4
(
´´4 5
type
´´5 9
:
´´9 :
$str
´´; A
,
´´A B
nullable
´´C K
:
´´K L
true
´´M Q
)
´´Q R
,
´´R S
	UpdatedAt
¨¨ 
=
¨¨ 
table
¨¨  %
.
¨¨% &
Column
¨¨& ,
<
¨¨, -
DateTime
¨¨- 5
>
¨¨5 6
(
¨¨6 7
type
¨¨7 ;
:
¨¨; <
$str
¨¨= W
,
¨¨W X
nullable
¨¨Y a
:
¨¨a b
true
¨¨c g
)
¨¨g h
,
¨¨h i
	UpdatedBy
≠≠ 
=
≠≠ 
table
≠≠  %
.
≠≠% &
Column
≠≠& ,
<
≠≠, -
string
≠≠- 3
>
≠≠3 4
(
≠≠4 5
type
≠≠5 9
:
≠≠9 :
$str
≠≠; A
,
≠≠A B
nullable
≠≠C K
:
≠≠K L
true
≠≠M Q
)
≠≠Q R
,
≠≠R S
IsActive
ÆÆ 
=
ÆÆ 
table
ÆÆ $
.
ÆÆ$ %
Column
ÆÆ% +
<
ÆÆ+ ,
bool
ÆÆ, 0
>
ÆÆ0 1
(
ÆÆ1 2
type
ÆÆ2 6
:
ÆÆ6 7
$str
ÆÆ8 A
,
ÆÆA B
nullable
ÆÆC K
:
ÆÆK L
false
ÆÆM R
)
ÆÆR S
,
ÆÆS T
	IsDeleted
ØØ 
=
ØØ 
table
ØØ  %
.
ØØ% &
Column
ØØ& ,
<
ØØ, -
bool
ØØ- 1
>
ØØ1 2
(
ØØ2 3
type
ØØ3 7
:
ØØ7 8
$str
ØØ9 B
,
ØØB C
nullable
ØØD L
:
ØØL M
false
ØØN S
)
ØØS T
,
ØØT U
	DeletedAt
∞∞ 
=
∞∞ 
table
∞∞  %
.
∞∞% &
Column
∞∞& ,
<
∞∞, -
DateTime
∞∞- 5
>
∞∞5 6
(
∞∞6 7
type
∞∞7 ;
:
∞∞; <
$str
∞∞= W
,
∞∞W X
nullable
∞∞Y a
:
∞∞a b
true
∞∞c g
)
∞∞g h
}
±± 
,
±± 
constraints
≤≤ 
:
≤≤ 
table
≤≤ "
=>
≤≤# %
{
≥≥ 
table
¥¥ 
.
¥¥ 

PrimaryKey
¥¥ $
(
¥¥$ %
$str
¥¥% 5
,
¥¥5 6
x
¥¥7 8
=>
¥¥9 ;
x
¥¥< =
.
¥¥= >
Id
¥¥> @
)
¥¥@ A
;
¥¥A B
}
µµ 
)
µµ 
;
µµ 
migrationBuilder
∑∑ 
.
∑∑ 
CreateTable
∑∑ (
(
∑∑( )
name
∏∏ 
:
∏∏ 
$str
∏∏  
,
∏∏  !
columns
ππ 
:
ππ 
table
ππ 
=>
ππ !
new
ππ" %
{
∫∫ 
Id
ªª 
=
ªª 
table
ªª 
.
ªª 
Column
ªª %
<
ªª% &
int
ªª& )
>
ªª) *
(
ªª* +
type
ªª+ /
:
ªª/ 0
$str
ªª1 :
,
ªª: ;
nullable
ªª< D
:
ªªD E
false
ªªF K
)
ªªK L
.
ºº 

Annotation
ºº #
(
ºº# $
$str
ºº$ D
,
ººD E+
NpgsqlValueGenerationStrategy
ººF c
.
ººc d%
IdentityByDefaultColumn
ººd {
)
ºº{ |
,
ºº| }
Name
ΩΩ 
=
ΩΩ 
table
ΩΩ  
.
ΩΩ  !
Column
ΩΩ! '
<
ΩΩ' (
string
ΩΩ( .
>
ΩΩ. /
(
ΩΩ/ 0
type
ΩΩ0 4
:
ΩΩ4 5
$str
ΩΩ6 <
,
ΩΩ< =
nullable
ΩΩ> F
:
ΩΩF G
false
ΩΩH M
)
ΩΩM N
,
ΩΩN O
	ProjectId
ææ 
=
ææ 
table
ææ  %
.
ææ% &
Column
ææ& ,
<
ææ, -
int
ææ- 0
>
ææ0 1
(
ææ1 2
type
ææ2 6
:
ææ6 7
$str
ææ8 A
,
ææA B
nullable
ææC K
:
ææK L
false
ææM R
)
ææR S
,
ææS T
IsClosedStatus
øø "
=
øø# $
table
øø% *
.
øø* +
Column
øø+ 1
<
øø1 2
bool
øø2 6
>
øø6 7
(
øø7 8
type
øø8 <
:
øø< =
$str
øø> G
,
øøG H
nullable
øøI Q
:
øøQ R
false
øøS X
)
øøX Y
,
øøY Z
ColorHex
¿¿ 
=
¿¿ 
table
¿¿ $
.
¿¿$ %
Column
¿¿% +
<
¿¿+ ,
string
¿¿, 2
>
¿¿2 3
(
¿¿3 4
type
¿¿4 8
:
¿¿8 9
$str
¿¿: @
,
¿¿@ A
nullable
¿¿B J
:
¿¿J K
true
¿¿L P
)
¿¿P Q
,
¿¿Q R
	SortOrder
¡¡ 
=
¡¡ 
table
¡¡  %
.
¡¡% &
Column
¡¡& ,
<
¡¡, -
int
¡¡- 0
>
¡¡0 1
(
¡¡1 2
type
¡¡2 6
:
¡¡6 7
$str
¡¡8 A
,
¡¡A B
nullable
¡¡C K
:
¡¡K L
false
¡¡M R
)
¡¡R S
,
¡¡S T
IsSystemDefault
¬¬ #
=
¬¬$ %
table
¬¬& +
.
¬¬+ ,
Column
¬¬, 2
<
¬¬2 3
bool
¬¬3 7
>
¬¬7 8
(
¬¬8 9
type
¬¬9 =
:
¬¬= >
$str
¬¬? H
,
¬¬H I
nullable
¬¬J R
:
¬¬R S
false
¬¬T Y
)
¬¬Y Z
,
¬¬Z [
	CreatedAt
√√ 
=
√√ 
table
√√  %
.
√√% &
Column
√√& ,
<
√√, -
DateTime
√√- 5
>
√√5 6
(
√√6 7
type
√√7 ;
:
√√; <
$str
√√= W
,
√√W X
nullable
√√Y a
:
√√a b
false
√√c h
)
√√h i
,
√√i j
	CreatedBy
ƒƒ 
=
ƒƒ 
table
ƒƒ  %
.
ƒƒ% &
Column
ƒƒ& ,
<
ƒƒ, -
string
ƒƒ- 3
>
ƒƒ3 4
(
ƒƒ4 5
type
ƒƒ5 9
:
ƒƒ9 :
$str
ƒƒ; A
,
ƒƒA B
nullable
ƒƒC K
:
ƒƒK L
true
ƒƒM Q
)
ƒƒQ R
,
ƒƒR S
	UpdatedAt
≈≈ 
=
≈≈ 
table
≈≈  %
.
≈≈% &
Column
≈≈& ,
<
≈≈, -
DateTime
≈≈- 5
>
≈≈5 6
(
≈≈6 7
type
≈≈7 ;
:
≈≈; <
$str
≈≈= W
,
≈≈W X
nullable
≈≈Y a
:
≈≈a b
true
≈≈c g
)
≈≈g h
,
≈≈h i
	UpdatedBy
∆∆ 
=
∆∆ 
table
∆∆  %
.
∆∆% &
Column
∆∆& ,
<
∆∆, -
string
∆∆- 3
>
∆∆3 4
(
∆∆4 5
type
∆∆5 9
:
∆∆9 :
$str
∆∆; A
,
∆∆A B
nullable
∆∆C K
:
∆∆K L
true
∆∆M Q
)
∆∆Q R
,
∆∆R S
IsActive
«« 
=
«« 
table
«« $
.
««$ %
Column
««% +
<
««+ ,
bool
««, 0
>
««0 1
(
««1 2
type
««2 6
:
««6 7
$str
««8 A
,
««A B
nullable
««C K
:
««K L
false
««M R
)
««R S
,
««S T
	IsDeleted
»» 
=
»» 
table
»»  %
.
»»% &
Column
»»& ,
<
»», -
bool
»»- 1
>
»»1 2
(
»»2 3
type
»»3 7
:
»»7 8
$str
»»9 B
,
»»B C
nullable
»»D L
:
»»L M
false
»»N S
)
»»S T
,
»»T U
	DeletedAt
…… 
=
…… 
table
……  %
.
……% &
Column
……& ,
<
……, -
DateTime
……- 5
>
……5 6
(
……6 7
type
……7 ;
:
……; <
$str
……= W
,
……W X
nullable
……Y a
:
……a b
true
……c g
)
……g h
}
   
,
   
constraints
ÀÀ 
:
ÀÀ 
table
ÀÀ "
=>
ÀÀ# %
{
ÃÃ 
table
ÕÕ 
.
ÕÕ 

PrimaryKey
ÕÕ $
(
ÕÕ$ %
$str
ÕÕ% 2
,
ÕÕ2 3
x
ÕÕ4 5
=>
ÕÕ6 8
x
ÕÕ9 :
.
ÕÕ: ;
Id
ÕÕ; =
)
ÕÕ= >
;
ÕÕ> ?
}
ŒŒ 
)
ŒŒ 
;
ŒŒ 
migrationBuilder
–– 
.
–– 
CreateTable
–– (
(
––( )
name
—— 
:
—— 
$str
—— #
,
——# $
columns
““ 
:
““ 
table
““ 
=>
““ !
new
““" %
{
”” 
Id
‘‘ 
=
‘‘ 
table
‘‘ 
.
‘‘ 
Column
‘‘ %
<
‘‘% &
int
‘‘& )
>
‘‘) *
(
‘‘* +
type
‘‘+ /
:
‘‘/ 0
$str
‘‘1 :
,
‘‘: ;
nullable
‘‘< D
:
‘‘D E
false
‘‘F K
)
‘‘K L
.
’’ 

Annotation
’’ #
(
’’# $
$str
’’$ D
,
’’D E+
NpgsqlValueGenerationStrategy
’’F c
.
’’c d%
IdentityByDefaultColumn
’’d {
)
’’{ |
,
’’| }
Name
÷÷ 
=
÷÷ 
table
÷÷  
.
÷÷  !
Column
÷÷! '
<
÷÷' (
string
÷÷( .
>
÷÷. /
(
÷÷/ 0
type
÷÷0 4
:
÷÷4 5
$str
÷÷6 <
,
÷÷< =
nullable
÷÷> F
:
÷÷F G
false
÷÷H M
)
÷÷M N
,
÷÷N O
	ProjectId
◊◊ 
=
◊◊ 
table
◊◊  %
.
◊◊% &
Column
◊◊& ,
<
◊◊, -
int
◊◊- 0
>
◊◊0 1
(
◊◊1 2
type
◊◊2 6
:
◊◊6 7
$str
◊◊8 A
,
◊◊A B
nullable
◊◊C K
:
◊◊K L
false
◊◊M R
)
◊◊R S
,
◊◊S T
Description
ÿÿ 
=
ÿÿ  !
table
ÿÿ" '
.
ÿÿ' (
Column
ÿÿ( .
<
ÿÿ. /
string
ÿÿ/ 5
>
ÿÿ5 6
(
ÿÿ6 7
type
ÿÿ7 ;
:
ÿÿ; <
$str
ÿÿ= C
,
ÿÿC D
nullable
ÿÿE M
:
ÿÿM N
true
ÿÿO S
)
ÿÿS T
,
ÿÿT U
Icon
ŸŸ 
=
ŸŸ 
table
ŸŸ  
.
ŸŸ  !
Column
ŸŸ! '
<
ŸŸ' (
string
ŸŸ( .
>
ŸŸ. /
(
ŸŸ/ 0
type
ŸŸ0 4
:
ŸŸ4 5
$str
ŸŸ6 <
,
ŸŸ< =
nullable
ŸŸ> F
:
ŸŸF G
true
ŸŸH L
)
ŸŸL M
,
ŸŸM N
ColorHex
⁄⁄ 
=
⁄⁄ 
table
⁄⁄ $
.
⁄⁄$ %
Column
⁄⁄% +
<
⁄⁄+ ,
string
⁄⁄, 2
>
⁄⁄2 3
(
⁄⁄3 4
type
⁄⁄4 8
:
⁄⁄8 9
$str
⁄⁄: @
,
⁄⁄@ A
nullable
⁄⁄B J
:
⁄⁄J K
true
⁄⁄L P
)
⁄⁄P Q
,
⁄⁄Q R
IsSystemDefault
€€ #
=
€€$ %
table
€€& +
.
€€+ ,
Column
€€, 2
<
€€2 3
bool
€€3 7
>
€€7 8
(
€€8 9
type
€€9 =
:
€€= >
$str
€€? H
,
€€H I
nullable
€€J R
:
€€R S
false
€€T Y
)
€€Y Z
,
€€Z [
	CreatedAt
‹‹ 
=
‹‹ 
table
‹‹  %
.
‹‹% &
Column
‹‹& ,
<
‹‹, -
DateTime
‹‹- 5
>
‹‹5 6
(
‹‹6 7
type
‹‹7 ;
:
‹‹; <
$str
‹‹= W
,
‹‹W X
nullable
‹‹Y a
:
‹‹a b
false
‹‹c h
)
‹‹h i
,
‹‹i j
	CreatedBy
›› 
=
›› 
table
››  %
.
››% &
Column
››& ,
<
››, -
string
››- 3
>
››3 4
(
››4 5
type
››5 9
:
››9 :
$str
››; A
,
››A B
nullable
››C K
:
››K L
true
››M Q
)
››Q R
,
››R S
	UpdatedAt
ﬁﬁ 
=
ﬁﬁ 
table
ﬁﬁ  %
.
ﬁﬁ% &
Column
ﬁﬁ& ,
<
ﬁﬁ, -
DateTime
ﬁﬁ- 5
>
ﬁﬁ5 6
(
ﬁﬁ6 7
type
ﬁﬁ7 ;
:
ﬁﬁ; <
$str
ﬁﬁ= W
,
ﬁﬁW X
nullable
ﬁﬁY a
:
ﬁﬁa b
true
ﬁﬁc g
)
ﬁﬁg h
,
ﬁﬁh i
	UpdatedBy
ﬂﬂ 
=
ﬂﬂ 
table
ﬂﬂ  %
.
ﬂﬂ% &
Column
ﬂﬂ& ,
<
ﬂﬂ, -
string
ﬂﬂ- 3
>
ﬂﬂ3 4
(
ﬂﬂ4 5
type
ﬂﬂ5 9
:
ﬂﬂ9 :
$str
ﬂﬂ; A
,
ﬂﬂA B
nullable
ﬂﬂC K
:
ﬂﬂK L
true
ﬂﬂM Q
)
ﬂﬂQ R
,
ﬂﬂR S
IsActive
‡‡ 
=
‡‡ 
table
‡‡ $
.
‡‡$ %
Column
‡‡% +
<
‡‡+ ,
bool
‡‡, 0
>
‡‡0 1
(
‡‡1 2
type
‡‡2 6
:
‡‡6 7
$str
‡‡8 A
,
‡‡A B
nullable
‡‡C K
:
‡‡K L
false
‡‡M R
)
‡‡R S
,
‡‡S T
	IsDeleted
·· 
=
·· 
table
··  %
.
··% &
Column
··& ,
<
··, -
bool
··- 1
>
··1 2
(
··2 3
type
··3 7
:
··7 8
$str
··9 B
,
··B C
nullable
··D L
:
··L M
false
··N S
)
··S T
,
··T U
	DeletedAt
‚‚ 
=
‚‚ 
table
‚‚  %
.
‚‚% &
Column
‚‚& ,
<
‚‚, -
DateTime
‚‚- 5
>
‚‚5 6
(
‚‚6 7
type
‚‚7 ;
:
‚‚; <
$str
‚‚= W
,
‚‚W X
nullable
‚‚Y a
:
‚‚a b
true
‚‚c g
)
‚‚g h
}
„„ 
,
„„ 
constraints
‰‰ 
:
‰‰ 
table
‰‰ "
=>
‰‰# %
{
ÂÂ 
table
ÊÊ 
.
ÊÊ 

PrimaryKey
ÊÊ $
(
ÊÊ$ %
$str
ÊÊ% 5
,
ÊÊ5 6
x
ÊÊ7 8
=>
ÊÊ9 ;
x
ÊÊ< =
.
ÊÊ= >
Id
ÊÊ> @
)
ÊÊ@ A
;
ÊÊA B
}
ÁÁ 
)
ÁÁ 
;
ÁÁ 
migrationBuilder
ÈÈ 
.
ÈÈ 
CreateTable
ÈÈ (
(
ÈÈ( )
name
ÍÍ 
:
ÍÍ 
$str
ÍÍ !
,
ÍÍ! "
columns
ÎÎ 
:
ÎÎ 
table
ÎÎ 
=>
ÎÎ !
new
ÎÎ" %
{
ÏÏ 
Id
ÌÌ 
=
ÌÌ 
table
ÌÌ 
.
ÌÌ 
Column
ÌÌ %
<
ÌÌ% &
int
ÌÌ& )
>
ÌÌ) *
(
ÌÌ* +
type
ÌÌ+ /
:
ÌÌ/ 0
$str
ÌÌ1 :
,
ÌÌ: ;
nullable
ÌÌ< D
:
ÌÌD E
false
ÌÌF K
)
ÌÌK L
.
ÓÓ 

Annotation
ÓÓ #
(
ÓÓ# $
$str
ÓÓ$ D
,
ÓÓD E+
NpgsqlValueGenerationStrategy
ÓÓF c
.
ÓÓc d%
IdentityByDefaultColumn
ÓÓd {
)
ÓÓ{ |
,
ÓÓ| }
Name
ÔÔ 
=
ÔÔ 
table
ÔÔ  
.
ÔÔ  !
Column
ÔÔ! '
<
ÔÔ' (
string
ÔÔ( .
>
ÔÔ. /
(
ÔÔ/ 0
type
ÔÔ0 4
:
ÔÔ4 5
$str
ÔÔ6 <
,
ÔÔ< =
nullable
ÔÔ> F
:
ÔÔF G
false
ÔÔH M
)
ÔÔM N
,
ÔÔN O
Description
 
=
  !
table
" '
.
' (
Column
( .
<
. /
string
/ 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= C
,
C D
nullable
E M
:
M N
true
O S
)
S T
,
T U
	ProjectId
ÒÒ 
=
ÒÒ 
table
ÒÒ  %
.
ÒÒ% &
Column
ÒÒ& ,
<
ÒÒ, -
int
ÒÒ- 0
>
ÒÒ0 1
(
ÒÒ1 2
type
ÒÒ2 6
:
ÒÒ6 7
$str
ÒÒ8 A
,
ÒÒA B
nullable
ÒÒC K
:
ÒÒK L
true
ÒÒM Q
)
ÒÒQ R
,
ÒÒR S
	CreatedAt
ÚÚ 
=
ÚÚ 
table
ÚÚ  %
.
ÚÚ% &
Column
ÚÚ& ,
<
ÚÚ, -
DateTime
ÚÚ- 5
>
ÚÚ5 6
(
ÚÚ6 7
type
ÚÚ7 ;
:
ÚÚ; <
$str
ÚÚ= W
,
ÚÚW X
nullable
ÚÚY a
:
ÚÚa b
false
ÚÚc h
)
ÚÚh i
,
ÚÚi j
	CreatedBy
ÛÛ 
=
ÛÛ 
table
ÛÛ  %
.
ÛÛ% &
Column
ÛÛ& ,
<
ÛÛ, -
string
ÛÛ- 3
>
ÛÛ3 4
(
ÛÛ4 5
type
ÛÛ5 9
:
ÛÛ9 :
$str
ÛÛ; A
,
ÛÛA B
nullable
ÛÛC K
:
ÛÛK L
true
ÛÛM Q
)
ÛÛQ R
,
ÛÛR S
	UpdatedAt
ÙÙ 
=
ÙÙ 
table
ÙÙ  %
.
ÙÙ% &
Column
ÙÙ& ,
<
ÙÙ, -
DateTime
ÙÙ- 5
>
ÙÙ5 6
(
ÙÙ6 7
type
ÙÙ7 ;
:
ÙÙ; <
$str
ÙÙ= W
,
ÙÙW X
nullable
ÙÙY a
:
ÙÙa b
true
ÙÙc g
)
ÙÙg h
,
ÙÙh i
	UpdatedBy
ıı 
=
ıı 
table
ıı  %
.
ıı% &
Column
ıı& ,
<
ıı, -
string
ıı- 3
>
ıı3 4
(
ıı4 5
type
ıı5 9
:
ıı9 :
$str
ıı; A
,
ııA B
nullable
ııC K
:
ııK L
true
ııM Q
)
ııQ R
,
ııR S
IsActive
ˆˆ 
=
ˆˆ 
table
ˆˆ $
.
ˆˆ$ %
Column
ˆˆ% +
<
ˆˆ+ ,
bool
ˆˆ, 0
>
ˆˆ0 1
(
ˆˆ1 2
type
ˆˆ2 6
:
ˆˆ6 7
$str
ˆˆ8 A
,
ˆˆA B
nullable
ˆˆC K
:
ˆˆK L
false
ˆˆM R
)
ˆˆR S
,
ˆˆS T
	IsDeleted
˜˜ 
=
˜˜ 
table
˜˜  %
.
˜˜% &
Column
˜˜& ,
<
˜˜, -
bool
˜˜- 1
>
˜˜1 2
(
˜˜2 3
type
˜˜3 7
:
˜˜7 8
$str
˜˜9 B
,
˜˜B C
nullable
˜˜D L
:
˜˜L M
false
˜˜N S
)
˜˜S T
,
˜˜T U
	DeletedAt
¯¯ 
=
¯¯ 
table
¯¯  %
.
¯¯% &
Column
¯¯& ,
<
¯¯, -
DateTime
¯¯- 5
>
¯¯5 6
(
¯¯6 7
type
¯¯7 ;
:
¯¯; <
$str
¯¯= W
,
¯¯W X
nullable
¯¯Y a
:
¯¯a b
true
¯¯c g
)
¯¯g h
}
˘˘ 
,
˘˘ 
constraints
˙˙ 
:
˙˙ 
table
˙˙ "
=>
˙˙# %
{
˚˚ 
table
¸¸ 
.
¸¸ 

PrimaryKey
¸¸ $
(
¸¸$ %
$str
¸¸% 3
,
¸¸3 4
x
¸¸5 6
=>
¸¸7 9
x
¸¸: ;
.
¸¸; <
Id
¸¸< >
)
¸¸> ?
;
¸¸? @
}
˝˝ 
)
˝˝ 
;
˝˝ 
migrationBuilder
ˇˇ 
.
ˇˇ 
CreateTable
ˇˇ (
(
ˇˇ( )
name
ÄÄ 
:
ÄÄ 
$str
ÄÄ 
,
ÄÄ 
columns
ÅÅ 
:
ÅÅ 
table
ÅÅ 
=>
ÅÅ !
new
ÅÅ" %
{
ÇÇ 
Id
ÉÉ 
=
ÉÉ 
table
ÉÉ 
.
ÉÉ 
Column
ÉÉ %
<
ÉÉ% &
int
ÉÉ& )
>
ÉÉ) *
(
ÉÉ* +
type
ÉÉ+ /
:
ÉÉ/ 0
$str
ÉÉ1 :
,
ÉÉ: ;
nullable
ÉÉ< D
:
ÉÉD E
false
ÉÉF K
)
ÉÉK L
.
ÑÑ 

Annotation
ÑÑ #
(
ÑÑ# $
$str
ÑÑ$ D
,
ÑÑD E+
NpgsqlValueGenerationStrategy
ÑÑF c
.
ÑÑc d%
IdentityByDefaultColumn
ÑÑd {
)
ÑÑ{ |
,
ÑÑ| }
Name
ÖÖ 
=
ÖÖ 
table
ÖÖ  
.
ÖÖ  !
Column
ÖÖ! '
<
ÖÖ' (
string
ÖÖ( .
>
ÖÖ. /
(
ÖÖ/ 0
type
ÖÖ0 4
:
ÖÖ4 5
$str
ÖÖ6 <
,
ÖÖ< =
nullable
ÖÖ> F
:
ÖÖF G
false
ÖÖH M
)
ÖÖM N
,
ÖÖN O
DepartmentId
ÜÜ  
=
ÜÜ! "
table
ÜÜ# (
.
ÜÜ( )
Column
ÜÜ) /
<
ÜÜ/ 0
int
ÜÜ0 3
>
ÜÜ3 4
(
ÜÜ4 5
type
ÜÜ5 9
:
ÜÜ9 :
$str
ÜÜ; D
,
ÜÜD E
nullable
ÜÜF N
:
ÜÜN O
true
ÜÜP T
)
ÜÜT U
,
ÜÜU V
	CreatedAt
áá 
=
áá 
table
áá  %
.
áá% &
Column
áá& ,
<
áá, -
DateTime
áá- 5
>
áá5 6
(
áá6 7
type
áá7 ;
:
áá; <
$str
áá= W
,
ááW X
nullable
ááY a
:
ááa b
false
áác h
)
ááh i
,
áái j
	CreatedBy
àà 
=
àà 
table
àà  %
.
àà% &
Column
àà& ,
<
àà, -
string
àà- 3
>
àà3 4
(
àà4 5
type
àà5 9
:
àà9 :
$str
àà; A
,
ààA B
nullable
ààC K
:
ààK L
true
ààM Q
)
ààQ R
,
ààR S
	UpdatedAt
ââ 
=
ââ 
table
ââ  %
.
ââ% &
Column
ââ& ,
<
ââ, -
DateTime
ââ- 5
>
ââ5 6
(
ââ6 7
type
ââ7 ;
:
ââ; <
$str
ââ= W
,
ââW X
nullable
ââY a
:
ââa b
true
ââc g
)
ââg h
,
ââh i
	UpdatedBy
ää 
=
ää 
table
ää  %
.
ää% &
Column
ää& ,
<
ää, -
string
ää- 3
>
ää3 4
(
ää4 5
type
ää5 9
:
ää9 :
$str
ää; A
,
ääA B
nullable
ääC K
:
ääK L
true
ääM Q
)
ääQ R
,
ääR S
IsActive
ãã 
=
ãã 
table
ãã $
.
ãã$ %
Column
ãã% +
<
ãã+ ,
bool
ãã, 0
>
ãã0 1
(
ãã1 2
type
ãã2 6
:
ãã6 7
$str
ãã8 A
,
ããA B
nullable
ããC K
:
ããK L
false
ããM R
)
ããR S
,
ããS T
	IsDeleted
åå 
=
åå 
table
åå  %
.
åå% &
Column
åå& ,
<
åå, -
bool
åå- 1
>
åå1 2
(
åå2 3
type
åå3 7
:
åå7 8
$str
åå9 B
,
ååB C
nullable
ååD L
:
ååL M
false
ååN S
)
ååS T
,
ååT U
	DeletedAt
çç 
=
çç 
table
çç  %
.
çç% &
Column
çç& ,
<
çç, -
DateTime
çç- 5
>
çç5 6
(
çç6 7
type
çç7 ;
:
çç; <
$str
çç= W
,
ççW X
nullable
ççY a
:
çça b
true
ççc g
)
ççg h
}
éé 
,
éé 
constraints
èè 
:
èè 
table
èè "
=>
èè# %
{
êê 
table
ëë 
.
ëë 

PrimaryKey
ëë $
(
ëë$ %
$str
ëë% 0
,
ëë0 1
x
ëë2 3
=>
ëë4 6
x
ëë7 8
.
ëë8 9
Id
ëë9 ;
)
ëë; <
;
ëë< =
table
íí 
.
íí 

ForeignKey
íí $
(
íí$ %
name
ìì 
:
ìì 
$str
ìì B
,
ììB C
column
îî 
:
îî 
x
îî  !
=>
îî" $
x
îî% &
.
îî& '
DepartmentId
îî' 3
,
îî3 4
principalTable
ïï &
:
ïï& '
$str
ïï( 5
,
ïï5 6
principalColumn
ññ '
:
ññ' (
$str
ññ) -
)
ññ- .
;
ññ. /
}
óó 
)
óó 
;
óó 
migrationBuilder
ôô 
.
ôô 
CreateTable
ôô (
(
ôô( )
name
öö 
:
öö 
$str
öö 
,
öö 
columns
õõ 
:
õõ 
table
õõ 
=>
õõ !
new
õõ" %
{
úú 
Id
ùù 
=
ùù 
table
ùù 
.
ùù 
Column
ùù %
<
ùù% &
int
ùù& )
>
ùù) *
(
ùù* +
type
ùù+ /
:
ùù/ 0
$str
ùù1 :
,
ùù: ;
nullable
ùù< D
:
ùùD E
false
ùùF K
)
ùùK L
.
ûû 

Annotation
ûû #
(
ûû# $
$str
ûû$ D
,
ûûD E+
NpgsqlValueGenerationStrategy
ûûF c
.
ûûc d%
IdentityByDefaultColumn
ûûd {
)
ûû{ |
,
ûû| }
Username
üü 
=
üü 
table
üü $
.
üü$ %
Column
üü% +
<
üü+ ,
string
üü, 2
>
üü2 3
(
üü3 4
type
üü4 8
:
üü8 9
$str
üü: @
,
üü@ A
nullable
üüB J
:
üüJ K
false
üüL Q
)
üüQ R
,
üüR S
Email
†† 
=
†† 
table
†† !
.
††! "
Column
††" (
<
††( )
string
††) /
>
††/ 0
(
††0 1
type
††1 5
:
††5 6
$str
††7 =
,
††= >
nullable
††? G
:
††G H
false
††I N
)
††N O
,
††O P
PasswordHash
°°  
=
°°! "
table
°°# (
.
°°( )
Column
°°) /
<
°°/ 0
string
°°0 6
>
°°6 7
(
°°7 8
type
°°8 <
:
°°< =
$str
°°> D
,
°°D E
nullable
°°F N
:
°°N O
false
°°P U
)
°°U V
,
°°V W
	FirstName
¢¢ 
=
¢¢ 
table
¢¢  %
.
¢¢% &
Column
¢¢& ,
<
¢¢, -
string
¢¢- 3
>
¢¢3 4
(
¢¢4 5
type
¢¢5 9
:
¢¢9 :
$str
¢¢; A
,
¢¢A B
nullable
¢¢C K
:
¢¢K L
false
¢¢M R
)
¢¢R S
,
¢¢S T
LastName
££ 
=
££ 
table
££ $
.
££$ %
Column
££% +
<
££+ ,
string
££, 2
>
££2 3
(
££3 4
type
££4 8
:
££8 9
$str
££: @
,
££@ A
nullable
££B J
:
££J K
false
££L Q
)
££Q R
,
££R S
DepartmentId
§§  
=
§§! "
table
§§# (
.
§§( )
Column
§§) /
<
§§/ 0
int
§§0 3
>
§§3 4
(
§§4 5
type
§§5 9
:
§§9 :
$str
§§; D
,
§§D E
nullable
§§F N
:
§§N O
true
§§P T
)
§§T U
,
§§U V
	CreatedAt
•• 
=
•• 
table
••  %
.
••% &
Column
••& ,
<
••, -
DateTime
••- 5
>
••5 6
(
••6 7
type
••7 ;
:
••; <
$str
••= W
,
••W X
nullable
••Y a
:
••a b
false
••c h
)
••h i
,
••i j
	CreatedBy
¶¶ 
=
¶¶ 
table
¶¶  %
.
¶¶% &
Column
¶¶& ,
<
¶¶, -
string
¶¶- 3
>
¶¶3 4
(
¶¶4 5
type
¶¶5 9
:
¶¶9 :
$str
¶¶; A
,
¶¶A B
nullable
¶¶C K
:
¶¶K L
true
¶¶M Q
)
¶¶Q R
,
¶¶R S
	UpdatedAt
ßß 
=
ßß 
table
ßß  %
.
ßß% &
Column
ßß& ,
<
ßß, -
DateTime
ßß- 5
>
ßß5 6
(
ßß6 7
type
ßß7 ;
:
ßß; <
$str
ßß= W
,
ßßW X
nullable
ßßY a
:
ßßa b
true
ßßc g
)
ßßg h
,
ßßh i
	UpdatedBy
®® 
=
®® 
table
®®  %
.
®®% &
Column
®®& ,
<
®®, -
string
®®- 3
>
®®3 4
(
®®4 5
type
®®5 9
:
®®9 :
$str
®®; A
,
®®A B
nullable
®®C K
:
®®K L
true
®®M Q
)
®®Q R
,
®®R S
IsActive
©© 
=
©© 
table
©© $
.
©©$ %
Column
©©% +
<
©©+ ,
bool
©©, 0
>
©©0 1
(
©©1 2
type
©©2 6
:
©©6 7
$str
©©8 A
,
©©A B
nullable
©©C K
:
©©K L
false
©©M R
)
©©R S
,
©©S T
	IsDeleted
™™ 
=
™™ 
table
™™  %
.
™™% &
Column
™™& ,
<
™™, -
bool
™™- 1
>
™™1 2
(
™™2 3
type
™™3 7
:
™™7 8
$str
™™9 B
,
™™B C
nullable
™™D L
:
™™L M
false
™™N S
)
™™S T
,
™™T U
	DeletedAt
´´ 
=
´´ 
table
´´  %
.
´´% &
Column
´´& ,
<
´´, -
DateTime
´´- 5
>
´´5 6
(
´´6 7
type
´´7 ;
:
´´; <
$str
´´= W
,
´´W X
nullable
´´Y a
:
´´a b
true
´´c g
)
´´g h
}
¨¨ 
,
¨¨ 
constraints
≠≠ 
:
≠≠ 
table
≠≠ "
=>
≠≠# %
{
ÆÆ 
table
ØØ 
.
ØØ 

PrimaryKey
ØØ $
(
ØØ$ %
$str
ØØ% /
,
ØØ/ 0
x
ØØ1 2
=>
ØØ3 5
x
ØØ6 7
.
ØØ7 8
Id
ØØ8 :
)
ØØ: ;
;
ØØ; <
table
∞∞ 
.
∞∞ 

ForeignKey
∞∞ $
(
∞∞$ %
name
±± 
:
±± 
$str
±± A
,
±±A B
column
≤≤ 
:
≤≤ 
x
≤≤  !
=>
≤≤" $
x
≤≤% &
.
≤≤& '
DepartmentId
≤≤' 3
,
≤≤3 4
principalTable
≥≥ &
:
≥≥& '
$str
≥≥( 5
,
≥≥5 6
principalColumn
¥¥ '
:
¥¥' (
$str
¥¥) -
)
¥¥- .
;
¥¥. /
}
µµ 
)
µµ 
;
µµ 
migrationBuilder
∑∑ 
.
∑∑ 
CreateTable
∑∑ (
(
∑∑( )
name
∏∏ 
:
∏∏ 
$str
∏∏ $
,
∏∏$ %
columns
ππ 
:
ππ 
table
ππ 
=>
ππ !
new
ππ" %
{
∫∫ 
Id
ªª 
=
ªª 
table
ªª 
.
ªª 
Column
ªª %
<
ªª% &
int
ªª& )
>
ªª) *
(
ªª* +
type
ªª+ /
:
ªª/ 0
$str
ªª1 :
,
ªª: ;
nullable
ªª< D
:
ªªD E
false
ªªF K
)
ªªK L
.
ºº 

Annotation
ºº #
(
ºº# $
$str
ºº$ D
,
ººD E+
NpgsqlValueGenerationStrategy
ººF c
.
ººc d%
IdentityByDefaultColumn
ººd {
)
ºº{ |
,
ºº| }
FieldDefinitionId
ΩΩ %
=
ΩΩ& '
table
ΩΩ( -
.
ΩΩ- .
Column
ΩΩ. 4
<
ΩΩ4 5
int
ΩΩ5 8
>
ΩΩ8 9
(
ΩΩ9 :
type
ΩΩ: >
:
ΩΩ> ?
$str
ΩΩ@ I
,
ΩΩI J
nullable
ΩΩK S
:
ΩΩS T
false
ΩΩU Z
)
ΩΩZ [
,
ΩΩ[ \
Value
ææ 
=
ææ 
table
ææ !
.
ææ! "
Column
ææ" (
<
ææ( )
string
ææ) /
>
ææ/ 0
(
ææ0 1
type
ææ1 5
:
ææ5 6
$str
ææ7 =
,
ææ= >
nullable
ææ? G
:
ææG H
false
ææI N
)
ææN O
,
ææO P
Label
øø 
=
øø 
table
øø !
.
øø! "
Column
øø" (
<
øø( )
string
øø) /
>
øø/ 0
(
øø0 1
type
øø1 5
:
øø5 6
$str
øø7 =
,
øø= >
nullable
øø? G
:
øøG H
false
øøI N
)
øøN O
,
øøO P
	SortOrder
¿¿ 
=
¿¿ 
table
¿¿  %
.
¿¿% &
Column
¿¿& ,
<
¿¿, -
int
¿¿- 0
>
¿¿0 1
(
¿¿1 2
type
¿¿2 6
:
¿¿6 7
$str
¿¿8 A
,
¿¿A B
nullable
¿¿C K
:
¿¿K L
false
¿¿M R
)
¿¿R S
,
¿¿S T
	CreatedAt
¡¡ 
=
¡¡ 
table
¡¡  %
.
¡¡% &
Column
¡¡& ,
<
¡¡, -
DateTime
¡¡- 5
>
¡¡5 6
(
¡¡6 7
type
¡¡7 ;
:
¡¡; <
$str
¡¡= W
,
¡¡W X
nullable
¡¡Y a
:
¡¡a b
false
¡¡c h
)
¡¡h i
,
¡¡i j
	CreatedBy
¬¬ 
=
¬¬ 
table
¬¬  %
.
¬¬% &
Column
¬¬& ,
<
¬¬, -
string
¬¬- 3
>
¬¬3 4
(
¬¬4 5
type
¬¬5 9
:
¬¬9 :
$str
¬¬; A
,
¬¬A B
nullable
¬¬C K
:
¬¬K L
true
¬¬M Q
)
¬¬Q R
,
¬¬R S
	UpdatedAt
√√ 
=
√√ 
table
√√  %
.
√√% &
Column
√√& ,
<
√√, -
DateTime
√√- 5
>
√√5 6
(
√√6 7
type
√√7 ;
:
√√; <
$str
√√= W
,
√√W X
nullable
√√Y a
:
√√a b
true
√√c g
)
√√g h
,
√√h i
	UpdatedBy
ƒƒ 
=
ƒƒ 
table
ƒƒ  %
.
ƒƒ% &
Column
ƒƒ& ,
<
ƒƒ, -
string
ƒƒ- 3
>
ƒƒ3 4
(
ƒƒ4 5
type
ƒƒ5 9
:
ƒƒ9 :
$str
ƒƒ; A
,
ƒƒA B
nullable
ƒƒC K
:
ƒƒK L
true
ƒƒM Q
)
ƒƒQ R
,
ƒƒR S
IsActive
≈≈ 
=
≈≈ 
table
≈≈ $
.
≈≈$ %
Column
≈≈% +
<
≈≈+ ,
bool
≈≈, 0
>
≈≈0 1
(
≈≈1 2
type
≈≈2 6
:
≈≈6 7
$str
≈≈8 A
,
≈≈A B
nullable
≈≈C K
:
≈≈K L
false
≈≈M R
)
≈≈R S
,
≈≈S T
	IsDeleted
∆∆ 
=
∆∆ 
table
∆∆  %
.
∆∆% &
Column
∆∆& ,
<
∆∆, -
bool
∆∆- 1
>
∆∆1 2
(
∆∆2 3
type
∆∆3 7
:
∆∆7 8
$str
∆∆9 B
,
∆∆B C
nullable
∆∆D L
:
∆∆L M
false
∆∆N S
)
∆∆S T
,
∆∆T U
	DeletedAt
«« 
=
«« 
table
««  %
.
««% &
Column
««& ,
<
««, -
DateTime
««- 5
>
««5 6
(
««6 7
type
««7 ;
:
««; <
$str
««= W
,
««W X
nullable
««Y a
:
««a b
true
««c g
)
««g h
}
»» 
,
»» 
constraints
…… 
:
…… 
table
…… "
=>
……# %
{
   
table
ÀÀ 
.
ÀÀ 

PrimaryKey
ÀÀ $
(
ÀÀ$ %
$str
ÀÀ% 6
,
ÀÀ6 7
x
ÀÀ8 9
=>
ÀÀ: <
x
ÀÀ= >
.
ÀÀ> ?
Id
ÀÀ? A
)
ÀÀA B
;
ÀÀB C
table
ÃÃ 
.
ÃÃ 

ForeignKey
ÃÃ $
(
ÃÃ$ %
name
ÕÕ 
:
ÕÕ 
$str
ÕÕ R
,
ÕÕR S
column
ŒŒ 
:
ŒŒ 
x
ŒŒ  !
=>
ŒŒ" $
x
ŒŒ% &
.
ŒŒ& '
FieldDefinitionId
ŒŒ' 8
,
ŒŒ8 9
principalTable
œœ &
:
œœ& '
$str
œœ( :
,
œœ: ;
principalColumn
–– '
:
––' (
$str
––) -
,
––- .
onDelete
——  
:
——  !
ReferentialAction
——" 3
.
——3 4
Cascade
——4 ;
)
——; <
;
——< =
}
““ 
)
““ 
;
““ 
migrationBuilder
‘‘ 
.
‘‘ 
CreateTable
‘‘ (
(
‘‘( )
name
’’ 
:
’’ 
$str
’’ +
,
’’+ ,
columns
÷÷ 
:
÷÷ 
table
÷÷ 
=>
÷÷ !
new
÷÷" %
{
◊◊ 
Id
ÿÿ 
=
ÿÿ 
table
ÿÿ 
.
ÿÿ 
Column
ÿÿ %
<
ÿÿ% &
int
ÿÿ& )
>
ÿÿ) *
(
ÿÿ* +
type
ÿÿ+ /
:
ÿÿ/ 0
$str
ÿÿ1 :
,
ÿÿ: ;
nullable
ÿÿ< D
:
ÿÿD E
false
ÿÿF K
)
ÿÿK L
.
ŸŸ 

Annotation
ŸŸ #
(
ŸŸ# $
$str
ŸŸ$ D
,
ŸŸD E+
NpgsqlValueGenerationStrategy
ŸŸF c
.
ŸŸc d%
IdentityByDefaultColumn
ŸŸd {
)
ŸŸ{ |
,
ŸŸ| }
	ProjectId
⁄⁄ 
=
⁄⁄ 
table
⁄⁄  %
.
⁄⁄% &
Column
⁄⁄& ,
<
⁄⁄, -
int
⁄⁄- 0
>
⁄⁄0 1
(
⁄⁄1 2
type
⁄⁄2 6
:
⁄⁄6 7
$str
⁄⁄8 A
,
⁄⁄A B
nullable
⁄⁄C K
:
⁄⁄K L
true
⁄⁄M Q
)
⁄⁄Q R
,
⁄⁄R S

CategoryId
€€ 
=
€€  
table
€€! &
.
€€& '
Column
€€' -
<
€€- .
int
€€. 1
>
€€1 2
(
€€2 3
type
€€3 7
:
€€7 8
$str
€€9 B
,
€€B C
nullable
€€D L
:
€€L M
true
€€N R
)
€€R S
,
€€S T
TicketTypeId
‹‹  
=
‹‹! "
table
‹‹# (
.
‹‹( )
Column
‹‹) /
<
‹‹/ 0
int
‹‹0 3
>
‹‹3 4
(
‹‹4 5
type
‹‹5 9
:
‹‹9 :
$str
‹‹; D
,
‹‹D E
nullable
‹‹F N
:
‹‹N O
true
‹‹P T
)
‹‹T U
,
‹‹U V
FieldDefinitionId
›› %
=
››& '
table
››( -
.
››- .
Column
››. 4
<
››4 5
int
››5 8
>
››8 9
(
››9 :
type
››: >
:
››> ?
$str
››@ I
,
››I J
nullable
››K S
:
››S T
false
››U Z
)
››Z [
,
››[ \
	SortOrder
ﬁﬁ 
=
ﬁﬁ 
table
ﬁﬁ  %
.
ﬁﬁ% &
Column
ﬁﬁ& ,
<
ﬁﬁ, -
int
ﬁﬁ- 0
>
ﬁﬁ0 1
(
ﬁﬁ1 2
type
ﬁﬁ2 6
:
ﬁﬁ6 7
$str
ﬁﬁ8 A
,
ﬁﬁA B
nullable
ﬁﬁC K
:
ﬁﬁK L
false
ﬁﬁM R
)
ﬁﬁR S
,
ﬁﬁS T

IsRequired
ﬂﬂ 
=
ﬂﬂ  
table
ﬂﬂ! &
.
ﬂﬂ& '
Column
ﬂﬂ' -
<
ﬂﬂ- .
bool
ﬂﬂ. 2
>
ﬂﬂ2 3
(
ﬂﬂ3 4
type
ﬂﬂ4 8
:
ﬂﬂ8 9
$str
ﬂﬂ: C
,
ﬂﬂC D
nullable
ﬂﬂE M
:
ﬂﬂM N
false
ﬂﬂO T
)
ﬂﬂT U
,
ﬂﬂU V
	CreatedAt
‡‡ 
=
‡‡ 
table
‡‡  %
.
‡‡% &
Column
‡‡& ,
<
‡‡, -
DateTime
‡‡- 5
>
‡‡5 6
(
‡‡6 7
type
‡‡7 ;
:
‡‡; <
$str
‡‡= W
,
‡‡W X
nullable
‡‡Y a
:
‡‡a b
false
‡‡c h
)
‡‡h i
,
‡‡i j
	CreatedBy
·· 
=
·· 
table
··  %
.
··% &
Column
··& ,
<
··, -
string
··- 3
>
··3 4
(
··4 5
type
··5 9
:
··9 :
$str
··; A
,
··A B
nullable
··C K
:
··K L
true
··M Q
)
··Q R
,
··R S
	UpdatedAt
‚‚ 
=
‚‚ 
table
‚‚  %
.
‚‚% &
Column
‚‚& ,
<
‚‚, -
DateTime
‚‚- 5
>
‚‚5 6
(
‚‚6 7
type
‚‚7 ;
:
‚‚; <
$str
‚‚= W
,
‚‚W X
nullable
‚‚Y a
:
‚‚a b
true
‚‚c g
)
‚‚g h
,
‚‚h i
	UpdatedBy
„„ 
=
„„ 
table
„„  %
.
„„% &
Column
„„& ,
<
„„, -
string
„„- 3
>
„„3 4
(
„„4 5
type
„„5 9
:
„„9 :
$str
„„; A
,
„„A B
nullable
„„C K
:
„„K L
true
„„M Q
)
„„Q R
,
„„R S
IsActive
‰‰ 
=
‰‰ 
table
‰‰ $
.
‰‰$ %
Column
‰‰% +
<
‰‰+ ,
bool
‰‰, 0
>
‰‰0 1
(
‰‰1 2
type
‰‰2 6
:
‰‰6 7
$str
‰‰8 A
,
‰‰A B
nullable
‰‰C K
:
‰‰K L
false
‰‰M R
)
‰‰R S
,
‰‰S T
	IsDeleted
ÂÂ 
=
ÂÂ 
table
ÂÂ  %
.
ÂÂ% &
Column
ÂÂ& ,
<
ÂÂ, -
bool
ÂÂ- 1
>
ÂÂ1 2
(
ÂÂ2 3
type
ÂÂ3 7
:
ÂÂ7 8
$str
ÂÂ9 B
,
ÂÂB C
nullable
ÂÂD L
:
ÂÂL M
false
ÂÂN S
)
ÂÂS T
,
ÂÂT U
	DeletedAt
ÊÊ 
=
ÊÊ 
table
ÊÊ  %
.
ÊÊ% &
Column
ÊÊ& ,
<
ÊÊ, -
DateTime
ÊÊ- 5
>
ÊÊ5 6
(
ÊÊ6 7
type
ÊÊ7 ;
:
ÊÊ; <
$str
ÊÊ= W
,
ÊÊW X
nullable
ÊÊY a
:
ÊÊa b
true
ÊÊc g
)
ÊÊg h
}
ÁÁ 
,
ÁÁ 
constraints
ËË 
:
ËË 
table
ËË "
=>
ËË# %
{
ÈÈ 
table
ÍÍ 
.
ÍÍ 

PrimaryKey
ÍÍ $
(
ÍÍ$ %
$str
ÍÍ% =
,
ÍÍ= >
x
ÍÍ? @
=>
ÍÍA C
x
ÍÍD E
.
ÍÍE F
Id
ÍÍF H
)
ÍÍH I
;
ÍÍI J
table
ÎÎ 
.
ÎÎ 

ForeignKey
ÎÎ $
(
ÎÎ$ %
name
ÏÏ 
:
ÏÏ 
$str
ÏÏ Y
,
ÏÏY Z
column
ÌÌ 
:
ÌÌ 
x
ÌÌ  !
=>
ÌÌ" $
x
ÌÌ% &
.
ÌÌ& '
FieldDefinitionId
ÌÌ' 8
,
ÌÌ8 9
principalTable
ÓÓ &
:
ÓÓ& '
$str
ÓÓ( :
,
ÓÓ: ;
principalColumn
ÔÔ '
:
ÔÔ' (
$str
ÔÔ) -
,
ÔÔ- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
}
ÒÒ 
)
ÒÒ 
;
ÒÒ 
migrationBuilder
ÛÛ 
.
ÛÛ 
CreateTable
ÛÛ (
(
ÛÛ( )
name
ÙÙ 
:
ÙÙ 
$str
ÙÙ )
,
ÙÙ) *
columns
ıı 
:
ıı 
table
ıı 
=>
ıı !
new
ıı" %
{
ˆˆ 
Id
˜˜ 
=
˜˜ 
table
˜˜ 
.
˜˜ 
Column
˜˜ %
<
˜˜% &
int
˜˜& )
>
˜˜) *
(
˜˜* +
type
˜˜+ /
:
˜˜/ 0
$str
˜˜1 :
,
˜˜: ;
nullable
˜˜< D
:
˜˜D E
false
˜˜F K
)
˜˜K L
.
¯¯ 

Annotation
¯¯ #
(
¯¯# $
$str
¯¯$ D
,
¯¯D E+
NpgsqlValueGenerationStrategy
¯¯F c
.
¯¯c d%
IdentityByDefaultColumn
¯¯d {
)
¯¯{ |
,
¯¯| }

CategoryId
˘˘ 
=
˘˘  
table
˘˘! &
.
˘˘& '
Column
˘˘' -
<
˘˘- .
int
˘˘. 1
>
˘˘1 2
(
˘˘2 3
type
˘˘3 7
:
˘˘7 8
$str
˘˘9 B
,
˘˘B C
nullable
˘˘D L
:
˘˘L M
false
˘˘N S
)
˘˘S T
,
˘˘T U
Title
˙˙ 
=
˙˙ 
table
˙˙ !
.
˙˙! "
Column
˙˙" (
<
˙˙( )
string
˙˙) /
>
˙˙/ 0
(
˙˙0 1
type
˙˙1 5
:
˙˙5 6
$str
˙˙7 =
,
˙˙= >
nullable
˙˙? G
:
˙˙G H
false
˙˙I N
)
˙˙N O
,
˙˙O P
Content
˚˚ 
=
˚˚ 
table
˚˚ #
.
˚˚# $
Column
˚˚$ *
<
˚˚* +
string
˚˚+ 1
>
˚˚1 2
(
˚˚2 3
type
˚˚3 7
:
˚˚7 8
$str
˚˚9 ?
,
˚˚? @
nullable
˚˚A I
:
˚˚I J
false
˚˚K P
)
˚˚P Q
,
˚˚Q R
AuthorUserId
¸¸  
=
¸¸! "
table
¸¸# (
.
¸¸( )
Column
¸¸) /
<
¸¸/ 0
int
¸¸0 3
>
¸¸3 4
(
¸¸4 5
type
¸¸5 9
:
¸¸9 :
$str
¸¸; D
,
¸¸D E
nullable
¸¸F N
:
¸¸N O
false
¸¸P U
)
¸¸U V
,
¸¸V W
Status
˝˝ 
=
˝˝ 
table
˝˝ "
.
˝˝" #
Column
˝˝# )
<
˝˝) *
int
˝˝* -
>
˝˝- .
(
˝˝. /
type
˝˝/ 3
:
˝˝3 4
$str
˝˝5 >
,
˝˝> ?
nullable
˝˝@ H
:
˝˝H I
false
˝˝J O
)
˝˝O P
,
˝˝P Q
	ViewCount
˛˛ 
=
˛˛ 
table
˛˛  %
.
˛˛% &
Column
˛˛& ,
<
˛˛, -
int
˛˛- 0
>
˛˛0 1
(
˛˛1 2
type
˛˛2 6
:
˛˛6 7
$str
˛˛8 A
,
˛˛A B
nullable
˛˛C K
:
˛˛K L
false
˛˛M R
)
˛˛R S
,
˛˛S T
	CreatedAt
ˇˇ 
=
ˇˇ 
table
ˇˇ  %
.
ˇˇ% &
Column
ˇˇ& ,
<
ˇˇ, -
DateTime
ˇˇ- 5
>
ˇˇ5 6
(
ˇˇ6 7
type
ˇˇ7 ;
:
ˇˇ; <
$str
ˇˇ= W
,
ˇˇW X
nullable
ˇˇY a
:
ˇˇa b
false
ˇˇc h
)
ˇˇh i
,
ˇˇi j
	CreatedBy
ÄÄ 
=
ÄÄ 
table
ÄÄ  %
.
ÄÄ% &
Column
ÄÄ& ,
<
ÄÄ, -
string
ÄÄ- 3
>
ÄÄ3 4
(
ÄÄ4 5
type
ÄÄ5 9
:
ÄÄ9 :
$str
ÄÄ; A
,
ÄÄA B
nullable
ÄÄC K
:
ÄÄK L
true
ÄÄM Q
)
ÄÄQ R
,
ÄÄR S
	UpdatedAt
ÅÅ 
=
ÅÅ 
table
ÅÅ  %
.
ÅÅ% &
Column
ÅÅ& ,
<
ÅÅ, -
DateTime
ÅÅ- 5
>
ÅÅ5 6
(
ÅÅ6 7
type
ÅÅ7 ;
:
ÅÅ; <
$str
ÅÅ= W
,
ÅÅW X
nullable
ÅÅY a
:
ÅÅa b
true
ÅÅc g
)
ÅÅg h
,
ÅÅh i
	UpdatedBy
ÇÇ 
=
ÇÇ 
table
ÇÇ  %
.
ÇÇ% &
Column
ÇÇ& ,
<
ÇÇ, -
string
ÇÇ- 3
>
ÇÇ3 4
(
ÇÇ4 5
type
ÇÇ5 9
:
ÇÇ9 :
$str
ÇÇ; A
,
ÇÇA B
nullable
ÇÇC K
:
ÇÇK L
true
ÇÇM Q
)
ÇÇQ R
,
ÇÇR S
IsActive
ÉÉ 
=
ÉÉ 
table
ÉÉ $
.
ÉÉ$ %
Column
ÉÉ% +
<
ÉÉ+ ,
bool
ÉÉ, 0
>
ÉÉ0 1
(
ÉÉ1 2
type
ÉÉ2 6
:
ÉÉ6 7
$str
ÉÉ8 A
,
ÉÉA B
nullable
ÉÉC K
:
ÉÉK L
false
ÉÉM R
)
ÉÉR S
,
ÉÉS T
	IsDeleted
ÑÑ 
=
ÑÑ 
table
ÑÑ  %
.
ÑÑ% &
Column
ÑÑ& ,
<
ÑÑ, -
bool
ÑÑ- 1
>
ÑÑ1 2
(
ÑÑ2 3
type
ÑÑ3 7
:
ÑÑ7 8
$str
ÑÑ9 B
,
ÑÑB C
nullable
ÑÑD L
:
ÑÑL M
false
ÑÑN S
)
ÑÑS T
,
ÑÑT U
	DeletedAt
ÖÖ 
=
ÖÖ 
table
ÖÖ  %
.
ÖÖ% &
Column
ÖÖ& ,
<
ÖÖ, -
DateTime
ÖÖ- 5
>
ÖÖ5 6
(
ÖÖ6 7
type
ÖÖ7 ;
:
ÖÖ; <
$str
ÖÖ= W
,
ÖÖW X
nullable
ÖÖY a
:
ÖÖa b
true
ÖÖc g
)
ÖÖg h
}
ÜÜ 
,
ÜÜ 
constraints
áá 
:
áá 
table
áá "
=>
áá# %
{
àà 
table
ââ 
.
ââ 

PrimaryKey
ââ $
(
ââ$ %
$str
ââ% ;
,
ââ; <
x
ââ= >
=>
ââ? A
x
ââB C
.
ââC D
Id
ââD F
)
ââF G
;
ââG H
table
ää 
.
ää 

ForeignKey
ää $
(
ää$ %
name
ãã 
:
ãã 
$str
ãã S
,
ããS T
column
åå 
:
åå 
x
åå  !
=>
åå" $
x
åå% &
.
åå& '

CategoryId
åå' 1
,
åå1 2
principalTable
çç &
:
çç& '
$str
çç( =
,
çç= >
principalColumn
éé '
:
éé' (
$str
éé) -
,
éé- .
onDelete
èè  
:
èè  !
ReferentialAction
èè" 3
.
èè3 4
Cascade
èè4 ;
)
èè; <
;
èè< =
}
êê 
)
êê 
;
êê 
migrationBuilder
íí 
.
íí 
CreateTable
íí (
(
íí( )
name
ìì 
:
ìì 
$str
ìì '
,
ìì' (
columns
îî 
:
îî 
table
îî 
=>
îî !
new
îî" %
{
ïï 
Id
ññ 
=
ññ 
table
ññ 
.
ññ 
Column
ññ %
<
ññ% &
int
ññ& )
>
ññ) *
(
ññ* +
type
ññ+ /
:
ññ/ 0
$str
ññ1 :
,
ññ: ;
nullable
ññ< D
:
ññD E
false
ññF K
)
ññK L
.
óó 

Annotation
óó #
(
óó# $
$str
óó$ D
,
óóD E+
NpgsqlValueGenerationStrategy
óóF c
.
óóc d%
IdentityByDefaultColumn
óód {
)
óó{ |
,
óó| }
RoleId
òò 
=
òò 
table
òò "
.
òò" #
Column
òò# )
<
òò) *
int
òò* -
>
òò- .
(
òò. /
type
òò/ 3
:
òò3 4
$str
òò5 >
,
òò> ?
nullable
òò@ H
:
òòH I
false
òòJ O
)
òòO P
,
òòP Q
PermissionId
ôô  
=
ôô! "
table
ôô# (
.
ôô( )
Column
ôô) /
<
ôô/ 0
int
ôô0 3
>
ôô3 4
(
ôô4 5
type
ôô5 9
:
ôô9 :
$str
ôô; D
,
ôôD E
nullable
ôôF N
:
ôôN O
false
ôôP U
)
ôôU V
,
ôôV W
	CreatedAt
öö 
=
öö 
table
öö  %
.
öö% &
Column
öö& ,
<
öö, -
DateTime
öö- 5
>
öö5 6
(
öö6 7
type
öö7 ;
:
öö; <
$str
öö= W
,
ööW X
nullable
ööY a
:
ööa b
false
ööc h
)
ööh i
,
ööi j
	CreatedBy
õõ 
=
õõ 
table
õõ  %
.
õõ% &
Column
õõ& ,
<
õõ, -
string
õõ- 3
>
õõ3 4
(
õõ4 5
type
õõ5 9
:
õõ9 :
$str
õõ; A
,
õõA B
nullable
õõC K
:
õõK L
true
õõM Q
)
õõQ R
,
õõR S
	UpdatedAt
úú 
=
úú 
table
úú  %
.
úú% &
Column
úú& ,
<
úú, -
DateTime
úú- 5
>
úú5 6
(
úú6 7
type
úú7 ;
:
úú; <
$str
úú= W
,
úúW X
nullable
úúY a
:
úúa b
true
úúc g
)
úúg h
,
úúh i
	UpdatedBy
ùù 
=
ùù 
table
ùù  %
.
ùù% &
Column
ùù& ,
<
ùù, -
string
ùù- 3
>
ùù3 4
(
ùù4 5
type
ùù5 9
:
ùù9 :
$str
ùù; A
,
ùùA B
nullable
ùùC K
:
ùùK L
true
ùùM Q
)
ùùQ R
,
ùùR S
IsActive
ûû 
=
ûû 
table
ûû $
.
ûû$ %
Column
ûû% +
<
ûû+ ,
bool
ûû, 0
>
ûû0 1
(
ûû1 2
type
ûû2 6
:
ûû6 7
$str
ûû8 A
,
ûûA B
nullable
ûûC K
:
ûûK L
false
ûûM R
)
ûûR S
,
ûûS T
	IsDeleted
üü 
=
üü 
table
üü  %
.
üü% &
Column
üü& ,
<
üü, -
bool
üü- 1
>
üü1 2
(
üü2 3
type
üü3 7
:
üü7 8
$str
üü9 B
,
üüB C
nullable
üüD L
:
üüL M
false
üüN S
)
üüS T
,
üüT U
	DeletedAt
†† 
=
†† 
table
††  %
.
††% &
Column
††& ,
<
††, -
DateTime
††- 5
>
††5 6
(
††6 7
type
††7 ;
:
††; <
$str
††= W
,
††W X
nullable
††Y a
:
††a b
true
††c g
)
††g h
}
°° 
,
°° 
constraints
¢¢ 
:
¢¢ 
table
¢¢ "
=>
¢¢# %
{
££ 
table
§§ 
.
§§ 

PrimaryKey
§§ $
(
§§$ %
$str
§§% 9
,
§§9 :
x
§§; <
=>
§§= ?
x
§§@ A
.
§§A B
Id
§§B D
)
§§D E
;
§§E F
table
•• 
.
•• 

ForeignKey
•• $
(
••$ %
name
¶¶ 
:
¶¶ 
$str
¶¶ K
,
¶¶K L
column
ßß 
:
ßß 
x
ßß  !
=>
ßß" $
x
ßß% &
.
ßß& '
PermissionId
ßß' 3
,
ßß3 4
principalTable
®® &
:
®®& '
$str
®®( 5
,
®®5 6
principalColumn
©© '
:
©©' (
$str
©©) -
,
©©- .
onDelete
™™  
:
™™  !
ReferentialAction
™™" 3
.
™™3 4
Cascade
™™4 ;
)
™™; <
;
™™< =
table
´´ 
.
´´ 

ForeignKey
´´ $
(
´´$ %
name
¨¨ 
:
¨¨ 
$str
¨¨ ?
,
¨¨? @
column
≠≠ 
:
≠≠ 
x
≠≠  !
=>
≠≠" $
x
≠≠% &
.
≠≠& '
RoleId
≠≠' -
,
≠≠- .
principalTable
ÆÆ &
:
ÆÆ& '
$str
ÆÆ( /
,
ÆÆ/ 0
principalColumn
ØØ '
:
ØØ' (
$str
ØØ) -
,
ØØ- .
onDelete
∞∞  
:
∞∞  !
ReferentialAction
∞∞" 3
.
∞∞3 4
Cascade
∞∞4 ;
)
∞∞; <
;
∞∞< =
}
±± 
)
±± 
;
±± 
migrationBuilder
≥≥ 
.
≥≥ 
CreateTable
≥≥ (
(
≥≥( )
name
¥¥ 
:
¥¥ 
$str
¥¥ "
,
¥¥" #
columns
µµ 
:
µµ 
table
µµ 
=>
µµ !
new
µµ" %
{
∂∂ 
Id
∑∑ 
=
∑∑ 
table
∑∑ 
.
∑∑ 
Column
∑∑ %
<
∑∑% &
int
∑∑& )
>
∑∑) *
(
∑∑* +
type
∑∑+ /
:
∑∑/ 0
$str
∑∑1 :
,
∑∑: ;
nullable
∑∑< D
:
∑∑D E
false
∑∑F K
)
∑∑K L
.
∏∏ 

Annotation
∏∏ #
(
∏∏# $
$str
∏∏$ D
,
∏∏D E+
NpgsqlValueGenerationStrategy
∏∏F c
.
∏∏c d%
IdentityByDefaultColumn
∏∏d {
)
∏∏{ |
,
∏∏| }
SlaPolicyId
ππ 
=
ππ  !
table
ππ" '
.
ππ' (
Column
ππ( .
<
ππ. /
int
ππ/ 2
>
ππ2 3
(
ππ3 4
type
ππ4 8
:
ππ8 9
$str
ππ: C
,
ππC D
nullable
ππE M
:
ππM N
false
ππO T
)
ππT U
,
ππU V

PriorityId
∫∫ 
=
∫∫  
table
∫∫! &
.
∫∫& '
Column
∫∫' -
<
∫∫- .
int
∫∫. 1
>
∫∫1 2
(
∫∫2 3
type
∫∫3 7
:
∫∫7 8
$str
∫∫9 B
,
∫∫B C
nullable
∫∫D L
:
∫∫L M
false
∫∫N S
)
∫∫S T
,
∫∫T U
TicketTypeId
ªª  
=
ªª! "
table
ªª# (
.
ªª( )
Column
ªª) /
<
ªª/ 0
int
ªª0 3
>
ªª3 4
(
ªª4 5
type
ªª5 9
:
ªª9 :
$str
ªª; D
,
ªªD E
nullable
ªªF N
:
ªªN O
true
ªªP T
)
ªªT U
,
ªªU V"
FirstResponseMinutes
ºº (
=
ºº) *
table
ºº+ 0
.
ºº0 1
Column
ºº1 7
<
ºº7 8
int
ºº8 ;
>
ºº; <
(
ºº< =
type
ºº= A
:
ººA B
$str
ººC L
,
ººL M
nullable
ººN V
:
ººV W
false
ººX ]
)
ºº] ^
,
ºº^ _
ResolutionMinutes
ΩΩ %
=
ΩΩ& '
table
ΩΩ( -
.
ΩΩ- .
Column
ΩΩ. 4
<
ΩΩ4 5
int
ΩΩ5 8
>
ΩΩ8 9
(
ΩΩ9 :
type
ΩΩ: >
:
ΩΩ> ?
$str
ΩΩ@ I
,
ΩΩI J
nullable
ΩΩK S
:
ΩΩS T
false
ΩΩU Z
)
ΩΩZ [
,
ΩΩ[ \
	CreatedAt
ææ 
=
ææ 
table
ææ  %
.
ææ% &
Column
ææ& ,
<
ææ, -
DateTime
ææ- 5
>
ææ5 6
(
ææ6 7
type
ææ7 ;
:
ææ; <
$str
ææ= W
,
ææW X
nullable
ææY a
:
ææa b
false
ææc h
)
ææh i
,
ææi j
	CreatedBy
øø 
=
øø 
table
øø  %
.
øø% &
Column
øø& ,
<
øø, -
string
øø- 3
>
øø3 4
(
øø4 5
type
øø5 9
:
øø9 :
$str
øø; A
,
øøA B
nullable
øøC K
:
øøK L
true
øøM Q
)
øøQ R
,
øøR S
	UpdatedAt
¿¿ 
=
¿¿ 
table
¿¿  %
.
¿¿% &
Column
¿¿& ,
<
¿¿, -
DateTime
¿¿- 5
>
¿¿5 6
(
¿¿6 7
type
¿¿7 ;
:
¿¿; <
$str
¿¿= W
,
¿¿W X
nullable
¿¿Y a
:
¿¿a b
true
¿¿c g
)
¿¿g h
,
¿¿h i
	UpdatedBy
¡¡ 
=
¡¡ 
table
¡¡  %
.
¡¡% &
Column
¡¡& ,
<
¡¡, -
string
¡¡- 3
>
¡¡3 4
(
¡¡4 5
type
¡¡5 9
:
¡¡9 :
$str
¡¡; A
,
¡¡A B
nullable
¡¡C K
:
¡¡K L
true
¡¡M Q
)
¡¡Q R
,
¡¡R S
IsActive
¬¬ 
=
¬¬ 
table
¬¬ $
.
¬¬$ %
Column
¬¬% +
<
¬¬+ ,
bool
¬¬, 0
>
¬¬0 1
(
¬¬1 2
type
¬¬2 6
:
¬¬6 7
$str
¬¬8 A
,
¬¬A B
nullable
¬¬C K
:
¬¬K L
false
¬¬M R
)
¬¬R S
,
¬¬S T
	IsDeleted
√√ 
=
√√ 
table
√√  %
.
√√% &
Column
√√& ,
<
√√, -
bool
√√- 1
>
√√1 2
(
√√2 3
type
√√3 7
:
√√7 8
$str
√√9 B
,
√√B C
nullable
√√D L
:
√√L M
false
√√N S
)
√√S T
,
√√T U
	DeletedAt
ƒƒ 
=
ƒƒ 
table
ƒƒ  %
.
ƒƒ% &
Column
ƒƒ& ,
<
ƒƒ, -
DateTime
ƒƒ- 5
>
ƒƒ5 6
(
ƒƒ6 7
type
ƒƒ7 ;
:
ƒƒ; <
$str
ƒƒ= W
,
ƒƒW X
nullable
ƒƒY a
:
ƒƒa b
true
ƒƒc g
)
ƒƒg h
}
≈≈ 
,
≈≈ 
constraints
∆∆ 
:
∆∆ 
table
∆∆ "
=>
∆∆# %
{
«« 
table
»» 
.
»» 

PrimaryKey
»» $
(
»»$ %
$str
»»% 4
,
»»4 5
x
»»6 7
=>
»»8 :
x
»»; <
.
»»< =
Id
»»= ?
)
»»? @
;
»»@ A
table
…… 
.
…… 

ForeignKey
…… $
(
……$ %
name
   
:
   
$str
   E
,
  E F
column
ÀÀ 
:
ÀÀ 
x
ÀÀ  !
=>
ÀÀ" $
x
ÀÀ% &
.
ÀÀ& '
SlaPolicyId
ÀÀ' 2
,
ÀÀ2 3
principalTable
ÃÃ &
:
ÃÃ& '
$str
ÃÃ( 5
,
ÃÃ5 6
principalColumn
ÕÕ '
:
ÕÕ' (
$str
ÕÕ) -
,
ÕÕ- .
onDelete
ŒŒ  
:
ŒŒ  !
ReferentialAction
ŒŒ" 3
.
ŒŒ3 4
Cascade
ŒŒ4 ;
)
ŒŒ; <
;
ŒŒ< =
}
œœ 
)
œœ 
;
œœ 
migrationBuilder
—— 
.
—— 
CreateTable
—— (
(
——( )
name
““ 
:
““ 
$str
““ +
,
““+ ,
columns
”” 
:
”” 
table
”” 
=>
”” !
new
””" %
{
‘‘ 
Id
’’ 
=
’’ 
table
’’ 
.
’’ 
Column
’’ %
<
’’% &
int
’’& )
>
’’) *
(
’’* +
type
’’+ /
:
’’/ 0
$str
’’1 :
,
’’: ;
nullable
’’< D
:
’’D E
false
’’F K
)
’’K L
.
÷÷ 

Annotation
÷÷ #
(
÷÷# $
$str
÷÷$ D
,
÷÷D E+
NpgsqlValueGenerationStrategy
÷÷F c
.
÷÷c d%
IdentityByDefaultColumn
÷÷d {
)
÷÷{ |
,
÷÷| }

WorkflowId
◊◊ 
=
◊◊  
table
◊◊! &
.
◊◊& '
Column
◊◊' -
<
◊◊- .
int
◊◊. 1
>
◊◊1 2
(
◊◊2 3
type
◊◊3 7
:
◊◊7 8
$str
◊◊9 B
,
◊◊B C
nullable
◊◊D L
:
◊◊L M
false
◊◊N S
)
◊◊S T
,
◊◊T U
FromStatusId
ÿÿ  
=
ÿÿ! "
table
ÿÿ# (
.
ÿÿ( )
Column
ÿÿ) /
<
ÿÿ/ 0
int
ÿÿ0 3
>
ÿÿ3 4
(
ÿÿ4 5
type
ÿÿ5 9
:
ÿÿ9 :
$str
ÿÿ; D
,
ÿÿD E
nullable
ÿÿF N
:
ÿÿN O
false
ÿÿP U
)
ÿÿU V
,
ÿÿV W

ToStatusId
ŸŸ 
=
ŸŸ  
table
ŸŸ! &
.
ŸŸ& '
Column
ŸŸ' -
<
ŸŸ- .
int
ŸŸ. 1
>
ŸŸ1 2
(
ŸŸ2 3
type
ŸŸ3 7
:
ŸŸ7 8
$str
ŸŸ9 B
,
ŸŸB C
nullable
ŸŸD L
:
ŸŸL M
false
ŸŸN S
)
ŸŸS T
,
ŸŸT U
TransitionName
⁄⁄ "
=
⁄⁄# $
table
⁄⁄% *
.
⁄⁄* +
Column
⁄⁄+ 1
<
⁄⁄1 2
string
⁄⁄2 8
>
⁄⁄8 9
(
⁄⁄9 :
type
⁄⁄: >
:
⁄⁄> ?
$str
⁄⁄@ F
,
⁄⁄F G
nullable
⁄⁄H P
:
⁄⁄P Q
false
⁄⁄R W
)
⁄⁄W X
,
⁄⁄X Y#
RequiredPermissionKey
€€ )
=
€€* +
table
€€, 1
.
€€1 2
Column
€€2 8
<
€€8 9
string
€€9 ?
>
€€? @
(
€€@ A
type
€€A E
:
€€E F
$str
€€G M
,
€€M N
nullable
€€O W
:
€€W X
true
€€Y ]
)
€€] ^
,
€€^ _
	SortOrder
‹‹ 
=
‹‹ 
table
‹‹  %
.
‹‹% &
Column
‹‹& ,
<
‹‹, -
int
‹‹- 0
>
‹‹0 1
(
‹‹1 2
type
‹‹2 6
:
‹‹6 7
$str
‹‹8 A
,
‹‹A B
nullable
‹‹C K
:
‹‹K L
false
‹‹M R
)
‹‹R S
,
‹‹S T
	CreatedAt
›› 
=
›› 
table
››  %
.
››% &
Column
››& ,
<
››, -
DateTime
››- 5
>
››5 6
(
››6 7
type
››7 ;
:
››; <
$str
››= W
,
››W X
nullable
››Y a
:
››a b
false
››c h
)
››h i
,
››i j
	CreatedBy
ﬁﬁ 
=
ﬁﬁ 
table
ﬁﬁ  %
.
ﬁﬁ% &
Column
ﬁﬁ& ,
<
ﬁﬁ, -
string
ﬁﬁ- 3
>
ﬁﬁ3 4
(
ﬁﬁ4 5
type
ﬁﬁ5 9
:
ﬁﬁ9 :
$str
ﬁﬁ; A
,
ﬁﬁA B
nullable
ﬁﬁC K
:
ﬁﬁK L
true
ﬁﬁM Q
)
ﬁﬁQ R
,
ﬁﬁR S
	UpdatedAt
ﬂﬂ 
=
ﬂﬂ 
table
ﬂﬂ  %
.
ﬂﬂ% &
Column
ﬂﬂ& ,
<
ﬂﬂ, -
DateTime
ﬂﬂ- 5
>
ﬂﬂ5 6
(
ﬂﬂ6 7
type
ﬂﬂ7 ;
:
ﬂﬂ; <
$str
ﬂﬂ= W
,
ﬂﬂW X
nullable
ﬂﬂY a
:
ﬂﬂa b
true
ﬂﬂc g
)
ﬂﬂg h
,
ﬂﬂh i
	UpdatedBy
‡‡ 
=
‡‡ 
table
‡‡  %
.
‡‡% &
Column
‡‡& ,
<
‡‡, -
string
‡‡- 3
>
‡‡3 4
(
‡‡4 5
type
‡‡5 9
:
‡‡9 :
$str
‡‡; A
,
‡‡A B
nullable
‡‡C K
:
‡‡K L
true
‡‡M Q
)
‡‡Q R
,
‡‡R S
IsActive
·· 
=
·· 
table
·· $
.
··$ %
Column
··% +
<
··+ ,
bool
··, 0
>
··0 1
(
··1 2
type
··2 6
:
··6 7
$str
··8 A
,
··A B
nullable
··C K
:
··K L
false
··M R
)
··R S
,
··S T
	IsDeleted
‚‚ 
=
‚‚ 
table
‚‚  %
.
‚‚% &
Column
‚‚& ,
<
‚‚, -
bool
‚‚- 1
>
‚‚1 2
(
‚‚2 3
type
‚‚3 7
:
‚‚7 8
$str
‚‚9 B
,
‚‚B C
nullable
‚‚D L
:
‚‚L M
false
‚‚N S
)
‚‚S T
,
‚‚T U
	DeletedAt
„„ 
=
„„ 
table
„„  %
.
„„% &
Column
„„& ,
<
„„, -
DateTime
„„- 5
>
„„5 6
(
„„6 7
type
„„7 ;
:
„„; <
$str
„„= W
,
„„W X
nullable
„„Y a
:
„„a b
true
„„c g
)
„„g h
}
‰‰ 
,
‰‰ 
constraints
ÂÂ 
:
ÂÂ 
table
ÂÂ "
=>
ÂÂ# %
{
ÊÊ 
table
ÁÁ 
.
ÁÁ 

PrimaryKey
ÁÁ $
(
ÁÁ$ %
$str
ÁÁ% =
,
ÁÁ= >
x
ÁÁ? @
=>
ÁÁA C
x
ÁÁD E
.
ÁÁE F
Id
ÁÁF H
)
ÁÁH I
;
ÁÁI J
table
ËË 
.
ËË 

ForeignKey
ËË $
(
ËË$ %
name
ÈÈ 
:
ÈÈ 
$str
ÈÈ L
,
ÈÈL M
column
ÍÍ 
:
ÍÍ 
x
ÍÍ  !
=>
ÍÍ" $
x
ÍÍ% &
.
ÍÍ& '
FromStatusId
ÍÍ' 3
,
ÍÍ3 4
principalTable
ÎÎ &
:
ÎÎ& '
$str
ÎÎ( 2
,
ÎÎ2 3
principalColumn
ÏÏ '
:
ÏÏ' (
$str
ÏÏ) -
,
ÏÏ- .
onDelete
ÌÌ  
:
ÌÌ  !
ReferentialAction
ÌÌ" 3
.
ÌÌ3 4
Restrict
ÌÌ4 <
)
ÌÌ< =
;
ÌÌ= >
table
ÓÓ 
.
ÓÓ 

ForeignKey
ÓÓ $
(
ÓÓ$ %
name
ÔÔ 
:
ÔÔ 
$str
ÔÔ J
,
ÔÔJ K
column
 
:
 
x
  !
=>
" $
x
% &
.
& '

ToStatusId
' 1
,
1 2
principalTable
ÒÒ &
:
ÒÒ& '
$str
ÒÒ( 2
,
ÒÒ2 3
principalColumn
ÚÚ '
:
ÚÚ' (
$str
ÚÚ) -
,
ÚÚ- .
onDelete
ÛÛ  
:
ÛÛ  !
ReferentialAction
ÛÛ" 3
.
ÛÛ3 4
Restrict
ÛÛ4 <
)
ÛÛ< =
;
ÛÛ= >
table
ÙÙ 
.
ÙÙ 

ForeignKey
ÙÙ $
(
ÙÙ$ %
name
ıı 
:
ıı 
$str
ıı K
,
ııK L
column
ˆˆ 
:
ˆˆ 
x
ˆˆ  !
=>
ˆˆ" $
x
ˆˆ% &
.
ˆˆ& '

WorkflowId
ˆˆ' 1
,
ˆˆ1 2
principalTable
˜˜ &
:
˜˜& '
$str
˜˜( 3
,
˜˜3 4
principalColumn
¯¯ '
:
¯¯' (
$str
¯¯) -
,
¯¯- .
onDelete
˘˘  
:
˘˘  !
ReferentialAction
˘˘" 3
.
˘˘3 4
Cascade
˘˘4 ;
)
˘˘; <
;
˘˘< =
}
˙˙ 
)
˙˙ 
;
˙˙ 
migrationBuilder
¸¸ 
.
¸¸ 
CreateTable
¸¸ (
(
¸¸( )
name
˝˝ 
:
˝˝ 
$str
˝˝ "
,
˝˝" #
columns
˛˛ 
:
˛˛ 
table
˛˛ 
=>
˛˛ !
new
˛˛" %
{
ˇˇ 
Id
ÄÄ 
=
ÄÄ 
table
ÄÄ 
.
ÄÄ 
Column
ÄÄ %
<
ÄÄ% &
int
ÄÄ& )
>
ÄÄ) *
(
ÄÄ* +
type
ÄÄ+ /
:
ÄÄ/ 0
$str
ÄÄ1 :
,
ÄÄ: ;
nullable
ÄÄ< D
:
ÄÄD E
false
ÄÄF K
)
ÄÄK L
.
ÅÅ 

Annotation
ÅÅ #
(
ÅÅ# $
$str
ÅÅ$ D
,
ÅÅD E+
NpgsqlValueGenerationStrategy
ÅÅF c
.
ÅÅc d%
IdentityByDefaultColumn
ÅÅd {
)
ÅÅ{ |
,
ÅÅ| }
GroupId
ÇÇ 
=
ÇÇ 
table
ÇÇ #
.
ÇÇ# $
Column
ÇÇ$ *
<
ÇÇ* +
int
ÇÇ+ .
>
ÇÇ. /
(
ÇÇ/ 0
type
ÇÇ0 4
:
ÇÇ4 5
$str
ÇÇ6 ?
,
ÇÇ? @
nullable
ÇÇA I
:
ÇÇI J
false
ÇÇK P
)
ÇÇP Q
,
ÇÇQ R
RoleId
ÉÉ 
=
ÉÉ 
table
ÉÉ "
.
ÉÉ" #
Column
ÉÉ# )
<
ÉÉ) *
int
ÉÉ* -
>
ÉÉ- .
(
ÉÉ. /
type
ÉÉ/ 3
:
ÉÉ3 4
$str
ÉÉ5 >
,
ÉÉ> ?
nullable
ÉÉ@ H
:
ÉÉH I
false
ÉÉJ O
)
ÉÉO P
,
ÉÉP Q
	CreatedAt
ÑÑ 
=
ÑÑ 
table
ÑÑ  %
.
ÑÑ% &
Column
ÑÑ& ,
<
ÑÑ, -
DateTime
ÑÑ- 5
>
ÑÑ5 6
(
ÑÑ6 7
type
ÑÑ7 ;
:
ÑÑ; <
$str
ÑÑ= W
,
ÑÑW X
nullable
ÑÑY a
:
ÑÑa b
false
ÑÑc h
)
ÑÑh i
,
ÑÑi j
	CreatedBy
ÖÖ 
=
ÖÖ 
table
ÖÖ  %
.
ÖÖ% &
Column
ÖÖ& ,
<
ÖÖ, -
string
ÖÖ- 3
>
ÖÖ3 4
(
ÖÖ4 5
type
ÖÖ5 9
:
ÖÖ9 :
$str
ÖÖ; A
,
ÖÖA B
nullable
ÖÖC K
:
ÖÖK L
true
ÖÖM Q
)
ÖÖQ R
,
ÖÖR S
	UpdatedAt
ÜÜ 
=
ÜÜ 
table
ÜÜ  %
.
ÜÜ% &
Column
ÜÜ& ,
<
ÜÜ, -
DateTime
ÜÜ- 5
>
ÜÜ5 6
(
ÜÜ6 7
type
ÜÜ7 ;
:
ÜÜ; <
$str
ÜÜ= W
,
ÜÜW X
nullable
ÜÜY a
:
ÜÜa b
true
ÜÜc g
)
ÜÜg h
,
ÜÜh i
	UpdatedBy
áá 
=
áá 
table
áá  %
.
áá% &
Column
áá& ,
<
áá, -
string
áá- 3
>
áá3 4
(
áá4 5
type
áá5 9
:
áá9 :
$str
áá; A
,
ááA B
nullable
ááC K
:
ááK L
true
ááM Q
)
ááQ R
,
ááR S
IsActive
àà 
=
àà 
table
àà $
.
àà$ %
Column
àà% +
<
àà+ ,
bool
àà, 0
>
àà0 1
(
àà1 2
type
àà2 6
:
àà6 7
$str
àà8 A
,
ààA B
nullable
ààC K
:
ààK L
false
ààM R
)
ààR S
,
ààS T
	IsDeleted
ââ 
=
ââ 
table
ââ  %
.
ââ% &
Column
ââ& ,
<
ââ, -
bool
ââ- 1
>
ââ1 2
(
ââ2 3
type
ââ3 7
:
ââ7 8
$str
ââ9 B
,
ââB C
nullable
ââD L
:
ââL M
false
ââN S
)
ââS T
,
ââT U
	DeletedAt
ää 
=
ää 
table
ää  %
.
ää% &
Column
ää& ,
<
ää, -
DateTime
ää- 5
>
ää5 6
(
ää6 7
type
ää7 ;
:
ää; <
$str
ää= W
,
ääW X
nullable
ääY a
:
ääa b
true
ääc g
)
ääg h
}
ãã 
,
ãã 
constraints
åå 
:
åå 
table
åå "
=>
åå# %
{
çç 
table
éé 
.
éé 

PrimaryKey
éé $
(
éé$ %
$str
éé% 4
,
éé4 5
x
éé6 7
=>
éé8 :
x
éé; <
.
éé< =
Id
éé= ?
)
éé? @
;
éé@ A
table
èè 
.
èè 

ForeignKey
èè $
(
èè$ %
name
êê 
:
êê 
$str
êê <
,
êê< =
column
ëë 
:
ëë 
x
ëë  !
=>
ëë" $
x
ëë% &
.
ëë& '
GroupId
ëë' .
,
ëë. /
principalTable
íí &
:
íí& '
$str
íí( 0
,
íí0 1
principalColumn
ìì '
:
ìì' (
$str
ìì) -
,
ìì- .
onDelete
îî  
:
îî  !
ReferentialAction
îî" 3
.
îî3 4
Cascade
îî4 ;
)
îî; <
;
îî< =
table
ïï 
.
ïï 

ForeignKey
ïï $
(
ïï$ %
name
ññ 
:
ññ 
$str
ññ :
,
ññ: ;
column
óó 
:
óó 
x
óó  !
=>
óó" $
x
óó% &
.
óó& '
RoleId
óó' -
,
óó- .
principalTable
òò &
:
òò& '
$str
òò( /
,
òò/ 0
principalColumn
ôô '
:
ôô' (
$str
ôô) -
,
ôô- .
onDelete
öö  
:
öö  !
ReferentialAction
öö" 3
.
öö3 4
Cascade
öö4 ;
)
öö; <
;
öö< =
}
õõ 
)
õõ 
;
õõ 
migrationBuilder
ùù 
.
ùù 
CreateTable
ùù (
(
ùù( )
name
ûû 
:
ûû 
$str
ûû $
,
ûû$ %
columns
üü 
:
üü 
table
üü 
=>
üü !
new
üü" %
{
†† 
Id
°° 
=
°° 
table
°° 
.
°° 
Column
°° %
<
°°% &
int
°°& )
>
°°) *
(
°°* +
type
°°+ /
:
°°/ 0
$str
°°1 :
,
°°: ;
nullable
°°< D
:
°°D E
false
°°F K
)
°°K L
.
¢¢ 

Annotation
¢¢ #
(
¢¢# $
$str
¢¢$ D
,
¢¢D E+
NpgsqlValueGenerationStrategy
¢¢F c
.
¢¢c d%
IdentityByDefaultColumn
¢¢d {
)
¢¢{ |
,
¢¢| }
UserId
££ 
=
££ 
table
££ "
.
££" #
Column
££# )
<
££) *
int
££* -
>
££- .
(
££. /
type
££/ 3
:
££3 4
$str
££5 >
,
££> ?
nullable
££@ H
:
££H I
false
££J O
)
££O P
,
££P Q
GroupId
§§ 
=
§§ 
table
§§ #
.
§§# $
Column
§§$ *
<
§§* +
int
§§+ .
>
§§. /
(
§§/ 0
type
§§0 4
:
§§4 5
$str
§§6 ?
,
§§? @
nullable
§§A I
:
§§I J
false
§§K P
)
§§P Q
,
§§Q R
	CreatedAt
•• 
=
•• 
table
••  %
.
••% &
Column
••& ,
<
••, -
DateTime
••- 5
>
••5 6
(
••6 7
type
••7 ;
:
••; <
$str
••= W
,
••W X
nullable
••Y a
:
••a b
false
••c h
)
••h i
,
••i j
	CreatedBy
¶¶ 
=
¶¶ 
table
¶¶  %
.
¶¶% &
Column
¶¶& ,
<
¶¶, -
string
¶¶- 3
>
¶¶3 4
(
¶¶4 5
type
¶¶5 9
:
¶¶9 :
$str
¶¶; A
,
¶¶A B
nullable
¶¶C K
:
¶¶K L
true
¶¶M Q
)
¶¶Q R
,
¶¶R S
	UpdatedAt
ßß 
=
ßß 
table
ßß  %
.
ßß% &
Column
ßß& ,
<
ßß, -
DateTime
ßß- 5
>
ßß5 6
(
ßß6 7
type
ßß7 ;
:
ßß; <
$str
ßß= W
,
ßßW X
nullable
ßßY a
:
ßßa b
true
ßßc g
)
ßßg h
,
ßßh i
	UpdatedBy
®® 
=
®® 
table
®®  %
.
®®% &
Column
®®& ,
<
®®, -
string
®®- 3
>
®®3 4
(
®®4 5
type
®®5 9
:
®®9 :
$str
®®; A
,
®®A B
nullable
®®C K
:
®®K L
true
®®M Q
)
®®Q R
,
®®R S
IsActive
©© 
=
©© 
table
©© $
.
©©$ %
Column
©©% +
<
©©+ ,
bool
©©, 0
>
©©0 1
(
©©1 2
type
©©2 6
:
©©6 7
$str
©©8 A
,
©©A B
nullable
©©C K
:
©©K L
false
©©M R
)
©©R S
,
©©S T
	IsDeleted
™™ 
=
™™ 
table
™™  %
.
™™% &
Column
™™& ,
<
™™, -
bool
™™- 1
>
™™1 2
(
™™2 3
type
™™3 7
:
™™7 8
$str
™™9 B
,
™™B C
nullable
™™D L
:
™™L M
false
™™N S
)
™™S T
,
™™T U
	DeletedAt
´´ 
=
´´ 
table
´´  %
.
´´% &
Column
´´& ,
<
´´, -
DateTime
´´- 5
>
´´5 6
(
´´6 7
type
´´7 ;
:
´´; <
$str
´´= W
,
´´W X
nullable
´´Y a
:
´´a b
true
´´c g
)
´´g h
}
¨¨ 
,
¨¨ 
constraints
≠≠ 
:
≠≠ 
table
≠≠ "
=>
≠≠# %
{
ÆÆ 
table
ØØ 
.
ØØ 

PrimaryKey
ØØ $
(
ØØ$ %
$str
ØØ% 6
,
ØØ6 7
x
ØØ8 9
=>
ØØ: <
x
ØØ= >
.
ØØ> ?
Id
ØØ? A
)
ØØA B
;
ØØB C
table
∞∞ 
.
∞∞ 

ForeignKey
∞∞ $
(
∞∞$ %
name
±± 
:
±± 
$str
±± >
,
±±> ?
column
≤≤ 
:
≤≤ 
x
≤≤  !
=>
≤≤" $
x
≤≤% &
.
≤≤& '
GroupId
≤≤' .
,
≤≤. /
principalTable
≥≥ &
:
≥≥& '
$str
≥≥( 0
,
≥≥0 1
principalColumn
¥¥ '
:
¥¥' (
$str
¥¥) -
,
¥¥- .
onDelete
µµ  
:
µµ  !
ReferentialAction
µµ" 3
.
µµ3 4
Cascade
µµ4 ;
)
µµ; <
;
µµ< =
table
∂∂ 
.
∂∂ 

ForeignKey
∂∂ $
(
∂∂$ %
name
∑∑ 
:
∑∑ 
$str
∑∑ <
,
∑∑< =
column
∏∏ 
:
∏∏ 
x
∏∏  !
=>
∏∏" $
x
∏∏% &
.
∏∏& '
UserId
∏∏' -
,
∏∏- .
principalTable
ππ &
:
ππ& '
$str
ππ( /
,
ππ/ 0
principalColumn
∫∫ '
:
∫∫' (
$str
∫∫) -
,
∫∫- .
onDelete
ªª  
:
ªª  !
ReferentialAction
ªª" 3
.
ªª3 4
Cascade
ªª4 ;
)
ªª; <
;
ªª< =
}
ºº 
)
ºº 
;
ºº 
migrationBuilder
ææ 
.
ææ 
CreateTable
ææ (
(
ææ( )
name
øø 
:
øø 
$str
øø &
,
øø& '
columns
¿¿ 
:
¿¿ 
table
¿¿ 
=>
¿¿ !
new
¿¿" %
{
¡¡ 
Id
¬¬ 
=
¬¬ 
table
¬¬ 
.
¬¬ 
Column
¬¬ %
<
¬¬% &
int
¬¬& )
>
¬¬) *
(
¬¬* +
type
¬¬+ /
:
¬¬/ 0
$str
¬¬1 :
,
¬¬: ;
nullable
¬¬< D
:
¬¬D E
false
¬¬F K
)
¬¬K L
.
√√ 

Annotation
√√ #
(
√√# $
$str
√√$ D
,
√√D E+
NpgsqlValueGenerationStrategy
√√F c
.
√√c d%
IdentityByDefaultColumn
√√d {
)
√√{ |
,
√√| }
	ProjectId
ƒƒ 
=
ƒƒ 
table
ƒƒ  %
.
ƒƒ% &
Column
ƒƒ& ,
<
ƒƒ, -
int
ƒƒ- 0
>
ƒƒ0 1
(
ƒƒ1 2
type
ƒƒ2 6
:
ƒƒ6 7
$str
ƒƒ8 A
,
ƒƒA B
nullable
ƒƒC K
:
ƒƒK L
false
ƒƒM R
)
ƒƒR S
,
ƒƒS T
UserId
≈≈ 
=
≈≈ 
table
≈≈ "
.
≈≈" #
Column
≈≈# )
<
≈≈) *
int
≈≈* -
>
≈≈- .
(
≈≈. /
type
≈≈/ 3
:
≈≈3 4
$str
≈≈5 >
,
≈≈> ?
nullable
≈≈@ H
:
≈≈H I
false
≈≈J O
)
≈≈O P
,
≈≈P Q
SpecificRoleId
∆∆ "
=
∆∆# $
table
∆∆% *
.
∆∆* +
Column
∆∆+ 1
<
∆∆1 2
int
∆∆2 5
>
∆∆5 6
(
∆∆6 7
type
∆∆7 ;
:
∆∆; <
$str
∆∆= F
,
∆∆F G
nullable
∆∆H P
:
∆∆P Q
true
∆∆R V
)
∆∆V W
,
∆∆W X
	CreatedAt
«« 
=
«« 
table
««  %
.
««% &
Column
««& ,
<
««, -
DateTime
««- 5
>
««5 6
(
««6 7
type
««7 ;
:
««; <
$str
««= W
,
««W X
nullable
««Y a
:
««a b
false
««c h
)
««h i
,
««i j
	CreatedBy
»» 
=
»» 
table
»»  %
.
»»% &
Column
»»& ,
<
»», -
string
»»- 3
>
»»3 4
(
»»4 5
type
»»5 9
:
»»9 :
$str
»»; A
,
»»A B
nullable
»»C K
:
»»K L
true
»»M Q
)
»»Q R
,
»»R S
	UpdatedAt
…… 
=
…… 
table
……  %
.
……% &
Column
……& ,
<
……, -
DateTime
……- 5
>
……5 6
(
……6 7
type
……7 ;
:
……; <
$str
……= W
,
……W X
nullable
……Y a
:
……a b
true
……c g
)
……g h
,
……h i
	UpdatedBy
   
=
   
table
    %
.
  % &
Column
  & ,
<
  , -
string
  - 3
>
  3 4
(
  4 5
type
  5 9
:
  9 :
$str
  ; A
,
  A B
nullable
  C K
:
  K L
true
  M Q
)
  Q R
,
  R S
IsActive
ÀÀ 
=
ÀÀ 
table
ÀÀ $
.
ÀÀ$ %
Column
ÀÀ% +
<
ÀÀ+ ,
bool
ÀÀ, 0
>
ÀÀ0 1
(
ÀÀ1 2
type
ÀÀ2 6
:
ÀÀ6 7
$str
ÀÀ8 A
,
ÀÀA B
nullable
ÀÀC K
:
ÀÀK L
false
ÀÀM R
)
ÀÀR S
,
ÀÀS T
	IsDeleted
ÃÃ 
=
ÃÃ 
table
ÃÃ  %
.
ÃÃ% &
Column
ÃÃ& ,
<
ÃÃ, -
bool
ÃÃ- 1
>
ÃÃ1 2
(
ÃÃ2 3
type
ÃÃ3 7
:
ÃÃ7 8
$str
ÃÃ9 B
,
ÃÃB C
nullable
ÃÃD L
:
ÃÃL M
false
ÃÃN S
)
ÃÃS T
,
ÃÃT U
	DeletedAt
ÕÕ 
=
ÕÕ 
table
ÕÕ  %
.
ÕÕ% &
Column
ÕÕ& ,
<
ÕÕ, -
DateTime
ÕÕ- 5
>
ÕÕ5 6
(
ÕÕ6 7
type
ÕÕ7 ;
:
ÕÕ; <
$str
ÕÕ= W
,
ÕÕW X
nullable
ÕÕY a
:
ÕÕa b
true
ÕÕc g
)
ÕÕg h
}
ŒŒ 
,
ŒŒ 
constraints
œœ 
:
œœ 
table
œœ "
=>
œœ# %
{
–– 
table
—— 
.
—— 

PrimaryKey
—— $
(
——$ %
$str
——% 8
,
——8 9
x
——: ;
=>
——< >
x
——? @
.
——@ A
Id
——A C
)
——C D
;
——D E
table
““ 
.
““ 

ForeignKey
““ $
(
““$ %
name
”” 
:
”” 
$str
”” D
,
””D E
column
‘‘ 
:
‘‘ 
x
‘‘  !
=>
‘‘" $
x
‘‘% &
.
‘‘& '
	ProjectId
‘‘' 0
,
‘‘0 1
principalTable
’’ &
:
’’& '
$str
’’( 2
,
’’2 3
principalColumn
÷÷ '
:
÷÷' (
$str
÷÷) -
,
÷÷- .
onDelete
◊◊  
:
◊◊  !
ReferentialAction
◊◊" 3
.
◊◊3 4
Cascade
◊◊4 ;
)
◊◊; <
;
◊◊< =
table
ÿÿ 
.
ÿÿ 

ForeignKey
ÿÿ $
(
ÿÿ$ %
name
ŸŸ 
:
ŸŸ 
$str
ŸŸ >
,
ŸŸ> ?
column
⁄⁄ 
:
⁄⁄ 
x
⁄⁄  !
=>
⁄⁄" $
x
⁄⁄% &
.
⁄⁄& '
UserId
⁄⁄' -
,
⁄⁄- .
principalTable
€€ &
:
€€& '
$str
€€( /
,
€€/ 0
principalColumn
‹‹ '
:
‹‹' (
$str
‹‹) -
,
‹‹- .
onDelete
››  
:
››  !
ReferentialAction
››" 3
.
››3 4
Cascade
››4 ;
)
››; <
;
››< =
}
ﬁﬁ 
)
ﬁﬁ 
;
ﬁﬁ 
migrationBuilder
‡‡ 
.
‡‡ 
CreateTable
‡‡ (
(
‡‡( )
name
·· 
:
·· 
$str
·· 
,
··  
columns
‚‚ 
:
‚‚ 
table
‚‚ 
=>
‚‚ !
new
‚‚" %
{
„„ 
Id
‰‰ 
=
‰‰ 
table
‰‰ 
.
‰‰ 
Column
‰‰ %
<
‰‰% &
int
‰‰& )
>
‰‰) *
(
‰‰* +
type
‰‰+ /
:
‰‰/ 0
$str
‰‰1 :
,
‰‰: ;
nullable
‰‰< D
:
‰‰D E
false
‰‰F K
)
‰‰K L
.
ÂÂ 

Annotation
ÂÂ #
(
ÂÂ# $
$str
ÂÂ$ D
,
ÂÂD E+
NpgsqlValueGenerationStrategy
ÂÂF c
.
ÂÂc d%
IdentityByDefaultColumn
ÂÂd {
)
ÂÂ{ |
,
ÂÂ| }
TicketNumber
ÊÊ  
=
ÊÊ! "
table
ÊÊ# (
.
ÊÊ( )
Column
ÊÊ) /
<
ÊÊ/ 0
string
ÊÊ0 6
>
ÊÊ6 7
(
ÊÊ7 8
type
ÊÊ8 <
:
ÊÊ< =
$str
ÊÊ> U
,
ÊÊU V
	maxLength
ÊÊW `
:
ÊÊ` a
$num
ÊÊb d
,
ÊÊd e
nullable
ÊÊf n
:
ÊÊn o
false
ÊÊp u
)
ÊÊu v
,
ÊÊv w
Title
ÁÁ 
=
ÁÁ 
table
ÁÁ !
.
ÁÁ! "
Column
ÁÁ" (
<
ÁÁ( )
string
ÁÁ) /
>
ÁÁ/ 0
(
ÁÁ0 1
type
ÁÁ1 5
:
ÁÁ5 6
$str
ÁÁ7 =
,
ÁÁ= >
nullable
ÁÁ? G
:
ÁÁG H
false
ÁÁI N
)
ÁÁN O
,
ÁÁO P
Description
ËË 
=
ËË  !
table
ËË" '
.
ËË' (
Column
ËË( .
<
ËË. /
string
ËË/ 5
>
ËË5 6
(
ËË6 7
type
ËË7 ;
:
ËË; <
$str
ËË= C
,
ËËC D
nullable
ËËE M
:
ËËM N
false
ËËO T
)
ËËT U
,
ËËU V
	ProjectId
ÈÈ 
=
ÈÈ 
table
ÈÈ  %
.
ÈÈ% &
Column
ÈÈ& ,
<
ÈÈ, -
int
ÈÈ- 0
>
ÈÈ0 1
(
ÈÈ1 2
type
ÈÈ2 6
:
ÈÈ6 7
$str
ÈÈ8 A
,
ÈÈA B
nullable
ÈÈC K
:
ÈÈK L
false
ÈÈM R
)
ÈÈR S
,
ÈÈS T

CategoryId
ÍÍ 
=
ÍÍ  
table
ÍÍ! &
.
ÍÍ& '
Column
ÍÍ' -
<
ÍÍ- .
int
ÍÍ. 1
>
ÍÍ1 2
(
ÍÍ2 3
type
ÍÍ3 7
:
ÍÍ7 8
$str
ÍÍ9 B
,
ÍÍB C
nullable
ÍÍD L
:
ÍÍL M
false
ÍÍN S
)
ÍÍS T
,
ÍÍT U
TypeId
ÎÎ 
=
ÎÎ 
table
ÎÎ "
.
ÎÎ" #
Column
ÎÎ# )
<
ÎÎ) *
int
ÎÎ* -
>
ÎÎ- .
(
ÎÎ. /
type
ÎÎ/ 3
:
ÎÎ3 4
$str
ÎÎ5 >
,
ÎÎ> ?
nullable
ÎÎ@ H
:
ÎÎH I
false
ÎÎJ O
)
ÎÎO P
,
ÎÎP Q
StatusId
ÏÏ 
=
ÏÏ 
table
ÏÏ $
.
ÏÏ$ %
Column
ÏÏ% +
<
ÏÏ+ ,
int
ÏÏ, /
>
ÏÏ/ 0
(
ÏÏ0 1
type
ÏÏ1 5
:
ÏÏ5 6
$str
ÏÏ7 @
,
ÏÏ@ A
nullable
ÏÏB J
:
ÏÏJ K
false
ÏÏL Q
)
ÏÏQ R
,
ÏÏR S

PriorityId
ÌÌ 
=
ÌÌ  
table
ÌÌ! &
.
ÌÌ& '
Column
ÌÌ' -
<
ÌÌ- .
int
ÌÌ. 1
>
ÌÌ1 2
(
ÌÌ2 3
type
ÌÌ3 7
:
ÌÌ7 8
$str
ÌÌ9 B
,
ÌÌB C
nullable
ÌÌD L
:
ÌÌL M
false
ÌÌN S
)
ÌÌS T
,
ÌÌT U
RequesterUserId
ÓÓ #
=
ÓÓ$ %
table
ÓÓ& +
.
ÓÓ+ ,
Column
ÓÓ, 2
<
ÓÓ2 3
int
ÓÓ3 6
>
ÓÓ6 7
(
ÓÓ7 8
type
ÓÓ8 <
:
ÓÓ< =
$str
ÓÓ> G
,
ÓÓG H
nullable
ÓÓI Q
:
ÓÓQ R
false
ÓÓS X
)
ÓÓX Y
,
ÓÓY Z
AssignedUserId
ÔÔ "
=
ÔÔ# $
table
ÔÔ% *
.
ÔÔ* +
Column
ÔÔ+ 1
<
ÔÔ1 2
int
ÔÔ2 5
>
ÔÔ5 6
(
ÔÔ6 7
type
ÔÔ7 ;
:
ÔÔ; <
$str
ÔÔ= F
,
ÔÔF G
nullable
ÔÔH P
:
ÔÔP Q
true
ÔÔR V
)
ÔÔV W
,
ÔÔW X
AssignedGroupId
 #
=
$ %
table
& +
.
+ ,
Column
, 2
<
2 3
int
3 6
>
6 7
(
7 8
type
8 <
:
< =
$str
> G
,
G H
nullable
I Q
:
Q R
true
S W
)
W X
,
X Y
	CreatedAt
ÒÒ 
=
ÒÒ 
table
ÒÒ  %
.
ÒÒ% &
Column
ÒÒ& ,
<
ÒÒ, -
DateTime
ÒÒ- 5
>
ÒÒ5 6
(
ÒÒ6 7
type
ÒÒ7 ;
:
ÒÒ; <
$str
ÒÒ= W
,
ÒÒW X
nullable
ÒÒY a
:
ÒÒa b
false
ÒÒc h
)
ÒÒh i
,
ÒÒi j
	CreatedBy
ÚÚ 
=
ÚÚ 
table
ÚÚ  %
.
ÚÚ% &
Column
ÚÚ& ,
<
ÚÚ, -
string
ÚÚ- 3
>
ÚÚ3 4
(
ÚÚ4 5
type
ÚÚ5 9
:
ÚÚ9 :
$str
ÚÚ; A
,
ÚÚA B
nullable
ÚÚC K
:
ÚÚK L
true
ÚÚM Q
)
ÚÚQ R
,
ÚÚR S
	UpdatedAt
ÛÛ 
=
ÛÛ 
table
ÛÛ  %
.
ÛÛ% &
Column
ÛÛ& ,
<
ÛÛ, -
DateTime
ÛÛ- 5
>
ÛÛ5 6
(
ÛÛ6 7
type
ÛÛ7 ;
:
ÛÛ; <
$str
ÛÛ= W
,
ÛÛW X
nullable
ÛÛY a
:
ÛÛa b
true
ÛÛc g
)
ÛÛg h
,
ÛÛh i
	UpdatedBy
ÙÙ 
=
ÙÙ 
table
ÙÙ  %
.
ÙÙ% &
Column
ÙÙ& ,
<
ÙÙ, -
string
ÙÙ- 3
>
ÙÙ3 4
(
ÙÙ4 5
type
ÙÙ5 9
:
ÙÙ9 :
$str
ÙÙ; A
,
ÙÙA B
nullable
ÙÙC K
:
ÙÙK L
true
ÙÙM Q
)
ÙÙQ R
,
ÙÙR S
IsActive
ıı 
=
ıı 
table
ıı $
.
ıı$ %
Column
ıı% +
<
ıı+ ,
bool
ıı, 0
>
ıı0 1
(
ıı1 2
type
ıı2 6
:
ıı6 7
$str
ıı8 A
,
ııA B
nullable
ııC K
:
ııK L
false
ııM R
)
ııR S
,
ııS T
	IsDeleted
ˆˆ 
=
ˆˆ 
table
ˆˆ  %
.
ˆˆ% &
Column
ˆˆ& ,
<
ˆˆ, -
bool
ˆˆ- 1
>
ˆˆ1 2
(
ˆˆ2 3
type
ˆˆ3 7
:
ˆˆ7 8
$str
ˆˆ9 B
,
ˆˆB C
nullable
ˆˆD L
:
ˆˆL M
false
ˆˆN S
)
ˆˆS T
,
ˆˆT U
	DeletedAt
˜˜ 
=
˜˜ 
table
˜˜  %
.
˜˜% &
Column
˜˜& ,
<
˜˜, -
DateTime
˜˜- 5
>
˜˜5 6
(
˜˜6 7
type
˜˜7 ;
:
˜˜; <
$str
˜˜= W
,
˜˜W X
nullable
˜˜Y a
:
˜˜a b
true
˜˜c g
)
˜˜g h
}
¯¯ 
,
¯¯ 
constraints
˘˘ 
:
˘˘ 
table
˘˘ "
=>
˘˘# %
{
˙˙ 
table
˚˚ 
.
˚˚ 

PrimaryKey
˚˚ $
(
˚˚$ %
$str
˚˚% 1
,
˚˚1 2
x
˚˚3 4
=>
˚˚5 7
x
˚˚8 9
.
˚˚9 :
Id
˚˚: <
)
˚˚< =
;
˚˚= >
table
¸¸ 
.
¸¸ 

ForeignKey
¸¸ $
(
¸¸$ %
name
˝˝ 
:
˝˝ 
$str
˝˝ @
,
˝˝@ A
column
˛˛ 
:
˛˛ 
x
˛˛  !
=>
˛˛" $
x
˛˛% &
.
˛˛& '

CategoryId
˛˛' 1
,
˛˛1 2
principalTable
ˇˇ &
:
ˇˇ& '
$str
ˇˇ( 4
,
ˇˇ4 5
principalColumn
ÄÄ '
:
ÄÄ' (
$str
ÄÄ) -
,
ÄÄ- .
onDelete
ÅÅ  
:
ÅÅ  !
ReferentialAction
ÅÅ" 3
.
ÅÅ3 4
Cascade
ÅÅ4 ;
)
ÅÅ; <
;
ÅÅ< =
table
ÇÇ 
.
ÇÇ 

ForeignKey
ÇÇ $
(
ÇÇ$ %
name
ÉÉ 
:
ÉÉ 
$str
ÉÉ A
,
ÉÉA B
column
ÑÑ 
:
ÑÑ 
x
ÑÑ  !
=>
ÑÑ" $
x
ÑÑ% &
.
ÑÑ& '
AssignedGroupId
ÑÑ' 6
,
ÑÑ6 7
principalTable
ÖÖ &
:
ÖÖ& '
$str
ÖÖ( 0
,
ÖÖ0 1
principalColumn
ÜÜ '
:
ÜÜ' (
$str
ÜÜ) -
)
ÜÜ- .
;
ÜÜ. /
table
áá 
.
áá 

ForeignKey
áá $
(
áá$ %
name
àà 
:
àà 
$str
àà @
,
àà@ A
column
ââ 
:
ââ 
x
ââ  !
=>
ââ" $
x
ââ% &
.
ââ& '

PriorityId
ââ' 1
,
ââ1 2
principalTable
ää &
:
ää& '
$str
ää( 4
,
ää4 5
principalColumn
ãã '
:
ãã' (
$str
ãã) -
,
ãã- .
onDelete
åå  
:
åå  !
ReferentialAction
åå" 3
.
åå3 4
Cascade
åå4 ;
)
åå; <
;
åå< =
table
çç 
.
çç 

ForeignKey
çç $
(
çç$ %
name
éé 
:
éé 
$str
éé =
,
éé= >
column
èè 
:
èè 
x
èè  !
=>
èè" $
x
èè% &
.
èè& '
	ProjectId
èè' 0
,
èè0 1
principalTable
êê &
:
êê& '
$str
êê( 2
,
êê2 3
principalColumn
ëë '
:
ëë' (
$str
ëë) -
,
ëë- .
onDelete
íí  
:
íí  !
ReferentialAction
íí" 3
.
íí3 4
Cascade
íí4 ;
)
íí; <
;
íí< =
table
ìì 
.
ìì 

ForeignKey
ìì $
(
ìì$ %
name
îî 
:
îî 
$str
îî <
,
îî< =
column
ïï 
:
ïï 
x
ïï  !
=>
ïï" $
x
ïï% &
.
ïï& '
StatusId
ïï' /
,
ïï/ 0
principalTable
ññ &
:
ññ& '
$str
ññ( 2
,
ññ2 3
principalColumn
óó '
:
óó' (
$str
óó) -
,
óó- .
onDelete
òò  
:
òò  !
ReferentialAction
òò" 3
.
òò3 4
Cascade
òò4 ;
)
òò; <
;
òò< =
table
ôô 
.
ôô 

ForeignKey
ôô $
(
ôô$ %
name
öö 
:
öö 
$str
öö =
,
öö= >
column
õõ 
:
õõ 
x
õõ  !
=>
õõ" $
x
õõ% &
.
õõ& '
TypeId
õõ' -
,
õõ- .
principalTable
úú &
:
úú& '
$str
úú( 5
,
úú5 6
principalColumn
ùù '
:
ùù' (
$str
ùù) -
,
ùù- .
onDelete
ûû  
:
ûû  !
ReferentialAction
ûû" 3
.
ûû3 4
Cascade
ûû4 ;
)
ûû; <
;
ûû< =
table
üü 
.
üü 

ForeignKey
üü $
(
üü$ %
name
†† 
:
†† 
$str
†† ?
,
††? @
column
°° 
:
°° 
x
°°  !
=>
°°" $
x
°°% &
.
°°& '
AssignedUserId
°°' 5
,
°°5 6
principalTable
¢¢ &
:
¢¢& '
$str
¢¢( /
,
¢¢/ 0
principalColumn
££ '
:
££' (
$str
££) -
,
££- .
onDelete
§§  
:
§§  !
ReferentialAction
§§" 3
.
§§3 4
SetNull
§§4 ;
)
§§; <
;
§§< =
table
•• 
.
•• 

ForeignKey
•• $
(
••$ %
name
¶¶ 
:
¶¶ 
$str
¶¶ @
,
¶¶@ A
column
ßß 
:
ßß 
x
ßß  !
=>
ßß" $
x
ßß% &
.
ßß& '
RequesterUserId
ßß' 6
,
ßß6 7
principalTable
®® &
:
®®& '
$str
®®( /
,
®®/ 0
principalColumn
©© '
:
©©' (
$str
©©) -
,
©©- .
onDelete
™™  
:
™™  !
ReferentialAction
™™" 3
.
™™3 4
Restrict
™™4 <
)
™™< =
;
™™= >
}
´´ 
)
´´ 
;
´´ 
migrationBuilder
≠≠ 
.
≠≠ 
CreateTable
≠≠ (
(
≠≠( )
name
ÆÆ 
:
ÆÆ 
$str
ÆÆ /
,
ÆÆ/ 0
columns
ØØ 
:
ØØ 
table
ØØ 
=>
ØØ !
new
ØØ" %
{
∞∞ 
Id
±± 
=
±± 
table
±± 
.
±± 
Column
±± %
<
±±% &
int
±±& )
>
±±) *
(
±±* +
type
±±+ /
:
±±/ 0
$str
±±1 :
,
±±: ;
nullable
±±< D
:
±±D E
false
±±F K
)
±±K L
.
≤≤ 

Annotation
≤≤ #
(
≤≤# $
$str
≤≤$ D
,
≤≤D E+
NpgsqlValueGenerationStrategy
≤≤F c
.
≤≤c d%
IdentityByDefaultColumn
≤≤d {
)
≤≤{ |
,
≤≤| }
UserId
≥≥ 
=
≥≥ 
table
≥≥ "
.
≥≥" #
Column
≥≥# )
<
≥≥) *
int
≥≥* -
>
≥≥- .
(
≥≥. /
type
≥≥/ 3
:
≥≥3 4
$str
≥≥5 >
,
≥≥> ?
nullable
≥≥@ H
:
≥≥H I
false
≥≥J O
)
≥≥O P
,
≥≥P Q
PermissionId
¥¥  
=
¥¥! "
table
¥¥# (
.
¥¥( )
Column
¥¥) /
<
¥¥/ 0
int
¥¥0 3
>
¥¥3 4
(
¥¥4 5
type
¥¥5 9
:
¥¥9 :
$str
¥¥; D
,
¥¥D E
nullable
¥¥F N
:
¥¥N O
false
¥¥P U
)
¥¥U V
,
¥¥V W
	IsGranted
µµ 
=
µµ 
table
µµ  %
.
µµ% &
Column
µµ& ,
<
µµ, -
bool
µµ- 1
>
µµ1 2
(
µµ2 3
type
µµ3 7
:
µµ7 8
$str
µµ9 B
,
µµB C
nullable
µµD L
:
µµL M
false
µµN S
)
µµS T
,
µµT U
	CreatedAt
∂∂ 
=
∂∂ 
table
∂∂  %
.
∂∂% &
Column
∂∂& ,
<
∂∂, -
DateTime
∂∂- 5
>
∂∂5 6
(
∂∂6 7
type
∂∂7 ;
:
∂∂; <
$str
∂∂= W
,
∂∂W X
nullable
∂∂Y a
:
∂∂a b
false
∂∂c h
)
∂∂h i
,
∂∂i j
	CreatedBy
∑∑ 
=
∑∑ 
table
∑∑  %
.
∑∑% &
Column
∑∑& ,
<
∑∑, -
string
∑∑- 3
>
∑∑3 4
(
∑∑4 5
type
∑∑5 9
:
∑∑9 :
$str
∑∑; A
,
∑∑A B
nullable
∑∑C K
:
∑∑K L
true
∑∑M Q
)
∑∑Q R
,
∑∑R S
	UpdatedAt
∏∏ 
=
∏∏ 
table
∏∏  %
.
∏∏% &
Column
∏∏& ,
<
∏∏, -
DateTime
∏∏- 5
>
∏∏5 6
(
∏∏6 7
type
∏∏7 ;
:
∏∏; <
$str
∏∏= W
,
∏∏W X
nullable
∏∏Y a
:
∏∏a b
true
∏∏c g
)
∏∏g h
,
∏∏h i
	UpdatedBy
ππ 
=
ππ 
table
ππ  %
.
ππ% &
Column
ππ& ,
<
ππ, -
string
ππ- 3
>
ππ3 4
(
ππ4 5
type
ππ5 9
:
ππ9 :
$str
ππ; A
,
ππA B
nullable
ππC K
:
ππK L
true
ππM Q
)
ππQ R
,
ππR S
IsActive
∫∫ 
=
∫∫ 
table
∫∫ $
.
∫∫$ %
Column
∫∫% +
<
∫∫+ ,
bool
∫∫, 0
>
∫∫0 1
(
∫∫1 2
type
∫∫2 6
:
∫∫6 7
$str
∫∫8 A
,
∫∫A B
nullable
∫∫C K
:
∫∫K L
false
∫∫M R
)
∫∫R S
,
∫∫S T
	IsDeleted
ªª 
=
ªª 
table
ªª  %
.
ªª% &
Column
ªª& ,
<
ªª, -
bool
ªª- 1
>
ªª1 2
(
ªª2 3
type
ªª3 7
:
ªª7 8
$str
ªª9 B
,
ªªB C
nullable
ªªD L
:
ªªL M
false
ªªN S
)
ªªS T
,
ªªT U
	DeletedAt
ºº 
=
ºº 
table
ºº  %
.
ºº% &
Column
ºº& ,
<
ºº, -
DateTime
ºº- 5
>
ºº5 6
(
ºº6 7
type
ºº7 ;
:
ºº; <
$str
ºº= W
,
ººW X
nullable
ººY a
:
ººa b
true
ººc g
)
ººg h
}
ΩΩ 
,
ΩΩ 
constraints
ææ 
:
ææ 
table
ææ "
=>
ææ# %
{
øø 
table
¿¿ 
.
¿¿ 

PrimaryKey
¿¿ $
(
¿¿$ %
$str
¿¿% A
,
¿¿A B
x
¿¿C D
=>
¿¿E G
x
¿¿H I
.
¿¿I J
Id
¿¿J L
)
¿¿L M
;
¿¿M N
table
¡¡ 
.
¡¡ 

ForeignKey
¡¡ $
(
¡¡$ %
name
¬¬ 
:
¬¬ 
$str
¬¬ S
,
¬¬S T
column
√√ 
:
√√ 
x
√√  !
=>
√√" $
x
√√% &
.
√√& '
PermissionId
√√' 3
,
√√3 4
principalTable
ƒƒ &
:
ƒƒ& '
$str
ƒƒ( 5
,
ƒƒ5 6
principalColumn
≈≈ '
:
≈≈' (
$str
≈≈) -
,
≈≈- .
onDelete
∆∆  
:
∆∆  !
ReferentialAction
∆∆" 3
.
∆∆3 4
Cascade
∆∆4 ;
)
∆∆; <
;
∆∆< =
table
«« 
.
«« 

ForeignKey
«« $
(
««$ %
name
»» 
:
»» 
$str
»» G
,
»»G H
column
…… 
:
…… 
x
……  !
=>
……" $
x
……% &
.
……& '
UserId
……' -
,
……- .
principalTable
   &
:
  & '
$str
  ( /
,
  / 0
principalColumn
ÀÀ '
:
ÀÀ' (
$str
ÀÀ) -
,
ÀÀ- .
onDelete
ÃÃ  
:
ÃÃ  !
ReferentialAction
ÃÃ" 3
.
ÃÃ3 4
Cascade
ÃÃ4 ;
)
ÃÃ; <
;
ÃÃ< =
}
ÕÕ 
)
ÕÕ 
;
ÕÕ 
migrationBuilder
œœ 
.
œœ 
CreateTable
œœ (
(
œœ( )
name
–– 
:
–– 
$str
–– !
,
––! "
columns
—— 
:
—— 
table
—— 
=>
—— !
new
——" %
{
““ 
Id
”” 
=
”” 
table
”” 
.
”” 
Column
”” %
<
””% &
int
””& )
>
””) *
(
””* +
type
””+ /
:
””/ 0
$str
””1 :
,
””: ;
nullable
””< D
:
””D E
false
””F K
)
””K L
.
‘‘ 

Annotation
‘‘ #
(
‘‘# $
$str
‘‘$ D
,
‘‘D E+
NpgsqlValueGenerationStrategy
‘‘F c
.
‘‘c d%
IdentityByDefaultColumn
‘‘d {
)
‘‘{ |
,
‘‘| }
UserId
’’ 
=
’’ 
table
’’ "
.
’’" #
Column
’’# )
<
’’) *
int
’’* -
>
’’- .
(
’’. /
type
’’/ 3
:
’’3 4
$str
’’5 >
,
’’> ?
nullable
’’@ H
:
’’H I
false
’’J O
)
’’O P
,
’’P Q
RoleId
÷÷ 
=
÷÷ 
table
÷÷ "
.
÷÷" #
Column
÷÷# )
<
÷÷) *
int
÷÷* -
>
÷÷- .
(
÷÷. /
type
÷÷/ 3
:
÷÷3 4
$str
÷÷5 >
,
÷÷> ?
nullable
÷÷@ H
:
÷÷H I
false
÷÷J O
)
÷÷O P
,
÷÷P Q
	CreatedAt
◊◊ 
=
◊◊ 
table
◊◊  %
.
◊◊% &
Column
◊◊& ,
<
◊◊, -
DateTime
◊◊- 5
>
◊◊5 6
(
◊◊6 7
type
◊◊7 ;
:
◊◊; <
$str
◊◊= W
,
◊◊W X
nullable
◊◊Y a
:
◊◊a b
false
◊◊c h
)
◊◊h i
,
◊◊i j
	CreatedBy
ÿÿ 
=
ÿÿ 
table
ÿÿ  %
.
ÿÿ% &
Column
ÿÿ& ,
<
ÿÿ, -
string
ÿÿ- 3
>
ÿÿ3 4
(
ÿÿ4 5
type
ÿÿ5 9
:
ÿÿ9 :
$str
ÿÿ; A
,
ÿÿA B
nullable
ÿÿC K
:
ÿÿK L
true
ÿÿM Q
)
ÿÿQ R
,
ÿÿR S
	UpdatedAt
ŸŸ 
=
ŸŸ 
table
ŸŸ  %
.
ŸŸ% &
Column
ŸŸ& ,
<
ŸŸ, -
DateTime
ŸŸ- 5
>
ŸŸ5 6
(
ŸŸ6 7
type
ŸŸ7 ;
:
ŸŸ; <
$str
ŸŸ= W
,
ŸŸW X
nullable
ŸŸY a
:
ŸŸa b
true
ŸŸc g
)
ŸŸg h
,
ŸŸh i
	UpdatedBy
⁄⁄ 
=
⁄⁄ 
table
⁄⁄  %
.
⁄⁄% &
Column
⁄⁄& ,
<
⁄⁄, -
string
⁄⁄- 3
>
⁄⁄3 4
(
⁄⁄4 5
type
⁄⁄5 9
:
⁄⁄9 :
$str
⁄⁄; A
,
⁄⁄A B
nullable
⁄⁄C K
:
⁄⁄K L
true
⁄⁄M Q
)
⁄⁄Q R
,
⁄⁄R S
IsActive
€€ 
=
€€ 
table
€€ $
.
€€$ %
Column
€€% +
<
€€+ ,
bool
€€, 0
>
€€0 1
(
€€1 2
type
€€2 6
:
€€6 7
$str
€€8 A
,
€€A B
nullable
€€C K
:
€€K L
false
€€M R
)
€€R S
,
€€S T
	IsDeleted
‹‹ 
=
‹‹ 
table
‹‹  %
.
‹‹% &
Column
‹‹& ,
<
‹‹, -
bool
‹‹- 1
>
‹‹1 2
(
‹‹2 3
type
‹‹3 7
:
‹‹7 8
$str
‹‹9 B
,
‹‹B C
nullable
‹‹D L
:
‹‹L M
false
‹‹N S
)
‹‹S T
,
‹‹T U
	DeletedAt
›› 
=
›› 
table
››  %
.
››% &
Column
››& ,
<
››, -
DateTime
››- 5
>
››5 6
(
››6 7
type
››7 ;
:
››; <
$str
››= W
,
››W X
nullable
››Y a
:
››a b
true
››c g
)
››g h
}
ﬁﬁ 
,
ﬁﬁ 
constraints
ﬂﬂ 
:
ﬂﬂ 
table
ﬂﬂ "
=>
ﬂﬂ# %
{
‡‡ 
table
·· 
.
·· 

PrimaryKey
·· $
(
··$ %
$str
··% 3
,
··3 4
x
··5 6
=>
··7 9
x
··: ;
.
··; <
Id
··< >
)
··> ?
;
··? @
table
‚‚ 
.
‚‚ 

ForeignKey
‚‚ $
(
‚‚$ %
name
„„ 
:
„„ 
$str
„„ 9
,
„„9 :
column
‰‰ 
:
‰‰ 
x
‰‰  !
=>
‰‰" $
x
‰‰% &
.
‰‰& '
RoleId
‰‰' -
,
‰‰- .
principalTable
ÂÂ &
:
ÂÂ& '
$str
ÂÂ( /
,
ÂÂ/ 0
principalColumn
ÊÊ '
:
ÊÊ' (
$str
ÊÊ) -
,
ÊÊ- .
onDelete
ÁÁ  
:
ÁÁ  !
ReferentialAction
ÁÁ" 3
.
ÁÁ3 4
Cascade
ÁÁ4 ;
)
ÁÁ; <
;
ÁÁ< =
table
ËË 
.
ËË 

ForeignKey
ËË $
(
ËË$ %
name
ÈÈ 
:
ÈÈ 
$str
ÈÈ 9
,
ÈÈ9 :
column
ÍÍ 
:
ÍÍ 
x
ÍÍ  !
=>
ÍÍ" $
x
ÍÍ% &
.
ÍÍ& '
UserId
ÍÍ' -
,
ÍÍ- .
principalTable
ÎÎ &
:
ÎÎ& '
$str
ÎÎ( /
,
ÎÎ/ 0
principalColumn
ÏÏ '
:
ÏÏ' (
$str
ÏÏ) -
,
ÏÏ- .
onDelete
ÌÌ  
:
ÌÌ  !
ReferentialAction
ÌÌ" 3
.
ÌÌ3 4
Cascade
ÌÌ4 ;
)
ÌÌ; <
;
ÌÌ< =
}
ÓÓ 
)
ÓÓ 
;
ÓÓ 
migrationBuilder
 
.
 
CreateTable
 (
(
( )
name
ÒÒ 
:
ÒÒ 
$str
ÒÒ )
,
ÒÒ) *
columns
ÚÚ 
:
ÚÚ 
table
ÚÚ 
=>
ÚÚ !
new
ÚÚ" %
{
ÛÛ 
Id
ÙÙ 
=
ÙÙ 
table
ÙÙ 
.
ÙÙ 
Column
ÙÙ %
<
ÙÙ% &
int
ÙÙ& )
>
ÙÙ) *
(
ÙÙ* +
type
ÙÙ+ /
:
ÙÙ/ 0
$str
ÙÙ1 :
,
ÙÙ: ;
nullable
ÙÙ< D
:
ÙÙD E
false
ÙÙF K
)
ÙÙK L
.
ıı 

Annotation
ıı #
(
ıı# $
$str
ıı$ D
,
ııD E+
NpgsqlValueGenerationStrategy
ııF c
.
ııc d%
IdentityByDefaultColumn
ııd {
)
ıı{ |
,
ıı| }
TicketId
ˆˆ 
=
ˆˆ 
table
ˆˆ $
.
ˆˆ$ %
Column
ˆˆ% +
<
ˆˆ+ ,
int
ˆˆ, /
>
ˆˆ/ 0
(
ˆˆ0 1
type
ˆˆ1 5
:
ˆˆ5 6
$str
ˆˆ7 @
,
ˆˆ@ A
nullable
ˆˆB J
:
ˆˆJ K
false
ˆˆL Q
)
ˆˆQ R
,
ˆˆR S
FieldDefinitionId
˜˜ %
=
˜˜& '
table
˜˜( -
.
˜˜- .
Column
˜˜. 4
<
˜˜4 5
int
˜˜5 8
>
˜˜8 9
(
˜˜9 :
type
˜˜: >
:
˜˜> ?
$str
˜˜@ I
,
˜˜I J
nullable
˜˜K S
:
˜˜S T
false
˜˜U Z
)
˜˜Z [
,
˜˜[ \
ValueString
¯¯ 
=
¯¯  !
table
¯¯" '
.
¯¯' (
Column
¯¯( .
<
¯¯. /
string
¯¯/ 5
>
¯¯5 6
(
¯¯6 7
type
¯¯7 ;
:
¯¯; <
$str
¯¯= C
,
¯¯C D
nullable
¯¯E M
:
¯¯M N
false
¯¯O T
)
¯¯T U
,
¯¯U V
	ValueText
˘˘ 
=
˘˘ 
table
˘˘  %
.
˘˘% &
Column
˘˘& ,
<
˘˘, -
string
˘˘- 3
>
˘˘3 4
(
˘˘4 5
type
˘˘5 9
:
˘˘9 :
$str
˘˘; A
,
˘˘A B
nullable
˘˘C K
:
˘˘K L
true
˘˘M Q
)
˘˘Q R
,
˘˘R S
	CreatedAt
˙˙ 
=
˙˙ 
table
˙˙  %
.
˙˙% &
Column
˙˙& ,
<
˙˙, -
DateTime
˙˙- 5
>
˙˙5 6
(
˙˙6 7
type
˙˙7 ;
:
˙˙; <
$str
˙˙= W
,
˙˙W X
nullable
˙˙Y a
:
˙˙a b
false
˙˙c h
)
˙˙h i
,
˙˙i j
	CreatedBy
˚˚ 
=
˚˚ 
table
˚˚  %
.
˚˚% &
Column
˚˚& ,
<
˚˚, -
string
˚˚- 3
>
˚˚3 4
(
˚˚4 5
type
˚˚5 9
:
˚˚9 :
$str
˚˚; A
,
˚˚A B
nullable
˚˚C K
:
˚˚K L
true
˚˚M Q
)
˚˚Q R
,
˚˚R S
	UpdatedAt
¸¸ 
=
¸¸ 
table
¸¸  %
.
¸¸% &
Column
¸¸& ,
<
¸¸, -
DateTime
¸¸- 5
>
¸¸5 6
(
¸¸6 7
type
¸¸7 ;
:
¸¸; <
$str
¸¸= W
,
¸¸W X
nullable
¸¸Y a
:
¸¸a b
true
¸¸c g
)
¸¸g h
,
¸¸h i
	UpdatedBy
˝˝ 
=
˝˝ 
table
˝˝  %
.
˝˝% &
Column
˝˝& ,
<
˝˝, -
string
˝˝- 3
>
˝˝3 4
(
˝˝4 5
type
˝˝5 9
:
˝˝9 :
$str
˝˝; A
,
˝˝A B
nullable
˝˝C K
:
˝˝K L
true
˝˝M Q
)
˝˝Q R
,
˝˝R S
IsActive
˛˛ 
=
˛˛ 
table
˛˛ $
.
˛˛$ %
Column
˛˛% +
<
˛˛+ ,
bool
˛˛, 0
>
˛˛0 1
(
˛˛1 2
type
˛˛2 6
:
˛˛6 7
$str
˛˛8 A
,
˛˛A B
nullable
˛˛C K
:
˛˛K L
false
˛˛M R
)
˛˛R S
,
˛˛S T
	IsDeleted
ˇˇ 
=
ˇˇ 
table
ˇˇ  %
.
ˇˇ% &
Column
ˇˇ& ,
<
ˇˇ, -
bool
ˇˇ- 1
>
ˇˇ1 2
(
ˇˇ2 3
type
ˇˇ3 7
:
ˇˇ7 8
$str
ˇˇ9 B
,
ˇˇB C
nullable
ˇˇD L
:
ˇˇL M
false
ˇˇN S
)
ˇˇS T
,
ˇˇT U
	DeletedAt
ÄÄ 
=
ÄÄ 
table
ÄÄ  %
.
ÄÄ% &
Column
ÄÄ& ,
<
ÄÄ, -
DateTime
ÄÄ- 5
>
ÄÄ5 6
(
ÄÄ6 7
type
ÄÄ7 ;
:
ÄÄ; <
$str
ÄÄ= W
,
ÄÄW X
nullable
ÄÄY a
:
ÄÄa b
true
ÄÄc g
)
ÄÄg h
}
ÅÅ 
,
ÅÅ 
constraints
ÇÇ 
:
ÇÇ 
table
ÇÇ "
=>
ÇÇ# %
{
ÉÉ 
table
ÑÑ 
.
ÑÑ 

PrimaryKey
ÑÑ $
(
ÑÑ$ %
$str
ÑÑ% ;
,
ÑÑ; <
x
ÑÑ= >
=>
ÑÑ? A
x
ÑÑB C
.
ÑÑC D
Id
ÑÑD F
)
ÑÑF G
;
ÑÑG H
table
ÖÖ 
.
ÖÖ 

ForeignKey
ÖÖ $
(
ÖÖ$ %
name
ÜÜ 
:
ÜÜ 
$str
ÜÜ W
,
ÜÜW X
column
áá 
:
áá 
x
áá  !
=>
áá" $
x
áá% &
.
áá& '
FieldDefinitionId
áá' 8
,
áá8 9
principalTable
àà &
:
àà& '
$str
àà( :
,
àà: ;
principalColumn
ââ '
:
ââ' (
$str
ââ) -
,
ââ- .
onDelete
ää  
:
ää  !
ReferentialAction
ää" 3
.
ää3 4
Restrict
ää4 <
)
ää< =
;
ää= >
table
ãã 
.
ãã 

ForeignKey
ãã $
(
ãã$ %
name
åå 
:
åå 
$str
åå E
,
ååE F
column
çç 
:
çç 
x
çç  !
=>
çç" $
x
çç% &
.
çç& '
TicketId
çç' /
,
çç/ 0
principalTable
éé &
:
éé& '
$str
éé( 1
,
éé1 2
principalColumn
èè '
:
èè' (
$str
èè) -
,
èè- .
onDelete
êê  
:
êê  !
ReferentialAction
êê" 3
.
êê3 4
Cascade
êê4 ;
)
êê; <
;
êê< =
}
ëë 
)
ëë 
;
ëë 
migrationBuilder
ìì 
.
ìì 
CreateTable
ìì (
(
ìì( )
name
îî 
:
îî 
$str
îî '
,
îî' (
columns
ïï 
:
ïï 
table
ïï 
=>
ïï !
new
ïï" %
{
ññ 
Id
óó 
=
óó 
table
óó 
.
óó 
Column
óó %
<
óó% &
int
óó& )
>
óó) *
(
óó* +
type
óó+ /
:
óó/ 0
$str
óó1 :
,
óó: ;
nullable
óó< D
:
óóD E
false
óóF K
)
óóK L
.
òò 

Annotation
òò #
(
òò# $
$str
òò$ D
,
òòD E+
NpgsqlValueGenerationStrategy
òòF c
.
òòc d%
IdentityByDefaultColumn
òòd {
)
òò{ |
,
òò| }
TicketId
ôô 
=
ôô 
table
ôô $
.
ôô$ %
Column
ôô% +
<
ôô+ ,
int
ôô, /
>
ôô/ 0
(
ôô0 1
type
ôô1 5
:
ôô5 6
$str
ôô7 @
,
ôô@ A
nullable
ôôB J
:
ôôJ K
false
ôôL Q
)
ôôQ R
,
ôôR S
	FieldName
öö 
=
öö 
table
öö  %
.
öö% &
Column
öö& ,
<
öö, -
string
öö- 3
>
öö3 4
(
öö4 5
type
öö5 9
:
öö9 :
$str
öö; A
,
ööA B
nullable
ööC K
:
ööK L
false
ööM R
)
ööR S
,
ööS T
OldValue
õõ 
=
õõ 
table
õõ $
.
õõ$ %
Column
õõ% +
<
õõ+ ,
string
õõ, 2
>
õõ2 3
(
õõ3 4
type
õõ4 8
:
õõ8 9
$str
õõ: @
,
õõ@ A
nullable
õõB J
:
õõJ K
true
õõL P
)
õõP Q
,
õõQ R
NewValue
úú 
=
úú 
table
úú $
.
úú$ %
Column
úú% +
<
úú+ ,
string
úú, 2
>
úú2 3
(
úú3 4
type
úú4 8
:
úú8 9
$str
úú: @
,
úú@ A
nullable
úúB J
:
úúJ K
true
úúL P
)
úúP Q
,
úúQ R
Action
ùù 
=
ùù 
table
ùù "
.
ùù" #
Column
ùù# )
<
ùù) *
string
ùù* 0
>
ùù0 1
(
ùù1 2
type
ùù2 6
:
ùù6 7
$str
ùù8 >
,
ùù> ?
nullable
ùù@ H
:
ùùH I
false
ùùJ O
)
ùùO P
,
ùùP Q
	CreatedAt
ûû 
=
ûû 
table
ûû  %
.
ûû% &
Column
ûû& ,
<
ûû, -
DateTime
ûû- 5
>
ûû5 6
(
ûû6 7
type
ûû7 ;
:
ûû; <
$str
ûû= W
,
ûûW X
nullable
ûûY a
:
ûûa b
false
ûûc h
)
ûûh i
,
ûûi j
	CreatedBy
üü 
=
üü 
table
üü  %
.
üü% &
Column
üü& ,
<
üü, -
string
üü- 3
>
üü3 4
(
üü4 5
type
üü5 9
:
üü9 :
$str
üü; A
,
üüA B
nullable
üüC K
:
üüK L
true
üüM Q
)
üüQ R
,
üüR S
	UpdatedAt
†† 
=
†† 
table
††  %
.
††% &
Column
††& ,
<
††, -
DateTime
††- 5
>
††5 6
(
††6 7
type
††7 ;
:
††; <
$str
††= W
,
††W X
nullable
††Y a
:
††a b
true
††c g
)
††g h
,
††h i
	UpdatedBy
°° 
=
°° 
table
°°  %
.
°°% &
Column
°°& ,
<
°°, -
string
°°- 3
>
°°3 4
(
°°4 5
type
°°5 9
:
°°9 :
$str
°°; A
,
°°A B
nullable
°°C K
:
°°K L
true
°°M Q
)
°°Q R
,
°°R S
IsActive
¢¢ 
=
¢¢ 
table
¢¢ $
.
¢¢$ %
Column
¢¢% +
<
¢¢+ ,
bool
¢¢, 0
>
¢¢0 1
(
¢¢1 2
type
¢¢2 6
:
¢¢6 7
$str
¢¢8 A
,
¢¢A B
nullable
¢¢C K
:
¢¢K L
false
¢¢M R
)
¢¢R S
,
¢¢S T
	IsDeleted
££ 
=
££ 
table
££  %
.
££% &
Column
££& ,
<
££, -
bool
££- 1
>
££1 2
(
££2 3
type
££3 7
:
££7 8
$str
££9 B
,
££B C
nullable
££D L
:
££L M
false
££N S
)
££S T
,
££T U
	DeletedAt
§§ 
=
§§ 
table
§§  %
.
§§% &
Column
§§& ,
<
§§, -
DateTime
§§- 5
>
§§5 6
(
§§6 7
type
§§7 ;
:
§§; <
$str
§§= W
,
§§W X
nullable
§§Y a
:
§§a b
true
§§c g
)
§§g h
}
•• 
,
•• 
constraints
¶¶ 
:
¶¶ 
table
¶¶ "
=>
¶¶# %
{
ßß 
table
®® 
.
®® 

PrimaryKey
®® $
(
®®$ %
$str
®®% 9
,
®®9 :
x
®®; <
=>
®®= ?
x
®®@ A
.
®®A B
Id
®®B D
)
®®D E
;
®®E F
table
©© 
.
©© 

ForeignKey
©© $
(
©©$ %
name
™™ 
:
™™ 
$str
™™ C
,
™™C D
column
´´ 
:
´´ 
x
´´  !
=>
´´" $
x
´´% &
.
´´& '
TicketId
´´' /
,
´´/ 0
principalTable
¨¨ &
:
¨¨& '
$str
¨¨( 1
,
¨¨1 2
principalColumn
≠≠ '
:
≠≠' (
$str
≠≠) -
,
≠≠- .
onDelete
ÆÆ  
:
ÆÆ  !
ReferentialAction
ÆÆ" 3
.
ÆÆ3 4
Cascade
ÆÆ4 ;
)
ÆÆ; <
;
ÆÆ< =
}
ØØ 
)
ØØ 
;
ØØ 
migrationBuilder
±± 
.
±± 
CreateIndex
±± (
(
±±( )
name
≤≤ 
:
≤≤ 
$str
≤≤ /
,
≤≤/ 0
table
≥≥ 
:
≥≥ 
$str
≥≥ )
,
≥≥) *
column
¥¥ 
:
¥¥ 
$str
¥¥ 
,
¥¥ 
unique
µµ 
:
µµ 
true
µµ 
)
µµ 
;
µµ 
migrationBuilder
∑∑ 
.
∑∑ 
CreateIndex
∑∑ (
(
∑∑( )
name
∏∏ 
:
∏∏ 
$str
∏∏ 9
,
∏∏9 :
table
ππ 
:
ππ 
$str
ππ %
,
ππ% &
column
∫∫ 
:
∫∫ 
$str
∫∫ +
)
∫∫+ ,
;
∫∫, -
migrationBuilder
ºº 
.
ºº 
CreateIndex
ºº (
(
ºº( )
name
ΩΩ 
:
ΩΩ 
$str
ΩΩ @
,
ΩΩ@ A
table
ææ 
:
ææ 
$str
ææ ,
,
ææ, -
column
øø 
:
øø 
$str
øø +
)
øø+ ,
;
øø, -
migrationBuilder
¡¡ 
.
¡¡ 
CreateIndex
¡¡ (
(
¡¡( )
name
¬¬ 
:
¬¬ 
$str
¬¬ /
,
¬¬/ 0
table
√√ 
:
√√ 
$str
√√ %
,
√√% &
column
ƒƒ 
:
ƒƒ 
$str
ƒƒ !
)
ƒƒ! "
;
ƒƒ" #
migrationBuilder
∆∆ 
.
∆∆ 
CreateIndex
∆∆ (
(
∆∆( )
name
«« 
:
«« 
$str
«« .
,
««. /
table
»» 
:
»» 
$str
»» %
,
»»% &
column
…… 
:
…… 
$str
……  
)
……  !
;
……! "
migrationBuilder
ÀÀ 
.
ÀÀ 
CreateIndex
ÀÀ (
(
ÀÀ( )
name
ÃÃ 
:
ÃÃ 
$str
ÃÃ -
,
ÃÃ- .
table
ÕÕ 
:
ÕÕ 
$str
ÕÕ #
,
ÕÕ# $
column
ŒŒ 
:
ŒŒ 
$str
ŒŒ !
)
ŒŒ! "
;
ŒŒ" #
migrationBuilder
–– 
.
–– 
CreateIndex
–– (
(
––( )
name
—— 
:
—— 
$str
—— ,
,
——, -
table
““ 
:
““ 
$str
““ #
,
““# $
column
”” 
:
”” 
$str
””  
)
””  !
;
””! "
migrationBuilder
’’ 
.
’’ 
CreateIndex
’’ (
(
’’( )
name
÷÷ 
:
÷÷ 
$str
÷÷ .
,
÷÷. /
table
◊◊ 
:
◊◊ 
$str
◊◊ 
,
◊◊  
column
ÿÿ 
:
ÿÿ 
$str
ÿÿ &
)
ÿÿ& '
;
ÿÿ' (
migrationBuilder
⁄⁄ 
.
⁄⁄ 
CreateIndex
⁄⁄ (
(
⁄⁄( )
name
€€ 
:
€€ 
$str
€€ 7
,
€€7 8
table
‹‹ 
:
‹‹ 
$str
‹‹ *
,
‹‹* +
column
›› 
:
›› 
$str
›› $
)
››$ %
;
››% &
migrationBuilder
ﬂﬂ 
.
ﬂﬂ 
CreateIndex
ﬂﬂ (
(
ﬂﬂ( )
name
‡‡ 
:
‡‡ 
$str
‡‡ 7
,
‡‡7 8
table
·· 
:
·· 
$str
·· ,
,
··, -
column
‚‚ 
:
‚‚ 
$str
‚‚ "
)
‚‚" #
;
‚‚# $
migrationBuilder
‰‰ 
.
‰‰ 
CreateIndex
‰‰ (
(
‰‰( )
name
ÂÂ 
:
ÂÂ 
$str
ÂÂ 3
,
ÂÂ3 4
table
ÊÊ 
:
ÊÊ 
$str
ÊÊ '
,
ÊÊ' (
column
ÁÁ 
:
ÁÁ 
$str
ÁÁ #
)
ÁÁ# $
;
ÁÁ$ %
migrationBuilder
ÈÈ 
.
ÈÈ 
CreateIndex
ÈÈ (
(
ÈÈ( )
name
ÍÍ 
:
ÍÍ 
$str
ÍÍ 0
,
ÍÍ0 1
table
ÎÎ 
:
ÎÎ 
$str
ÎÎ '
,
ÎÎ' (
column
ÏÏ 
:
ÏÏ 
$str
ÏÏ  
)
ÏÏ  !
;
ÏÏ! "
migrationBuilder
ÓÓ 
.
ÓÓ 
CreateIndex
ÓÓ (
(
ÓÓ( )
name
ÔÔ 
:
ÔÔ 
$str
ÔÔ 7
,
ÔÔ7 8
table
 
:
 
$str
 (
,
( )
column
ÒÒ 
:
ÒÒ 
$str
ÒÒ &
)
ÒÒ& '
;
ÒÒ' (
migrationBuilder
ÛÛ 
.
ÛÛ 
CreateIndex
ÛÛ (
(
ÛÛ( )
name
ÙÙ 
:
ÙÙ 
$str
ÙÙ 1
,
ÙÙ1 2
table
ıı 
:
ıı 
$str
ıı (
,
ıı( )
column
ˆˆ 
:
ˆˆ 
$str
ˆˆ  
)
ˆˆ  !
;
ˆˆ! "
migrationBuilder
¯¯ 
.
¯¯ 
CreateIndex
¯¯ (
(
¯¯( )
name
˘˘ 
:
˘˘ 
$str
˘˘ 1
,
˘˘1 2
table
˙˙ 
:
˙˙ 
$str
˙˙ #
,
˙˙# $
column
˚˚ 
:
˚˚ 
$str
˚˚ %
)
˚˚% &
;
˚˚& '
migrationBuilder
˝˝ 
.
˝˝ 
CreateIndex
˝˝ (
(
˝˝( )
name
˛˛ 
:
˛˛ 
$str
˛˛ >
,
˛˛> ?
table
ˇˇ 
:
ˇˇ 
$str
ˇˇ *
,
ˇˇ* +
column
ÄÄ 
:
ÄÄ 
$str
ÄÄ +
)
ÄÄ+ ,
;
ÄÄ, -
migrationBuilder
ÇÇ 
.
ÇÇ 
CreateIndex
ÇÇ (
(
ÇÇ( )
name
ÉÉ 
:
ÉÉ 
$str
ÉÉ G
,
ÉÉG H
table
ÑÑ 
:
ÑÑ 
$str
ÑÑ *
,
ÑÑ* +
columns
ÖÖ 
:
ÖÖ 
new
ÖÖ 
[
ÖÖ 
]
ÖÖ 
{
ÖÖ  
$str
ÖÖ! +
,
ÖÖ+ ,
$str
ÖÖ- @
}
ÖÖA B
,
ÖÖB C
unique
ÜÜ 
:
ÜÜ 
true
ÜÜ 
)
ÜÜ 
;
ÜÜ 
migrationBuilder
àà 
.
àà 
CreateIndex
àà (
(
àà( )
name
ââ 
:
ââ 
$str
ââ 3
,
ââ3 4
table
ää 
:
ää 
$str
ää (
,
ää( )
column
ãã 
:
ãã 
$str
ãã "
)
ãã" #
;
ãã# $
migrationBuilder
çç 
.
çç 
CreateIndex
çç (
(
çç( )
name
éé 
:
éé 
$str
éé 2
,
éé2 3
table
èè 
:
èè 
$str
èè  
,
èè  !
column
êê 
:
êê 
$str
êê )
)
êê) *
;
êê* +
migrationBuilder
íí 
.
íí 
CreateIndex
íí (
(
íí( )
name
ìì 
:
ìì 
$str
ìì 1
,
ìì1 2
table
îî 
:
îî 
$str
îî  
,
îî  !
column
ïï 
:
ïï 
$str
ïï (
)
ïï( )
;
ïï) *
migrationBuilder
óó 
.
óó 
CreateIndex
óó (
(
óó( )
name
òò 
:
òò 
$str
òò -
,
òò- .
table
ôô 
:
ôô 
$str
ôô  
,
ôô  !
column
öö 
:
öö 
$str
öö $
)
öö$ %
;
öö% &
migrationBuilder
úú 
.
úú 
CreateIndex
úú (
(
úú( )
name
ùù 
:
ùù 
$str
ùù -
,
ùù- .
table
ûû 
:
ûû 
$str
ûû  
,
ûû  !
column
üü 
:
üü 
$str
üü $
)
üü$ %
;
üü% &
migrationBuilder
°° 
.
°° 
CreateIndex
°° (
(
°°( )
name
¢¢ 
:
¢¢ 
$str
¢¢ ,
,
¢¢, -
table
££ 
:
££ 
$str
££  
,
££  !
column
§§ 
:
§§ 
$str
§§ #
)
§§# $
;
§§$ %
migrationBuilder
¶¶ 
.
¶¶ 
CreateIndex
¶¶ (
(
¶¶( )
name
ßß 
:
ßß 
$str
ßß 2
,
ßß2 3
table
®® 
:
®® 
$str
®®  
,
®®  !
column
©© 
:
©© 
$str
©© )
)
©©) *
;
©©* +
migrationBuilder
´´ 
.
´´ 
CreateIndex
´´ (
(
´´( )
name
¨¨ 
:
¨¨ 
$str
¨¨ +
,
¨¨+ ,
table
≠≠ 
:
≠≠ 
$str
≠≠  
,
≠≠  !
column
ÆÆ 
:
ÆÆ 
$str
ÆÆ "
)
ÆÆ" #
;
ÆÆ# $
migrationBuilder
∞∞ 
.
∞∞ 
CreateIndex
∞∞ (
(
∞∞( )
name
±± 
:
±± 
$str
±± /
,
±±/ 0
table
≤≤ 
:
≤≤ 
$str
≤≤  
,
≤≤  !
column
≥≥ 
:
≥≥ 
$str
≥≥ &
,
≥≥& '
unique
¥¥ 
:
¥¥ 
true
¥¥ 
)
¥¥ 
;
¥¥ 
migrationBuilder
∂∂ 
.
∂∂ 
CreateIndex
∂∂ (
(
∂∂( )
name
∑∑ 
:
∑∑ 
$str
∑∑ )
,
∑∑) *
table
∏∏ 
:
∏∏ 
$str
∏∏  
,
∏∏  !
column
ππ 
:
ππ 
$str
ππ  
)
ππ  !
;
ππ! "
migrationBuilder
ªª 
.
ªª 
CreateIndex
ªª (
(
ªª( )
name
ºº 
:
ºº 
$str
ºº ?
,
ºº? @
table
ΩΩ 
:
ΩΩ 
$str
ΩΩ 0
,
ΩΩ0 1
column
ææ 
:
ææ 
$str
ææ &
)
ææ& '
;
ææ' (
migrationBuilder
¿¿ 
.
¿¿ 
CreateIndex
¿¿ (
(
¿¿( )
name
¡¡ 
:
¡¡ 
$str
¡¡ 9
,
¡¡9 :
table
¬¬ 
:
¬¬ 
$str
¬¬ 0
,
¬¬0 1
column
√√ 
:
√√ 
$str
√√  
)
√√  !
;
√√! "
migrationBuilder
≈≈ 
.
≈≈ 
CreateIndex
≈≈ (
(
≈≈( )
name
∆∆ 
:
∆∆ 
$str
∆∆ +
,
∆∆+ ,
table
«« 
:
«« 
$str
«« "
,
««" #
column
»» 
:
»» 
$str
»»  
)
»»  !
;
»»! "
migrationBuilder
   
.
   
CreateIndex
   (
(
  ( )
name
ÀÀ 
:
ÀÀ 
$str
ÀÀ +
,
ÀÀ+ ,
table
ÃÃ 
:
ÃÃ 
$str
ÃÃ "
,
ÃÃ" #
column
ÕÕ 
:
ÕÕ 
$str
ÕÕ  
)
ÕÕ  !
;
ÕÕ! "
migrationBuilder
œœ 
.
œœ 
CreateIndex
œœ (
(
œœ( )
name
–– 
:
–– 
$str
–– -
,
––- .
table
—— 
:
—— 
$str
—— 
,
—— 
column
““ 
:
““ 
$str
““ &
)
““& '
;
““' (
migrationBuilder
‘‘ 
.
‘‘ 
CreateIndex
‘‘ (
(
‘‘( )
name
’’ 
:
’’ 
$str
’’ ;
,
’’; <
table
÷÷ 
:
÷÷ 
$str
÷÷ ,
,
÷÷, -
column
◊◊ 
:
◊◊ 
$str
◊◊ &
)
◊◊& '
;
◊◊' (
migrationBuilder
ŸŸ 
.
ŸŸ 
CreateIndex
ŸŸ (
(
ŸŸ( )
name
⁄⁄ 
:
⁄⁄ 
$str
⁄⁄ 9
,
⁄⁄9 :
table
€€ 
:
€€ 
$str
€€ ,
,
€€, -
column
‹‹ 
:
‹‹ 
$str
‹‹ $
)
‹‹$ %
;
‹‹% &
migrationBuilder
ﬁﬁ 
.
ﬁﬁ 
CreateIndex
ﬁﬁ (
(
ﬁﬁ( )
name
ﬂﬂ 
:
ﬂﬂ 
$str
ﬂﬂ 9
,
ﬂﬂ9 :
table
‡‡ 
:
‡‡ 
$str
‡‡ ,
,
‡‡, -
column
·· 
:
·· 
$str
·· $
)
··$ %
;
··% &
}
‚‚ 	
	protected
ÂÂ 
override
ÂÂ 
void
ÂÂ 
Down
ÂÂ  $
(
ÂÂ$ %
MigrationBuilder
ÂÂ% 5
migrationBuilder
ÂÂ6 F
)
ÂÂF G
{
ÊÊ 	
migrationBuilder
ÁÁ 
.
ÁÁ 
	DropTable
ÁÁ &
(
ÁÁ& '
name
ËË 
:
ËË 
$str
ËË %
)
ËË% &
;
ËË& '
migrationBuilder
ÍÍ 
.
ÍÍ 
	DropTable
ÍÍ &
(
ÍÍ& '
name
ÎÎ 
:
ÎÎ 
$str
ÎÎ $
)
ÎÎ$ %
;
ÎÎ% &
migrationBuilder
ÌÌ 
.
ÌÌ 
	DropTable
ÌÌ &
(
ÌÌ& '
name
ÓÓ 
:
ÓÓ 
$str
ÓÓ +
)
ÓÓ+ ,
;
ÓÓ, -
migrationBuilder
 
.
 
	DropTable
 &
(
& '
name
ÒÒ 
:
ÒÒ 
$str
ÒÒ $
)
ÒÒ$ %
;
ÒÒ% &
migrationBuilder
ÛÛ 
.
ÛÛ 
	DropTable
ÛÛ &
(
ÛÛ& '
name
ÙÙ 
:
ÙÙ 
$str
ÙÙ "
)
ÙÙ" #
;
ÙÙ# $
migrationBuilder
ˆˆ 
.
ˆˆ 
	DropTable
ˆˆ &
(
ˆˆ& '
name
˜˜ 
:
˜˜ 
$str
˜˜  
)
˜˜  !
;
˜˜! "
migrationBuilder
˘˘ 
.
˘˘ 
	DropTable
˘˘ &
(
˘˘& '
name
˙˙ 
:
˙˙ 
$str
˙˙ )
)
˙˙) *
;
˙˙* +
migrationBuilder
¸¸ 
.
¸¸ 
	DropTable
¸¸ &
(
¸¸& '
name
˝˝ 
:
˝˝ 
$str
˝˝ )
)
˝˝) *
;
˝˝* +
migrationBuilder
ˇˇ 
.
ˇˇ 
	DropTable
ˇˇ &
(
ˇˇ& '
name
Ä	Ä	 
:
Ä	Ä	 
$str
Ä	Ä	 %
)
Ä	Ä	% &
;
Ä	Ä	& '
migrationBuilder
Ç	Ç	 
.
Ç	Ç	 
	DropTable
Ç	Ç	 &
(
Ç	Ç	& '
name
É	É	 
:
É	É	 
$str
É	É	 &
)
É	É	& '
;
É	É	' (
migrationBuilder
Ö	Ö	 
.
Ö	Ö	 
	DropTable
Ö	Ö	 &
(
Ö	Ö	& '
name
Ü	Ü	 
:
Ü	Ü	 
$str
Ü	Ü	 '
)
Ü	Ü	' (
;
Ü	Ü	( )
migrationBuilder
à	à	 
.
à	à	 
	DropTable
à	à	 &
(
à	à	& '
name
â	â	 
:
â	â	 
$str
â	â	 "
)
â	â	" #
;
â	â	# $
migrationBuilder
ã	ã	 
.
ã	ã	 
	DropTable
ã	ã	 &
(
ã	ã	& '
name
å	å	 
:
å	å	 
$str
å	å	 )
)
å	å	) *
;
å	å	* +
migrationBuilder
é	é	 
.
é	é	 
	DropTable
é	é	 &
(
é	é	& '
name
è	è	 
:
è	è	 
$str
è	è	 '
)
è	è	' (
;
è	è	( )
migrationBuilder
ë	ë	 
.
ë	ë	 
	DropTable
ë	ë	 &
(
ë	ë	& '
name
í	í	 
:
í	í	 
$str
í	í	 /
)
í	í	/ 0
;
í	í	0 1
migrationBuilder
î	î	 
.
î	î	 
	DropTable
î	î	 &
(
î	î	& '
name
ï	ï	 
:
ï	ï	 
$str
ï	ï	 !
)
ï	ï	! "
;
ï	ï	" #
migrationBuilder
ó	ó	 
.
ó	ó	 
	DropTable
ó	ó	 &
(
ó	ó	& '
name
ò	ò	 
:
ò	ò	 
$str
ò	ò	 +
)
ò	ò	+ ,
;
ò	ò	, -
migrationBuilder
ö	ö	 
.
ö	ö	 
	DropTable
ö	ö	 &
(
ö	ö	& '
name
õ	õ	 
:
õ	õ	 
$str
õ	õ	 +
)
õ	õ	+ ,
;
õ	õ	, -
migrationBuilder
ù	ù	 
.
ù	ù	 
	DropTable
ù	ù	 &
(
ù	ù	& '
name
û	û	 
:
û	û	 
$str
û	û	 #
)
û	û	# $
;
û	û	$ %
migrationBuilder
†	†	 
.
†	†	 
	DropTable
†	†	 &
(
†	†	& '
name
°	°	 
:
°	°	 
$str
°	°	 (
)
°	°	( )
;
°	°	) *
migrationBuilder
£	£	 
.
£	£	 
	DropTable
£	£	 &
(
£	£	& '
name
§	§	 
:
§	§	 
$str
§	§	 
)
§	§	  
;
§	§	  !
migrationBuilder
¶	¶	 
.
¶	¶	 
	DropTable
¶	¶	 &
(
¶	¶	& '
name
ß	ß	 
:
ß	ß	 
$str
ß	ß	 #
)
ß	ß	# $
;
ß	ß	$ %
migrationBuilder
©	©	 
.
©	©	 
	DropTable
©	©	 &
(
©	©	& '
name
™	™	 
:
™	™	 
$str
™	™	 
)
™	™	 
;
™	™	 
migrationBuilder
¨	¨	 
.
¨	¨	 
	DropTable
¨	¨	 &
(
¨	¨	& '
name
≠	≠	 
:
≠	≠	 
$str
≠	≠	 !
)
≠	≠	! "
;
≠	≠	" #
migrationBuilder
Ø	Ø	 
.
Ø	Ø	 
	DropTable
Ø	Ø	 &
(
Ø	Ø	& '
name
∞	∞	 
:
∞	∞	 
$str
∞	∞	 "
)
∞	∞	" #
;
∞	∞	# $
migrationBuilder
≤	≤	 
.
≤	≤	 
	DropTable
≤	≤	 &
(
≤	≤	& '
name
≥	≥	 
:
≥	≥	 
$str
≥	≥	 
)
≥	≥	 
;
≥	≥	  
migrationBuilder
µ	µ	 
.
µ	µ	 
	DropTable
µ	µ	 &
(
µ	µ	& '
name
∂	∂	 
:
∂	∂	 
$str
∂	∂	 "
)
∂	∂	" #
;
∂	∂	# $
migrationBuilder
∏	∏	 
.
∏	∏	 
	DropTable
∏	∏	 &
(
∏	∏	& '
name
π	π	 
:
π	π	 
$str
π	π	  
)
π	π	  !
;
π	π	! "
migrationBuilder
ª	ª	 
.
ª	ª	 
	DropTable
ª	ª	 &
(
ª	ª	& '
name
º	º	 
:
º	º	 
$str
º	º	  
)
º	º	  !
;
º	º	! "
migrationBuilder
æ	æ	 
.
æ	æ	 
	DropTable
æ	æ	 &
(
æ	æ	& '
name
ø	ø	 
:
ø	ø	 
$str
ø	ø	 #
)
ø	ø	# $
;
ø	ø	$ %
migrationBuilder
¡	¡	 
.
¡	¡	 
	DropTable
¡	¡	 &
(
¡	¡	& '
name
¬	¬	 
:
¬	¬	 
$str
¬	¬	 
)
¬	¬	 
;
¬	¬	 
migrationBuilder
ƒ	ƒ	 
.
ƒ	ƒ	 
	DropTable
ƒ	ƒ	 &
(
ƒ	ƒ	& '
name
≈	≈	 
:
≈	≈	 
$str
≈	≈	 #
)
≈	≈	# $
;
≈	≈	$ %
}
∆	∆	 	
}
«	«	 
}»	»	 Ò(
Z/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/Repository.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
;% &
public 
class 

Repository 
< 
T 
> 
: 
IRepository (
<( )
T) *
>* +
where, 1
T2 3
:4 5

BaseEntity6 @
{		 
	protected

 
readonly

 
ItsToolDbContext

 '
_context

( 0
;

0 1
	protected 
readonly 
DbSet 
< 
T 
> 
_dbSet  &
;& '
public 


Repository 
( 
ItsToolDbContext &
context' .
). /
{ 
_context 
= 
context 
; 
_dbSet 
= 
context 
. 
Set 
< 
T 
> 
(  
)  !
;! "
} 
public 

async 
Task 
< 
IEnumerable !
<! "
T" #
># $
>$ %
GetAllAsync& 1
(1 2

Expression2 <
<< =
Func= A
<A B
TB C
,C D
boolE I
>I J
>J K
?K L
	predicateM V
=W X
nullY ]
)] ^
{ 

IQueryable 
< 
T 
> 
query 
= 
_dbSet $
.$ %
Where% *
(* +
e+ ,
=>- /
!0 1
e1 2
.2 3
	IsDeleted3 <
)< =
;= >
if 

( 
	predicate 
!= 
null 
) 
{ 	
query 
= 
query 
. 
Where 
(  
	predicate  )
)) *
;* +
} 	
return 
await 
query 
. 
ToListAsync &
(& '
)' (
;( )
} 
public 

async 
Task 
< 
T 
? 
> 
GetByIdAsync &
(& '
int' *
id+ -
)- .
{ 
return 
await 
_dbSet 
. 
FirstOrDefaultAsync /
(/ 0
e0 1
=>2 4
e5 6
.6 7
Id7 9
==: <
id= ?
&&@ B
!C D
eD E
.E F
	IsDeletedF O
)O P
;P Q
}   
public"" 

async"" 
Task"" 
<"" 
T"" 
>"" 
AddAsync"" !
(""! "
T""" #
entity""$ *
)""* +
{## 
_dbSet$$ 
.$$ 
Add$$ 
($$ 
entity$$ 
)$$ 
;$$ 
await%% 
_context%% 
.%% 
SaveChangesAsync%% '
(%%' (
)%%( )
;%%) *
return&& 
entity&& 
;&& 
}'' 
public)) 

async)) 
Task)) 
UpdateAsync)) !
())! "
T))" #
entity))$ *
)))* +
{** 
entity++ 
.++ 
	UpdatedAt++ 
=++ 
DateTime++ #
.++# $
UtcNow++$ *
;++* +
_dbSet,, 
.,, 
Update,, 
(,, 
entity,, 
),, 
;,, 
await-- 
_context-- 
.-- 
SaveChangesAsync-- '
(--' (
)--( )
;--) *
}.. 
public00 

async00 
Task00 
DeleteAsync00 !
(00! "
int00" %
id00& (
)00( )
{11 
var22 
entity22 
=22 
await22 
GetByIdAsync22 '
(22' (
id22( *
)22* +
;22+ ,
if33 

(33 
entity33 
!=33 
null33 
)33 
{44 	
entity55 
.55 
	IsDeleted55 
=55 
true55 #
;55# $
entity66 
.66 
	DeletedAt66 
=66 
DateTime66 '
.66' (
UtcNow66( .
;66. /
await77 
_context77 
.77 
SaveChangesAsync77 +
(77+ ,
)77, -
;77- .
}88 	
else99 
{:: 	
throw;; 
new;;  
KeyNotFoundException;; *
(;;* +
$";;+ -
{;;- .
typeof;;. 4
(;;4 5
T;;5 6
);;6 7
.;;7 8
Name;;8 <
};;< =
$str;;= G
";;G H
);;H I
;;;I J
}<< 	
}== 
}>> õ
g/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/ItsToolDbContextFactory.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
;% &
public 
class #
ItsToolDbContextFactory $
:% &'
IDesignTimeDbContextFactory' B
<B C
ItsToolDbContextC S
>S T
{		 
public

 

ItsToolDbContext

 
CreateDbContext

 +
(

+ ,
string

, 2
[

2 3
]

3 4
args

5 9
)

9 :
{ 
var 
environment 
= 
Environment %
.% &"
GetEnvironmentVariable& <
(< =
$str= U
)U V
??W Y
$strZ g
;g h
var 
basePath 
= 
Path 
. 
Combine #
(# $
	Directory$ -
.- .
GetCurrentDirectory. A
(A B
)B C
,C D
$strE U
)U V
;V W
if 

( 
! 
	Directory 
. 
Exists 
( 
basePath &
)& '
)' (
{ 	
basePath 
= 
Path 
. 
Combine #
(# $
	Directory$ -
.- .
GetCurrentDirectory. A
(A B
)B C
,C D
$strE V
)V W
;W X
} 	
var 
configuration 
= 
new  
ConfigurationBuilder  4
(4 5
)5 6
. 
SetBasePath 
( 
basePath !
)! "
. 
AddJsonFile 
( 
$str +
,+ ,
optional- 5
:5 6
false7 <
,< =
reloadOnChange> L
:L M
trueN R
)R S
. 
AddJsonFile 
( 
$" 
$str '
{' (
environment( 3
}3 4
$str4 9
"9 :
,: ;
optional< D
:D E
trueF J
)J K
. #
AddEnvironmentVariables $
($ %
)% &
. 
Build 
( 
) 
; 
var 
optionsBuilder 
= 
new  #
DbContextOptionsBuilder! 8
<8 9
ItsToolDbContext9 I
>I J
(J K
)K L
;L M
var!! 
connectionString!! 
=!! 
configuration!! ,
.!!, -
GetConnectionString!!- @
(!!@ A
$str!!A T
)!!T U
;!!U V
if"" 

("" 
string"" 
."" 
IsNullOrEmpty""  
(""  !
connectionString""! 1
)""1 2
)""2 3
{## 	
throw$$ 
new$$ %
InvalidOperationException$$ /
($$/ 0
$str$$0 b
)$$b c
;$$c d
}%% 	
optionsBuilder'' 
.'' 
	UseNpgsql''  
(''  !
connectionString''! 1
)''1 2
;''2 3
return)) 
new)) 
ItsToolDbContext)) #
())# $
optionsBuilder))$ 2
.))2 3
Options))3 :
))): ;
;)); <
}** 
}++ ™]
`/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/ItsToolDbContext.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
;% &
public 
class 
ItsToolDbContext 
: 
	DbContext  )
{ 
public 

ItsToolDbContext 
( 
DbContextOptions ,
<, -
ItsToolDbContext- =
>= >
options? F
)F G
:H I
baseJ N
(N O
optionsO V
)V W
{ 
} 
public 

DbSet 
< 

Department 
> 
Departments (
=>) +
Set, /
</ 0

Department0 :
>: ;
(; <
)< =
;= >
public 

DbSet 
< 
Group 
> 
Groups 
=> !
Set" %
<% &
Group& +
>+ ,
(, -
)- .
;. /
public 

DbSet 
< 
User 
> 
Users 
=> 
Set  #
<# $
User$ (
>( )
() *
)* +
;+ ,
public 

DbSet 
< 
GroupMember 
> 
GroupMembers *
=>+ -
Set. 1
<1 2
GroupMember2 =
>= >
(> ?
)? @
;@ A
public 

DbSet 
< 
Role 
> 
Roles 
=> 
Set  #
<# $
Role$ (
>( )
() *
)* +
;+ ,
public 

DbSet 
< 

Permission 
> 
Permissions (
=>) +
Set, /
</ 0

Permission0 :
>: ;
(; <
)< =
;= >
public 

DbSet 
< 
RolePermission 
>  
RolePermissions! 0
=>1 3
Set4 7
<7 8
RolePermission8 F
>F G
(G H
)H I
;I J
public   

DbSet   
<   
UserRole   
>   
	UserRoles   $
=>  % '
Set  ( +
<  + ,
UserRole  , 4
>  4 5
(  5 6
)  6 7
;  7 8
public!! 

DbSet!! 
<!! 
	GroupRole!! 
>!! 

GroupRoles!! &
=>!!' )
Set!!* -
<!!- .
	GroupRole!!. 7
>!!7 8
(!!8 9
)!!9 :
;!!: ;
public"" 

DbSet"" 
<"" "
UserPermissionOverride"" '
>""' (#
UserPermissionOverrides"") @
=>""A C
Set""D G
<""G H"
UserPermissionOverride""H ^
>""^ _
(""_ `
)""` a
;""a b
public%% 

DbSet%% 
<%% 
Project%% 
>%% 
Projects%% "
=>%%# %
Set%%& )
<%%) *
Project%%* 1
>%%1 2
(%%2 3
)%%3 4
;%%4 5
public&& 

DbSet&& 
<&& 
ProjectMember&& 
>&& 
ProjectMembers&&  .
=>&&/ 1
Set&&2 5
<&&5 6
ProjectMember&&6 C
>&&C D
(&&D E
)&&E F
;&&F G
public)) 

DbSet)) 
<)) 

TicketType)) 
>)) 
TicketTypes)) (
=>))) +
Set)), /
<))/ 0

TicketType))0 :
>)): ;
()); <
)))< =
;))= >
public** 

DbSet** 
<** 
Category** 
>** 

Categories** %
=>**& (
Set**) ,
<**, -
Category**- 5
>**5 6
(**6 7
)**7 8
;**8 9
public++ 

DbSet++ 
<++ 
Status++ 
>++ 
Statuses++ !
=>++" $
Set++% (
<++( )
Status++) /
>++/ 0
(++0 1
)++1 2
;++2 3
public,, 

DbSet,, 
<,, 
Priority,, 
>,, 

Priorities,, %
=>,,& (
Set,,) ,
<,,, -
Priority,,- 5
>,,5 6
(,,6 7
),,7 8
;,,8 9
public-- 

DbSet-- 
<-- 
Ticket-- 
>-- 
Tickets--  
=>--! #
Set--$ '
<--' (
Ticket--( .
>--. /
(--/ 0
)--0 1
;--1 2
public.. 

DbSet.. 
<.. 
TicketHistory.. 
>.. 
TicketHistories..  /
=>..0 2
Set..3 6
<..6 7
TicketHistory..7 D
>..D E
(..E F
)..F G
;..G H
public// 

DbSet// 
<// 
SystemAuditLog// 
>//  
SystemAuditLogs//! 0
=>//1 3
Set//4 7
<//7 8
SystemAuditLog//8 F
>//F G
(//G H
)//H I
;//I J
public00 

DbSet00 
<00 
Workflow00 
>00 
	Workflows00 $
=>00% '
Set00( +
<00+ ,
Workflow00, 4
>004 5
(005 6
)006 7
;007 8
public11 

DbSet11 
<11 
WorkflowTransition11 #
>11# $
WorkflowTransitions11% 8
=>119 ;
Set11< ?
<11? @
WorkflowTransition11@ R
>11R S
(11S T
)11T U
;11U V
public22 

DbSet22 
<22 
TicketComment22 
>22 
TicketComments22  .
=>22/ 1
Set222 5
<225 6
TicketComment226 C
>22C D
(22D E
)22E F
;22F G
public33 

DbSet33 
<33 
TicketAttachment33 !
>33! "
TicketAttachments33# 4
=>335 7
Set338 ;
<33; <
TicketAttachment33< L
>33L M
(33M N
)33N O
;33O P
public44 

DbSet44 
<44 
TicketWatcher44 
>44 
TicketWatchers44  .
=>44/ 1
Set442 5
<445 6
TicketWatcher446 C
>44C D
(44D E
)44E F
;44F G
public55 

DbSet55 
<55 
ProjectSequence55  
>55  !
ProjectSequences55" 2
=>553 5
Set556 9
<559 :
ProjectSequence55: I
>55I J
(55J K
)55K L
;55L M
public88 

DbSet88 
<88 
FieldDefinition88  
>88  !
FieldDefinitions88" 2
=>883 5
Set886 9
<889 :
FieldDefinition88: I
>88I J
(88J K
)88K L
;88L M
public99 

DbSet99 
<99 
FieldOption99 
>99 
FieldOptions99 *
=>99+ -
Set99. 1
<991 2
FieldOption992 =
>99= >
(99> ?
)99? @
;99@ A
public:: 

DbSet:: 
<:: 
FormFieldPlacement:: #
>::# $
FormFieldPlacements::% 8
=>::9 ;
Set::< ?
<::? @
FormFieldPlacement::@ R
>::R S
(::S T
)::T U
;::U V
public;; 

DbSet;; 
<;; 
TicketFieldValue;; !
>;;! "
TicketFieldValues;;# 4
=>;;5 7
Set;;8 ;
<;;; <
TicketFieldValue;;< L
>;;L M
(;;M N
);;N O
;;;O P
public>> 

DbSet>> 
<>> 
	SlaPolicy>> 
>>> 
SlaPolicies>> '
=>>>( *
Set>>+ .
<>>. /
	SlaPolicy>>/ 8
>>>8 9
(>>9 :
)>>: ;
;>>; <
public?? 

DbSet?? 
<?? 
	SlaTarget?? 
>?? 

SlaTargets?? &
=>??' )
Set??* -
<??- .
	SlaTarget??. 7
>??7 8
(??8 9
)??9 :
;??: ;
public@@ 

DbSet@@ 
<@@ 
BusinessHour@@ 
>@@ 
BusinessHours@@ ,
=>@@- /
Set@@0 3
<@@3 4
BusinessHour@@4 @
>@@@ A
(@@A B
)@@B C
;@@C D
publicAA 

DbSetAA 
<AA 
HolidayAA 
>AA 
HolidaysAA "
=>AA# %
SetAA& )
<AA) *
HolidayAA* 1
>AA1 2
(AA2 3
)AA3 4
;AA4 5
publicBB 

DbSetBB 
<BB 
	TicketSlaBB 
>BB 

TicketSlasBB &
=>BB' )
SetBB* -
<BB- .
	TicketSlaBB. 7
>BB7 8
(BB8 9
)BB9 :
;BB: ;
publicEE 

DbSetEE 
<EE 
NotificationRuleEE !
>EE! "
NotificationRulesEE# 4
=>EE5 7
SetEE8 ;
<EE; <
NotificationRuleEE< L
>EEL M
(EEM N
)EEN O
;EEO P
publicFF 

DbSetFF 
<FF 
NotificationFF 
>FF 
NotificationsFF ,
=>FF- /
SetFF0 3
<FF3 4
NotificationFF4 @
>FF@ A
(FFA B
)FFB C
;FFC D
publicII 

DbSetII 
<II 
AssignmentRuleII 
>II  
AssignmentRulesII! 0
=>II1 3
SetII4 7
<II7 8
AssignmentRuleII8 F
>IIF G
(IIG H
)IIH I
;III J
publicLL 

DbSetLL 
<LL 
SavedFilterLL 
>LL 
SavedFiltersLL *
=>LL+ -
SetLL. 1
<LL1 2
SavedFilterLL2 =
>LL= >
(LL> ?
)LL? @
;LL@ A
publicOO 

DbSetOO 
<OO 
KnowledgeCategoryOO "
>OO" #
KnowledgeCategoriesOO$ 7
=>OO8 :
SetOO; >
<OO> ?
KnowledgeCategoryOO? P
>OOP Q
(OOQ R
)OOR S
;OOS T
publicPP 

DbSetPP 
<PP 
KnowledgeArticlePP !
>PP! "
KnowledgeArticlesPP# 4
=>PP5 7
SetPP8 ;
<PP; <
KnowledgeArticlePP< L
>PPL M
(PPM N
)PPN O
;PPO P
publicSS 

DbSetSS 
<SS 
TicketSurveySS 
>SS 
TicketSurveysSS ,
=>SS- /
SetSS0 3
<SS3 4
TicketSurveySS4 @
>SS@ A
(SSA B
)SSB C
;SSC D
publicVV 

DbSetVV 
<VV 
WebhookSubscriptionVV $
>VV$ % 
WebhookSubscriptionsVV& :
=>VV; =
SetVV> A
<VVA B
WebhookSubscriptionVVB U
>VVU V
(VVV W
)VVW X
;VVX Y
	protectedXX 
overrideXX 
voidXX 
OnModelCreatingXX +
(XX+ ,
ModelBuilderXX, 8
modelBuilderXX9 E
)XXE F
{YY 
baseZZ 
.ZZ 
OnModelCreatingZZ 
(ZZ 
modelBuilderZZ )
)ZZ) *
;ZZ* +
modelBuilder[[ 
.[[ +
ApplyConfigurationsFromAssembly[[ 4
([[4 5
Assembly[[5 =
.[[= > 
GetExecutingAssembly[[> R
([[R S
)[[S T
)[[T U
;[[U V
}\\ 
}]] ˘
Z/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/DataSeeder.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
;% &
public

 
static

 
class

 
StatusConstants

 #
{ 
public 

const 
string 
Open 
= 
$str %
;% &
public 

const 
string 

InProgress "
=# $
$str% 3
;3 4
public 

const 
string 
OnHold 
=  
$str! ,
;, -
public 

const 
string 
Resolved  
=! "
$str# ,
;, -
public 

const 
string 
Closed 
=  
$str! ,
;, -
} 
public 
static 
class 
TransitionConstants '
{ 
public 

const 
string 
StartProgress %
=& '
$str( 8
;8 9
public 

const 
string 
	PutOnHold !
=" #
$str$ 1
;1 2
public 

const 
string 
Resolve 
=  !
$str" +
;+ ,
public 

const 
string 

MoveToOpen "
=# $
$str% 3
;3 4
public 

const 
string 
ResumeProgress &
=' (
$str) :
;: ;
public 

const 
string 
ReopenToOpen $
=% &
$str' 7
;7 8
public 

const 
string 
ReopenToProgress (
=) *
$str+ ?
;? @
public 

const 
string 
ReopenToPending '
=( )
$str* =
;= >
public 

const 
string 
ReopenToResolved (
=) *
$str+ ?
;? @
} 
public!! 
class!! 

DataSeeder!! 
{"" 
private## 
static## 
readonly## 
string## "
[##" #
]### $
ManagerPermissions##% 7
=##8 9
new##: =
[##= >
]##> ?
{##@ A
$str##B O
,##O P
$str##Q ]
,##] ^
$str##_ l
,##l m
$str##n }
,##} ~
$str	## ä
}
##ã å
;
##å ç
private$$ 
static$$ 
readonly$$ 
string$$ "
[$$" #
]$$# $
AgentPermissions$$% 5
=$$6 7
new$$8 ;
[$$; <
]$$< =
{$$> ?
$str$$@ M
,$$M N
PermissionConstants$$O b
.$$b c

TicketEdit$$c m
,$$m n 
PermissionConstants	$$o Ç
.
$$Ç É
TicketResolve
$$É ê
,
$$ê ë
$str
$$í ¢
,
$$¢ £
$str
$$§ ≠
}
$$Æ Ø
;
$$Ø ∞
private%% 
static%% 
readonly%% 
string%% "
[%%" #
]%%# $
EndUserPermissions%%% 7
=%%8 9
new%%: =
[%%= >
]%%> ?
{%%@ A
$str%%B Q
,%%Q R
$str%%S `
,%%` a
$str%%b q
,%%q r
$str%%s |
}%%} ~
;%%~ 
private'' 
readonly'' 
ItsToolDbContext'' %
_context''& .
;''. /
public)) 


DataSeeder)) 
()) 
ItsToolDbContext)) &
context))' .
))). /
{** 
_context++ 
=++ 
context++ 
;++ 
},, 
public.. 

async.. 
Task.. 
	SeedAsync.. 
(..  
)..  !
{// 
await//  
SeedTicketTypesAsync// '
(//' (
)//( )
;//) *
await00 
SeedStatusesAsync00 
(00  
)00  !
;00! "
await11 
SeedPrioritiesAsync11 !
(11! "
)11" #
;11# $
await22 )
SeedDepartmentsAndGroupsAsync22 +
(22+ ,
)22, -
;22- .
await33 (
SeedRolesAndPermissionsAsync33 *
(33* +
)33+ ,
;33, -
await44 
SeedUsersAsync44 
(44 
)44 
;44 
await55 *
SeedProjectsAndCategoriesAsync55 ,
(55, -
)55- .
;55. /
await66 "
SeedDynamicFieldsAsync66 $
(66$ %
)66% &
;66& '
await77  
SeedSlaPoliciesAsync77 "
(77" #
)77# $
;77$ %
await88 (
SeedWorkflowTransitionsAsync88 *
(88* +
)88+ ,
;88, -
await99 "
SeedKnowledgeBaseAsync99 $
(99$ %
)99% &
;99& '
};; 
private== 
async== 
Task==  
SeedTicketTypesAsync== +
(==+ ,
)==, -
{>> 
if@@ 

(@@ 
!@@ 
await@@ 
_context@@ 
.@@ 
TicketTypes@@ '
.@@' (
AnyAsync@@( 0
(@@0 1
)@@1 2
)@@2 3
{AA 	
_contextBB 
.BB 
TicketTypesBB  
.BB  !
AddRangeBB! )
(BB) *
newCC 

TicketTypeCC 
{CC  
NameCC! %
=CC& '
$strCC( 2
}CC3 4
,CC4 5
newDD 

TicketTypeDD 
{DD  
NameDD! %
=DD& '
$strDD( 9
}DD: ;
)EE 
;EE 
}FF 	
}GG 
privateII 
asyncII 
TaskII 
SeedStatusesAsyncII (
(II( )
)II) *
{JJ 
ifLL 

(LL 
!LL 
awaitLL 
_contextLL 
.LL 
StatusesLL $
.LL$ %
AnyAsyncLL% -
(LL- .
)LL. /
)LL/ 0
{MM 	
_contextNN 
.NN 
StatusesNN 
.NN 
AddRangeNN &
(NN& '
newOO 
StatusOO 
{OO 
NameOO !
=OO" #
StatusConstantsOO$ 3
.OO3 4
OpenOO4 8
,OO8 9
	SortOrderOO: C
=OOD E
$numOOF G
,OOG H
IsSystemDefaultOOI X
=OOY Z
trueOO[ _
}OO` a
,OOa b
newPP 
StatusPP 
{PP 
NamePP !
=PP" #
StatusConstantsPP$ 3
.PP3 4

InProgressPP4 >
,PP> ?
	SortOrderPP@ I
=PPJ K
$numPPL M
}PPN O
,PPO P
newQQ 
StatusQQ 
{QQ 
NameQQ !
=QQ" #
StatusConstantsQQ$ 3
.QQ3 4
OnHoldQQ4 :
,QQ: ;
	SortOrderQQ< E
=QQF G
$numQQH I
,QQI J
	PausesSlaQQK T
=QQU V
trueQQW [
}QQ\ ]
,QQ] ^
newRR 
StatusRR 
{RR 
NameRR !
=RR" #
StatusConstantsRR$ 3
.RR3 4
ResolvedRR4 <
,RR< =
	SortOrderRR> G
=RRH I
$numRRJ K
,RRK L
IsClosedStatusRRM [
=RR\ ]
trueRR^ b
}RRc d
,RRd e
newSS 
StatusSS 
{SS 
NameSS !
=SS" #
StatusConstantsSS$ 3
.SS3 4
ClosedSS4 :
,SS: ;
	SortOrderSS< E
=SSF G
$numSSH I
,SSI J
IsClosedStatusSSK Y
=SSZ [
trueSS\ `
}SSa b
)TT 
;TT 
}UU 	
}VV 
privateXX 
asyncXX 
TaskXX 
SeedPrioritiesAsyncXX *
(XX* +
)XX+ ,
{YY 
if[[ 

([[ 
![[ 
await[[ 
_context[[ 
.[[ 

Priorities[[ &
.[[& '
AnyAsync[[' /
([[/ 0
)[[0 1
)[[1 2
{\\ 	
_context]] 
.]] 

Priorities]] 
.]]  
AddRange]]  (
(]]( )
new^^ 
Priority^^ 
{^^ 
Name^^ #
=^^$ %
$str^^& .
,^^. /
Weight^^0 6
=^^7 8
$num^^9 <
,^^< =
SeverityLevel^^> K
=^^L M
$num^^N O
}^^P Q
,^^Q R
new__ 
Priority__ 
{__ 
Name__ #
=__$ %
$str__& .
,__. /
Weight__0 6
=__7 8
$num__9 ;
,__; <
SeverityLevel__= J
=__K L
$num__M N
}__O P
,__P Q
new`` 
Priority`` 
{`` 
Name`` #
=``$ %
$str``& ,
,``, -
Weight``. 4
=``5 6
$num``7 9
,``9 :
SeverityLevel``; H
=``I J
$num``K L
}``M N
,``N O
newaa 
Priorityaa 
{aa 
Nameaa #
=aa$ %
$straa& -
,aa- .
Weightaa/ 5
=aa6 7
$numaa8 :
,aa: ;
SeverityLevelaa< I
=aaJ K
$numaaL M
}aaN O
)bb 
;bb 
}cc 	
}dd 
privateff 
asyncff 
Taskff )
SeedDepartmentsAndGroupsAsyncff 4
(ff4 5
)ff5 6
{gg 
ifii 

(ii 
!ii 
awaitii 
_contextii 
.ii 
Departmentsii '
.ii' (
AnyAsyncii( 0
(ii0 1
)ii1 2
)ii2 3
{jj 	
_contextkk 
.kk 
Departmentskk  
.kk  !
AddRangekk! )
(kk) *
newll 

Departmentll 
{ll  
Namell! %
=ll& '
$strll( =
}ll> ?
,ll? @
newmm 

Departmentmm 
{mm  
Namemm! %
=mm& '
$strmm( :
}mm; <
)nn 
;nn 
}oo 	
awaitpp 
_contextpp 
.pp 
SaveChangesAsyncpp '
(pp' (
)pp( )
;pp) *
varrr 
itDeptrr 
=rr 
awaitrr 
_contextrr #
.rr# $
Departmentsrr$ /
.rr/ 0
FirstOrDefaultAsyncrr0 C
(rrC D
drrD E
=>rrF H
drrI J
.rrJ K
NamerrK O
==rrP R
$strrrS h
)rrh i
;rri j
iftt 

(tt 
!tt 
awaittt 
_contexttt 
.tt 
Groupstt "
.tt" #
AnyAsynctt# +
(tt+ ,
)tt, -
&&tt. 0
itDepttt1 7
!=tt8 :
nulltt; ?
)tt? @
{uu 	
_contextvv 
.vv 
Groupsvv 
.vv 
AddRangevv $
(vv$ %
newww 
Groupww 
{ww 
Nameww  
=ww! "
$strww# 3
,ww3 4
DepartmentIdww5 A
=wwB C
itDeptwwD J
.wwJ K
IdwwK M
}wwN O
,wwO P
newxx 
Groupxx 
{xx 
Namexx  
=xx! "
$strxx# ;
,xx; <
DepartmentIdxx= I
=xxJ K
itDeptxxL R
.xxR S
IdxxS U
}xxV W
,xxW X
newyy 
Groupyy 
{yy 
Nameyy  
=yy! "
$stryy# 9
,yy9 :
DepartmentIdyy; G
=yyH I
itDeptyyJ P
.yyP Q
IdyyQ S
}yyT U
,yyU V
newzz 
Groupzz 
{zz 
Namezz  
=zz! "
$strzz# 3
,zz3 4
DepartmentIdzz5 A
=zzB C
itDeptzzD J
.zzJ K
IdzzK M
}zzN O
){{ 
;{{ 
await|| 
_context|| 
.|| 
SaveChangesAsync|| +
(||+ ,
)||, -
;||- .
}}} 	
}~~ 
private
ÄÄ 
async
ÄÄ 
Task
ÄÄ *
SeedRolesAndPermissionsAsync
ÄÄ 3
(
ÄÄ3 4
)
ÄÄ4 5
{
ÅÅ 
var
ÉÉ 
allPermissions
ÉÉ 
=
ÉÉ 
ItsTool
ÉÉ $
.
ÉÉ$ %
Application
ÉÉ% 0
.
ÉÉ0 1
	Constants
ÉÉ1 :
.
ÉÉ: ;!
PermissionConstants
ÉÉ; N
.
ÉÉN O
AllPermissions
ÉÉO ]
;
ÉÉ] ^
var
ÑÑ !
existingPermissions
ÑÑ 
=
ÑÑ  !
await
ÑÑ" '
_context
ÑÑ( 0
.
ÑÑ0 1
Permissions
ÑÑ1 <
.
ÑÑ< =
ToListAsync
ÑÑ= H
(
ÑÑH I
)
ÑÑI J
;
ÑÑJ K
var
ÜÜ  
missingPermissions
ÜÜ 
=
ÜÜ  
allPermissions
ÜÜ! /
.
ÜÜ/ 0
Where
ÜÜ0 5
(
ÜÜ5 6
pKey
ÜÜ6 :
=>
ÜÜ; =
!
ÜÜ> ?!
existingPermissions
ÜÜ? R
.
ÜÜR S
Any
ÜÜS V
(
ÜÜV W
p
ÜÜW X
=>
ÜÜY [
p
ÜÜ\ ]
.
ÜÜ] ^
Key
ÜÜ^ a
==
ÜÜb d
pKey
ÜÜe i
)
ÜÜi j
)
ÜÜj k
.
ÜÜk l
Select
ÜÜl r
(
ÜÜr s
pKey
ÜÜs w
=>
ÜÜx z
new
ÜÜ{ ~

PermissionÜÜ â
{ÜÜä ã
NameÜÜå ê
=ÜÜë í
pKeyÜÜì ó
,ÜÜó ò
KeyÜÜô ú
=ÜÜù û
pKeyÜÜü £
}ÜÜ§ •
)ÜÜ• ¶
.ÜÜ¶ ß
ToListÜÜß ≠
(ÜÜ≠ Æ
)ÜÜÆ Ø
;ÜÜØ ∞
if
áá 

(
áá  
missingPermissions
áá 
.
áá 
Count
áá $
>
áá% &
$num
áá' (
)
áá( )
{
àà 	
_context
ââ 
.
ââ 
Permissions
ââ  
.
ââ  !
AddRange
ââ! )
(
ââ) * 
missingPermissions
ââ* <
)
ââ< =
;
ââ= >!
existingPermissions
ää 
.
ää  
AddRange
ää  (
(
ää( ) 
missingPermissions
ää) ;
)
ää; <
;
ää< =
}
ãã 	
await
åå 
_context
åå 
.
åå 
SaveChangesAsync
åå '
(
åå' (
)
åå( )
;
åå) *
var
éé 
rolesToSeed
éé 
=
éé 
new
éé 

Dictionary
éé (
<
éé( )
string
éé) /
,
éé/ 0
string
éé1 7
[
éé7 8
]
éé8 9
>
éé9 :
{
èè 	
{
êê 
$str
êê 
,
êê 
allPermissions
êê *
.
êê* +
ToArray
êê+ 2
(
êê2 3
)
êê3 4
}
êê5 6
,
êê6 7
{
ëë 
$str
ëë 
,
ëë  
ManagerPermissions
ëë +
}
ëë, -
,
ëë- .
{
íí 
$str
íí 
,
íí 
AgentPermissions
íí '
}
íí( )
,
íí) *
{
ìì 
$str
ìì 
,
ìì  
EndUserPermissions
ìì +
}
ìì, -
}
îî 	
;
îî	 

var
ññ 
existingRoles
ññ 
=
ññ 
await
ññ !
_context
ññ" *
.
ññ* +
Roles
ññ+ 0
.
ññ0 1
Include
ññ1 8
(
ññ8 9
r
ññ9 :
=>
ññ; =
r
ññ> ?
.
ññ? @
RolePermissions
ññ@ O
)
ññO P
.
ññP Q
ToListAsync
ññQ \
(
ññ\ ]
)
ññ] ^
;
ññ^ _
foreach
òò 
(
òò 
var
òò 
kvp
òò 
in
òò 
rolesToSeed
òò '
)
òò' (
{
ôô 	
var
öö 
role
öö 
=
öö 
existingRoles
öö $
.
öö$ %
FirstOrDefault
öö% 3
(
öö3 4
r
öö4 5
=>
öö6 8
r
öö9 :
.
öö: ;
Name
öö; ?
==
öö@ B
kvp
ööC F
.
ööF G
Key
ööG J
)
ööJ K
;
ööK L
if
õõ 
(
õõ 
role
õõ 
==
õõ 
null
õõ 
)
õõ 
{
úú 
role
ùù 
=
ùù 
new
ùù 
Role
ùù 
{
ùù  !
Name
ùù" &
=
ùù' (
kvp
ùù) ,
.
ùù, -
Key
ùù- 0
}
ùù1 2
;
ùù2 3
_context
ûû 
.
ûû 
Roles
ûû 
.
ûû 
Add
ûû "
(
ûû" #
role
ûû# '
)
ûû' (
;
ûû( )
existingRoles
üü 
.
üü 
Add
üü !
(
üü! "
role
üü" &
)
üü& '
;
üü' (
await
†† 
_context
†† 
.
†† 
SaveChangesAsync
†† /
(
††/ 0
)
††0 1
;
††1 2
}
°° 
foreach
££ 
(
££ 
var
££ 
permKey
££  
in
££! #
kvp
££$ '
.
££' (
Value
££( -
)
££- .
{
§§ 
var
•• 
perm
•• 
=
•• !
existingPermissions
•• .
.
••. /
FirstOrDefault
••/ =
(
••= >
p
••> ?
=>
••@ B
p
••C D
.
••D E
Key
••E H
==
••I K
permKey
••L S
)
••S T
;
••T U
if
¶¶ 
(
¶¶ 
perm
¶¶ 
!=
¶¶ 
null
¶¶  
&&
¶¶! #
!
¶¶$ %
role
¶¶% )
.
¶¶) *
RolePermissions
¶¶* 9
.
¶¶9 :
Any
¶¶: =
(
¶¶= >
rp
¶¶> @
=>
¶¶A C
rp
¶¶D F
.
¶¶F G
PermissionId
¶¶G S
==
¶¶T V
perm
¶¶W [
.
¶¶[ \
Id
¶¶\ ^
)
¶¶^ _
)
¶¶_ `
{
ßß 
_context
®® 
.
®® 
RolePermissions
®® ,
.
®®, -
Add
®®- 0
(
®®0 1
new
®®1 4
RolePermission
®®5 C
{
®®D E
RoleId
®®F L
=
®®M N
role
®®O S
.
®®S T
Id
®®T V
,
®®V W
PermissionId
®®X d
=
®®e f
perm
®®g k
.
®®k l
Id
®®l n
}
®®o p
)
®®p q
;
®®q r
}
©© 
}
™™ 
}
´´ 	
await
¨¨ 
_context
¨¨ 
.
¨¨ 
SaveChangesAsync
¨¨ '
(
¨¨' (
)
¨¨( )
;
¨¨) *
}
≠≠ 
private
ØØ 
async
ØØ 
Task
ØØ 
SeedUsersAsync
ØØ %
(
ØØ% &
)
ØØ& '
{
∞∞ 
var
±± 
itDept
±± 
=
±± 
await
±± 
_context
±± #
.
±±# $
Departments
±±$ /
.
±±/ 0!
FirstOrDefaultAsync
±±0 C
(
±±C D
d
±±D E
=>
±±F H
d
±±I J
.
±±J K
Name
±±K O
==
±±P R
$str
±±S h
)
±±h i
;
±±i j
var
≤≤ 
existingRoles
≤≤ 
=
≤≤ 
await
≤≤ !
_context
≤≤" *
.
≤≤* +
Roles
≤≤+ 0
.
≤≤0 1
ToListAsync
≤≤1 <
(
≤≤< =
)
≤≤= >
;
≤≤> ?
var
≥≥ !
existingPermissions
≥≥ 
=
≥≥  !
await
≥≥" '
_context
≥≥( 0
.
≥≥0 1
Permissions
≥≥1 <
.
≥≥< =
ToListAsync
≥≥= H
(
≥≥H I
)
≥≥I J
;
≥≥J K
var
µµ 
usersToSeed
µµ 
=
µµ 
new
µµ 
List
µµ "
<
µµ" #
(
µµ# $
string
µµ$ *
Username
µµ+ 3
,
µµ3 4
string
µµ5 ;
Password
µµ< D
,
µµD E
string
µµF L
Role
µµM Q
,
µµQ R
string
µµS Y
	FirstName
µµZ c
,
µµc d
string
µµe k
LastName
µµl t
)
µµt u
>
µµu v
{
∂∂ 	
(
∑∑ 
$str
∑∑ 
,
∑∑ 
$str
∑∑ !
,
∑∑! "
$str
∑∑# /
,
∑∑/ 0
$str
∑∑1 9
,
∑∑9 :
$str
∑∑; B
)
∑∑B C
,
∑∑C D
(
∏∏ 
$str
∏∏ 
,
∏∏ 
$str
∏∏ %
,
∏∏% &
$str
∏∏' 0
,
∏∏0 1
$str
∏∏2 6
,
∏∏6 7
$str
∏∏8 A
)
∏∏A B
,
∏∏B C
(
ππ 
$str
ππ 
,
ππ 
$str
ππ "
,
ππ" #
$str
ππ$ +
,
ππ+ ,
$str
ππ- 7
,
ππ7 8
$str
ππ9 B
)
ππB C
,
ππC D
(
∫∫ 
$str
∫∫ 
,
∫∫ 
$str
∫∫ "
,
∫∫" #
$str
∫∫$ +
,
∫∫+ ,
$str
∫∫- 7
,
∫∫7 8
$str
∫∫9 B
)
∫∫B C
,
∫∫C D
(
ªª 
$str
ªª 
,
ªª 
$str
ªª  
,
ªª  !
$str
ªª" +
,
ªª+ ,
$str
ªª- 2
,
ªª2 3
$str
ªª4 :
)
ªª: ;
}
ºº 	
;
ºº	 

var
ææ 
existingUsers
ææ 
=
ææ 
await
ææ !
_context
ææ" *
.
ææ* +
Users
ææ+ 0
.
ææ0 1
Include
ææ1 8
(
ææ8 9
u
ææ9 :
=>
ææ; =
u
ææ> ?
.
ææ? @
	UserRoles
ææ@ I
)
ææI J
.
ææJ K
Include
ææK R
(
ææR S
u
ææS T
=>
ææU W
u
ææX Y
.
ææY Z!
PermissionOverrides
ææZ m
)
ææm n
.
ææn o
ToListAsync
ææo z
(
ææz {
)
ææ{ |
;
ææ| }
foreach
¿¿ 
(
¿¿ 
var
¿¿ 
u
¿¿ 
in
¿¿ 
usersToSeed
¿¿ %
)
¿¿% &
{
¡¡ 	
await
¬¬ %
CreateOrUpdateUserAsync
¬¬ )
(
¬¬) *
u
¬¬* +
,
¬¬+ ,
existingUsers
¬¬- :
,
¬¬: ;
itDept
¬¬< B
,
¬¬B C
existingRoles
¬¬D Q
,
¬¬Q R!
existingPermissions
¬¬S f
)
¬¬f g
;
¬¬g h
}
√√ 	
await
ƒƒ 
_context
ƒƒ 
.
ƒƒ 
SaveChangesAsync
ƒƒ '
(
ƒƒ' (
)
ƒƒ( )
;
ƒƒ) *
}
≈≈ 
private
«« 
async
«« 
Task
«« ,
SeedProjectsAndCategoriesAsync
«« 5
(
««5 6
)
««6 7
{
»» 
if
   

(
   
!
   
await
   
_context
   
.
   
Projects
   $
.
  $ %
AnyAsync
  % -
(
  - .
)
  . /
)
  / 0
{
ÀÀ 	
_context
ÃÃ 
.
ÃÃ 
Projects
ÃÃ 
.
ÃÃ 
AddRange
ÃÃ &
(
ÃÃ& '
new
ÕÕ 
ItsTool
ÕÕ 
.
ÕÕ 
Domain
ÕÕ "
.
ÕÕ" #
Entities
ÕÕ# +
.
ÕÕ+ ,
Project
ÕÕ, 3
.
ÕÕ3 4
Project
ÕÕ4 ;
{
ÕÕ< =
Name
ÕÕ> B
=
ÕÕC D
$str
ÕÕE P
,
ÕÕP Q

ProjectKey
ÕÕR \
=
ÕÕ] ^
$str
ÕÕ_ d
}
ÕÕe f
,
ÕÕf g
new
ŒŒ 
ItsTool
ŒŒ 
.
ŒŒ 
Domain
ŒŒ "
.
ŒŒ" #
Entities
ŒŒ# +
.
ŒŒ+ ,
Project
ŒŒ, 3
.
ŒŒ3 4
Project
ŒŒ4 ;
{
ŒŒ< =
Name
ŒŒ> B
=
ŒŒC D
$str
ŒŒE W
,
ŒŒW X

ProjectKey
ŒŒY c
=
ŒŒd e
$str
ŒŒf j
}
ŒŒk l
,
ŒŒl m
new
œœ 
ItsTool
œœ 
.
œœ 
Domain
œœ "
.
œœ" #
Entities
œœ# +
.
œœ+ ,
Project
œœ, 3
.
œœ3 4
Project
œœ4 ;
{
œœ< =
Name
œœ> B
=
œœC D
$str
œœE Y
,
œœY Z

ProjectKey
œœ[ e
=
œœf g
$str
œœh m
}
œœn o
,
œœo p
new
–– 
ItsTool
–– 
.
–– 
Domain
–– "
.
––" #
Entities
––# +
.
––+ ,
Project
––, 3
.
––3 4
Project
––4 ;
{
––< =
Name
––> B
=
––C D
$str
––E W
,
––W X

ProjectKey
––Y c
=
––d e
$str
––f k
}
––l m
,
––m n
new
—— 
ItsTool
—— 
.
—— 
Domain
—— "
.
——" #
Entities
——# +
.
——+ ,
Project
——, 3
.
——3 4
Project
——4 ;
{
——< =
Name
——> B
=
——C D
$str
——E ]
,
——] ^

ProjectKey
——_ i
=
——j k
$str
——l q
}
——r s
)
““ 
;
““ 
await
”” 
_context
”” 
.
”” 
SaveChangesAsync
”” +
(
””+ ,
)
””, -
;
””- .
}
‘‘ 	
var
÷÷ 

itsProject
÷÷ 
=
÷÷ 
await
÷÷ 
_context
÷÷ '
.
÷÷' (
Projects
÷÷( 0
.
÷÷0 1!
FirstOrDefaultAsync
÷÷1 D
(
÷÷D E
p
÷÷E F
=>
÷÷G I
p
÷÷J K
.
÷÷K L

ProjectKey
÷÷L V
==
÷÷W Y
$str
÷÷Z _
)
÷÷_ `
;
÷÷` a
if
◊◊ 

(
◊◊ 
!
◊◊ 
await
◊◊ 
_context
◊◊ 
.
◊◊ 

Categories
◊◊ &
.
◊◊& '
AnyAsync
◊◊' /
(
◊◊/ 0
)
◊◊0 1
&&
◊◊2 4

itsProject
◊◊5 ?
!=
◊◊@ B
null
◊◊C G
)
◊◊G H
{
ÿÿ 	
_context
ŸŸ 
.
ŸŸ 

Categories
ŸŸ 
.
ŸŸ  
AddRange
ŸŸ  (
(
ŸŸ( )
new
⁄⁄ 
ItsTool
⁄⁄ 
.
⁄⁄ 
Domain
⁄⁄ "
.
⁄⁄" #
Entities
⁄⁄# +
.
⁄⁄+ ,
Ticket
⁄⁄, 2
.
⁄⁄2 3
Category
⁄⁄3 ;
{
⁄⁄< =
Name
⁄⁄> B
=
⁄⁄C D
$str
⁄⁄E V
,
⁄⁄V W
	ProjectId
⁄⁄X a
=
⁄⁄b c

itsProject
⁄⁄d n
.
⁄⁄n o
Id
⁄⁄o q
}
⁄⁄r s
,
⁄⁄s t
new
€€ 
ItsTool
€€ 
.
€€ 
Domain
€€ "
.
€€" #
Entities
€€# +
.
€€+ ,
Ticket
€€, 2
.
€€2 3
Category
€€3 ;
{
€€< =
Name
€€> B
=
€€C D
$str
€€E U
,
€€U V
	ProjectId
€€W `
=
€€a b

itsProject
€€c m
.
€€m n
Id
€€n p
}
€€q r
,
€€r s
new
‹‹ 
ItsTool
‹‹ 
.
‹‹ 
Domain
‹‹ "
.
‹‹" #
Entities
‹‹# +
.
‹‹+ ,
Ticket
‹‹, 2
.
‹‹2 3
Category
‹‹3 ;
{
‹‹< =
Name
‹‹> B
=
‹‹C D
$str
‹‹E T
,
‹‹T U
	ProjectId
‹‹V _
=
‹‹` a

itsProject
‹‹b l
.
‹‹l m
Id
‹‹m o
}
‹‹p q
)
›› 
;
›› 
await
ﬁﬁ 
_context
ﬁﬁ 
.
ﬁﬁ 
SaveChangesAsync
ﬁﬁ +
(
ﬁﬁ+ ,
)
ﬁﬁ, -
;
ﬁﬁ- .
}
ﬂﬂ 	
}
‡‡ 
private
‚‚ 
async
‚‚ 
Task
‚‚ $
SeedDynamicFieldsAsync
‚‚ -
(
‚‚- .
)
‚‚. /
{
„„ 
if
ÂÂ 

(
ÂÂ 
!
ÂÂ 
await
ÂÂ 
_context
ÂÂ 
.
ÂÂ 
FieldDefinitions
ÂÂ ,
.
ÂÂ, -
AnyAsync
ÂÂ- 5
(
ÂÂ5 6
)
ÂÂ6 7
)
ÂÂ7 8
{
ÊÊ 	
var
ÁÁ 
serverNameField
ÁÁ 
=
ÁÁ  !
new
ÁÁ" %
ItsTool
ÁÁ& -
.
ÁÁ- .
Domain
ÁÁ. 4
.
ÁÁ4 5
Entities
ÁÁ5 =
.
ÁÁ= >
Config
ÁÁ> D
.
ÁÁD E
FieldDefinition
ÁÁE T
{
ÁÁU V
Key
ÁÁW Z
=
ÁÁ[ \
$str
ÁÁ] i
,
ÁÁi j
Label
ÁÁk p
=
ÁÁq r
$str
ÁÁs 
,ÁÁ Ä
	FieldTypeÁÁÅ ä
=ÁÁã å
ItsToolÁÁç î
.ÁÁî ï
DomainÁÁï õ
.ÁÁõ ú
EntitiesÁÁú §
.ÁÁ§ •
ConfigÁÁ• ´
.ÁÁ´ ¨
	FieldTypeÁÁ¨ µ
.ÁÁµ ∂
TextÁÁ∂ ∫
}ÁÁª º
;ÁÁº Ω
var
ËË  
impactedUsersField
ËË "
=
ËË# $
new
ËË% (
ItsTool
ËË) 0
.
ËË0 1
Domain
ËË1 7
.
ËË7 8
Entities
ËË8 @
.
ËË@ A
Config
ËËA G
.
ËËG H
FieldDefinition
ËËH W
{
ËËX Y
Key
ËËZ ]
=
ËË^ _
$str
ËË` x
,
ËËx y
Label
ËËz 
=ËËÄ Å
$strËËÇ û
,ËËû ü
	FieldTypeËË† ©
=ËË™ ´
ItsToolËË¨ ≥
.ËË≥ ¥
DomainËË¥ ∫
.ËË∫ ª
EntitiesËËª √
.ËË√ ƒ
ConfigËËƒ  
.ËË  À
	FieldTypeËËÀ ‘
.ËË‘ ’
NumberËË’ €
}ËË‹ ›
;ËË› ﬁ
_context
ÈÈ 
.
ÈÈ 
FieldDefinitions
ÈÈ %
.
ÈÈ% &
AddRange
ÈÈ& .
(
ÈÈ. /
serverNameField
ÈÈ/ >
,
ÈÈ> ? 
impactedUsersField
ÈÈ@ R
)
ÈÈR S
;
ÈÈS T
await
ÍÍ 
_context
ÍÍ 
.
ÍÍ 
SaveChangesAsync
ÍÍ +
(
ÍÍ+ ,
)
ÍÍ, -
;
ÍÍ- .
var
ÏÏ 

hwCategory
ÏÏ 
=
ÏÏ 
await
ÏÏ "
_context
ÏÏ# +
.
ÏÏ+ ,

Categories
ÏÏ, 6
.
ÏÏ6 7!
FirstOrDefaultAsync
ÏÏ7 J
(
ÏÏJ K
c
ÏÏK L
=>
ÏÏM O
c
ÏÏP Q
.
ÏÏQ R
Name
ÏÏR V
==
ÏÏW Y
$str
ÏÏZ k
)
ÏÏk l
;
ÏÏl m
if
ÌÌ 
(
ÌÌ 

hwCategory
ÌÌ 
!=
ÌÌ 
null
ÌÌ "
)
ÌÌ" #
{
ÓÓ 
_context
ÔÔ 
.
ÔÔ !
FormFieldPlacements
ÔÔ ,
.
ÔÔ, -
AddRange
ÔÔ- 5
(
ÔÔ5 6
new
 
ItsTool
 
.
  
Domain
  &
.
& '
Entities
' /
.
/ 0
Config
0 6
.
6 7 
FormFieldPlacement
7 I
{
J K

CategoryId
L V
=
W X

hwCategory
Y c
.
c d
Id
d f
,
f g
FieldDefinitionId
h y
=
z {
serverNameField| ã
.ã å
Idå é
,é è
	SortOrderê ô
=ö õ
$numú ù
,ù û

IsRequiredü ©
=™ ´
true¨ ∞
}± ≤
,≤ ≥
new
ÒÒ 
ItsTool
ÒÒ 
.
ÒÒ  
Domain
ÒÒ  &
.
ÒÒ& '
Entities
ÒÒ' /
.
ÒÒ/ 0
Config
ÒÒ0 6
.
ÒÒ6 7 
FormFieldPlacement
ÒÒ7 I
{
ÒÒJ K

CategoryId
ÒÒL V
=
ÒÒW X

hwCategory
ÒÒY c
.
ÒÒc d
Id
ÒÒd f
,
ÒÒf g
FieldDefinitionId
ÒÒh y
=
ÒÒz {!
impactedUsersFieldÒÒ| é
.ÒÒé è
IdÒÒè ë
,ÒÒë í
	SortOrderÒÒì ú
=ÒÒù û
$numÒÒü †
,ÒÒ† °

IsRequiredÒÒ¢ ¨
=ÒÒ≠ Æ
falseÒÒØ ¥
}ÒÒµ ∂
)
ÚÚ 
;
ÚÚ 
await
ÛÛ 
_context
ÛÛ 
.
ÛÛ 
SaveChangesAsync
ÛÛ /
(
ÛÛ/ 0
)
ÛÛ0 1
;
ÛÛ1 2
}
ÙÙ 
}
ıı 	
}
ˆˆ 
private
¯¯ 
async
¯¯ 
Task
¯¯ "
SeedSlaPoliciesAsync
¯¯ +
(
¯¯+ ,
)
¯¯, -
{
˘˘ 
if
˚˚ 

(
˚˚ 
!
˚˚ 
await
˚˚ 
_context
˚˚ 
.
˚˚ 
SlaPolicies
˚˚ '
.
˚˚' (
AnyAsync
˚˚( 0
(
˚˚0 1
)
˚˚1 2
)
˚˚2 3
{
¸¸ 	
var
˝˝ 
policy
˝˝ 
=
˝˝ 
new
˝˝ 
	SlaPolicy
˝˝ &
{
˝˝' (
Name
˝˝) -
=
˝˝. /
$str
˝˝0 D
,
˝˝D E
Description
˝˝F Q
=
˝˝R S
$str
˝˝T {
}
˝˝| }
;
˝˝} ~
_context
˛˛ 
.
˛˛ 
SlaPolicies
˛˛  
.
˛˛  !
Add
˛˛! $
(
˛˛$ %
policy
˛˛% +
)
˛˛+ ,
;
˛˛, -
await
ˇˇ 
_context
ˇˇ 
.
ˇˇ 
SaveChangesAsync
ˇˇ +
(
ˇˇ+ ,
)
ˇˇ, -
;
ˇˇ- .
var
ÅÅ 
critical
ÅÅ 
=
ÅÅ 
await
ÅÅ  
_context
ÅÅ! )
.
ÅÅ) *

Priorities
ÅÅ* 4
.
ÅÅ4 5!
FirstOrDefaultAsync
ÅÅ5 H
(
ÅÅH I
p
ÅÅI J
=>
ÅÅK M
p
ÅÅN O
.
ÅÅO P
Name
ÅÅP T
==
ÅÅU W
$str
ÅÅX `
)
ÅÅ` a
;
ÅÅa b
var
ÇÇ 
high
ÇÇ 
=
ÇÇ 
await
ÇÇ 
_context
ÇÇ %
.
ÇÇ% &

Priorities
ÇÇ& 0
.
ÇÇ0 1!
FirstOrDefaultAsync
ÇÇ1 D
(
ÇÇD E
p
ÇÇE F
=>
ÇÇG I
p
ÇÇJ K
.
ÇÇK L
Name
ÇÇL P
==
ÇÇQ S
$str
ÇÇT \
)
ÇÇ\ ]
;
ÇÇ] ^
var
ÉÉ 
medium
ÉÉ 
=
ÉÉ 
await
ÉÉ 
_context
ÉÉ '
.
ÉÉ' (

Priorities
ÉÉ( 2
.
ÉÉ2 3!
FirstOrDefaultAsync
ÉÉ3 F
(
ÉÉF G
p
ÉÉG H
=>
ÉÉI K
p
ÉÉL M
.
ÉÉM N
Name
ÉÉN R
==
ÉÉS U
$str
ÉÉV \
)
ÉÉ\ ]
;
ÉÉ] ^
var
ÑÑ 
low
ÑÑ 
=
ÑÑ 
await
ÑÑ 
_context
ÑÑ $
.
ÑÑ$ %

Priorities
ÑÑ% /
.
ÑÑ/ 0!
FirstOrDefaultAsync
ÑÑ0 C
(
ÑÑC D
p
ÑÑD E
=>
ÑÑF H
p
ÑÑI J
.
ÑÑJ K
Name
ÑÑK O
==
ÑÑP R
$str
ÑÑS Z
)
ÑÑZ [
;
ÑÑ[ \
if
ÜÜ 
(
ÜÜ 
critical
ÜÜ 
!=
ÜÜ 
null
ÜÜ  
&&
ÜÜ! #
high
ÜÜ$ (
!=
ÜÜ) +
null
ÜÜ, 0
&&
ÜÜ1 3
medium
ÜÜ4 :
!=
ÜÜ; =
null
ÜÜ> B
&&
ÜÜC E
low
ÜÜF I
!=
ÜÜJ L
null
ÜÜM Q
)
ÜÜQ R
{
áá 
_context
àà 
.
àà 

SlaTargets
àà #
.
àà# $
AddRange
àà$ ,
(
àà, -
new
ââ 
	SlaTarget
ââ !
{
ââ" #
SlaPolicyId
ââ$ /
=
ââ0 1
policy
ââ2 8
.
ââ8 9
Id
ââ9 ;
,
ââ; <

PriorityId
ââ= G
=
ââH I
critical
ââJ R
.
ââR S
Id
ââS U
,
ââU V"
FirstResponseMinutes
ââW k
=
ââl m
$num
âân p
,
ââp q 
ResolutionMinutesââr É
=ââÑ Ö
$numââÜ â
}ââä ã
,ââã å
new
ää 
	SlaTarget
ää !
{
ää" #
SlaPolicyId
ää$ /
=
ää0 1
policy
ää2 8
.
ää8 9
Id
ää9 ;
,
ää; <

PriorityId
ää= G
=
ääH I
high
ääJ N
.
ääN O
Id
ääO Q
,
ääQ R"
FirstResponseMinutes
ääS g
=
ääh i
$num
ääj m
,
ääm n 
ResolutionMinutesääo Ä
=ääÅ Ç
$numääÉ á
}ääà â
,ääâ ä
new
ãã 
	SlaTarget
ãã !
{
ãã" #
SlaPolicyId
ãã$ /
=
ãã0 1
policy
ãã2 8
.
ãã8 9
Id
ãã9 ;
,
ãã; <

PriorityId
ãã= G
=
ããH I
medium
ããJ P
.
ããP Q
Id
ããQ S
,
ããS T"
FirstResponseMinutes
ããU i
=
ããj k
$num
ããl o
,
ãão p 
ResolutionMinutesããq Ç
=ããÉ Ñ
$numããÖ â
}ããä ã
,ããã å
new
åå 
	SlaTarget
åå !
{
åå" #
SlaPolicyId
åå$ /
=
åå0 1
policy
åå2 8
.
åå8 9
Id
åå9 ;
,
åå; <

PriorityId
åå= G
=
ååH I
low
ååJ M
.
ååM N
Id
ååN P
,
ååP Q"
FirstResponseMinutes
ååR f
=
ååg h
$num
ååi m
,
ååm n 
ResolutionMinutesååo Ä
=ååÅ Ç
$numååÉ á
}ååà â
)
çç 
;
çç 
}
éé 
for
êê 
(
êê 
int
êê 
i
êê 
=
êê 
$num
êê 
;
êê 
i
êê 
<=
êê  
$num
êê! "
;
êê" #
i
êê$ %
++
êê% '
)
êê' (
{
ëë 
_context
íí 
.
íí 
BusinessHours
íí &
.
íí& '
Add
íí' *
(
íí* +
new
íí+ .
BusinessHour
íí/ ;
{
ìì 
	DayOfWeek
îî 
=
îî 
(
îî  !
	DayOfWeek
îî! *
)
îî* +
i
îî+ ,
,
îî, -
	StartTime
ïï 
=
ïï 
new
ïï  #
TimeSpan
ïï$ ,
(
ïï, -
$num
ïï- .
,
ïï. /
$num
ïï0 1
,
ïï1 2
$num
ïï3 4
)
ïï4 5
,
ïï5 6
EndTime
ññ 
=
ññ 
new
ññ !
TimeSpan
ññ" *
(
ññ* +
$num
ññ+ -
,
ññ- .
$num
ññ/ 0
,
ññ0 1
$num
ññ2 3
)
ññ3 4
,
ññ4 5
IsWorkingDay
óó  
=
óó! "
true
óó# '
}
òò 
)
òò 
;
òò 
}
ôô 
_context
öö 
.
öö 
BusinessHours
öö "
.
öö" #
Add
öö# &
(
öö& '
new
öö' *
BusinessHour
öö+ 7
{
öö8 9
	DayOfWeek
öö: C
=
ööD E
	DayOfWeek
ööF O
.
ööO P
Saturday
ööP X
,
ööX Y
IsWorkingDay
ööZ f
=
öög h
false
ööi n
}
ööo p
)
ööp q
;
ööq r
_context
õõ 
.
õõ 
BusinessHours
õõ "
.
õõ" #
Add
õõ# &
(
õõ& '
new
õõ' *
BusinessHour
õõ+ 7
{
õõ8 9
	DayOfWeek
õõ: C
=
õõD E
	DayOfWeek
õõF O
.
õõO P
Sunday
õõP V
,
õõV W
IsWorkingDay
õõX d
=
õõe f
false
õõg l
}
õõm n
)
õõn o
;
õõo p
await
ùù 
_context
ùù 
.
ùù 
SaveChangesAsync
ùù +
(
ùù+ ,
)
ùù, -
;
ùù- .
}
ûû 	
}
üü 
private
°° 
async
°° 
Task
°° *
SeedWorkflowTransitionsAsync
°° 3
(
°°3 4
)
°°4 5
{
¢¢ 
var
££ 
defaultWorkflow
££ 
=
££ 
await
££ #-
GetOrCreateDefaultWorkflowAsync
££$ C
(
££C D
)
££D E
;
££E F
var
•• 

openStatus
•• 
=
•• 
await
•• 
_context
•• '
.
••' (
Statuses
••( 0
.
••0 1!
FirstOrDefaultAsync
••1 D
(
••D E
s
••E F
=>
••G I
s
••J K
.
••K L
Name
••L P
==
••Q S
StatusConstants
••T c
.
••c d
Open
••d h
)
••h i
;
••i j
var
¶¶ 
inProgressStatus
¶¶ 
=
¶¶ 
await
¶¶ $
_context
¶¶% -
.
¶¶- .
Statuses
¶¶. 6
.
¶¶6 7!
FirstOrDefaultAsync
¶¶7 J
(
¶¶J K
s
¶¶K L
=>
¶¶M O
s
¶¶P Q
.
¶¶Q R
Name
¶¶R V
==
¶¶W Y
StatusConstants
¶¶Z i
.
¶¶i j

InProgress
¶¶j t
)
¶¶t u
;
¶¶u v
var
ßß 
onHoldStatus
ßß 
=
ßß 
await
ßß  
_context
ßß! )
.
ßß) *
Statuses
ßß* 2
.
ßß2 3!
FirstOrDefaultAsync
ßß3 F
(
ßßF G
s
ßßG H
=>
ßßI K
s
ßßL M
.
ßßM N
Name
ßßN R
==
ßßS U
StatusConstants
ßßV e
.
ßße f
OnHold
ßßf l
)
ßßl m
;
ßßm n
var
®® 
resolvedStatus
®® 
=
®® 
await
®® "
_context
®®# +
.
®®+ ,
Statuses
®®, 4
.
®®4 5!
FirstOrDefaultAsync
®®5 H
(
®®H I
s
®®I J
=>
®®K M
s
®®N O
.
®®O P
Name
®®P T
==
®®U W
StatusConstants
®®X g
.
®®g h
Resolved
®®h p
)
®®p q
;
®®q r
var
©© 
closedStatus
©© 
=
©© 
await
©©  
_context
©©! )
.
©©) *
Statuses
©©* 2
.
©©2 3!
FirstOrDefaultAsync
©©3 F
(
©©F G
s
©©G H
=>
©©I K
s
©©L M
.
©©M N
Name
©©N R
==
©©S U
StatusConstants
©©V e
.
©©e f
Closed
©©f l
)
©©l m
;
©©m n
if
´´ 

(
´´ 

openStatus
´´ 
!=
´´ 
null
´´ 
&&
´´ !
inProgressStatus
´´" 2
!=
´´3 5
null
´´6 :
&&
´´; =
onHoldStatus
´´> J
!=
´´K M
null
´´N R
&&
´´S U
resolvedStatus
´´V d
!=
´´e g
null
´´h l
&&
´´m o
closedStatus
´´p |
!=
´´} 
null´´Ä Ñ
)´´Ñ Ö
{
¨¨ 	
var
≠≠  
desiredTransitions
≠≠ "
=
≠≠# $%
BuildDesiredTransitions
≠≠% <
(
≠≠< =
defaultWorkflow
≠≠= L
.
≠≠L M
Id
≠≠M O
,
≠≠O P

openStatus
≠≠Q [
.
≠≠[ \
Id
≠≠\ ^
,
≠≠^ _
inProgressStatus
≠≠` p
.
≠≠p q
Id
≠≠q s
,
≠≠s t
onHoldStatus≠≠u Å
.≠≠Å Ç
Id≠≠Ç Ñ
,≠≠Ñ Ö
resolvedStatus≠≠Ü î
.≠≠î ï
Id≠≠ï ó
,≠≠ó ò
closedStatus≠≠ô •
.≠≠• ¶
Id≠≠¶ ®
)≠≠® ©
;≠≠© ™
var
ØØ  
currentTransitions
ØØ "
=
ØØ# $
await
ØØ% *
_context
ØØ+ 3
.
ØØ3 4!
WorkflowTransitions
ØØ4 G
.
∞∞ 
Where
∞∞ 
(
∞∞ 
wt
∞∞ 
=>
∞∞ 
wt
∞∞ 
.
∞∞  

WorkflowId
∞∞  *
==
∞∞+ -
defaultWorkflow
∞∞. =
.
∞∞= >
Id
∞∞> @
)
∞∞@ A
.
±± 
ToListAsync
±± 
(
±± 
)
±± 
;
±± 
foreach
≥≥ 
(
≥≥ 
var
≥≥ 
dt
≥≥ 
in
≥≥  
desiredTransitions
≥≥ 1
)
≥≥1 2
{
¥¥ 
var
µµ 
exists
µµ 
=
µµ  
currentTransitions
µµ /
.
µµ/ 0
Any
µµ0 3
(
µµ3 4
wt
µµ4 6
=>
µµ7 9
wt
µµ: <
.
µµ< =
FromStatusId
µµ= I
==
µµJ L
dt
µµM O
.
µµO P
FromStatusId
µµP \
&&
µµ] _
wt
µµ` b
.
µµb c

ToStatusId
µµc m
==
µµn p
dt
µµq s
.
µµs t

ToStatusId
µµt ~
)
µµ~ 
;µµ Ä
if
∂∂ 
(
∂∂ 
!
∂∂ 
exists
∂∂ 
)
∂∂ 
{
∑∑ 
_context
∏∏ 
.
∏∏ !
WorkflowTransitions
∏∏ 0
.
∏∏0 1
Add
∏∏1 4
(
∏∏4 5
dt
∏∏5 7
)
∏∏7 8
;
∏∏8 9
}
ππ 
}
∫∫ 
await
ªª 
_context
ªª 
.
ªª 
SaveChangesAsync
ªª +
(
ªª+ ,
)
ªª, -
;
ªª- .
}
ºº 	
await
ææ *
UpdateLegacyTransitionsAsync
ææ *
(
ææ* +
resolvedStatus
ææ+ 9
?
ææ9 :
.
ææ: ;
Id
ææ; =
,
ææ= >
closedStatus
ææ? K
?
ææK L
.
ææL M
Id
ææM O
,
ææO P
inProgressStatus
ææQ a
?
ææa b
.
ææb c
Id
ææc e
)
ææe f
;
ææf g
}
øø 
private
¡¡ 
async
¡¡ 
Task
¡¡ *
UpdateLegacyTransitionsAsync
¡¡ 3
(
¡¡3 4
int
¡¡4 7
?
¡¡7 8
resolvedStatusId
¡¡9 I
,
¡¡I J
int
¡¡K N
?
¡¡N O
closedStatusId
¡¡P ^
,
¡¡^ _
int
¡¡` c
?
¡¡c d 
inProgressStatusId
¡¡e w
)
¡¡w x
{
¬¬ 
var
√√ !
existingTransitions
√√ 
=
√√  !
await
√√" '
_context
√√( 0
.
√√0 1!
WorkflowTransitions
√√1 D
.
√√D E
Where
√√E J
(
√√J K
wt
√√K M
=>
√√N P
string
√√Q W
.
√√W X
IsNullOrEmpty
√√X e
(
√√e f
wt
√√f h
.
√√h i
TransitionName
√√i w
)
√√w x
)
√√x y
.
√√y z
ToListAsync√√z Ö
(√√Ö Ü
)√√Ü á
;√√á à
if
ƒƒ 

(
ƒƒ !
existingTransitions
ƒƒ 
.
ƒƒ  
Count
ƒƒ  %
==
ƒƒ& (
$num
ƒƒ) *
)
ƒƒ* +
return
ƒƒ, 2
;
ƒƒ2 3
foreach
∆∆ 
(
∆∆ 
var
∆∆ 
et
∆∆ 
in
∆∆ !
existingTransitions
∆∆ .
)
∆∆. /
{
«« 	
if
»» 
(
»» 
(
»» 
et
»» 
.
»» 
FromStatusId
»»  
==
»»! #
resolvedStatusId
»»$ 4
||
»»5 7
et
»»8 :
.
»»: ;
FromStatusId
»»; G
==
»»H J
closedStatusId
»»K Y
)
»»Y Z
&&
»»[ ]
et
»»^ `
.
»»` a

ToStatusId
»»a k
==
»»l n!
inProgressStatusId»»o Å
)»»Å Ç
{
…… 
et
   
.
   
TransitionName
   !
=
  " #
$str
  $ ,
;
  , -
et
ÀÀ 
.
ÀÀ #
RequiredPermissionKey
ÀÀ (
=
ÀÀ) *!
PermissionConstants
ÀÀ+ >
.
ÀÀ> ?
TicketReopen
ÀÀ? K
;
ÀÀK L
}
ÃÃ 
else
ÕÕ 
{
ŒŒ 
et
œœ 
.
œœ 
TransitionName
œœ !
=
œœ" #
$str
œœ$ -
;
œœ- .
}
–– 
}
—— 	
await
““ 
_context
““ 
.
““ 
SaveChangesAsync
““ '
(
““' (
)
““( )
;
““) *
}
”” 
private
’’ 
async
’’ 
Task
’’ $
SeedKnowledgeBaseAsync
’’ -
(
’’- .
)
’’. /
{
÷÷ 
if
ÿÿ 

(
ÿÿ 
!
ÿÿ 
await
ÿÿ 
_context
ÿÿ 
.
ÿÿ !
KnowledgeCategories
ÿÿ /
.
ÿÿ/ 0
AnyAsync
ÿÿ0 8
(
ÿÿ8 9
)
ÿÿ9 :
)
ÿÿ: ;
{
ŸŸ 	
_context
⁄⁄ 
.
⁄⁄ !
KnowledgeCategories
⁄⁄ (
.
⁄⁄( )
AddRange
⁄⁄) 1
(
⁄⁄1 2
new
€€ 
ItsTool
€€ 
.
€€ 
Domain
€€ "
.
€€" #
Entities
€€# +
.
€€+ ,
KnowledgeBase
€€, 9
.
€€9 :
KnowledgeCategory
€€: K
{
€€L M
Name
€€N R
=
€€S T
$str
€€U `
}
€€a b
,
€€b c
new
‹‹ 
ItsTool
‹‹ 
.
‹‹ 
Domain
‹‹ "
.
‹‹" #
Entities
‹‹# +
.
‹‹+ ,
KnowledgeBase
‹‹, 9
.
‹‹9 :
KnowledgeCategory
‹‹: K
{
‹‹L M
Name
‹‹N R
=
‹‹S T
$str
‹‹U b
}
‹‹c d
,
‹‹d e
new
›› 
ItsTool
›› 
.
›› 
Domain
›› "
.
››" #
Entities
››# +
.
››+ ,
KnowledgeBase
››, 9
.
››9 :
KnowledgeCategory
››: K
{
››L M
Name
››N R
=
››S T
$str
››U g
}
››h i
)
ﬁﬁ 
;
ﬁﬁ 
await
ﬂﬂ 
_context
ﬂﬂ 
.
ﬂﬂ 
SaveChangesAsync
ﬂﬂ +
(
ﬂﬂ+ ,
)
ﬂﬂ, -
;
ﬂﬂ- .
}
‡‡ 	
if
‚‚ 

(
‚‚ 
!
‚‚ 
await
‚‚ 
_context
‚‚ 
.
‚‚ 
KnowledgeArticles
‚‚ -
.
‚‚- .
AnyAsync
‚‚. 6
(
‚‚6 7
)
‚‚7 8
)
‚‚8 9
{
„„ 	
var
‰‰ 
rehberlerCat
‰‰ 
=
‰‰ 
await
‰‰ $
_context
‰‰% -
.
‰‰- .!
KnowledgeCategories
‰‰. A
.
‰‰A B!
FirstOrDefaultAsync
‰‰B U
(
‰‰U V
c
‰‰V W
=>
‰‰X Z
c
‰‰[ \
.
‰‰\ ]
Name
‰‰] a
==
‰‰b d
$str
‰‰e p
)
‰‰p q
;
‰‰q r
var
ÂÂ 
prosedurlerCat
ÂÂ 
=
ÂÂ  
await
ÂÂ! &
_context
ÂÂ' /
.
ÂÂ/ 0!
KnowledgeCategories
ÂÂ0 C
.
ÂÂC D!
FirstOrDefaultAsync
ÂÂD W
(
ÂÂW X
c
ÂÂX Y
=>
ÂÂZ \
c
ÂÂ] ^
.
ÂÂ^ _
Name
ÂÂ_ c
==
ÂÂd f
$str
ÂÂg t
)
ÂÂt u
;
ÂÂu v
var
ÊÊ 
	sistemCat
ÊÊ 
=
ÊÊ 
await
ÊÊ !
_context
ÊÊ" *
.
ÊÊ* +!
KnowledgeCategories
ÊÊ+ >
.
ÊÊ> ?!
FirstOrDefaultAsync
ÊÊ? R
(
ÊÊR S
c
ÊÊS T
=>
ÊÊU W
c
ÊÊX Y
.
ÊÊY Z
Name
ÊÊZ ^
==
ÊÊ_ a
$str
ÊÊb t
)
ÊÊt u
;
ÊÊu v
var
ËË 
adminAuthor
ËË 
=
ËË 
await
ËË #
_context
ËË$ ,
.
ËË, -
Users
ËË- 2
.
ËË2 3!
FirstOrDefaultAsync
ËË3 F
(
ËËF G
u
ËËG H
=>
ËËI K
u
ËËL M
.
ËËM N
Username
ËËN V
==
ËËW Y
$str
ËËZ a
)
ËËa b
;
ËËb c
if
ÍÍ 
(
ÍÍ 
adminAuthor
ÍÍ 
!=
ÍÍ 
null
ÍÍ #
&&
ÍÍ$ &
rehberlerCat
ÍÍ' 3
!=
ÍÍ4 6
null
ÍÍ7 ;
&&
ÍÍ< >
prosedurlerCat
ÍÍ? M
!=
ÍÍN P
null
ÍÍQ U
&&
ÍÍV X
	sistemCat
ÍÍY b
!=
ÍÍc e
null
ÍÍf j
)
ÍÍj k
{
ÎÎ 
_context
ÏÏ 
.
ÏÏ 
KnowledgeArticles
ÏÏ *
.
ÏÏ* +
AddRange
ÏÏ+ 3
(
ÏÏ3 4
new
ÌÌ 
ItsTool
ÌÌ 
.
ÌÌ  
Domain
ÌÌ  &
.
ÌÌ& '
Entities
ÌÌ' /
.
ÌÌ/ 0
KnowledgeBase
ÌÌ0 =
.
ÌÌ= >
KnowledgeArticle
ÌÌ> N
{
ÓÓ 
Title
ÔÔ 
=
ÔÔ 
$str
ÔÔ  6
,
ÔÔ6 7
Content
 
=
  !
$str" ¡
,¡ ¬

CategoryId
ÒÒ "
=
ÒÒ# $
rehberlerCat
ÒÒ% 1
.
ÒÒ1 2
Id
ÒÒ2 4
,
ÒÒ4 5
AuthorUserId
ÚÚ $
=
ÚÚ% &
adminAuthor
ÚÚ' 2
.
ÚÚ2 3
Id
ÚÚ3 5
,
ÚÚ5 6

Visibility
ÛÛ "
=
ÛÛ# $
ItsTool
ÛÛ% ,
.
ÛÛ, -
Domain
ÛÛ- 3
.
ÛÛ3 4
Entities
ÛÛ4 <
.
ÛÛ< =
KnowledgeBase
ÛÛ= J
.
ÛÛJ K
ArticleVisibility
ÛÛK \
.
ÛÛ\ ]
Public
ÛÛ] c
,
ÛÛc d
Status
ÙÙ 
=
ÙÙ  
ItsTool
ÙÙ! (
.
ÙÙ( )
Domain
ÙÙ) /
.
ÙÙ/ 0
Entities
ÙÙ0 8
.
ÙÙ8 9
KnowledgeBase
ÙÙ9 F
.
ÙÙF G
ArticleStatus
ÙÙG T
.
ÙÙT U
	Published
ÙÙU ^
,
ÙÙ^ _
	ViewCount
ıı !
=
ıı" #
$num
ıı$ &
}
ˆˆ 
,
ˆˆ 
new
˜˜ 
ItsTool
˜˜ 
.
˜˜  
Domain
˜˜  &
.
˜˜& '
Entities
˜˜' /
.
˜˜/ 0
KnowledgeBase
˜˜0 =
.
˜˜= >
KnowledgeArticle
˜˜> N
{
¯¯ 
Title
˘˘ 
=
˘˘ 
$str
˘˘  <
,
˘˘< =
Content
˙˙ 
=
˙˙  !
$str˙˙" Œ
,˙˙Œ œ

CategoryId
˚˚ "
=
˚˚# $
prosedurlerCat
˚˚% 3
.
˚˚3 4
Id
˚˚4 6
,
˚˚6 7
AuthorUserId
¸¸ $
=
¸¸% &
adminAuthor
¸¸' 2
.
¸¸2 3
Id
¸¸3 5
,
¸¸5 6

Visibility
˝˝ "
=
˝˝# $
ItsTool
˝˝% ,
.
˝˝, -
Domain
˝˝- 3
.
˝˝3 4
Entities
˝˝4 <
.
˝˝< =
KnowledgeBase
˝˝= J
.
˝˝J K
ArticleVisibility
˝˝K \
.
˝˝\ ]
Public
˝˝] c
,
˝˝c d
Status
˛˛ 
=
˛˛  
ItsTool
˛˛! (
.
˛˛( )
Domain
˛˛) /
.
˛˛/ 0
Entities
˛˛0 8
.
˛˛8 9
KnowledgeBase
˛˛9 F
.
˛˛F G
ArticleStatus
˛˛G T
.
˛˛T U
	Published
˛˛U ^
,
˛˛^ _
	ViewCount
ˇˇ !
=
ˇˇ" #
$num
ˇˇ$ %
}
ÄÄ 
,
ÄÄ 
new
ÅÅ 
ItsTool
ÅÅ 
.
ÅÅ  
Domain
ÅÅ  &
.
ÅÅ& '
Entities
ÅÅ' /
.
ÅÅ/ 0
KnowledgeBase
ÅÅ0 =
.
ÅÅ= >
KnowledgeArticle
ÅÅ> N
{
ÇÇ 
Title
ÉÉ 
=
ÉÉ 
$str
ÉÉ  >
,
ÉÉ> ?
Content
ÑÑ 
=
ÑÑ  !
$strÑÑ" ∆
,ÑÑ∆ «

CategoryId
ÖÖ "
=
ÖÖ# $
	sistemCat
ÖÖ% .
.
ÖÖ. /
Id
ÖÖ/ 1
,
ÖÖ1 2
AuthorUserId
ÜÜ $
=
ÜÜ% &
adminAuthor
ÜÜ' 2
.
ÜÜ2 3
Id
ÜÜ3 5
,
ÜÜ5 6

Visibility
áá "
=
áá# $
ItsTool
áá% ,
.
áá, -
Domain
áá- 3
.
áá3 4
Entities
áá4 <
.
áá< =
KnowledgeBase
áá= J
.
ááJ K
ArticleVisibility
ááK \
.
áá\ ]
Internal
áá] e
,
ááe f
Status
àà 
=
àà  
ItsTool
àà! (
.
àà( )
Domain
àà) /
.
àà/ 0
Entities
àà0 8
.
àà8 9
KnowledgeBase
àà9 F
.
ààF G
ArticleStatus
ààG T
.
ààT U
	Published
ààU ^
,
àà^ _
	ViewCount
ââ !
=
ââ" #
$num
ââ$ %
}
ää 
,
ää 
new
ãã 
ItsTool
ãã 
.
ãã  
Domain
ãã  &
.
ãã& '
Entities
ãã' /
.
ãã/ 0
KnowledgeBase
ãã0 =
.
ãã= >
KnowledgeArticle
ãã> N
{
åå 
Title
çç 
=
çç 
$str
çç  B
,
ççB C
Content
éé 
=
éé  !
$stréé" £
,éé£ §

CategoryId
èè "
=
èè# $
rehberlerCat
èè% 1
.
èè1 2
Id
èè2 4
,
èè4 5
AuthorUserId
êê $
=
êê% &
adminAuthor
êê' 2
.
êê2 3
Id
êê3 5
,
êê5 6

Visibility
ëë "
=
ëë# $
ItsTool
ëë% ,
.
ëë, -
Domain
ëë- 3
.
ëë3 4
Entities
ëë4 <
.
ëë< =
KnowledgeBase
ëë= J
.
ëëJ K
ArticleVisibility
ëëK \
.
ëë\ ]
Internal
ëë] e
,
ëëe f
Status
íí 
=
íí  
ItsTool
íí! (
.
íí( )
Domain
íí) /
.
íí/ 0
Entities
íí0 8
.
íí8 9
KnowledgeBase
íí9 F
.
ííF G
ArticleStatus
ííG T
.
ííT U
Draft
ííU Z
,
ííZ [
	ViewCount
ìì !
=
ìì" #
$num
ìì$ %
}
îî 
)
ïï 
;
ïï 
await
ññ 
_context
ññ 
.
ññ 
SaveChangesAsync
ññ /
(
ññ/ 0
)
ññ0 1
;
ññ1 2
}
óó 
}
òò 	
}
ôô 
private
úú 
async
úú 
Task
úú %
CreateOrUpdateUserAsync
úú .
(
úú. /
(
ùù 	
string
ùù	 
Username
ùù 
,
ùù 
string
ùù  
Password
ùù! )
,
ùù) *
string
ùù+ 1
Role
ùù2 6
,
ùù6 7
string
ùù8 >
	FirstName
ùù? H
,
ùùH I
string
ùùJ P
LastName
ùùQ Y
)
ùùY Z
u
ùù[ \
,
ùù\ ]
List
ûû 
<
ûû 
ItsTool
ûû 
.
ûû 
Domain
ûû 
.
ûû 
Entities
ûû $
.
ûû$ %
Organization
ûû% 1
.
ûû1 2
User
ûû2 6
>
ûû6 7
existingUsers
ûû8 E
,
ûûE F
ItsTool
üü 
.
üü 
Domain
üü 
.
üü 
Entities
üü 
.
üü  
Organization
üü  ,
.
üü, -

Department
üü- 7
?
üü7 8
itDept
üü9 ?
,
üü? @
List
†† 
<
†† 
ItsTool
†† 
.
†† 
Domain
†† 
.
†† 
Entities
†† $
.
††$ %
Auth
††% )
.
††) *
Role
††* .
>
††. /
existingRoles
††0 =
,
††= >
List
°° 
<
°° 
ItsTool
°° 
.
°° 
Domain
°° 
.
°° 
Entities
°° $
.
°°$ %
Auth
°°% )
.
°°) *

Permission
°°* 4
>
°°4 5!
existingPermissions
°°6 I
)
°°I J
{
¢¢ 
var
££ 
user
££ 
=
££ 
existingUsers
££  
.
££  !
FirstOrDefault
££! /
(
££/ 0
x
££0 1
=>
££2 4
x
££5 6
.
££6 7
Username
££7 ?
==
££@ B
u
££C D
.
££D E
Username
££E M
)
££M N
;
££N O
if
§§ 

(
§§ 
user
§§ 
==
§§ 
null
§§ 
&&
§§ 
itDept
§§ "
!=
§§# %
null
§§& *
)
§§* +
{
•• 	
user
¶¶ 
=
¶¶ 
new
¶¶ 
ItsTool
¶¶ 
.
¶¶ 
Domain
¶¶ %
.
¶¶% &
Entities
¶¶& .
.
¶¶. /
Organization
¶¶/ ;
.
¶¶; <
User
¶¶< @
{
ßß 
Username
®® 
=
®® 
u
®® 
.
®® 
Username
®® %
,
®®% &
Email
©© 
=
©© 
$"
©© 
{
©© 
u
©© 
.
©© 
Username
©© %
}
©©% &
$str
©©& 1
"
©©1 2
,
©©2 3
	FirstName
™™ 
=
™™ 
u
™™ 
.
™™ 
	FirstName
™™ '
,
™™' (
LastName
´´ 
=
´´ 
u
´´ 
.
´´ 
LastName
´´ %
,
´´% &
DepartmentId
¨¨ 
=
¨¨ 
itDept
¨¨ %
.
¨¨% &
Id
¨¨& (
,
¨¨( )
PasswordHash
≠≠ 
=
≠≠ 
BCrypt
≠≠ %
.
≠≠% &
Net
≠≠& )
.
≠≠) *
BCrypt
≠≠* 0
.
≠≠0 1
HashPassword
≠≠1 =
(
≠≠= >
u
≠≠> ?
.
≠≠? @
Password
≠≠@ H
)
≠≠H I
}
ÆÆ 
;
ÆÆ 
_context
ØØ 
.
ØØ 
Users
ØØ 
.
ØØ 
Add
ØØ 
(
ØØ 
user
ØØ #
)
ØØ# $
;
ØØ$ %
existingUsers
∞∞ 
.
∞∞ 
Add
∞∞ 
(
∞∞ 
user
∞∞ "
)
∞∞" #
;
∞∞# $
await
±± 
_context
±± 
.
±± 
SaveChangesAsync
±± +
(
±±+ ,
)
±±, -
;
±±- .
}
≤≤ 	
if
¥¥ 

(
¥¥ 
user
¥¥ 
!=
¥¥ 
null
¥¥ 
)
¥¥ 
{
µµ 	
var
∂∂ 
role
∂∂ 
=
∂∂ 
existingRoles
∂∂ $
.
∂∂$ %
First
∂∂% *
(
∂∂* +
r
∂∂+ ,
=>
∂∂- /
r
∂∂0 1
.
∂∂1 2
Name
∂∂2 6
==
∂∂7 9
u
∂∂: ;
.
∂∂; <
Role
∂∂< @
)
∂∂@ A
;
∂∂A B
if
∑∑ 
(
∑∑ 
!
∑∑ 
user
∑∑ 
.
∑∑ 
	UserRoles
∑∑ 
.
∑∑  
Any
∑∑  #
(
∑∑# $
ur
∑∑$ &
=>
∑∑' )
ur
∑∑* ,
.
∑∑, -
RoleId
∑∑- 3
==
∑∑4 6
role
∑∑7 ;
.
∑∑; <
Id
∑∑< >
)
∑∑> ?
)
∑∑? @
{
∏∏ 
_context
ππ 
.
ππ 
	UserRoles
ππ "
.
ππ" #
Add
ππ# &
(
ππ& '
new
ππ' *
ItsTool
ππ+ 2
.
ππ2 3
Domain
ππ3 9
.
ππ9 :
Entities
ππ: B
.
ππB C
Auth
ππC G
.
ππG H
UserRole
ππH P
{
ππQ R
UserId
ππS Y
=
ππZ [
user
ππ\ `
.
ππ` a
Id
ππa c
,
ππc d
RoleId
ππe k
=
ππl m
role
ππn r
.
ππr s
Id
ππs u
}
ππv w
)
ππw x
;
ππx y
}
∫∫ 
if
ºº 
(
ºº 
u
ºº 
.
ºº 
Username
ºº 
==
ºº 
$str
ºº &
)
ºº& '
{
ΩΩ 
var
ææ 
	closePerm
ææ 
=
ææ !
existingPermissions
ææ  3
.
ææ3 4
First
ææ4 9
(
ææ9 :
p
ææ: ;
=>
ææ< >
p
ææ? @
.
ææ@ A
Key
ææA D
==
ææE G!
PermissionConstants
ææH [
.
ææ[ \
TicketClose
ææ\ g
)
ææg h
;
ææh i
if
øø 
(
øø 
!
øø 
user
øø 
.
øø !
PermissionOverrides
øø -
.
øø- .
Any
øø. 1
(
øø1 2
po
øø2 4
=>
øø5 7
po
øø8 :
.
øø: ;
PermissionId
øø; G
==
øøH J
	closePerm
øøK T
.
øøT U
Id
øøU W
)
øøW X
)
øøX Y
{
¿¿ 
_context
¡¡ 
.
¡¡ %
UserPermissionOverrides
¡¡ 4
.
¡¡4 5
Add
¡¡5 8
(
¡¡8 9
new
¡¡9 <
ItsTool
¡¡= D
.
¡¡D E
Domain
¡¡E K
.
¡¡K L
Entities
¡¡L T
.
¡¡T U
Auth
¡¡U Y
.
¡¡Y Z$
UserPermissionOverride
¡¡Z p
{
¬¬ 
UserId
√√ 
=
√√  
user
√√! %
.
√√% &
Id
√√& (
,
√√( )
PermissionId
ƒƒ $
=
ƒƒ% &
	closePerm
ƒƒ' 0
.
ƒƒ0 1
Id
ƒƒ1 3
,
ƒƒ3 4
	IsGranted
≈≈ !
=
≈≈" #
true
≈≈$ (
}
∆∆ 
)
∆∆ 
;
∆∆ 
}
«« 
}
»» 
}
…… 	
}
   
private
ŒŒ 
static
ŒŒ 
List
ŒŒ 
<
ŒŒ 
ItsTool
ŒŒ 
.
ŒŒ  
Domain
ŒŒ  &
.
ŒŒ& '
Entities
ŒŒ' /
.
ŒŒ/ 0
Workflow
ŒŒ0 8
.
ŒŒ8 9 
WorkflowTransition
ŒŒ9 K
>
ŒŒK L%
BuildDesiredTransitions
ŒŒM d
(
ŒŒd e
int
ŒŒe h

workflowId
ŒŒi s
,
ŒŒs t
int
ŒŒu x
openId
ŒŒy 
,ŒŒ Ä
intŒŒÅ Ñ
inProgressIdŒŒÖ ë
,ŒŒë í
intŒŒì ñ
onHoldIdŒŒó ü
,ŒŒü †
intŒŒ° §

resolvedIdŒŒ• Ø
,ŒŒØ ∞
intŒŒ± ¥
closedIdŒŒµ Ω
)ŒŒΩ æ
{
œœ 
return
–– 
new
–– 
List
–– 
<
–– 
ItsTool
–– 
.
––  
Domain
––  &
.
––& '
Entities
––' /
.
––/ 0
Workflow
––0 8
.
––8 9 
WorkflowTransition
––9 K
>
––K L
{
—— 	
new
““ 
(
““ 
)
““ 
{
““ 

WorkflowId
““ 
=
““  

workflowId
““! +
,
““+ ,
FromStatusId
““- 9
=
““: ;
openId
““< B
,
““B C

ToStatusId
““D N
=
““O P
inProgressId
““Q ]
,
““] ^
IsActive
““_ g
=
““h i
true
““j n
,
““n o
TransitionName
““p ~
=““ Ä#
TransitionConstants““Å î
.““î ï
StartProgress““ï ¢
}““£ §
,““§ •
new
”” 
(
”” 
)
”” 
{
”” 

WorkflowId
”” 
=
””  

workflowId
””! +
,
””+ ,
FromStatusId
””- 9
=
””: ;
openId
””< B
,
””B C

ToStatusId
””D N
=
””O P
onHoldId
””Q Y
,
””Y Z
IsActive
””[ c
=
””d e
true
””f j
,
””j k
TransitionName
””l z
=
””{ |"
TransitionConstants””} ê
.””ê ë
	PutOnHold””ë ö
}””õ ú
,””ú ù
new
‘‘ 
(
‘‘ 
)
‘‘ 
{
‘‘ 

WorkflowId
‘‘ 
=
‘‘  

workflowId
‘‘! +
,
‘‘+ ,
FromStatusId
‘‘- 9
=
‘‘: ;
openId
‘‘< B
,
‘‘B C

ToStatusId
‘‘D N
=
‘‘O P

resolvedId
‘‘Q [
,
‘‘[ \
IsActive
‘‘] e
=
‘‘f g
true
‘‘h l
,
‘‘l m
TransitionName
‘‘n |
=
‘‘} ~"
TransitionConstants‘‘ í
.‘‘í ì
Resolve‘‘ì ö
,‘‘ö õ%
RequiredPermissionKey‘‘ú ±
=‘‘≤ ≥#
PermissionConstants‘‘¥ «
.‘‘« »
TicketResolve‘‘» ’
}‘‘÷ ◊
,‘‘◊ ÿ
new
’’ 
(
’’ 
)
’’ 
{
’’ 

WorkflowId
’’ 
=
’’  

workflowId
’’! +
,
’’+ ,
FromStatusId
’’- 9
=
’’: ;
openId
’’< B
,
’’B C

ToStatusId
’’D N
=
’’O P
closedId
’’Q Y
,
’’Y Z
IsActive
’’[ c
=
’’d e
true
’’f j
,
’’j k
TransitionName
’’l z
=
’’{ |
StatusConstants’’} å
.’’å ç
Closed’’ç ì
,’’ì î%
RequiredPermissionKey’’ï ™
=’’´ ¨#
PermissionConstants’’≠ ¿
.’’¿ ¡
TicketClose’’¡ Ã
}’’Õ Œ
,’’Œ œ
new
÷÷ 
(
÷÷ 
)
÷÷ 
{
÷÷ 

WorkflowId
÷÷ 
=
÷÷  

workflowId
÷÷! +
,
÷÷+ ,
FromStatusId
÷÷- 9
=
÷÷: ;
inProgressId
÷÷< H
,
÷÷H I

ToStatusId
÷÷J T
=
÷÷U V
openId
÷÷W ]
,
÷÷] ^
IsActive
÷÷_ g
=
÷÷h i
true
÷÷j n
,
÷÷n o
TransitionName
÷÷p ~
=÷÷ Ä#
TransitionConstants÷÷Å î
.÷÷î ï

MoveToOpen÷÷ï ü
}÷÷† °
,÷÷° ¢
new
◊◊ 
(
◊◊ 
)
◊◊ 
{
◊◊ 

WorkflowId
◊◊ 
=
◊◊  

workflowId
◊◊! +
,
◊◊+ ,
FromStatusId
◊◊- 9
=
◊◊: ;
inProgressId
◊◊< H
,
◊◊H I

ToStatusId
◊◊J T
=
◊◊U V
onHoldId
◊◊W _
,
◊◊_ `
IsActive
◊◊a i
=
◊◊j k
true
◊◊l p
,
◊◊p q
TransitionName◊◊r Ä
=◊◊Å Ç#
TransitionConstants◊◊É ñ
.◊◊ñ ó
	PutOnHold◊◊ó †
}◊◊° ¢
,◊◊¢ £
new
ÿÿ 
(
ÿÿ 
)
ÿÿ 
{
ÿÿ 

WorkflowId
ÿÿ 
=
ÿÿ  

workflowId
ÿÿ! +
,
ÿÿ+ ,
FromStatusId
ÿÿ- 9
=
ÿÿ: ;
inProgressId
ÿÿ< H
,
ÿÿH I

ToStatusId
ÿÿJ T
=
ÿÿU V

resolvedId
ÿÿW a
,
ÿÿa b
IsActive
ÿÿc k
=
ÿÿl m
true
ÿÿn r
,
ÿÿr s
TransitionNameÿÿt Ç
=ÿÿÉ Ñ#
TransitionConstantsÿÿÖ ò
.ÿÿò ô
Resolveÿÿô †
,ÿÿ† °%
RequiredPermissionKeyÿÿ¢ ∑
=ÿÿ∏ π#
PermissionConstantsÿÿ∫ Õ
.ÿÿÕ Œ
TicketResolveÿÿŒ €
}ÿÿ‹ ›
,ÿÿ› ﬁ
new
ŸŸ 
(
ŸŸ 
)
ŸŸ 
{
ŸŸ 

WorkflowId
ŸŸ 
=
ŸŸ  

workflowId
ŸŸ! +
,
ŸŸ+ ,
FromStatusId
ŸŸ- 9
=
ŸŸ: ;
inProgressId
ŸŸ< H
,
ŸŸH I

ToStatusId
ŸŸJ T
=
ŸŸU V
closedId
ŸŸW _
,
ŸŸ_ `
IsActive
ŸŸa i
=
ŸŸj k
true
ŸŸl p
,
ŸŸp q
TransitionNameŸŸr Ä
=ŸŸÅ Ç
StatusConstantsŸŸÉ í
.ŸŸí ì
ClosedŸŸì ô
,ŸŸô ö%
RequiredPermissionKeyŸŸõ ∞
=ŸŸ± ≤#
PermissionConstantsŸŸ≥ ∆
.ŸŸ∆ «
TicketCloseŸŸ« “
}ŸŸ” ‘
,ŸŸ‘ ’
new
⁄⁄ 
(
⁄⁄ 
)
⁄⁄ 
{
⁄⁄ 

WorkflowId
⁄⁄ 
=
⁄⁄  

workflowId
⁄⁄! +
,
⁄⁄+ ,
FromStatusId
⁄⁄- 9
=
⁄⁄: ;
onHoldId
⁄⁄< D
,
⁄⁄D E

ToStatusId
⁄⁄F P
=
⁄⁄Q R
openId
⁄⁄S Y
,
⁄⁄Y Z
IsActive
⁄⁄[ c
=
⁄⁄d e
true
⁄⁄f j
,
⁄⁄j k
TransitionName
⁄⁄l z
=
⁄⁄{ |"
TransitionConstants⁄⁄} ê
.⁄⁄ê ë

MoveToOpen⁄⁄ë õ
}⁄⁄ú ù
,⁄⁄ù û
new
€€ 
(
€€ 
)
€€ 
{
€€ 

WorkflowId
€€ 
=
€€  

workflowId
€€! +
,
€€+ ,
FromStatusId
€€- 9
=
€€: ;
onHoldId
€€< D
,
€€D E

ToStatusId
€€F P
=
€€Q R
inProgressId
€€S _
,
€€_ `
IsActive
€€a i
=
€€j k
true
€€l p
,
€€p q
TransitionName€€r Ä
=€€Å Ç#
TransitionConstants€€É ñ
.€€ñ ó
ResumeProgress€€ó •
}€€¶ ß
,€€ß ®
new
‹‹ 
(
‹‹ 
)
‹‹ 
{
‹‹ 

WorkflowId
‹‹ 
=
‹‹  

workflowId
‹‹! +
,
‹‹+ ,
FromStatusId
‹‹- 9
=
‹‹: ;
onHoldId
‹‹< D
,
‹‹D E

ToStatusId
‹‹F P
=
‹‹Q R

resolvedId
‹‹S ]
,
‹‹] ^
IsActive
‹‹_ g
=
‹‹h i
true
‹‹j n
,
‹‹n o
TransitionName
‹‹p ~
=‹‹ Ä#
TransitionConstants‹‹Å î
.‹‹î ï
Resolve‹‹ï ú
,‹‹ú ù%
RequiredPermissionKey‹‹û ≥
=‹‹¥ µ#
PermissionConstants‹‹∂ …
.‹‹…  
TicketResolve‹‹  ◊
}‹‹ÿ Ÿ
,‹‹Ÿ ⁄
new
›› 
(
›› 
)
›› 
{
›› 

WorkflowId
›› 
=
››  

workflowId
››! +
,
››+ ,
FromStatusId
››- 9
=
››: ;
onHoldId
››< D
,
››D E

ToStatusId
››F P
=
››Q R
closedId
››S [
,
››[ \
IsActive
››] e
=
››f g
true
››h l
,
››l m
TransitionName
››n |
=
››} ~
StatusConstants›› é
.››é è
Closed››è ï
,››ï ñ%
RequiredPermissionKey››ó ¨
=››≠ Æ#
PermissionConstants››Ø ¬
.››¬ √
TicketClose››√ Œ
}››œ –
,››– —
new
ﬁﬁ 
(
ﬁﬁ 
)
ﬁﬁ 
{
ﬁﬁ 

WorkflowId
ﬁﬁ 
=
ﬁﬁ  

workflowId
ﬁﬁ! +
,
ﬁﬁ+ ,
FromStatusId
ﬁﬁ- 9
=
ﬁﬁ: ;

resolvedId
ﬁﬁ< F
,
ﬁﬁF G

ToStatusId
ﬁﬁH R
=
ﬁﬁS T
openId
ﬁﬁU [
,
ﬁﬁ[ \
IsActive
ﬁﬁ] e
=
ﬁﬁf g
true
ﬁﬁh l
,
ﬁﬁl m
TransitionName
ﬁﬁn |
=
ﬁﬁ} ~"
TransitionConstantsﬁﬁ í
.ﬁﬁí ì
ReopenToOpenﬁﬁì ü
,ﬁﬁü †%
RequiredPermissionKeyﬁﬁ° ∂
=ﬁﬁ∑ ∏#
PermissionConstantsﬁﬁπ Ã
.ﬁﬁÃ Õ
TicketReopenﬁﬁÕ Ÿ
}ﬁﬁ⁄ €
,ﬁﬁ€ ‹
new
ﬂﬂ 
(
ﬂﬂ 
)
ﬂﬂ 
{
ﬂﬂ 

WorkflowId
ﬂﬂ 
=
ﬂﬂ  

workflowId
ﬂﬂ! +
,
ﬂﬂ+ ,
FromStatusId
ﬂﬂ- 9
=
ﬂﬂ: ;

resolvedId
ﬂﬂ< F
,
ﬂﬂF G

ToStatusId
ﬂﬂH R
=
ﬂﬂS T
inProgressId
ﬂﬂU a
,
ﬂﬂa b
IsActive
ﬂﬂc k
=
ﬂﬂl m
true
ﬂﬂn r
,
ﬂﬂr s
TransitionNameﬂﬂt Ç
=ﬂﬂÉ Ñ#
TransitionConstantsﬂﬂÖ ò
.ﬂﬂò ô 
ReopenToProgressﬂﬂô ©
,ﬂﬂ© ™%
RequiredPermissionKeyﬂﬂ´ ¿
=ﬂﬂ¡ ¬#
PermissionConstantsﬂﬂ√ ÷
.ﬂﬂ÷ ◊
TicketReopenﬂﬂ◊ „
}ﬂﬂ‰ Â
,ﬂﬂÂ Ê
new
‡‡ 
(
‡‡ 
)
‡‡ 
{
‡‡ 

WorkflowId
‡‡ 
=
‡‡  

workflowId
‡‡! +
,
‡‡+ ,
FromStatusId
‡‡- 9
=
‡‡: ;

resolvedId
‡‡< F
,
‡‡F G

ToStatusId
‡‡H R
=
‡‡S T
onHoldId
‡‡U ]
,
‡‡] ^
IsActive
‡‡_ g
=
‡‡h i
true
‡‡j n
,
‡‡n o
TransitionName
‡‡p ~
=‡‡ Ä#
TransitionConstants‡‡Å î
.‡‡î ï
ReopenToPending‡‡ï §
,‡‡§ •%
RequiredPermissionKey‡‡¶ ª
=‡‡º Ω#
PermissionConstants‡‡æ —
.‡‡— “
TicketReopen‡‡“ ﬁ
}‡‡ﬂ ‡
,‡‡‡ ·
new
·· 
(
·· 
)
·· 
{
·· 

WorkflowId
·· 
=
··  

workflowId
··! +
,
··+ ,
FromStatusId
··- 9
=
··: ;

resolvedId
··< F
,
··F G

ToStatusId
··H R
=
··S T
closedId
··U ]
,
··] ^
IsActive
··_ g
=
··h i
true
··j n
,
··n o
TransitionName
··p ~
=·· Ä
StatusConstants··Å ê
.··ê ë
Closed··ë ó
,··ó ò%
RequiredPermissionKey··ô Æ
=··Ø ∞#
PermissionConstants··± ƒ
.··ƒ ≈
TicketClose··≈ –
}··— “
,··“ ”
new
‚‚ 
(
‚‚ 
)
‚‚ 
{
‚‚ 

WorkflowId
‚‚ 
=
‚‚  

workflowId
‚‚! +
,
‚‚+ ,
FromStatusId
‚‚- 9
=
‚‚: ;
closedId
‚‚< D
,
‚‚D E

ToStatusId
‚‚F P
=
‚‚Q R
openId
‚‚S Y
,
‚‚Y Z
IsActive
‚‚[ c
=
‚‚d e
true
‚‚f j
,
‚‚j k
TransitionName
‚‚l z
=
‚‚{ |"
TransitionConstants‚‚} ê
.‚‚ê ë
ReopenToOpen‚‚ë ù
,‚‚ù û%
RequiredPermissionKey‚‚ü ¥
=‚‚µ ∂#
PermissionConstants‚‚∑  
.‚‚  À
TicketReopen‚‚À ◊
}‚‚ÿ Ÿ
,‚‚Ÿ ⁄
new
„„ 
(
„„ 
)
„„ 
{
„„ 

WorkflowId
„„ 
=
„„  

workflowId
„„! +
,
„„+ ,
FromStatusId
„„- 9
=
„„: ;
closedId
„„< D
,
„„D E

ToStatusId
„„F P
=
„„Q R
inProgressId
„„S _
,
„„_ `
IsActive
„„a i
=
„„j k
true
„„l p
,
„„p q
TransitionName„„r Ä
=„„Å Ç#
TransitionConstants„„É ñ
.„„ñ ó 
ReopenToProgress„„ó ß
,„„ß ®%
RequiredPermissionKey„„© æ
=„„ø ¿#
PermissionConstants„„¡ ‘
.„„‘ ’
TicketReopen„„’ ·
}„„‚ „
,„„„ ‰
new
‰‰ 
(
‰‰ 
)
‰‰ 
{
‰‰ 

WorkflowId
‰‰ 
=
‰‰  

workflowId
‰‰! +
,
‰‰+ ,
FromStatusId
‰‰- 9
=
‰‰: ;
closedId
‰‰< D
,
‰‰D E

ToStatusId
‰‰F P
=
‰‰Q R
onHoldId
‰‰S [
,
‰‰[ \
IsActive
‰‰] e
=
‰‰f g
true
‰‰h l
,
‰‰l m
TransitionName
‰‰n |
=
‰‰} ~"
TransitionConstants‰‰ í
.‰‰í ì
ReopenToPending‰‰ì ¢
,‰‰¢ £%
RequiredPermissionKey‰‰§ π
=‰‰∫ ª#
PermissionConstants‰‰º œ
.‰‰œ –
TicketReopen‰‰– ‹
}‰‰› ﬁ
,‰‰ﬁ ﬂ
new
ÂÂ 
(
ÂÂ 
)
ÂÂ 
{
ÂÂ 

WorkflowId
ÂÂ 
=
ÂÂ  

workflowId
ÂÂ! +
,
ÂÂ+ ,
FromStatusId
ÂÂ- 9
=
ÂÂ: ;
closedId
ÂÂ< D
,
ÂÂD E

ToStatusId
ÂÂF P
=
ÂÂQ R

resolvedId
ÂÂS ]
,
ÂÂ] ^
IsActive
ÂÂ_ g
=
ÂÂh i
true
ÂÂj n
,
ÂÂn o
TransitionName
ÂÂp ~
=ÂÂ Ä#
TransitionConstantsÂÂÅ î
.ÂÂî ï 
ReopenToResolvedÂÂï •
,ÂÂ• ¶%
RequiredPermissionKeyÂÂß º
=ÂÂΩ æ#
PermissionConstantsÂÂø “
.ÂÂ“ ”
TicketReopenÂÂ” ﬂ
}ÂÂ‡ ·
}
ÊÊ 	
;
ÊÊ	 

}
ÁÁ 
private
ÈÈ 
async
ÈÈ 
Task
ÈÈ 
<
ÈÈ 
ItsTool
ÈÈ 
.
ÈÈ 
Domain
ÈÈ %
.
ÈÈ% &
Entities
ÈÈ& .
.
ÈÈ. /
Workflow
ÈÈ/ 7
.
ÈÈ7 8
Workflow
ÈÈ8 @
>
ÈÈ@ A-
GetOrCreateDefaultWorkflowAsync
ÈÈB a
(
ÈÈa b
)
ÈÈb c
{
ÍÍ 
var
ÎÎ 
wf
ÎÎ 
=
ÎÎ 
await
ÎÎ 
_context
ÎÎ 
.
ÎÎ  
	Workflows
ÎÎ  )
.
ÎÎ) *!
FirstOrDefaultAsync
ÎÎ* =
(
ÎÎ= >
w
ÎÎ> ?
=>
ÎÎ@ B
w
ÎÎC D
.
ÎÎD E
Name
ÎÎE I
==
ÎÎJ L
$str
ÎÎM f
)
ÎÎf g
;
ÎÎg h
if
ÏÏ 

(
ÏÏ 
wf
ÏÏ 
==
ÏÏ 
null
ÏÏ 
)
ÏÏ 
{
ÌÌ 	
wf
ÓÓ 
=
ÓÓ 
new
ÓÓ 
ItsTool
ÓÓ 
.
ÓÓ 
Domain
ÓÓ #
.
ÓÓ# $
Entities
ÓÓ$ ,
.
ÓÓ, -
Workflow
ÓÓ- 5
.
ÓÓ5 6
Workflow
ÓÓ6 >
{
ÔÔ 
Name
 
=
 
$str
 0
,
0 1
Description
ÒÒ 
=
ÒÒ 
$str
ÒÒ :
,
ÒÒ: ;
IsActive
ÚÚ 
=
ÚÚ 
true
ÚÚ 
}
ÛÛ 
;
ÛÛ 
_context
ÙÙ 
.
ÙÙ 
	Workflows
ÙÙ 
.
ÙÙ 
Add
ÙÙ "
(
ÙÙ" #
wf
ÙÙ# %
)
ÙÙ% &
;
ÙÙ& '
await
ıı 
_context
ıı 
.
ıı 
SaveChangesAsync
ıı +
(
ıı+ ,
)
ıı, -
;
ıı- .
}
ˆˆ 	
return
˜˜ 
wf
˜˜ 
;
˜˜ 
}
¯¯ 
}˘˘ •
r/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/Configurations/TicketConfiguration.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
.% &
Configurations& 4
;4 5
public 
class 
TicketConfiguration  
:! "$
IEntityTypeConfiguration# ;
<; <
Ticket< B
>B C
{D E
public 

void 
	Configure 
( 
EntityTypeBuilder +
<+ ,
Ticket, 2
>2 3
builder4 ;
); <
{= >
builder 
. 
HasKey 
( 
t 
=> 
t 
. 
Id  
)  !
;! "
builder 
. 
Property 
( 
t 
=> 
t 
.  
TicketNumber  ,
), -
.- .

IsRequired. 8
(8 9
)9 :
.: ;
HasMaxLength; G
(G H
$numH J
)J K
;K L
builder		 
.		 
HasIndex		 
(		 
t		 
=>		 
t		 
.		  
TicketNumber		  ,
)		, -
.		- .
IsUnique		. 6
(		6 7
)		7 8
;		8 9
builder

 
.

 
HasOne

 
(

 
t

 
=>

 
t

 
.

 
RequesterUser

 +
)

+ ,
.

, -
WithMany

- 5
(

5 6
)

6 7
.

7 8
HasForeignKey

8 E
(

E F
t

F G
=>

H J
t

K L
.

L M
RequesterUserId

M \
)

\ ]
.

] ^
OnDelete

^ f
(

f g
DeleteBehavior

g u
.

u v
Restrict

v ~
)

~ 
;	

 Ä
builder 
. 
HasOne 
( 
t 
=> 
t 
. 
AssignedUser *
)* +
.+ ,
WithMany, 4
(4 5
)5 6
.6 7
HasForeignKey7 D
(D E
tE F
=>G I
tJ K
.K L
AssignedUserIdL Z
)Z [
.[ \
OnDelete\ d
(d e
DeleteBehaviore s
.s t
SetNullt {
){ |
;| }
} 
} ˚"
s/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/Configurations/Phase2BConfiguration.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
.% &
Configurations& 4
;4 5
public 
class $
CustomFieldConfiguration %
:& '$
IEntityTypeConfiguration( @
<@ A
FieldDefinitionA P
>P Q
{		 
public

 

void

 
	Configure

 
(

 
EntityTypeBuilder

 +
<

+ ,
FieldDefinition

, ;
>

; <
builder

= D
)

D E
{ 
builder 
. 
HasIndex 
( 
f 
=> 
f 
.  
Key  #
)# $
.$ %
IsUnique% -
(- .
). /
;/ 0
} 
} 
public 
class )
TicketFieldValueConfiguration *
:+ ,$
IEntityTypeConfiguration- E
<E F
TicketFieldValueF V
>V W
{ 
public 

void 
	Configure 
( 
EntityTypeBuilder +
<+ ,
TicketFieldValue, <
>< =
builder> E
)E F
{ 
builder 
. 
HasIndex 
( 
tfv 
=> 
new  #
{$ %
tfv& )
.) *
TicketId* 2
,2 3
tfv4 7
.7 8
FieldDefinitionId8 I
}J K
)K L
.L M
IsUniqueM U
(U V
)V W
;W X
builder 
. 
HasOne 
( 
tfv 
=> 
tfv !
.! "
Ticket" (
)( )
. 
WithMany 
( 
) 
. 
HasForeignKey 
( 
tfv !
=>" $
tfv% (
.( )
TicketId) 1
)1 2
. 
OnDelete 
( 
DeleteBehavior '
.' (
Cascade( /
)/ 0
;0 1
builder 
. 
HasOne 
( 
tfv 
=> 
tfv !
.! "
FieldDefinition" 1
)1 2
. 
WithMany 
( 
) 
. 
HasForeignKey 
( 
tfv !
=>" $
tfv% (
.( )
FieldDefinitionId) :
): ;
. 
OnDelete 
( 
DeleteBehavior '
.' (
Restrict( 0
)0 1
;1 2
} 
}   
public"" 
class"" +
WorkflowTransitionConfiguration"" ,
:""- .$
IEntityTypeConfiguration""/ G
<""G H
WorkflowTransition""H Z
>""Z [
{## 
public$$ 

void$$ 
	Configure$$ 
($$ 
EntityTypeBuilder$$ +
<$$+ ,
WorkflowTransition$$, >
>$$> ?
builder$$@ G
)$$G H
{%% 
builder&& 
.&& 
HasOne&& 
(&& 
wt&& 
=>&& 
wt&& 
.&&  

FromStatus&&  *
)&&* +
.'' 
WithMany'' 
('' 
)'' 
.(( 
HasForeignKey(( 
((( 
wt((  
=>((! #
wt(($ &
.((& '
FromStatusId((' 3
)((3 4
.)) 
OnDelete)) 
()) 
DeleteBehavior)) '
.))' (
Restrict))( 0
)))0 1
;))1 2
builder++ 
.++ 
HasOne++ 
(++ 
wt++ 
=>++ 
wt++ 
.++  
ToStatus++  (
)++( )
.,, 
WithMany,, 
(,, 
),, 
.-- 
HasForeignKey-- 
(-- 
wt--  
=>--! #
wt--$ &
.--& '

ToStatusId--' 1
)--1 2
... 
OnDelete.. 
(.. 
DeleteBehavior.. '
...' (
Restrict..( 0
)..0 1
;..1 2
}// 
}00 