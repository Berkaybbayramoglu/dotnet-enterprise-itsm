›k
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
.	44 €#
RequiredPermissionKey
44€ •
,
44• –
t
44— 
.
44 ™
	SortOrder
44™ Ά
,
44Ά £
t
44¤ ¥
.
44¥ ¦
IsActive
44¦ ®
)
44® ―
)
44― °
;
44° ±
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
RequiredPermissionKey	;;o „
,
;;„ …
t
;;† ‡
.
;;‡ 
	SortOrder
;; ‘
,
;;‘ ’
t
;;“ ”
.
;;” •
IsActive
;;• 
)
;; 
;
;; 
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
$str	@@T 
)
@@ ‚
;
@@‚ ƒ
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
RequiredPermissionKey	LLo „
,
LL„ …
t
LL† ‡
.
LL‡ 
	SortOrder
LL ‘
,
LL‘ ’
t
LL“ ”
.
LL” •
IsActive
LL• 
)
LL 
;
LL 
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
$str	QQT 
)
QQ ‚
;
QQ‚ ƒ
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
}`` „E
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
)	:: €
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
}cc ψn
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
.	 €
ToListAsync
€ ‹
(
‹ 
)
 
;
 
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
FirstOrDefaultAsync	"" ’
(
""’ “
u
""“ ”
=>
""• —
u
"" ™
.
""™ 
Id
"" 
==
"" 
id
""  Ά
)
""Ά £
;
""£ ¤
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
99€ …
.
99… †
Empty
99† ‹
<
99‹ 
int
99 
>
99 
(
99 ‘
)
99‘ ’
,
99’ “
new
99” —

Dictionary
99 Ά
<
99Ά £
int
99£ ¦
,
99¦ §
bool
99¨ ¬
>
99¬ ­
(
99­ ®
)
99® ―
,
99― °
user
99± µ
.
99µ ¶
ProfilePhoto
99¶ Β
)
99Β Γ
;
99Γ Δ
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
}ww ζε
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
€ 
	slaEngine
‹ ”
,
” •
IAssignmentEngine
– §
assignmentEngine
¨ Έ
,
Έ Ή%
INotificationDispatcher
Ί Ρ$
notificationDispatcher
Ò θ
)
θ ι
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
customFields	66x „
)
66„ …
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
==	:: 
typeId
::‚ 
)
:: ‰
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
Value	ff~ ƒ
)
ffƒ „
.
ff„ …
ToListAsync
ff… 
(
ff ‘
)
ff‘ ’
;
ff’ “
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
€€ 	
;
€€	 

_context
 
.
 
Tickets
 
.
 
Add
 
(
 
t
 
)
 
;
  
await
‚‚ 
_context
‚‚ 
.
‚‚ 
SaveChangesAsync
‚‚ '
(
‚‚' (
)
‚‚( )
;
‚‚) *
foreach
„„ 
(
„„ 
var
„„ 
kvp
„„ 
in
„„ 
dto
„„ 
.
„„  
CustomFields
„„  ,
)
„„, -
{
…… 	
var
†† 
def
†† 
=
†† 
await
†† 
_context
†† $
.
††$ %
FieldDefinitions
††% 5
.
††5 6!
FirstOrDefaultAsync
††6 I
(
††I J
fd
††J L
=>
††M O
fd
††P R
.
††R S
Key
††S V
==
††W Y
kvp
††Z ]
.
††] ^
Key
††^ a
)
††a b
;
††b c
if
‡‡ 
(
‡‡ 
def
‡‡ 
!=
‡‡ 
null
‡‡ 
)
‡‡ 
{
 
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
 
TicketId
‹‹ 
=
‹‹ 
t
‹‹  
.
‹‹  !
Id
‹‹! #
,
‹‹# $
FieldDefinitionId
 %
=
& '
def
( +
.
+ ,
Id
, .
,
. /
ValueString
 
=
  !
kvp
" %
.
% &
Value
& +
}
 
)
 
;
 
}
 
}
 	
_context
’’ 
.
’’ 
TicketHistories
’’  
.
’’  !
Add
’’! $
(
’’$ %
new
’’% (
TicketHistory
’’) 6
{
““ 	
TicketId
”” 
=
”” 
t
”” 
.
”” 
Id
”” 
,
”” 
Action
•• 
=
•• 
$str
•• 
,
•• 
	FieldName
–– 
=
–– 
$str
––  
,
––  !
NewValue
—— 
=
—— 
t
—— 
.
—— 
TicketNumber
—— %
,
——% &
	CreatedBy
 
=
 
dto
 
.
 
RequesterUserId
 +
.
+ ,
ToString
, 4
(
4 5
)
5 6
}
™™ 	
)
™™	 

;
™™
 
await
 
_context
 
.
 
SaveChangesAsync
 '
(
' (
)
( )
;
) *
await
 
_assignmentEngine
 
.
  
AssignTicketAsync
  1
(
1 2
t
2 3
)
3 4
;
4 5
await
 
_context
 
.
 
SaveChangesAsync
 '
(
' (
)
( )
;
) *
await
   

_slaEngine
   
.
   $
AttachSlaToTicketAsync
   /
(
  / 0
t
  0 1
.
  1 2
Id
  2 4
)
  4 5
;
  5 6
await
΅΅ %
_notificationDispatcher
΅΅ %
.
΅΅% & 
DispatchEventAsync
΅΅& 8
(
΅΅8 9
$str
΅΅9 I
,
΅΅I J
t
΅΅K L
.
΅΅L M
Id
΅΅M O
,
΅΅O P
dto
΅΅Q T
.
΅΅T U
RequesterUserId
΅΅U d
,
΅΅d e
$str΅΅f †
)΅΅† ‡
;΅΅‡ 
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

PriorityId££~ 
,££ ‰
t££ ‹
.££‹ 
RequesterUserId££ ›
,££› 
t££ 
.££ 
AssignedUserId££ ­
,££­ ®
t££― °
.££° ±
AssignedGroupId££± ΐ
,££ΐ Α
null££Β Ζ
)££Ζ Η
;££Η Θ
}
¤¤ 
public
¦¦ 

async
¦¦ 
Task
¦¦ 
<
¦¦ 
	TicketDto
¦¦ 
?
¦¦  
>
¦¦  ! 
GetTicketByIdAsync
¦¦" 4
(
¦¦4 5
int
¦¦5 8
id
¦¦9 ;
)
¦¦; <
{
§§ 
var
¨¨ 
t
¨¨ 
=
¨¨ 
await
¨¨ 
_context
¨¨ 
.
¨¨ 
Tickets
¨¨ &
.
¨¨& '!
FirstOrDefaultAsync
¨¨' :
(
¨¨: ;
x
¨¨; <
=>
¨¨= ?
x
¨¨@ A
.
¨¨A B
Id
¨¨B D
==
¨¨E G
id
¨¨H J
&&
¨¨K M
!
¨¨N O
x
¨¨O P
.
¨¨P Q
	IsDeleted
¨¨Q Z
)
¨¨Z [
;
¨¨[ \
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
«« 
customFields
«« 
=
«« 
await
««  
_context
««! )
.
««) *
TicketFieldValues
««* ;
.
¬¬ 
Include
¬¬ 
(
¬¬ 
tfv
¬¬ 
=>
¬¬ 
tfv
¬¬ 
.
¬¬  
FieldDefinition
¬¬  /
)
¬¬/ 0
.
­­ 
Where
­­ 
(
­­ 
tfv
­­ 
=>
­­ 
tfv
­­ 
.
­­ 
TicketId
­­ &
==
­­' )
id
­­* ,
)
­­, -
.
®® 
ToDictionaryAsync
®® 
(
®® 
tfv
®® "
=>
®®# %
tfv
®®& )
.
®®) *
FieldDefinition
®®* 9
!
®®9 :
.
®®: ;
Key
®®; >
,
®®> ?
tfv
®®@ C
=>
®®D F
tfv
®®G J
.
®®J K
ValueString
®®K V
)
®®V W
;
®®W X
return
°° 
new
°° 
	TicketDto
°° 
(
°° 
t
°° 
.
°° 
Id
°° !
,
°°! "
t
°°# $
.
°°$ %
TicketNumber
°°% 1
,
°°1 2
t
°°3 4
.
°°4 5
Title
°°5 :
,
°°: ;
t
°°< =
.
°°= >
Description
°°> I
,
°°I J
t
°°K L
.
°°L M
	ProjectId
°°M V
,
°°V W
t
°°X Y
.
°°Y Z

CategoryId
°°Z d
,
°°d e
t
°°f g
.
°°g h
TypeId
°°h n
,
°°n o
t
°°p q
.
°°q r
StatusId
°°r z
,
°°z {
t
°°| }
.
°°} ~

PriorityId°°~ 
,°° ‰
t°° ‹
.°°‹ 
RequesterUserId°° ›
,°°› 
t°° 
.°° 
AssignedUserId°° ­
,°°­ ®
t°°― °
.°°° ±
AssignedGroupId°°± ΐ
,°°ΐ Α
customFields°°Β Ξ
)°°Ξ Ο
;°°Ο Π
}
±± 
public
³³ 

async
³³ 
Task
³³ 
UpdateTicketAsync
³³ '
(
³³' (
int
³³( +
id
³³, .
,
³³. /
UpdateTicketDto
³³0 ?
dto
³³@ C
,
³³C D
int
³³E H
currentUserId
³³I V
)
³³V W
{
΄΄ 
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
¶¶ 

(
¶¶ 
t
¶¶ 
==
¶¶ 
null
¶¶ 
)
¶¶ 
throw
¶¶ 
new
¶¶  "
KeyNotFoundException
¶¶! 5
(
¶¶5 6#
TicketNotFoundMessage
¶¶6 K
)
¶¶K L
;
¶¶L M
await
ΈΈ (
ValidateDynamicFieldsAsync
ΈΈ (
(
ΈΈ( )
t
ΈΈ) *
.
ΈΈ* +
	ProjectId
ΈΈ+ 4
,
ΈΈ4 5
dto
ΈΈ6 9
.
ΈΈ9 :

CategoryId
ΈΈ: D
,
ΈΈD E
t
ΈΈF G
.
ΈΈG H
TypeId
ΈΈH N
,
ΈΈN O
dto
ΈΈP S
.
ΈΈS T
CustomFields
ΈΈT `
)
ΈΈ` a
;
ΈΈa b
var
ΊΊ 
historyEntries
ΊΊ 
=
ΊΊ 
new
ΊΊ  
List
ΊΊ! %
<
ΊΊ% &
TicketHistory
ΊΊ& 3
>
ΊΊ3 4
(
ΊΊ4 5
)
ΊΊ5 6
;
ΊΊ6 7
void
ΌΌ 
	CheckDiff
ΌΌ 
(
ΌΌ 
string
ΌΌ 
	fieldName
ΌΌ '
,
ΌΌ' (
string
ΌΌ) /
?
ΌΌ/ 0
oldVal
ΌΌ1 7
,
ΌΌ7 8
string
ΌΌ9 ?
?
ΌΌ? @
newVal
ΌΌA G
)
ΌΌG H
{
½½ 	
if
ΎΎ 
(
ΎΎ 
oldVal
ΎΎ 
!=
ΎΎ 
newVal
ΎΎ  
)
ΎΎ  !
{
ΏΏ 
historyEntries
ΐΐ 
.
ΐΐ 
Add
ΐΐ "
(
ΐΐ" #
new
ΐΐ# &
TicketHistory
ΐΐ' 4
{
ΑΑ 
TicketId
ΒΒ 
=
ΒΒ 
id
ΒΒ !
,
ΒΒ! "
Action
ΓΓ 
=
ΓΓ 
$str
ΓΓ &
,
ΓΓ& '
	FieldName
ΔΔ 
=
ΔΔ 
	fieldName
ΔΔ  )
,
ΔΔ) *
OldValue
ΕΕ 
=
ΕΕ 
oldVal
ΕΕ %
,
ΕΕ% &
NewValue
ΖΖ 
=
ΖΖ 
newVal
ΖΖ %
,
ΖΖ% &
	CreatedBy
ΗΗ 
=
ΗΗ 
currentUserId
ΗΗ  -
.
ΗΗ- .
ToString
ΗΗ. 6
(
ΗΗ6 7
)
ΗΗ7 8
}
ΘΘ 
)
ΘΘ 
;
ΘΘ 
}
ΙΙ 
}
ΚΚ 	
	CheckDiff
ΜΜ 
(
ΜΜ 
$str
ΜΜ 
,
ΜΜ 
t
ΜΜ 
.
ΜΜ 
Title
ΜΜ "
,
ΜΜ" #
dto
ΜΜ$ '
.
ΜΜ' (
Title
ΜΜ( -
)
ΜΜ- .
;
ΜΜ. /
	CheckDiff
ΝΝ 
(
ΝΝ 
$str
ΝΝ 
,
ΝΝ  
t
ΝΝ! "
.
ΝΝ" #
Description
ΝΝ# .
,
ΝΝ. /
dto
ΝΝ0 3
.
ΝΝ3 4
Description
ΝΝ4 ?
)
ΝΝ? @
;
ΝΝ@ A
	CheckDiff
ΞΞ 
(
ΞΞ 
$str
ΞΞ 
,
ΞΞ 
t
ΞΞ  !
.
ΞΞ! "

CategoryId
ΞΞ" ,
.
ΞΞ, -
ToString
ΞΞ- 5
(
ΞΞ5 6
)
ΞΞ6 7
,
ΞΞ7 8
dto
ΞΞ9 <
.
ΞΞ< =

CategoryId
ΞΞ= G
.
ΞΞG H
ToString
ΞΞH P
(
ΞΞP Q
)
ΞΞQ R
)
ΞΞR S
;
ΞΞS T
	CheckDiff
ΟΟ 
(
ΟΟ 
$str
ΟΟ 
,
ΟΟ 
t
ΟΟ  !
.
ΟΟ! "

PriorityId
ΟΟ" ,
.
ΟΟ, -
ToString
ΟΟ- 5
(
ΟΟ5 6
)
ΟΟ6 7
,
ΟΟ7 8
dto
ΟΟ9 <
.
ΟΟ< =

PriorityId
ΟΟ= G
.
ΟΟG H
ToString
ΟΟH P
(
ΟΟP Q
)
ΟΟQ R
)
ΟΟR S
;
ΟΟS T
t
ΡΡ 	
.
ΡΡ	 

Title
ΡΡ
 
=
ΡΡ 
dto
ΡΡ 
.
ΡΡ 
Title
ΡΡ 
;
ΡΡ 
t
ÒÒ 	
.
ÒÒ	 

Description
ÒÒ
 
=
ÒÒ 
dto
ÒÒ 
.
ÒÒ 
Description
ÒÒ '
;
ÒÒ' (
t
ΣΣ 	
.
ΣΣ	 


CategoryId
ΣΣ
 
=
ΣΣ 
dto
ΣΣ 
.
ΣΣ 

CategoryId
ΣΣ %
;
ΣΣ% &
t
ΤΤ 	
.
ΤΤ	 


PriorityId
ΤΤ
 
=
ΤΤ 
dto
ΤΤ 
.
ΤΤ 

PriorityId
ΤΤ %
;
ΤΤ% &
var
ΧΧ 
existingFields
ΧΧ 
=
ΧΧ 
await
ΧΧ "
_context
ΧΧ# +
.
ΧΧ+ ,
TicketFieldValues
ΧΧ, =
.
ΨΨ 
Include
ΨΨ 
(
ΨΨ 
f
ΨΨ 
=>
ΨΨ 
f
ΨΨ 
.
ΨΨ 
FieldDefinition
ΨΨ +
)
ΨΨ+ ,
.
ΩΩ 
Where
ΩΩ 
(
ΩΩ 
f
ΩΩ 
=>
ΩΩ 
f
ΩΩ 
.
ΩΩ 
TicketId
ΩΩ "
==
ΩΩ# %
id
ΩΩ& (
)
ΩΩ( )
.
ΪΪ 
ToListAsync
ΪΪ 
(
ΪΪ 
)
ΪΪ 
;
ΪΪ 
foreach
άά 
(
άά 
var
άά 
kvp
άά 
in
άά 
dto
άά 
.
άά  
CustomFields
άά  ,
)
άά, -
{
έέ 	
var
ήή 
def
ήή 
=
ήή 
await
ήή 
_context
ήή $
.
ήή$ %
FieldDefinitions
ήή% 5
.
ήή5 6!
FirstOrDefaultAsync
ήή6 I
(
ήήI J
fd
ήήJ L
=>
ήήM O
fd
ήήP R
.
ήήR S
Key
ήήS V
==
ήήW Y
kvp
ήήZ ]
.
ήή] ^
Key
ήή^ a
)
ήήa b
;
ήήb c
if
ίί 
(
ίί 
def
ίί 
==
ίί 
null
ίί 
)
ίί 
continue
ίί %
;
ίί% &
var
αα 
existing
αα 
=
αα 
existingFields
αα )
.
αα) *
FirstOrDefault
αα* 8
(
αα8 9
f
αα9 :
=>
αα; =
f
αα> ?
.
αα? @
FieldDefinitionId
αα@ Q
==
ααR T
def
ααU X
.
ααX Y
Id
ααY [
)
αα[ \
;
αα\ ]
if
ββ 
(
ββ 
existing
ββ 
==
ββ 
null
ββ  
)
ββ  !
{
γγ 
_context
δδ 
.
δδ 
TicketFieldValues
δδ *
.
δδ* +
Add
δδ+ .
(
δδ. /
new
δδ/ 2
TicketFieldValue
δδ3 C
{
εε 
TicketId
ζζ 
=
ζζ 
id
ζζ !
,
ζζ! "
FieldDefinitionId
ηη %
=
ηη& '
def
ηη( +
.
ηη+ ,
Id
ηη, .
,
ηη. /
ValueString
θθ 
=
θθ  !
kvp
θθ" %
.
θθ% &
Value
θθ& +
}
ιι 
)
ιι 
;
ιι 
	CheckDiff
κκ 
(
κκ 
kvp
κκ 
.
κκ 
Key
κκ !
,
κκ! "
null
κκ# '
,
κκ' (
kvp
κκ) ,
.
κκ, -
Value
κκ- 2
)
κκ2 3
;
κκ3 4
}
λλ 
else
μμ 
{
νν 
if
ξξ 
(
ξξ 
existing
ξξ 
.
ξξ 
ValueString
ξξ (
!=
ξξ) +
kvp
ξξ, /
.
ξξ/ 0
Value
ξξ0 5
)
ξξ5 6
{
οο 
	CheckDiff
ππ 
(
ππ 
kvp
ππ !
.
ππ! "
Key
ππ" %
,
ππ% &
existing
ππ' /
.
ππ/ 0
ValueString
ππ0 ;
,
ππ; <
kvp
ππ= @
.
ππ@ A
Value
ππA F
)
ππF G
;
ππG H
existing
ρρ 
.
ρρ 
ValueString
ρρ (
=
ρρ) *
kvp
ρρ+ .
.
ρρ. /
Value
ρρ/ 4
;
ρρ4 5
}
ςς 
}
σσ 
}
ττ 	
if
φφ 

(
φφ 
historyEntries
φφ 
.
φφ 
Any
φφ 
(
φφ 
)
φφ  
)
φφ  !
{
χχ 	
_context
ψψ 
.
ψψ 
TicketHistories
ψψ $
.
ψψ$ %
AddRange
ψψ% -
(
ψψ- .
historyEntries
ψψ. <
)
ψψ< =
;
ψψ= >
}
ωω 	
await
ϊϊ 
_context
ϊϊ 
.
ϊϊ 
SaveChangesAsync
ϊϊ '
(
ϊϊ' (
)
ϊϊ( )
;
ϊϊ) *
}
ϋϋ 
public
ώώ 

async
ώώ 
Task
ώώ 
<
ώώ 
IEnumerable
ώώ !
<
ώώ! "
	StatusDto
ώώ" +
>
ώώ+ ,
>
ώώ, -(
GetAllowedTransitionsAsync
ώώ. H
(
ώώH I
int
ώώI L
ticketId
ώώM U
,
ώώU V
int
ώώW Z
userId
ώώ[ a
)
ώώa b
{
ÿÿ 
var
€€ 
t
€€ 
=
€€ 
await
€€ 
_context
€€ 
.
€€ 
Tickets
€€ &
.
€€& '!
FirstOrDefaultAsync
€€' :
(
€€: ;
x
€€; <
=>
€€= ?
x
€€@ A
.
€€A B
Id
€€B D
==
€€E G
ticketId
€€H P
&&
€€Q S
!
€€T U
x
€€U V
.
€€V W
	IsDeleted
€€W `
)
€€` a
;
€€a b
if
 

(
 
t
 
==
 
null
 
)
 
throw
 
new
  "
KeyNotFoundException
! 5
(
5 6#
TicketNotFoundMessage
6 K
)
K L
;
L M
var
ƒƒ 
wf
ƒƒ 
=
ƒƒ 
await
ƒƒ 
_context
ƒƒ 
.
ƒƒ  
	Workflows
ƒƒ  )
.
„„ 
Where
„„ 
(
„„ 
w
„„ 
=>
„„ 
(
„„ 
w
„„ 
.
„„ 
	ProjectId
„„ $
==
„„% '
t
„„( )
.
„„) *
	ProjectId
„„* 3
||
„„4 6
w
„„7 8
.
„„8 9
	ProjectId
„„9 B
==
„„C E
null
„„F J
)
„„J K
&&
„„L N
!
„„O P
w
„„P Q
.
„„Q R
	IsDeleted
„„R [
)
„„[ \
.
…… 
OrderByDescending
…… 
(
…… 
w
……  
=>
……! #
w
……$ %
.
……% &
	ProjectId
……& /
==
……0 2
t
……3 4
.
……4 5
	ProjectId
……5 >
?
……? @
$num
……A B
:
……C D
$num
……E F
)
……F G
.
†† !
FirstOrDefaultAsync
††  
(
††  !
)
††! "
;
††" #
if
‡‡ 

(
‡‡ 
wf
‡‡ 
==
‡‡ 
null
‡‡ 
)
‡‡ 
return
‡‡ 

Enumerable
‡‡ )
.
‡‡) *
Empty
‡‡* /
<
‡‡/ 0
	StatusDto
‡‡0 9
>
‡‡9 :
(
‡‡: ;
)
‡‡; <
;
‡‡< =
var
‰‰ 
	userPerms
‰‰ 
=
‰‰ 
await
‰‰ #
_permissionCalculator
‰‰ 3
.
‰‰3 40
"CalculateEffectivePermissionsAsync
‰‰4 V
(
‰‰V W
userId
‰‰W ]
)
‰‰] ^
;
‰‰^ _
var
‹‹ 
transitions
‹‹ 
=
‹‹ 
await
‹‹ 
_context
‹‹  (
.
‹‹( )!
WorkflowTransitions
‹‹) <
.
 
Include
 
(
 
wt
 
=>
 
wt
 
.
 
ToStatus
 &
)
& '
.
 
Where
 
(
 
wt
 
=>
 
wt
 
.
 

WorkflowId
 &
==
' )
wf
* ,
.
, -
Id
- /
&&
0 2
wt
3 5
.
5 6
FromStatusId
6 B
==
C E
t
F G
.
G H
StatusId
H P
&&
Q S
!
T U
wt
U W
.
W X
	IsDeleted
X a
&&
b d
wt
e g
.
g h
IsActive
h p
)
p q
.
 
ToListAsync
 
(
 
)
 
;
 
var
 
allowed
 
=
 
transitions
 !
.
! "
Where
" '
(
' (
wt
( *
=>
+ -
string
‘‘ 
.
‘‘ 
IsNullOrEmpty
‘‘  
(
‘‘  !
wt
‘‘! #
.
‘‘# $#
RequiredPermissionKey
‘‘$ 9
)
‘‘9 :
||
‘‘; =
	userPerms
‘‘> G
.
‘‘G H
Contains
‘‘H P
(
‘‘P Q
wt
‘‘Q S
.
‘‘S T#
RequiredPermissionKey
‘‘T i
)
‘‘i j
)
‘‘j k
.
’’ 
Select
’’ 
(
’’ 
wt
’’ 
=>
’’ 
new
’’ 
	StatusDto
’’ '
(
’’' (
wt
““ 
.
““ 
ToStatus
““ 
!
““ 
.
““ 
Id
““ 
,
““  
wt
”” 
.
”” 
ToStatus
”” 
.
”” 
Name
””  
,
””  !
null
•• 
,
•• 
wt
–– 
.
–– 
ToStatus
–– 
.
–– 
	SortOrder
–– %
,
––% &
wt
—— 
.
—— 
ToStatus
—— 
.
—— 
IsClosedStatus
—— *
,
——* +
wt
 
.
 
ToStatus
 
.
 
IsSystemDefault
 +
,
+ ,
true
™™ 
)
 
)
 
.
›› 
OrderBy
›› 
(
›› 
s
›› 
=>
›› 
s
›› 
.
›› 
	SortOrder
›› %
)
››% &
.
 
ToList
 
(
 
)
 
;
 
var
 
currentStatus
 
=
 
await
 !
_context
" *
.
* +
Statuses
+ 3
.
3 4!
FirstOrDefaultAsync
4 G
(
G H
s
H I
=>
J L
s
M N
.
N O
Id
O Q
==
R T
t
U V
.
V W
StatusId
W _
)
_ `
;
` a
if
   

(
   
currentStatus
   
!=
   
null
   !
&&
  " $
!
  % &
allowed
  & -
.
  - .
Any
  . 1
(
  1 2
a
  2 3
=>
  4 6
a
  7 8
.
  8 9
Id
  9 ;
==
  < >
currentStatus
  ? L
.
  L M
Id
  M O
)
  O P
)
  P Q
{
΅΅ 	
allowed
ΆΆ 
.
ΆΆ 
Insert
ΆΆ 
(
ΆΆ 
$num
ΆΆ 
,
ΆΆ 
new
ΆΆ !
	StatusDto
ΆΆ" +
(
ΆΆ+ ,
currentStatus
££ 
.
££ 
Id
££  
,
££  !
currentStatus
¤¤ 
.
¤¤ 
Name
¤¤ "
,
¤¤" #
null
¥¥ 
,
¥¥ 
currentStatus
¦¦ 
.
¦¦ 
	SortOrder
¦¦ '
,
¦¦' (
currentStatus
§§ 
.
§§ 
IsClosedStatus
§§ ,
,
§§, -
currentStatus
¨¨ 
.
¨¨ 
IsSystemDefault
¨¨ -
,
¨¨- .
true
©© 
)
ªª 
)
ªª 
;
ªª 
}
«« 	
return
­­ 
allowed
­­ 
;
­­ 
}
®® 
public
°° 

async
°° 
Task
°° 
ChangeStatusAsync
°° '
(
°°' (
int
°°( +
ticketId
°°, 4
,
°°4 5
ChangeStatusDto
°°6 E
dto
°°F I
)
°°I J
{
±± 
var
²² 
t
²² 
=
²² 
await
²² 
_context
²² 
.
²² 
Tickets
²² &
.
²²& '!
FirstOrDefaultAsync
²²' :
(
²²: ;
x
²²; <
=>
²²= ?
x
²²@ A
.
²²A B
Id
²²B D
==
²²E G
ticketId
²²H P
&&
²²Q S
!
²²T U
x
²²U V
.
²²V W
	IsDeleted
²²W `
)
²²` a
;
²²a b
if
³³ 

(
³³ 
t
³³ 
==
³³ 
null
³³ 
)
³³ 
throw
³³ 
new
³³  "
KeyNotFoundException
³³! 5
(
³³5 6#
TicketNotFoundMessage
³³6 K
)
³³K L
;
³³L M
if
µµ 

(
µµ 
t
µµ 
.
µµ 
StatusId
µµ 
==
µµ 
dto
µµ 
.
µµ 
NewStatusId
µµ )
)
µµ) *
return
µµ+ 1
;
µµ1 2
var
ΈΈ 
wf
ΈΈ 
=
ΈΈ 
await
ΈΈ 
_context
ΈΈ 
.
ΈΈ  
	Workflows
ΈΈ  )
.
ΉΉ 
Where
ΉΉ 
(
ΉΉ 
w
ΉΉ 
=>
ΉΉ 
(
ΉΉ 
w
ΉΉ 
.
ΉΉ 
	ProjectId
ΉΉ $
==
ΉΉ% '
t
ΉΉ( )
.
ΉΉ) *
	ProjectId
ΉΉ* 3
||
ΉΉ4 6
w
ΉΉ7 8
.
ΉΉ8 9
	ProjectId
ΉΉ9 B
==
ΉΉC E
null
ΉΉF J
)
ΉΉJ K
&&
ΉΉL N
!
ΉΉO P
w
ΉΉP Q
.
ΉΉQ R
	IsDeleted
ΉΉR [
)
ΉΉ[ \
.
ΊΊ 
OrderByDescending
ΊΊ 
(
ΊΊ 
w
ΊΊ  
=>
ΊΊ! #
w
ΊΊ$ %
.
ΊΊ% &
	ProjectId
ΊΊ& /
==
ΊΊ0 2
t
ΊΊ3 4
.
ΊΊ4 5
	ProjectId
ΊΊ5 >
?
ΊΊ? @
$num
ΊΊA B
:
ΊΊC D
$num
ΊΊE F
)
ΊΊF G
.
»» !
FirstOrDefaultAsync
»»  
(
»»  !
)
»»! "
;
»»" #
if
ΌΌ 

(
ΌΌ 
wf
ΌΌ 
==
ΌΌ 
null
ΌΌ 
)
ΌΌ 
throw
ΌΌ 
new
ΌΌ !'
InvalidOperationException
ΌΌ" ;
(
ΌΌ; <
$str
ΌΌ< \
)
ΌΌ\ ]
;
ΌΌ] ^
var
ΎΎ 

transition
ΎΎ 
=
ΎΎ 
await
ΎΎ 
_context
ΎΎ '
.
ΎΎ' (!
WorkflowTransitions
ΎΎ( ;
.
ΎΎ; <!
FirstOrDefaultAsync
ΎΎ< O
(
ΎΎO P
wt
ΎΎP R
=>
ΎΎS U
wt
ΏΏ 
.
ΏΏ 

WorkflowId
ΏΏ 
==
ΏΏ 
wf
ΏΏ 
.
ΏΏ  
Id
ΏΏ  "
&&
ΏΏ# %
wt
ΏΏ& (
.
ΏΏ( )
FromStatusId
ΏΏ) 5
==
ΏΏ6 8
t
ΏΏ9 :
.
ΏΏ: ;
StatusId
ΏΏ; C
&&
ΏΏD F
wt
ΏΏG I
.
ΏΏI J

ToStatusId
ΏΏJ T
==
ΏΏU W
dto
ΏΏX [
.
ΏΏ[ \
NewStatusId
ΏΏ\ g
&&
ΏΏh j
!
ΏΏk l
wt
ΏΏl n
.
ΏΏn o
	IsDeleted
ΏΏo x
&&
ΏΏy {
wt
ΏΏ| ~
.
ΏΏ~ 
IsActiveΏΏ ‡
)ΏΏ‡ 
;ΏΏ ‰
if
ΑΑ 

(
ΑΑ 

transition
ΑΑ 
==
ΑΑ 
null
ΑΑ 
)
ΑΑ 
throw
ΒΒ 
new
ΒΒ '
InvalidOperationException
ΒΒ /
(
ΒΒ/ 0
$str
ΒΒ0 L
)
ΒΒL M
;
ΒΒM N
if
ΔΔ 

(
ΔΔ 
!
ΔΔ 
string
ΔΔ 
.
ΔΔ 
IsNullOrEmpty
ΔΔ !
(
ΔΔ! "

transition
ΔΔ" ,
.
ΔΔ, -#
RequiredPermissionKey
ΔΔ- B
)
ΔΔB C
)
ΔΔC D
{
ΕΕ 	
var
ΖΖ 
perms
ΖΖ 
=
ΖΖ 
await
ΖΖ #
_permissionCalculator
ΖΖ 3
.
ΖΖ3 40
"CalculateEffectivePermissionsAsync
ΖΖ4 V
(
ΖΖV W
dto
ΖΖW Z
.
ΖΖZ [
UserId
ΖΖ[ a
)
ΖΖa b
;
ΖΖb c
if
ΗΗ 
(
ΗΗ 
!
ΗΗ 
perms
ΗΗ 
.
ΗΗ 
Contains
ΗΗ 
(
ΗΗ  

transition
ΗΗ  *
.
ΗΗ* +#
RequiredPermissionKey
ΗΗ+ @
)
ΗΗ@ A
)
ΗΗA B
throw
ΘΘ 
new
ΘΘ )
UnauthorizedAccessException
ΘΘ 5
(
ΘΘ5 6
$"
ΘΘ6 8
$str
ΘΘ8 U
{
ΘΘU V

transition
ΘΘV `
.
ΘΘ` a#
RequiredPermissionKey
ΘΘa v
}
ΘΘv w
"
ΘΘw x
)
ΘΘx y
;
ΘΘy z
}
ΙΙ 	
var
ΛΛ 
	oldStatus
ΛΛ 
=
ΛΛ 
t
ΛΛ 
.
ΛΛ 
StatusId
ΛΛ "
;
ΛΛ" #
t
ΜΜ 	
.
ΜΜ	 

StatusId
ΜΜ
 
=
ΜΜ 
dto
ΜΜ 
.
ΜΜ 
NewStatusId
ΜΜ $
;
ΜΜ$ %
_context
ΞΞ 
.
ΞΞ 
TicketHistories
ΞΞ  
.
ΞΞ  !
Add
ΞΞ! $
(
ΞΞ$ %
new
ΞΞ% (
TicketHistory
ΞΞ) 6
{
ΟΟ 	
TicketId
ΠΠ 
=
ΠΠ 
t
ΠΠ 
.
ΠΠ 
Id
ΠΠ 
,
ΠΠ 
Action
ΡΡ 
=
ΡΡ 

transition
ΡΡ 
.
ΡΡ  
TransitionName
ΡΡ  .
.
ΡΡ. /
Contains
ΡΡ/ 7
(
ΡΡ7 8
$str
ΡΡ8 @
)
ΡΡ@ A
?
ΡΡB C
$str
ΡΡD N
:
ΡΡO P
$str
ΡΡQ `
,
ΡΡ` a
	FieldName
ÒÒ 
=
ÒÒ 
$str
ÒÒ "
,
ÒÒ" #
OldValue
ΣΣ 
=
ΣΣ 
	oldStatus
ΣΣ  
.
ΣΣ  !
ToString
ΣΣ! )
(
ΣΣ) *
)
ΣΣ* +
,
ΣΣ+ ,
NewValue
ΤΤ 
=
ΤΤ 
dto
ΤΤ 
.
ΤΤ 
NewStatusId
ΤΤ &
.
ΤΤ& '
ToString
ΤΤ' /
(
ΤΤ/ 0
)
ΤΤ0 1
,
ΤΤ1 2
	CreatedBy
ΥΥ 
=
ΥΥ 
dto
ΥΥ 
.
ΥΥ 
UserId
ΥΥ "
.
ΥΥ" #
ToString
ΥΥ# +
(
ΥΥ+ ,
)
ΥΥ, -
}
ΦΦ 	
)
ΦΦ	 

;
ΦΦ
 
await
ΨΨ 
_context
ΨΨ 
.
ΨΨ 
SaveChangesAsync
ΨΨ '
(
ΨΨ' (
)
ΨΨ( )
;
ΨΨ) *
await
ΪΪ 

_slaEngine
ΪΪ 
.
ΪΪ ,
ProcessTicketStatusChangeAsync
ΪΪ 7
(
ΪΪ7 8
t
ΪΪ8 9
.
ΪΪ9 :
Id
ΪΪ: <
,
ΪΪ< =
	oldStatus
ΪΪ> G
,
ΪΪG H
dto
ΪΪI L
.
ΪΪL M
NewStatusId
ΪΪM X
)
ΪΪX Y
;
ΪΪY Z
if
έέ 

(
έέ 
dto
έέ 
.
έέ 
NewStatusId
έέ 
==
έέ 
$num
έέ  
&&
έέ! #
	oldStatus
έέ$ -
!=
έέ. 0
$num
έέ1 2
)
έέ2 3
{
ήή 	
await
ίί %
_notificationDispatcher
ίί )
.
ίί) * 
DispatchEventAsync
ίί* <
(
ίί< =
$str
ίί= S
,
ίίS T
t
ίίU V
.
ίίV W
Id
ίίW Y
,
ίίY Z
dto
ίί[ ^
.
ίί^ _
UserId
ίί_ e
,
ίίe f
$strίίg ®
)ίί® ―
;ίί― °
}
ΰΰ 	
}
αα 
public
γγ 

async
γγ 
Task
γγ 
AssignTicketAsync
γγ '
(
γγ' (
int
γγ( +
ticketId
γγ, 4
,
γγ4 5
AssignTicketDto
γγ6 E
dto
γγF I
)
γγI J
{
δδ 
var
εε 
t
εε 
=
εε 
await
εε 
_context
εε 
.
εε 
Tickets
εε &
.
εε& '!
FirstOrDefaultAsync
εε' :
(
εε: ;
x
εε; <
=>
εε= ?
x
εε@ A
.
εεA B
Id
εεB D
==
εεE G
ticketId
εεH P
&&
εεQ S
!
εεT U
x
εεU V
.
εεV W
	IsDeleted
εεW `
)
εε` a
;
εεa b
if
ζζ 

(
ζζ 
t
ζζ 
==
ζζ 
null
ζζ 
)
ζζ 
throw
ζζ 
new
ζζ  "
KeyNotFoundException
ζζ! 5
(
ζζ5 6#
TicketNotFoundMessage
ζζ6 K
)
ζζK L
;
ζζL M
var
θθ 
perms
θθ 
=
θθ 
await
θθ #
_permissionCalculator
θθ /
.
θθ/ 00
"CalculateEffectivePermissionsAsync
θθ0 R
(
θθR S
dto
θθS V
.
θθV W
AssignerUserId
θθW e
)
θθe f
;
θθf g
if
ιι 

(
ιι 
!
ιι 
perms
ιι 
.
ιι 
Contains
ιι 
(
ιι 
$str
ιι +
)
ιι+ ,
)
ιι, -
throw
ιι. 3
new
ιι4 7)
UnauthorizedAccessException
ιι8 S
(
ιιS T
$str
ιιT w
)
ιιw x
;
ιιx y
var
λλ 
oldAssignee
λλ 
=
λλ 
t
λλ 
.
λλ 
AssignedUserId
λλ *
;
λλ* +
t
μμ 	
.
μμ	 

AssignedUserId
μμ
 
=
μμ 
dto
μμ 
.
μμ 
UserId
μμ %
;
μμ% &
_context
ξξ 
.
ξξ 
TicketHistories
ξξ  
.
ξξ  !
Add
ξξ! $
(
ξξ$ %
new
ξξ% (
TicketHistory
ξξ) 6
{
οο 	
TicketId
ππ 
=
ππ 
t
ππ 
.
ππ 
Id
ππ 
,
ππ 
Action
ρρ 
=
ρρ 
$str
ρρ 
,
ρρ  
	FieldName
ςς 
=
ςς 
$str
ςς (
,
ςς( )
OldValue
σσ 
=
σσ 
oldAssignee
σσ "
?
σσ" #
.
σσ# $
ToString
σσ$ ,
(
σσ, -
)
σσ- .
,
σσ. /
NewValue
ττ 
=
ττ 
dto
ττ 
.
ττ 
UserId
ττ !
.
ττ! "
ToString
ττ" *
(
ττ* +
)
ττ+ ,
,
ττ, -
	CreatedBy
υυ 
=
υυ 
dto
υυ 
.
υυ 
AssignerUserId
υυ *
.
υυ* +
ToString
υυ+ 3
(
υυ3 4
)
υυ4 5
}
φφ 	
)
φφ	 

;
φφ
 
await
ψψ 
_context
ψψ 
.
ψψ 
SaveChangesAsync
ψψ '
(
ψψ' (
)
ψψ( )
;
ψψ) *
await
ωω %
_notificationDispatcher
ωω %
.
ωω% & 
DispatchEventAsync
ωω& 8
(
ωω8 9
$str
ωω9 J
,
ωωJ K
t
ωωL M
.
ωωM N
Id
ωωN P
,
ωωP Q
dto
ωωR U
.
ωωU V
AssignerUserId
ωωV d
,
ωωd e
$"
ωωf h
$str
ωωh {
{
ωω{ |
dto
ωω| 
.ωω €
UserIdωω€ †
}ωω† ‡
"ωω‡ 
)ωω ‰
;ωω‰ 
}
ϊϊ 
public
όό 

async
όό 
Task
όό !
TransferTicketAsync
όό )
(
όό) *
int
όό* -
ticketId
όό. 6
,
όό6 7
TransferTicketDto
όό8 I
dto
όόJ M
)
όόM N
{
ύύ 
var
ώώ 
t
ώώ 
=
ώώ 
await
ώώ 
_context
ώώ 
.
ώώ 
Tickets
ώώ &
.
ώώ& '!
FirstOrDefaultAsync
ώώ' :
(
ώώ: ;
x
ώώ; <
=>
ώώ= ?
x
ώώ@ A
.
ώώA B
Id
ώώB D
==
ώώE G
ticketId
ώώH P
&&
ώώQ S
!
ώώT U
x
ώώU V
.
ώώV W
	IsDeleted
ώώW `
)
ώώ` a
;
ώώa b
if
ÿÿ 

(
ÿÿ 
t
ÿÿ 
==
ÿÿ 
null
ÿÿ 
)
ÿÿ 
throw
ÿÿ 
new
ÿÿ  "
KeyNotFoundException
ÿÿ! 5
(
ÿÿ5 6#
TicketNotFoundMessage
ÿÿ6 K
)
ÿÿK L
;
ÿÿL M
var
 
perms
 
=
 
await
 #
_permissionCalculator
 /
.
/ 00
"CalculateEffectivePermissionsAsync
0 R
(
R S
dto
S V
.
V W
TransferrerUserId
W h
)
h i
;
i j
if
‚‚ 

(
‚‚ 
!
‚‚ 
perms
‚‚ 
.
‚‚ 
Contains
‚‚ 
(
‚‚ 
$str
‚‚ -
)
‚‚- .
)
‚‚. /
throw
‚‚0 5
new
‚‚6 9)
UnauthorizedAccessException
‚‚: U
(
‚‚U V
$str
‚‚V {
)
‚‚{ |
;
‚‚| }
var
„„ 
oldProj
„„ 
=
„„ 
t
„„ 
.
„„ 
	ProjectId
„„ !
;
„„! "
var
…… 
oldGroup
…… 
=
…… 
t
…… 
.
…… 
AssignedGroupId
…… (
;
……( )
if
‡‡ 

(
‡‡ 
dto
‡‡ 
.
‡‡ 
	ProjectId
‡‡ 
.
‡‡ 
HasValue
‡‡ "
)
‡‡" #
t
‡‡$ %
.
‡‡% &
	ProjectId
‡‡& /
=
‡‡0 1
dto
‡‡2 5
.
‡‡5 6
	ProjectId
‡‡6 ?
.
‡‡? @
Value
‡‡@ E
;
‡‡E F
if
 

(
 
dto
 
.
 
GroupId
 
.
 
HasValue
  
)
  !
t
" #
.
# $
AssignedGroupId
$ 3
=
4 5
dto
6 9
.
9 :
GroupId
: A
.
A B
Value
B G
;
G H
_context
 
.
 
TicketHistories
  
.
  !
Add
! $
(
$ %
new
% (
TicketHistory
) 6
{
‹‹ 	
TicketId
 
=
 
t
 
.
 
Id
 
,
 
Action
 
=
 
$str
 "
,
" #
	FieldName
 
=
 
$str
 "
,
" #
OldValue
 
=
 
$"
 
$str
 
{
 
oldProj
 &
}
& '
$str
' ,
{
, -
oldGroup
- 5
}
5 6
"
6 7
,
7 8
NewValue
 
=
 
$"
 
$str
 
{
 
t
  
.
  !
	ProjectId
! *
}
* +
$str
+ 0
{
0 1
t
1 2
.
2 3
AssignedGroupId
3 B
}
B C
"
C D
,
D E
	CreatedBy
‘‘ 
=
‘‘ 
dto
‘‘ 
.
‘‘ 
TransferrerUserId
‘‘ -
.
‘‘- .
ToString
‘‘. 6
(
‘‘6 7
)
‘‘7 8
}
’’ 	
)
’’	 

;
’’
 
await
”” 
_context
”” 
.
”” 
SaveChangesAsync
”” '
(
””' (
)
””( )
;
””) *
}
•• 
public
—— 

async
—— 
Task
—— 
<
—— 
TicketCommentDto
—— &
>
——& '
AddCommentAsync
——( 7
(
——7 8
int
——8 ;
ticketId
——< D
,
——D E
CreateCommentDto
——F V
dto
——W Z
)
——Z [
{
 
var
™™ 
c
™™ 
=
™™ 
new
™™ 
TicketComment
™™ !
{
 	
TicketId
›› 
=
›› 
ticketId
›› 
,
››  
Content
 
=
 
dto
 
.
 
Content
 !
,
! "

IsInternal
 
=
 
dto
 
.
 

IsInternal
 '
,
' (
AuthorUserId
 
=
 
dto
 
.
 
AuthorUserId
 +
}
 	
;
	 

_context
   
.
   
TicketComments
   
.
    
Add
    #
(
  # $
c
  $ %
)
  % &
;
  & '
_context
ΆΆ 
.
ΆΆ 
TicketHistories
ΆΆ  
.
ΆΆ  !
Add
ΆΆ! $
(
ΆΆ$ %
new
ΆΆ% (
TicketHistory
ΆΆ) 6
{
££ 	
TicketId
¤¤ 
=
¤¤ 
ticketId
¤¤ 
,
¤¤  
Action
¥¥ 
=
¥¥ 
$str
¥¥ #
,
¥¥# $
	FieldName
¦¦ 
=
¦¦ 
$str
¦¦ !
,
¦¦! "
NewValue
§§ 
=
§§ 
c
§§ 
.
§§ 
Id
§§ 
.
§§ 
ToString
§§ $
(
§§$ %
)
§§% &
,
§§& '
	CreatedBy
¨¨ 
=
¨¨ 
dto
¨¨ 
.
¨¨ 
AuthorUserId
¨¨ (
.
¨¨( )
ToString
¨¨) 1
(
¨¨1 2
)
¨¨2 3
}
©© 	
)
©©	 

;
©©
 
await
«« 
_context
«« 
.
«« 
SaveChangesAsync
«« '
(
««' (
)
««( )
;
««) *
await
­­ 

_slaEngine
­­ 
.
­­ '
ProcessTicketCommentAsync
­­ 2
(
­­2 3
ticketId
­­3 ;
,
­­; <
dto
­­= @
.
­­@ A

IsInternal
­­A K
)
­­K L
;
­­L M
await
®® %
_notificationDispatcher
®® %
.
®®% & 
DispatchEventAsync
®®& 8
(
®®8 9
$str
®®9 O
,
®®O P
ticketId
®®Q Y
,
®®Y Z
dto
®®[ ^
.
®®^ _
AuthorUserId
®®_ k
,
®®k l
$str®®m ‡
)®®‡ 
;®® ‰
return
°° 
new
°° 
TicketCommentDto
°° #
(
°°# $
c
°°$ %
.
°°% &
Id
°°& (
,
°°( )
c
°°* +
.
°°+ ,
TicketId
°°, 4
,
°°4 5
c
°°6 7
.
°°7 8
AuthorUserId
°°8 D
,
°°D E
c
°°F G
.
°°G H
Content
°°H O
,
°°O P
c
°°Q R
.
°°R S

IsInternal
°°S ]
,
°°] ^
c
°°_ `
.
°°` a
	CreatedAt
°°a j
)
°°j k
;
°°k l
}
±± 
public
³³ 

async
³³ 
Task
³³ 
<
³³ 
IEnumerable
³³ !
<
³³! "
TicketCommentDto
³³" 2
>
³³2 3
>
³³3 4
GetCommentsAsync
³³5 E
(
³³E F
int
³³F I
ticketId
³³J R
,
³³R S
bool
³³T X
includeInternal
³³Y h
)
³³h i
{
΄΄ 
var
µµ 
q
µµ 
=
µµ 
_context
µµ 
.
µµ 
TicketComments
µµ '
.
µµ' (
Where
µµ( -
(
µµ- .
c
µµ. /
=>
µµ0 2
c
µµ3 4
.
µµ4 5
TicketId
µµ5 =
==
µµ> @
ticketId
µµA I
&&
µµJ L
!
µµM N
c
µµN O
.
µµO P
	IsDeleted
µµP Y
)
µµY Z
;
µµZ [
if
¶¶ 

(
¶¶ 
!
¶¶ 
includeInternal
¶¶ 
)
¶¶ 
q
¶¶ 
=
¶¶  !
q
¶¶" #
.
¶¶# $
Where
¶¶$ )
(
¶¶) *
c
¶¶* +
=>
¶¶, .
!
¶¶/ 0
c
¶¶0 1
.
¶¶1 2

IsInternal
¶¶2 <
)
¶¶< =
;
¶¶= >
var
ΈΈ 
list
ΈΈ 
=
ΈΈ 
await
ΈΈ 
q
ΈΈ 
.
ΈΈ 
OrderBy
ΈΈ "
(
ΈΈ" #
c
ΈΈ# $
=>
ΈΈ% '
c
ΈΈ( )
.
ΈΈ) *
	CreatedAt
ΈΈ* 3
)
ΈΈ3 4
.
ΈΈ4 5
ToListAsync
ΈΈ5 @
(
ΈΈ@ A
)
ΈΈA B
;
ΈΈB C
return
ΉΉ 
list
ΉΉ 
.
ΉΉ 
Select
ΉΉ 
(
ΉΉ 
c
ΉΉ 
=>
ΉΉ 
new
ΉΉ  #
TicketCommentDto
ΉΉ$ 4
(
ΉΉ4 5
c
ΉΉ5 6
.
ΉΉ6 7
Id
ΉΉ7 9
,
ΉΉ9 :
c
ΉΉ; <
.
ΉΉ< =
TicketId
ΉΉ= E
,
ΉΉE F
c
ΉΉG H
.
ΉΉH I
AuthorUserId
ΉΉI U
,
ΉΉU V
c
ΉΉW X
.
ΉΉX Y
Content
ΉΉY `
,
ΉΉ` a
c
ΉΉb c
.
ΉΉc d

IsInternal
ΉΉd n
,
ΉΉn o
c
ΉΉp q
.
ΉΉq r
	CreatedAt
ΉΉr {
)
ΉΉ{ |
)
ΉΉ| }
;
ΉΉ} ~
}
ΊΊ 
public
ΌΌ 

async
ΌΌ 
Task
ΌΌ 
<
ΌΌ !
TicketAttachmentDto
ΌΌ )
>
ΌΌ) * 
AddAttachmentAsync
ΌΌ+ =
(
ΌΌ= >
int
ΌΌ> A
ticketId
ΌΌB J
,
ΌΌJ K
	IFormFile
ΌΌL U
file
ΌΌV Z
,
ΌΌZ [
int
ΌΌ\ _
userId
ΌΌ` f
)
ΌΌf g
{
½½ 
var
ΎΎ 
path
ΎΎ 
=
ΎΎ 
await
ΎΎ 
_fileStorage
ΎΎ %
.
ΎΎ% &
SaveFileAsync
ΎΎ& 3
(
ΎΎ3 4
file
ΎΎ4 8
,
ΎΎ8 9
ticketId
ΎΎ: B
)
ΎΎB C
;
ΎΎC D
var
ΐΐ 
a
ΐΐ 
=
ΐΐ 
new
ΐΐ 
TicketAttachment
ΐΐ $
{
ΑΑ 	
TicketId
ΒΒ 
=
ΒΒ 
ticketId
ΒΒ 
,
ΒΒ  
FileName
ΓΓ 
=
ΓΓ 
file
ΓΓ 
.
ΓΓ 
FileName
ΓΓ $
,
ΓΓ$ %
FilePath
ΔΔ 
=
ΔΔ 
path
ΔΔ 
,
ΔΔ 
FileSize
ΕΕ 
=
ΕΕ 
file
ΕΕ 
.
ΕΕ 
Length
ΕΕ "
,
ΕΕ" #
ContentType
ΖΖ 
=
ΖΖ 
file
ΖΖ 
.
ΖΖ 
ContentType
ΖΖ *
,
ΖΖ* +
UploadedByUserId
ΗΗ 
=
ΗΗ 
userId
ΗΗ %
}
ΘΘ 	
;
ΘΘ	 

_context
ΙΙ 
.
ΙΙ 
TicketAttachments
ΙΙ "
.
ΙΙ" #
Add
ΙΙ# &
(
ΙΙ& '
a
ΙΙ' (
)
ΙΙ( )
;
ΙΙ) *
_context
ΛΛ 
.
ΛΛ 
TicketHistories
ΛΛ  
.
ΛΛ  !
Add
ΛΛ! $
(
ΛΛ$ %
new
ΛΛ% (
TicketHistory
ΛΛ) 6
{
ΜΜ 	
TicketId
ΝΝ 
=
ΝΝ 
ticketId
ΝΝ 
,
ΝΝ  
Action
ΞΞ 
=
ΞΞ 
$str
ΞΞ &
,
ΞΞ& '
	FieldName
ΟΟ 
=
ΟΟ 
$str
ΟΟ $
,
ΟΟ$ %
NewValue
ΠΠ 
=
ΠΠ 
a
ΠΠ 
.
ΠΠ 
FileName
ΠΠ !
,
ΠΠ! "
	CreatedBy
ΡΡ 
=
ΡΡ 
userId
ΡΡ 
.
ΡΡ 
ToString
ΡΡ '
(
ΡΡ' (
)
ΡΡ( )
}
ÒÒ 	
)
ÒÒ	 

;
ÒÒ
 
await
ΤΤ 
_context
ΤΤ 
.
ΤΤ 
SaveChangesAsync
ΤΤ '
(
ΤΤ' (
)
ΤΤ( )
;
ΤΤ) *
return
ΥΥ 
new
ΥΥ !
TicketAttachmentDto
ΥΥ &
(
ΥΥ& '
a
ΥΥ' (
.
ΥΥ( )
Id
ΥΥ) +
,
ΥΥ+ ,
a
ΥΥ- .
.
ΥΥ. /
TicketId
ΥΥ/ 7
,
ΥΥ7 8
a
ΥΥ9 :
.
ΥΥ: ;
FileName
ΥΥ; C
,
ΥΥC D
a
ΥΥE F
.
ΥΥF G
FilePath
ΥΥG O
,
ΥΥO P
a
ΥΥQ R
.
ΥΥR S
FileSize
ΥΥS [
,
ΥΥ[ \
a
ΥΥ] ^
.
ΥΥ^ _
ContentType
ΥΥ_ j
,
ΥΥj k
a
ΥΥl m
.
ΥΥm n
UploadedByUserId
ΥΥn ~
,
ΥΥ~ 
aΥΥ€ 
.ΥΥ ‚
	CreatedAtΥΥ‚ ‹
)ΥΥ‹ 
;ΥΥ 
}
ΦΦ 
public
ΨΨ 

async
ΨΨ 
Task
ΨΨ 
<
ΨΨ 
IEnumerable
ΨΨ !
<
ΨΨ! "!
TicketAttachmentDto
ΨΨ" 5
>
ΨΨ5 6
>
ΨΨ6 7!
GetAttachmentsAsync
ΨΨ8 K
(
ΨΨK L
int
ΨΨL O
ticketId
ΨΨP X
)
ΨΨX Y
{
ΩΩ 
var
ΪΪ 
list
ΪΪ 
=
ΪΪ 
await
ΪΪ 
_context
ΪΪ !
.
ΪΪ! "
TicketAttachments
ΪΪ" 3
.
ΪΪ3 4
Where
ΪΪ4 9
(
ΪΪ9 :
a
ΪΪ: ;
=>
ΪΪ< >
a
ΪΪ? @
.
ΪΪ@ A
TicketId
ΪΪA I
==
ΪΪJ L
ticketId
ΪΪM U
&&
ΪΪV X
!
ΪΪY Z
a
ΪΪZ [
.
ΪΪ[ \
	IsDeleted
ΪΪ\ e
)
ΪΪe f
.
ΪΪf g
ToListAsync
ΪΪg r
(
ΪΪr s
)
ΪΪs t
;
ΪΪt u
return
ΫΫ 
list
ΫΫ 
.
ΫΫ 
Select
ΫΫ 
(
ΫΫ 
a
ΫΫ 
=>
ΫΫ 
new
ΫΫ  #!
TicketAttachmentDto
ΫΫ$ 7
(
ΫΫ7 8
a
ΫΫ8 9
.
ΫΫ9 :
Id
ΫΫ: <
,
ΫΫ< =
a
ΫΫ> ?
.
ΫΫ? @
TicketId
ΫΫ@ H
,
ΫΫH I
a
ΫΫJ K
.
ΫΫK L
FileName
ΫΫL T
,
ΫΫT U
a
ΫΫV W
.
ΫΫW X
FilePath
ΫΫX `
,
ΫΫ` a
a
ΫΫb c
.
ΫΫc d
FileSize
ΫΫd l
,
ΫΫl m
a
ΫΫn o
.
ΫΫo p
ContentType
ΫΫp {
,
ΫΫ{ |
a
ΫΫ} ~
.
ΫΫ~ 
UploadedByUserIdΫΫ 
,ΫΫ 
aΫΫ‘ ’
.ΫΫ’ “
	CreatedAtΫΫ“ 
)ΫΫ 
)ΫΫ 
;ΫΫ 
}
άά 
public
ήή 

async
ήή 
Task
ήή 
AddWatcherAsync
ήή %
(
ήή% &
int
ήή& )
ticketId
ήή* 2
,
ήή2 3
int
ήή4 7
userId
ήή8 >
)
ήή> ?
{
ίί 
var
ΰΰ 
exists
ΰΰ 
=
ΰΰ 
await
ΰΰ 
_context
ΰΰ #
.
ΰΰ# $
TicketWatchers
ΰΰ$ 2
.
ΰΰ2 3
AnyAsync
ΰΰ3 ;
(
ΰΰ; <
w
ΰΰ< =
=>
ΰΰ> @
w
ΰΰA B
.
ΰΰB C
TicketId
ΰΰC K
==
ΰΰL N
ticketId
ΰΰO W
&&
ΰΰX Z
w
ΰΰ[ \
.
ΰΰ\ ]
UserId
ΰΰ] c
==
ΰΰd f
userId
ΰΰg m
&&
ΰΰn p
!
ΰΰq r
w
ΰΰr s
.
ΰΰs t
	IsDeleted
ΰΰt }
)
ΰΰ} ~
;
ΰΰ~ 
if
αα 

(
αα 
!
αα 
exists
αα 
)
αα 
{
ββ 	
_context
γγ 
.
γγ 
TicketWatchers
γγ #
.
γγ# $
Add
γγ$ '
(
γγ' (
new
γγ( +
TicketWatcher
γγ, 9
{
γγ: ;
TicketId
γγ< D
=
γγE F
ticketId
γγG O
,
γγO P
UserId
γγQ W
=
γγX Y
userId
γγZ `
}
γγa b
)
γγb c
;
γγc d
await
δδ 
_context
δδ 
.
δδ 
SaveChangesAsync
δδ +
(
δδ+ ,
)
δδ, -
;
δδ- .
}
εε 	
}
ζζ 
public
θθ 

async
θθ 
Task
θθ  
RemoveWatcherAsync
θθ (
(
θθ( )
int
θθ) ,
ticketId
θθ- 5
,
θθ5 6
int
θθ7 :
userId
θθ; A
)
θθA B
{
ιι 
var
κκ 
w
κκ 
=
κκ 
await
κκ 
_context
κκ 
.
κκ 
TicketWatchers
κκ -
.
κκ- .!
FirstOrDefaultAsync
κκ. A
(
κκA B
x
κκB C
=>
κκD F
x
κκG H
.
κκH I
TicketId
κκI Q
==
κκR T
ticketId
κκU ]
&&
κκ^ `
x
κκa b
.
κκb c
UserId
κκc i
==
κκj l
userId
κκm s
&&
κκt v
!
κκw x
x
κκx y
.
κκy z
	IsDeletedκκz ƒ
)κκƒ „
;κκ„ …
if
λλ 

(
λλ 
w
λλ 
!=
λλ 
null
λλ 
)
λλ 
{
μμ 	
_context
νν 
.
νν 
TicketWatchers
νν #
.
νν# $
Remove
νν$ *
(
νν* +
w
νν+ ,
)
νν, -
;
νν- .
await
ξξ 
_context
ξξ 
.
ξξ 
SaveChangesAsync
ξξ +
(
ξξ+ ,
)
ξξ, -
;
ξξ- .
}
οο 	
}
ππ 
public
ςς 

async
ςς 
Task
ςς 
<
ςς 
IEnumerable
ςς !
<
ςς! "
TicketWatcherDto
ςς" 2
>
ςς2 3
>
ςς3 4
GetWatchersAsync
ςς5 E
(
ςςE F
int
ςςF I
ticketId
ςςJ R
)
ςςR S
{
σσ 
var
ττ 
list
ττ 
=
ττ 
await
ττ 
_context
ττ !
.
ττ! "
TicketWatchers
ττ" 0
.
ττ0 1
Where
ττ1 6
(
ττ6 7
w
ττ7 8
=>
ττ9 ;
w
ττ< =
.
ττ= >
TicketId
ττ> F
==
ττG I
ticketId
ττJ R
&&
ττS U
!
ττV W
w
ττW X
.
ττX Y
	IsDeleted
ττY b
)
ττb c
.
ττc d
ToListAsync
ττd o
(
ττo p
)
ττp q
;
ττq r
return
υυ 
list
υυ 
.
υυ 
Select
υυ 
(
υυ 
w
υυ 
=>
υυ 
new
υυ  #
TicketWatcherDto
υυ$ 4
(
υυ4 5
w
υυ5 6
.
υυ6 7
TicketId
υυ7 ?
,
υυ? @
w
υυA B
.
υυB C
UserId
υυC I
)
υυI J
)
υυJ K
;
υυK L
}
φφ 
public
ψψ 

async
ψψ 
Task
ψψ 
<
ψψ 
IEnumerable
ψψ !
<
ψψ! "
TimelineEventDto
ψψ" 2
>
ψψ2 3
>
ψψ3 4
GetTimelineAsync
ψψ5 E
(
ψψE F
int
ψψF I
ticketId
ψψJ R
,
ψψR S
bool
ψψT X
includeInternal
ψψY h
)
ψψh i
{
ωω 
var
ϊϊ 
events
ϊϊ 
=
ϊϊ 
new
ϊϊ 
List
ϊϊ 
<
ϊϊ 
TimelineEventDto
ϊϊ .
>
ϊϊ. /
(
ϊϊ/ 0
)
ϊϊ0 1
;
ϊϊ1 2
var
όό 
	histories
όό 
=
όό 
await
όό 
_context
όό &
.
όό& '
TicketHistories
όό' 6
.
όό6 7
Where
όό7 <
(
όό< =
h
όό= >
=>
όό? A
h
όόB C
.
όόC D
TicketId
όόD L
==
όόM O
ticketId
όόP X
&&
όόY [
!
όό\ ]
h
όό] ^
.
όό^ _
	IsDeleted
όό_ h
)
όόh i
.
όόi j
ToListAsync
όόj u
(
όόu v
)
όόv w
;
όόw x
events
ύύ 
.
ύύ 
AddRange
ύύ 
(
ύύ 
	histories
ύύ !
.
ύύ! "
Select
ύύ" (
(
ύύ( )
h
ύύ) *
=>
ύύ+ -
new
ύύ. 1
TimelineEventDto
ύύ2 B
(
ύύB C
$str
ύύC L
,
ύύL M
h
ύύN O
.
ύύO P
	CreatedAt
ύύP Y
,
ύύY Z
h
ύύ[ \
)
ύύ\ ]
)
ύύ] ^
)
ύύ^ _
;
ύύ_ `
var
ÿÿ 
comments
ÿÿ 
=
ÿÿ 
await
ÿÿ 
_context
ÿÿ %
.
ÿÿ% &
TicketComments
ÿÿ& 4
.
ÿÿ4 5
Where
ÿÿ5 :
(
ÿÿ: ;
c
ÿÿ; <
=>
ÿÿ= ?
c
ÿÿ@ A
.
ÿÿA B
TicketId
ÿÿB J
==
ÿÿK M
ticketId
ÿÿN V
&&
ÿÿW Y
!
ÿÿZ [
c
ÿÿ[ \
.
ÿÿ\ ]
	IsDeleted
ÿÿ] f
)
ÿÿf g
.
ÿÿg h
ToListAsync
ÿÿh s
(
ÿÿs t
)
ÿÿt u
;
ÿÿu v
if
€€ 

(
€€ 
!
€€ 
includeInternal
€€ 
)
€€ 
comments
€€ &
=
€€' (
comments
€€) 1
.
€€1 2
Where
€€2 7
(
€€7 8
c
€€8 9
=>
€€: <
!
€€= >
c
€€> ?
.
€€? @

IsInternal
€€@ J
)
€€J K
.
€€K L
ToList
€€L R
(
€€R S
)
€€S T
;
€€T U
events
 
.
 
AddRange
 
(
 
comments
  
.
  !
Select
! '
(
' (
c
( )
=>
* ,
new
- 0
TimelineEventDto
1 A
(
A B
$str
B K
,
K L
c
M N
.
N O
	CreatedAt
O X
,
X Y
c
Z [
)
[ \
)
\ ]
)
] ^
;
^ _
var
ƒƒ 
attachments
ƒƒ 
=
ƒƒ 
await
ƒƒ 
_context
ƒƒ  (
.
ƒƒ( )
TicketAttachments
ƒƒ) :
.
ƒƒ: ;
Where
ƒƒ; @
(
ƒƒ@ A
a
ƒƒA B
=>
ƒƒC E
a
ƒƒF G
.
ƒƒG H
TicketId
ƒƒH P
==
ƒƒQ S
ticketId
ƒƒT \
&&
ƒƒ] _
!
ƒƒ` a
a
ƒƒa b
.
ƒƒb c
	IsDeleted
ƒƒc l
)
ƒƒl m
.
ƒƒm n
ToListAsync
ƒƒn y
(
ƒƒy z
)
ƒƒz {
;
ƒƒ{ |
events
„„ 
.
„„ 
AddRange
„„ 
(
„„ 
attachments
„„ #
.
„„# $
Select
„„$ *
(
„„* +
a
„„+ ,
=>
„„- /
new
„„0 3
TimelineEventDto
„„4 D
(
„„D E
$str
„„E Q
,
„„Q R
a
„„S T
.
„„T U
	CreatedAt
„„U ^
,
„„^ _
a
„„` a
)
„„a b
)
„„b c
)
„„c d
;
„„d e
return
†† 
events
†† 
.
†† 
OrderBy
†† 
(
†† 
e
†† 
=>
††  "
e
††# $
.
††$ %
	Timestamp
††% .
)
††. /
;
††/ 0
}
‡‡ 
public
‰‰ 

async
‰‰ 
Task
‰‰ 
<
‰‰ 
PagedResult
‰‰ !
<
‰‰! "
	TicketDto
‰‰" +
>
‰‰+ ,
>
‰‰, - 
SearchTicketsAsync
‰‰. @
(
‰‰@ A#
TicketSearchFilterDto
‰‰A V
filter
‰‰W ]
,
‰‰] ^
int
‰‰_ b
userId
‰‰c i
)
‰‰i j
{
 
var
‹‹ 
perms
‹‹ 
=
‹‹ 
await
‹‹ #
_permissionCalculator
‹‹ /
.
‹‹/ 00
"CalculateEffectivePermissionsAsync
‹‹0 R
(
‹‹R S
userId
‹‹S Y
)
‹‹Y Z
;
‹‹Z [
var
 
query
 
=
 
_context
 
.
 
Tickets
 $
.
 
Include
 
(
 
t
 
=>
 
t
 
.
 
	TicketSla
 %
)
% &
.
 
Where
 
(
 
t
 
=>
 
!
 
t
 
.
 
	IsDeleted
 $
)
$ %
;
% &
query
‘‘ 
=
‘‘ 
await
‘‘  
ApplySecurityScope
‘‘ (
(
‘‘( )
query
‘‘) .
,
‘‘. /
perms
‘‘0 5
,
‘‘5 6
userId
‘‘7 =
)
‘‘= >
;
‘‘> ?
query
’’ 
=
’’ 
ApplyBasicFilters
’’ !
(
’’! "
query
’’" '
,
’’' (
filter
’’) /
)
’’/ 0
;
’’0 1
query
““ 
=
““ '
ApplyKeywordAndSlaFilters
““ )
(
““) *
query
““* /
,
““/ 0
filter
““1 7
)
““7 8
;
““8 9
query
•• 
=
•• 
filter
•• 
.
•• 
SortDescending
•• %
?
–– 
query
–– 
.
–– 
OrderByDescending
–– %
(
––% &
e
––& '
=>
––( *
EF
––+ -
.
––- .
Property
––. 6
<
––6 7
object
––7 =
>
––= >
(
––> ?
e
––? @
,
––@ A
filter
––B H
.
––H I
SortBy
––I O
??
––P R
$str
––S ^
)
––^ _
)
––_ `
:
—— 
query
—— 
.
—— 
OrderBy
—— 
(
—— 
e
—— 
=>
——  
EF
——! #
.
——# $
Property
——$ ,
<
——, -
object
——- 3
>
——3 4
(
——4 5
e
——5 6
,
——6 7
filter
——8 >
.
——> ?
SortBy
——? E
??
——F H
$str
——I T
)
——T U
)
——U V
;
——V W
var
™™ 

totalCount
™™ 
=
™™ 
await
™™ 
query
™™ $
.
™™$ %

CountAsync
™™% /
(
™™/ 0
)
™™0 1
;
™™1 2
var
›› 
tickets
›› 
=
›› 
await
›› 
query
›› !
.
 
Skip
 
(
 
(
 
filter
 
.
 
Page
 
-
  
$num
! "
)
" #
*
$ %
filter
& ,
.
, -
PageSize
- 5
)
5 6
.
 
Take
 
(
 
filter
 
.
 
PageSize
 !
)
! "
.
 
Select
 
(
 
t
 
=>
 
new
 
	TicketDto
 &
(
& '
t
' (
.
( )
Id
) +
,
+ ,
t
- .
.
. /
TicketNumber
/ ;
,
; <
t
= >
.
> ?
Title
? D
,
D E
t
F G
.
G H
Description
H S
,
S T
t
U V
.
V W
	ProjectId
W `
,
` a
t
b c
.
c d

CategoryId
d n
,
n o
t
p q
.
q r
TypeId
r x
,
x y
t
z {
.
{ |
StatusId| „
,„ …
t† ‡
.‡ 

PriorityId ’
,’ “
t” •
.• –
RequesterUserId– ¥
,¥ ¦
t§ ¨
.¨ ©
AssignedUserId© ·
,· Έ
tΉ Ί
.Ί »
AssignedGroupId» Κ
,Κ Λ
nullΜ Π
)Π Ρ
)Ρ Ò
.
 
ToListAsync
 
(
 
)
 
;
 
return
΅΅ 
new
΅΅ 
PagedResult
΅΅ 
<
΅΅ 
	TicketDto
΅΅ (
>
΅΅( )
{
ΆΆ 	
Items
££ 
=
££ 
tickets
££ 
,
££ 

TotalCount
¤¤ 
=
¤¤ 

totalCount
¤¤ #
,
¤¤# $
Page
¥¥ 
=
¥¥ 
filter
¥¥ 
.
¥¥ 
Page
¥¥ 
,
¥¥ 
PageSize
¦¦ 
=
¦¦ 
filter
¦¦ 
.
¦¦ 
PageSize
¦¦ &
}
§§ 	
;
§§	 

}
¨¨ 
private
ªª 
async
ªª 
Task
ªª 
<
ªª 

IQueryable
ªª !
<
ªª! "
Ticket
ªª" (
>
ªª( )
>
ªª) * 
ApplySecurityScope
ªª+ =
(
ªª= >

IQueryable
ªª> H
<
ªªH I
Ticket
ªªI O
>
ªªO P
query
ªªQ V
,
ªªV W
HashSet
ªªX _
<
ªª_ `
string
ªª` f
>
ªªf g
perms
ªªh m
,
ªªm n
int
ªªo r
userId
ªªs y
)
ªªy z
{
«« 
if
¬¬ 

(
¬¬ 
!
¬¬ 
perms
¬¬ 
.
¬¬ 
Contains
¬¬ 
(
¬¬ 
$str
¬¬ )
)
¬¬) *
)
¬¬* +
{
­­ 	
var
®® 
isAgent
®® 
=
®® 
perms
®® 
.
®®  
Contains
®®  (
(
®®( )
$str
®®) 6
)
®®6 7
||
®®8 :
perms
®®; @
.
®®@ A
Contains
®®A I
(
®®I J
$str
®®J Z
)
®®Z [
||
®®\ ^
perms
®®_ d
.
®®d e
Contains
®®e m
(
®®m n
$str
®®n }
)
®®} ~
;
®®~ 
if
―― 
(
―― 
isAgent
―― 
)
―― 
{
°° 
var
±± 
userGroupIds
±±  
=
±±! "
await
±±# (
_context
±±) 1
.
±±1 2
GroupMembers
±±2 >
.
²² 
Where
²² 
(
²² 
gm
²² 
=>
²²  
gm
²²! #
.
²²# $
UserId
²²$ *
==
²²+ -
userId
²². 4
&&
²²5 7
!
²²8 9
gm
²²9 ;
.
²²; <
	IsDeleted
²²< E
)
²²E F
.
³³ 
Select
³³ 
(
³³ 
gm
³³ 
=>
³³ !
gm
³³" $
.
³³$ %
GroupId
³³% ,
)
³³, -
.
΄΄ 
ToListAsync
΄΄  
(
΄΄  !
)
΄΄! "
;
΄΄" #
return
¶¶ 
query
¶¶ 
.
¶¶ 
Where
¶¶ "
(
¶¶" #
t
¶¶# $
=>
¶¶% '
t
¶¶( )
.
¶¶) *
AssignedUserId
¶¶* 8
==
¶¶9 ;
userId
¶¶< B
||
¶¶C E
(
··( )
t
··) *
.
··* +
AssignedGroupId
··+ :
.
··: ;
HasValue
··; C
&&
··D F
userGroupIds
··G S
.
··S T
Contains
··T \
(
··\ ]
t
··] ^
.
··^ _
AssignedGroupId
··_ n
.
··n o
Value
··o t
)
··t u
)
··u v
||
··w y
t
ΈΈ( )
.
ΈΈ) *
RequesterUserId
ΈΈ* 9
==
ΈΈ: <
userId
ΈΈ= C
)
ΈΈC D
;
ΈΈD E
}
ΉΉ 
return
ΊΊ 
query
ΊΊ 
.
ΊΊ 
Where
ΊΊ 
(
ΊΊ 
t
ΊΊ  
=>
ΊΊ! #
t
ΊΊ$ %
.
ΊΊ% &
RequesterUserId
ΊΊ& 5
==
ΊΊ6 8
userId
ΊΊ9 ?
)
ΊΊ? @
;
ΊΊ@ A
}
»» 	
return
ΌΌ 
query
ΌΌ 
;
ΌΌ 
}
½½ 
private
ΏΏ 
static
ΏΏ 

IQueryable
ΏΏ 
<
ΏΏ 
Ticket
ΏΏ $
>
ΏΏ$ %
ApplyBasicFilters
ΏΏ& 7
(
ΏΏ7 8

IQueryable
ΏΏ8 B
<
ΏΏB C
Ticket
ΏΏC I
>
ΏΏI J
query
ΏΏK P
,
ΏΏP Q#
TicketSearchFilterDto
ΏΏR g
filter
ΏΏh n
)
ΏΏn o
{
ΐΐ 
if
ΑΑ 

(
ΑΑ 
filter
ΑΑ 
.
ΑΑ 
	ProjectId
ΑΑ 
.
ΑΑ 
HasValue
ΑΑ %
)
ΑΑ% &
query
ΑΑ' ,
=
ΑΑ- .
query
ΑΑ/ 4
.
ΑΑ4 5
Where
ΑΑ5 :
(
ΑΑ: ;
t
ΑΑ; <
=>
ΑΑ= ?
t
ΑΑ@ A
.
ΑΑA B
	ProjectId
ΑΑB K
==
ΑΑL N
filter
ΑΑO U
.
ΑΑU V
	ProjectId
ΑΑV _
.
ΑΑ_ `
Value
ΑΑ` e
)
ΑΑe f
;
ΑΑf g
if
ΒΒ 

(
ΒΒ 
filter
ΒΒ 
.
ΒΒ 

CategoryId
ΒΒ 
.
ΒΒ 
HasValue
ΒΒ &
)
ΒΒ& '
query
ΒΒ( -
=
ΒΒ. /
query
ΒΒ0 5
.
ΒΒ5 6
Where
ΒΒ6 ;
(
ΒΒ; <
t
ΒΒ< =
=>
ΒΒ> @
t
ΒΒA B
.
ΒΒB C

CategoryId
ΒΒC M
==
ΒΒN P
filter
ΒΒQ W
.
ΒΒW X

CategoryId
ΒΒX b
.
ΒΒb c
Value
ΒΒc h
)
ΒΒh i
;
ΒΒi j
if
ΓΓ 

(
ΓΓ 
filter
ΓΓ 
.
ΓΓ 
TypeId
ΓΓ 
.
ΓΓ 
HasValue
ΓΓ "
)
ΓΓ" #
query
ΓΓ$ )
=
ΓΓ* +
query
ΓΓ, 1
.
ΓΓ1 2
Where
ΓΓ2 7
(
ΓΓ7 8
t
ΓΓ8 9
=>
ΓΓ: <
t
ΓΓ= >
.
ΓΓ> ?
TypeId
ΓΓ? E
==
ΓΓF H
filter
ΓΓI O
.
ΓΓO P
TypeId
ΓΓP V
.
ΓΓV W
Value
ΓΓW \
)
ΓΓ\ ]
;
ΓΓ] ^
if
ΔΔ 

(
ΔΔ 
filter
ΔΔ 
.
ΔΔ 
StatusId
ΔΔ 
.
ΔΔ 
HasValue
ΔΔ $
)
ΔΔ$ %
query
ΔΔ& +
=
ΔΔ, -
query
ΔΔ. 3
.
ΔΔ3 4
Where
ΔΔ4 9
(
ΔΔ9 :
t
ΔΔ: ;
=>
ΔΔ< >
t
ΔΔ? @
.
ΔΔ@ A
StatusId
ΔΔA I
==
ΔΔJ L
filter
ΔΔM S
.
ΔΔS T
StatusId
ΔΔT \
.
ΔΔ\ ]
Value
ΔΔ] b
)
ΔΔb c
;
ΔΔc d
if
ΕΕ 

(
ΕΕ 
filter
ΕΕ 
.
ΕΕ 
ExcludeStatusId
ΕΕ "
.
ΕΕ" #
HasValue
ΕΕ# +
)
ΕΕ+ ,
query
ΕΕ- 2
=
ΕΕ3 4
query
ΕΕ5 :
.
ΕΕ: ;
Where
ΕΕ; @
(
ΕΕ@ A
t
ΕΕA B
=>
ΕΕC E
t
ΕΕF G
.
ΕΕG H
StatusId
ΕΕH P
!=
ΕΕQ S
filter
ΕΕT Z
.
ΕΕZ [
ExcludeStatusId
ΕΕ[ j
.
ΕΕj k
Value
ΕΕk p
)
ΕΕp q
;
ΕΕq r
if
ΖΖ 

(
ΖΖ 
filter
ΖΖ 
.
ΖΖ 

PriorityId
ΖΖ 
.
ΖΖ 
HasValue
ΖΖ &
)
ΖΖ& '
query
ΖΖ( -
=
ΖΖ. /
query
ΖΖ0 5
.
ΖΖ5 6
Where
ΖΖ6 ;
(
ΖΖ; <
t
ΖΖ< =
=>
ΖΖ> @
t
ΖΖA B
.
ΖΖB C

PriorityId
ΖΖC M
==
ΖΖN P
filter
ΖΖQ W
.
ΖΖW X

PriorityId
ΖΖX b
.
ΖΖb c
Value
ΖΖc h
)
ΖΖh i
;
ΖΖi j
if
ΗΗ 

(
ΗΗ 
filter
ΗΗ 
.
ΗΗ 
AssigneeUserId
ΗΗ !
.
ΗΗ! "
HasValue
ΗΗ" *
)
ΗΗ* +
query
ΗΗ, 1
=
ΗΗ2 3
query
ΗΗ4 9
.
ΗΗ9 :
Where
ΗΗ: ?
(
ΗΗ? @
t
ΗΗ@ A
=>
ΗΗB D
t
ΗΗE F
.
ΗΗF G
AssignedUserId
ΗΗG U
==
ΗΗV X
filter
ΗΗY _
.
ΗΗ_ `
AssigneeUserId
ΗΗ` n
.
ΗΗn o
Value
ΗΗo t
)
ΗΗt u
;
ΗΗu v
if
ΘΘ 

(
ΘΘ 
filter
ΘΘ 
.
ΘΘ 

Unassigned
ΘΘ 
==
ΘΘ  
true
ΘΘ! %
)
ΘΘ% &
query
ΘΘ' ,
=
ΘΘ- .
query
ΘΘ/ 4
.
ΘΘ4 5
Where
ΘΘ5 :
(
ΘΘ: ;
t
ΘΘ; <
=>
ΘΘ= ?
t
ΘΘ@ A
.
ΘΘA B
AssignedUserId
ΘΘB P
==
ΘΘQ S
null
ΘΘT X
)
ΘΘX Y
;
ΘΘY Z
if
ΙΙ 

(
ΙΙ 
filter
ΙΙ 
.
ΙΙ 
RequesterUserId
ΙΙ "
.
ΙΙ" #
HasValue
ΙΙ# +
)
ΙΙ+ ,
query
ΙΙ- 2
=
ΙΙ3 4
query
ΙΙ5 :
.
ΙΙ: ;
Where
ΙΙ; @
(
ΙΙ@ A
t
ΙΙA B
=>
ΙΙC E
t
ΙΙF G
.
ΙΙG H
RequesterUserId
ΙΙH W
==
ΙΙX Z
filter
ΙΙ[ a
.
ΙΙa b
RequesterUserId
ΙΙb q
.
ΙΙq r
Value
ΙΙr w
)
ΙΙw x
;
ΙΙx y
if
ΚΚ 

(
ΚΚ 
filter
ΚΚ 
.
ΚΚ 
FromDate
ΚΚ 
.
ΚΚ 
HasValue
ΚΚ $
)
ΚΚ$ %
query
ΚΚ& +
=
ΚΚ, -
query
ΚΚ. 3
.
ΚΚ3 4
Where
ΚΚ4 9
(
ΚΚ9 :
t
ΚΚ: ;
=>
ΚΚ< >
t
ΚΚ? @
.
ΚΚ@ A
	CreatedAt
ΚΚA J
>=
ΚΚK M
filter
ΚΚN T
.
ΚΚT U
FromDate
ΚΚU ]
.
ΚΚ] ^
Value
ΚΚ^ c
)
ΚΚc d
;
ΚΚd e
if
ΛΛ 

(
ΛΛ 
filter
ΛΛ 
.
ΛΛ 
ToDate
ΛΛ 
.
ΛΛ 
HasValue
ΛΛ "
)
ΛΛ" #
query
ΛΛ$ )
=
ΛΛ* +
query
ΛΛ, 1
.
ΛΛ1 2
Where
ΛΛ2 7
(
ΛΛ7 8
t
ΛΛ8 9
=>
ΛΛ: <
t
ΛΛ= >
.
ΛΛ> ?
	CreatedAt
ΛΛ? H
<=
ΛΛI K
filter
ΛΛL R
.
ΛΛR S
ToDate
ΛΛS Y
.
ΛΛY Z
Value
ΛΛZ _
)
ΛΛ_ `
;
ΛΛ` a
return
ΜΜ 
query
ΜΜ 
;
ΜΜ 
}
ΝΝ 
private
ΟΟ 
static
ΟΟ 

IQueryable
ΟΟ 
<
ΟΟ 
Ticket
ΟΟ $
>
ΟΟ$ %'
ApplyKeywordAndSlaFilters
ΟΟ& ?
(
ΟΟ? @

IQueryable
ΟΟ@ J
<
ΟΟJ K
Ticket
ΟΟK Q
>
ΟΟQ R
query
ΟΟS X
,
ΟΟX Y#
TicketSearchFilterDto
ΟΟZ o
filter
ΟΟp v
)
ΟΟv w
{
ΠΠ 
if
ΡΡ 

(
ΡΡ 
!
ΡΡ 
string
ΡΡ 
.
ΡΡ  
IsNullOrWhiteSpace
ΡΡ &
(
ΡΡ& '
filter
ΡΡ' -
.
ΡΡ- .
Keyword
ΡΡ. 5
)
ΡΡ5 6
)
ΡΡ6 7
{
ÒÒ 	
var
ΣΣ 
kw
ΣΣ 
=
ΣΣ 
filter
ΣΣ 
.
ΣΣ 
Keyword
ΣΣ #
;
ΣΣ# $
query
ΤΤ 
=
ΤΤ 
query
ΤΤ 
.
ΤΤ 
Where
ΤΤ 
(
ΤΤ  
t
ΤΤ  !
=>
ΤΤ" $
t
ΥΥ 
.
ΥΥ 
TicketNumber
ΥΥ 
.
ΥΥ 
Contains
ΥΥ '
(
ΥΥ' (
kw
ΥΥ( *
,
ΥΥ* +
StringComparison
ΥΥ, <
.
ΥΥ< =
OrdinalIgnoreCase
ΥΥ= N
)
ΥΥN O
||
ΥΥP R
t
ΦΦ 
.
ΦΦ 
Title
ΦΦ 
.
ΦΦ 
Contains
ΦΦ  
(
ΦΦ  !
kw
ΦΦ! #
,
ΦΦ# $
StringComparison
ΦΦ% 5
.
ΦΦ5 6
OrdinalIgnoreCase
ΦΦ6 G
)
ΦΦG H
||
ΦΦI K
t
ΧΧ 
.
ΧΧ 
Description
ΧΧ 
.
ΧΧ 
Contains
ΧΧ &
(
ΧΧ& '
kw
ΧΧ' )
,
ΧΧ) *
StringComparison
ΧΧ+ ;
.
ΧΧ; <
OrdinalIgnoreCase
ΧΧ< M
)
ΧΧM N
)
ΧΧN O
;
ΧΧO P
}
ΨΨ 	
if
ΪΪ 

(
ΪΪ 
!
ΪΪ 
string
ΪΪ 
.
ΪΪ  
IsNullOrWhiteSpace
ΪΪ &
(
ΪΪ& '
filter
ΪΪ' -
.
ΪΪ- .
	SlaStatus
ΪΪ. 7
)
ΪΪ7 8
)
ΪΪ8 9
{
ΫΫ 	
var
άά 
s
άά 
=
άά 
filter
άά 
.
άά 
	SlaStatus
άά $
.
άά$ %
ToLower
άά% ,
(
άά, -
)
άά- .
;
άά. /
if
έέ 
(
έέ 
s
έέ 
==
έέ 
$str
έέ 
)
έέ  
query
ήή 
=
ήή 
query
ήή 
.
ήή 
Where
ήή #
(
ήή# $
t
ήή$ %
=>
ήή& (
t
ήή) *
.
ήή* +
	TicketSla
ήή+ 4
!=
ήή5 7
null
ήή8 <
&&
ήή= ?
(
ήή@ A
t
ήήA B
.
ήήB C
	TicketSla
ήήC L
.
ήήL M#
FirstResponseBreached
ήήM b
||
ήήc e
t
ήήf g
.
ήήg h
	TicketSla
ήήh q
.
ήήq r!
ResolutionBreachedήήr „
)ήή„ …
)ήή… †
;ήή† ‡
else
ίί 
if
ίί 
(
ίί 
s
ίί 
==
ίί 
$str
ίί #
)
ίί# $
query
ΰΰ 
=
ΰΰ 
query
ΰΰ 
.
ΰΰ 
Where
ΰΰ #
(
ΰΰ# $
t
ΰΰ$ %
=>
ΰΰ& (
t
ΰΰ) *
.
ΰΰ* +
	TicketSla
ΰΰ+ 4
!=
ΰΰ5 7
null
ΰΰ8 <
&&
ΰΰ= ?
(
ΰΰ@ A
t
ΰΰA B
.
ΰΰB C
	TicketSla
ΰΰC L
.
ΰΰL M!
FirstResponseWarned
ΰΰM `
||
ΰΰa c
t
ΰΰd e
.
ΰΰe f
	TicketSla
ΰΰf o
.
ΰΰo p
ResolutionWarnedΰΰp €
)ΰΰ€ 
&&ΰΰ‚ „
!ΰΰ… †
(ΰΰ† ‡
tΰΰ‡ 
.ΰΰ ‰
	TicketSlaΰΰ‰ ’
.ΰΰ’ “%
FirstResponseBreachedΰΰ“ ¨
||ΰΰ© «
tΰΰ¬ ­
.ΰΰ­ ®
	TicketSlaΰΰ® ·
.ΰΰ· Έ"
ResolutionBreachedΰΰΈ Κ
)ΰΰΚ Λ
)ΰΰΛ Μ
;ΰΰΜ Ν
else
αα 
if
αα 
(
αα 
s
αα 
==
αα 
$str
αα #
)
αα# $
query
ββ 
=
ββ 
query
ββ 
.
ββ 
Where
ββ #
(
ββ# $
t
ββ$ %
=>
ββ& (
t
ββ) *
.
ββ* +
	TicketSla
ββ+ 4
!=
ββ5 7
null
ββ8 <
&&
ββ= ?
!
ββ@ A
t
ββA B
.
ββB C
	TicketSla
ββC L
.
ββL M!
FirstResponseWarned
ββM `
&&
ββa c
!
ββd e
t
ββe f
.
ββf g
	TicketSla
ββg p
.
ββp q
ResolutionWarnedββq 
&&ββ‚ „
!ββ… †
tββ† ‡
.ββ‡ 
	TicketSlaββ ‘
.ββ‘ ’%
FirstResponseBreachedββ’ §
&&ββ¨ ª
!ββ« ¬
tββ¬ ­
.ββ­ ®
	TicketSlaββ® ·
.ββ· Έ"
ResolutionBreachedββΈ Κ
)ββΚ Λ
;ββΛ Μ
}
γγ 	
return
δδ 
query
δδ 
;
δδ 
}
εε 
public
ηη 

async
ηη 
Task
ηη 
<
ηη 
TicketSurveyDto
ηη %
>
ηη% &
SubmitSurveyAsync
ηη' 8
(
ηη8 9
int
ηη9 <
ticketId
ηη= E
,
ηηE F#
SubmitTicketSurveyDto
ηηG \
dto
ηη] `
,
ηη` a
int
ηηb e
userId
ηηf l
)
ηηl m
{
θθ 
var
ιι 
ticket
ιι 
=
ιι 
await
ιι 
_context
ιι #
.
ιι# $
Tickets
ιι$ +
.
ιι+ ,!
FirstOrDefaultAsync
ιι, ?
(
ιι? @
t
ιι@ A
=>
ιιB D
t
ιιE F
.
ιιF G
Id
ιιG I
==
ιιJ L
ticketId
ιιM U
&&
ιιV X
!
ιιY Z
t
ιιZ [
.
ιι[ \
	IsDeleted
ιι\ e
)
ιιe f
;
ιιf g
if
κκ 

(
κκ 
ticket
κκ 
==
κκ 
null
κκ 
)
κκ 
throw
κκ !
new
κκ" %"
KeyNotFoundException
κκ& :
(
κκ: ;
$str
κκ; M
)
κκM N
;
κκN O
if
μμ 

(
μμ 
ticket
μμ 
.
μμ 
RequesterUserId
μμ "
!=
μμ# %
userId
μμ& ,
)
μμ, -
throw
νν 
new
νν )
UnauthorizedAccessException
νν 1
(
νν1 2
$str
νν2 j
)
ννj k
;
ννk l
if
ππ 

(
ππ 
ticket
ππ 
.
ππ 
StatusId
ππ 
!=
ππ 
$num
ππ  
)
ππ  !
throw
ρρ 
new
ρρ '
InvalidOperationException
ρρ /
(
ρρ/ 0
$str
ρρ0 b
)
ρρb c
;
ρρc d
var
σσ 
existingSurvey
σσ 
=
σσ 
await
σσ "
_context
σσ# +
.
σσ+ ,
TicketSurveys
σσ, 9
.
σσ9 :
AnyAsync
σσ: B
(
σσB C
s
σσC D
=>
σσE G
s
σσH I
.
σσI J
TicketId
σσJ R
==
σσS U
ticketId
σσV ^
)
σσ^ _
;
σσ_ `
if
ττ 

(
ττ 
existingSurvey
ττ 
)
ττ 
throw
υυ 
new
υυ '
InvalidOperationException
υυ /
(
υυ/ 0
$str
υυ0 e
)
υυe f
;
υυf g
if
χχ 

(
χχ 
dto
χχ 
.
χχ 
Rating
χχ 
<
χχ 
$num
χχ 
||
χχ 
dto
χχ !
.
χχ! "
Rating
χχ" (
>
χχ) *
$num
χχ+ ,
)
χχ, -
throw
ψψ 
new
ψψ '
InvalidOperationException
ψψ /
(
ψψ/ 0
$str
ψψ0 P
)
ψψP Q
;
ψψQ R
var
ϊϊ 
survey
ϊϊ 
=
ϊϊ 
new
ϊϊ 
TicketSurvey
ϊϊ %
{
ϋϋ 	
TicketId
όό 
=
όό 
ticketId
όό 
,
όό  
Rating
ύύ 
=
ύύ 
dto
ύύ 
.
ύύ 
Rating
ύύ 
,
ύύ  
Comment
ώώ 
=
ώώ 
dto
ώώ 
.
ώώ 
Comment
ώώ !
}
ÿÿ 	
;
ÿÿ	 

_context
 
.
 
TicketSurveys
 
.
 
Add
 "
(
" #
survey
# )
)
) *
;
* +
await
‚‚ 
_context
‚‚ 
.
‚‚ 
SaveChangesAsync
‚‚ '
(
‚‚' (
)
‚‚( )
;
‚‚) *
return
„„ 
new
„„ 
TicketSurveyDto
„„ "
(
„„" #
survey
„„# )
.
„„) *
Id
„„* ,
,
„„, -
survey
„„. 4
.
„„4 5
TicketId
„„5 =
,
„„= >
survey
„„? E
.
„„E F
Rating
„„F L
,
„„L M
survey
„„N T
.
„„T U
Comment
„„U \
,
„„\ ]
survey
„„^ d
.
„„d e
SubmittedAt
„„e p
)
„„p q
;
„„q r
}
…… 
}†† Ζ
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
oldValue	y 
=
‚ ƒ
null
„ 
,
 ‰
string
 
?
 ‘
newValue
’ 
=
› 
null
 ΅
)
΅ Ά
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
})) Ή	
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
} ο)
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
}@@ ‰d
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
ResolutionMinutes	KK~ 
,
KK 
t
KK‘ ’
.
KK’ “
IsActive
KK“ ›
)
KK› 
)
KK 
;
KK 
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
FirstResponseMinutes	ZZn ‚
,
ZZ‚ ƒ
target
ZZ„ 
.
ZZ ‹
ResolutionMinutes
ZZ‹ 
,
ZZ 
target
ZZ ¤
.
ZZ¤ ¥
IsActive
ZZ¥ ­
)
ZZ­ ®
;
ZZ® ―
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
}tt 
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
TimeSpan	AA ‡
	startTime
AA ‘
,
AA‘ ’
TimeSpan
AA“ ›
endTime
AA £
)
AA£ ¤
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
€€ 
	oldStatus
€€ 
=
€€ 
await
€€ 
_context
€€ &
.
€€& '
Statuses
€€' /
.
€€/ 0
	FindAsync
€€0 9
(
€€9 :
oldStatusId
€€: E
)
€€E F
;
€€F G
var
 
	newStatus
 
=
 
await
 
_context
 &
.
& '
Statuses
' /
.
/ 0
	FindAsync
0 9
(
9 :
newStatusId
: E
)
E F
;
F G
if
‚‚ 

(
‚‚ 
	oldStatus
‚‚ 
==
‚‚ 
null
‚‚ 
||
‚‚  
	newStatus
‚‚! *
==
‚‚+ -
null
‚‚. 2
)
‚‚2 3
return
‚‚4 :
;
‚‚: ;
var
„„ 
now
„„ 
=
„„ 
DateTime
„„ 
.
„„ 
UtcNow
„„ !
;
„„! "
if
†† 

(
†† 
!
†† 
	oldStatus
†† 
.
†† 
	PausesSla
††  
&&
††! #
	newStatus
††$ -
.
††- .
	PausesSla
††. 7
)
††7 8
{
‡‡ 	

ApplyPause
 
(
 
sla
 
,
 
now
 
)
  
;
  !
}
‰‰ 	
else
 
if
 
(
 
	oldStatus
 
.
 
	PausesSla
 $
&&
% '
!
( )
	newStatus
) 2
.
2 3
	PausesSla
3 <
&&
= ?
sla
@ C
.
C D
PausedAt
D L
.
L M
HasValue
M U
)
U V
{
‹‹ 	
await
 
ApplyResumeAsync
 "
(
" #
sla
# &
,
& '
now
( +
)
+ ,
;
, -
}
 	
if
 

(
 
	newStatus
 
.
 
IsClosedStatus
 $
&&
% '
sla
( +
.
+ ,
ResolutionMetAt
, ;
==
< >
null
? C
)
C D
sla
 
.
 
ResolutionMetAt
 
=
  !
now
" %
;
% &
await
’’ 
_context
’’ 
.
’’ 
SaveChangesAsync
’’ '
(
’’' (
)
’’( )
;
’’) *
}
““ 
private
•• 
static
•• 
void
•• 

ApplyPause
•• "
(
••" #
	TicketSla
••# ,
sla
••- 0
,
••0 1
DateTime
••2 :
now
••; >
)
••> ?
{
–– 
sla
—— 
.
—— 
PausedAt
—— 
=
—— 
now
—— 
;
—— 
}
 
private
 
async
 
Task
 
ApplyResumeAsync
 '
(
' (
	TicketSla
( 1
sla
2 5
,
5 6
DateTime
7 ?
now
@ C
)
C D
{
›› 
if
 

(
 
!
 
sla
 
.
 
PausedAt
 
.
 
HasValue
 "
)
" #
return
$ *
;
* +
var
 
pausedDuration
 
=
 
now
  
-
! "
sla
# &
.
& '
PausedAt
' /
.
/ 0
Value
0 5
;
5 6
sla
 
.
  
TotalPausedMinutes
 
+=
 !
(
" #
int
# &
)
& '
pausedDuration
' 5
.
5 6
TotalMinutes
6 B
;
B C
if
΅΅ 

(
΅΅ 
sla
΅΅ 
.
΅΅  
FirstResponseDueAt
΅΅ "
.
΅΅" #
HasValue
΅΅# +
)
΅΅+ ,
sla
ΆΆ 
.
ΆΆ  
FirstResponseDueAt
ΆΆ "
=
ΆΆ# $
await
ΆΆ% *#
CalculateDueTimeAsync
ΆΆ+ @
(
ΆΆ@ A
now
ΆΆA D
,
ΆΆD E
(
ΆΆF G
int
ΆΆG J
)
ΆΆJ K
(
ΆΆK L
sla
ΆΆL O
.
ΆΆO P 
FirstResponseDueAt
ΆΆP b
.
ΆΆb c
Value
ΆΆc h
-
ΆΆi j
sla
ΆΆk n
.
ΆΆn o
PausedAt
ΆΆo w
.
ΆΆw x
Value
ΆΆx }
)
ΆΆ} ~
.
ΆΆ~ 
TotalMinutesΆΆ ‹
)ΆΆ‹ 
;ΆΆ 
if
¤¤ 

(
¤¤ 
sla
¤¤ 
.
¤¤ 
ResolutionDueAt
¤¤ 
.
¤¤  
HasValue
¤¤  (
)
¤¤( )
sla
¥¥ 
.
¥¥ 
ResolutionDueAt
¥¥ 
=
¥¥  !
await
¥¥" '#
CalculateDueTimeAsync
¥¥( =
(
¥¥= >
now
¥¥> A
,
¥¥A B
(
¥¥C D
int
¥¥D G
)
¥¥G H
(
¥¥H I
sla
¥¥I L
.
¥¥L M
ResolutionDueAt
¥¥M \
.
¥¥\ ]
Value
¥¥] b
-
¥¥c d
sla
¥¥e h
.
¥¥h i
PausedAt
¥¥i q
.
¥¥q r
Value
¥¥r w
)
¥¥w x
.
¥¥x y
TotalMinutes¥¥y …
)¥¥… †
;¥¥† ‡
sla
§§ 
.
§§ 
PausedAt
§§ 
=
§§ 
null
§§ 
;
§§ 
}
¨¨ 
public
ªª 

async
ªª 
Task
ªª '
ProcessTicketCommentAsync
ªª /
(
ªª/ 0
int
ªª0 3
ticketId
ªª4 <
,
ªª< =
bool
ªª> B

isInternal
ªªC M
)
ªªM N
{
«« 
if
¬¬ 

(
¬¬ 

isInternal
¬¬ 
)
¬¬ 
return
¬¬ 
;
¬¬ 
var
®® 
sla
®® 
=
®® 
await
®® 
_context
®®  
.
®®  !

TicketSlas
®®! +
.
®®+ ,!
FirstOrDefaultAsync
®®, ?
(
®®? @
s
®®@ A
=>
®®B D
s
®®E F
.
®®F G
TicketId
®®G O
==
®®P R
ticketId
®®S [
)
®®[ \
;
®®\ ]
if
―― 

(
―― 
sla
―― 
!=
―― 
null
―― 
&&
―― 
sla
―― 
.
――  
FirstResponseMetAt
―― 1
==
――2 4
null
――5 9
)
――9 :
{
°° 	
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
²² 
_context
²² 
.
²² 
SaveChangesAsync
²² +
(
²²+ ,
)
²², -
;
²²- .
}
³³ 	
}
΄΄ 
public
¶¶ 

async
¶¶ 
Task
¶¶  
CheckBreachesAsync
¶¶ (
(
¶¶( )
DateTime
¶¶) 1
nowUtc
¶¶2 8
)
¶¶8 9
{
·· 
var
ΈΈ 

activeSlas
ΈΈ 
=
ΈΈ 
await
ΈΈ 
_context
ΈΈ '
.
ΈΈ' (

TicketSlas
ΈΈ( 2
.
ΉΉ 
Include
ΉΉ 
(
ΉΉ 
s
ΉΉ 
=>
ΉΉ 
s
ΉΉ 
.
ΉΉ 
Ticket
ΉΉ "
)
ΉΉ" #
.
ΊΊ 
Where
ΊΊ 
(
ΊΊ 
s
ΊΊ 
=>
ΊΊ 
s
ΊΊ 
.
ΊΊ 
PausedAt
ΊΊ "
==
ΊΊ# %
null
ΊΊ& *
&&
ΊΊ+ -
(
ΊΊ. /
!
ΊΊ/ 0
s
ΊΊ0 1
.
ΊΊ1 2
ResolutionMetAt
ΊΊ2 A
.
ΊΊA B
HasValue
ΊΊB J
||
ΊΊK M
!
ΊΊN O
s
ΊΊO P
.
ΊΊP Q 
FirstResponseMetAt
ΊΊQ c
.
ΊΊc d
HasValue
ΊΊd l
)
ΊΊl m
)
ΊΊm n
.
»» 
ToListAsync
»» 
(
»» 
)
»» 
;
»» 
foreach
½½ 
(
½½ 
var
½½ 
sla
½½ 
in
½½ 

activeSlas
½½ &
)
½½& '
{
ΎΎ 	
if
ΏΏ 
(
ΏΏ 
sla
ΏΏ 
.
ΏΏ 
Ticket
ΏΏ 
==
ΏΏ 
null
ΏΏ "
)
ΏΏ" #
continue
ΏΏ$ ,
;
ΏΏ, -
var
ΐΐ 
targetUserId
ΐΐ 
=
ΐΐ 
sla
ΐΐ "
.
ΐΐ" #
Ticket
ΐΐ# )
.
ΐΐ) *
AssignedUserId
ΐΐ* 8
??
ΐΐ9 ;
sla
ΐΐ< ?
.
ΐΐ? @
Ticket
ΐΐ@ F
.
ΐΐF G
RequesterUserId
ΐΐG V
;
ΐΐV W
await
ΒΒ %
CheckFirstResponseAsync
ΒΒ )
(
ΒΒ) *
sla
ΒΒ* -
,
ΒΒ- .
targetUserId
ΒΒ/ ;
,
ΒΒ; <
nowUtc
ΒΒ= C
)
ΒΒC D
;
ΒΒD E
await
ΓΓ "
CheckResolutionAsync
ΓΓ &
(
ΓΓ& '
sla
ΓΓ' *
,
ΓΓ* +
targetUserId
ΓΓ, 8
,
ΓΓ8 9
nowUtc
ΓΓ: @
)
ΓΓ@ A
;
ΓΓA B
}
ΔΔ 	
await
ΖΖ 
_context
ΖΖ 
.
ΖΖ 
SaveChangesAsync
ΖΖ '
(
ΖΖ' (
)
ΖΖ( )
;
ΖΖ) *
}
ΗΗ 
private
ΙΙ 
async
ΙΙ 
Task
ΙΙ %
CheckFirstResponseAsync
ΙΙ .
(
ΙΙ. /
	TicketSla
ΙΙ/ 8
sla
ΙΙ9 <
,
ΙΙ< =
int
ΙΙ> A
targetUserId
ΙΙB N
,
ΙΙN O
DateTime
ΙΙP X
nowUtc
ΙΙY _
)
ΙΙ_ `
{
ΚΚ 
if
ΛΛ 

(
ΛΛ 
sla
ΛΛ 
.
ΛΛ  
FirstResponseMetAt
ΛΛ "
.
ΛΛ" #
HasValue
ΛΛ# +
||
ΛΛ, .
!
ΛΛ/ 0
sla
ΛΛ0 3
.
ΛΛ3 4 
FirstResponseDueAt
ΛΛ4 F
.
ΛΛF G
HasValue
ΛΛG O
)
ΛΛO P
return
ΛΛQ W
;
ΛΛW X
var
ΝΝ 
(
ΝΝ 
warn
ΝΝ 
,
ΝΝ 
breach
ΝΝ 
)
ΝΝ 
=
ΝΝ 
EvaluateMetric
ΝΝ +
(
ΝΝ+ ,
sla
ΝΝ, /
.
ΝΝ/ 0 
FirstResponseDueAt
ΝΝ0 B
.
ΝΝB C
Value
ΝΝC H
,
ΝΝH I
sla
ΝΝJ M
.
ΝΝM N!
FirstResponseWarned
ΝΝN a
,
ΝΝa b
sla
ΝΝc f
.
ΝΝf g#
FirstResponseBreached
ΝΝg |
,
ΝΝ| }
nowUtcΝΝ~ „
)ΝΝ„ …
;ΝΝ… †
if
ΟΟ 

(
ΟΟ 
breach
ΟΟ 
)
ΟΟ 
{
ΠΠ 	
sla
ΡΡ 
.
ΡΡ #
FirstResponseBreached
ΡΡ %
=
ΡΡ& '
true
ΡΡ( ,
;
ΡΡ, -
await
ÒÒ %
_notificationDispatcher
ÒÒ )
.
ÒÒ) * 
DispatchEventAsync
ÒÒ* <
(
ÒÒ< =
$str
ÒÒ= I
,
ÒÒI J
sla
ÒÒK N
.
ÒÒN O
TicketId
ÒÒO W
,
ÒÒW X
null
ÒÒY ]
,
ÒÒ] ^
$str
ÒÒ_ }
)
ÒÒ} ~
;
ÒÒ~ 
await
ΣΣ 
TryEscalateAsync
ΣΣ "
(
ΣΣ" #
sla
ΣΣ# &
)
ΣΣ& '
;
ΣΣ' (
}
ΤΤ 	
else
ΥΥ 
if
ΥΥ 
(
ΥΥ 
warn
ΥΥ 
)
ΥΥ 
{
ΦΦ 	
sla
ΧΧ 
.
ΧΧ !
FirstResponseWarned
ΧΧ #
=
ΧΧ$ %
true
ΧΧ& *
;
ΧΧ* +
await
ΨΨ %
CreateNotificationAsync
ΨΨ )
(
ΨΨ) *
targetUserId
ΨΨ* 6
,
ΨΨ6 7
sla
ΨΨ8 ;
.
ΨΨ; <
TicketId
ΨΨ< D
,
ΨΨD E
$str
ΨΨF S
,
ΨΨS T
$str
ΨΨU }
)
ΨΨ} ~
;
ΨΨ~ 
}
ΩΩ 	
}
ΪΪ 
private
άά 
async
άά 
Task
άά "
CheckResolutionAsync
άά +
(
άά+ ,
	TicketSla
άά, 5
sla
άά6 9
,
άά9 :
int
άά; >
targetUserId
άά? K
,
άάK L
DateTime
άάM U
nowUtc
άάV \
)
άά\ ]
{
έέ 
if
ήή 

(
ήή 
sla
ήή 
.
ήή 
ResolutionMetAt
ήή 
.
ήή  
HasValue
ήή  (
||
ήή) +
!
ήή, -
sla
ήή- 0
.
ήή0 1
ResolutionDueAt
ήή1 @
.
ήή@ A
HasValue
ήήA I
)
ήήI J
return
ήήK Q
;
ήήQ R
var
ΰΰ 
(
ΰΰ 
warn
ΰΰ 
,
ΰΰ 
breach
ΰΰ 
)
ΰΰ 
=
ΰΰ 
EvaluateMetric
ΰΰ +
(
ΰΰ+ ,
sla
ΰΰ, /
.
ΰΰ/ 0
ResolutionDueAt
ΰΰ0 ?
.
ΰΰ? @
Value
ΰΰ@ E
,
ΰΰE F
sla
ΰΰG J
.
ΰΰJ K
ResolutionWarned
ΰΰK [
,
ΰΰ[ \
sla
ΰΰ] `
.
ΰΰ` a 
ResolutionBreached
ΰΰa s
,
ΰΰs t
nowUtc
ΰΰu {
)
ΰΰ{ |
;
ΰΰ| }
if
ββ 

(
ββ 
breach
ββ 
)
ββ 
{
γγ 	
sla
δδ 
.
δδ  
ResolutionBreached
δδ "
=
δδ# $
true
δδ% )
;
δδ) *
await
εε %
_notificationDispatcher
εε )
.
εε) * 
DispatchEventAsync
εε* <
(
εε< =
$str
εε= I
,
εεI J
sla
εεK N
.
εεN O
TicketId
εεO W
,
εεW X
null
εεY ]
,
εε] ^
$str
εε_ y
)
εεy z
;
εεz {
await
ζζ 
TryEscalateAsync
ζζ "
(
ζζ" #
sla
ζζ# &
)
ζζ& '
;
ζζ' (
}
ηη 	
else
θθ 
if
θθ 
(
θθ 
warn
θθ 
)
θθ 
{
ιι 	
sla
κκ 
.
κκ 
ResolutionWarned
κκ  
=
κκ! "
true
κκ# '
;
κκ' (
await
λλ %
CreateNotificationAsync
λλ )
(
λλ) *
targetUserId
λλ* 6
,
λλ6 7
sla
λλ8 ;
.
λλ; <
TicketId
λλ< D
,
λλD E
$str
λλF S
,
λλS T
$str
λλU y
)
λλy z
;
λλz {
}
μμ 	
}
νν 
private
οο 
async
οο 
Task
οο 
TryEscalateAsync
οο '
(
οο' (
	TicketSla
οο( 1
sla
οο2 5
)
οο5 6
{
ππ 
if
ρρ 

(
ρρ 
sla
ρρ 
.
ρρ 
EscalatedAt
ρρ 
.
ρρ 
HasValue
ρρ $
||
ρρ% '
sla
ρρ( +
.
ρρ+ ,
Ticket
ρρ, 2
==
ρρ3 5
null
ρρ6 :
)
ρρ: ;
return
ρρ< B
;
ρρB C
var
σσ 
target
σσ 
=
σσ 
await
σσ 
_context
σσ #
.
σσ# $

SlaTargets
σσ$ .
.
σσ. /!
FirstOrDefaultAsync
σσ/ B
(
σσB C
t
σσC D
=>
σσE G
t
σσH I
.
σσI J

PriorityId
σσJ T
==
σσU W
sla
σσX [
.
σσ[ \
Ticket
σσ\ b
.
σσb c

PriorityId
σσc m
&&
σσn p
(
σσq r
t
σσr s
.
σσs t
TicketTypeIdσσt €
==σσ ƒ
slaσσ„ ‡
.σσ‡ 
Ticketσσ 
.σσ 
TypeIdσσ •
||σσ– 
tσσ™ 
.σσ ›
TicketTypeIdσσ› §
==σσ¨ ª
nullσσ« ―
)σσ― °
)σσ° ±
;σσ± ²
if
ττ 

(
ττ 
target
ττ 
==
ττ 
null
ττ 
)
ττ 
return
ττ "
;
ττ" #
var
φφ 
policy
φφ 
=
φφ 
await
φφ 
_context
φφ #
.
φφ# $
SlaPolicies
φφ$ /
.
φφ/ 0!
FirstOrDefaultAsync
φφ0 C
(
φφC D
p
φφD E
=>
φφF H
p
φφI J
.
φφJ K
Id
φφK M
==
φφN P
target
φφQ W
.
φφW X
SlaPolicyId
φφX c
)
φφc d
;
φφd e
if
ψψ 

(
ψψ 
policy
ψψ 
!=
ψψ 
null
ψψ 
&&
ψψ 
policy
ψψ $
.
ψψ$ %
EscalateOnBreach
ψψ% 5
)
ψψ5 6
{
ωω 	
sla
ϊϊ 
.
ϊϊ 
EscalatedAt
ϊϊ 
=
ϊϊ 
DateTime
ϊϊ &
.
ϊϊ& '
UtcNow
ϊϊ' -
;
ϊϊ- .
var
ύύ 
higherPriority
ύύ 
=
ύύ  
await
ύύ! &
_context
ύύ' /
.
ύύ/ 0

Priorities
ύύ0 :
.
ώώ 
Where
ώώ 
(
ώώ 
p
ώώ 
=>
ώώ 
p
ώώ 
.
ώώ 
SeverityLevel
ώώ +
>
ώώ, -
sla
ώώ. 1
.
ώώ1 2
Ticket
ώώ2 8
.
ώώ8 9
Priority
ώώ9 A
!
ώώA B
.
ώώB C
SeverityLevel
ώώC P
)
ώώP Q
.
ÿÿ 
OrderBy
ÿÿ 
(
ÿÿ 
p
ÿÿ 
=>
ÿÿ 
p
ÿÿ 
.
ÿÿ  
SeverityLevel
ÿÿ  -
)
ÿÿ- .
.
€€ !
FirstOrDefaultAsync
€€ $
(
€€$ %
)
€€% &
;
€€& '
if
‚‚ 
(
‚‚ 
higherPriority
‚‚ 
!=
‚‚ !
null
‚‚" &
)
‚‚& '
{
ƒƒ 
var
„„ 
oldPriority
„„ 
=
„„  !
sla
„„" %
.
„„% &
Ticket
„„& ,
.
„„, -

PriorityId
„„- 7
.
„„7 8
ToString
„„8 @
(
„„@ A
)
„„A B
;
„„B C
sla
…… 
.
…… 
Ticket
…… 
.
…… 

PriorityId
…… %
=
……& '
higherPriority
……( 6
.
……6 7
Id
……7 9
;
……9 :
_context
‡‡ 
.
‡‡ 
TicketHistories
‡‡ (
.
‡‡( )
Add
‡‡) ,
(
‡‡, -
new
‡‡- 0
Domain
‡‡1 7
.
‡‡7 8
Entities
‡‡8 @
.
‡‡@ A
Ticket
‡‡A G
.
‡‡G H
TicketHistory
‡‡H U
{
 
TicketId
‰‰ 
=
‰‰ 
sla
‰‰ "
.
‰‰" #
TicketId
‰‰# +
,
‰‰+ ,
Action
 
=
 
$str
 (
,
( )
	FieldName
‹‹ 
=
‹‹ 
$str
‹‹  ,
,
‹‹, -
OldValue
 
=
 
oldPriority
 *
,
* +
NewValue
 
=
 
higherPriority
 -
.
- .
Id
. 0
.
0 1
ToString
1 9
(
9 :
)
: ;
,
; <
	CreatedBy
 
=
 
$str
  (
}
 
)
 
;
 
}
 
}
‘‘ 	
}
’’ 
private
”” 
static
”” 
(
”” 
bool
”” 
warn
”” 
,
”” 
bool
”” #
breach
””$ *
)
””* +
EvaluateMetric
””, :
(
””: ;
DateTime
””; C
dueAt
””D I
,
””I J
bool
””K O
warned
””P V
,
””V W
bool
””X \
breached
””] e
,
””e f
DateTime
””g o
now
””p s
)
””s t
{
•• 
var
–– 
timeRemaining
–– 
=
–– 
(
–– 
dueAt
–– "
-
––# $
now
––% (
)
––( )
.
––) *
TotalMinutes
––* 6
;
––6 7
if
 

(
 
timeRemaining
 
<=
 
$num
 
&&
 !
!
" #
breached
# +
)
+ ,
return
™™ 
(
™™ 
false
™™ 
,
™™ 
true
™™ 
)
™™  
;
™™  !
if
›› 

(
›› 
timeRemaining
›› 
>
›› 
$num
›› 
&&
››  
timeRemaining
››! .
<=
››/ 1
$num
››2 5
&&
››6 8
!
››9 :
warned
››: @
)
››@ A
return
 
(
 
true
 
,
 
false
 
)
  
;
  !
return
 
(
 
false
 
,
 
false
 
)
 
;
 
}
 
private
΅΅ 
async
΅΅ 
Task
΅΅ %
CreateNotificationAsync
΅΅ .
(
΅΅. /
int
΅΅/ 2
userId
΅΅3 9
,
΅΅9 :
int
΅΅; >
ticketId
΅΅? G
,
΅΅G H
string
΅΅I O
title
΅΅P U
,
΅΅U V
string
΅΅W ]
message
΅΅^ e
)
΅΅e f
{
ΆΆ 
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
¤¤ 	
UserId
¥¥ 
=
¥¥ 
userId
¥¥ 
,
¥¥ 
Title
¦¦ 
=
¦¦ 
title
¦¦ 
,
¦¦ 
Message
§§ 
=
§§ 
message
§§ 
,
§§ 
RelatedEntityId
¨¨ 
=
¨¨ 
ticketId
¨¨ &
,
¨¨& '
RelatedEntityType
©© 
=
©© 
$str
©©  (
}
ªª 	
)
ªª	 

;
ªª
 
var
­­ 
user
­­ 
=
­­ 
await
­­ 
_context
­­ !
.
­­! "
Users
­­" '
.
­­' (
	FindAsync
­­( 1
(
­­1 2
userId
­­2 8
)
­­8 9
;
­­9 :
if
®® 

(
®® 
user
®® 
!=
®® 
null
®® 
)
®® 
{
―― 	
await
°° 
_emailService
°° 
.
°°  
SendEmailAsync
°°  .
(
°°. /
user
°°/ 3
.
°°3 4
Email
°°4 9
,
°°9 :
title
°°; @
,
°°@ A
message
°°B I
)
°°I J
;
°°J K
}
±± 	
}
²² 
}³³ λ9
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
}JJ ²¬
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
string	22{ 
>
22 ‚
perms
22ƒ 
,
22 ‰
int
22 
userId
22 ”
)
22” •
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
ResolutionBreached	ddr „
)
dd„ …
)
dd… †
;
dd† ‡
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
ResolutionWarned	ffp €
)
ff€ 
&&
ff‚ „
!
ff… †
(
ff† ‡
t
ff‡ 
.
ff ‰
	TicketSla
ff‰ ’
.
ff’ “#
FirstResponseBreached
ff“ ¨
||
ff© «
t
ff¬ ­
.
ff­ ®
	TicketSla
ff® ·
.
ff· Έ 
ResolutionBreached
ffΈ Κ
)
ffΚ Λ
)
ffΛ Μ
;
ffΜ Ν
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
ResolutionWarned	hhq 
&&
hh‚ „
!
hh… †
t
hh† ‡
.
hh‡ 
	TicketSla
hh ‘
.
hh‘ ’#
FirstResponseBreached
hh’ §
&&
hh¨ ª
!
hh« ¬
t
hh¬ ­
.
hh­ ®
	TicketSla
hh® ·
.
hh· Έ 
ResolutionBreached
hhΈ Κ
)
hhΚ Λ
;
hhΛ Μ
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
tickets	mm| ƒ
)
mmƒ „
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
$str	rr  ‚
)
rr‚ ƒ
;
rrƒ „
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
(	}} €
t
}}€ 
.
}} ‚
Category
}}‚ 
?
}} ‹
.
}}‹ 
Name
}} 
)
}} ‘
}
}}‘ ’
$str
}}’ —
{
}}— 
	EscapeCsv
}} ΅
(
}}΅ Ά
t
}}Ά £
.
}}£ ¤
Type
}}¤ ¨
?
}}¨ ©
.
}}© ª
Name
}}ª ®
)
}}® ―
}
}}― °
$str
}}° µ
{
}}µ ¶
	EscapeCsv
}}¶ Ώ
(
}}Ώ ΐ
t
}}ΐ Α
.
}}Α Β
Status
}}Β Θ
?
}}Θ Ι
.
}}Ι Κ
Name
}}Κ Ξ
)
}}Ξ Ο
}
}}Ο Π
$str
}}Π Υ
{
}}Υ Φ
	EscapeCsv
}}Φ ί
(
}}ί ΰ
t
}}ΰ α
.
}}α β
Priority
}}β κ
?
}}κ λ
.
}}λ μ
Name
}}μ π
)
}}π ρ
}
}}ρ ς
$str
}}ς χ
{
}}χ ψ
	EscapeCsv
}}ψ 
(
}} ‚
t
}}‚ ƒ
.
}}ƒ „
RequesterUser
}}„ ‘
?
}}‘ ’
.
}}’ “
	FirstName
}}“ 
+
}} 
$str
}} Ά
+
}}£ ¤
t
}}¥ ¦
.
}}¦ §
RequesterUser
}}§ ΄
?
}}΄ µ
.
}}µ ¶
LastName
}}¶ Ύ
)
}}Ύ Ώ
}
}}Ώ ΐ
$str
}}ΐ Ε
{
}}Ε Ζ
	EscapeCsv
}}Ζ Ο
(
}}Ο Π
t
}}Π Ρ
.
}}Ρ Ò
AssignedUser
}}Ò ή
?
}}ή ί
.
}}ί ΰ
	FirstName
}}ΰ ι
+
}}κ λ
$str
}}μ ο
+
}}π ρ
t
}}ς σ
.
}}σ τ
AssignedUser
}}τ €
?
}}€ 
.
}} ‚
LastName
}}‚ 
)
}} ‹
}
}}‹ 
$str
}} ‘
{
}}‘ ’
t
}}’ “
.
}}“ ”
	CreatedAt
}}” 
:
}} 
$str
}} ±
}
}}± ²
$str
}}² ·
{
}}· Έ
	slaStatus
}}Έ Α
}
}}Α Β
$str
}}Β Δ
"
}}Δ Ε
;
}}Ε Ζ
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
 
sw
 
.
 

FlushAsync
 
(
 
)
 
;
 
ms
‚‚ 

.
‚‚
 
Position
‚‚ 
=
‚‚ 
$num
‚‚ 
;
‚‚ 
return
ƒƒ 
ms
ƒƒ 
;
ƒƒ 
}
„„ 
private
†† 
static
†† 
string
†† 
	EscapeCsv
†† #
(
††# $
string
††$ *
?
††* +
field
††, 1
)
††1 2
{
‡‡ 
if
 

(
 
string
 
.
 
IsNullOrEmpty
  
(
  !
field
! &
)
& '
)
' (
return
) /
$str
0 2
;
2 3
return
‰‰ 
field
‰‰ 
.
‰‰ 
Replace
‰‰ 
(
‰‰ 
$str
‰‰ !
,
‰‰! "
$str
‰‰# )
)
‰‰) *
;
‰‰* +
}
 
}‹‹ ’F
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
}XX α=
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
o	<< €
.
<<€ 

Permission
<< ‹
.
<<‹ 
	IsDeleted
<< •
)
<<• –
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
}GG Η%
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
RelatedEntityType	w 
,
 ‰
n
 ‹
.
‹ 
	CreatedAt
 •
)
• –
)
– —
;
— 
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
	IsDeleted	  } †
)
  † ‡
;
  ‡ 
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
}11 Ό^
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
null	 ƒ
)
ƒ „
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
))€ 
additionalContext
))‚ “
}
))” •
)
))• –
;
))– —
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
NotificationRule	,,} 
>
,, 
rules
,, ”
,
,,” •
Domain
,,– 
.
,, 
Entities
,, ¥
.
,,¥ ¦
Ticket
,,¦ ¬
.
,,¬ ­
Ticket
,,­ ³
ticket
,,΄ Ί
,
,,Ί »
int
,,Ό Ώ
?
,,Ώ ΐ
triggerUserId
,,Α Ξ
)
,,Ξ Ο
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
.	OO €
Entities
OO€ 
.
OO ‰
Ticket
OO‰ 
.
OO 
Ticket
OO –
ticket
OO— 
,
OO 
string
OO ¥
?
OO¥ ¦
additionalContext
OO§ Έ
)
OOΈ Ή
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
additionalContext	mm 
)
mm ‘
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
eventKey	rrx €
}
rr€ 
$str
rr …
{
rr… †
ticket
rr† 
.
rr 
TicketNumber
rr ™
}
rr™ 
"
rr ›
)
rr› 
;
rr 
}ss 	
}tt 
}uu ‚$
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
$str	Q 
,
 ›
$str
 ί
}
ΰ α
;
α β
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
}22 ”–
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
StringComparison	TTx 
.
TT ‰
OrdinalIgnoreCase
TT‰ 
)
TT ›
)
TT› 
;
TT 
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
	ViewCount	YY 
,
YY ‰
a
YY ‹
.
YY‹ 
	CreatedAt
YY •
)
YY• –
)
YY– —
;
YY— 
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
Status	pp~ „
,
pp„ …
article
pp† 
.
pp 

Visibility
pp 
,
pp ™
article
pp ΅
.
pp΅ Ά
	ViewCount
ppΆ «
,
pp« ¬
article
pp­ ΄
.
pp΄ µ
	CreatedAt
ppµ Ύ
)
ppΎ Ώ
;
ppΏ ΐ
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
 
new
 
KbArticleDto
 
(
  
article
  '
.
' (
Id
( *
,
* +
article
, 3
.
3 4

CategoryId
4 >
,
> ?
article
@ G
.
G H
Title
H M
,
M N
article
O V
.
V W
Content
W ^
,
^ _
article
` g
.
g h
AuthorUserId
h t
,
t u
article
v }
.
} ~
Status~ „
,„ …
article† 
. 

Visibility 
, ™
article ΅
.΅ Ά
	ViewCountΆ «
,« ¬
article­ ΄
.΄ µ
	CreatedAtµ Ύ
)Ύ Ώ
;Ώ ΐ
}
‚‚ 
public
„„ 

async
„„ 
Task
„„  
UpdateArticleAsync
„„ (
(
„„( )
int
„„) ,
id
„„- /
,
„„/ 0 
UpdateKbArticleDto
„„1 C
dto
„„D G
)
„„G H
{
…… 
var
†† 
article
†† 
=
†† 
await
†† 
_context
†† $
.
††$ %
KnowledgeArticles
††% 6
.
††6 7!
FirstOrDefaultAsync
††7 J
(
††J K
a
††K L
=>
††M O
a
††P Q
.
††Q R
Id
††R T
==
††U W
id
††X Z
&&
††[ ]
!
††^ _
a
††_ `
.
††` a
	IsDeleted
††a j
)
††j k
;
††k l
if
‡‡ 

(
‡‡ 
article
‡‡ 
==
‡‡ 
null
‡‡ 
)
‡‡ 
throw
‡‡ "
new
‡‡# &"
KeyNotFoundException
‡‡' ;
(
‡‡; <
$str
‡‡< P
)
‡‡P Q
;
‡‡Q R
article
‰‰ 
.
‰‰ 

CategoryId
‰‰ 
=
‰‰ 
dto
‰‰  
.
‰‰  !

CategoryId
‰‰! +
;
‰‰+ ,
article
 
.
 
Title
 
=
 
dto
 
.
 
Title
 !
;
! "
article
‹‹ 
.
‹‹ 
Content
‹‹ 
=
‹‹ 
dto
‹‹ 
.
‹‹ 
Content
‹‹ %
;
‹‹% &
article
 
.
 
Status
 
=
 
dto
 
.
 
Status
 #
;
# $
article
 
.
 

Visibility
 
=
 
dto
  
.
  !

Visibility
! +
;
+ ,
await
 
_context
 
.
 
SaveChangesAsync
 '
(
' (
)
( )
;
) *
}
 
public
‘‘ 

async
‘‘ 
Task
‘‘  
DeleteArticleAsync
‘‘ (
(
‘‘( )
int
‘‘) ,
id
‘‘- /
)
‘‘/ 0
{
’’ 
var
““ 
article
““ 
=
““ 
await
““ 
_context
““ $
.
““$ %
KnowledgeArticles
““% 6
.
““6 7!
FirstOrDefaultAsync
““7 J
(
““J K
a
““K L
=>
““M O
a
““P Q
.
““Q R
Id
““R T
==
““U W
id
““X Z
&&
““[ ]
!
““^ _
a
““_ `
.
““` a
	IsDeleted
““a j
)
““j k
;
““k l
if
”” 

(
”” 
article
”” 
!=
”” 
null
”” 
)
”” 
{
•• 	
article
–– 
.
–– 
	IsDeleted
–– 
=
–– 
true
––  $
;
––$ %
await
—— 
_context
—— 
.
—— 
SaveChangesAsync
—— +
(
——+ ,
)
——, -
;
——- .
}
 	
}
™™ 
} Ξ>
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
}OO T
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
OrdinalIgnoreCase	!!s „
)
!!„ …
)
!!… †
;
!!† ‡
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
}yy ΊΒ
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
IsActive	z ‚
)
‚ ƒ
)
ƒ „
;
„ …
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
ValidationRegex	00q €
}
00 ‚
;
00‚ ƒ
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
IsActive	??} …
;
??… †
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
dto	TT ‚
.
TT‚ ƒ
	SortOrder
TTƒ 
}
TT 
;
TT 
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
)	cc €
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
gg€ 
.
gg ‚
	SortOrder
gg‚ ‹
,
gg‹ 
p
gg 
.
gg 

IsRequired
gg ™
,
gg™ 
p
gg› 
.
gg 
IsActive
gg ¥
)
gg¥ ¦
)
gg¦ §
;
gg§ ¨
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

IsRequired	nn~ 
,
nn ‰
p
nn ‹
.
nn‹ 
IsActive
nn ”
)
nn” •
;
nn• –
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
.	|| €

CategoryId
||€ 
,
|| ‹
TicketTypeId
|| 
=
||™ 
dto
||› 
.
|| 
TicketTypeId
|| «
,
||« ¬
	SortOrder
||­ ¶
=
||· Έ
dto
||Ή Ό
.
||Ό ½
	SortOrder
||½ Ζ
,
||Ζ Η

IsRequired
||Θ Ò
=
||Σ Τ
dto
||Υ Ψ
.
||Ψ Ω

IsRequired
||Ω γ
}
||δ ε
;
||ε ζ
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

IsRequired	~~~ 
,
~~ ‰
p
~~ ‹
.
~~‹ 
IsActive
~~ ”
)
~~” •
;
~~• –
} 
public
 

async
 
Task
 "
UpdatePlacementAsync
 *
(
* +
int
+ .
id
/ 1
,
1 2)
UpdateFormFieldPlacementDto
3 N
dto
O R
)
R S
{
‚‚ 
var
ƒƒ 
p
ƒƒ 
=
ƒƒ 
await
ƒƒ 
_placementRepo
ƒƒ $
.
ƒƒ$ %
GetByIdAsync
ƒƒ% 1
(
ƒƒ1 2
id
ƒƒ2 4
)
ƒƒ4 5
;
ƒƒ5 6
if
„„ 

(
„„ 
p
„„ 
==
„„ 
null
„„ 
)
„„ 
throw
„„ 
new
„„  "
KeyNotFoundException
„„! 5
(
„„5 6
$str
„„6 T
)
„„T U
;
„„U V
var
†† 
exists
†† 
=
†† 
await
†† 
_context
†† #
.
††# $!
FormFieldPlacements
††$ 7
.
††7 8
AnyAsync
††8 @
(
††@ A
fp
††A C
=>
††D F
fp
‡‡ 
.
‡‡ 
Id
‡‡ 
!=
‡‡ 
id
‡‡ 
&&
‡‡ 
fp
 
.
 
FieldDefinitionId
  
==
! #
p
$ %
.
% &
FieldDefinitionId
& 7
&&
8 :
fp
‰‰ 
.
‰‰ 
	ProjectId
‰‰ 
==
‰‰ 
dto
‰‰ 
.
‰‰  
	ProjectId
‰‰  )
&&
‰‰* ,
fp
 
.
 

CategoryId
 
==
 
dto
  
.
  !

CategoryId
! +
&&
, .
fp
‹‹ 
.
‹‹ 
TicketTypeId
‹‹ 
==
‹‹ 
dto
‹‹ "
.
‹‹" #
TicketTypeId
‹‹# /
&&
‹‹0 2
!
 
fp
 
.
 
	IsDeleted
 
)
 
;
 
if
 

(
 
exists
 
)
 
throw
 
new
 '
InvalidOperationException
 7
(
7 8
$str
8 e
)
e f
;
f g
p
 	
.
	 

	ProjectId

 
=
 
dto
 
.
 
	ProjectId
 #
;
# $
p
% &
.
& '

CategoryId
' 1
=
2 3
dto
4 7
.
7 8

CategoryId
8 B
;
B C
p
D E
.
E F
TicketTypeId
F R
=
S T
dto
U X
.
X Y
TicketTypeId
Y e
;
e f
p
g h
.
h i
	SortOrder
i r
=
s t
dto
u x
.
x y
	SortOrdery ‚
;‚ ƒ
p„ …
.… †

IsRequired† 
=‘ ’
dto“ –
.– —

IsRequired— ΅
;΅ Ά
p£ ¤
.¤ ¥
IsActive¥ ­
=® ―
dto° ³
.³ ΄
IsActive΄ Ό
;Ό ½
await
‘‘ 
_placementRepo
‘‘ 
.
‘‘ 
UpdateAsync
‘‘ (
(
‘‘( )
p
‘‘) *
)
‘‘* +
;
‘‘+ ,
}
’’ 
public
”” 

async
”” 
Task
”” "
DeletePlacementAsync
”” *
(
””* +
int
””+ .
id
””/ 1
)
””1 2
=>
””3 5
await
””6 ;
_placementRepo
””< J
.
””J K
DeleteAsync
””K V
(
””V W
id
””W Y
)
””Y Z
;
””Z [
}•• ή)
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
}77 ΐε
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
!=	@@ 
null
@@‚ †
&&
@@‡ ‰
!
@@ ‹
t
@@‹ 
.
@@ 
Status
@@ “
.
@@“ ”
IsClosedStatus
@@” Ά
)
@@Ά £
;
@@£ ¤
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
	TicketSla	AAz ƒ
.
AAƒ „ 
ResolutionBreached
AA„ –
)
AA– —
&&
AA 
t
AA› 
.
AA 
Status
AA £
!=
AA¤ ¦
null
AA§ «
&&
AA¬ ®
!
AA― °
t
AA° ±
.
AA± ²
Status
AA² Έ
.
AAΈ Ή
IsClosedStatus
AAΉ Η
)
AAΗ Θ
;
AAΘ Ι
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
ResolutionWarned	BB~ 
)
BB 
&&
BB ’
!
BB“ ”
(
BB” •
t
BB• –
.
BB– —
	TicketSla
BB—  
.
BB  ΅#
FirstResponseBreached
BB΅ ¶
||
BB· Ή
t
BBΊ »
.
BB» Ό
	TicketSla
BBΌ Ε
.
BBΕ Ζ 
ResolutionBreached
BBΖ Ψ
)
BBΨ Ω
&&
BBΪ ά
t
BBέ ή
.
BBή ί
Status
BBί ε
!=
BBζ θ
null
BBι ν
&&
BBξ π
!
BBρ ς
t
BBς σ
.
BBσ τ
Status
BBτ ϊ
.
BBϊ ϋ
IsClosedStatus
BBϋ ‰
)
BB‰ 
;
BB ‹
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
IsClosedStatus	CCt ‚
)
CC‚ ƒ
;
CCƒ „
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
,	HH €
csatAverage
HH 
)
HH 
;
HH 
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
€€ 
.
€€ 
Id
€€ 
,
€€ 
$"
 
{
 
u
 
.
 
	FirstName
 "
}
" #
$str
# $
{
$ %
u
% &
.
& '
LastName
' /
}
/ 0
"
0 1
,
1 2%
openTicketsCountPerUser
‚‚ +
.
‚‚+ ,
GetValueOrDefault
‚‚, =
(
‚‚= >
u
‚‚> ?
.
‚‚? @
Id
‚‚@ B
,
‚‚B C
$num
‚‚D E
)
‚‚E F
)
ƒƒ 
)
ƒƒ 
.
ƒƒ 
OrderByDescending
ƒƒ $
(
ƒƒ$ %
a
ƒƒ% &
=>
ƒƒ' )
a
ƒƒ* +
.
ƒƒ+ ,
OpenTicketCount
ƒƒ, ;
)
ƒƒ; <
.
ƒƒ< =
ToList
ƒƒ= C
(
ƒƒC D
)
ƒƒD E
)
„„ 
)
„„ 
.
…… 
Where
…… 
(
…… 
w
…… 
=>
…… 
w
…… 
.
…… 
DepartmentId
…… &
!=
……' )
$num
……* +
||
……, .
w
……/ 0
.
……0 1
OpenTicketCount
……1 @
>
……A B
$num
……C D
)
……D E
.
†† 
OrderByDescending
†† 
(
†† 
w
††  
=>
††! #
w
††$ %
.
††% &
OpenTicketCount
††& 5
)
††5 6
.
‡‡ 
ThenBy
‡‡ 
(
‡‡ 
w
‡‡ 
=>
‡‡ 
w
‡‡ 
.
‡‡ 
DepartmentName
‡‡ )
)
‡‡) *
.
 
ToList
 
(
 
)
 
;
 
return
 
workload
 
;
 
}
‹‹ 
public
 

async
 
Task
 
<
 
SlaComplianceDto
 &
>
& '#
GetSlaComplianceAsync
( =
(
= >
int
> A
userId
B H
)
H I
{
 
var
 
query
 
=
 
await
 (
GetScopedTicketsQueryAsync
 4
(
4 5
userId
5 ;
)
; <
;
< =
var
‘‘ 
ticketsWithSla
‘‘ 
=
‘‘ 
await
‘‘ "
query
‘‘# (
.
’’ 
Where
’’ 
(
’’ 
t
’’ 
=>
’’ 
t
’’ 
.
’’ 
	TicketSla
’’ #
!=
’’$ &
null
’’' +
)
’’+ ,
.
““ 
Select
““ 
(
““ 
t
““ 
=>
““ 
new
““ 
{
““ 
t
”” 
.
”” 
	TicketSla
”” 
!
”” 
.
””  
FirstResponseDueAt
”” /
,
””/ 0
t
•• 
.
•• 
	TicketSla
•• 
.
••  
FirstResponseMetAt
•• .
,
••. /
t
–– 
.
–– 
	TicketSla
–– 
.
–– 
ResolutionDueAt
–– +
,
––+ ,
t
—— 
.
—— 
	TicketSla
—— 
.
—— 
ResolutionMetAt
—— +
,
——+ ,
t
 
.
 
	TicketSla
 
.
 #
FirstResponseBreached
 1
,
1 2
t
™™ 
.
™™ 
	TicketSla
™™ 
.
™™  
ResolutionBreached
™™ .
,
™™. /
	CreatedAt
 
=
 
t
 
.
 
	CreatedAt
 '
,
' (

ResolvedAt
›› 
=
›› 
t
›› 
.
›› 
Status
›› %
!=
››& (
null
››) -
&&
››. 0
t
››1 2
.
››2 3
Status
››3 9
.
››9 :
IsClosedStatus
››: H
?
››I J
t
››K L
.
››L M
	TicketSla
››M V
.
››V W
ResolutionMetAt
››W f
??
››g i
DateTime
››j r
.
››r s
UtcNow
››s y
:
››z {
(
››| }
DateTime››} …
?››… †
)››† ‡
null››‡ ‹
}
 
)
 
.
 
ToListAsync
 
(
 
)
 
;
 
if
 

(
 
ticketsWithSla
 
.
 
Count
  
==
! #
$num
$ %
)
% &
return
' -
new
. 1
SlaComplianceDto
2 B
(
B C
$num
C F
,
F G
$num
H K
,
K L
$num
M N
)
N O
;
O P
var
΅΅ #
firstResponseEligible
΅΅ !
=
΅΅" #
ticketsWithSla
΅΅$ 2
.
΅΅2 3
Where
΅΅3 8
(
΅΅8 9
t
΅΅9 :
=>
΅΅; =
t
΅΅> ?
.
΅΅? @ 
FirstResponseDueAt
΅΅@ R
!=
΅΅S U
null
΅΅V Z
)
΅΅Z [
.
΅΅[ \
ToList
΅΅\ b
(
΅΅b c
)
΅΅c d
;
΅΅d e
var
ΆΆ 
frCompliant
ΆΆ 
=
ΆΆ #
firstResponseEligible
ΆΆ /
.
ΆΆ/ 0
Count
ΆΆ0 5
(
ΆΆ5 6
t
ΆΆ6 7
=>
ΆΆ8 :
!
ΆΆ; <
t
ΆΆ< =
.
ΆΆ= >#
FirstResponseBreached
ΆΆ> S
)
ΆΆS T
;
ΆΆT U
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
¥¥ 
resEligible
¥¥ 
=
¥¥ 
ticketsWithSla
¥¥ (
.
¥¥( )
Where
¥¥) .
(
¥¥. /
t
¥¥/ 0
=>
¥¥1 3
t
¥¥4 5
.
¥¥5 6
ResolutionDueAt
¥¥6 E
!=
¥¥F H
null
¥¥I M
)
¥¥M N
.
¥¥N O
ToList
¥¥O U
(
¥¥U V
)
¥¥V W
;
¥¥W X
var
¦¦ 
resCompliant
¦¦ 
=
¦¦ 
resEligible
¦¦ &
.
¦¦& '
Count
¦¦' ,
(
¦¦, -
t
¦¦- .
=>
¦¦/ 1
!
¦¦2 3
t
¦¦3 4
.
¦¦4 5 
ResolutionBreached
¦¦5 G
)
¦¦G H
;
¦¦H I
var
§§ 
resRate
§§ 
=
§§ 
resEligible
§§ !
.
§§! "
Count
§§" '
>
§§( )
$num
§§* +
?
§§, -
(
§§. /
resCompliant
§§/ ;
/
§§< =
(
§§> ?
double
§§? E
)
§§E F
resEligible
§§F Q
.
§§Q R
Count
§§R W
)
§§W X
*
§§Y Z
$num
§§[ ^
:
§§_ `
$num
§§a d
;
§§d e
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
ªª 
avgTime
ªª 
=
ªª 
resolvedTickets
ªª %
.
ªª% &
Count
ªª& +
>
ªª, -
$num
ªª. /
?
ªª0 1
resolvedTickets
ªª2 A
.
ªªA B
Average
ªªB I
(
ªªI J
t
ªªJ K
=>
ªªL N
(
ªªO P
t
ªªP Q
.
ªªQ R

ResolvedAt
ªªR \
!
ªª\ ]
.
ªª] ^
Value
ªª^ c
-
ªªd e
t
ªªf g
.
ªªg h
	CreatedAt
ªªh q
)
ªªq r
.
ªªr s
TotalMinutes
ªªs 
)ªª €
:ªª ‚
$numªªƒ †
;ªª† ‡
return
¬¬ 
new
¬¬ 
SlaComplianceDto
¬¬ #
(
¬¬# $
frRate
¬¬$ *
,
¬¬* +
resRate
¬¬, 3
,
¬¬3 4
avgTime
¬¬5 <
)
¬¬< =
;
¬¬= >
}
­­ 
public
―― 

async
―― 
Task
―― 
<
―― 
IEnumerable
―― !
<
――! "
TicketSurveyDto
――" 1
>
――1 2
>
――2 3#
GetRecentSurveysAsync
――4 I
(
――I J
int
――J M
userId
――N T
)
――T U
{
°° 
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
·· 
query
·· 
=
·· 
_context
·· 
.
·· 
TicketSurveys
·· *
.
··* +
AsQueryable
··+ 6
(
··6 7
)
··7 8
;
··8 9
if
ΉΉ 

(
ΉΉ 
!
ΉΉ 
perms
ΉΉ 
.
ΉΉ 
Contains
ΉΉ 
(
ΉΉ 
$str
ΉΉ )
)
ΉΉ) *
)
ΉΉ* +
{
ΊΊ 	
var
½½ 
scopedTickets
½½ 
=
½½ 
await
½½  %(
GetScopedTicketsQueryAsync
½½& @
(
½½@ A
userId
½½A G
)
½½G H
;
½½H I
var
ΎΎ 
scopedTicketIds
ΎΎ 
=
ΎΎ  !
await
ΎΎ" '
scopedTickets
ΎΎ( 5
.
ΎΎ5 6
Select
ΎΎ6 <
(
ΎΎ< =
t
ΎΎ= >
=>
ΎΎ? A
t
ΎΎB C
.
ΎΎC D
Id
ΎΎD F
)
ΎΎF G
.
ΎΎG H
ToListAsync
ΎΎH S
(
ΎΎS T
)
ΎΎT U
;
ΎΎU V
query
ΏΏ 
=
ΏΏ 
query
ΏΏ 
.
ΏΏ 
Where
ΏΏ 
(
ΏΏ  
s
ΏΏ  !
=>
ΏΏ" $
scopedTicketIds
ΏΏ% 4
.
ΏΏ4 5
Contains
ΏΏ5 =
(
ΏΏ= >
s
ΏΏ> ?
.
ΏΏ? @
TicketId
ΏΏ@ H
)
ΏΏH I
)
ΏΏI J
;
ΏΏJ K
}
ΐΐ 	
var
ΒΒ 
surveys
ΒΒ 
=
ΒΒ 
await
ΒΒ 
query
ΒΒ !
.
ΓΓ 
Include
ΓΓ 
(
ΓΓ 
s
ΓΓ 
=>
ΓΓ 
s
ΓΓ 
.
ΓΓ 
Ticket
ΓΓ "
)
ΓΓ" #
.
ΔΔ 
OrderByDescending
ΔΔ 
(
ΔΔ 
s
ΔΔ  
=>
ΔΔ! #
s
ΔΔ$ %
.
ΔΔ% &
	CreatedAt
ΔΔ& /
)
ΔΔ/ 0
.
ΕΕ 
Take
ΕΕ 
(
ΕΕ 
$num
ΕΕ 
)
ΕΕ 
.
ΖΖ 
Select
ΖΖ 
(
ΖΖ 
s
ΖΖ 
=>
ΖΖ 
new
ΖΖ 
TicketSurveyDto
ΖΖ ,
(
ΖΖ, -
s
ΖΖ- .
.
ΖΖ. /
Id
ΖΖ/ 1
,
ΖΖ1 2
s
ΖΖ3 4
.
ΖΖ4 5
TicketId
ΖΖ5 =
,
ΖΖ= >
s
ΖΖ? @
.
ΖΖ@ A
Rating
ΖΖA G
,
ΖΖG H
s
ΖΖI J
.
ΖΖJ K
Comment
ΖΖK R
,
ΖΖR S
s
ΖΖT U
.
ΖΖU V
	CreatedAt
ΖΖV _
)
ΖΖ_ `
)
ΖΖ` a
.
ΗΗ 
ToListAsync
ΗΗ 
(
ΗΗ 
)
ΗΗ 
;
ΗΗ 
return
ΙΙ 
surveys
ΙΙ 
;
ΙΙ 
}
ΚΚ 
}ΛΛ ώR
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
!	TT €
o
TT€ 
.
TT ‚

Permission
TT‚ 
.
TT 
	IsDeleted
TT –
)
TT– —
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
}bb «Ε
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
DefaultAssigneeGroupId	##p †
,
##† ‡
c
## ‰
.
##‰ 
IsActive
## ’
)
##’ “
)
##“ ”
;
##” •
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
IsActive	**y 
)
** ‚
;
**‚ ƒ
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
//€ 
dto
//‚ …
.
//… †
Description
//† ‘
,
//‘ ’$
DefaultAssigneeGroupId
//“ ©
=
//ª «
dto
//¬ ―
.
//― °$
DefaultAssigneeGroupId
//° Ζ
}
//Η Θ
;
//Θ Ι
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
IsActive	11y 
)
11 ‚
;
11‚ ƒ
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
Description	88w ‚
;
88‚ ƒ
c
88„ …
.
88… †$
DefaultAssigneeGroupId
88† 
=
88 
dto
88 Ά
.
88Ά £$
DefaultAssigneeGroupId
88£ Ή
;
88Ή Ί
c
88» Ό
.
88Ό ½
IsActive
88½ Ε
=
88Ζ Η
dto
88Θ Λ
.
88Λ Μ
IsActive
88Μ Τ
;
88Τ Υ
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
IsActive	aa| „
)
aa„ …
)
aa… †
;
aa† ‡
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
IsClosedStatus	mmw …
,
mm… †
IsSystemDefault
mm‡ –
=
mm— 
dto
mm™ 
.
mm 
IsSystemDefault
mm ¬
}
mm­ ®
;
mm® ―
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
IsSystemDefault	vv| ‹
=
vv 
dto
vv ‘
.
vv‘ ’
IsSystemDefault
vv’ ΅
;
vv΅ Ά
s
vv£ ¤
.
vv¤ ¥
IsActive
vv¥ ­
=
vv® ―
dto
vv° ³
.
vv³ ΄
IsActive
vv΄ Ό
;
vvΌ ½
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
==	|| 
id
||‚ „
)
||„ …
)
||… †
;
||† ‡
if}} 

(}} 
inUse}} 
)}} 
{~~ 	
throw
‚‚ 
new
‚‚ '
InvalidOperationException
‚‚ /
(
‚‚/ 0
$str‚‚0 „
)‚‚„ …
;‚‚… †
}
ƒƒ 	
await
„„ 
_statusRepo
„„ 
.
„„ 
DeleteAsync
„„ %
(
„„% &
id
„„& (
)
„„( )
;
„„) *
}
…… 
public
 

async
 
Task
 
<
 
IEnumerable
 !
<
! "
PriorityDto
" -
>
- .
>
. / 
GetPrioritiesAsync
0 B
(
B C
)
C D
{
‰‰ 
var
 
list
 
=
 
await
 
_priorityRepo
 &
.
& '
GetAllAsync
' 2
(
2 3
)
3 4
;
4 5
return
‹‹ 
list
‹‹ 
.
‹‹ 
Select
‹‹ 
(
‹‹ 
p
‹‹ 
=>
‹‹ 
new
‹‹  #
PriorityDto
‹‹$ /
(
‹‹/ 0
p
‹‹0 1
.
‹‹1 2
Id
‹‹2 4
,
‹‹4 5
p
‹‹6 7
.
‹‹7 8
Name
‹‹8 <
,
‹‹< =
p
‹‹> ?
.
‹‹? @
ColorHex
‹‹@ H
,
‹‹H I
p
‹‹J K
.
‹‹K L
Weight
‹‹L R
,
‹‹R S
p
‹‹T U
.
‹‹U V
SeverityLevel
‹‹V c
,
‹‹c d
p
‹‹e f
.
‹‹f g
IsActive
‹‹g o
)
‹‹o p
)
‹‹p q
;
‹‹q r
}
 
public
 

async
 
Task
 
<
 
PriorityDto
 !
?
! "
>
" #"
GetPriorityByIdAsync
$ 8
(
8 9
int
9 <
id
= ?
)
? @
{
 
var
 
p
 
=
 
await
 
_priorityRepo
 #
.
# $
GetByIdAsync
$ 0
(
0 1
id
1 3
)
3 4
;
4 5
if
‘‘ 

(
‘‘ 
p
‘‘ 
==
‘‘ 
null
‘‘ 
)
‘‘ 
return
‘‘ 
null
‘‘ "
;
‘‘" #
return
’’ 
new
’’ 
PriorityDto
’’ 
(
’’ 
p
’’  
.
’’  !
Id
’’! #
,
’’# $
p
’’% &
.
’’& '
Name
’’' +
,
’’+ ,
p
’’- .
.
’’. /
ColorHex
’’/ 7
,
’’7 8
p
’’9 :
.
’’: ;
Weight
’’; A
,
’’A B
p
’’C D
.
’’D E
SeverityLevel
’’E R
,
’’R S
p
’’T U
.
’’U V
IsActive
’’V ^
)
’’^ _
;
’’_ `
}
““ 
public
•• 

async
•• 
Task
•• 
<
•• 
PriorityDto
•• !
>
••! "!
CreatePriorityAsync
••# 6
(
••6 7
CreatePriorityDto
••7 H
dto
••I L
)
••L M
{
–– 
var
—— 
p
—— 
=
—— 
new
—— 
Priority
—— 
{
—— 
Name
—— #
=
——$ %
dto
——& )
.
——) *
Name
——* .
,
——. /
ColorHex
——0 8
=
——9 :
dto
——; >
.
——> ?
ColorHex
——? G
,
——G H
Weight
——I O
=
——P Q
dto
——R U
.
——U V
Weight
——V \
,
——\ ]
SeverityLevel
——^ k
=
——l m
dto
——n q
.
——q r
SeverityLevel
——r 
}——€ 
;—— ‚
await
 
_priorityRepo
 
.
 
AddAsync
 $
(
$ %
p
% &
)
& '
;
' (
return
™™ 
new
™™ 
PriorityDto
™™ 
(
™™ 
p
™™  
.
™™  !
Id
™™! #
,
™™# $
p
™™% &
.
™™& '
Name
™™' +
,
™™+ ,
p
™™- .
.
™™. /
ColorHex
™™/ 7
,
™™7 8
p
™™9 :
.
™™: ;
Weight
™™; A
,
™™A B
p
™™C D
.
™™D E
SeverityLevel
™™E R
,
™™R S
p
™™T U
.
™™U V
IsActive
™™V ^
)
™™^ _
;
™™_ `
}
 
public
 

async
 
Task
 !
UpdatePriorityAsync
 )
(
) *
int
* -
id
. 0
,
0 1
UpdatePriorityDto
2 C
dto
D G
)
G H
{
 
var
 
p
 
=
 
await
 
_priorityRepo
 #
.
# $
GetByIdAsync
$ 0
(
0 1
id
1 3
)
3 4
;
4 5
if
 

(
 
p
 
==
 
null
 
)
 
throw
 
new
  "
KeyNotFoundException
! 5
(
5 6
$str
6 J
)
J K
;
K L
p
   	
.
  	 

Name
  
 
=
   
dto
   
.
   
Name
   
;
   
p
   
.
   
ColorHex
   %
=
  & '
dto
  ( +
.
  + ,
ColorHex
  , 4
;
  4 5
p
  6 7
.
  7 8
Weight
  8 >
=
  ? @
dto
  A D
.
  D E
Weight
  E K
;
  K L
p
  M N
.
  N O
SeverityLevel
  O \
=
  ] ^
dto
  _ b
.
  b c
SeverityLevel
  c p
;
  p q
p
  r s
.
  s t
IsActive
  t |
=
  } ~
dto   ‚
.  ‚ ƒ
IsActive  ƒ ‹
;  ‹ 
await
΅΅ 
_priorityRepo
΅΅ 
.
΅΅ 
UpdateAsync
΅΅ '
(
΅΅' (
p
΅΅( )
)
΅΅) *
;
΅΅* +
}
ΆΆ 
public
¤¤ 

async
¤¤ 
Task
¤¤ !
DeletePriorityAsync
¤¤ )
(
¤¤) *
int
¤¤* -
id
¤¤. 0
)
¤¤0 1
=>
¤¤2 4
await
¤¤5 :
_priorityRepo
¤¤; H
.
¤¤H I
DeleteAsync
¤¤I T
(
¤¤T U
id
¤¤U W
)
¤¤W X
;
¤¤X Y
}¥¥ ν
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
})) …"
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
}44 
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
} Κ
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
} ΰ/
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
}LL Ν1
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
}99 σ€
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
€€ 
:
€€ 
$str
€€ &
)
€€& '
;
€€' (
migrationBuilder
‚‚ 
.
‚‚ 
CreateIndex
‚‚ (
(
‚‚( )
name
ƒƒ 
:
ƒƒ 
$str
ƒƒ .
,
ƒƒ. /
table
„„ 
:
„„ 
$str
„„ %
,
„„% &
column
…… 
:
…… 
$str
……  
)
……  !
;
……! "
}
†† 	
	protected
‰‰ 
override
‰‰ 
void
‰‰ 
Down
‰‰  $
(
‰‰$ %
MigrationBuilder
‰‰% 5
migrationBuilder
‰‰6 F
)
‰‰F G
{
 	
migrationBuilder
‹‹ 
.
‹‹ 
	DropTable
‹‹ &
(
‹‹& '
name
 
:
 
$str
 '
)
' (
;
( )
migrationBuilder
 
.
 
	DropTable
 &
(
& '
name
 
:
 
$str
 $
)
$ %
;
% &
}
 	
}
‘‘ 
}’’ µ
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
} ό
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
}00 ¨’
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
€€ &
=
€€' (
table
€€) .
.
€€. /
Column
€€/ 5
<
€€5 6
DateTime
€€6 >
>
€€> ?
(
€€? @
type
€€@ D
:
€€D E
$str
€€F `
,
€€` a
nullable
€€b j
:
€€j k
true
€€l p
)
€€p q
,
€€q r
ResolutionDueAt
 #
=
$ %
table
& +
.
+ ,
Column
, 2
<
2 3
DateTime
3 ;
>
; <
(
< =
type
= A
:
A B
$str
C ]
,
] ^
nullable
_ g
:
g h
true
i m
)
m n
,
n o
PausedAt
‚‚ 
=
‚‚ 
table
‚‚ $
.
‚‚$ %
Column
‚‚% +
<
‚‚+ ,
DateTime
‚‚, 4
>
‚‚4 5
(
‚‚5 6
type
‚‚6 :
:
‚‚: ;
$str
‚‚< V
,
‚‚V W
nullable
‚‚X `
:
‚‚` a
true
‚‚b f
)
‚‚f g
,
‚‚g h 
TotalPausedMinutes
ƒƒ &
=
ƒƒ' (
table
ƒƒ) .
.
ƒƒ. /
Column
ƒƒ/ 5
<
ƒƒ5 6
int
ƒƒ6 9
>
ƒƒ9 :
(
ƒƒ: ;
type
ƒƒ; ?
:
ƒƒ? @
$str
ƒƒA J
,
ƒƒJ K
nullable
ƒƒL T
:
ƒƒT U
false
ƒƒV [
)
ƒƒ[ \
,
ƒƒ\ ] 
FirstResponseMetAt
„„ &
=
„„' (
table
„„) .
.
„„. /
Column
„„/ 5
<
„„5 6
DateTime
„„6 >
>
„„> ?
(
„„? @
type
„„@ D
:
„„D E
$str
„„F `
,
„„` a
nullable
„„b j
:
„„j k
true
„„l p
)
„„p q
,
„„q r
ResolutionMetAt
…… #
=
……$ %
table
……& +
.
……+ ,
Column
……, 2
<
……2 3
DateTime
……3 ;
>
……; <
(
……< =
type
……= A
:
……A B
$str
……C ]
,
……] ^
nullable
……_ g
:
……g h
true
……i m
)
……m n
,
……n o!
FirstResponseWarned
†† '
=
††( )
table
††* /
.
††/ 0
Column
††0 6
<
††6 7
bool
††7 ;
>
††; <
(
††< =
type
††= A
:
††A B
$str
††C L
,
††L M
nullable
††N V
:
††V W
false
††X ]
)
††] ^
,
††^ _#
FirstResponseBreached
‡‡ )
=
‡‡* +
table
‡‡, 1
.
‡‡1 2
Column
‡‡2 8
<
‡‡8 9
bool
‡‡9 =
>
‡‡= >
(
‡‡> ?
type
‡‡? C
:
‡‡C D
$str
‡‡E N
,
‡‡N O
nullable
‡‡P X
:
‡‡X Y
false
‡‡Z _
)
‡‡_ `
,
‡‡` a
ResolutionWarned
 $
=
% &
table
' ,
.
, -
Column
- 3
<
3 4
bool
4 8
>
8 9
(
9 :
type
: >
:
> ?
$str
@ I
,
I J
nullable
K S
:
S T
false
U Z
)
Z [
,
[ \ 
ResolutionBreached
‰‰ &
=
‰‰' (
table
‰‰) .
.
‰‰. /
Column
‰‰/ 5
<
‰‰5 6
bool
‰‰6 :
>
‰‰: ;
(
‰‰; <
type
‰‰< @
:
‰‰@ A
$str
‰‰B K
,
‰‰K L
nullable
‰‰M U
:
‰‰U V
false
‰‰W \
)
‰‰\ ]
,
‰‰] ^
	CreatedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
false
c h
)
h i
,
i j
	CreatedBy
‹‹ 
=
‹‹ 
table
‹‹  %
.
‹‹% &
Column
‹‹& ,
<
‹‹, -
string
‹‹- 3
>
‹‹3 4
(
‹‹4 5
type
‹‹5 9
:
‹‹9 :
$str
‹‹; A
,
‹‹A B
nullable
‹‹C K
:
‹‹K L
true
‹‹M Q
)
‹‹Q R
,
‹‹R S
	UpdatedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
,
h i
	UpdatedBy
 
=
 
table
  %
.
% &
Column
& ,
<
, -
string
- 3
>
3 4
(
4 5
type
5 9
:
9 :
$str
; A
,
A B
nullable
C K
:
K L
true
M Q
)
Q R
,
R S
IsActive
 
=
 
table
 $
.
$ %
Column
% +
<
+ ,
bool
, 0
>
0 1
(
1 2
type
2 6
:
6 7
$str
8 A
,
A B
nullable
C K
:
K L
false
M R
)
R S
,
S T
	IsDeleted
 
=
 
table
  %
.
% &
Column
& ,
<
, -
bool
- 1
>
1 2
(
2 3
type
3 7
:
7 8
$str
9 B
,
B C
nullable
D L
:
L M
false
N S
)
S T
,
T U
	DeletedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
}
‘‘ 
,
‘‘ 
constraints
’’ 
:
’’ 
table
’’ "
=>
’’# %
{
““ 
table
”” 
.
”” 

PrimaryKey
”” $
(
””$ %
$str
””% 4
,
””4 5
x
””6 7
=>
””8 :
x
””; <
.
””< =
Id
””= ?
)
””? @
;
””@ A
table
•• 
.
•• 

ForeignKey
•• $
(
••$ %
name
–– 
:
–– 
$str
–– >
,
––> ?
column
—— 
:
—— 
x
——  !
=>
——" $
x
——% &
.
——& '
TicketId
——' /
,
——/ 0
principalTable
 &
:
& '
$str
( 1
,
1 2
principalColumn
™™ '
:
™™' (
$str
™™) -
,
™™- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
}
›› 
)
›› 
;
›› 
migrationBuilder
 
.
 
CreateTable
 (
(
( )
name
 
:
 
$str
 &
,
& '
columns
 
:
 
table
 
=>
 !
new
" %
{
   
Id
΅΅ 
=
΅΅ 
table
΅΅ 
.
΅΅ 
Column
΅΅ %
<
΅΅% &
int
΅΅& )
>
΅΅) *
(
΅΅* +
type
΅΅+ /
:
΅΅/ 0
$str
΅΅1 :
,
΅΅: ;
nullable
΅΅< D
:
΅΅D E
false
΅΅F K
)
΅΅K L
.
ΆΆ 

Annotation
ΆΆ #
(
ΆΆ# $
$str
ΆΆ$ D
,
ΆΆD E+
NpgsqlValueGenerationStrategy
ΆΆF c
.
ΆΆc d%
IdentityByDefaultColumn
ΆΆd {
)
ΆΆ{ |
,
ΆΆ| }
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
¤¤ 
=
¤¤ 
table
¤¤ "
.
¤¤" #
Column
¤¤# )
<
¤¤) *
int
¤¤* -
>
¤¤- .
(
¤¤. /
type
¤¤/ 3
:
¤¤3 4
$str
¤¤5 >
,
¤¤> ?
nullable
¤¤@ H
:
¤¤H I
false
¤¤J O
)
¤¤O P
,
¤¤P Q
	CreatedAt
¥¥ 
=
¥¥ 
table
¥¥  %
.
¥¥% &
Column
¥¥& ,
<
¥¥, -
DateTime
¥¥- 5
>
¥¥5 6
(
¥¥6 7
type
¥¥7 ;
:
¥¥; <
$str
¥¥= W
,
¥¥W X
nullable
¥¥Y a
:
¥¥a b
false
¥¥c h
)
¥¥h i
,
¥¥i j
	CreatedBy
¦¦ 
=
¦¦ 
table
¦¦  %
.
¦¦% &
Column
¦¦& ,
<
¦¦, -
string
¦¦- 3
>
¦¦3 4
(
¦¦4 5
type
¦¦5 9
:
¦¦9 :
$str
¦¦; A
,
¦¦A B
nullable
¦¦C K
:
¦¦K L
true
¦¦M Q
)
¦¦Q R
,
¦¦R S
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
¨¨ 
=
¨¨ 
table
¨¨  %
.
¨¨% &
Column
¨¨& ,
<
¨¨, -
string
¨¨- 3
>
¨¨3 4
(
¨¨4 5
type
¨¨5 9
:
¨¨9 :
$str
¨¨; A
,
¨¨A B
nullable
¨¨C K
:
¨¨K L
true
¨¨M Q
)
¨¨Q R
,
¨¨R S
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
ªª, -
bool
ªª- 1
>
ªª1 2
(
ªª2 3
type
ªª3 7
:
ªª7 8
$str
ªª9 B
,
ªªB C
nullable
ªªD L
:
ªªL M
false
ªªN S
)
ªªS T
,
ªªT U
	DeletedAt
«« 
=
«« 
table
««  %
.
««% &
Column
««& ,
<
««, -
DateTime
««- 5
>
««5 6
(
««6 7
type
««7 ;
:
««; <
$str
««= W
,
««W X
nullable
««Y a
:
««a b
true
««c g
)
««g h
}
¬¬ 
,
¬¬ 
constraints
­­ 
:
­­ 
table
­­ "
=>
­­# %
{
®® 
table
―― 
.
―― 

PrimaryKey
―― $
(
――$ %
$str
――% 8
,
――8 9
x
――: ;
=>
――< >
x
――? @
.
――@ A
Id
――A C
)
――C D
;
――D E
table
°° 
.
°° 

ForeignKey
°° $
(
°°$ %
name
±± 
:
±± 
$str
±± B
,
±±B C
column
²² 
:
²² 
x
²²  !
=>
²²" $
x
²²% &
.
²²& '
TicketId
²²' /
,
²²/ 0
principalTable
³³ &
:
³³& '
$str
³³( 1
,
³³1 2
principalColumn
΄΄ '
:
΄΄' (
$str
΄΄) -
,
΄΄- .
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
¶¶ 
.
¶¶ 

ForeignKey
¶¶ $
(
¶¶$ %
name
·· 
:
·· 
$str
·· >
,
··> ?
column
ΈΈ 
:
ΈΈ 
x
ΈΈ  !
=>
ΈΈ" $
x
ΈΈ% &
.
ΈΈ& '
UserId
ΈΈ' -
,
ΈΈ- .
principalTable
ΉΉ &
:
ΉΉ& '
$str
ΉΉ( /
,
ΉΉ/ 0
principalColumn
ΊΊ '
:
ΊΊ' (
$str
ΊΊ) -
,
ΊΊ- .
onDelete
»»  
:
»»  !
ReferentialAction
»»" 3
.
»»3 4
Cascade
»»4 ;
)
»»; <
;
»»< =
}
ΌΌ 
)
ΌΌ 
;
ΌΌ 
migrationBuilder
ΎΎ 
.
ΎΎ 
CreateIndex
ΎΎ (
(
ΎΎ( )
name
ΏΏ 
:
ΏΏ 
$str
ΏΏ 5
,
ΏΏ5 6
table
ΐΐ 
:
ΐΐ 
$str
ΐΐ )
,
ΐΐ) *
column
ΑΑ 
:
ΑΑ 
$str
ΑΑ #
)
ΑΑ# $
;
ΑΑ$ %
migrationBuilder
ΓΓ 
.
ΓΓ 
CreateIndex
ΓΓ (
(
ΓΓ( )
name
ΔΔ 
:
ΔΔ 
$str
ΔΔ 5
,
ΔΔ5 6
table
ΕΕ 
:
ΕΕ 
$str
ΕΕ *
,
ΕΕ* +
column
ΖΖ 
:
ΖΖ 
$str
ΖΖ "
)
ΖΖ" #
;
ΖΖ# $
migrationBuilder
ΘΘ 
.
ΘΘ 
CreateIndex
ΘΘ (
(
ΘΘ( )
name
ΙΙ 
:
ΙΙ 
$str
ΙΙ =
,
ΙΙ= >
table
ΚΚ 
:
ΚΚ 
$str
ΚΚ *
,
ΚΚ* +
column
ΛΛ 
:
ΛΛ 
$str
ΛΛ *
)
ΛΛ* +
;
ΛΛ+ ,
migrationBuilder
ΝΝ 
.
ΝΝ 
CreateIndex
ΝΝ (
(
ΝΝ( )
name
ΞΞ 
:
ΞΞ 
$str
ΞΞ 6
,
ΞΞ6 7
table
ΟΟ 
:
ΟΟ 
$str
ΟΟ '
,
ΟΟ' (
column
ΠΠ 
:
ΠΠ 
$str
ΠΠ &
)
ΠΠ& '
;
ΠΠ' (
migrationBuilder
ÒÒ 
.
ÒÒ 
CreateIndex
ÒÒ (
(
ÒÒ( )
name
ΣΣ 
:
ΣΣ 
$str
ΣΣ 2
,
ΣΣ2 3
table
ΤΤ 
:
ΤΤ 
$str
ΤΤ '
,
ΤΤ' (
column
ΥΥ 
:
ΥΥ 
$str
ΥΥ "
)
ΥΥ" #
;
ΥΥ# $
migrationBuilder
ΧΧ 
.
ΧΧ 
CreateIndex
ΧΧ (
(
ΧΧ( )
name
ΨΨ 
:
ΨΨ 
$str
ΨΨ .
,
ΨΨ. /
table
ΩΩ 
:
ΩΩ 
$str
ΩΩ #
,
ΩΩ# $
column
ΪΪ 
:
ΪΪ 
$str
ΪΪ "
)
ΪΪ" #
;
ΪΪ# $
migrationBuilder
άά 
.
άά 
CreateIndex
άά (
(
άά( )
name
έέ 
:
έέ 
$str
έέ 2
,
έέ2 3
table
ήή 
:
ήή 
$str
ήή '
,
ήή' (
column
ίί 
:
ίί 
$str
ίί "
)
ίί" #
;
ίί# $
migrationBuilder
αα 
.
αα 
CreateIndex
αα (
(
αα( )
name
ββ 
:
ββ 
$str
ββ 0
,
ββ0 1
table
γγ 
:
γγ 
$str
γγ '
,
γγ' (
column
δδ 
:
δδ 
$str
δδ  
)
δδ  !
;
δδ! "
}
εε 	
	protected
θθ 
override
θθ 
void
θθ 
Down
θθ  $
(
θθ$ %
MigrationBuilder
θθ% 5
migrationBuilder
θθ6 F
)
θθF G
{
ιι 	
migrationBuilder
κκ 
.
κκ 
	DropTable
κκ &
(
κκ& '
name
λλ 
:
λλ 
$str
λλ (
)
λλ( )
;
λλ) *
migrationBuilder
νν 
.
νν 
	DropTable
νν &
(
νν& '
name
ξξ 
:
ξξ 
$str
ξξ )
)
ξξ) *
;
ξξ* +
migrationBuilder
ππ 
.
ππ 
	DropTable
ππ &
(
ππ& '
name
ρρ 
:
ρρ 
$str
ρρ &
)
ρρ& '
;
ρρ' (
migrationBuilder
σσ 
.
σσ 
	DropTable
σσ &
(
σσ& '
name
ττ 
:
ττ 
$str
ττ "
)
ττ" #
;
ττ# $
migrationBuilder
φφ 
.
φφ 
	DropTable
φφ &
(
φφ& '
name
χχ 
:
χχ 
$str
χχ &
)
χχ& '
;
χχ' (
migrationBuilder
ωω 
.
ωω 

DropColumn
ωω '
(
ωω' (
name
ϊϊ 
:
ϊϊ 
$str
ϊϊ !
,
ϊϊ! "
table
ϋϋ 
:
ϋϋ 
$str
ϋϋ !
)
ϋϋ! "
;
ϋϋ" #
}
όό 	
}
ύύ 
}ώώ „
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
€€ 
.
€€ 
CreateTable
€€ (
(
€€( )
name
 
:
 
$str
 +
,
+ ,
columns
‚‚ 
:
‚‚ 
table
‚‚ 
=>
‚‚ !
new
‚‚" %
{
ƒƒ 
Id
„„ 
=
„„ 
table
„„ 
.
„„ 
Column
„„ %
<
„„% &
int
„„& )
>
„„) *
(
„„* +
type
„„+ /
:
„„/ 0
$str
„„1 :
,
„„: ;
nullable
„„< D
:
„„D E
false
„„F K
)
„„K L
.
…… 

Annotation
…… #
(
……# $
$str
……$ D
,
……D E+
NpgsqlValueGenerationStrategy
……F c
.
……c d%
IdentityByDefaultColumn
……d {
)
……{ |
,
……| }
Name
†† 
=
†† 
table
††  
.
††  !
Column
††! '
<
††' (
string
††( .
>
††. /
(
††/ 0
type
††0 4
:
††4 5
$str
††6 <
,
††< =
nullable
††> F
:
††F G
false
††H M
)
††M N
,
††N O
ParentId
‡‡ 
=
‡‡ 
table
‡‡ $
.
‡‡$ %
Column
‡‡% +
<
‡‡+ ,
int
‡‡, /
>
‡‡/ 0
(
‡‡0 1
type
‡‡1 5
:
‡‡5 6
$str
‡‡7 @
,
‡‡@ A
nullable
‡‡B J
:
‡‡J K
true
‡‡L P
)
‡‡P Q
,
‡‡Q R
	CreatedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
false
c h
)
h i
,
i j
	CreatedBy
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
‰‰, -
string
‰‰- 3
>
‰‰3 4
(
‰‰4 5
type
‰‰5 9
:
‰‰9 :
$str
‰‰; A
,
‰‰A B
nullable
‰‰C K
:
‰‰K L
true
‰‰M Q
)
‰‰Q R
,
‰‰R S
	UpdatedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
,
h i
	UpdatedBy
‹‹ 
=
‹‹ 
table
‹‹  %
.
‹‹% &
Column
‹‹& ,
<
‹‹, -
string
‹‹- 3
>
‹‹3 4
(
‹‹4 5
type
‹‹5 9
:
‹‹9 :
$str
‹‹; A
,
‹‹A B
nullable
‹‹C K
:
‹‹K L
true
‹‹M Q
)
‹‹Q R
,
‹‹R S
IsActive
 
=
 
table
 $
.
$ %
Column
% +
<
+ ,
bool
, 0
>
0 1
(
1 2
type
2 6
:
6 7
$str
8 A
,
A B
nullable
C K
:
K L
false
M R
)
R S
,
S T
	IsDeleted
 
=
 
table
  %
.
% &
Column
& ,
<
, -
bool
- 1
>
1 2
(
2 3
type
3 7
:
7 8
$str
9 B
,
B C
nullable
D L
:
L M
false
N S
)
S T
,
T U
	DeletedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
}
 
,
 
constraints
 
:
 
table
 "
=>
# %
{
‘‘ 
table
’’ 
.
’’ 

PrimaryKey
’’ $
(
’’$ %
$str
’’% =
,
’’= >
x
’’? @
=>
’’A C
x
’’D E
.
’’E F
Id
’’F H
)
’’H I
;
’’I J
table
““ 
.
““ 

ForeignKey
““ $
(
““$ %
name
”” 
:
”” 
$str
”” S
,
””S T
column
•• 
:
•• 
x
••  !
=>
••" $
x
••% &
.
••& '
ParentId
••' /
,
••/ 0
principalTable
–– &
:
––& '
$str
––( =
,
––= >
principalColumn
—— '
:
——' (
$str
——) -
)
——- .
;
——. /
}
 
)
 
;
 
migrationBuilder
 
.
 
CreateTable
 (
(
( )
name
›› 
:
›› 
$str
›› )
,
››) *
columns
 
:
 
table
 
=>
 !
new
" %
{
 
Id
 
=
 
table
 
.
 
Column
 %
<
% &
int
& )
>
) *
(
* +
type
+ /
:
/ 0
$str
1 :
,
: ;
nullable
< D
:
D E
false
F K
)
K L
.
 

Annotation
 #
(
# $
$str
$ D
,
D E+
NpgsqlValueGenerationStrategy
F c
.
c d%
IdentityByDefaultColumn
d {
)
{ |
,
| }
EventKey
   
=
   
table
   $
.
  $ %
Column
  % +
<
  + ,
string
  , 2
>
  2 3
(
  3 4
type
  4 8
:
  8 9
$str
  : @
,
  @ A
nullable
  B J
:
  J K
false
  L Q
)
  Q R
,
  R S

TargetRole
΅΅ 
=
΅΅  
table
΅΅! &
.
΅΅& '
Column
΅΅' -
<
΅΅- .
string
΅΅. 4
>
΅΅4 5
(
΅΅5 6
type
΅΅6 :
:
΅΅: ;
$str
΅΅< B
,
΅΅B C
nullable
΅΅D L
:
΅΅L M
false
΅΅N S
)
΅΅S T
,
΅΅T U
	CreatedAt
ΆΆ 
=
ΆΆ 
table
ΆΆ  %
.
ΆΆ% &
Column
ΆΆ& ,
<
ΆΆ, -
DateTime
ΆΆ- 5
>
ΆΆ5 6
(
ΆΆ6 7
type
ΆΆ7 ;
:
ΆΆ; <
$str
ΆΆ= W
,
ΆΆW X
nullable
ΆΆY a
:
ΆΆa b
false
ΆΆc h
)
ΆΆh i
,
ΆΆi j
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
¤¤ 
=
¤¤ 
table
¤¤  %
.
¤¤% &
Column
¤¤& ,
<
¤¤, -
DateTime
¤¤- 5
>
¤¤5 6
(
¤¤6 7
type
¤¤7 ;
:
¤¤; <
$str
¤¤= W
,
¤¤W X
nullable
¤¤Y a
:
¤¤a b
true
¤¤c g
)
¤¤g h
,
¤¤h i
	UpdatedBy
¥¥ 
=
¥¥ 
table
¥¥  %
.
¥¥% &
Column
¥¥& ,
<
¥¥, -
string
¥¥- 3
>
¥¥3 4
(
¥¥4 5
type
¥¥5 9
:
¥¥9 :
$str
¥¥; A
,
¥¥A B
nullable
¥¥C K
:
¥¥K L
true
¥¥M Q
)
¥¥Q R
,
¥¥R S
IsActive
¦¦ 
=
¦¦ 
table
¦¦ $
.
¦¦$ %
Column
¦¦% +
<
¦¦+ ,
bool
¦¦, 0
>
¦¦0 1
(
¦¦1 2
type
¦¦2 6
:
¦¦6 7
$str
¦¦8 A
,
¦¦A B
nullable
¦¦C K
:
¦¦K L
false
¦¦M R
)
¦¦R S
,
¦¦S T
	IsDeleted
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
§§, -
bool
§§- 1
>
§§1 2
(
§§2 3
type
§§3 7
:
§§7 8
$str
§§9 B
,
§§B C
nullable
§§D L
:
§§L M
false
§§N S
)
§§S T
,
§§T U
	DeletedAt
¨¨ 
=
¨¨ 
table
¨¨  %
.
¨¨% &
Column
¨¨& ,
<
¨¨, -
DateTime
¨¨- 5
>
¨¨5 6
(
¨¨6 7
type
¨¨7 ;
:
¨¨; <
$str
¨¨= W
,
¨¨W X
nullable
¨¨Y a
:
¨¨a b
true
¨¨c g
)
¨¨g h
}
©© 
,
©© 
constraints
ªª 
:
ªª 
table
ªª "
=>
ªª# %
{
«« 
table
¬¬ 
.
¬¬ 

PrimaryKey
¬¬ $
(
¬¬$ %
$str
¬¬% ;
,
¬¬; <
x
¬¬= >
=>
¬¬? A
x
¬¬B C
.
¬¬C D
Id
¬¬D F
)
¬¬F G
;
¬¬G H
}
­­ 
)
­­ 
;
­­ 
migrationBuilder
―― 
.
―― 
CreateTable
―― (
(
――( )
name
°° 
:
°° 
$str
°° %
,
°°% &
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
²² 
Id
³³ 
=
³³ 
table
³³ 
.
³³ 
Column
³³ %
<
³³% &
int
³³& )
>
³³) *
(
³³* +
type
³³+ /
:
³³/ 0
$str
³³1 :
,
³³: ;
nullable
³³< D
:
³³D E
false
³³F K
)
³³K L
.
΄΄ 

Annotation
΄΄ #
(
΄΄# $
$str
΄΄$ D
,
΄΄D E+
NpgsqlValueGenerationStrategy
΄΄F c
.
΄΄c d%
IdentityByDefaultColumn
΄΄d {
)
΄΄{ |
,
΄΄| }
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
¶¶ 
=
¶¶ 
table
¶¶ !
.
¶¶! "
Column
¶¶" (
<
¶¶( )
string
¶¶) /
>
¶¶/ 0
(
¶¶0 1
type
¶¶1 5
:
¶¶5 6
$str
¶¶7 =
,
¶¶= >
nullable
¶¶? G
:
¶¶G H
false
¶¶I N
)
¶¶N O
,
¶¶O P
Message
·· 
=
·· 
table
·· #
.
··# $
Column
··$ *
<
··* +
string
··+ 1
>
··1 2
(
··2 3
type
··3 7
:
··7 8
$str
··9 ?
,
··? @
nullable
··A I
:
··I J
false
··K P
)
··P Q
,
··Q R
IsRead
ΈΈ 
=
ΈΈ 
table
ΈΈ "
.
ΈΈ" #
Column
ΈΈ# )
<
ΈΈ) *
bool
ΈΈ* .
>
ΈΈ. /
(
ΈΈ/ 0
type
ΈΈ0 4
:
ΈΈ4 5
$str
ΈΈ6 ?
,
ΈΈ? @
nullable
ΈΈA I
:
ΈΈI J
false
ΈΈK P
)
ΈΈP Q
,
ΈΈQ R
RelatedEntityId
ΉΉ #
=
ΉΉ$ %
table
ΉΉ& +
.
ΉΉ+ ,
Column
ΉΉ, 2
<
ΉΉ2 3
int
ΉΉ3 6
>
ΉΉ6 7
(
ΉΉ7 8
type
ΉΉ8 <
:
ΉΉ< =
$str
ΉΉ> G
,
ΉΉG H
nullable
ΉΉI Q
:
ΉΉQ R
true
ΉΉS W
)
ΉΉW X
,
ΉΉX Y
RelatedEntityType
ΊΊ %
=
ΊΊ& '
table
ΊΊ( -
.
ΊΊ- .
Column
ΊΊ. 4
<
ΊΊ4 5
string
ΊΊ5 ;
>
ΊΊ; <
(
ΊΊ< =
type
ΊΊ= A
:
ΊΊA B
$str
ΊΊC I
,
ΊΊI J
nullable
ΊΊK S
:
ΊΊS T
true
ΊΊU Y
)
ΊΊY Z
,
ΊΊZ [
	CreatedAt
»» 
=
»» 
table
»»  %
.
»»% &
Column
»»& ,
<
»», -
DateTime
»»- 5
>
»»5 6
(
»»6 7
type
»»7 ;
:
»»; <
$str
»»= W
,
»»W X
nullable
»»Y a
:
»»a b
false
»»c h
)
»»h i
,
»»i j
	CreatedBy
ΌΌ 
=
ΌΌ 
table
ΌΌ  %
.
ΌΌ% &
Column
ΌΌ& ,
<
ΌΌ, -
string
ΌΌ- 3
>
ΌΌ3 4
(
ΌΌ4 5
type
ΌΌ5 9
:
ΌΌ9 :
$str
ΌΌ; A
,
ΌΌA B
nullable
ΌΌC K
:
ΌΌK L
true
ΌΌM Q
)
ΌΌQ R
,
ΌΌR S
	UpdatedAt
½½ 
=
½½ 
table
½½  %
.
½½% &
Column
½½& ,
<
½½, -
DateTime
½½- 5
>
½½5 6
(
½½6 7
type
½½7 ;
:
½½; <
$str
½½= W
,
½½W X
nullable
½½Y a
:
½½a b
true
½½c g
)
½½g h
,
½½h i
	UpdatedBy
ΎΎ 
=
ΎΎ 
table
ΎΎ  %
.
ΎΎ% &
Column
ΎΎ& ,
<
ΎΎ, -
string
ΎΎ- 3
>
ΎΎ3 4
(
ΎΎ4 5
type
ΎΎ5 9
:
ΎΎ9 :
$str
ΎΎ; A
,
ΎΎA B
nullable
ΎΎC K
:
ΎΎK L
true
ΎΎM Q
)
ΎΎQ R
,
ΎΎR S
IsActive
ΏΏ 
=
ΏΏ 
table
ΏΏ $
.
ΏΏ$ %
Column
ΏΏ% +
<
ΏΏ+ ,
bool
ΏΏ, 0
>
ΏΏ0 1
(
ΏΏ1 2
type
ΏΏ2 6
:
ΏΏ6 7
$str
ΏΏ8 A
,
ΏΏA B
nullable
ΏΏC K
:
ΏΏK L
false
ΏΏM R
)
ΏΏR S
,
ΏΏS T
	IsDeleted
ΐΐ 
=
ΐΐ 
table
ΐΐ  %
.
ΐΐ% &
Column
ΐΐ& ,
<
ΐΐ, -
bool
ΐΐ- 1
>
ΐΐ1 2
(
ΐΐ2 3
type
ΐΐ3 7
:
ΐΐ7 8
$str
ΐΐ9 B
,
ΐΐB C
nullable
ΐΐD L
:
ΐΐL M
false
ΐΐN S
)
ΐΐS T
,
ΐΐT U
	DeletedAt
ΑΑ 
=
ΑΑ 
table
ΑΑ  %
.
ΑΑ% &
Column
ΑΑ& ,
<
ΑΑ, -
DateTime
ΑΑ- 5
>
ΑΑ5 6
(
ΑΑ6 7
type
ΑΑ7 ;
:
ΑΑ; <
$str
ΑΑ= W
,
ΑΑW X
nullable
ΑΑY a
:
ΑΑa b
true
ΑΑc g
)
ΑΑg h
}
ΒΒ 
,
ΒΒ 
constraints
ΓΓ 
:
ΓΓ 
table
ΓΓ "
=>
ΓΓ# %
{
ΔΔ 
table
ΕΕ 
.
ΕΕ 

PrimaryKey
ΕΕ $
(
ΕΕ$ %
$str
ΕΕ% 7
,
ΕΕ7 8
x
ΕΕ9 :
=>
ΕΕ; =
x
ΕΕ> ?
.
ΕΕ? @
Id
ΕΕ@ B
)
ΕΕB C
;
ΕΕC D
}
ΖΖ 
)
ΖΖ 
;
ΖΖ 
migrationBuilder
ΘΘ 
.
ΘΘ 
CreateTable
ΘΘ (
(
ΘΘ( )
name
ΙΙ 
:
ΙΙ 
$str
ΙΙ #
,
ΙΙ# $
columns
ΚΚ 
:
ΚΚ 
table
ΚΚ 
=>
ΚΚ !
new
ΚΚ" %
{
ΛΛ 
Id
ΜΜ 
=
ΜΜ 
table
ΜΜ 
.
ΜΜ 
Column
ΜΜ %
<
ΜΜ% &
int
ΜΜ& )
>
ΜΜ) *
(
ΜΜ* +
type
ΜΜ+ /
:
ΜΜ/ 0
$str
ΜΜ1 :
,
ΜΜ: ;
nullable
ΜΜ< D
:
ΜΜD E
false
ΜΜF K
)
ΜΜK L
.
ΝΝ 

Annotation
ΝΝ #
(
ΝΝ# $
$str
ΝΝ$ D
,
ΝΝD E+
NpgsqlValueGenerationStrategy
ΝΝF c
.
ΝΝc d%
IdentityByDefaultColumn
ΝΝd {
)
ΝΝ{ |
,
ΝΝ| }
Name
ΞΞ 
=
ΞΞ 
table
ΞΞ  
.
ΞΞ  !
Column
ΞΞ! '
<
ΞΞ' (
string
ΞΞ( .
>
ΞΞ. /
(
ΞΞ/ 0
type
ΞΞ0 4
:
ΞΞ4 5
$str
ΞΞ6 <
,
ΞΞ< =
nullable
ΞΞ> F
:
ΞΞF G
false
ΞΞH M
)
ΞΞM N
,
ΞΞN O
Key
ΟΟ 
=
ΟΟ 
table
ΟΟ 
.
ΟΟ  
Column
ΟΟ  &
<
ΟΟ& '
string
ΟΟ' -
>
ΟΟ- .
(
ΟΟ. /
type
ΟΟ/ 3
:
ΟΟ3 4
$str
ΟΟ5 ;
,
ΟΟ; <
nullable
ΟΟ= E
:
ΟΟE F
false
ΟΟG L
)
ΟΟL M
,
ΟΟM N
	CreatedAt
ΠΠ 
=
ΠΠ 
table
ΠΠ  %
.
ΠΠ% &
Column
ΠΠ& ,
<
ΠΠ, -
DateTime
ΠΠ- 5
>
ΠΠ5 6
(
ΠΠ6 7
type
ΠΠ7 ;
:
ΠΠ; <
$str
ΠΠ= W
,
ΠΠW X
nullable
ΠΠY a
:
ΠΠa b
false
ΠΠc h
)
ΠΠh i
,
ΠΠi j
	CreatedBy
ΡΡ 
=
ΡΡ 
table
ΡΡ  %
.
ΡΡ% &
Column
ΡΡ& ,
<
ΡΡ, -
string
ΡΡ- 3
>
ΡΡ3 4
(
ΡΡ4 5
type
ΡΡ5 9
:
ΡΡ9 :
$str
ΡΡ; A
,
ΡΡA B
nullable
ΡΡC K
:
ΡΡK L
true
ΡΡM Q
)
ΡΡQ R
,
ΡΡR S
	UpdatedAt
ÒÒ 
=
ÒÒ 
table
ÒÒ  %
.
ÒÒ% &
Column
ÒÒ& ,
<
ÒÒ, -
DateTime
ÒÒ- 5
>
ÒÒ5 6
(
ÒÒ6 7
type
ÒÒ7 ;
:
ÒÒ; <
$str
ÒÒ= W
,
ÒÒW X
nullable
ÒÒY a
:
ÒÒa b
true
ÒÒc g
)
ÒÒg h
,
ÒÒh i
	UpdatedBy
ΣΣ 
=
ΣΣ 
table
ΣΣ  %
.
ΣΣ% &
Column
ΣΣ& ,
<
ΣΣ, -
string
ΣΣ- 3
>
ΣΣ3 4
(
ΣΣ4 5
type
ΣΣ5 9
:
ΣΣ9 :
$str
ΣΣ; A
,
ΣΣA B
nullable
ΣΣC K
:
ΣΣK L
true
ΣΣM Q
)
ΣΣQ R
,
ΣΣR S
IsActive
ΤΤ 
=
ΤΤ 
table
ΤΤ $
.
ΤΤ$ %
Column
ΤΤ% +
<
ΤΤ+ ,
bool
ΤΤ, 0
>
ΤΤ0 1
(
ΤΤ1 2
type
ΤΤ2 6
:
ΤΤ6 7
$str
ΤΤ8 A
,
ΤΤA B
nullable
ΤΤC K
:
ΤΤK L
false
ΤΤM R
)
ΤΤR S
,
ΤΤS T
	IsDeleted
ΥΥ 
=
ΥΥ 
table
ΥΥ  %
.
ΥΥ% &
Column
ΥΥ& ,
<
ΥΥ, -
bool
ΥΥ- 1
>
ΥΥ1 2
(
ΥΥ2 3
type
ΥΥ3 7
:
ΥΥ7 8
$str
ΥΥ9 B
,
ΥΥB C
nullable
ΥΥD L
:
ΥΥL M
false
ΥΥN S
)
ΥΥS T
,
ΥΥT U
	DeletedAt
ΦΦ 
=
ΦΦ 
table
ΦΦ  %
.
ΦΦ% &
Column
ΦΦ& ,
<
ΦΦ, -
DateTime
ΦΦ- 5
>
ΦΦ5 6
(
ΦΦ6 7
type
ΦΦ7 ;
:
ΦΦ; <
$str
ΦΦ= W
,
ΦΦW X
nullable
ΦΦY a
:
ΦΦa b
true
ΦΦc g
)
ΦΦg h
}
ΧΧ 
,
ΧΧ 
constraints
ΨΨ 
:
ΨΨ 
table
ΨΨ "
=>
ΨΨ# %
{
ΩΩ 
table
ΪΪ 
.
ΪΪ 

PrimaryKey
ΪΪ $
(
ΪΪ$ %
$str
ΪΪ% 5
,
ΪΪ5 6
x
ΪΪ7 8
=>
ΪΪ9 ;
x
ΪΪ< =
.
ΪΪ= >
Id
ΪΪ> @
)
ΪΪ@ A
;
ΪΪA B
}
ΫΫ 
)
ΫΫ 
;
ΫΫ 
migrationBuilder
έέ 
.
έέ 
CreateTable
έέ (
(
έέ( )
name
ήή 
:
ήή 
$str
ήή "
,
ήή" #
columns
ίί 
:
ίί 
table
ίί 
=>
ίί !
new
ίί" %
{
ΰΰ 
Id
αα 
=
αα 
table
αα 
.
αα 
Column
αα %
<
αα% &
int
αα& )
>
αα) *
(
αα* +
type
αα+ /
:
αα/ 0
$str
αα1 :
,
αα: ;
nullable
αα< D
:
ααD E
false
ααF K
)
ααK L
.
ββ 

Annotation
ββ #
(
ββ# $
$str
ββ$ D
,
ββD E+
NpgsqlValueGenerationStrategy
ββF c
.
ββc d%
IdentityByDefaultColumn
ββd {
)
ββ{ |
,
ββ| }
Name
γγ 
=
γγ 
table
γγ  
.
γγ  !
Column
γγ! '
<
γγ' (
string
γγ( .
>
γγ. /
(
γγ/ 0
type
γγ0 4
:
γγ4 5
$str
γγ6 <
,
γγ< =
nullable
γγ> F
:
γγF G
false
γγH M
)
γγM N
,
γγN O
	ProjectId
δδ 
=
δδ 
table
δδ  %
.
δδ% &
Column
δδ& ,
<
δδ, -
int
δδ- 0
>
δδ0 1
(
δδ1 2
type
δδ2 6
:
δδ6 7
$str
δδ8 A
,
δδA B
nullable
δδC K
:
δδK L
false
δδM R
)
δδR S
,
δδS T
Weight
εε 
=
εε 
table
εε "
.
εε" #
Column
εε# )
<
εε) *
int
εε* -
>
εε- .
(
εε. /
type
εε/ 3
:
εε3 4
$str
εε5 >
,
εε> ?
nullable
εε@ H
:
εεH I
false
εεJ O
)
εεO P
,
εεP Q
ColorHex
ζζ 
=
ζζ 
table
ζζ $
.
ζζ$ %
Column
ζζ% +
<
ζζ+ ,
string
ζζ, 2
>
ζζ2 3
(
ζζ3 4
type
ζζ4 8
:
ζζ8 9
$str
ζζ: @
,
ζζ@ A
nullable
ζζB J
:
ζζJ K
true
ζζL P
)
ζζP Q
,
ζζQ R
	SortOrder
ηη 
=
ηη 
table
ηη  %
.
ηη% &
Column
ηη& ,
<
ηη, -
int
ηη- 0
>
ηη0 1
(
ηη1 2
type
ηη2 6
:
ηη6 7
$str
ηη8 A
,
ηηA B
nullable
ηηC K
:
ηηK L
false
ηηM R
)
ηηR S
,
ηηS T
SeverityLevel
θθ !
=
θθ" #
table
θθ$ )
.
θθ) *
Column
θθ* 0
<
θθ0 1
int
θθ1 4
>
θθ4 5
(
θθ5 6
type
θθ6 :
:
θθ: ;
$str
θθ< E
,
θθE F
nullable
θθG O
:
θθO P
false
θθQ V
)
θθV W
,
θθW X
	CreatedAt
ιι 
=
ιι 
table
ιι  %
.
ιι% &
Column
ιι& ,
<
ιι, -
DateTime
ιι- 5
>
ιι5 6
(
ιι6 7
type
ιι7 ;
:
ιι; <
$str
ιι= W
,
ιιW X
nullable
ιιY a
:
ιιa b
false
ιιc h
)
ιιh i
,
ιιi j
	CreatedBy
κκ 
=
κκ 
table
κκ  %
.
κκ% &
Column
κκ& ,
<
κκ, -
string
κκ- 3
>
κκ3 4
(
κκ4 5
type
κκ5 9
:
κκ9 :
$str
κκ; A
,
κκA B
nullable
κκC K
:
κκK L
true
κκM Q
)
κκQ R
,
κκR S
	UpdatedAt
λλ 
=
λλ 
table
λλ  %
.
λλ% &
Column
λλ& ,
<
λλ, -
DateTime
λλ- 5
>
λλ5 6
(
λλ6 7
type
λλ7 ;
:
λλ; <
$str
λλ= W
,
λλW X
nullable
λλY a
:
λλa b
true
λλc g
)
λλg h
,
λλh i
	UpdatedBy
μμ 
=
μμ 
table
μμ  %
.
μμ% &
Column
μμ& ,
<
μμ, -
string
μμ- 3
>
μμ3 4
(
μμ4 5
type
μμ5 9
:
μμ9 :
$str
μμ; A
,
μμA B
nullable
μμC K
:
μμK L
true
μμM Q
)
μμQ R
,
μμR S
IsActive
νν 
=
νν 
table
νν $
.
νν$ %
Column
νν% +
<
νν+ ,
bool
νν, 0
>
νν0 1
(
νν1 2
type
νν2 6
:
νν6 7
$str
νν8 A
,
ννA B
nullable
ννC K
:
ννK L
false
ννM R
)
ννR S
,
ννS T
	IsDeleted
ξξ 
=
ξξ 
table
ξξ  %
.
ξξ% &
Column
ξξ& ,
<
ξξ, -
bool
ξξ- 1
>
ξξ1 2
(
ξξ2 3
type
ξξ3 7
:
ξξ7 8
$str
ξξ9 B
,
ξξB C
nullable
ξξD L
:
ξξL M
false
ξξN S
)
ξξS T
,
ξξT U
	DeletedAt
οο 
=
οο 
table
οο  %
.
οο% &
Column
οο& ,
<
οο, -
DateTime
οο- 5
>
οο5 6
(
οο6 7
type
οο7 ;
:
οο; <
$str
οο= W
,
οοW X
nullable
οοY a
:
οοa b
true
οοc g
)
οοg h
}
ππ 
,
ππ 
constraints
ρρ 
:
ρρ 
table
ρρ "
=>
ρρ# %
{
ςς 
table
σσ 
.
σσ 

PrimaryKey
σσ $
(
σσ$ %
$str
σσ% 4
,
σσ4 5
x
σσ6 7
=>
σσ8 :
x
σσ; <
.
σσ< =
Id
σσ= ?
)
σσ? @
;
σσ@ A
}
ττ 
)
ττ 
;
ττ 
migrationBuilder
φφ 
.
φφ 
CreateTable
φφ (
(
φφ( )
name
χχ 
:
χχ 
$str
χχ  
,
χχ  !
columns
ψψ 
:
ψψ 
table
ψψ 
=>
ψψ !
new
ψψ" %
{
ωω 
Id
ϊϊ 
=
ϊϊ 
table
ϊϊ 
.
ϊϊ 
Column
ϊϊ %
<
ϊϊ% &
int
ϊϊ& )
>
ϊϊ) *
(
ϊϊ* +
type
ϊϊ+ /
:
ϊϊ/ 0
$str
ϊϊ1 :
,
ϊϊ: ;
nullable
ϊϊ< D
:
ϊϊD E
false
ϊϊF K
)
ϊϊK L
.
ϋϋ 

Annotation
ϋϋ #
(
ϋϋ# $
$str
ϋϋ$ D
,
ϋϋD E+
NpgsqlValueGenerationStrategy
ϋϋF c
.
ϋϋc d%
IdentityByDefaultColumn
ϋϋd {
)
ϋϋ{ |
,
ϋϋ| }
Name
όό 
=
όό 
table
όό  
.
όό  !
Column
όό! '
<
όό' (
string
όό( .
>
όό. /
(
όό/ 0
type
όό0 4
:
όό4 5
$str
όό6 <
,
όό< =
nullable
όό> F
:
όόF G
false
όόH M
)
όόM N
,
όόN O

ProjectKey
ύύ 
=
ύύ  
table
ύύ! &
.
ύύ& '
Column
ύύ' -
<
ύύ- .
string
ύύ. 4
>
ύύ4 5
(
ύύ5 6
type
ύύ6 :
:
ύύ: ;
$str
ύύ< B
,
ύύB C
nullable
ύύD L
:
ύύL M
false
ύύN S
)
ύύS T
,
ύύT U
Description
ώώ 
=
ώώ  !
table
ώώ" '
.
ώώ' (
Column
ώώ( .
<
ώώ. /
string
ώώ/ 5
>
ώώ5 6
(
ώώ6 7
type
ώώ7 ;
:
ώώ; <
$str
ώώ= C
,
ώώC D
nullable
ώώE M
:
ώώM N
true
ώώO S
)
ώώS T
,
ώώT U#
CurrentTicketSequence
ÿÿ )
=
ÿÿ* +
table
ÿÿ, 1
.
ÿÿ1 2
Column
ÿÿ2 8
<
ÿÿ8 9
int
ÿÿ9 <
>
ÿÿ< =
(
ÿÿ= >
type
ÿÿ> B
:
ÿÿB C
$str
ÿÿD M
,
ÿÿM N
nullable
ÿÿO W
:
ÿÿW X
false
ÿÿY ^
)
ÿÿ^ _
,
ÿÿ_ `
	CreatedAt
€€ 
=
€€ 
table
€€  %
.
€€% &
Column
€€& ,
<
€€, -
DateTime
€€- 5
>
€€5 6
(
€€6 7
type
€€7 ;
:
€€; <
$str
€€= W
,
€€W X
nullable
€€Y a
:
€€a b
false
€€c h
)
€€h i
,
€€i j
	CreatedBy
 
=
 
table
  %
.
% &
Column
& ,
<
, -
string
- 3
>
3 4
(
4 5
type
5 9
:
9 :
$str
; A
,
A B
nullable
C K
:
K L
true
M Q
)
Q R
,
R S
	UpdatedAt
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
,
‚‚h i
	UpdatedBy
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
ƒƒR S
IsActive
„„ 
=
„„ 
table
„„ $
.
„„$ %
Column
„„% +
<
„„+ ,
bool
„„, 0
>
„„0 1
(
„„1 2
type
„„2 6
:
„„6 7
$str
„„8 A
,
„„A B
nullable
„„C K
:
„„K L
false
„„M R
)
„„R S
,
„„S T
	IsDeleted
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
……, -
bool
……- 1
>
……1 2
(
……2 3
type
……3 7
:
……7 8
$str
……9 B
,
……B C
nullable
……D L
:
……L M
false
……N S
)
……S T
,
……T U
	DeletedAt
†† 
=
†† 
table
††  %
.
††% &
Column
††& ,
<
††, -
DateTime
††- 5
>
††5 6
(
††6 7
type
††7 ;
:
††; <
$str
††= W
,
††W X
nullable
††Y a
:
††a b
true
††c g
)
††g h
}
‡‡ 
,
‡‡ 
constraints
 
:
 
table
 "
=>
# %
{
‰‰ 
table
 
.
 

PrimaryKey
 $
(
$ %
$str
% 2
,
2 3
x
4 5
=>
6 8
x
9 :
.
: ;
Id
; =
)
= >
;
> ?
}
‹‹ 
)
‹‹ 
;
‹‹ 
migrationBuilder
 
.
 
CreateTable
 (
(
( )
name
 
:
 
$str
 
,
 
columns
 
:
 
table
 
=>
 !
new
" %
{
 
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
““ 
=
““ 
table
““  
.
““  !
Column
““! '
<
““' (
string
““( .
>
““. /
(
““/ 0
type
““0 4
:
““4 5
$str
““6 <
,
““< =
nullable
““> F
:
““F G
false
““H M
)
““M N
,
““N O
	CreatedAt
”” 
=
”” 
table
””  %
.
””% &
Column
””& ,
<
””, -
DateTime
””- 5
>
””5 6
(
””6 7
type
””7 ;
:
””; <
$str
””= W
,
””W X
nullable
””Y a
:
””a b
false
””c h
)
””h i
,
””i j
	CreatedBy
•• 
=
•• 
table
••  %
.
••% &
Column
••& ,
<
••, -
string
••- 3
>
••3 4
(
••4 5
type
••5 9
:
••9 :
$str
••; A
,
••A B
nullable
••C K
:
••K L
true
••M Q
)
••Q R
,
••R S
	UpdatedAt
–– 
=
–– 
table
––  %
.
––% &
Column
––& ,
<
––, -
DateTime
––- 5
>
––5 6
(
––6 7
type
––7 ;
:
––; <
$str
––= W
,
––W X
nullable
––Y a
:
––a b
true
––c g
)
––g h
,
––h i
	UpdatedBy
—— 
=
—— 
table
——  %
.
——% &
Column
——& ,
<
——, -
string
——- 3
>
——3 4
(
——4 5
type
——5 9
:
——9 :
$str
——; A
,
——A B
nullable
——C K
:
——K L
true
——M Q
)
——Q R
,
——R S
IsActive
 
=
 
table
 $
.
$ %
Column
% +
<
+ ,
bool
, 0
>
0 1
(
1 2
type
2 6
:
6 7
$str
8 A
,
A B
nullable
C K
:
K L
false
M R
)
R S
,
S T
	IsDeleted
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
™™, -
bool
™™- 1
>
™™1 2
(
™™2 3
type
™™3 7
:
™™7 8
$str
™™9 B
,
™™B C
nullable
™™D L
:
™™L M
false
™™N S
)
™™S T
,
™™T U
	DeletedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
}
›› 
,
›› 
constraints
 
:
 
table
 "
=>
# %
{
 
table
 
.
 

PrimaryKey
 $
(
$ %
$str
% /
,
/ 0
x
1 2
=>
3 5
x
6 7
.
7 8
Id
8 :
)
: ;
;
; <
}
 
)
 
;
 
migrationBuilder
΅΅ 
.
΅΅ 
CreateTable
΅΅ (
(
΅΅( )
name
ΆΆ 
:
ΆΆ 
$str
ΆΆ #
,
ΆΆ# $
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
¤¤ 
Id
¥¥ 
=
¥¥ 
table
¥¥ 
.
¥¥ 
Column
¥¥ %
<
¥¥% &
int
¥¥& )
>
¥¥) *
(
¥¥* +
type
¥¥+ /
:
¥¥/ 0
$str
¥¥1 :
,
¥¥: ;
nullable
¥¥< D
:
¥¥D E
false
¥¥F K
)
¥¥K L
.
¦¦ 

Annotation
¦¦ #
(
¦¦# $
$str
¦¦$ D
,
¦¦D E+
NpgsqlValueGenerationStrategy
¦¦F c
.
¦¦c d%
IdentityByDefaultColumn
¦¦d {
)
¦¦{ |
,
¦¦| }
Name
§§ 
=
§§ 
table
§§  
.
§§  !
Column
§§! '
<
§§' (
string
§§( .
>
§§. /
(
§§/ 0
type
§§0 4
:
§§4 5
$str
§§6 <
,
§§< =
nullable
§§> F
:
§§F G
false
§§H M
)
§§M N
,
§§N O
Description
¨¨ 
=
¨¨  !
table
¨¨" '
.
¨¨' (
Column
¨¨( .
<
¨¨. /
string
¨¨/ 5
>
¨¨5 6
(
¨¨6 7
type
¨¨7 ;
:
¨¨; <
$str
¨¨= C
,
¨¨C D
nullable
¨¨E M
:
¨¨M N
true
¨¨O S
)
¨¨S T
,
¨¨T U
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
ªª 
=
ªª 
table
ªª  %
.
ªª% &
Column
ªª& ,
<
ªª, -
DateTime
ªª- 5
>
ªª5 6
(
ªª6 7
type
ªª7 ;
:
ªª; <
$str
ªª= W
,
ªªW X
nullable
ªªY a
:
ªªa b
false
ªªc h
)
ªªh i
,
ªªi j
	CreatedBy
«« 
=
«« 
table
««  %
.
««% &
Column
««& ,
<
««, -
string
««- 3
>
««3 4
(
««4 5
type
««5 9
:
««9 :
$str
««; A
,
««A B
nullable
««C K
:
««K L
true
««M Q
)
««Q R
,
««R S
	UpdatedAt
¬¬ 
=
¬¬ 
table
¬¬  %
.
¬¬% &
Column
¬¬& ,
<
¬¬, -
DateTime
¬¬- 5
>
¬¬5 6
(
¬¬6 7
type
¬¬7 ;
:
¬¬; <
$str
¬¬= W
,
¬¬W X
nullable
¬¬Y a
:
¬¬a b
true
¬¬c g
)
¬¬g h
,
¬¬h i
	UpdatedBy
­­ 
=
­­ 
table
­­  %
.
­­% &
Column
­­& ,
<
­­, -
string
­­- 3
>
­­3 4
(
­­4 5
type
­­5 9
:
­­9 :
$str
­­; A
,
­­A B
nullable
­­C K
:
­­K L
true
­­M Q
)
­­Q R
,
­­R S
IsActive
®® 
=
®® 
table
®® $
.
®®$ %
Column
®®% +
<
®®+ ,
bool
®®, 0
>
®®0 1
(
®®1 2
type
®®2 6
:
®®6 7
$str
®®8 A
,
®®A B
nullable
®®C K
:
®®K L
false
®®M R
)
®®R S
,
®®S T
	IsDeleted
―― 
=
―― 
table
――  %
.
――% &
Column
――& ,
<
――, -
bool
――- 1
>
――1 2
(
――2 3
type
――3 7
:
――7 8
$str
――9 B
,
――B C
nullable
――D L
:
――L M
false
――N S
)
――S T
,
――T U
	DeletedAt
°° 
=
°° 
table
°°  %
.
°°% &
Column
°°& ,
<
°°, -
DateTime
°°- 5
>
°°5 6
(
°°6 7
type
°°7 ;
:
°°; <
$str
°°= W
,
°°W X
nullable
°°Y a
:
°°a b
true
°°c g
)
°°g h
}
±± 
,
±± 
constraints
²² 
:
²² 
table
²² "
=>
²²# %
{
³³ 
table
΄΄ 
.
΄΄ 

PrimaryKey
΄΄ $
(
΄΄$ %
$str
΄΄% 5
,
΄΄5 6
x
΄΄7 8
=>
΄΄9 ;
x
΄΄< =
.
΄΄= >
Id
΄΄> @
)
΄΄@ A
;
΄΄A B
}
µµ 
)
µµ 
;
µµ 
migrationBuilder
·· 
.
·· 
CreateTable
·· (
(
··( )
name
ΈΈ 
:
ΈΈ 
$str
ΈΈ  
,
ΈΈ  !
columns
ΉΉ 
:
ΉΉ 
table
ΉΉ 
=>
ΉΉ !
new
ΉΉ" %
{
ΊΊ 
Id
»» 
=
»» 
table
»» 
.
»» 
Column
»» %
<
»»% &
int
»»& )
>
»») *
(
»»* +
type
»»+ /
:
»»/ 0
$str
»»1 :
,
»»: ;
nullable
»»< D
:
»»D E
false
»»F K
)
»»K L
.
ΌΌ 

Annotation
ΌΌ #
(
ΌΌ# $
$str
ΌΌ$ D
,
ΌΌD E+
NpgsqlValueGenerationStrategy
ΌΌF c
.
ΌΌc d%
IdentityByDefaultColumn
ΌΌd {
)
ΌΌ{ |
,
ΌΌ| }
Name
½½ 
=
½½ 
table
½½  
.
½½  !
Column
½½! '
<
½½' (
string
½½( .
>
½½. /
(
½½/ 0
type
½½0 4
:
½½4 5
$str
½½6 <
,
½½< =
nullable
½½> F
:
½½F G
false
½½H M
)
½½M N
,
½½N O
	ProjectId
ΎΎ 
=
ΎΎ 
table
ΎΎ  %
.
ΎΎ% &
Column
ΎΎ& ,
<
ΎΎ, -
int
ΎΎ- 0
>
ΎΎ0 1
(
ΎΎ1 2
type
ΎΎ2 6
:
ΎΎ6 7
$str
ΎΎ8 A
,
ΎΎA B
nullable
ΎΎC K
:
ΎΎK L
false
ΎΎM R
)
ΎΎR S
,
ΎΎS T
IsClosedStatus
ΏΏ "
=
ΏΏ# $
table
ΏΏ% *
.
ΏΏ* +
Column
ΏΏ+ 1
<
ΏΏ1 2
bool
ΏΏ2 6
>
ΏΏ6 7
(
ΏΏ7 8
type
ΏΏ8 <
:
ΏΏ< =
$str
ΏΏ> G
,
ΏΏG H
nullable
ΏΏI Q
:
ΏΏQ R
false
ΏΏS X
)
ΏΏX Y
,
ΏΏY Z
ColorHex
ΐΐ 
=
ΐΐ 
table
ΐΐ $
.
ΐΐ$ %
Column
ΐΐ% +
<
ΐΐ+ ,
string
ΐΐ, 2
>
ΐΐ2 3
(
ΐΐ3 4
type
ΐΐ4 8
:
ΐΐ8 9
$str
ΐΐ: @
,
ΐΐ@ A
nullable
ΐΐB J
:
ΐΐJ K
true
ΐΐL P
)
ΐΐP Q
,
ΐΐQ R
	SortOrder
ΑΑ 
=
ΑΑ 
table
ΑΑ  %
.
ΑΑ% &
Column
ΑΑ& ,
<
ΑΑ, -
int
ΑΑ- 0
>
ΑΑ0 1
(
ΑΑ1 2
type
ΑΑ2 6
:
ΑΑ6 7
$str
ΑΑ8 A
,
ΑΑA B
nullable
ΑΑC K
:
ΑΑK L
false
ΑΑM R
)
ΑΑR S
,
ΑΑS T
IsSystemDefault
ΒΒ #
=
ΒΒ$ %
table
ΒΒ& +
.
ΒΒ+ ,
Column
ΒΒ, 2
<
ΒΒ2 3
bool
ΒΒ3 7
>
ΒΒ7 8
(
ΒΒ8 9
type
ΒΒ9 =
:
ΒΒ= >
$str
ΒΒ? H
,
ΒΒH I
nullable
ΒΒJ R
:
ΒΒR S
false
ΒΒT Y
)
ΒΒY Z
,
ΒΒZ [
	CreatedAt
ΓΓ 
=
ΓΓ 
table
ΓΓ  %
.
ΓΓ% &
Column
ΓΓ& ,
<
ΓΓ, -
DateTime
ΓΓ- 5
>
ΓΓ5 6
(
ΓΓ6 7
type
ΓΓ7 ;
:
ΓΓ; <
$str
ΓΓ= W
,
ΓΓW X
nullable
ΓΓY a
:
ΓΓa b
false
ΓΓc h
)
ΓΓh i
,
ΓΓi j
	CreatedBy
ΔΔ 
=
ΔΔ 
table
ΔΔ  %
.
ΔΔ% &
Column
ΔΔ& ,
<
ΔΔ, -
string
ΔΔ- 3
>
ΔΔ3 4
(
ΔΔ4 5
type
ΔΔ5 9
:
ΔΔ9 :
$str
ΔΔ; A
,
ΔΔA B
nullable
ΔΔC K
:
ΔΔK L
true
ΔΔM Q
)
ΔΔQ R
,
ΔΔR S
	UpdatedAt
ΕΕ 
=
ΕΕ 
table
ΕΕ  %
.
ΕΕ% &
Column
ΕΕ& ,
<
ΕΕ, -
DateTime
ΕΕ- 5
>
ΕΕ5 6
(
ΕΕ6 7
type
ΕΕ7 ;
:
ΕΕ; <
$str
ΕΕ= W
,
ΕΕW X
nullable
ΕΕY a
:
ΕΕa b
true
ΕΕc g
)
ΕΕg h
,
ΕΕh i
	UpdatedBy
ΖΖ 
=
ΖΖ 
table
ΖΖ  %
.
ΖΖ% &
Column
ΖΖ& ,
<
ΖΖ, -
string
ΖΖ- 3
>
ΖΖ3 4
(
ΖΖ4 5
type
ΖΖ5 9
:
ΖΖ9 :
$str
ΖΖ; A
,
ΖΖA B
nullable
ΖΖC K
:
ΖΖK L
true
ΖΖM Q
)
ΖΖQ R
,
ΖΖR S
IsActive
ΗΗ 
=
ΗΗ 
table
ΗΗ $
.
ΗΗ$ %
Column
ΗΗ% +
<
ΗΗ+ ,
bool
ΗΗ, 0
>
ΗΗ0 1
(
ΗΗ1 2
type
ΗΗ2 6
:
ΗΗ6 7
$str
ΗΗ8 A
,
ΗΗA B
nullable
ΗΗC K
:
ΗΗK L
false
ΗΗM R
)
ΗΗR S
,
ΗΗS T
	IsDeleted
ΘΘ 
=
ΘΘ 
table
ΘΘ  %
.
ΘΘ% &
Column
ΘΘ& ,
<
ΘΘ, -
bool
ΘΘ- 1
>
ΘΘ1 2
(
ΘΘ2 3
type
ΘΘ3 7
:
ΘΘ7 8
$str
ΘΘ9 B
,
ΘΘB C
nullable
ΘΘD L
:
ΘΘL M
false
ΘΘN S
)
ΘΘS T
,
ΘΘT U
	DeletedAt
ΙΙ 
=
ΙΙ 
table
ΙΙ  %
.
ΙΙ% &
Column
ΙΙ& ,
<
ΙΙ, -
DateTime
ΙΙ- 5
>
ΙΙ5 6
(
ΙΙ6 7
type
ΙΙ7 ;
:
ΙΙ; <
$str
ΙΙ= W
,
ΙΙW X
nullable
ΙΙY a
:
ΙΙa b
true
ΙΙc g
)
ΙΙg h
}
ΚΚ 
,
ΚΚ 
constraints
ΛΛ 
:
ΛΛ 
table
ΛΛ "
=>
ΛΛ# %
{
ΜΜ 
table
ΝΝ 
.
ΝΝ 

PrimaryKey
ΝΝ $
(
ΝΝ$ %
$str
ΝΝ% 2
,
ΝΝ2 3
x
ΝΝ4 5
=>
ΝΝ6 8
x
ΝΝ9 :
.
ΝΝ: ;
Id
ΝΝ; =
)
ΝΝ= >
;
ΝΝ> ?
}
ΞΞ 
)
ΞΞ 
;
ΞΞ 
migrationBuilder
ΠΠ 
.
ΠΠ 
CreateTable
ΠΠ (
(
ΠΠ( )
name
ΡΡ 
:
ΡΡ 
$str
ΡΡ #
,
ΡΡ# $
columns
ÒÒ 
:
ÒÒ 
table
ÒÒ 
=>
ÒÒ !
new
ÒÒ" %
{
ΣΣ 
Id
ΤΤ 
=
ΤΤ 
table
ΤΤ 
.
ΤΤ 
Column
ΤΤ %
<
ΤΤ% &
int
ΤΤ& )
>
ΤΤ) *
(
ΤΤ* +
type
ΤΤ+ /
:
ΤΤ/ 0
$str
ΤΤ1 :
,
ΤΤ: ;
nullable
ΤΤ< D
:
ΤΤD E
false
ΤΤF K
)
ΤΤK L
.
ΥΥ 

Annotation
ΥΥ #
(
ΥΥ# $
$str
ΥΥ$ D
,
ΥΥD E+
NpgsqlValueGenerationStrategy
ΥΥF c
.
ΥΥc d%
IdentityByDefaultColumn
ΥΥd {
)
ΥΥ{ |
,
ΥΥ| }
Name
ΦΦ 
=
ΦΦ 
table
ΦΦ  
.
ΦΦ  !
Column
ΦΦ! '
<
ΦΦ' (
string
ΦΦ( .
>
ΦΦ. /
(
ΦΦ/ 0
type
ΦΦ0 4
:
ΦΦ4 5
$str
ΦΦ6 <
,
ΦΦ< =
nullable
ΦΦ> F
:
ΦΦF G
false
ΦΦH M
)
ΦΦM N
,
ΦΦN O
	ProjectId
ΧΧ 
=
ΧΧ 
table
ΧΧ  %
.
ΧΧ% &
Column
ΧΧ& ,
<
ΧΧ, -
int
ΧΧ- 0
>
ΧΧ0 1
(
ΧΧ1 2
type
ΧΧ2 6
:
ΧΧ6 7
$str
ΧΧ8 A
,
ΧΧA B
nullable
ΧΧC K
:
ΧΧK L
false
ΧΧM R
)
ΧΧR S
,
ΧΧS T
Description
ΨΨ 
=
ΨΨ  !
table
ΨΨ" '
.
ΨΨ' (
Column
ΨΨ( .
<
ΨΨ. /
string
ΨΨ/ 5
>
ΨΨ5 6
(
ΨΨ6 7
type
ΨΨ7 ;
:
ΨΨ; <
$str
ΨΨ= C
,
ΨΨC D
nullable
ΨΨE M
:
ΨΨM N
true
ΨΨO S
)
ΨΨS T
,
ΨΨT U
Icon
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
ΩΩF G
true
ΩΩH L
)
ΩΩL M
,
ΩΩM N
ColorHex
ΪΪ 
=
ΪΪ 
table
ΪΪ $
.
ΪΪ$ %
Column
ΪΪ% +
<
ΪΪ+ ,
string
ΪΪ, 2
>
ΪΪ2 3
(
ΪΪ3 4
type
ΪΪ4 8
:
ΪΪ8 9
$str
ΪΪ: @
,
ΪΪ@ A
nullable
ΪΪB J
:
ΪΪJ K
true
ΪΪL P
)
ΪΪP Q
,
ΪΪQ R
IsSystemDefault
ΫΫ #
=
ΫΫ$ %
table
ΫΫ& +
.
ΫΫ+ ,
Column
ΫΫ, 2
<
ΫΫ2 3
bool
ΫΫ3 7
>
ΫΫ7 8
(
ΫΫ8 9
type
ΫΫ9 =
:
ΫΫ= >
$str
ΫΫ? H
,
ΫΫH I
nullable
ΫΫJ R
:
ΫΫR S
false
ΫΫT Y
)
ΫΫY Z
,
ΫΫZ [
	CreatedAt
άά 
=
άά 
table
άά  %
.
άά% &
Column
άά& ,
<
άά, -
DateTime
άά- 5
>
άά5 6
(
άά6 7
type
άά7 ;
:
άά; <
$str
άά= W
,
άάW X
nullable
άάY a
:
άάa b
false
άάc h
)
άάh i
,
άάi j
	CreatedBy
έέ 
=
έέ 
table
έέ  %
.
έέ% &
Column
έέ& ,
<
έέ, -
string
έέ- 3
>
έέ3 4
(
έέ4 5
type
έέ5 9
:
έέ9 :
$str
έέ; A
,
έέA B
nullable
έέC K
:
έέK L
true
έέM Q
)
έέQ R
,
έέR S
	UpdatedAt
ήή 
=
ήή 
table
ήή  %
.
ήή% &
Column
ήή& ,
<
ήή, -
DateTime
ήή- 5
>
ήή5 6
(
ήή6 7
type
ήή7 ;
:
ήή; <
$str
ήή= W
,
ήήW X
nullable
ήήY a
:
ήήa b
true
ήήc g
)
ήήg h
,
ήήh i
	UpdatedBy
ίί 
=
ίί 
table
ίί  %
.
ίί% &
Column
ίί& ,
<
ίί, -
string
ίί- 3
>
ίί3 4
(
ίί4 5
type
ίί5 9
:
ίί9 :
$str
ίί; A
,
ίίA B
nullable
ίίC K
:
ίίK L
true
ίίM Q
)
ίίQ R
,
ίίR S
IsActive
ΰΰ 
=
ΰΰ 
table
ΰΰ $
.
ΰΰ$ %
Column
ΰΰ% +
<
ΰΰ+ ,
bool
ΰΰ, 0
>
ΰΰ0 1
(
ΰΰ1 2
type
ΰΰ2 6
:
ΰΰ6 7
$str
ΰΰ8 A
,
ΰΰA B
nullable
ΰΰC K
:
ΰΰK L
false
ΰΰM R
)
ΰΰR S
,
ΰΰS T
	IsDeleted
αα 
=
αα 
table
αα  %
.
αα% &
Column
αα& ,
<
αα, -
bool
αα- 1
>
αα1 2
(
αα2 3
type
αα3 7
:
αα7 8
$str
αα9 B
,
ααB C
nullable
ααD L
:
ααL M
false
ααN S
)
ααS T
,
ααT U
	DeletedAt
ββ 
=
ββ 
table
ββ  %
.
ββ% &
Column
ββ& ,
<
ββ, -
DateTime
ββ- 5
>
ββ5 6
(
ββ6 7
type
ββ7 ;
:
ββ; <
$str
ββ= W
,
ββW X
nullable
ββY a
:
ββa b
true
ββc g
)
ββg h
}
γγ 
,
γγ 
constraints
δδ 
:
δδ 
table
δδ "
=>
δδ# %
{
εε 
table
ζζ 
.
ζζ 

PrimaryKey
ζζ $
(
ζζ$ %
$str
ζζ% 5
,
ζζ5 6
x
ζζ7 8
=>
ζζ9 ;
x
ζζ< =
.
ζζ= >
Id
ζζ> @
)
ζζ@ A
;
ζζA B
}
ηη 
)
ηη 
;
ηη 
migrationBuilder
ιι 
.
ιι 
CreateTable
ιι (
(
ιι( )
name
κκ 
:
κκ 
$str
κκ !
,
κκ! "
columns
λλ 
:
λλ 
table
λλ 
=>
λλ !
new
λλ" %
{
μμ 
Id
νν 
=
νν 
table
νν 
.
νν 
Column
νν %
<
νν% &
int
νν& )
>
νν) *
(
νν* +
type
νν+ /
:
νν/ 0
$str
νν1 :
,
νν: ;
nullable
νν< D
:
ννD E
false
ννF K
)
ννK L
.
ξξ 

Annotation
ξξ #
(
ξξ# $
$str
ξξ$ D
,
ξξD E+
NpgsqlValueGenerationStrategy
ξξF c
.
ξξc d%
IdentityByDefaultColumn
ξξd {
)
ξξ{ |
,
ξξ| }
Name
οο 
=
οο 
table
οο  
.
οο  !
Column
οο! '
<
οο' (
string
οο( .
>
οο. /
(
οο/ 0
type
οο0 4
:
οο4 5
$str
οο6 <
,
οο< =
nullable
οο> F
:
οοF G
false
οοH M
)
οοM N
,
οοN O
Description
ππ 
=
ππ  !
table
ππ" '
.
ππ' (
Column
ππ( .
<
ππ. /
string
ππ/ 5
>
ππ5 6
(
ππ6 7
type
ππ7 ;
:
ππ; <
$str
ππ= C
,
ππC D
nullable
ππE M
:
ππM N
true
ππO S
)
ππS T
,
ππT U
	ProjectId
ρρ 
=
ρρ 
table
ρρ  %
.
ρρ% &
Column
ρρ& ,
<
ρρ, -
int
ρρ- 0
>
ρρ0 1
(
ρρ1 2
type
ρρ2 6
:
ρρ6 7
$str
ρρ8 A
,
ρρA B
nullable
ρρC K
:
ρρK L
true
ρρM Q
)
ρρQ R
,
ρρR S
	CreatedAt
ςς 
=
ςς 
table
ςς  %
.
ςς% &
Column
ςς& ,
<
ςς, -
DateTime
ςς- 5
>
ςς5 6
(
ςς6 7
type
ςς7 ;
:
ςς; <
$str
ςς= W
,
ςςW X
nullable
ςςY a
:
ςςa b
false
ςςc h
)
ςςh i
,
ςςi j
	CreatedBy
σσ 
=
σσ 
table
σσ  %
.
σσ% &
Column
σσ& ,
<
σσ, -
string
σσ- 3
>
σσ3 4
(
σσ4 5
type
σσ5 9
:
σσ9 :
$str
σσ; A
,
σσA B
nullable
σσC K
:
σσK L
true
σσM Q
)
σσQ R
,
σσR S
	UpdatedAt
ττ 
=
ττ 
table
ττ  %
.
ττ% &
Column
ττ& ,
<
ττ, -
DateTime
ττ- 5
>
ττ5 6
(
ττ6 7
type
ττ7 ;
:
ττ; <
$str
ττ= W
,
ττW X
nullable
ττY a
:
ττa b
true
ττc g
)
ττg h
,
ττh i
	UpdatedBy
υυ 
=
υυ 
table
υυ  %
.
υυ% &
Column
υυ& ,
<
υυ, -
string
υυ- 3
>
υυ3 4
(
υυ4 5
type
υυ5 9
:
υυ9 :
$str
υυ; A
,
υυA B
nullable
υυC K
:
υυK L
true
υυM Q
)
υυQ R
,
υυR S
IsActive
φφ 
=
φφ 
table
φφ $
.
φφ$ %
Column
φφ% +
<
φφ+ ,
bool
φφ, 0
>
φφ0 1
(
φφ1 2
type
φφ2 6
:
φφ6 7
$str
φφ8 A
,
φφA B
nullable
φφC K
:
φφK L
false
φφM R
)
φφR S
,
φφS T
	IsDeleted
χχ 
=
χχ 
table
χχ  %
.
χχ% &
Column
χχ& ,
<
χχ, -
bool
χχ- 1
>
χχ1 2
(
χχ2 3
type
χχ3 7
:
χχ7 8
$str
χχ9 B
,
χχB C
nullable
χχD L
:
χχL M
false
χχN S
)
χχS T
,
χχT U
	DeletedAt
ψψ 
=
ψψ 
table
ψψ  %
.
ψψ% &
Column
ψψ& ,
<
ψψ, -
DateTime
ψψ- 5
>
ψψ5 6
(
ψψ6 7
type
ψψ7 ;
:
ψψ; <
$str
ψψ= W
,
ψψW X
nullable
ψψY a
:
ψψa b
true
ψψc g
)
ψψg h
}
ωω 
,
ωω 
constraints
ϊϊ 
:
ϊϊ 
table
ϊϊ "
=>
ϊϊ# %
{
ϋϋ 
table
όό 
.
όό 

PrimaryKey
όό $
(
όό$ %
$str
όό% 3
,
όό3 4
x
όό5 6
=>
όό7 9
x
όό: ;
.
όό; <
Id
όό< >
)
όό> ?
;
όό? @
}
ύύ 
)
ύύ 
;
ύύ 
migrationBuilder
ÿÿ 
.
ÿÿ 
CreateTable
ÿÿ (
(
ÿÿ( )
name
€€ 
:
€€ 
$str
€€ 
,
€€ 
columns
 
:
 
table
 
=>
 !
new
" %
{
‚‚ 
Id
ƒƒ 
=
ƒƒ 
table
ƒƒ 
.
ƒƒ 
Column
ƒƒ %
<
ƒƒ% &
int
ƒƒ& )
>
ƒƒ) *
(
ƒƒ* +
type
ƒƒ+ /
:
ƒƒ/ 0
$str
ƒƒ1 :
,
ƒƒ: ;
nullable
ƒƒ< D
:
ƒƒD E
false
ƒƒF K
)
ƒƒK L
.
„„ 

Annotation
„„ #
(
„„# $
$str
„„$ D
,
„„D E+
NpgsqlValueGenerationStrategy
„„F c
.
„„c d%
IdentityByDefaultColumn
„„d {
)
„„{ |
,
„„| }
Name
…… 
=
…… 
table
……  
.
……  !
Column
……! '
<
……' (
string
……( .
>
……. /
(
……/ 0
type
……0 4
:
……4 5
$str
……6 <
,
……< =
nullable
……> F
:
……F G
false
……H M
)
……M N
,
……N O
DepartmentId
††  
=
††! "
table
††# (
.
††( )
Column
††) /
<
††/ 0
int
††0 3
>
††3 4
(
††4 5
type
††5 9
:
††9 :
$str
††; D
,
††D E
nullable
††F N
:
††N O
true
††P T
)
††T U
,
††U V
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
 
=
 
table
  %
.
% &
Column
& ,
<
, -
string
- 3
>
3 4
(
4 5
type
5 9
:
9 :
$str
; A
,
A B
nullable
C K
:
K L
true
M Q
)
Q R
,
R S
	UpdatedAt
‰‰ 
=
‰‰ 
table
‰‰  %
.
‰‰% &
Column
‰‰& ,
<
‰‰, -
DateTime
‰‰- 5
>
‰‰5 6
(
‰‰6 7
type
‰‰7 ;
:
‰‰; <
$str
‰‰= W
,
‰‰W X
nullable
‰‰Y a
:
‰‰a b
true
‰‰c g
)
‰‰g h
,
‰‰h i
	UpdatedBy
 
=
 
table
  %
.
% &
Column
& ,
<
, -
string
- 3
>
3 4
(
4 5
type
5 9
:
9 :
$str
; A
,
A B
nullable
C K
:
K L
true
M Q
)
Q R
,
R S
IsActive
‹‹ 
=
‹‹ 
table
‹‹ $
.
‹‹$ %
Column
‹‹% +
<
‹‹+ ,
bool
‹‹, 0
>
‹‹0 1
(
‹‹1 2
type
‹‹2 6
:
‹‹6 7
$str
‹‹8 A
,
‹‹A B
nullable
‹‹C K
:
‹‹K L
false
‹‹M R
)
‹‹R S
,
‹‹S T
	IsDeleted
 
=
 
table
  %
.
% &
Column
& ,
<
, -
bool
- 1
>
1 2
(
2 3
type
3 7
:
7 8
$str
9 B
,
B C
nullable
D L
:
L M
false
N S
)
S T
,
T U
	DeletedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
}
 
,
 
constraints
 
:
 
table
 "
=>
# %
{
 
table
‘‘ 
.
‘‘ 

PrimaryKey
‘‘ $
(
‘‘$ %
$str
‘‘% 0
,
‘‘0 1
x
‘‘2 3
=>
‘‘4 6
x
‘‘7 8
.
‘‘8 9
Id
‘‘9 ;
)
‘‘; <
;
‘‘< =
table
’’ 
.
’’ 

ForeignKey
’’ $
(
’’$ %
name
““ 
:
““ 
$str
““ B
,
““B C
column
”” 
:
”” 
x
””  !
=>
””" $
x
””% &
.
””& '
DepartmentId
””' 3
,
””3 4
principalTable
•• &
:
••& '
$str
••( 5
,
••5 6
principalColumn
–– '
:
––' (
$str
––) -
)
––- .
;
––. /
}
—— 
)
—— 
;
—— 
migrationBuilder
™™ 
.
™™ 
CreateTable
™™ (
(
™™( )
name
 
:
 
$str
 
,
 
columns
›› 
:
›› 
table
›› 
=>
›› !
new
››" %
{
 
Id
 
=
 
table
 
.
 
Column
 %
<
% &
int
& )
>
) *
(
* +
type
+ /
:
/ 0
$str
1 :
,
: ;
nullable
< D
:
D E
false
F K
)
K L
.
 

Annotation
 #
(
# $
$str
$ D
,
D E+
NpgsqlValueGenerationStrategy
F c
.
c d%
IdentityByDefaultColumn
d {
)
{ |
,
| }
Username
 
=
 
table
 $
.
$ %
Column
% +
<
+ ,
string
, 2
>
2 3
(
3 4
type
4 8
:
8 9
$str
: @
,
@ A
nullable
B J
:
J K
false
L Q
)
Q R
,
R S
Email
   
=
   
table
   !
.
  ! "
Column
  " (
<
  ( )
string
  ) /
>
  / 0
(
  0 1
type
  1 5
:
  5 6
$str
  7 =
,
  = >
nullable
  ? G
:
  G H
false
  I N
)
  N O
,
  O P
PasswordHash
΅΅  
=
΅΅! "
table
΅΅# (
.
΅΅( )
Column
΅΅) /
<
΅΅/ 0
string
΅΅0 6
>
΅΅6 7
(
΅΅7 8
type
΅΅8 <
:
΅΅< =
$str
΅΅> D
,
΅΅D E
nullable
΅΅F N
:
΅΅N O
false
΅΅P U
)
΅΅U V
,
΅΅V W
	FirstName
ΆΆ 
=
ΆΆ 
table
ΆΆ  %
.
ΆΆ% &
Column
ΆΆ& ,
<
ΆΆ, -
string
ΆΆ- 3
>
ΆΆ3 4
(
ΆΆ4 5
type
ΆΆ5 9
:
ΆΆ9 :
$str
ΆΆ; A
,
ΆΆA B
nullable
ΆΆC K
:
ΆΆK L
false
ΆΆM R
)
ΆΆR S
,
ΆΆS T
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
¤¤  
=
¤¤! "
table
¤¤# (
.
¤¤( )
Column
¤¤) /
<
¤¤/ 0
int
¤¤0 3
>
¤¤3 4
(
¤¤4 5
type
¤¤5 9
:
¤¤9 :
$str
¤¤; D
,
¤¤D E
nullable
¤¤F N
:
¤¤N O
true
¤¤P T
)
¤¤T U
,
¤¤U V
	CreatedAt
¥¥ 
=
¥¥ 
table
¥¥  %
.
¥¥% &
Column
¥¥& ,
<
¥¥, -
DateTime
¥¥- 5
>
¥¥5 6
(
¥¥6 7
type
¥¥7 ;
:
¥¥; <
$str
¥¥= W
,
¥¥W X
nullable
¥¥Y a
:
¥¥a b
false
¥¥c h
)
¥¥h i
,
¥¥i j
	CreatedBy
¦¦ 
=
¦¦ 
table
¦¦  %
.
¦¦% &
Column
¦¦& ,
<
¦¦, -
string
¦¦- 3
>
¦¦3 4
(
¦¦4 5
type
¦¦5 9
:
¦¦9 :
$str
¦¦; A
,
¦¦A B
nullable
¦¦C K
:
¦¦K L
true
¦¦M Q
)
¦¦Q R
,
¦¦R S
	UpdatedAt
§§ 
=
§§ 
table
§§  %
.
§§% &
Column
§§& ,
<
§§, -
DateTime
§§- 5
>
§§5 6
(
§§6 7
type
§§7 ;
:
§§; <
$str
§§= W
,
§§W X
nullable
§§Y a
:
§§a b
true
§§c g
)
§§g h
,
§§h i
	UpdatedBy
¨¨ 
=
¨¨ 
table
¨¨  %
.
¨¨% &
Column
¨¨& ,
<
¨¨, -
string
¨¨- 3
>
¨¨3 4
(
¨¨4 5
type
¨¨5 9
:
¨¨9 :
$str
¨¨; A
,
¨¨A B
nullable
¨¨C K
:
¨¨K L
true
¨¨M Q
)
¨¨Q R
,
¨¨R S
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
ªª 
=
ªª 
table
ªª  %
.
ªª% &
Column
ªª& ,
<
ªª, -
bool
ªª- 1
>
ªª1 2
(
ªª2 3
type
ªª3 7
:
ªª7 8
$str
ªª9 B
,
ªªB C
nullable
ªªD L
:
ªªL M
false
ªªN S
)
ªªS T
,
ªªT U
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
¬¬ 
,
¬¬ 
constraints
­­ 
:
­­ 
table
­­ "
=>
­­# %
{
®® 
table
―― 
.
―― 

PrimaryKey
―― $
(
――$ %
$str
――% /
,
――/ 0
x
――1 2
=>
――3 5
x
――6 7
.
――7 8
Id
――8 :
)
――: ;
;
――; <
table
°° 
.
°° 

ForeignKey
°° $
(
°°$ %
name
±± 
:
±± 
$str
±± A
,
±±A B
column
²² 
:
²² 
x
²²  !
=>
²²" $
x
²²% &
.
²²& '
DepartmentId
²²' 3
,
²²3 4
principalTable
³³ &
:
³³& '
$str
³³( 5
,
³³5 6
principalColumn
΄΄ '
:
΄΄' (
$str
΄΄) -
)
΄΄- .
;
΄΄. /
}
µµ 
)
µµ 
;
µµ 
migrationBuilder
·· 
.
·· 
CreateTable
·· (
(
··( )
name
ΈΈ 
:
ΈΈ 
$str
ΈΈ $
,
ΈΈ$ %
columns
ΉΉ 
:
ΉΉ 
table
ΉΉ 
=>
ΉΉ !
new
ΉΉ" %
{
ΊΊ 
Id
»» 
=
»» 
table
»» 
.
»» 
Column
»» %
<
»»% &
int
»»& )
>
»») *
(
»»* +
type
»»+ /
:
»»/ 0
$str
»»1 :
,
»»: ;
nullable
»»< D
:
»»D E
false
»»F K
)
»»K L
.
ΌΌ 

Annotation
ΌΌ #
(
ΌΌ# $
$str
ΌΌ$ D
,
ΌΌD E+
NpgsqlValueGenerationStrategy
ΌΌF c
.
ΌΌc d%
IdentityByDefaultColumn
ΌΌd {
)
ΌΌ{ |
,
ΌΌ| }
FieldDefinitionId
½½ %
=
½½& '
table
½½( -
.
½½- .
Column
½½. 4
<
½½4 5
int
½½5 8
>
½½8 9
(
½½9 :
type
½½: >
:
½½> ?
$str
½½@ I
,
½½I J
nullable
½½K S
:
½½S T
false
½½U Z
)
½½Z [
,
½½[ \
Value
ΎΎ 
=
ΎΎ 
table
ΎΎ !
.
ΎΎ! "
Column
ΎΎ" (
<
ΎΎ( )
string
ΎΎ) /
>
ΎΎ/ 0
(
ΎΎ0 1
type
ΎΎ1 5
:
ΎΎ5 6
$str
ΎΎ7 =
,
ΎΎ= >
nullable
ΎΎ? G
:
ΎΎG H
false
ΎΎI N
)
ΎΎN O
,
ΎΎO P
Label
ΏΏ 
=
ΏΏ 
table
ΏΏ !
.
ΏΏ! "
Column
ΏΏ" (
<
ΏΏ( )
string
ΏΏ) /
>
ΏΏ/ 0
(
ΏΏ0 1
type
ΏΏ1 5
:
ΏΏ5 6
$str
ΏΏ7 =
,
ΏΏ= >
nullable
ΏΏ? G
:
ΏΏG H
false
ΏΏI N
)
ΏΏN O
,
ΏΏO P
	SortOrder
ΐΐ 
=
ΐΐ 
table
ΐΐ  %
.
ΐΐ% &
Column
ΐΐ& ,
<
ΐΐ, -
int
ΐΐ- 0
>
ΐΐ0 1
(
ΐΐ1 2
type
ΐΐ2 6
:
ΐΐ6 7
$str
ΐΐ8 A
,
ΐΐA B
nullable
ΐΐC K
:
ΐΐK L
false
ΐΐM R
)
ΐΐR S
,
ΐΐS T
	CreatedAt
ΑΑ 
=
ΑΑ 
table
ΑΑ  %
.
ΑΑ% &
Column
ΑΑ& ,
<
ΑΑ, -
DateTime
ΑΑ- 5
>
ΑΑ5 6
(
ΑΑ6 7
type
ΑΑ7 ;
:
ΑΑ; <
$str
ΑΑ= W
,
ΑΑW X
nullable
ΑΑY a
:
ΑΑa b
false
ΑΑc h
)
ΑΑh i
,
ΑΑi j
	CreatedBy
ΒΒ 
=
ΒΒ 
table
ΒΒ  %
.
ΒΒ% &
Column
ΒΒ& ,
<
ΒΒ, -
string
ΒΒ- 3
>
ΒΒ3 4
(
ΒΒ4 5
type
ΒΒ5 9
:
ΒΒ9 :
$str
ΒΒ; A
,
ΒΒA B
nullable
ΒΒC K
:
ΒΒK L
true
ΒΒM Q
)
ΒΒQ R
,
ΒΒR S
	UpdatedAt
ΓΓ 
=
ΓΓ 
table
ΓΓ  %
.
ΓΓ% &
Column
ΓΓ& ,
<
ΓΓ, -
DateTime
ΓΓ- 5
>
ΓΓ5 6
(
ΓΓ6 7
type
ΓΓ7 ;
:
ΓΓ; <
$str
ΓΓ= W
,
ΓΓW X
nullable
ΓΓY a
:
ΓΓa b
true
ΓΓc g
)
ΓΓg h
,
ΓΓh i
	UpdatedBy
ΔΔ 
=
ΔΔ 
table
ΔΔ  %
.
ΔΔ% &
Column
ΔΔ& ,
<
ΔΔ, -
string
ΔΔ- 3
>
ΔΔ3 4
(
ΔΔ4 5
type
ΔΔ5 9
:
ΔΔ9 :
$str
ΔΔ; A
,
ΔΔA B
nullable
ΔΔC K
:
ΔΔK L
true
ΔΔM Q
)
ΔΔQ R
,
ΔΔR S
IsActive
ΕΕ 
=
ΕΕ 
table
ΕΕ $
.
ΕΕ$ %
Column
ΕΕ% +
<
ΕΕ+ ,
bool
ΕΕ, 0
>
ΕΕ0 1
(
ΕΕ1 2
type
ΕΕ2 6
:
ΕΕ6 7
$str
ΕΕ8 A
,
ΕΕA B
nullable
ΕΕC K
:
ΕΕK L
false
ΕΕM R
)
ΕΕR S
,
ΕΕS T
	IsDeleted
ΖΖ 
=
ΖΖ 
table
ΖΖ  %
.
ΖΖ% &
Column
ΖΖ& ,
<
ΖΖ, -
bool
ΖΖ- 1
>
ΖΖ1 2
(
ΖΖ2 3
type
ΖΖ3 7
:
ΖΖ7 8
$str
ΖΖ9 B
,
ΖΖB C
nullable
ΖΖD L
:
ΖΖL M
false
ΖΖN S
)
ΖΖS T
,
ΖΖT U
	DeletedAt
ΗΗ 
=
ΗΗ 
table
ΗΗ  %
.
ΗΗ% &
Column
ΗΗ& ,
<
ΗΗ, -
DateTime
ΗΗ- 5
>
ΗΗ5 6
(
ΗΗ6 7
type
ΗΗ7 ;
:
ΗΗ; <
$str
ΗΗ= W
,
ΗΗW X
nullable
ΗΗY a
:
ΗΗa b
true
ΗΗc g
)
ΗΗg h
}
ΘΘ 
,
ΘΘ 
constraints
ΙΙ 
:
ΙΙ 
table
ΙΙ "
=>
ΙΙ# %
{
ΚΚ 
table
ΛΛ 
.
ΛΛ 

PrimaryKey
ΛΛ $
(
ΛΛ$ %
$str
ΛΛ% 6
,
ΛΛ6 7
x
ΛΛ8 9
=>
ΛΛ: <
x
ΛΛ= >
.
ΛΛ> ?
Id
ΛΛ? A
)
ΛΛA B
;
ΛΛB C
table
ΜΜ 
.
ΜΜ 

ForeignKey
ΜΜ $
(
ΜΜ$ %
name
ΝΝ 
:
ΝΝ 
$str
ΝΝ R
,
ΝΝR S
column
ΞΞ 
:
ΞΞ 
x
ΞΞ  !
=>
ΞΞ" $
x
ΞΞ% &
.
ΞΞ& '
FieldDefinitionId
ΞΞ' 8
,
ΞΞ8 9
principalTable
ΟΟ &
:
ΟΟ& '
$str
ΟΟ( :
,
ΟΟ: ;
principalColumn
ΠΠ '
:
ΠΠ' (
$str
ΠΠ) -
,
ΠΠ- .
onDelete
ΡΡ  
:
ΡΡ  !
ReferentialAction
ΡΡ" 3
.
ΡΡ3 4
Cascade
ΡΡ4 ;
)
ΡΡ; <
;
ΡΡ< =
}
ÒÒ 
)
ÒÒ 
;
ÒÒ 
migrationBuilder
ΤΤ 
.
ΤΤ 
CreateTable
ΤΤ (
(
ΤΤ( )
name
ΥΥ 
:
ΥΥ 
$str
ΥΥ +
,
ΥΥ+ ,
columns
ΦΦ 
:
ΦΦ 
table
ΦΦ 
=>
ΦΦ !
new
ΦΦ" %
{
ΧΧ 
Id
ΨΨ 
=
ΨΨ 
table
ΨΨ 
.
ΨΨ 
Column
ΨΨ %
<
ΨΨ% &
int
ΨΨ& )
>
ΨΨ) *
(
ΨΨ* +
type
ΨΨ+ /
:
ΨΨ/ 0
$str
ΨΨ1 :
,
ΨΨ: ;
nullable
ΨΨ< D
:
ΨΨD E
false
ΨΨF K
)
ΨΨK L
.
ΩΩ 

Annotation
ΩΩ #
(
ΩΩ# $
$str
ΩΩ$ D
,
ΩΩD E+
NpgsqlValueGenerationStrategy
ΩΩF c
.
ΩΩc d%
IdentityByDefaultColumn
ΩΩd {
)
ΩΩ{ |
,
ΩΩ| }
	ProjectId
ΪΪ 
=
ΪΪ 
table
ΪΪ  %
.
ΪΪ% &
Column
ΪΪ& ,
<
ΪΪ, -
int
ΪΪ- 0
>
ΪΪ0 1
(
ΪΪ1 2
type
ΪΪ2 6
:
ΪΪ6 7
$str
ΪΪ8 A
,
ΪΪA B
nullable
ΪΪC K
:
ΪΪK L
true
ΪΪM Q
)
ΪΪQ R
,
ΪΪR S

CategoryId
ΫΫ 
=
ΫΫ  
table
ΫΫ! &
.
ΫΫ& '
Column
ΫΫ' -
<
ΫΫ- .
int
ΫΫ. 1
>
ΫΫ1 2
(
ΫΫ2 3
type
ΫΫ3 7
:
ΫΫ7 8
$str
ΫΫ9 B
,
ΫΫB C
nullable
ΫΫD L
:
ΫΫL M
true
ΫΫN R
)
ΫΫR S
,
ΫΫS T
TicketTypeId
άά  
=
άά! "
table
άά# (
.
άά( )
Column
άά) /
<
άά/ 0
int
άά0 3
>
άά3 4
(
άά4 5
type
άά5 9
:
άά9 :
$str
άά; D
,
άάD E
nullable
άάF N
:
άάN O
true
άάP T
)
άάT U
,
άάU V
FieldDefinitionId
έέ %
=
έέ& '
table
έέ( -
.
έέ- .
Column
έέ. 4
<
έέ4 5
int
έέ5 8
>
έέ8 9
(
έέ9 :
type
έέ: >
:
έέ> ?
$str
έέ@ I
,
έέI J
nullable
έέK S
:
έέS T
false
έέU Z
)
έέZ [
,
έέ[ \
	SortOrder
ήή 
=
ήή 
table
ήή  %
.
ήή% &
Column
ήή& ,
<
ήή, -
int
ήή- 0
>
ήή0 1
(
ήή1 2
type
ήή2 6
:
ήή6 7
$str
ήή8 A
,
ήήA B
nullable
ήήC K
:
ήήK L
false
ήήM R
)
ήήR S
,
ήήS T

IsRequired
ίί 
=
ίί  
table
ίί! &
.
ίί& '
Column
ίί' -
<
ίί- .
bool
ίί. 2
>
ίί2 3
(
ίί3 4
type
ίί4 8
:
ίί8 9
$str
ίί: C
,
ίίC D
nullable
ίίE M
:
ίίM N
false
ίίO T
)
ίίT U
,
ίίU V
	CreatedAt
ΰΰ 
=
ΰΰ 
table
ΰΰ  %
.
ΰΰ% &
Column
ΰΰ& ,
<
ΰΰ, -
DateTime
ΰΰ- 5
>
ΰΰ5 6
(
ΰΰ6 7
type
ΰΰ7 ;
:
ΰΰ; <
$str
ΰΰ= W
,
ΰΰW X
nullable
ΰΰY a
:
ΰΰa b
false
ΰΰc h
)
ΰΰh i
,
ΰΰi j
	CreatedBy
αα 
=
αα 
table
αα  %
.
αα% &
Column
αα& ,
<
αα, -
string
αα- 3
>
αα3 4
(
αα4 5
type
αα5 9
:
αα9 :
$str
αα; A
,
ααA B
nullable
ααC K
:
ααK L
true
ααM Q
)
ααQ R
,
ααR S
	UpdatedAt
ββ 
=
ββ 
table
ββ  %
.
ββ% &
Column
ββ& ,
<
ββ, -
DateTime
ββ- 5
>
ββ5 6
(
ββ6 7
type
ββ7 ;
:
ββ; <
$str
ββ= W
,
ββW X
nullable
ββY a
:
ββa b
true
ββc g
)
ββg h
,
ββh i
	UpdatedBy
γγ 
=
γγ 
table
γγ  %
.
γγ% &
Column
γγ& ,
<
γγ, -
string
γγ- 3
>
γγ3 4
(
γγ4 5
type
γγ5 9
:
γγ9 :
$str
γγ; A
,
γγA B
nullable
γγC K
:
γγK L
true
γγM Q
)
γγQ R
,
γγR S
IsActive
δδ 
=
δδ 
table
δδ $
.
δδ$ %
Column
δδ% +
<
δδ+ ,
bool
δδ, 0
>
δδ0 1
(
δδ1 2
type
δδ2 6
:
δδ6 7
$str
δδ8 A
,
δδA B
nullable
δδC K
:
δδK L
false
δδM R
)
δδR S
,
δδS T
	IsDeleted
εε 
=
εε 
table
εε  %
.
εε% &
Column
εε& ,
<
εε, -
bool
εε- 1
>
εε1 2
(
εε2 3
type
εε3 7
:
εε7 8
$str
εε9 B
,
εεB C
nullable
εεD L
:
εεL M
false
εεN S
)
εεS T
,
εεT U
	DeletedAt
ζζ 
=
ζζ 
table
ζζ  %
.
ζζ% &
Column
ζζ& ,
<
ζζ, -
DateTime
ζζ- 5
>
ζζ5 6
(
ζζ6 7
type
ζζ7 ;
:
ζζ; <
$str
ζζ= W
,
ζζW X
nullable
ζζY a
:
ζζa b
true
ζζc g
)
ζζg h
}
ηη 
,
ηη 
constraints
θθ 
:
θθ 
table
θθ "
=>
θθ# %
{
ιι 
table
κκ 
.
κκ 

PrimaryKey
κκ $
(
κκ$ %
$str
κκ% =
,
κκ= >
x
κκ? @
=>
κκA C
x
κκD E
.
κκE F
Id
κκF H
)
κκH I
;
κκI J
table
λλ 
.
λλ 

ForeignKey
λλ $
(
λλ$ %
name
μμ 
:
μμ 
$str
μμ Y
,
μμY Z
column
νν 
:
νν 
x
νν  !
=>
νν" $
x
νν% &
.
νν& '
FieldDefinitionId
νν' 8
,
νν8 9
principalTable
ξξ &
:
ξξ& '
$str
ξξ( :
,
ξξ: ;
principalColumn
οο '
:
οο' (
$str
οο) -
,
οο- .
onDelete
ππ  
:
ππ  !
ReferentialAction
ππ" 3
.
ππ3 4
Cascade
ππ4 ;
)
ππ; <
;
ππ< =
}
ρρ 
)
ρρ 
;
ρρ 
migrationBuilder
σσ 
.
σσ 
CreateTable
σσ (
(
σσ( )
name
ττ 
:
ττ 
$str
ττ )
,
ττ) *
columns
υυ 
:
υυ 
table
υυ 
=>
υυ !
new
υυ" %
{
φφ 
Id
χχ 
=
χχ 
table
χχ 
.
χχ 
Column
χχ %
<
χχ% &
int
χχ& )
>
χχ) *
(
χχ* +
type
χχ+ /
:
χχ/ 0
$str
χχ1 :
,
χχ: ;
nullable
χχ< D
:
χχD E
false
χχF K
)
χχK L
.
ψψ 

Annotation
ψψ #
(
ψψ# $
$str
ψψ$ D
,
ψψD E+
NpgsqlValueGenerationStrategy
ψψF c
.
ψψc d%
IdentityByDefaultColumn
ψψd {
)
ψψ{ |
,
ψψ| }

CategoryId
ωω 
=
ωω  
table
ωω! &
.
ωω& '
Column
ωω' -
<
ωω- .
int
ωω. 1
>
ωω1 2
(
ωω2 3
type
ωω3 7
:
ωω7 8
$str
ωω9 B
,
ωωB C
nullable
ωωD L
:
ωωL M
false
ωωN S
)
ωωS T
,
ωωT U
Title
ϊϊ 
=
ϊϊ 
table
ϊϊ !
.
ϊϊ! "
Column
ϊϊ" (
<
ϊϊ( )
string
ϊϊ) /
>
ϊϊ/ 0
(
ϊϊ0 1
type
ϊϊ1 5
:
ϊϊ5 6
$str
ϊϊ7 =
,
ϊϊ= >
nullable
ϊϊ? G
:
ϊϊG H
false
ϊϊI N
)
ϊϊN O
,
ϊϊO P
Content
ϋϋ 
=
ϋϋ 
table
ϋϋ #
.
ϋϋ# $
Column
ϋϋ$ *
<
ϋϋ* +
string
ϋϋ+ 1
>
ϋϋ1 2
(
ϋϋ2 3
type
ϋϋ3 7
:
ϋϋ7 8
$str
ϋϋ9 ?
,
ϋϋ? @
nullable
ϋϋA I
:
ϋϋI J
false
ϋϋK P
)
ϋϋP Q
,
ϋϋQ R
AuthorUserId
όό  
=
όό! "
table
όό# (
.
όό( )
Column
όό) /
<
όό/ 0
int
όό0 3
>
όό3 4
(
όό4 5
type
όό5 9
:
όό9 :
$str
όό; D
,
όόD E
nullable
όόF N
:
όόN O
false
όόP U
)
όόU V
,
όόV W
Status
ύύ 
=
ύύ 
table
ύύ "
.
ύύ" #
Column
ύύ# )
<
ύύ) *
int
ύύ* -
>
ύύ- .
(
ύύ. /
type
ύύ/ 3
:
ύύ3 4
$str
ύύ5 >
,
ύύ> ?
nullable
ύύ@ H
:
ύύH I
false
ύύJ O
)
ύύO P
,
ύύP Q
	ViewCount
ώώ 
=
ώώ 
table
ώώ  %
.
ώώ% &
Column
ώώ& ,
<
ώώ, -
int
ώώ- 0
>
ώώ0 1
(
ώώ1 2
type
ώώ2 6
:
ώώ6 7
$str
ώώ8 A
,
ώώA B
nullable
ώώC K
:
ώώK L
false
ώώM R
)
ώώR S
,
ώώS T
	CreatedAt
ÿÿ 
=
ÿÿ 
table
ÿÿ  %
.
ÿÿ% &
Column
ÿÿ& ,
<
ÿÿ, -
DateTime
ÿÿ- 5
>
ÿÿ5 6
(
ÿÿ6 7
type
ÿÿ7 ;
:
ÿÿ; <
$str
ÿÿ= W
,
ÿÿW X
nullable
ÿÿY a
:
ÿÿa b
false
ÿÿc h
)
ÿÿh i
,
ÿÿi j
	CreatedBy
€€ 
=
€€ 
table
€€  %
.
€€% &
Column
€€& ,
<
€€, -
string
€€- 3
>
€€3 4
(
€€4 5
type
€€5 9
:
€€9 :
$str
€€; A
,
€€A B
nullable
€€C K
:
€€K L
true
€€M Q
)
€€Q R
,
€€R S
	UpdatedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
,
h i
	UpdatedBy
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
‚‚, -
string
‚‚- 3
>
‚‚3 4
(
‚‚4 5
type
‚‚5 9
:
‚‚9 :
$str
‚‚; A
,
‚‚A B
nullable
‚‚C K
:
‚‚K L
true
‚‚M Q
)
‚‚Q R
,
‚‚R S
IsActive
ƒƒ 
=
ƒƒ 
table
ƒƒ $
.
ƒƒ$ %
Column
ƒƒ% +
<
ƒƒ+ ,
bool
ƒƒ, 0
>
ƒƒ0 1
(
ƒƒ1 2
type
ƒƒ2 6
:
ƒƒ6 7
$str
ƒƒ8 A
,
ƒƒA B
nullable
ƒƒC K
:
ƒƒK L
false
ƒƒM R
)
ƒƒR S
,
ƒƒS T
	IsDeleted
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
„„, -
bool
„„- 1
>
„„1 2
(
„„2 3
type
„„3 7
:
„„7 8
$str
„„9 B
,
„„B C
nullable
„„D L
:
„„L M
false
„„N S
)
„„S T
,
„„T U
	DeletedAt
…… 
=
…… 
table
……  %
.
……% &
Column
……& ,
<
……, -
DateTime
……- 5
>
……5 6
(
……6 7
type
……7 ;
:
……; <
$str
……= W
,
……W X
nullable
……Y a
:
……a b
true
……c g
)
……g h
}
†† 
,
†† 
constraints
‡‡ 
:
‡‡ 
table
‡‡ "
=>
‡‡# %
{
 
table
‰‰ 
.
‰‰ 

PrimaryKey
‰‰ $
(
‰‰$ %
$str
‰‰% ;
,
‰‰; <
x
‰‰= >
=>
‰‰? A
x
‰‰B C
.
‰‰C D
Id
‰‰D F
)
‰‰F G
;
‰‰G H
table
 
.
 

ForeignKey
 $
(
$ %
name
‹‹ 
:
‹‹ 
$str
‹‹ S
,
‹‹S T
column
 
:
 
x
  !
=>
" $
x
% &
.
& '

CategoryId
' 1
,
1 2
principalTable
 &
:
& '
$str
( =
,
= >
principalColumn
 '
:
' (
$str
) -
,
- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
}
 
)
 
;
 
migrationBuilder
’’ 
.
’’ 
CreateTable
’’ (
(
’’( )
name
““ 
:
““ 
$str
““ '
,
““' (
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
•• 
Id
–– 
=
–– 
table
–– 
.
–– 
Column
–– %
<
––% &
int
––& )
>
––) *
(
––* +
type
––+ /
:
––/ 0
$str
––1 :
,
––: ;
nullable
––< D
:
––D E
false
––F K
)
––K L
.
—— 

Annotation
—— #
(
——# $
$str
——$ D
,
——D E+
NpgsqlValueGenerationStrategy
——F c
.
——c d%
IdentityByDefaultColumn
——d {
)
——{ |
,
——| }
RoleId
 
=
 
table
 "
.
" #
Column
# )
<
) *
int
* -
>
- .
(
. /
type
/ 3
:
3 4
$str
5 >
,
> ?
nullable
@ H
:
H I
false
J O
)
O P
,
P Q
PermissionId
™™  
=
™™! "
table
™™# (
.
™™( )
Column
™™) /
<
™™/ 0
int
™™0 3
>
™™3 4
(
™™4 5
type
™™5 9
:
™™9 :
$str
™™; D
,
™™D E
nullable
™™F N
:
™™N O
false
™™P U
)
™™U V
,
™™V W
	CreatedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
false
c h
)
h i
,
i j
	CreatedBy
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
››, -
string
››- 3
>
››3 4
(
››4 5
type
››5 9
:
››9 :
$str
››; A
,
››A B
nullable
››C K
:
››K L
true
››M Q
)
››Q R
,
››R S
	UpdatedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
,
h i
	UpdatedBy
 
=
 
table
  %
.
% &
Column
& ,
<
, -
string
- 3
>
3 4
(
4 5
type
5 9
:
9 :
$str
; A
,
A B
nullable
C K
:
K L
true
M Q
)
Q R
,
R S
IsActive
 
=
 
table
 $
.
$ %
Column
% +
<
+ ,
bool
, 0
>
0 1
(
1 2
type
2 6
:
6 7
$str
8 A
,
A B
nullable
C K
:
K L
false
M R
)
R S
,
S T
	IsDeleted
 
=
 
table
  %
.
% &
Column
& ,
<
, -
bool
- 1
>
1 2
(
2 3
type
3 7
:
7 8
$str
9 B
,
B C
nullable
D L
:
L M
false
N S
)
S T
,
T U
	DeletedAt
   
=
   
table
    %
.
  % &
Column
  & ,
<
  , -
DateTime
  - 5
>
  5 6
(
  6 7
type
  7 ;
:
  ; <
$str
  = W
,
  W X
nullable
  Y a
:
  a b
true
  c g
)
  g h
}
΅΅ 
,
΅΅ 
constraints
ΆΆ 
:
ΆΆ 
table
ΆΆ "
=>
ΆΆ# %
{
££ 
table
¤¤ 
.
¤¤ 

PrimaryKey
¤¤ $
(
¤¤$ %
$str
¤¤% 9
,
¤¤9 :
x
¤¤; <
=>
¤¤= ?
x
¤¤@ A
.
¤¤A B
Id
¤¤B D
)
¤¤D E
;
¤¤E F
table
¥¥ 
.
¥¥ 

ForeignKey
¥¥ $
(
¥¥$ %
name
¦¦ 
:
¦¦ 
$str
¦¦ K
,
¦¦K L
column
§§ 
:
§§ 
x
§§  !
=>
§§" $
x
§§% &
.
§§& '
PermissionId
§§' 3
,
§§3 4
principalTable
¨¨ &
:
¨¨& '
$str
¨¨( 5
,
¨¨5 6
principalColumn
©© '
:
©©' (
$str
©©) -
,
©©- .
onDelete
ªª  
:
ªª  !
ReferentialAction
ªª" 3
.
ªª3 4
Cascade
ªª4 ;
)
ªª; <
;
ªª< =
table
«« 
.
«« 

ForeignKey
«« $
(
««$ %
name
¬¬ 
:
¬¬ 
$str
¬¬ ?
,
¬¬? @
column
­­ 
:
­­ 
x
­­  !
=>
­­" $
x
­­% &
.
­­& '
RoleId
­­' -
,
­­- .
principalTable
®® &
:
®®& '
$str
®®( /
,
®®/ 0
principalColumn
―― '
:
――' (
$str
――) -
,
――- .
onDelete
°°  
:
°°  !
ReferentialAction
°°" 3
.
°°3 4
Cascade
°°4 ;
)
°°; <
;
°°< =
}
±± 
)
±± 
;
±± 
migrationBuilder
³³ 
.
³³ 
CreateTable
³³ (
(
³³( )
name
΄΄ 
:
΄΄ 
$str
΄΄ "
,
΄΄" #
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
¶¶ 
Id
·· 
=
·· 
table
·· 
.
·· 
Column
·· %
<
··% &
int
··& )
>
··) *
(
··* +
type
··+ /
:
··/ 0
$str
··1 :
,
··: ;
nullable
··< D
:
··D E
false
··F K
)
··K L
.
ΈΈ 

Annotation
ΈΈ #
(
ΈΈ# $
$str
ΈΈ$ D
,
ΈΈD E+
NpgsqlValueGenerationStrategy
ΈΈF c
.
ΈΈc d%
IdentityByDefaultColumn
ΈΈd {
)
ΈΈ{ |
,
ΈΈ| }
SlaPolicyId
ΉΉ 
=
ΉΉ  !
table
ΉΉ" '
.
ΉΉ' (
Column
ΉΉ( .
<
ΉΉ. /
int
ΉΉ/ 2
>
ΉΉ2 3
(
ΉΉ3 4
type
ΉΉ4 8
:
ΉΉ8 9
$str
ΉΉ: C
,
ΉΉC D
nullable
ΉΉE M
:
ΉΉM N
false
ΉΉO T
)
ΉΉT U
,
ΉΉU V

PriorityId
ΊΊ 
=
ΊΊ  
table
ΊΊ! &
.
ΊΊ& '
Column
ΊΊ' -
<
ΊΊ- .
int
ΊΊ. 1
>
ΊΊ1 2
(
ΊΊ2 3
type
ΊΊ3 7
:
ΊΊ7 8
$str
ΊΊ9 B
,
ΊΊB C
nullable
ΊΊD L
:
ΊΊL M
false
ΊΊN S
)
ΊΊS T
,
ΊΊT U
TicketTypeId
»»  
=
»»! "
table
»»# (
.
»»( )
Column
»») /
<
»»/ 0
int
»»0 3
>
»»3 4
(
»»4 5
type
»»5 9
:
»»9 :
$str
»»; D
,
»»D E
nullable
»»F N
:
»»N O
true
»»P T
)
»»T U
,
»»U V"
FirstResponseMinutes
ΌΌ (
=
ΌΌ) *
table
ΌΌ+ 0
.
ΌΌ0 1
Column
ΌΌ1 7
<
ΌΌ7 8
int
ΌΌ8 ;
>
ΌΌ; <
(
ΌΌ< =
type
ΌΌ= A
:
ΌΌA B
$str
ΌΌC L
,
ΌΌL M
nullable
ΌΌN V
:
ΌΌV W
false
ΌΌX ]
)
ΌΌ] ^
,
ΌΌ^ _
ResolutionMinutes
½½ %
=
½½& '
table
½½( -
.
½½- .
Column
½½. 4
<
½½4 5
int
½½5 8
>
½½8 9
(
½½9 :
type
½½: >
:
½½> ?
$str
½½@ I
,
½½I J
nullable
½½K S
:
½½S T
false
½½U Z
)
½½Z [
,
½½[ \
	CreatedAt
ΎΎ 
=
ΎΎ 
table
ΎΎ  %
.
ΎΎ% &
Column
ΎΎ& ,
<
ΎΎ, -
DateTime
ΎΎ- 5
>
ΎΎ5 6
(
ΎΎ6 7
type
ΎΎ7 ;
:
ΎΎ; <
$str
ΎΎ= W
,
ΎΎW X
nullable
ΎΎY a
:
ΎΎa b
false
ΎΎc h
)
ΎΎh i
,
ΎΎi j
	CreatedBy
ΏΏ 
=
ΏΏ 
table
ΏΏ  %
.
ΏΏ% &
Column
ΏΏ& ,
<
ΏΏ, -
string
ΏΏ- 3
>
ΏΏ3 4
(
ΏΏ4 5
type
ΏΏ5 9
:
ΏΏ9 :
$str
ΏΏ; A
,
ΏΏA B
nullable
ΏΏC K
:
ΏΏK L
true
ΏΏM Q
)
ΏΏQ R
,
ΏΏR S
	UpdatedAt
ΐΐ 
=
ΐΐ 
table
ΐΐ  %
.
ΐΐ% &
Column
ΐΐ& ,
<
ΐΐ, -
DateTime
ΐΐ- 5
>
ΐΐ5 6
(
ΐΐ6 7
type
ΐΐ7 ;
:
ΐΐ; <
$str
ΐΐ= W
,
ΐΐW X
nullable
ΐΐY a
:
ΐΐa b
true
ΐΐc g
)
ΐΐg h
,
ΐΐh i
	UpdatedBy
ΑΑ 
=
ΑΑ 
table
ΑΑ  %
.
ΑΑ% &
Column
ΑΑ& ,
<
ΑΑ, -
string
ΑΑ- 3
>
ΑΑ3 4
(
ΑΑ4 5
type
ΑΑ5 9
:
ΑΑ9 :
$str
ΑΑ; A
,
ΑΑA B
nullable
ΑΑC K
:
ΑΑK L
true
ΑΑM Q
)
ΑΑQ R
,
ΑΑR S
IsActive
ΒΒ 
=
ΒΒ 
table
ΒΒ $
.
ΒΒ$ %
Column
ΒΒ% +
<
ΒΒ+ ,
bool
ΒΒ, 0
>
ΒΒ0 1
(
ΒΒ1 2
type
ΒΒ2 6
:
ΒΒ6 7
$str
ΒΒ8 A
,
ΒΒA B
nullable
ΒΒC K
:
ΒΒK L
false
ΒΒM R
)
ΒΒR S
,
ΒΒS T
	IsDeleted
ΓΓ 
=
ΓΓ 
table
ΓΓ  %
.
ΓΓ% &
Column
ΓΓ& ,
<
ΓΓ, -
bool
ΓΓ- 1
>
ΓΓ1 2
(
ΓΓ2 3
type
ΓΓ3 7
:
ΓΓ7 8
$str
ΓΓ9 B
,
ΓΓB C
nullable
ΓΓD L
:
ΓΓL M
false
ΓΓN S
)
ΓΓS T
,
ΓΓT U
	DeletedAt
ΔΔ 
=
ΔΔ 
table
ΔΔ  %
.
ΔΔ% &
Column
ΔΔ& ,
<
ΔΔ, -
DateTime
ΔΔ- 5
>
ΔΔ5 6
(
ΔΔ6 7
type
ΔΔ7 ;
:
ΔΔ; <
$str
ΔΔ= W
,
ΔΔW X
nullable
ΔΔY a
:
ΔΔa b
true
ΔΔc g
)
ΔΔg h
}
ΕΕ 
,
ΕΕ 
constraints
ΖΖ 
:
ΖΖ 
table
ΖΖ "
=>
ΖΖ# %
{
ΗΗ 
table
ΘΘ 
.
ΘΘ 

PrimaryKey
ΘΘ $
(
ΘΘ$ %
$str
ΘΘ% 4
,
ΘΘ4 5
x
ΘΘ6 7
=>
ΘΘ8 :
x
ΘΘ; <
.
ΘΘ< =
Id
ΘΘ= ?
)
ΘΘ? @
;
ΘΘ@ A
table
ΙΙ 
.
ΙΙ 

ForeignKey
ΙΙ $
(
ΙΙ$ %
name
ΚΚ 
:
ΚΚ 
$str
ΚΚ E
,
ΚΚE F
column
ΛΛ 
:
ΛΛ 
x
ΛΛ  !
=>
ΛΛ" $
x
ΛΛ% &
.
ΛΛ& '
SlaPolicyId
ΛΛ' 2
,
ΛΛ2 3
principalTable
ΜΜ &
:
ΜΜ& '
$str
ΜΜ( 5
,
ΜΜ5 6
principalColumn
ΝΝ '
:
ΝΝ' (
$str
ΝΝ) -
,
ΝΝ- .
onDelete
ΞΞ  
:
ΞΞ  !
ReferentialAction
ΞΞ" 3
.
ΞΞ3 4
Cascade
ΞΞ4 ;
)
ΞΞ; <
;
ΞΞ< =
}
ΟΟ 
)
ΟΟ 
;
ΟΟ 
migrationBuilder
ΡΡ 
.
ΡΡ 
CreateTable
ΡΡ (
(
ΡΡ( )
name
ÒÒ 
:
ÒÒ 
$str
ÒÒ +
,
ÒÒ+ ,
columns
ΣΣ 
:
ΣΣ 
table
ΣΣ 
=>
ΣΣ !
new
ΣΣ" %
{
ΤΤ 
Id
ΥΥ 
=
ΥΥ 
table
ΥΥ 
.
ΥΥ 
Column
ΥΥ %
<
ΥΥ% &
int
ΥΥ& )
>
ΥΥ) *
(
ΥΥ* +
type
ΥΥ+ /
:
ΥΥ/ 0
$str
ΥΥ1 :
,
ΥΥ: ;
nullable
ΥΥ< D
:
ΥΥD E
false
ΥΥF K
)
ΥΥK L
.
ΦΦ 

Annotation
ΦΦ #
(
ΦΦ# $
$str
ΦΦ$ D
,
ΦΦD E+
NpgsqlValueGenerationStrategy
ΦΦF c
.
ΦΦc d%
IdentityByDefaultColumn
ΦΦd {
)
ΦΦ{ |
,
ΦΦ| }

WorkflowId
ΧΧ 
=
ΧΧ  
table
ΧΧ! &
.
ΧΧ& '
Column
ΧΧ' -
<
ΧΧ- .
int
ΧΧ. 1
>
ΧΧ1 2
(
ΧΧ2 3
type
ΧΧ3 7
:
ΧΧ7 8
$str
ΧΧ9 B
,
ΧΧB C
nullable
ΧΧD L
:
ΧΧL M
false
ΧΧN S
)
ΧΧS T
,
ΧΧT U
FromStatusId
ΨΨ  
=
ΨΨ! "
table
ΨΨ# (
.
ΨΨ( )
Column
ΨΨ) /
<
ΨΨ/ 0
int
ΨΨ0 3
>
ΨΨ3 4
(
ΨΨ4 5
type
ΨΨ5 9
:
ΨΨ9 :
$str
ΨΨ; D
,
ΨΨD E
nullable
ΨΨF N
:
ΨΨN O
false
ΨΨP U
)
ΨΨU V
,
ΨΨV W

ToStatusId
ΩΩ 
=
ΩΩ  
table
ΩΩ! &
.
ΩΩ& '
Column
ΩΩ' -
<
ΩΩ- .
int
ΩΩ. 1
>
ΩΩ1 2
(
ΩΩ2 3
type
ΩΩ3 7
:
ΩΩ7 8
$str
ΩΩ9 B
,
ΩΩB C
nullable
ΩΩD L
:
ΩΩL M
false
ΩΩN S
)
ΩΩS T
,
ΩΩT U
TransitionName
ΪΪ "
=
ΪΪ# $
table
ΪΪ% *
.
ΪΪ* +
Column
ΪΪ+ 1
<
ΪΪ1 2
string
ΪΪ2 8
>
ΪΪ8 9
(
ΪΪ9 :
type
ΪΪ: >
:
ΪΪ> ?
$str
ΪΪ@ F
,
ΪΪF G
nullable
ΪΪH P
:
ΪΪP Q
false
ΪΪR W
)
ΪΪW X
,
ΪΪX Y#
RequiredPermissionKey
ΫΫ )
=
ΫΫ* +
table
ΫΫ, 1
.
ΫΫ1 2
Column
ΫΫ2 8
<
ΫΫ8 9
string
ΫΫ9 ?
>
ΫΫ? @
(
ΫΫ@ A
type
ΫΫA E
:
ΫΫE F
$str
ΫΫG M
,
ΫΫM N
nullable
ΫΫO W
:
ΫΫW X
true
ΫΫY ]
)
ΫΫ] ^
,
ΫΫ^ _
	SortOrder
άά 
=
άά 
table
άά  %
.
άά% &
Column
άά& ,
<
άά, -
int
άά- 0
>
άά0 1
(
άά1 2
type
άά2 6
:
άά6 7
$str
άά8 A
,
άάA B
nullable
άάC K
:
άάK L
false
άάM R
)
άάR S
,
άάS T
	CreatedAt
έέ 
=
έέ 
table
έέ  %
.
έέ% &
Column
έέ& ,
<
έέ, -
DateTime
έέ- 5
>
έέ5 6
(
έέ6 7
type
έέ7 ;
:
έέ; <
$str
έέ= W
,
έέW X
nullable
έέY a
:
έέa b
false
έέc h
)
έέh i
,
έέi j
	CreatedBy
ήή 
=
ήή 
table
ήή  %
.
ήή% &
Column
ήή& ,
<
ήή, -
string
ήή- 3
>
ήή3 4
(
ήή4 5
type
ήή5 9
:
ήή9 :
$str
ήή; A
,
ήήA B
nullable
ήήC K
:
ήήK L
true
ήήM Q
)
ήήQ R
,
ήήR S
	UpdatedAt
ίί 
=
ίί 
table
ίί  %
.
ίί% &
Column
ίί& ,
<
ίί, -
DateTime
ίί- 5
>
ίί5 6
(
ίί6 7
type
ίί7 ;
:
ίί; <
$str
ίί= W
,
ίίW X
nullable
ίίY a
:
ίίa b
true
ίίc g
)
ίίg h
,
ίίh i
	UpdatedBy
ΰΰ 
=
ΰΰ 
table
ΰΰ  %
.
ΰΰ% &
Column
ΰΰ& ,
<
ΰΰ, -
string
ΰΰ- 3
>
ΰΰ3 4
(
ΰΰ4 5
type
ΰΰ5 9
:
ΰΰ9 :
$str
ΰΰ; A
,
ΰΰA B
nullable
ΰΰC K
:
ΰΰK L
true
ΰΰM Q
)
ΰΰQ R
,
ΰΰR S
IsActive
αα 
=
αα 
table
αα $
.
αα$ %
Column
αα% +
<
αα+ ,
bool
αα, 0
>
αα0 1
(
αα1 2
type
αα2 6
:
αα6 7
$str
αα8 A
,
ααA B
nullable
ααC K
:
ααK L
false
ααM R
)
ααR S
,
ααS T
	IsDeleted
ββ 
=
ββ 
table
ββ  %
.
ββ% &
Column
ββ& ,
<
ββ, -
bool
ββ- 1
>
ββ1 2
(
ββ2 3
type
ββ3 7
:
ββ7 8
$str
ββ9 B
,
ββB C
nullable
ββD L
:
ββL M
false
ββN S
)
ββS T
,
ββT U
	DeletedAt
γγ 
=
γγ 
table
γγ  %
.
γγ% &
Column
γγ& ,
<
γγ, -
DateTime
γγ- 5
>
γγ5 6
(
γγ6 7
type
γγ7 ;
:
γγ; <
$str
γγ= W
,
γγW X
nullable
γγY a
:
γγa b
true
γγc g
)
γγg h
}
δδ 
,
δδ 
constraints
εε 
:
εε 
table
εε "
=>
εε# %
{
ζζ 
table
ηη 
.
ηη 

PrimaryKey
ηη $
(
ηη$ %
$str
ηη% =
,
ηη= >
x
ηη? @
=>
ηηA C
x
ηηD E
.
ηηE F
Id
ηηF H
)
ηηH I
;
ηηI J
table
θθ 
.
θθ 

ForeignKey
θθ $
(
θθ$ %
name
ιι 
:
ιι 
$str
ιι L
,
ιιL M
column
κκ 
:
κκ 
x
κκ  !
=>
κκ" $
x
κκ% &
.
κκ& '
FromStatusId
κκ' 3
,
κκ3 4
principalTable
λλ &
:
λλ& '
$str
λλ( 2
,
λλ2 3
principalColumn
μμ '
:
μμ' (
$str
μμ) -
,
μμ- .
onDelete
νν  
:
νν  !
ReferentialAction
νν" 3
.
νν3 4
Restrict
νν4 <
)
νν< =
;
νν= >
table
ξξ 
.
ξξ 

ForeignKey
ξξ $
(
ξξ$ %
name
οο 
:
οο 
$str
οο J
,
οοJ K
column
ππ 
:
ππ 
x
ππ  !
=>
ππ" $
x
ππ% &
.
ππ& '

ToStatusId
ππ' 1
,
ππ1 2
principalTable
ρρ &
:
ρρ& '
$str
ρρ( 2
,
ρρ2 3
principalColumn
ςς '
:
ςς' (
$str
ςς) -
,
ςς- .
onDelete
σσ  
:
σσ  !
ReferentialAction
σσ" 3
.
σσ3 4
Restrict
σσ4 <
)
σσ< =
;
σσ= >
table
ττ 
.
ττ 

ForeignKey
ττ $
(
ττ$ %
name
υυ 
:
υυ 
$str
υυ K
,
υυK L
column
φφ 
:
φφ 
x
φφ  !
=>
φφ" $
x
φφ% &
.
φφ& '

WorkflowId
φφ' 1
,
φφ1 2
principalTable
χχ &
:
χχ& '
$str
χχ( 3
,
χχ3 4
principalColumn
ψψ '
:
ψψ' (
$str
ψψ) -
,
ψψ- .
onDelete
ωω  
:
ωω  !
ReferentialAction
ωω" 3
.
ωω3 4
Cascade
ωω4 ;
)
ωω; <
;
ωω< =
}
ϊϊ 
)
ϊϊ 
;
ϊϊ 
migrationBuilder
όό 
.
όό 
CreateTable
όό (
(
όό( )
name
ύύ 
:
ύύ 
$str
ύύ "
,
ύύ" #
columns
ώώ 
:
ώώ 
table
ώώ 
=>
ώώ !
new
ώώ" %
{
ÿÿ 
Id
€€ 
=
€€ 
table
€€ 
.
€€ 
Column
€€ %
<
€€% &
int
€€& )
>
€€) *
(
€€* +
type
€€+ /
:
€€/ 0
$str
€€1 :
,
€€: ;
nullable
€€< D
:
€€D E
false
€€F K
)
€€K L
.
 

Annotation
 #
(
# $
$str
$ D
,
D E+
NpgsqlValueGenerationStrategy
F c
.
c d%
IdentityByDefaultColumn
d {
)
{ |
,
| }
GroupId
‚‚ 
=
‚‚ 
table
‚‚ #
.
‚‚# $
Column
‚‚$ *
<
‚‚* +
int
‚‚+ .
>
‚‚. /
(
‚‚/ 0
type
‚‚0 4
:
‚‚4 5
$str
‚‚6 ?
,
‚‚? @
nullable
‚‚A I
:
‚‚I J
false
‚‚K P
)
‚‚P Q
,
‚‚Q R
RoleId
ƒƒ 
=
ƒƒ 
table
ƒƒ "
.
ƒƒ" #
Column
ƒƒ# )
<
ƒƒ) *
int
ƒƒ* -
>
ƒƒ- .
(
ƒƒ. /
type
ƒƒ/ 3
:
ƒƒ3 4
$str
ƒƒ5 >
,
ƒƒ> ?
nullable
ƒƒ@ H
:
ƒƒH I
false
ƒƒJ O
)
ƒƒO P
,
ƒƒP Q
	CreatedAt
„„ 
=
„„ 
table
„„  %
.
„„% &
Column
„„& ,
<
„„, -
DateTime
„„- 5
>
„„5 6
(
„„6 7
type
„„7 ;
:
„„; <
$str
„„= W
,
„„W X
nullable
„„Y a
:
„„a b
false
„„c h
)
„„h i
,
„„i j
	CreatedBy
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
……, -
string
……- 3
>
……3 4
(
……4 5
type
……5 9
:
……9 :
$str
……; A
,
……A B
nullable
……C K
:
……K L
true
……M Q
)
……Q R
,
……R S
	UpdatedAt
†† 
=
†† 
table
††  %
.
††% &
Column
††& ,
<
††, -
DateTime
††- 5
>
††5 6
(
††6 7
type
††7 ;
:
††; <
$str
††= W
,
††W X
nullable
††Y a
:
††a b
true
††c g
)
††g h
,
††h i
	UpdatedBy
‡‡ 
=
‡‡ 
table
‡‡  %
.
‡‡% &
Column
‡‡& ,
<
‡‡, -
string
‡‡- 3
>
‡‡3 4
(
‡‡4 5
type
‡‡5 9
:
‡‡9 :
$str
‡‡; A
,
‡‡A B
nullable
‡‡C K
:
‡‡K L
true
‡‡M Q
)
‡‡Q R
,
‡‡R S
IsActive
 
=
 
table
 $
.
$ %
Column
% +
<
+ ,
bool
, 0
>
0 1
(
1 2
type
2 6
:
6 7
$str
8 A
,
A B
nullable
C K
:
K L
false
M R
)
R S
,
S T
	IsDeleted
‰‰ 
=
‰‰ 
table
‰‰  %
.
‰‰% &
Column
‰‰& ,
<
‰‰, -
bool
‰‰- 1
>
‰‰1 2
(
‰‰2 3
type
‰‰3 7
:
‰‰7 8
$str
‰‰9 B
,
‰‰B C
nullable
‰‰D L
:
‰‰L M
false
‰‰N S
)
‰‰S T
,
‰‰T U
	DeletedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
true
c g
)
g h
}
‹‹ 
,
‹‹ 
constraints
 
:
 
table
 "
=>
# %
{
 
table
 
.
 

PrimaryKey
 $
(
$ %
$str
% 4
,
4 5
x
6 7
=>
8 :
x
; <
.
< =
Id
= ?
)
? @
;
@ A
table
 
.
 

ForeignKey
 $
(
$ %
name
 
:
 
$str
 <
,
< =
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
‘‘& '
GroupId
‘‘' .
,
‘‘. /
principalTable
’’ &
:
’’& '
$str
’’( 0
,
’’0 1
principalColumn
““ '
:
““' (
$str
““) -
,
““- .
onDelete
””  
:
””  !
ReferentialAction
””" 3
.
””3 4
Cascade
””4 ;
)
””; <
;
””< =
table
•• 
.
•• 

ForeignKey
•• $
(
••$ %
name
–– 
:
–– 
$str
–– :
,
––: ;
column
—— 
:
—— 
x
——  !
=>
——" $
x
——% &
.
——& '
RoleId
——' -
,
——- .
principalTable
 &
:
& '
$str
( /
,
/ 0
principalColumn
™™ '
:
™™' (
$str
™™) -
,
™™- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
}
›› 
)
›› 
;
›› 
migrationBuilder
 
.
 
CreateTable
 (
(
( )
name
 
:
 
$str
 $
,
$ %
columns
 
:
 
table
 
=>
 !
new
" %
{
   
Id
΅΅ 
=
΅΅ 
table
΅΅ 
.
΅΅ 
Column
΅΅ %
<
΅΅% &
int
΅΅& )
>
΅΅) *
(
΅΅* +
type
΅΅+ /
:
΅΅/ 0
$str
΅΅1 :
,
΅΅: ;
nullable
΅΅< D
:
΅΅D E
false
΅΅F K
)
΅΅K L
.
ΆΆ 

Annotation
ΆΆ #
(
ΆΆ# $
$str
ΆΆ$ D
,
ΆΆD E+
NpgsqlValueGenerationStrategy
ΆΆF c
.
ΆΆc d%
IdentityByDefaultColumn
ΆΆd {
)
ΆΆ{ |
,
ΆΆ| }
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
¤¤ 
=
¤¤ 
table
¤¤ #
.
¤¤# $
Column
¤¤$ *
<
¤¤* +
int
¤¤+ .
>
¤¤. /
(
¤¤/ 0
type
¤¤0 4
:
¤¤4 5
$str
¤¤6 ?
,
¤¤? @
nullable
¤¤A I
:
¤¤I J
false
¤¤K P
)
¤¤P Q
,
¤¤Q R
	CreatedAt
¥¥ 
=
¥¥ 
table
¥¥  %
.
¥¥% &
Column
¥¥& ,
<
¥¥, -
DateTime
¥¥- 5
>
¥¥5 6
(
¥¥6 7
type
¥¥7 ;
:
¥¥; <
$str
¥¥= W
,
¥¥W X
nullable
¥¥Y a
:
¥¥a b
false
¥¥c h
)
¥¥h i
,
¥¥i j
	CreatedBy
¦¦ 
=
¦¦ 
table
¦¦  %
.
¦¦% &
Column
¦¦& ,
<
¦¦, -
string
¦¦- 3
>
¦¦3 4
(
¦¦4 5
type
¦¦5 9
:
¦¦9 :
$str
¦¦; A
,
¦¦A B
nullable
¦¦C K
:
¦¦K L
true
¦¦M Q
)
¦¦Q R
,
¦¦R S
	UpdatedAt
§§ 
=
§§ 
table
§§  %
.
§§% &
Column
§§& ,
<
§§, -
DateTime
§§- 5
>
§§5 6
(
§§6 7
type
§§7 ;
:
§§; <
$str
§§= W
,
§§W X
nullable
§§Y a
:
§§a b
true
§§c g
)
§§g h
,
§§h i
	UpdatedBy
¨¨ 
=
¨¨ 
table
¨¨  %
.
¨¨% &
Column
¨¨& ,
<
¨¨, -
string
¨¨- 3
>
¨¨3 4
(
¨¨4 5
type
¨¨5 9
:
¨¨9 :
$str
¨¨; A
,
¨¨A B
nullable
¨¨C K
:
¨¨K L
true
¨¨M Q
)
¨¨Q R
,
¨¨R S
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
ªª 
=
ªª 
table
ªª  %
.
ªª% &
Column
ªª& ,
<
ªª, -
bool
ªª- 1
>
ªª1 2
(
ªª2 3
type
ªª3 7
:
ªª7 8
$str
ªª9 B
,
ªªB C
nullable
ªªD L
:
ªªL M
false
ªªN S
)
ªªS T
,
ªªT U
	DeletedAt
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
««a b
true
««c g
)
««g h
}
¬¬ 
,
¬¬ 
constraints
­­ 
:
­­ 
table
­­ "
=>
­­# %
{
®® 
table
―― 
.
―― 

PrimaryKey
―― $
(
――$ %
$str
――% 6
,
――6 7
x
――8 9
=>
――: <
x
――= >
.
――> ?
Id
――? A
)
――A B
;
――B C
table
°° 
.
°° 

ForeignKey
°° $
(
°°$ %
name
±± 
:
±± 
$str
±± >
,
±±> ?
column
²² 
:
²² 
x
²²  !
=>
²²" $
x
²²% &
.
²²& '
GroupId
²²' .
,
²². /
principalTable
³³ &
:
³³& '
$str
³³( 0
,
³³0 1
principalColumn
΄΄ '
:
΄΄' (
$str
΄΄) -
,
΄΄- .
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
¶¶ 
.
¶¶ 

ForeignKey
¶¶ $
(
¶¶$ %
name
·· 
:
·· 
$str
·· <
,
··< =
column
ΈΈ 
:
ΈΈ 
x
ΈΈ  !
=>
ΈΈ" $
x
ΈΈ% &
.
ΈΈ& '
UserId
ΈΈ' -
,
ΈΈ- .
principalTable
ΉΉ &
:
ΉΉ& '
$str
ΉΉ( /
,
ΉΉ/ 0
principalColumn
ΊΊ '
:
ΊΊ' (
$str
ΊΊ) -
,
ΊΊ- .
onDelete
»»  
:
»»  !
ReferentialAction
»»" 3
.
»»3 4
Cascade
»»4 ;
)
»»; <
;
»»< =
}
ΌΌ 
)
ΌΌ 
;
ΌΌ 
migrationBuilder
ΎΎ 
.
ΎΎ 
CreateTable
ΎΎ (
(
ΎΎ( )
name
ΏΏ 
:
ΏΏ 
$str
ΏΏ &
,
ΏΏ& '
columns
ΐΐ 
:
ΐΐ 
table
ΐΐ 
=>
ΐΐ !
new
ΐΐ" %
{
ΑΑ 
Id
ΒΒ 
=
ΒΒ 
table
ΒΒ 
.
ΒΒ 
Column
ΒΒ %
<
ΒΒ% &
int
ΒΒ& )
>
ΒΒ) *
(
ΒΒ* +
type
ΒΒ+ /
:
ΒΒ/ 0
$str
ΒΒ1 :
,
ΒΒ: ;
nullable
ΒΒ< D
:
ΒΒD E
false
ΒΒF K
)
ΒΒK L
.
ΓΓ 

Annotation
ΓΓ #
(
ΓΓ# $
$str
ΓΓ$ D
,
ΓΓD E+
NpgsqlValueGenerationStrategy
ΓΓF c
.
ΓΓc d%
IdentityByDefaultColumn
ΓΓd {
)
ΓΓ{ |
,
ΓΓ| }
	ProjectId
ΔΔ 
=
ΔΔ 
table
ΔΔ  %
.
ΔΔ% &
Column
ΔΔ& ,
<
ΔΔ, -
int
ΔΔ- 0
>
ΔΔ0 1
(
ΔΔ1 2
type
ΔΔ2 6
:
ΔΔ6 7
$str
ΔΔ8 A
,
ΔΔA B
nullable
ΔΔC K
:
ΔΔK L
false
ΔΔM R
)
ΔΔR S
,
ΔΔS T
UserId
ΕΕ 
=
ΕΕ 
table
ΕΕ "
.
ΕΕ" #
Column
ΕΕ# )
<
ΕΕ) *
int
ΕΕ* -
>
ΕΕ- .
(
ΕΕ. /
type
ΕΕ/ 3
:
ΕΕ3 4
$str
ΕΕ5 >
,
ΕΕ> ?
nullable
ΕΕ@ H
:
ΕΕH I
false
ΕΕJ O
)
ΕΕO P
,
ΕΕP Q
SpecificRoleId
ΖΖ "
=
ΖΖ# $
table
ΖΖ% *
.
ΖΖ* +
Column
ΖΖ+ 1
<
ΖΖ1 2
int
ΖΖ2 5
>
ΖΖ5 6
(
ΖΖ6 7
type
ΖΖ7 ;
:
ΖΖ; <
$str
ΖΖ= F
,
ΖΖF G
nullable
ΖΖH P
:
ΖΖP Q
true
ΖΖR V
)
ΖΖV W
,
ΖΖW X
	CreatedAt
ΗΗ 
=
ΗΗ 
table
ΗΗ  %
.
ΗΗ% &
Column
ΗΗ& ,
<
ΗΗ, -
DateTime
ΗΗ- 5
>
ΗΗ5 6
(
ΗΗ6 7
type
ΗΗ7 ;
:
ΗΗ; <
$str
ΗΗ= W
,
ΗΗW X
nullable
ΗΗY a
:
ΗΗa b
false
ΗΗc h
)
ΗΗh i
,
ΗΗi j
	CreatedBy
ΘΘ 
=
ΘΘ 
table
ΘΘ  %
.
ΘΘ% &
Column
ΘΘ& ,
<
ΘΘ, -
string
ΘΘ- 3
>
ΘΘ3 4
(
ΘΘ4 5
type
ΘΘ5 9
:
ΘΘ9 :
$str
ΘΘ; A
,
ΘΘA B
nullable
ΘΘC K
:
ΘΘK L
true
ΘΘM Q
)
ΘΘQ R
,
ΘΘR S
	UpdatedAt
ΙΙ 
=
ΙΙ 
table
ΙΙ  %
.
ΙΙ% &
Column
ΙΙ& ,
<
ΙΙ, -
DateTime
ΙΙ- 5
>
ΙΙ5 6
(
ΙΙ6 7
type
ΙΙ7 ;
:
ΙΙ; <
$str
ΙΙ= W
,
ΙΙW X
nullable
ΙΙY a
:
ΙΙa b
true
ΙΙc g
)
ΙΙg h
,
ΙΙh i
	UpdatedBy
ΚΚ 
=
ΚΚ 
table
ΚΚ  %
.
ΚΚ% &
Column
ΚΚ& ,
<
ΚΚ, -
string
ΚΚ- 3
>
ΚΚ3 4
(
ΚΚ4 5
type
ΚΚ5 9
:
ΚΚ9 :
$str
ΚΚ; A
,
ΚΚA B
nullable
ΚΚC K
:
ΚΚK L
true
ΚΚM Q
)
ΚΚQ R
,
ΚΚR S
IsActive
ΛΛ 
=
ΛΛ 
table
ΛΛ $
.
ΛΛ$ %
Column
ΛΛ% +
<
ΛΛ+ ,
bool
ΛΛ, 0
>
ΛΛ0 1
(
ΛΛ1 2
type
ΛΛ2 6
:
ΛΛ6 7
$str
ΛΛ8 A
,
ΛΛA B
nullable
ΛΛC K
:
ΛΛK L
false
ΛΛM R
)
ΛΛR S
,
ΛΛS T
	IsDeleted
ΜΜ 
=
ΜΜ 
table
ΜΜ  %
.
ΜΜ% &
Column
ΜΜ& ,
<
ΜΜ, -
bool
ΜΜ- 1
>
ΜΜ1 2
(
ΜΜ2 3
type
ΜΜ3 7
:
ΜΜ7 8
$str
ΜΜ9 B
,
ΜΜB C
nullable
ΜΜD L
:
ΜΜL M
false
ΜΜN S
)
ΜΜS T
,
ΜΜT U
	DeletedAt
ΝΝ 
=
ΝΝ 
table
ΝΝ  %
.
ΝΝ% &
Column
ΝΝ& ,
<
ΝΝ, -
DateTime
ΝΝ- 5
>
ΝΝ5 6
(
ΝΝ6 7
type
ΝΝ7 ;
:
ΝΝ; <
$str
ΝΝ= W
,
ΝΝW X
nullable
ΝΝY a
:
ΝΝa b
true
ΝΝc g
)
ΝΝg h
}
ΞΞ 
,
ΞΞ 
constraints
ΟΟ 
:
ΟΟ 
table
ΟΟ "
=>
ΟΟ# %
{
ΠΠ 
table
ΡΡ 
.
ΡΡ 

PrimaryKey
ΡΡ $
(
ΡΡ$ %
$str
ΡΡ% 8
,
ΡΡ8 9
x
ΡΡ: ;
=>
ΡΡ< >
x
ΡΡ? @
.
ΡΡ@ A
Id
ΡΡA C
)
ΡΡC D
;
ΡΡD E
table
ÒÒ 
.
ÒÒ 

ForeignKey
ÒÒ $
(
ÒÒ$ %
name
ΣΣ 
:
ΣΣ 
$str
ΣΣ D
,
ΣΣD E
column
ΤΤ 
:
ΤΤ 
x
ΤΤ  !
=>
ΤΤ" $
x
ΤΤ% &
.
ΤΤ& '
	ProjectId
ΤΤ' 0
,
ΤΤ0 1
principalTable
ΥΥ &
:
ΥΥ& '
$str
ΥΥ( 2
,
ΥΥ2 3
principalColumn
ΦΦ '
:
ΦΦ' (
$str
ΦΦ) -
,
ΦΦ- .
onDelete
ΧΧ  
:
ΧΧ  !
ReferentialAction
ΧΧ" 3
.
ΧΧ3 4
Cascade
ΧΧ4 ;
)
ΧΧ; <
;
ΧΧ< =
table
ΨΨ 
.
ΨΨ 

ForeignKey
ΨΨ $
(
ΨΨ$ %
name
ΩΩ 
:
ΩΩ 
$str
ΩΩ >
,
ΩΩ> ?
column
ΪΪ 
:
ΪΪ 
x
ΪΪ  !
=>
ΪΪ" $
x
ΪΪ% &
.
ΪΪ& '
UserId
ΪΪ' -
,
ΪΪ- .
principalTable
ΫΫ &
:
ΫΫ& '
$str
ΫΫ( /
,
ΫΫ/ 0
principalColumn
άά '
:
άά' (
$str
άά) -
,
άά- .
onDelete
έέ  
:
έέ  !
ReferentialAction
έέ" 3
.
έέ3 4
Cascade
έέ4 ;
)
έέ; <
;
έέ< =
}
ήή 
)
ήή 
;
ήή 
migrationBuilder
ΰΰ 
.
ΰΰ 
CreateTable
ΰΰ (
(
ΰΰ( )
name
αα 
:
αα 
$str
αα 
,
αα  
columns
ββ 
:
ββ 
table
ββ 
=>
ββ !
new
ββ" %
{
γγ 
Id
δδ 
=
δδ 
table
δδ 
.
δδ 
Column
δδ %
<
δδ% &
int
δδ& )
>
δδ) *
(
δδ* +
type
δδ+ /
:
δδ/ 0
$str
δδ1 :
,
δδ: ;
nullable
δδ< D
:
δδD E
false
δδF K
)
δδK L
.
εε 

Annotation
εε #
(
εε# $
$str
εε$ D
,
εεD E+
NpgsqlValueGenerationStrategy
εεF c
.
εεc d%
IdentityByDefaultColumn
εεd {
)
εε{ |
,
εε| }
TicketNumber
ζζ  
=
ζζ! "
table
ζζ# (
.
ζζ( )
Column
ζζ) /
<
ζζ/ 0
string
ζζ0 6
>
ζζ6 7
(
ζζ7 8
type
ζζ8 <
:
ζζ< =
$str
ζζ> U
,
ζζU V
	maxLength
ζζW `
:
ζζ` a
$num
ζζb d
,
ζζd e
nullable
ζζf n
:
ζζn o
false
ζζp u
)
ζζu v
,
ζζv w
Title
ηη 
=
ηη 
table
ηη !
.
ηη! "
Column
ηη" (
<
ηη( )
string
ηη) /
>
ηη/ 0
(
ηη0 1
type
ηη1 5
:
ηη5 6
$str
ηη7 =
,
ηη= >
nullable
ηη? G
:
ηηG H
false
ηηI N
)
ηηN O
,
ηηO P
Description
θθ 
=
θθ  !
table
θθ" '
.
θθ' (
Column
θθ( .
<
θθ. /
string
θθ/ 5
>
θθ5 6
(
θθ6 7
type
θθ7 ;
:
θθ; <
$str
θθ= C
,
θθC D
nullable
θθE M
:
θθM N
false
θθO T
)
θθT U
,
θθU V
	ProjectId
ιι 
=
ιι 
table
ιι  %
.
ιι% &
Column
ιι& ,
<
ιι, -
int
ιι- 0
>
ιι0 1
(
ιι1 2
type
ιι2 6
:
ιι6 7
$str
ιι8 A
,
ιιA B
nullable
ιιC K
:
ιιK L
false
ιιM R
)
ιιR S
,
ιιS T

CategoryId
κκ 
=
κκ  
table
κκ! &
.
κκ& '
Column
κκ' -
<
κκ- .
int
κκ. 1
>
κκ1 2
(
κκ2 3
type
κκ3 7
:
κκ7 8
$str
κκ9 B
,
κκB C
nullable
κκD L
:
κκL M
false
κκN S
)
κκS T
,
κκT U
TypeId
λλ 
=
λλ 
table
λλ "
.
λλ" #
Column
λλ# )
<
λλ) *
int
λλ* -
>
λλ- .
(
λλ. /
type
λλ/ 3
:
λλ3 4
$str
λλ5 >
,
λλ> ?
nullable
λλ@ H
:
λλH I
false
λλJ O
)
λλO P
,
λλP Q
StatusId
μμ 
=
μμ 
table
μμ $
.
μμ$ %
Column
μμ% +
<
μμ+ ,
int
μμ, /
>
μμ/ 0
(
μμ0 1
type
μμ1 5
:
μμ5 6
$str
μμ7 @
,
μμ@ A
nullable
μμB J
:
μμJ K
false
μμL Q
)
μμQ R
,
μμR S

PriorityId
νν 
=
νν  
table
νν! &
.
νν& '
Column
νν' -
<
νν- .
int
νν. 1
>
νν1 2
(
νν2 3
type
νν3 7
:
νν7 8
$str
νν9 B
,
ννB C
nullable
ννD L
:
ννL M
false
ννN S
)
ννS T
,
ννT U
RequesterUserId
ξξ #
=
ξξ$ %
table
ξξ& +
.
ξξ+ ,
Column
ξξ, 2
<
ξξ2 3
int
ξξ3 6
>
ξξ6 7
(
ξξ7 8
type
ξξ8 <
:
ξξ< =
$str
ξξ> G
,
ξξG H
nullable
ξξI Q
:
ξξQ R
false
ξξS X
)
ξξX Y
,
ξξY Z
AssignedUserId
οο "
=
οο# $
table
οο% *
.
οο* +
Column
οο+ 1
<
οο1 2
int
οο2 5
>
οο5 6
(
οο6 7
type
οο7 ;
:
οο; <
$str
οο= F
,
οοF G
nullable
οοH P
:
οοP Q
true
οοR V
)
οοV W
,
οοW X
AssignedGroupId
ππ #
=
ππ$ %
table
ππ& +
.
ππ+ ,
Column
ππ, 2
<
ππ2 3
int
ππ3 6
>
ππ6 7
(
ππ7 8
type
ππ8 <
:
ππ< =
$str
ππ> G
,
ππG H
nullable
ππI Q
:
ππQ R
true
ππS W
)
ππW X
,
ππX Y
	CreatedAt
ρρ 
=
ρρ 
table
ρρ  %
.
ρρ% &
Column
ρρ& ,
<
ρρ, -
DateTime
ρρ- 5
>
ρρ5 6
(
ρρ6 7
type
ρρ7 ;
:
ρρ; <
$str
ρρ= W
,
ρρW X
nullable
ρρY a
:
ρρa b
false
ρρc h
)
ρρh i
,
ρρi j
	CreatedBy
ςς 
=
ςς 
table
ςς  %
.
ςς% &
Column
ςς& ,
<
ςς, -
string
ςς- 3
>
ςς3 4
(
ςς4 5
type
ςς5 9
:
ςς9 :
$str
ςς; A
,
ςςA B
nullable
ςςC K
:
ςςK L
true
ςςM Q
)
ςςQ R
,
ςςR S
	UpdatedAt
σσ 
=
σσ 
table
σσ  %
.
σσ% &
Column
σσ& ,
<
σσ, -
DateTime
σσ- 5
>
σσ5 6
(
σσ6 7
type
σσ7 ;
:
σσ; <
$str
σσ= W
,
σσW X
nullable
σσY a
:
σσa b
true
σσc g
)
σσg h
,
σσh i
	UpdatedBy
ττ 
=
ττ 
table
ττ  %
.
ττ% &
Column
ττ& ,
<
ττ, -
string
ττ- 3
>
ττ3 4
(
ττ4 5
type
ττ5 9
:
ττ9 :
$str
ττ; A
,
ττA B
nullable
ττC K
:
ττK L
true
ττM Q
)
ττQ R
,
ττR S
IsActive
υυ 
=
υυ 
table
υυ $
.
υυ$ %
Column
υυ% +
<
υυ+ ,
bool
υυ, 0
>
υυ0 1
(
υυ1 2
type
υυ2 6
:
υυ6 7
$str
υυ8 A
,
υυA B
nullable
υυC K
:
υυK L
false
υυM R
)
υυR S
,
υυS T
	IsDeleted
φφ 
=
φφ 
table
φφ  %
.
φφ% &
Column
φφ& ,
<
φφ, -
bool
φφ- 1
>
φφ1 2
(
φφ2 3
type
φφ3 7
:
φφ7 8
$str
φφ9 B
,
φφB C
nullable
φφD L
:
φφL M
false
φφN S
)
φφS T
,
φφT U
	DeletedAt
χχ 
=
χχ 
table
χχ  %
.
χχ% &
Column
χχ& ,
<
χχ, -
DateTime
χχ- 5
>
χχ5 6
(
χχ6 7
type
χχ7 ;
:
χχ; <
$str
χχ= W
,
χχW X
nullable
χχY a
:
χχa b
true
χχc g
)
χχg h
}
ψψ 
,
ψψ 
constraints
ωω 
:
ωω 
table
ωω "
=>
ωω# %
{
ϊϊ 
table
ϋϋ 
.
ϋϋ 

PrimaryKey
ϋϋ $
(
ϋϋ$ %
$str
ϋϋ% 1
,
ϋϋ1 2
x
ϋϋ3 4
=>
ϋϋ5 7
x
ϋϋ8 9
.
ϋϋ9 :
Id
ϋϋ: <
)
ϋϋ< =
;
ϋϋ= >
table
όό 
.
όό 

ForeignKey
όό $
(
όό$ %
name
ύύ 
:
ύύ 
$str
ύύ @
,
ύύ@ A
column
ώώ 
:
ώώ 
x
ώώ  !
=>
ώώ" $
x
ώώ% &
.
ώώ& '

CategoryId
ώώ' 1
,
ώώ1 2
principalTable
ÿÿ &
:
ÿÿ& '
$str
ÿÿ( 4
,
ÿÿ4 5
principalColumn
€€ '
:
€€' (
$str
€€) -
,
€€- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
table
‚‚ 
.
‚‚ 

ForeignKey
‚‚ $
(
‚‚$ %
name
ƒƒ 
:
ƒƒ 
$str
ƒƒ A
,
ƒƒA B
column
„„ 
:
„„ 
x
„„  !
=>
„„" $
x
„„% &
.
„„& '
AssignedGroupId
„„' 6
,
„„6 7
principalTable
…… &
:
……& '
$str
……( 0
,
……0 1
principalColumn
†† '
:
††' (
$str
††) -
)
††- .
;
††. /
table
‡‡ 
.
‡‡ 

ForeignKey
‡‡ $
(
‡‡$ %
name
 
:
 
$str
 @
,
@ A
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
‰‰& '

PriorityId
‰‰' 1
,
‰‰1 2
principalTable
 &
:
& '
$str
( 4
,
4 5
principalColumn
‹‹ '
:
‹‹' (
$str
‹‹) -
,
‹‹- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
table
 
.
 

ForeignKey
 $
(
$ %
name
 
:
 
$str
 =
,
= >
column
 
:
 
x
  !
=>
" $
x
% &
.
& '
	ProjectId
' 0
,
0 1
principalTable
 &
:
& '
$str
( 2
,
2 3
principalColumn
‘‘ '
:
‘‘' (
$str
‘‘) -
,
‘‘- .
onDelete
’’  
:
’’  !
ReferentialAction
’’" 3
.
’’3 4
Cascade
’’4 ;
)
’’; <
;
’’< =
table
““ 
.
““ 

ForeignKey
““ $
(
““$ %
name
”” 
:
”” 
$str
”” <
,
””< =
column
•• 
:
•• 
x
••  !
=>
••" $
x
••% &
.
••& '
StatusId
••' /
,
••/ 0
principalTable
–– &
:
––& '
$str
––( 2
,
––2 3
principalColumn
—— '
:
——' (
$str
——) -
,
——- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
table
™™ 
.
™™ 

ForeignKey
™™ $
(
™™$ %
name
 
:
 
$str
 =
,
= >
column
›› 
:
›› 
x
››  !
=>
››" $
x
››% &
.
››& '
TypeId
››' -
,
››- .
principalTable
 &
:
& '
$str
( 5
,
5 6
principalColumn
 '
:
' (
$str
) -
,
- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
table
 
.
 

ForeignKey
 $
(
$ %
name
   
:
   
$str
   ?
,
  ? @
column
΅΅ 
:
΅΅ 
x
΅΅  !
=>
΅΅" $
x
΅΅% &
.
΅΅& '
AssignedUserId
΅΅' 5
,
΅΅5 6
principalTable
ΆΆ &
:
ΆΆ& '
$str
ΆΆ( /
,
ΆΆ/ 0
principalColumn
££ '
:
££' (
$str
££) -
,
££- .
onDelete
¤¤  
:
¤¤  !
ReferentialAction
¤¤" 3
.
¤¤3 4
SetNull
¤¤4 ;
)
¤¤; <
;
¤¤< =
table
¥¥ 
.
¥¥ 

ForeignKey
¥¥ $
(
¥¥$ %
name
¦¦ 
:
¦¦ 
$str
¦¦ @
,
¦¦@ A
column
§§ 
:
§§ 
x
§§  !
=>
§§" $
x
§§% &
.
§§& '
RequesterUserId
§§' 6
,
§§6 7
principalTable
¨¨ &
:
¨¨& '
$str
¨¨( /
,
¨¨/ 0
principalColumn
©© '
:
©©' (
$str
©©) -
,
©©- .
onDelete
ªª  
:
ªª  !
ReferentialAction
ªª" 3
.
ªª3 4
Restrict
ªª4 <
)
ªª< =
;
ªª= >
}
«« 
)
«« 
;
«« 
migrationBuilder
­­ 
.
­­ 
CreateTable
­­ (
(
­­( )
name
®® 
:
®® 
$str
®® /
,
®®/ 0
columns
―― 
:
―― 
table
―― 
=>
―― !
new
――" %
{
°° 
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
²² 

Annotation
²² #
(
²²# $
$str
²²$ D
,
²²D E+
NpgsqlValueGenerationStrategy
²²F c
.
²²c d%
IdentityByDefaultColumn
²²d {
)
²²{ |
,
²²| }
UserId
³³ 
=
³³ 
table
³³ "
.
³³" #
Column
³³# )
<
³³) *
int
³³* -
>
³³- .
(
³³. /
type
³³/ 3
:
³³3 4
$str
³³5 >
,
³³> ?
nullable
³³@ H
:
³³H I
false
³³J O
)
³³O P
,
³³P Q
PermissionId
΄΄  
=
΄΄! "
table
΄΄# (
.
΄΄( )
Column
΄΄) /
<
΄΄/ 0
int
΄΄0 3
>
΄΄3 4
(
΄΄4 5
type
΄΄5 9
:
΄΄9 :
$str
΄΄; D
,
΄΄D E
nullable
΄΄F N
:
΄΄N O
false
΄΄P U
)
΄΄U V
,
΄΄V W
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
¶¶ 
=
¶¶ 
table
¶¶  %
.
¶¶% &
Column
¶¶& ,
<
¶¶, -
DateTime
¶¶- 5
>
¶¶5 6
(
¶¶6 7
type
¶¶7 ;
:
¶¶; <
$str
¶¶= W
,
¶¶W X
nullable
¶¶Y a
:
¶¶a b
false
¶¶c h
)
¶¶h i
,
¶¶i j
	CreatedBy
·· 
=
·· 
table
··  %
.
··% &
Column
··& ,
<
··, -
string
··- 3
>
··3 4
(
··4 5
type
··5 9
:
··9 :
$str
··; A
,
··A B
nullable
··C K
:
··K L
true
··M Q
)
··Q R
,
··R S
	UpdatedAt
ΈΈ 
=
ΈΈ 
table
ΈΈ  %
.
ΈΈ% &
Column
ΈΈ& ,
<
ΈΈ, -
DateTime
ΈΈ- 5
>
ΈΈ5 6
(
ΈΈ6 7
type
ΈΈ7 ;
:
ΈΈ; <
$str
ΈΈ= W
,
ΈΈW X
nullable
ΈΈY a
:
ΈΈa b
true
ΈΈc g
)
ΈΈg h
,
ΈΈh i
	UpdatedBy
ΉΉ 
=
ΉΉ 
table
ΉΉ  %
.
ΉΉ% &
Column
ΉΉ& ,
<
ΉΉ, -
string
ΉΉ- 3
>
ΉΉ3 4
(
ΉΉ4 5
type
ΉΉ5 9
:
ΉΉ9 :
$str
ΉΉ; A
,
ΉΉA B
nullable
ΉΉC K
:
ΉΉK L
true
ΉΉM Q
)
ΉΉQ R
,
ΉΉR S
IsActive
ΊΊ 
=
ΊΊ 
table
ΊΊ $
.
ΊΊ$ %
Column
ΊΊ% +
<
ΊΊ+ ,
bool
ΊΊ, 0
>
ΊΊ0 1
(
ΊΊ1 2
type
ΊΊ2 6
:
ΊΊ6 7
$str
ΊΊ8 A
,
ΊΊA B
nullable
ΊΊC K
:
ΊΊK L
false
ΊΊM R
)
ΊΊR S
,
ΊΊS T
	IsDeleted
»» 
=
»» 
table
»»  %
.
»»% &
Column
»»& ,
<
»», -
bool
»»- 1
>
»»1 2
(
»»2 3
type
»»3 7
:
»»7 8
$str
»»9 B
,
»»B C
nullable
»»D L
:
»»L M
false
»»N S
)
»»S T
,
»»T U
	DeletedAt
ΌΌ 
=
ΌΌ 
table
ΌΌ  %
.
ΌΌ% &
Column
ΌΌ& ,
<
ΌΌ, -
DateTime
ΌΌ- 5
>
ΌΌ5 6
(
ΌΌ6 7
type
ΌΌ7 ;
:
ΌΌ; <
$str
ΌΌ= W
,
ΌΌW X
nullable
ΌΌY a
:
ΌΌa b
true
ΌΌc g
)
ΌΌg h
}
½½ 
,
½½ 
constraints
ΎΎ 
:
ΎΎ 
table
ΎΎ "
=>
ΎΎ# %
{
ΏΏ 
table
ΐΐ 
.
ΐΐ 

PrimaryKey
ΐΐ $
(
ΐΐ$ %
$str
ΐΐ% A
,
ΐΐA B
x
ΐΐC D
=>
ΐΐE G
x
ΐΐH I
.
ΐΐI J
Id
ΐΐJ L
)
ΐΐL M
;
ΐΐM N
table
ΑΑ 
.
ΑΑ 

ForeignKey
ΑΑ $
(
ΑΑ$ %
name
ΒΒ 
:
ΒΒ 
$str
ΒΒ S
,
ΒΒS T
column
ΓΓ 
:
ΓΓ 
x
ΓΓ  !
=>
ΓΓ" $
x
ΓΓ% &
.
ΓΓ& '
PermissionId
ΓΓ' 3
,
ΓΓ3 4
principalTable
ΔΔ &
:
ΔΔ& '
$str
ΔΔ( 5
,
ΔΔ5 6
principalColumn
ΕΕ '
:
ΕΕ' (
$str
ΕΕ) -
,
ΕΕ- .
onDelete
ΖΖ  
:
ΖΖ  !
ReferentialAction
ΖΖ" 3
.
ΖΖ3 4
Cascade
ΖΖ4 ;
)
ΖΖ; <
;
ΖΖ< =
table
ΗΗ 
.
ΗΗ 

ForeignKey
ΗΗ $
(
ΗΗ$ %
name
ΘΘ 
:
ΘΘ 
$str
ΘΘ G
,
ΘΘG H
column
ΙΙ 
:
ΙΙ 
x
ΙΙ  !
=>
ΙΙ" $
x
ΙΙ% &
.
ΙΙ& '
UserId
ΙΙ' -
,
ΙΙ- .
principalTable
ΚΚ &
:
ΚΚ& '
$str
ΚΚ( /
,
ΚΚ/ 0
principalColumn
ΛΛ '
:
ΛΛ' (
$str
ΛΛ) -
,
ΛΛ- .
onDelete
ΜΜ  
:
ΜΜ  !
ReferentialAction
ΜΜ" 3
.
ΜΜ3 4
Cascade
ΜΜ4 ;
)
ΜΜ; <
;
ΜΜ< =
}
ΝΝ 
)
ΝΝ 
;
ΝΝ 
migrationBuilder
ΟΟ 
.
ΟΟ 
CreateTable
ΟΟ (
(
ΟΟ( )
name
ΠΠ 
:
ΠΠ 
$str
ΠΠ !
,
ΠΠ! "
columns
ΡΡ 
:
ΡΡ 
table
ΡΡ 
=>
ΡΡ !
new
ΡΡ" %
{
ÒÒ 
Id
ΣΣ 
=
ΣΣ 
table
ΣΣ 
.
ΣΣ 
Column
ΣΣ %
<
ΣΣ% &
int
ΣΣ& )
>
ΣΣ) *
(
ΣΣ* +
type
ΣΣ+ /
:
ΣΣ/ 0
$str
ΣΣ1 :
,
ΣΣ: ;
nullable
ΣΣ< D
:
ΣΣD E
false
ΣΣF K
)
ΣΣK L
.
ΤΤ 

Annotation
ΤΤ #
(
ΤΤ# $
$str
ΤΤ$ D
,
ΤΤD E+
NpgsqlValueGenerationStrategy
ΤΤF c
.
ΤΤc d%
IdentityByDefaultColumn
ΤΤd {
)
ΤΤ{ |
,
ΤΤ| }
UserId
ΥΥ 
=
ΥΥ 
table
ΥΥ "
.
ΥΥ" #
Column
ΥΥ# )
<
ΥΥ) *
int
ΥΥ* -
>
ΥΥ- .
(
ΥΥ. /
type
ΥΥ/ 3
:
ΥΥ3 4
$str
ΥΥ5 >
,
ΥΥ> ?
nullable
ΥΥ@ H
:
ΥΥH I
false
ΥΥJ O
)
ΥΥO P
,
ΥΥP Q
RoleId
ΦΦ 
=
ΦΦ 
table
ΦΦ "
.
ΦΦ" #
Column
ΦΦ# )
<
ΦΦ) *
int
ΦΦ* -
>
ΦΦ- .
(
ΦΦ. /
type
ΦΦ/ 3
:
ΦΦ3 4
$str
ΦΦ5 >
,
ΦΦ> ?
nullable
ΦΦ@ H
:
ΦΦH I
false
ΦΦJ O
)
ΦΦO P
,
ΦΦP Q
	CreatedAt
ΧΧ 
=
ΧΧ 
table
ΧΧ  %
.
ΧΧ% &
Column
ΧΧ& ,
<
ΧΧ, -
DateTime
ΧΧ- 5
>
ΧΧ5 6
(
ΧΧ6 7
type
ΧΧ7 ;
:
ΧΧ; <
$str
ΧΧ= W
,
ΧΧW X
nullable
ΧΧY a
:
ΧΧa b
false
ΧΧc h
)
ΧΧh i
,
ΧΧi j
	CreatedBy
ΨΨ 
=
ΨΨ 
table
ΨΨ  %
.
ΨΨ% &
Column
ΨΨ& ,
<
ΨΨ, -
string
ΨΨ- 3
>
ΨΨ3 4
(
ΨΨ4 5
type
ΨΨ5 9
:
ΨΨ9 :
$str
ΨΨ; A
,
ΨΨA B
nullable
ΨΨC K
:
ΨΨK L
true
ΨΨM Q
)
ΨΨQ R
,
ΨΨR S
	UpdatedAt
ΩΩ 
=
ΩΩ 
table
ΩΩ  %
.
ΩΩ% &
Column
ΩΩ& ,
<
ΩΩ, -
DateTime
ΩΩ- 5
>
ΩΩ5 6
(
ΩΩ6 7
type
ΩΩ7 ;
:
ΩΩ; <
$str
ΩΩ= W
,
ΩΩW X
nullable
ΩΩY a
:
ΩΩa b
true
ΩΩc g
)
ΩΩg h
,
ΩΩh i
	UpdatedBy
ΪΪ 
=
ΪΪ 
table
ΪΪ  %
.
ΪΪ% &
Column
ΪΪ& ,
<
ΪΪ, -
string
ΪΪ- 3
>
ΪΪ3 4
(
ΪΪ4 5
type
ΪΪ5 9
:
ΪΪ9 :
$str
ΪΪ; A
,
ΪΪA B
nullable
ΪΪC K
:
ΪΪK L
true
ΪΪM Q
)
ΪΪQ R
,
ΪΪR S
IsActive
ΫΫ 
=
ΫΫ 
table
ΫΫ $
.
ΫΫ$ %
Column
ΫΫ% +
<
ΫΫ+ ,
bool
ΫΫ, 0
>
ΫΫ0 1
(
ΫΫ1 2
type
ΫΫ2 6
:
ΫΫ6 7
$str
ΫΫ8 A
,
ΫΫA B
nullable
ΫΫC K
:
ΫΫK L
false
ΫΫM R
)
ΫΫR S
,
ΫΫS T
	IsDeleted
άά 
=
άά 
table
άά  %
.
άά% &
Column
άά& ,
<
άά, -
bool
άά- 1
>
άά1 2
(
άά2 3
type
άά3 7
:
άά7 8
$str
άά9 B
,
άάB C
nullable
άάD L
:
άάL M
false
άάN S
)
άάS T
,
άάT U
	DeletedAt
έέ 
=
έέ 
table
έέ  %
.
έέ% &
Column
έέ& ,
<
έέ, -
DateTime
έέ- 5
>
έέ5 6
(
έέ6 7
type
έέ7 ;
:
έέ; <
$str
έέ= W
,
έέW X
nullable
έέY a
:
έέa b
true
έέc g
)
έέg h
}
ήή 
,
ήή 
constraints
ίί 
:
ίί 
table
ίί "
=>
ίί# %
{
ΰΰ 
table
αα 
.
αα 

PrimaryKey
αα $
(
αα$ %
$str
αα% 3
,
αα3 4
x
αα5 6
=>
αα7 9
x
αα: ;
.
αα; <
Id
αα< >
)
αα> ?
;
αα? @
table
ββ 
.
ββ 

ForeignKey
ββ $
(
ββ$ %
name
γγ 
:
γγ 
$str
γγ 9
,
γγ9 :
column
δδ 
:
δδ 
x
δδ  !
=>
δδ" $
x
δδ% &
.
δδ& '
RoleId
δδ' -
,
δδ- .
principalTable
εε &
:
εε& '
$str
εε( /
,
εε/ 0
principalColumn
ζζ '
:
ζζ' (
$str
ζζ) -
,
ζζ- .
onDelete
ηη  
:
ηη  !
ReferentialAction
ηη" 3
.
ηη3 4
Cascade
ηη4 ;
)
ηη; <
;
ηη< =
table
θθ 
.
θθ 

ForeignKey
θθ $
(
θθ$ %
name
ιι 
:
ιι 
$str
ιι 9
,
ιι9 :
column
κκ 
:
κκ 
x
κκ  !
=>
κκ" $
x
κκ% &
.
κκ& '
UserId
κκ' -
,
κκ- .
principalTable
λλ &
:
λλ& '
$str
λλ( /
,
λλ/ 0
principalColumn
μμ '
:
μμ' (
$str
μμ) -
,
μμ- .
onDelete
νν  
:
νν  !
ReferentialAction
νν" 3
.
νν3 4
Cascade
νν4 ;
)
νν; <
;
νν< =
}
ξξ 
)
ξξ 
;
ξξ 
migrationBuilder
ππ 
.
ππ 
CreateTable
ππ (
(
ππ( )
name
ρρ 
:
ρρ 
$str
ρρ )
,
ρρ) *
columns
ςς 
:
ςς 
table
ςς 
=>
ςς !
new
ςς" %
{
σσ 
Id
ττ 
=
ττ 
table
ττ 
.
ττ 
Column
ττ %
<
ττ% &
int
ττ& )
>
ττ) *
(
ττ* +
type
ττ+ /
:
ττ/ 0
$str
ττ1 :
,
ττ: ;
nullable
ττ< D
:
ττD E
false
ττF K
)
ττK L
.
υυ 

Annotation
υυ #
(
υυ# $
$str
υυ$ D
,
υυD E+
NpgsqlValueGenerationStrategy
υυF c
.
υυc d%
IdentityByDefaultColumn
υυd {
)
υυ{ |
,
υυ| }
TicketId
φφ 
=
φφ 
table
φφ $
.
φφ$ %
Column
φφ% +
<
φφ+ ,
int
φφ, /
>
φφ/ 0
(
φφ0 1
type
φφ1 5
:
φφ5 6
$str
φφ7 @
,
φφ@ A
nullable
φφB J
:
φφJ K
false
φφL Q
)
φφQ R
,
φφR S
FieldDefinitionId
χχ %
=
χχ& '
table
χχ( -
.
χχ- .
Column
χχ. 4
<
χχ4 5
int
χχ5 8
>
χχ8 9
(
χχ9 :
type
χχ: >
:
χχ> ?
$str
χχ@ I
,
χχI J
nullable
χχK S
:
χχS T
false
χχU Z
)
χχZ [
,
χχ[ \
ValueString
ψψ 
=
ψψ  !
table
ψψ" '
.
ψψ' (
Column
ψψ( .
<
ψψ. /
string
ψψ/ 5
>
ψψ5 6
(
ψψ6 7
type
ψψ7 ;
:
ψψ; <
$str
ψψ= C
,
ψψC D
nullable
ψψE M
:
ψψM N
false
ψψO T
)
ψψT U
,
ψψU V
	ValueText
ωω 
=
ωω 
table
ωω  %
.
ωω% &
Column
ωω& ,
<
ωω, -
string
ωω- 3
>
ωω3 4
(
ωω4 5
type
ωω5 9
:
ωω9 :
$str
ωω; A
,
ωωA B
nullable
ωωC K
:
ωωK L
true
ωωM Q
)
ωωQ R
,
ωωR S
	CreatedAt
ϊϊ 
=
ϊϊ 
table
ϊϊ  %
.
ϊϊ% &
Column
ϊϊ& ,
<
ϊϊ, -
DateTime
ϊϊ- 5
>
ϊϊ5 6
(
ϊϊ6 7
type
ϊϊ7 ;
:
ϊϊ; <
$str
ϊϊ= W
,
ϊϊW X
nullable
ϊϊY a
:
ϊϊa b
false
ϊϊc h
)
ϊϊh i
,
ϊϊi j
	CreatedBy
ϋϋ 
=
ϋϋ 
table
ϋϋ  %
.
ϋϋ% &
Column
ϋϋ& ,
<
ϋϋ, -
string
ϋϋ- 3
>
ϋϋ3 4
(
ϋϋ4 5
type
ϋϋ5 9
:
ϋϋ9 :
$str
ϋϋ; A
,
ϋϋA B
nullable
ϋϋC K
:
ϋϋK L
true
ϋϋM Q
)
ϋϋQ R
,
ϋϋR S
	UpdatedAt
όό 
=
όό 
table
όό  %
.
όό% &
Column
όό& ,
<
όό, -
DateTime
όό- 5
>
όό5 6
(
όό6 7
type
όό7 ;
:
όό; <
$str
όό= W
,
όόW X
nullable
όόY a
:
όόa b
true
όόc g
)
όόg h
,
όόh i
	UpdatedBy
ύύ 
=
ύύ 
table
ύύ  %
.
ύύ% &
Column
ύύ& ,
<
ύύ, -
string
ύύ- 3
>
ύύ3 4
(
ύύ4 5
type
ύύ5 9
:
ύύ9 :
$str
ύύ; A
,
ύύA B
nullable
ύύC K
:
ύύK L
true
ύύM Q
)
ύύQ R
,
ύύR S
IsActive
ώώ 
=
ώώ 
table
ώώ $
.
ώώ$ %
Column
ώώ% +
<
ώώ+ ,
bool
ώώ, 0
>
ώώ0 1
(
ώώ1 2
type
ώώ2 6
:
ώώ6 7
$str
ώώ8 A
,
ώώA B
nullable
ώώC K
:
ώώK L
false
ώώM R
)
ώώR S
,
ώώS T
	IsDeleted
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
ÿÿ, -
bool
ÿÿ- 1
>
ÿÿ1 2
(
ÿÿ2 3
type
ÿÿ3 7
:
ÿÿ7 8
$str
ÿÿ9 B
,
ÿÿB C
nullable
ÿÿD L
:
ÿÿL M
false
ÿÿN S
)
ÿÿS T
,
ÿÿT U
	DeletedAt
€€ 
=
€€ 
table
€€  %
.
€€% &
Column
€€& ,
<
€€, -
DateTime
€€- 5
>
€€5 6
(
€€6 7
type
€€7 ;
:
€€; <
$str
€€= W
,
€€W X
nullable
€€Y a
:
€€a b
true
€€c g
)
€€g h
}
 
,
 
constraints
‚‚ 
:
‚‚ 
table
‚‚ "
=>
‚‚# %
{
ƒƒ 
table
„„ 
.
„„ 

PrimaryKey
„„ $
(
„„$ %
$str
„„% ;
,
„„; <
x
„„= >
=>
„„? A
x
„„B C
.
„„C D
Id
„„D F
)
„„F G
;
„„G H
table
…… 
.
…… 

ForeignKey
…… $
(
……$ %
name
†† 
:
†† 
$str
†† W
,
††W X
column
‡‡ 
:
‡‡ 
x
‡‡  !
=>
‡‡" $
x
‡‡% &
.
‡‡& '
FieldDefinitionId
‡‡' 8
,
‡‡8 9
principalTable
 &
:
& '
$str
( :
,
: ;
principalColumn
‰‰ '
:
‰‰' (
$str
‰‰) -
,
‰‰- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Restrict
4 <
)
< =
;
= >
table
‹‹ 
.
‹‹ 

ForeignKey
‹‹ $
(
‹‹$ %
name
 
:
 
$str
 E
,
E F
column
 
:
 
x
  !
=>
" $
x
% &
.
& '
TicketId
' /
,
/ 0
principalTable
 &
:
& '
$str
( 1
,
1 2
principalColumn
 '
:
' (
$str
) -
,
- .
onDelete
  
:
  !
ReferentialAction
" 3
.
3 4
Cascade
4 ;
)
; <
;
< =
}
‘‘ 
)
‘‘ 
;
‘‘ 
migrationBuilder
““ 
.
““ 
CreateTable
““ (
(
““( )
name
”” 
:
”” 
$str
”” '
,
””' (
columns
•• 
:
•• 
table
•• 
=>
•• !
new
••" %
{
–– 
Id
—— 
=
—— 
table
—— 
.
—— 
Column
—— %
<
——% &
int
——& )
>
——) *
(
——* +
type
——+ /
:
——/ 0
$str
——1 :
,
——: ;
nullable
——< D
:
——D E
false
——F K
)
——K L
.
 

Annotation
 #
(
# $
$str
$ D
,
D E+
NpgsqlValueGenerationStrategy
F c
.
c d%
IdentityByDefaultColumn
d {
)
{ |
,
| }
TicketId
™™ 
=
™™ 
table
™™ $
.
™™$ %
Column
™™% +
<
™™+ ,
int
™™, /
>
™™/ 0
(
™™0 1
type
™™1 5
:
™™5 6
$str
™™7 @
,
™™@ A
nullable
™™B J
:
™™J K
false
™™L Q
)
™™Q R
,
™™R S
	FieldName
 
=
 
table
  %
.
% &
Column
& ,
<
, -
string
- 3
>
3 4
(
4 5
type
5 9
:
9 :
$str
; A
,
A B
nullable
C K
:
K L
false
M R
)
R S
,
S T
OldValue
›› 
=
›› 
table
›› $
.
››$ %
Column
››% +
<
››+ ,
string
››, 2
>
››2 3
(
››3 4
type
››4 8
:
››8 9
$str
››: @
,
››@ A
nullable
››B J
:
››J K
true
››L P
)
››P Q
,
››Q R
NewValue
 
=
 
table
 $
.
$ %
Column
% +
<
+ ,
string
, 2
>
2 3
(
3 4
type
4 8
:
8 9
$str
: @
,
@ A
nullable
B J
:
J K
true
L P
)
P Q
,
Q R
Action
 
=
 
table
 "
.
" #
Column
# )
<
) *
string
* 0
>
0 1
(
1 2
type
2 6
:
6 7
$str
8 >
,
> ?
nullable
@ H
:
H I
false
J O
)
O P
,
P Q
	CreatedAt
 
=
 
table
  %
.
% &
Column
& ,
<
, -
DateTime
- 5
>
5 6
(
6 7
type
7 ;
:
; <
$str
= W
,
W X
nullable
Y a
:
a b
false
c h
)
h i
,
i j
	CreatedBy
 
=
 
table
  %
.
% &
Column
& ,
<
, -
string
- 3
>
3 4
(
4 5
type
5 9
:
9 :
$str
; A
,
A B
nullable
C K
:
K L
true
M Q
)
Q R
,
R S
	UpdatedAt
   
=
   
table
    %
.
  % &
Column
  & ,
<
  , -
DateTime
  - 5
>
  5 6
(
  6 7
type
  7 ;
:
  ; <
$str
  = W
,
  W X
nullable
  Y a
:
  a b
true
  c g
)
  g h
,
  h i
	UpdatedBy
΅΅ 
=
΅΅ 
table
΅΅  %
.
΅΅% &
Column
΅΅& ,
<
΅΅, -
string
΅΅- 3
>
΅΅3 4
(
΅΅4 5
type
΅΅5 9
:
΅΅9 :
$str
΅΅; A
,
΅΅A B
nullable
΅΅C K
:
΅΅K L
true
΅΅M Q
)
΅΅Q R
,
΅΅R S
IsActive
ΆΆ 
=
ΆΆ 
table
ΆΆ $
.
ΆΆ$ %
Column
ΆΆ% +
<
ΆΆ+ ,
bool
ΆΆ, 0
>
ΆΆ0 1
(
ΆΆ1 2
type
ΆΆ2 6
:
ΆΆ6 7
$str
ΆΆ8 A
,
ΆΆA B
nullable
ΆΆC K
:
ΆΆK L
false
ΆΆM R
)
ΆΆR S
,
ΆΆS T
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
¤¤ 
=
¤¤ 
table
¤¤  %
.
¤¤% &
Column
¤¤& ,
<
¤¤, -
DateTime
¤¤- 5
>
¤¤5 6
(
¤¤6 7
type
¤¤7 ;
:
¤¤; <
$str
¤¤= W
,
¤¤W X
nullable
¤¤Y a
:
¤¤a b
true
¤¤c g
)
¤¤g h
}
¥¥ 
,
¥¥ 
constraints
¦¦ 
:
¦¦ 
table
¦¦ "
=>
¦¦# %
{
§§ 
table
¨¨ 
.
¨¨ 

PrimaryKey
¨¨ $
(
¨¨$ %
$str
¨¨% 9
,
¨¨9 :
x
¨¨; <
=>
¨¨= ?
x
¨¨@ A
.
¨¨A B
Id
¨¨B D
)
¨¨D E
;
¨¨E F
table
©© 
.
©© 

ForeignKey
©© $
(
©©$ %
name
ªª 
:
ªª 
$str
ªª C
,
ªªC D
column
«« 
:
«« 
x
««  !
=>
««" $
x
««% &
.
««& '
TicketId
««' /
,
««/ 0
principalTable
¬¬ &
:
¬¬& '
$str
¬¬( 1
,
¬¬1 2
principalColumn
­­ '
:
­­' (
$str
­­) -
,
­­- .
onDelete
®®  
:
®®  !
ReferentialAction
®®" 3
.
®®3 4
Cascade
®®4 ;
)
®®; <
;
®®< =
}
―― 
)
―― 
;
―― 
migrationBuilder
±± 
.
±± 
CreateIndex
±± (
(
±±( )
name
²² 
:
²² 
$str
²² /
,
²²/ 0
table
³³ 
:
³³ 
$str
³³ )
,
³³) *
column
΄΄ 
:
΄΄ 
$str
΄΄ 
,
΄΄ 
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
·· 
.
·· 
CreateIndex
·· (
(
··( )
name
ΈΈ 
:
ΈΈ 
$str
ΈΈ 9
,
ΈΈ9 :
table
ΉΉ 
:
ΉΉ 
$str
ΉΉ %
,
ΉΉ% &
column
ΊΊ 
:
ΊΊ 
$str
ΊΊ +
)
ΊΊ+ ,
;
ΊΊ, -
migrationBuilder
ΌΌ 
.
ΌΌ 
CreateIndex
ΌΌ (
(
ΌΌ( )
name
½½ 
:
½½ 
$str
½½ @
,
½½@ A
table
ΎΎ 
:
ΎΎ 
$str
ΎΎ ,
,
ΎΎ, -
column
ΏΏ 
:
ΏΏ 
$str
ΏΏ +
)
ΏΏ+ ,
;
ΏΏ, -
migrationBuilder
ΑΑ 
.
ΑΑ 
CreateIndex
ΑΑ (
(
ΑΑ( )
name
ΒΒ 
:
ΒΒ 
$str
ΒΒ /
,
ΒΒ/ 0
table
ΓΓ 
:
ΓΓ 
$str
ΓΓ %
,
ΓΓ% &
column
ΔΔ 
:
ΔΔ 
$str
ΔΔ !
)
ΔΔ! "
;
ΔΔ" #
migrationBuilder
ΖΖ 
.
ΖΖ 
CreateIndex
ΖΖ (
(
ΖΖ( )
name
ΗΗ 
:
ΗΗ 
$str
ΗΗ .
,
ΗΗ. /
table
ΘΘ 
:
ΘΘ 
$str
ΘΘ %
,
ΘΘ% &
column
ΙΙ 
:
ΙΙ 
$str
ΙΙ  
)
ΙΙ  !
;
ΙΙ! "
migrationBuilder
ΛΛ 
.
ΛΛ 
CreateIndex
ΛΛ (
(
ΛΛ( )
name
ΜΜ 
:
ΜΜ 
$str
ΜΜ -
,
ΜΜ- .
table
ΝΝ 
:
ΝΝ 
$str
ΝΝ #
,
ΝΝ# $
column
ΞΞ 
:
ΞΞ 
$str
ΞΞ !
)
ΞΞ! "
;
ΞΞ" #
migrationBuilder
ΠΠ 
.
ΠΠ 
CreateIndex
ΠΠ (
(
ΠΠ( )
name
ΡΡ 
:
ΡΡ 
$str
ΡΡ ,
,
ΡΡ, -
table
ÒÒ 
:
ÒÒ 
$str
ÒÒ #
,
ÒÒ# $
column
ΣΣ 
:
ΣΣ 
$str
ΣΣ  
)
ΣΣ  !
;
ΣΣ! "
migrationBuilder
ΥΥ 
.
ΥΥ 
CreateIndex
ΥΥ (
(
ΥΥ( )
name
ΦΦ 
:
ΦΦ 
$str
ΦΦ .
,
ΦΦ. /
table
ΧΧ 
:
ΧΧ 
$str
ΧΧ 
,
ΧΧ  
column
ΨΨ 
:
ΨΨ 
$str
ΨΨ &
)
ΨΨ& '
;
ΨΨ' (
migrationBuilder
ΪΪ 
.
ΪΪ 
CreateIndex
ΪΪ (
(
ΪΪ( )
name
ΫΫ 
:
ΫΫ 
$str
ΫΫ 7
,
ΫΫ7 8
table
άά 
:
άά 
$str
άά *
,
άά* +
column
έέ 
:
έέ 
$str
έέ $
)
έέ$ %
;
έέ% &
migrationBuilder
ίί 
.
ίί 
CreateIndex
ίί (
(
ίί( )
name
ΰΰ 
:
ΰΰ 
$str
ΰΰ 7
,
ΰΰ7 8
table
αα 
:
αα 
$str
αα ,
,
αα, -
column
ββ 
:
ββ 
$str
ββ "
)
ββ" #
;
ββ# $
migrationBuilder
δδ 
.
δδ 
CreateIndex
δδ (
(
δδ( )
name
εε 
:
εε 
$str
εε 3
,
εε3 4
table
ζζ 
:
ζζ 
$str
ζζ '
,
ζζ' (
column
ηη 
:
ηη 
$str
ηη #
)
ηη# $
;
ηη$ %
migrationBuilder
ιι 
.
ιι 
CreateIndex
ιι (
(
ιι( )
name
κκ 
:
κκ 
$str
κκ 0
,
κκ0 1
table
λλ 
:
λλ 
$str
λλ '
,
λλ' (
column
μμ 
:
μμ 
$str
μμ  
)
μμ  !
;
μμ! "
migrationBuilder
ξξ 
.
ξξ 
CreateIndex
ξξ (
(
ξξ( )
name
οο 
:
οο 
$str
οο 7
,
οο7 8
table
ππ 
:
ππ 
$str
ππ (
,
ππ( )
column
ρρ 
:
ρρ 
$str
ρρ &
)
ρρ& '
;
ρρ' (
migrationBuilder
σσ 
.
σσ 
CreateIndex
σσ (
(
σσ( )
name
ττ 
:
ττ 
$str
ττ 1
,
ττ1 2
table
υυ 
:
υυ 
$str
υυ (
,
υυ( )
column
φφ 
:
φφ 
$str
φφ  
)
φφ  !
;
φφ! "
migrationBuilder
ψψ 
.
ψψ 
CreateIndex
ψψ (
(
ψψ( )
name
ωω 
:
ωω 
$str
ωω 1
,
ωω1 2
table
ϊϊ 
:
ϊϊ 
$str
ϊϊ #
,
ϊϊ# $
column
ϋϋ 
:
ϋϋ 
$str
ϋϋ %
)
ϋϋ% &
;
ϋϋ& '
migrationBuilder
ύύ 
.
ύύ 
CreateIndex
ύύ (
(
ύύ( )
name
ώώ 
:
ώώ 
$str
ώώ >
,
ώώ> ?
table
ÿÿ 
:
ÿÿ 
$str
ÿÿ *
,
ÿÿ* +
column
€€ 
:
€€ 
$str
€€ +
)
€€+ ,
;
€€, -
migrationBuilder
‚‚ 
.
‚‚ 
CreateIndex
‚‚ (
(
‚‚( )
name
ƒƒ 
:
ƒƒ 
$str
ƒƒ G
,
ƒƒG H
table
„„ 
:
„„ 
$str
„„ *
,
„„* +
columns
…… 
:
…… 
new
…… 
[
…… 
]
…… 
{
……  
$str
……! +
,
……+ ,
$str
……- @
}
……A B
,
……B C
unique
†† 
:
†† 
true
†† 
)
†† 
;
†† 
migrationBuilder
 
.
 
CreateIndex
 (
(
( )
name
‰‰ 
:
‰‰ 
$str
‰‰ 3
,
‰‰3 4
table
 
:
 
$str
 (
,
( )
column
‹‹ 
:
‹‹ 
$str
‹‹ "
)
‹‹" #
;
‹‹# $
migrationBuilder
 
.
 
CreateIndex
 (
(
( )
name
 
:
 
$str
 2
,
2 3
table
 
:
 
$str
  
,
  !
column
 
:
 
$str
 )
)
) *
;
* +
migrationBuilder
’’ 
.
’’ 
CreateIndex
’’ (
(
’’( )
name
““ 
:
““ 
$str
““ 1
,
““1 2
table
”” 
:
”” 
$str
””  
,
””  !
column
•• 
:
•• 
$str
•• (
)
••( )
;
••) *
migrationBuilder
—— 
.
—— 
CreateIndex
—— (
(
——( )
name
 
:
 
$str
 -
,
- .
table
™™ 
:
™™ 
$str
™™  
,
™™  !
column
 
:
 
$str
 $
)
$ %
;
% &
migrationBuilder
 
.
 
CreateIndex
 (
(
( )
name
 
:
 
$str
 -
,
- .
table
 
:
 
$str
  
,
  !
column
 
:
 
$str
 $
)
$ %
;
% &
migrationBuilder
΅΅ 
.
΅΅ 
CreateIndex
΅΅ (
(
΅΅( )
name
ΆΆ 
:
ΆΆ 
$str
ΆΆ ,
,
ΆΆ, -
table
££ 
:
££ 
$str
££  
,
££  !
column
¤¤ 
:
¤¤ 
$str
¤¤ #
)
¤¤# $
;
¤¤$ %
migrationBuilder
¦¦ 
.
¦¦ 
CreateIndex
¦¦ (
(
¦¦( )
name
§§ 
:
§§ 
$str
§§ 2
,
§§2 3
table
¨¨ 
:
¨¨ 
$str
¨¨  
,
¨¨  !
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
«« 
.
«« 
CreateIndex
«« (
(
««( )
name
¬¬ 
:
¬¬ 
$str
¬¬ +
,
¬¬+ ,
table
­­ 
:
­­ 
$str
­­  
,
­­  !
column
®® 
:
®® 
$str
®® "
)
®®" #
;
®®# $
migrationBuilder
°° 
.
°° 
CreateIndex
°° (
(
°°( )
name
±± 
:
±± 
$str
±± /
,
±±/ 0
table
²² 
:
²² 
$str
²²  
,
²²  !
column
³³ 
:
³³ 
$str
³³ &
,
³³& '
unique
΄΄ 
:
΄΄ 
true
΄΄ 
)
΄΄ 
;
΄΄ 
migrationBuilder
¶¶ 
.
¶¶ 
CreateIndex
¶¶ (
(
¶¶( )
name
·· 
:
·· 
$str
·· )
,
··) *
table
ΈΈ 
:
ΈΈ 
$str
ΈΈ  
,
ΈΈ  !
column
ΉΉ 
:
ΉΉ 
$str
ΉΉ  
)
ΉΉ  !
;
ΉΉ! "
migrationBuilder
»» 
.
»» 
CreateIndex
»» (
(
»»( )
name
ΌΌ 
:
ΌΌ 
$str
ΌΌ ?
,
ΌΌ? @
table
½½ 
:
½½ 
$str
½½ 0
,
½½0 1
column
ΎΎ 
:
ΎΎ 
$str
ΎΎ &
)
ΎΎ& '
;
ΎΎ' (
migrationBuilder
ΐΐ 
.
ΐΐ 
CreateIndex
ΐΐ (
(
ΐΐ( )
name
ΑΑ 
:
ΑΑ 
$str
ΑΑ 9
,
ΑΑ9 :
table
ΒΒ 
:
ΒΒ 
$str
ΒΒ 0
,
ΒΒ0 1
column
ΓΓ 
:
ΓΓ 
$str
ΓΓ  
)
ΓΓ  !
;
ΓΓ! "
migrationBuilder
ΕΕ 
.
ΕΕ 
CreateIndex
ΕΕ (
(
ΕΕ( )
name
ΖΖ 
:
ΖΖ 
$str
ΖΖ +
,
ΖΖ+ ,
table
ΗΗ 
:
ΗΗ 
$str
ΗΗ "
,
ΗΗ" #
column
ΘΘ 
:
ΘΘ 
$str
ΘΘ  
)
ΘΘ  !
;
ΘΘ! "
migrationBuilder
ΚΚ 
.
ΚΚ 
CreateIndex
ΚΚ (
(
ΚΚ( )
name
ΛΛ 
:
ΛΛ 
$str
ΛΛ +
,
ΛΛ+ ,
table
ΜΜ 
:
ΜΜ 
$str
ΜΜ "
,
ΜΜ" #
column
ΝΝ 
:
ΝΝ 
$str
ΝΝ  
)
ΝΝ  !
;
ΝΝ! "
migrationBuilder
ΟΟ 
.
ΟΟ 
CreateIndex
ΟΟ (
(
ΟΟ( )
name
ΠΠ 
:
ΠΠ 
$str
ΠΠ -
,
ΠΠ- .
table
ΡΡ 
:
ΡΡ 
$str
ΡΡ 
,
ΡΡ 
column
ÒÒ 
:
ÒÒ 
$str
ÒÒ &
)
ÒÒ& '
;
ÒÒ' (
migrationBuilder
ΤΤ 
.
ΤΤ 
CreateIndex
ΤΤ (
(
ΤΤ( )
name
ΥΥ 
:
ΥΥ 
$str
ΥΥ ;
,
ΥΥ; <
table
ΦΦ 
:
ΦΦ 
$str
ΦΦ ,
,
ΦΦ, -
column
ΧΧ 
:
ΧΧ 
$str
ΧΧ &
)
ΧΧ& '
;
ΧΧ' (
migrationBuilder
ΩΩ 
.
ΩΩ 
CreateIndex
ΩΩ (
(
ΩΩ( )
name
ΪΪ 
:
ΪΪ 
$str
ΪΪ 9
,
ΪΪ9 :
table
ΫΫ 
:
ΫΫ 
$str
ΫΫ ,
,
ΫΫ, -
column
άά 
:
άά 
$str
άά $
)
άά$ %
;
άά% &
migrationBuilder
ήή 
.
ήή 
CreateIndex
ήή (
(
ήή( )
name
ίί 
:
ίί 
$str
ίί 9
,
ίί9 :
table
ΰΰ 
:
ΰΰ 
$str
ΰΰ ,
,
ΰΰ, -
column
αα 
:
αα 
$str
αα $
)
αα$ %
;
αα% &
}
ββ 	
	protected
εε 
override
εε 
void
εε 
Down
εε  $
(
εε$ %
MigrationBuilder
εε% 5
migrationBuilder
εε6 F
)
εεF G
{
ζζ 	
migrationBuilder
ηη 
.
ηη 
	DropTable
ηη &
(
ηη& '
name
θθ 
:
θθ 
$str
θθ %
)
θθ% &
;
θθ& '
migrationBuilder
κκ 
.
κκ 
	DropTable
κκ &
(
κκ& '
name
λλ 
:
λλ 
$str
λλ $
)
λλ$ %
;
λλ% &
migrationBuilder
νν 
.
νν 
	DropTable
νν &
(
νν& '
name
ξξ 
:
ξξ 
$str
ξξ +
)
ξξ+ ,
;
ξξ, -
migrationBuilder
ππ 
.
ππ 
	DropTable
ππ &
(
ππ& '
name
ρρ 
:
ρρ 
$str
ρρ $
)
ρρ$ %
;
ρρ% &
migrationBuilder
σσ 
.
σσ 
	DropTable
σσ &
(
σσ& '
name
ττ 
:
ττ 
$str
ττ "
)
ττ" #
;
ττ# $
migrationBuilder
φφ 
.
φφ 
	DropTable
φφ &
(
φφ& '
name
χχ 
:
χχ 
$str
χχ  
)
χχ  !
;
χχ! "
migrationBuilder
ωω 
.
ωω 
	DropTable
ωω &
(
ωω& '
name
ϊϊ 
:
ϊϊ 
$str
ϊϊ )
)
ϊϊ) *
;
ϊϊ* +
migrationBuilder
όό 
.
όό 
	DropTable
όό &
(
όό& '
name
ύύ 
:
ύύ 
$str
ύύ )
)
ύύ) *
;
ύύ* +
migrationBuilder
ÿÿ 
.
ÿÿ 
	DropTable
ÿÿ &
(
ÿÿ& '
name
€	€	 
:
€	€	 
$str
€	€	 %
)
€	€	% &
;
€	€	& '
migrationBuilder
‚	‚	 
.
‚	‚	 
	DropTable
‚	‚	 &
(
‚	‚	& '
name
ƒ	ƒ	 
:
ƒ	ƒ	 
$str
ƒ	ƒ	 &
)
ƒ	ƒ	& '
;
ƒ	ƒ	' (
migrationBuilder
…	…	 
.
…	…	 
	DropTable
…	…	 &
(
…	…	& '
name
†	†	 
:
†	†	 
$str
†	†	 '
)
†	†	' (
;
†	†	( )
migrationBuilder
		 
.
		 
	DropTable
		 &
(
		& '
name
‰	‰	 
:
‰	‰	 
$str
‰	‰	 "
)
‰	‰	" #
;
‰	‰	# $
migrationBuilder
‹	‹	 
.
‹	‹	 
	DropTable
‹	‹	 &
(
‹	‹	& '
name
		 
:
		 
$str
		 )
)
		) *
;
		* +
migrationBuilder
		 
.
		 
	DropTable
		 &
(
		& '
name
		 
:
		 
$str
		 '
)
		' (
;
		( )
migrationBuilder
‘	‘	 
.
‘	‘	 
	DropTable
‘	‘	 &
(
‘	‘	& '
name
’	’	 
:
’	’	 
$str
’	’	 /
)
’	’	/ 0
;
’	’	0 1
migrationBuilder
”	”	 
.
”	”	 
	DropTable
”	”	 &
(
”	”	& '
name
•	•	 
:
•	•	 
$str
•	•	 !
)
•	•	! "
;
•	•	" #
migrationBuilder
—	—	 
.
—	—	 
	DropTable
—	—	 &
(
—	—	& '
name
		 
:
		 
$str
		 +
)
		+ ,
;
		, -
migrationBuilder
		 
.
		 
	DropTable
		 &
(
		& '
name
›	›	 
:
›	›	 
$str
›	›	 +
)
›	›	+ ,
;
›	›	, -
migrationBuilder
		 
.
		 
	DropTable
		 &
(
		& '
name
		 
:
		 
$str
		 #
)
		# $
;
		$ %
migrationBuilder
 	 	 
.
 	 	 
	DropTable
 	 	 &
(
 	 	& '
name
΅	΅	 
:
΅	΅	 
$str
΅	΅	 (
)
΅	΅	( )
;
΅	΅	) *
migrationBuilder
£	£	 
.
£	£	 
	DropTable
£	£	 &
(
£	£	& '
name
¤	¤	 
:
¤	¤	 
$str
¤	¤	 
)
¤	¤	  
;
¤	¤	  !
migrationBuilder
¦	¦	 
.
¦	¦	 
	DropTable
¦	¦	 &
(
¦	¦	& '
name
§	§	 
:
§	§	 
$str
§	§	 #
)
§	§	# $
;
§	§	$ %
migrationBuilder
©	©	 
.
©	©	 
	DropTable
©	©	 &
(
©	©	& '
name
ª	ª	 
:
ª	ª	 
$str
ª	ª	 
)
ª	ª	 
;
ª	ª	 
migrationBuilder
¬	¬	 
.
¬	¬	 
	DropTable
¬	¬	 &
(
¬	¬	& '
name
­	­	 
:
­	­	 
$str
­	­	 !
)
­	­	! "
;
­	­	" #
migrationBuilder
―	―	 
.
―	―	 
	DropTable
―	―	 &
(
―	―	& '
name
°	°	 
:
°	°	 
$str
°	°	 "
)
°	°	" #
;
°	°	# $
migrationBuilder
²	²	 
.
²	²	 
	DropTable
²	²	 &
(
²	²	& '
name
³	³	 
:
³	³	 
$str
³	³	 
)
³	³	 
;
³	³	  
migrationBuilder
µ	µ	 
.
µ	µ	 
	DropTable
µ	µ	 &
(
µ	µ	& '
name
¶	¶	 
:
¶	¶	 
$str
¶	¶	 "
)
¶	¶	" #
;
¶	¶	# $
migrationBuilder
Έ	Έ	 
.
Έ	Έ	 
	DropTable
Έ	Έ	 &
(
Έ	Έ	& '
name
Ή	Ή	 
:
Ή	Ή	 
$str
Ή	Ή	  
)
Ή	Ή	  !
;
Ή	Ή	! "
migrationBuilder
»	»	 
.
»	»	 
	DropTable
»	»	 &
(
»	»	& '
name
Ό	Ό	 
:
Ό	Ό	 
$str
Ό	Ό	  
)
Ό	Ό	  !
;
Ό	Ό	! "
migrationBuilder
Ύ	Ύ	 
.
Ύ	Ύ	 
	DropTable
Ύ	Ύ	 &
(
Ύ	Ύ	& '
name
Ώ	Ώ	 
:
Ώ	Ώ	 
$str
Ώ	Ώ	 #
)
Ώ	Ώ	# $
;
Ώ	Ώ	$ %
migrationBuilder
Α	Α	 
.
Α	Α	 
	DropTable
Α	Α	 &
(
Α	Α	& '
name
Β	Β	 
:
Β	Β	 
$str
Β	Β	 
)
Β	Β	 
;
Β	Β	 
migrationBuilder
Δ	Δ	 
.
Δ	Δ	 
	DropTable
Δ	Δ	 &
(
Δ	Δ	& '
name
Ε	Ε	 
:
Ε	Ε	 
$str
Ε	Ε	 #
)
Ε	Ε	# $
;
Ε	Ε	$ %
}
Ζ	Ζ	 	
}
Η	Η	 
}Θ	Θ	 ρ(
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
}>> ›
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
}++ ª]
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
}]] “Ο
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
public 
class 

DataSeeder 
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 


DataSeeder 
( 
ItsToolDbContext &
context' .
). /
{ 
_context 
= 
context 
; 
} 
public 

async 
Task 
	SeedAsync 
(  
)  !
{ 
await  
SeedTicketTypesAsync '
(' (
)( )
;) *
await 
SeedStatusesAsync 
(  
)  !
;! "
await   
SeedPrioritiesAsync   !
(  ! "
)  " #
;  # $
await!! )
SeedDepartmentsAndGroupsAsync!! +
(!!+ ,
)!!, -
;!!- .
await"" (
SeedRolesAndPermissionsAsync"" *
(""* +
)""+ ,
;"", -
await## 
SeedUsersAsync## 
(## 
)## 
;## 
await$$ *
SeedProjectsAndCategoriesAsync$$ ,
($$, -
)$$- .
;$$. /
await%% "
SeedDynamicFieldsAsync%% $
(%%$ %
)%%% &
;%%& '
await&&  
SeedSlaPoliciesAsync&& "
(&&" #
)&&# $
;&&$ %
await'' (
SeedWorkflowTransitionsAsync'' *
(''* +
)''+ ,
;'', -
await(( "
SeedKnowledgeBaseAsync(( $
((($ %
)((% &
;((& '
}** 
private,, 
async,, 
Task,,  
SeedTicketTypesAsync,, +
(,,+ ,
),,, -
{-- 
if// 

(// 
!// 
await// 
_context// 
.// 
TicketTypes// '
.//' (
AnyAsync//( 0
(//0 1
)//1 2
)//2 3
{00 	
_context11 
.11 
TicketTypes11  
.11  !
AddRange11! )
(11) *
new22 

TicketType22 
{22  
Name22! %
=22& '
$str22( 2
}223 4
,224 5
new33 

TicketType33 
{33  
Name33! %
=33& '
$str33( 9
}33: ;
)44 
;44 
}55 	
}66 
private88 
async88 
Task88 
SeedStatusesAsync88 (
(88( )
)88) *
{99 
if;; 

(;; 
!;; 
await;; 
_context;; 
.;; 
Statuses;; $
.;;$ %
AnyAsync;;% -
(;;- .
);;. /
);;/ 0
{<< 	
_context== 
.== 
Statuses== 
.== 
AddRange== &
(==& '
new>> 
Status>> 
{>> 
Name>> !
=>>" #
StatusConstants>>$ 3
.>>3 4
Open>>4 8
,>>8 9
	SortOrder>>: C
=>>D E
$num>>F G
,>>G H
IsSystemDefault>>I X
=>>Y Z
true>>[ _
}>>` a
,>>a b
new?? 
Status?? 
{?? 
Name?? !
=??" #
StatusConstants??$ 3
.??3 4

InProgress??4 >
,??> ?
	SortOrder??@ I
=??J K
$num??L M
}??N O
,??O P
new@@ 
Status@@ 
{@@ 
Name@@ !
=@@" #
StatusConstants@@$ 3
.@@3 4
OnHold@@4 :
,@@: ;
	SortOrder@@< E
=@@F G
$num@@H I
,@@I J
	PausesSla@@K T
=@@U V
true@@W [
}@@\ ]
,@@] ^
newAA 
StatusAA 
{AA 
NameAA !
=AA" #
StatusConstantsAA$ 3
.AA3 4
ResolvedAA4 <
,AA< =
	SortOrderAA> G
=AAH I
$numAAJ K
,AAK L
IsClosedStatusAAM [
=AA\ ]
trueAA^ b
}AAc d
,AAd e
newBB 
StatusBB 
{BB 
NameBB !
=BB" #
StatusConstantsBB$ 3
.BB3 4
ClosedBB4 :
,BB: ;
	SortOrderBB< E
=BBF G
$numBBH I
,BBI J
IsClosedStatusBBK Y
=BBZ [
trueBB\ `
}BBa b
)CC 
;CC 
}DD 	
}EE 
privateGG 
asyncGG 
TaskGG 
SeedPrioritiesAsyncGG *
(GG* +
)GG+ ,
{HH 
ifJJ 

(JJ 
!JJ 
awaitJJ 
_contextJJ 
.JJ 

PrioritiesJJ &
.JJ& '
AnyAsyncJJ' /
(JJ/ 0
)JJ0 1
)JJ1 2
{KK 	
_contextLL 
.LL 

PrioritiesLL 
.LL  
AddRangeLL  (
(LL( )
newMM 
PriorityMM 
{MM 
NameMM #
=MM$ %
$strMM& .
,MM. /
WeightMM0 6
=MM7 8
$numMM9 <
,MM< =
SeverityLevelMM> K
=MML M
$numMMN O
}MMP Q
,MMQ R
newNN 
PriorityNN 
{NN 
NameNN #
=NN$ %
$strNN& .
,NN. /
WeightNN0 6
=NN7 8
$numNN9 ;
,NN; <
SeverityLevelNN= J
=NNK L
$numNNM N
}NNO P
,NNP Q
newOO 
PriorityOO 
{OO 
NameOO #
=OO$ %
$strOO& ,
,OO, -
WeightOO. 4
=OO5 6
$numOO7 9
,OO9 :
SeverityLevelOO; H
=OOI J
$numOOK L
}OOM N
,OON O
newPP 
PriorityPP 
{PP 
NamePP #
=PP$ %
$strPP& -
,PP- .
WeightPP/ 5
=PP6 7
$numPP8 :
,PP: ;
SeverityLevelPP< I
=PPJ K
$numPPL M
}PPN O
)QQ 
;QQ 
}RR 	
}SS 
privateUU 
asyncUU 
TaskUU )
SeedDepartmentsAndGroupsAsyncUU 4
(UU4 5
)UU5 6
{VV 
ifXX 

(XX 
!XX 
awaitXX 
_contextXX 
.XX 
DepartmentsXX '
.XX' (
AnyAsyncXX( 0
(XX0 1
)XX1 2
)XX2 3
{YY 	
_contextZZ 
.ZZ 
DepartmentsZZ  
.ZZ  !
AddRangeZZ! )
(ZZ) *
new[[ 

Department[[ 
{[[  
Name[[! %
=[[& '
$str[[( =
}[[> ?
,[[? @
new\\ 

Department\\ 
{\\  
Name\\! %
=\\& '
$str\\( :
}\\; <
)]] 
;]] 
}^^ 	
await__ 
_context__ 
.__ 
SaveChangesAsync__ '
(__' (
)__( )
;__) *
varaa 
itDeptaa 
=aa 
awaitaa 
_contextaa #
.aa# $
Departmentsaa$ /
.aa/ 0
FirstOrDefaultAsyncaa0 C
(aaC D
daaD E
=>aaF H
daaI J
.aaJ K
NameaaK O
==aaP R
$straaS h
)aah i
;aai j
ifcc 

(cc 
!cc 
awaitcc 
_contextcc 
.cc 
Groupscc "
.cc" #
AnyAsynccc# +
(cc+ ,
)cc, -
&&cc. 0
itDeptcc1 7
!=cc8 :
nullcc; ?
)cc? @
{dd 	
_contextee 
.ee 
Groupsee 
.ee 
AddRangeee $
(ee$ %
newff 
Groupff 
{ff 
Nameff  
=ff! "
$strff# 3
,ff3 4
DepartmentIdff5 A
=ffB C
itDeptffD J
.ffJ K
IdffK M
}ffN O
,ffO P
newgg 
Groupgg 
{gg 
Namegg  
=gg! "
$strgg# ;
,gg; <
DepartmentIdgg= I
=ggJ K
itDeptggL R
.ggR S
IdggS U
}ggV W
,ggW X
newhh 
Grouphh 
{hh 
Namehh  
=hh! "
$strhh# 9
,hh9 :
DepartmentIdhh; G
=hhH I
itDepthhJ P
.hhP Q
IdhhQ S
}hhT U
,hhU V
newii 
Groupii 
{ii 
Nameii  
=ii! "
$strii# 3
,ii3 4
DepartmentIdii5 A
=iiB C
itDeptiiD J
.iiJ K
IdiiK M
}iiN O
)jj 
;jj 
awaitkk 
_contextkk 
.kk 
SaveChangesAsynckk +
(kk+ ,
)kk, -
;kk- .
}ll 	
}mm 
privateoo 
asyncoo 
Taskoo (
SeedRolesAndPermissionsAsyncoo 3
(oo3 4
)oo4 5
{pp 
varrr 
allPermissionsrr 
=rr 
ItsToolrr $
.rr$ %
Applicationrr% 0
.rr0 1
	Constantsrr1 :
.rr: ;
PermissionConstantsrr; N
.rrN O
AllPermissionsrrO ]
;rr] ^
varss 
existingPermissionsss 
=ss  !
awaitss" '
_contextss( 0
.ss0 1
Permissionsss1 <
.ss< =
ToListAsyncss= H
(ssH I
)ssI J
;ssJ K
varuu 
missingPermissionsuu 
=uu  
allPermissionsuu! /
.uu/ 0
Whereuu0 5
(uu5 6
pKeyuu6 :
=>uu; =
!uu> ?
existingPermissionsuu? R
.uuR S
AnyuuS V
(uuV W
puuW X
=>uuY [
puu\ ]
.uu] ^
Keyuu^ a
==uub d
pKeyuue i
)uui j
)uuj k
.uuk l
Selectuul r
(uur s
pKeyuus w
=>uux z
newuu{ ~

Permission	uu ‰
{
uu ‹
Name
uu 
=
uu‘ ’
pKey
uu“ —
,
uu— 
Key
uu™ 
=
uu 
pKey
uu £
}
uu¤ ¥
)
uu¥ ¦
.
uu¦ §
ToList
uu§ ­
(
uu­ ®
)
uu® ―
;
uu― °
ifvv 

(vv 
missingPermissionsvv 
.vv 
Countvv $
>vv% &
$numvv' (
)vv( )
{ww 	
_contextxx 
.xx 
Permissionsxx  
.xx  !
AddRangexx! )
(xx) *
missingPermissionsxx* <
)xx< =
;xx= >
existingPermissionsyy 
.yy  
AddRangeyy  (
(yy( )
missingPermissionsyy) ;
)yy; <
;yy< =
}zz 	
await{{ 
_context{{ 
.{{ 
SaveChangesAsync{{ '
({{' (
){{( )
;{{) *
var}} 
rolesToSeed}} 
=}} 
new}} 

Dictionary}} (
<}}( )
string}}) /
,}}/ 0
string}}1 7
[}}7 8
]}}8 9
>}}9 :
{~~ 	
{ 
$str 
, 
allPermissions *
.* +
ToArray+ 2
(2 3
)3 4
}5 6
,6 7
{
€€ 
$str
€€ 
,
€€ 
new
€€ 
[
€€ 
]
€€ 
{
€€  
$str
€€! .
,
€€. /
$str
€€0 <
,
€€< =
$str
€€> K
,
€€K L
$str
€€M \
,
€€\ ]
$str
€€^ i
}
€€j k
}
€€l m
,
€€m n
{
 
$str
 
,
 
new
 
[
 
]
 
{
 
$str
 ,
,
, -!
PermissionConstants
. A
.
A B

TicketEdit
B L
,
L M!
PermissionConstants
N a
.
a b
TicketResolve
b o
,
o p
$strq 
, ‚
$strƒ 
} 
} 
, ‘
{
‚‚ 
$str
‚‚ 
,
‚‚ 
new
‚‚ 
[
‚‚ 
]
‚‚ 
{
‚‚  
$str
‚‚! 0
,
‚‚0 1
$str
‚‚2 ?
,
‚‚? @
$str
‚‚A P
,
‚‚P Q
$str
‚‚R [
}
‚‚\ ]
}
‚‚^ _
}
ƒƒ 	
;
ƒƒ	 

var
…… 
existingRoles
…… 
=
…… 
await
…… !
_context
……" *
.
……* +
Roles
……+ 0
.
……0 1
Include
……1 8
(
……8 9
r
……9 :
=>
……; =
r
……> ?
.
……? @
RolePermissions
……@ O
)
……O P
.
……P Q
ToListAsync
……Q \
(
……\ ]
)
……] ^
;
……^ _
foreach
‡‡ 
(
‡‡ 
var
‡‡ 
kvp
‡‡ 
in
‡‡ 
rolesToSeed
‡‡ '
)
‡‡' (
{
 	
var
‰‰ 
role
‰‰ 
=
‰‰ 
existingRoles
‰‰ $
.
‰‰$ %
FirstOrDefault
‰‰% 3
(
‰‰3 4
r
‰‰4 5
=>
‰‰6 8
r
‰‰9 :
.
‰‰: ;
Name
‰‰; ?
==
‰‰@ B
kvp
‰‰C F
.
‰‰F G
Key
‰‰G J
)
‰‰J K
;
‰‰K L
if
 
(
 
role
 
==
 
null
 
)
 
{
‹‹ 
role
 
=
 
new
 
Role
 
{
  !
Name
" &
=
' (
kvp
) ,
.
, -
Key
- 0
}
1 2
;
2 3
_context
 
.
 
Roles
 
.
 
Add
 "
(
" #
role
# '
)
' (
;
( )
existingRoles
 
.
 
Add
 !
(
! "
role
" &
)
& '
;
' (
await
 
_context
 
.
 
SaveChangesAsync
 /
(
/ 0
)
0 1
;
1 2
}
 
foreach
’’ 
(
’’ 
var
’’ 
permKey
’’  
in
’’! #
kvp
’’$ '
.
’’' (
Value
’’( -
)
’’- .
{
““ 
var
”” 
perm
”” 
=
”” !
existingPermissions
”” .
.
””. /
FirstOrDefault
””/ =
(
””= >
p
””> ?
=>
””@ B
p
””C D
.
””D E
Key
””E H
==
””I K
permKey
””L S
)
””S T
;
””T U
if
•• 
(
•• 
perm
•• 
!=
•• 
null
••  
&&
••! #
!
••$ %
role
••% )
.
••) *
RolePermissions
••* 9
.
••9 :
Any
••: =
(
••= >
rp
••> @
=>
••A C
rp
••D F
.
••F G
PermissionId
••G S
==
••T V
perm
••W [
.
••[ \
Id
••\ ^
)
••^ _
)
••_ `
{
–– 
_context
—— 
.
—— 
RolePermissions
—— ,
.
——, -
Add
——- 0
(
——0 1
new
——1 4
RolePermission
——5 C
{
——D E
RoleId
——F L
=
——M N
role
——O S
.
——S T
Id
——T V
,
——V W
PermissionId
——X d
=
——e f
perm
——g k
.
——k l
Id
——l n
}
——o p
)
——p q
;
——q r
}
 
}
™™ 
}
 	
await
›› 
_context
›› 
.
›› 
SaveChangesAsync
›› '
(
››' (
)
››( )
;
››) *
}
 
private
 
async
 
Task
 
SeedUsersAsync
 %
(
% &
)
& '
{
 
var
   
itDept
   
=
   
await
   
_context
   #
.
  # $
Departments
  $ /
.
  / 0!
FirstOrDefaultAsync
  0 C
(
  C D
d
  D E
=>
  F H
d
  I J
.
  J K
Name
  K O
==
  P R
$str
  S h
)
  h i
;
  i j
var
΅΅ 
existingRoles
΅΅ 
=
΅΅ 
await
΅΅ !
_context
΅΅" *
.
΅΅* +
Roles
΅΅+ 0
.
΅΅0 1
ToListAsync
΅΅1 <
(
΅΅< =
)
΅΅= >
;
΅΅> ?
var
ΆΆ !
existingPermissions
ΆΆ 
=
ΆΆ  !
await
ΆΆ" '
_context
ΆΆ( 0
.
ΆΆ0 1
Permissions
ΆΆ1 <
.
ΆΆ< =
ToListAsync
ΆΆ= H
(
ΆΆH I
)
ΆΆI J
;
ΆΆJ K
var
¤¤ 
usersToSeed
¤¤ 
=
¤¤ 
new
¤¤ 
List
¤¤ "
<
¤¤" #
(
¤¤# $
string
¤¤$ *
Username
¤¤+ 3
,
¤¤3 4
string
¤¤5 ;
Password
¤¤< D
,
¤¤D E
string
¤¤F L
Role
¤¤M Q
,
¤¤Q R
string
¤¤S Y
	FirstName
¤¤Z c
,
¤¤c d
string
¤¤e k
LastName
¤¤l t
)
¤¤t u
>
¤¤u v
{
¥¥ 	
(
¦¦ 
$str
¦¦ 
,
¦¦ 
$str
¦¦ !
,
¦¦! "
$str
¦¦# /
,
¦¦/ 0
$str
¦¦1 9
,
¦¦9 :
$str
¦¦; B
)
¦¦B C
,
¦¦C D
(
§§ 
$str
§§ 
,
§§ 
$str
§§ %
,
§§% &
$str
§§' 0
,
§§0 1
$str
§§2 6
,
§§6 7
$str
§§8 A
)
§§A B
,
§§B C
(
¨¨ 
$str
¨¨ 
,
¨¨ 
$str
¨¨ "
,
¨¨" #
$str
¨¨$ +
,
¨¨+ ,
$str
¨¨- 7
,
¨¨7 8
$str
¨¨9 B
)
¨¨B C
,
¨¨C D
(
©© 
$str
©© 
,
©© 
$str
©© "
,
©©" #
$str
©©$ +
,
©©+ ,
$str
©©- 7
,
©©7 8
$str
©©9 B
)
©©B C
,
©©C D
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
«« 	
;
««	 

var
­­ 
existingUsers
­­ 
=
­­ 
await
­­ !
_context
­­" *
.
­­* +
Users
­­+ 0
.
­­0 1
Include
­­1 8
(
­­8 9
u
­­9 :
=>
­­; =
u
­­> ?
.
­­? @
	UserRoles
­­@ I
)
­­I J
.
­­J K
Include
­­K R
(
­­R S
u
­­S T
=>
­­U W
u
­­X Y
.
­­Y Z!
PermissionOverrides
­­Z m
)
­­m n
.
­­n o
ToListAsync
­­o z
(
­­z {
)
­­{ |
;
­­| }
foreach
―― 
(
―― 
var
―― 
u
―― 
in
―― 
usersToSeed
―― %
)
――% &
{
°° 	
var
±± 
user
±± 
=
±± 
existingUsers
±± $
.
±±$ %
FirstOrDefault
±±% 3
(
±±3 4
x
±±4 5
=>
±±6 8
x
±±9 :
.
±±: ;
Username
±±; C
==
±±D F
u
±±G H
.
±±H I
Username
±±I Q
)
±±Q R
;
±±R S
if
²² 
(
²² 
user
²² 
==
²² 
null
²² 
&&
²² 
itDept
²²  &
!=
²²' )
null
²²* .
)
²². /
{
³³ 
user
΄΄ 
=
΄΄ 
new
΄΄ 
User
΄΄ 
{
µµ 
Username
¶¶ 
=
¶¶ 
u
¶¶  
.
¶¶  !
Username
¶¶! )
,
¶¶) *
Email
·· 
=
·· 
$"
·· 
{
·· 
u
··  
.
··  !
Username
··! )
}
··) *
$str
··* 5
"
··5 6
,
··6 7
	FirstName
ΈΈ 
=
ΈΈ 
u
ΈΈ  !
.
ΈΈ! "
	FirstName
ΈΈ" +
,
ΈΈ+ ,
LastName
ΉΉ 
=
ΉΉ 
u
ΉΉ  
.
ΉΉ  !
LastName
ΉΉ! )
,
ΉΉ) *
DepartmentId
ΊΊ  
=
ΊΊ! "
itDept
ΊΊ# )
.
ΊΊ) *
Id
ΊΊ* ,
,
ΊΊ, -
PasswordHash
»»  
=
»»! "
BCrypt
»»# )
.
»») *
Net
»»* -
.
»»- .
BCrypt
»». 4
.
»»4 5
HashPassword
»»5 A
(
»»A B
u
»»B C
.
»»C D
Password
»»D L
)
»»L M
}
ΌΌ 
;
ΌΌ 
_context
½½ 
.
½½ 
Users
½½ 
.
½½ 
Add
½½ "
(
½½" #
user
½½# '
)
½½' (
;
½½( )
existingUsers
ΎΎ 
.
ΎΎ 
Add
ΎΎ !
(
ΎΎ! "
user
ΎΎ" &
)
ΎΎ& '
;
ΎΎ' (
await
ΏΏ 
_context
ΏΏ 
.
ΏΏ 
SaveChangesAsync
ΏΏ /
(
ΏΏ/ 0
)
ΏΏ0 1
;
ΏΏ1 2
}
ΐΐ 
if
ΒΒ 
(
ΒΒ 
user
ΒΒ 
!=
ΒΒ 
null
ΒΒ 
)
ΒΒ 
{
ΓΓ 
var
ΔΔ 
role
ΔΔ 
=
ΔΔ 
existingRoles
ΔΔ (
.
ΔΔ( )
First
ΔΔ) .
(
ΔΔ. /
r
ΔΔ/ 0
=>
ΔΔ1 3
r
ΔΔ4 5
.
ΔΔ5 6
Name
ΔΔ6 :
==
ΔΔ; =
u
ΔΔ> ?
.
ΔΔ? @
Role
ΔΔ@ D
)
ΔΔD E
;
ΔΔE F
if
ΕΕ 
(
ΕΕ 
!
ΕΕ 
user
ΕΕ 
.
ΕΕ 
	UserRoles
ΕΕ #
.
ΕΕ# $
Any
ΕΕ$ '
(
ΕΕ' (
ur
ΕΕ( *
=>
ΕΕ+ -
ur
ΕΕ. 0
.
ΕΕ0 1
RoleId
ΕΕ1 7
==
ΕΕ8 :
role
ΕΕ; ?
.
ΕΕ? @
Id
ΕΕ@ B
)
ΕΕB C
)
ΕΕC D
{
ΖΖ 
_context
ΗΗ 
.
ΗΗ 
	UserRoles
ΗΗ &
.
ΗΗ& '
Add
ΗΗ' *
(
ΗΗ* +
new
ΗΗ+ .
UserRole
ΗΗ/ 7
{
ΗΗ8 9
UserId
ΗΗ: @
=
ΗΗA B
user
ΗΗC G
.
ΗΗG H
Id
ΗΗH J
,
ΗΗJ K
RoleId
ΗΗL R
=
ΗΗS T
role
ΗΗU Y
.
ΗΗY Z
Id
ΗΗZ \
}
ΗΗ] ^
)
ΗΗ^ _
;
ΗΗ_ `
}
ΘΘ 
if
ΚΚ 
(
ΚΚ 
u
ΚΚ 
.
ΚΚ 
Username
ΚΚ 
==
ΚΚ !
$str
ΚΚ" *
)
ΚΚ* +
{
ΛΛ 
var
ΜΜ 
	closePerm
ΜΜ !
=
ΜΜ" #!
existingPermissions
ΜΜ$ 7
.
ΜΜ7 8
First
ΜΜ8 =
(
ΜΜ= >
p
ΜΜ> ?
=>
ΜΜ@ B
p
ΜΜC D
.
ΜΜD E
Key
ΜΜE H
==
ΜΜI K!
PermissionConstants
ΜΜL _
.
ΜΜ_ `
TicketClose
ΜΜ` k
)
ΜΜk l
;
ΜΜl m
if
ΝΝ 
(
ΝΝ 
!
ΝΝ 
user
ΝΝ 
.
ΝΝ !
PermissionOverrides
ΝΝ 1
.
ΝΝ1 2
Any
ΝΝ2 5
(
ΝΝ5 6
po
ΝΝ6 8
=>
ΝΝ9 ;
po
ΝΝ< >
.
ΝΝ> ?
PermissionId
ΝΝ? K
==
ΝΝL N
	closePerm
ΝΝO X
.
ΝΝX Y
Id
ΝΝY [
)
ΝΝ[ \
)
ΝΝ\ ]
{
ΞΞ 
_context
ΟΟ  
.
ΟΟ  !%
UserPermissionOverrides
ΟΟ! 8
.
ΟΟ8 9
Add
ΟΟ9 <
(
ΟΟ< =
new
ΟΟ= @$
UserPermissionOverride
ΟΟA W
{
ΠΠ 
UserId
ΡΡ "
=
ΡΡ# $
user
ΡΡ% )
.
ΡΡ) *
Id
ΡΡ* ,
,
ΡΡ, -
PermissionId
ÒÒ (
=
ÒÒ) *
	closePerm
ÒÒ+ 4
.
ÒÒ4 5
Id
ÒÒ5 7
,
ÒÒ7 8
	IsGranted
ΣΣ %
=
ΣΣ& '
true
ΣΣ( ,
}
ΤΤ 
)
ΤΤ 
;
ΤΤ 
}
ΥΥ 
}
ΦΦ 
}
ΧΧ 
}
ΨΨ 	
await
ΩΩ 
_context
ΩΩ 
.
ΩΩ 
SaveChangesAsync
ΩΩ '
(
ΩΩ' (
)
ΩΩ( )
;
ΩΩ) *
}
ΪΪ 
private
άά 
async
άά 
Task
άά ,
SeedProjectsAndCategoriesAsync
άά 5
(
άά5 6
)
άά6 7
{
έέ 
if
ίί 

(
ίί 
!
ίί 
await
ίί 
_context
ίί 
.
ίί 
Projects
ίί $
.
ίί$ %
AnyAsync
ίί% -
(
ίί- .
)
ίί. /
)
ίί/ 0
{
ΰΰ 	
_context
αα 
.
αα 
Projects
αα 
.
αα 
AddRange
αα &
(
αα& '
new
ββ 
ItsTool
ββ 
.
ββ 
Domain
ββ "
.
ββ" #
Entities
ββ# +
.
ββ+ ,
Project
ββ, 3
.
ββ3 4
Project
ββ4 ;
{
ββ< =
Name
ββ> B
=
ββC D
$str
ββE P
,
ββP Q

ProjectKey
ββR \
=
ββ] ^
$str
ββ_ d
}
ββe f
,
ββf g
new
γγ 
ItsTool
γγ 
.
γγ 
Domain
γγ "
.
γγ" #
Entities
γγ# +
.
γγ+ ,
Project
γγ, 3
.
γγ3 4
Project
γγ4 ;
{
γγ< =
Name
γγ> B
=
γγC D
$str
γγE W
,
γγW X

ProjectKey
γγY c
=
γγd e
$str
γγf j
}
γγk l
,
γγl m
new
δδ 
ItsTool
δδ 
.
δδ 
Domain
δδ "
.
δδ" #
Entities
δδ# +
.
δδ+ ,
Project
δδ, 3
.
δδ3 4
Project
δδ4 ;
{
δδ< =
Name
δδ> B
=
δδC D
$str
δδE Y
,
δδY Z

ProjectKey
δδ[ e
=
δδf g
$str
δδh m
}
δδn o
,
δδo p
new
εε 
ItsTool
εε 
.
εε 
Domain
εε "
.
εε" #
Entities
εε# +
.
εε+ ,
Project
εε, 3
.
εε3 4
Project
εε4 ;
{
εε< =
Name
εε> B
=
εεC D
$str
εεE W
,
εεW X

ProjectKey
εεY c
=
εεd e
$str
εεf k
}
εεl m
,
εεm n
new
ζζ 
ItsTool
ζζ 
.
ζζ 
Domain
ζζ "
.
ζζ" #
Entities
ζζ# +
.
ζζ+ ,
Project
ζζ, 3
.
ζζ3 4
Project
ζζ4 ;
{
ζζ< =
Name
ζζ> B
=
ζζC D
$str
ζζE ]
,
ζζ] ^

ProjectKey
ζζ_ i
=
ζζj k
$str
ζζl q
}
ζζr s
)
ηη 
;
ηη 
await
θθ 
_context
θθ 
.
θθ 
SaveChangesAsync
θθ +
(
θθ+ ,
)
θθ, -
;
θθ- .
}
ιι 	
var
λλ 

itsProject
λλ 
=
λλ 
await
λλ 
_context
λλ '
.
λλ' (
Projects
λλ( 0
.
λλ0 1!
FirstOrDefaultAsync
λλ1 D
(
λλD E
p
λλE F
=>
λλG I
p
λλJ K
.
λλK L

ProjectKey
λλL V
==
λλW Y
$str
λλZ _
)
λλ_ `
;
λλ` a
if
μμ 

(
μμ 
!
μμ 
await
μμ 
_context
μμ 
.
μμ 

Categories
μμ &
.
μμ& '
AnyAsync
μμ' /
(
μμ/ 0
)
μμ0 1
&&
μμ2 4

itsProject
μμ5 ?
!=
μμ@ B
null
μμC G
)
μμG H
{
νν 	
_context
ξξ 
.
ξξ 

Categories
ξξ 
.
ξξ  
AddRange
ξξ  (
(
ξξ( )
new
οο 
ItsTool
οο 
.
οο 
Domain
οο "
.
οο" #
Entities
οο# +
.
οο+ ,
Ticket
οο, 2
.
οο2 3
Category
οο3 ;
{
οο< =
Name
οο> B
=
οοC D
$str
οοE V
,
οοV W
	ProjectId
οοX a
=
οοb c

itsProject
οοd n
.
οοn o
Id
οοo q
}
οοr s
,
οοs t
new
ππ 
ItsTool
ππ 
.
ππ 
Domain
ππ "
.
ππ" #
Entities
ππ# +
.
ππ+ ,
Ticket
ππ, 2
.
ππ2 3
Category
ππ3 ;
{
ππ< =
Name
ππ> B
=
ππC D
$str
ππE U
,
ππU V
	ProjectId
ππW `
=
ππa b

itsProject
ππc m
.
ππm n
Id
ππn p
}
ππq r
,
ππr s
new
ρρ 
ItsTool
ρρ 
.
ρρ 
Domain
ρρ "
.
ρρ" #
Entities
ρρ# +
.
ρρ+ ,
Ticket
ρρ, 2
.
ρρ2 3
Category
ρρ3 ;
{
ρρ< =
Name
ρρ> B
=
ρρC D
$str
ρρE T
,
ρρT U
	ProjectId
ρρV _
=
ρρ` a

itsProject
ρρb l
.
ρρl m
Id
ρρm o
}
ρρp q
)
ςς 
;
ςς 
await
σσ 
_context
σσ 
.
σσ 
SaveChangesAsync
σσ +
(
σσ+ ,
)
σσ, -
;
σσ- .
}
ττ 	
}
υυ 
private
χχ 
async
χχ 
Task
χχ $
SeedDynamicFieldsAsync
χχ -
(
χχ- .
)
χχ. /
{
ψψ 
var
ωω 

itsProject
ωω 
=
ωω 
await
ωω 
_context
ωω '
.
ωω' (
Projects
ωω( 0
.
ωω0 1!
FirstOrDefaultAsync
ωω1 D
(
ωωD E
p
ωωE F
=>
ωωG I
p
ωωJ K
.
ωωK L

ProjectKey
ωωL V
==
ωωW Y
$str
ωωZ _
)
ωω_ `
;
ωω` a
if
ϋϋ 

(
ϋϋ 
!
ϋϋ 
await
ϋϋ 
_context
ϋϋ 
.
ϋϋ 
FieldDefinitions
ϋϋ ,
.
ϋϋ, -
AnyAsync
ϋϋ- 5
(
ϋϋ5 6
)
ϋϋ6 7
)
ϋϋ7 8
{
όό 	
var
ύύ 
serverNameField
ύύ 
=
ύύ  !
new
ύύ" %
ItsTool
ύύ& -
.
ύύ- .
Domain
ύύ. 4
.
ύύ4 5
Entities
ύύ5 =
.
ύύ= >
Config
ύύ> D
.
ύύD E
FieldDefinition
ύύE T
{
ύύU V
Key
ύύW Z
=
ύύ[ \
$str
ύύ] i
,
ύύi j
Label
ύύk p
=
ύύq r
$str
ύύs 
,ύύ €
	FieldTypeύύ 
=ύύ‹ 
ItsToolύύ ”
.ύύ” •
Domainύύ• ›
.ύύ› 
Entitiesύύ ¤
.ύύ¤ ¥
Configύύ¥ «
.ύύ« ¬
	FieldTypeύύ¬ µ
.ύύµ ¶
Textύύ¶ Ί
}ύύ» Ό
;ύύΌ ½
var
ώώ  
impactedUsersField
ώώ "
=
ώώ# $
new
ώώ% (
ItsTool
ώώ) 0
.
ώώ0 1
Domain
ώώ1 7
.
ώώ7 8
Entities
ώώ8 @
.
ώώ@ A
Config
ώώA G
.
ώώG H
FieldDefinition
ώώH W
{
ώώX Y
Key
ώώZ ]
=
ώώ^ _
$str
ώώ` x
,
ώώx y
Label
ώώz 
=ώώ€ 
$strώώ‚ 
,ώώ 
	FieldTypeώώ  ©
=ώώª «
ItsToolώώ¬ ³
.ώώ³ ΄
Domainώώ΄ Ί
.ώώΊ »
Entitiesώώ» Γ
.ώώΓ Δ
ConfigώώΔ Κ
.ώώΚ Λ
	FieldTypeώώΛ Τ
.ώώΤ Υ
NumberώώΥ Ϋ
}ώώά έ
;ώώέ ή
_context
ÿÿ 
.
ÿÿ 
FieldDefinitions
ÿÿ %
.
ÿÿ% &
AddRange
ÿÿ& .
(
ÿÿ. /
serverNameField
ÿÿ/ >
,
ÿÿ> ? 
impactedUsersField
ÿÿ@ R
)
ÿÿR S
;
ÿÿS T
await
€€ 
_context
€€ 
.
€€ 
SaveChangesAsync
€€ +
(
€€+ ,
)
€€, -
;
€€- .
var
‚‚ 

hwCategory
‚‚ 
=
‚‚ 
await
‚‚ "
_context
‚‚# +
.
‚‚+ ,

Categories
‚‚, 6
.
‚‚6 7!
FirstOrDefaultAsync
‚‚7 J
(
‚‚J K
c
‚‚K L
=>
‚‚M O
c
‚‚P Q
.
‚‚Q R
Name
‚‚R V
==
‚‚W Y
$str
‚‚Z k
)
‚‚k l
;
‚‚l m
if
ƒƒ 
(
ƒƒ 

hwCategory
ƒƒ 
!=
ƒƒ 
null
ƒƒ "
)
ƒƒ" #
{
„„ 
_context
…… 
.
…… !
FormFieldPlacements
…… ,
.
……, -
AddRange
……- 5
(
……5 6
new
†† 
ItsTool
†† 
.
††  
Domain
††  &
.
††& '
Entities
††' /
.
††/ 0
Config
††0 6
.
††6 7 
FormFieldPlacement
††7 I
{
††J K

CategoryId
††L V
=
††W X

hwCategory
††Y c
.
††c d
Id
††d f
,
††f g
FieldDefinitionId
††h y
=
††z {
serverNameField††| ‹
.††‹ 
Id†† 
,†† 
	SortOrder†† ™
=†† ›
$num†† 
,†† 

IsRequired†† ©
=††ª «
true††¬ °
}††± ²
,††² ³
new
‡‡ 
ItsTool
‡‡ 
.
‡‡  
Domain
‡‡  &
.
‡‡& '
Entities
‡‡' /
.
‡‡/ 0
Config
‡‡0 6
.
‡‡6 7 
FormFieldPlacement
‡‡7 I
{
‡‡J K

CategoryId
‡‡L V
=
‡‡W X

hwCategory
‡‡Y c
.
‡‡c d
Id
‡‡d f
,
‡‡f g
FieldDefinitionId
‡‡h y
=
‡‡z {!
impactedUsersField‡‡| 
.‡‡ 
Id‡‡ ‘
,‡‡‘ ’
	SortOrder‡‡“ 
=‡‡ 
$num‡‡  
,‡‡  ΅

IsRequired‡‡Ά ¬
=‡‡­ ®
false‡‡― ΄
}‡‡µ ¶
)
 
;
 
await
‰‰ 
_context
‰‰ 
.
‰‰ 
SaveChangesAsync
‰‰ /
(
‰‰/ 0
)
‰‰0 1
;
‰‰1 2
}
 
}
‹‹ 	
}
 
private
 
async
 
Task
 "
SeedSlaPoliciesAsync
 +
(
+ ,
)
, -
{
 
if
‘‘ 

(
‘‘ 
!
‘‘ 
await
‘‘ 
_context
‘‘ 
.
‘‘ 
SlaPolicies
‘‘ '
.
‘‘' (
AnyAsync
‘‘( 0
(
‘‘0 1
)
‘‘1 2
)
‘‘2 3
{
’’ 	
var
““ 
policy
““ 
=
““ 
new
““ 
	SlaPolicy
““ &
{
““' (
Name
““) -
=
““. /
$str
““0 D
,
““D E
Description
““F Q
=
““R S
$str
““T {
}
““| }
;
““} ~
_context
”” 
.
”” 
SlaPolicies
””  
.
””  !
Add
””! $
(
””$ %
policy
””% +
)
””+ ,
;
””, -
await
•• 
_context
•• 
.
•• 
SaveChangesAsync
•• +
(
••+ ,
)
••, -
;
••- .
var
—— 
critical
—— 
=
—— 
await
——  
_context
——! )
.
——) *

Priorities
——* 4
.
——4 5!
FirstOrDefaultAsync
——5 H
(
——H I
p
——I J
=>
——K M
p
——N O
.
——O P
Name
——P T
==
——U W
$str
——X `
)
——` a
;
——a b
var
 
high
 
=
 
await
 
_context
 %
.
% &

Priorities
& 0
.
0 1!
FirstOrDefaultAsync
1 D
(
D E
p
E F
=>
G I
p
J K
.
K L
Name
L P
==
Q S
$str
T \
)
\ ]
;
] ^
var
™™ 
medium
™™ 
=
™™ 
await
™™ 
_context
™™ '
.
™™' (

Priorities
™™( 2
.
™™2 3!
FirstOrDefaultAsync
™™3 F
(
™™F G
p
™™G H
=>
™™I K
p
™™L M
.
™™M N
Name
™™N R
==
™™S U
$str
™™V \
)
™™\ ]
;
™™] ^
var
 
low
 
=
 
await
 
_context
 $
.
$ %

Priorities
% /
.
/ 0!
FirstOrDefaultAsync
0 C
(
C D
p
D E
=>
F H
p
I J
.
J K
Name
K O
==
P R
$str
S Z
)
Z [
;
[ \
if
 
(
 
critical
 
!=
 
null
  
&&
! #
high
$ (
!=
) +
null
, 0
&&
1 3
medium
4 :
!=
; =
null
> B
&&
C E
low
F I
!=
J L
null
M Q
)
Q R
{
 
_context
 
.
 

SlaTargets
 #
.
# $
AddRange
$ ,
(
, -
new
 
	SlaTarget
 !
{
" #
SlaPolicyId
$ /
=
0 1
policy
2 8
.
8 9
Id
9 ;
,
; <

PriorityId
= G
=
H I
critical
J R
.
R S
Id
S U
,
U V"
FirstResponseMinutes
W k
=
l m
$num
n p
,
p q 
ResolutionMinutesr ƒ
=„ …
$num† ‰
} ‹
,‹ 
new
   
	SlaTarget
   !
{
  " #
SlaPolicyId
  $ /
=
  0 1
policy
  2 8
.
  8 9
Id
  9 ;
,
  ; <

PriorityId
  = G
=
  H I
high
  J N
.
  N O
Id
  O Q
,
  Q R"
FirstResponseMinutes
  S g
=
  h i
$num
  j m
,
  m n 
ResolutionMinutes  o €
=   ‚
$num  ƒ ‡
}   ‰
,  ‰ 
new
΅΅ 
	SlaTarget
΅΅ !
{
΅΅" #
SlaPolicyId
΅΅$ /
=
΅΅0 1
policy
΅΅2 8
.
΅΅8 9
Id
΅΅9 ;
,
΅΅; <

PriorityId
΅΅= G
=
΅΅H I
medium
΅΅J P
.
΅΅P Q
Id
΅΅Q S
,
΅΅S T"
FirstResponseMinutes
΅΅U i
=
΅΅j k
$num
΅΅l o
,
΅΅o p 
ResolutionMinutes΅΅q ‚
=΅΅ƒ „
$num΅΅… ‰
}΅΅ ‹
,΅΅‹ 
new
ΆΆ 
	SlaTarget
ΆΆ !
{
ΆΆ" #
SlaPolicyId
ΆΆ$ /
=
ΆΆ0 1
policy
ΆΆ2 8
.
ΆΆ8 9
Id
ΆΆ9 ;
,
ΆΆ; <

PriorityId
ΆΆ= G
=
ΆΆH I
low
ΆΆJ M
.
ΆΆM N
Id
ΆΆN P
,
ΆΆP Q"
FirstResponseMinutes
ΆΆR f
=
ΆΆg h
$num
ΆΆi m
,
ΆΆm n 
ResolutionMinutesΆΆo €
=ΆΆ ‚
$numΆΆƒ ‡
}ΆΆ ‰
)
££ 
;
££ 
}
¤¤ 
for
¦¦ 
(
¦¦ 
int
¦¦ 
i
¦¦ 
=
¦¦ 
$num
¦¦ 
;
¦¦ 
i
¦¦ 
<=
¦¦  
$num
¦¦! "
;
¦¦" #
i
¦¦$ %
++
¦¦% '
)
¦¦' (
{
§§ 
_context
¨¨ 
.
¨¨ 
BusinessHours
¨¨ &
.
¨¨& '
Add
¨¨' *
(
¨¨* +
new
¨¨+ .
BusinessHour
¨¨/ ;
{
©© 
	DayOfWeek
ªª 
=
ªª 
(
ªª  !
	DayOfWeek
ªª! *
)
ªª* +
i
ªª+ ,
,
ªª, -
	StartTime
«« 
=
«« 
new
««  #
TimeSpan
««$ ,
(
««, -
$num
««- .
,
««. /
$num
««0 1
,
««1 2
$num
««3 4
)
««4 5
,
««5 6
EndTime
¬¬ 
=
¬¬ 
new
¬¬ !
TimeSpan
¬¬" *
(
¬¬* +
$num
¬¬+ -
,
¬¬- .
$num
¬¬/ 0
,
¬¬0 1
$num
¬¬2 3
)
¬¬3 4
,
¬¬4 5
IsWorkingDay
­­  
=
­­! "
true
­­# '
}
®® 
)
®® 
;
®® 
}
―― 
_context
°° 
.
°° 
BusinessHours
°° "
.
°°" #
Add
°°# &
(
°°& '
new
°°' *
BusinessHour
°°+ 7
{
°°8 9
	DayOfWeek
°°: C
=
°°D E
	DayOfWeek
°°F O
.
°°O P
Saturday
°°P X
,
°°X Y
IsWorkingDay
°°Z f
=
°°g h
false
°°i n
}
°°o p
)
°°p q
;
°°q r
_context
±± 
.
±± 
BusinessHours
±± "
.
±±" #
Add
±±# &
(
±±& '
new
±±' *
BusinessHour
±±+ 7
{
±±8 9
	DayOfWeek
±±: C
=
±±D E
	DayOfWeek
±±F O
.
±±O P
Sunday
±±P V
,
±±V W
IsWorkingDay
±±X d
=
±±e f
false
±±g l
}
±±m n
)
±±n o
;
±±o p
await
³³ 
_context
³³ 
.
³³ 
SaveChangesAsync
³³ +
(
³³+ ,
)
³³, -
;
³³- .
}
΄΄ 	
}
µµ 
private
·· 
async
·· 
Task
·· *
SeedWorkflowTransitionsAsync
·· 3
(
··3 4
)
··4 5
{
ΈΈ 
var
ΊΊ 
defaultWorkflow
ΊΊ 
=
ΊΊ 
await
ΊΊ #
_context
ΊΊ$ ,
.
ΊΊ, -
	Workflows
ΊΊ- 6
.
ΊΊ6 7!
FirstOrDefaultAsync
ΊΊ7 J
(
ΊΊJ K
w
ΊΊK L
=>
ΊΊM O
w
ΊΊP Q
.
ΊΊQ R
Name
ΊΊR V
==
ΊΊW Y
$str
ΊΊZ s
)
ΊΊs t
;
ΊΊt u
if
»» 

(
»» 
defaultWorkflow
»» 
==
»» 
null
»» #
)
»»# $
{
ΌΌ 	
defaultWorkflow
½½ 
=
½½ 
new
½½ !
ItsTool
½½" )
.
½½) *
Domain
½½* 0
.
½½0 1
Entities
½½1 9
.
½½9 :
Workflow
½½: B
.
½½B C
Workflow
½½C K
{
ΎΎ 
Name
ΏΏ 
=
ΏΏ 
$str
ΏΏ 0
,
ΏΏ0 1
Description
ΐΐ 
=
ΐΐ 
$str
ΐΐ :
,
ΐΐ: ;
IsActive
ΑΑ 
=
ΑΑ 
true
ΑΑ 
}
ΒΒ 
;
ΒΒ 
_context
ΓΓ 
.
ΓΓ 
	Workflows
ΓΓ 
.
ΓΓ 
Add
ΓΓ "
(
ΓΓ" #
defaultWorkflow
ΓΓ# 2
)
ΓΓ2 3
;
ΓΓ3 4
await
ΔΔ 
_context
ΔΔ 
.
ΔΔ 
SaveChangesAsync
ΔΔ +
(
ΔΔ+ ,
)
ΔΔ, -
;
ΔΔ- .
}
ΕΕ 	
var
ΗΗ 

openStatus
ΗΗ 
=
ΗΗ 
await
ΗΗ "
_context
ΗΗ# +
.
ΗΗ+ ,
Statuses
ΗΗ, 4
.
ΗΗ4 5!
FirstOrDefaultAsync
ΗΗ5 H
(
ΗΗH I
s
ΗΗI J
=>
ΗΗK M
s
ΗΗN O
.
ΗΗO P
Name
ΗΗP T
==
ΗΗU W
StatusConstants
ΗΗX g
.
ΗΗg h
Open
ΗΗh l
)
ΗΗl m
;
ΗΗm n
var
ΘΘ 
inProgressStatus
ΘΘ  
=
ΘΘ! "
await
ΘΘ# (
_context
ΘΘ) 1
.
ΘΘ1 2
Statuses
ΘΘ2 :
.
ΘΘ: ;!
FirstOrDefaultAsync
ΘΘ; N
(
ΘΘN O
s
ΘΘO P
=>
ΘΘQ S
s
ΘΘT U
.
ΘΘU V
Name
ΘΘV Z
==
ΘΘ[ ]
StatusConstants
ΘΘ^ m
.
ΘΘm n

InProgress
ΘΘn x
)
ΘΘx y
;
ΘΘy z
var
ΙΙ 
onHoldStatus
ΙΙ 
=
ΙΙ 
await
ΙΙ $
_context
ΙΙ% -
.
ΙΙ- .
Statuses
ΙΙ. 6
.
ΙΙ6 7!
FirstOrDefaultAsync
ΙΙ7 J
(
ΙΙJ K
s
ΙΙK L
=>
ΙΙM O
s
ΙΙP Q
.
ΙΙQ R
Name
ΙΙR V
==
ΙΙW Y
StatusConstants
ΙΙZ i
.
ΙΙi j
OnHold
ΙΙj p
)
ΙΙp q
;
ΙΙq r
var
ΚΚ 
resolvedStatus
ΚΚ 
=
ΚΚ  
await
ΚΚ! &
_context
ΚΚ' /
.
ΚΚ/ 0
Statuses
ΚΚ0 8
.
ΚΚ8 9!
FirstOrDefaultAsync
ΚΚ9 L
(
ΚΚL M
s
ΚΚM N
=>
ΚΚO Q
s
ΚΚR S
.
ΚΚS T
Name
ΚΚT X
==
ΚΚY [
StatusConstants
ΚΚ\ k
.
ΚΚk l
Resolved
ΚΚl t
)
ΚΚt u
;
ΚΚu v
var
ΛΛ 
closedStatus
ΛΛ 
=
ΛΛ 
await
ΛΛ $
_context
ΛΛ% -
.
ΛΛ- .
Statuses
ΛΛ. 6
.
ΛΛ6 7!
FirstOrDefaultAsync
ΛΛ7 J
(
ΛΛJ K
s
ΛΛK L
=>
ΛΛM O
s
ΛΛP Q
.
ΛΛQ R
Name
ΛΛR V
==
ΛΛW Y
StatusConstants
ΛΛZ i
.
ΛΛi j
Closed
ΛΛj p
)
ΛΛp q
;
ΛΛq r
if
ΝΝ 

(
ΝΝ 

openStatus
ΝΝ 
!=
ΝΝ 
null
ΝΝ 
&&
ΝΝ !
inProgressStatus
ΝΝ" 2
!=
ΝΝ3 5
null
ΝΝ6 :
&&
ΝΝ; =
onHoldStatus
ΝΝ> J
!=
ΝΝK M
null
ΝΝN R
&&
ΝΝS U
resolvedStatus
ΝΝV d
!=
ΝΝe g
null
ΝΝh l
&&
ΝΝm o
closedStatus
ΝΝp |
!=
ΝΝ} 
nullΝΝ€ „
)ΝΝ„ …
{
ΞΞ 	
var
ΟΟ  
desiredTransitions
ΟΟ "
=
ΟΟ# $
new
ΟΟ% (
List
ΟΟ) -
<
ΟΟ- .
ItsTool
ΟΟ. 5
.
ΟΟ5 6
Domain
ΟΟ6 <
.
ΟΟ< =
Entities
ΟΟ= E
.
ΟΟE F
Workflow
ΟΟF N
.
ΟΟN O 
WorkflowTransition
ΟΟO a
>
ΟΟa b
{
ΠΠ 
new
ÒÒ 
(
ÒÒ 
)
ÒÒ 
{
ÒÒ 

WorkflowId
ÒÒ "
=
ÒÒ# $
defaultWorkflow
ÒÒ% 4
.
ÒÒ4 5
Id
ÒÒ5 7
,
ÒÒ7 8
FromStatusId
ÒÒ9 E
=
ÒÒF G

openStatus
ÒÒH R
.
ÒÒR S
Id
ÒÒS U
,
ÒÒU V

ToStatusId
ÒÒW a
=
ÒÒb c
inProgressStatus
ÒÒd t
.
ÒÒt u
Id
ÒÒu w
,
ÒÒw x
IsActiveÒÒy 
=ÒÒ‚ ƒ
trueÒÒ„ 
,ÒÒ ‰
TransitionNameÒÒ 
=ÒÒ™ 
$strÒÒ› «
}ÒÒ¬ ­
,ÒÒ­ ®
new
ΣΣ 
(
ΣΣ 
)
ΣΣ 
{
ΣΣ 

WorkflowId
ΣΣ "
=
ΣΣ# $
defaultWorkflow
ΣΣ% 4
.
ΣΣ4 5
Id
ΣΣ5 7
,
ΣΣ7 8
FromStatusId
ΣΣ9 E
=
ΣΣF G

openStatus
ΣΣH R
.
ΣΣR S
Id
ΣΣS U
,
ΣΣU V

ToStatusId
ΣΣW a
=
ΣΣb c
onHoldStatus
ΣΣd p
.
ΣΣp q
Id
ΣΣq s
,
ΣΣs t
IsActive
ΣΣu }
=
ΣΣ~ 
trueΣΣ€ „
,ΣΣ„ …
TransitionNameΣΣ† ”
=ΣΣ• –
$strΣΣ— ¤
}ΣΣ¥ ¦
,ΣΣ¦ §
new
ΤΤ 
(
ΤΤ 
)
ΤΤ 
{
ΤΤ 

WorkflowId
ΤΤ "
=
ΤΤ# $
defaultWorkflow
ΤΤ% 4
.
ΤΤ4 5
Id
ΤΤ5 7
,
ΤΤ7 8
FromStatusId
ΤΤ9 E
=
ΤΤF G

openStatus
ΤΤH R
.
ΤΤR S
Id
ΤΤS U
,
ΤΤU V

ToStatusId
ΤΤW a
=
ΤΤb c
resolvedStatus
ΤΤd r
.
ΤΤr s
Id
ΤΤs u
,
ΤΤu v
IsActive
ΤΤw 
=ΤΤ€ 
trueΤΤ‚ †
,ΤΤ† ‡
TransitionNameΤΤ –
=ΤΤ— 
$strΤΤ™ Ά
,ΤΤΆ £%
RequiredPermissionKeyΤΤ¤ Ή
=ΤΤΊ »#
PermissionConstantsΤΤΌ Ο
.ΤΤΟ Π
TicketResolveΤΤΠ έ
}ΤΤή ί
,ΤΤί ΰ
new
ΥΥ 
(
ΥΥ 
)
ΥΥ 
{
ΥΥ 

WorkflowId
ΥΥ "
=
ΥΥ# $
defaultWorkflow
ΥΥ% 4
.
ΥΥ4 5
Id
ΥΥ5 7
,
ΥΥ7 8
FromStatusId
ΥΥ9 E
=
ΥΥF G

openStatus
ΥΥH R
.
ΥΥR S
Id
ΥΥS U
,
ΥΥU V

ToStatusId
ΥΥW a
=
ΥΥb c
closedStatus
ΥΥd p
.
ΥΥp q
Id
ΥΥq s
,
ΥΥs t
IsActive
ΥΥu }
=
ΥΥ~ 
trueΥΥ€ „
,ΥΥ„ …
TransitionNameΥΥ† ”
=ΥΥ• –
$strΥΥ— 
,ΥΥ %
RequiredPermissionKeyΥΥ  µ
=ΥΥ¶ ·#
PermissionConstantsΥΥΈ Λ
.ΥΥΛ Μ
TicketCloseΥΥΜ Χ
}ΥΥΨ Ω
,ΥΥΩ Ϊ
new
ΨΨ 
(
ΨΨ 
)
ΨΨ 
{
ΨΨ 

WorkflowId
ΨΨ "
=
ΨΨ# $
defaultWorkflow
ΨΨ% 4
.
ΨΨ4 5
Id
ΨΨ5 7
,
ΨΨ7 8
FromStatusId
ΨΨ9 E
=
ΨΨF G
inProgressStatus
ΨΨH X
.
ΨΨX Y
Id
ΨΨY [
,
ΨΨ[ \

ToStatusId
ΨΨ] g
=
ΨΨh i

openStatus
ΨΨj t
.
ΨΨt u
Id
ΨΨu w
,
ΨΨw x
IsActiveΨΨy 
=ΨΨ‚ ƒ
trueΨΨ„ 
,ΨΨ ‰
TransitionNameΨΨ 
=ΨΨ™ 
$strΨΨ› ©
}ΨΨª «
,ΨΨ« ¬
new
ΩΩ 
(
ΩΩ 
)
ΩΩ 
{
ΩΩ 

WorkflowId
ΩΩ "
=
ΩΩ# $
defaultWorkflow
ΩΩ% 4
.
ΩΩ4 5
Id
ΩΩ5 7
,
ΩΩ7 8
FromStatusId
ΩΩ9 E
=
ΩΩF G
inProgressStatus
ΩΩH X
.
ΩΩX Y
Id
ΩΩY [
,
ΩΩ[ \

ToStatusId
ΩΩ] g
=
ΩΩh i
onHoldStatus
ΩΩj v
.
ΩΩv w
Id
ΩΩw y
,
ΩΩy z
IsActiveΩΩ{ ƒ
=ΩΩ„ …
trueΩΩ† 
,ΩΩ ‹
TransitionNameΩΩ 
=ΩΩ› 
$strΩΩ ª
}ΩΩ« ¬
,ΩΩ¬ ­
new
ΪΪ 
(
ΪΪ 
)
ΪΪ 
{
ΪΪ 

WorkflowId
ΪΪ "
=
ΪΪ# $
defaultWorkflow
ΪΪ% 4
.
ΪΪ4 5
Id
ΪΪ5 7
,
ΪΪ7 8
FromStatusId
ΪΪ9 E
=
ΪΪF G
inProgressStatus
ΪΪH X
.
ΪΪX Y
Id
ΪΪY [
,
ΪΪ[ \

ToStatusId
ΪΪ] g
=
ΪΪh i
resolvedStatus
ΪΪj x
.
ΪΪx y
Id
ΪΪy {
,
ΪΪ{ |
IsActiveΪΪ} …
=ΪΪ† ‡
trueΪΪ 
,ΪΪ 
TransitionNameΪΪ 
=ΪΪ 
$strΪΪ ¨
,ΪΪ¨ ©%
RequiredPermissionKeyΪΪª Ώ
=ΪΪΐ Α#
PermissionConstantsΪΪΒ Υ
.ΪΪΥ Φ
TicketResolveΪΪΦ γ
}ΪΪδ ε
,ΪΪε ζ
new
ΫΫ 
(
ΫΫ 
)
ΫΫ 
{
ΫΫ 

WorkflowId
ΫΫ "
=
ΫΫ# $
defaultWorkflow
ΫΫ% 4
.
ΫΫ4 5
Id
ΫΫ5 7
,
ΫΫ7 8
FromStatusId
ΫΫ9 E
=
ΫΫF G
inProgressStatus
ΫΫH X
.
ΫΫX Y
Id
ΫΫY [
,
ΫΫ[ \

ToStatusId
ΫΫ] g
=
ΫΫh i
closedStatus
ΫΫj v
.
ΫΫv w
Id
ΫΫw y
,
ΫΫy z
IsActiveΫΫ{ ƒ
=ΫΫ„ …
trueΫΫ† 
,ΫΫ ‹
TransitionNameΫΫ 
=ΫΫ› 
$strΫΫ ¤
,ΫΫ¤ ¥%
RequiredPermissionKeyΫΫ¦ »
=ΫΫΌ ½#
PermissionConstantsΫΫΎ Ρ
.ΫΫΡ Ò
TicketCloseΫΫÒ έ
}ΫΫή ί
,ΫΫί ΰ
new
ήή 
(
ήή 
)
ήή 
{
ήή 

WorkflowId
ήή "
=
ήή# $
defaultWorkflow
ήή% 4
.
ήή4 5
Id
ήή5 7
,
ήή7 8
FromStatusId
ήή9 E
=
ήήF G
onHoldStatus
ήήH T
.
ήήT U
Id
ήήU W
,
ήήW X

ToStatusId
ήήY c
=
ήήd e

openStatus
ήήf p
.
ήήp q
Id
ήήq s
,
ήήs t
IsActive
ήήu }
=
ήή~ 
trueήή€ „
,ήή„ …
TransitionNameήή† ”
=ήή• –
$strήή— ¥
}ήή¦ §
,ήή§ ¨
new
ίί 
(
ίί 
)
ίί 
{
ίί 

WorkflowId
ίί "
=
ίί# $
defaultWorkflow
ίί% 4
.
ίί4 5
Id
ίί5 7
,
ίί7 8
FromStatusId
ίί9 E
=
ίίF G
onHoldStatus
ίίH T
.
ίίT U
Id
ίίU W
,
ίίW X

ToStatusId
ίίY c
=
ίίd e
inProgressStatus
ίίf v
.
ίίv w
Id
ίίw y
,
ίίy z
IsActiveίί{ ƒ
=ίί„ …
trueίί† 
,ίί ‹
TransitionNameίί 
=ίί› 
$strίί ®
}ίί― °
,ίί° ±
new
ΰΰ 
(
ΰΰ 
)
ΰΰ 
{
ΰΰ 

WorkflowId
ΰΰ "
=
ΰΰ# $
defaultWorkflow
ΰΰ% 4
.
ΰΰ4 5
Id
ΰΰ5 7
,
ΰΰ7 8
FromStatusId
ΰΰ9 E
=
ΰΰF G
onHoldStatus
ΰΰH T
.
ΰΰT U
Id
ΰΰU W
,
ΰΰW X

ToStatusId
ΰΰY c
=
ΰΰd e
resolvedStatus
ΰΰf t
.
ΰΰt u
Id
ΰΰu w
,
ΰΰw x
IsActiveΰΰy 
=ΰΰ‚ ƒ
trueΰΰ„ 
,ΰΰ ‰
TransitionNameΰΰ 
=ΰΰ™ 
$strΰΰ› ¤
,ΰΰ¤ ¥%
RequiredPermissionKeyΰΰ¦ »
=ΰΰΌ ½#
PermissionConstantsΰΰΎ Ρ
.ΰΰΡ Ò
TicketResolveΰΰÒ ί
}ΰΰΰ α
,ΰΰα β
new
αα 
(
αα 
)
αα 
{
αα 

WorkflowId
αα "
=
αα# $
defaultWorkflow
αα% 4
.
αα4 5
Id
αα5 7
,
αα7 8
FromStatusId
αα9 E
=
ααF G
onHoldStatus
ααH T
.
ααT U
Id
ααU W
,
ααW X

ToStatusId
ααY c
=
ααd e
closedStatus
ααf r
.
ααr s
Id
ααs u
,
ααu v
IsActive
ααw 
=αα€ 
trueαα‚ †
,αα† ‡
TransitionNameαα –
=αα— 
$strαα™  
,αα  ΅%
RequiredPermissionKeyααΆ ·
=ααΈ Ή#
PermissionConstantsααΊ Ν
.ααΝ Ξ
TicketCloseααΞ Ω
}ααΪ Ϋ
,ααΫ ά
new
δδ 
(
δδ 
)
δδ 
{
δδ 

WorkflowId
δδ "
=
δδ# $
defaultWorkflow
δδ% 4
.
δδ4 5
Id
δδ5 7
,
δδ7 8
FromStatusId
δδ9 E
=
δδF G
resolvedStatus
δδH V
.
δδV W
Id
δδW Y
,
δδY Z

ToStatusId
δδ[ e
=
δδf g

openStatus
δδh r
.
δδr s
Id
δδs u
,
δδu v
IsActive
δδw 
=δδ€ 
trueδδ‚ †
,δδ† ‡
TransitionNameδδ –
=δδ— 
$strδδ™ ©
,δδ© ª%
RequiredPermissionKeyδδ« ΐ
=δδΑ Β#
PermissionConstantsδδΓ Φ
.δδΦ Χ
TicketReopenδδΧ γ
}δδδ ε
,δδε ζ
new
εε 
(
εε 
)
εε 
{
εε 

WorkflowId
εε "
=
εε# $
defaultWorkflow
εε% 4
.
εε4 5
Id
εε5 7
,
εε7 8
FromStatusId
εε9 E
=
εεF G
resolvedStatus
εεH V
.
εεV W
Id
εεW Y
,
εεY Z

ToStatusId
εε[ e
=
εεf g
inProgressStatus
εεh x
.
εεx y
Id
εεy {
,
εε{ |
IsActiveεε} …
=εε† ‡
trueεε 
,εε 
TransitionNameεε 
=εε 
$strεε ³
,εε³ ΄%
RequiredPermissionKeyεεµ Κ
=εεΛ Μ#
PermissionConstantsεεΝ ΰ
.εεΰ α
TicketReopenεεα ν
}εεξ ο
,εεο π
new
ζζ 
(
ζζ 
)
ζζ 
{
ζζ 

WorkflowId
ζζ "
=
ζζ# $
defaultWorkflow
ζζ% 4
.
ζζ4 5
Id
ζζ5 7
,
ζζ7 8
FromStatusId
ζζ9 E
=
ζζF G
resolvedStatus
ζζH V
.
ζζV W
Id
ζζW Y
,
ζζY Z

ToStatusId
ζζ[ e
=
ζζf g
onHoldStatus
ζζh t
.
ζζt u
Id
ζζu w
,
ζζw x
IsActiveζζy 
=ζζ‚ ƒ
trueζζ„ 
,ζζ ‰
TransitionNameζζ 
=ζζ™ 
$strζζ› ®
,ζζ® ―%
RequiredPermissionKeyζζ° Ε
=ζζΖ Η#
PermissionConstantsζζΘ Ϋ
.ζζΫ ά
TicketReopenζζά θ
}ζζι κ
,ζζκ λ
new
ηη 
(
ηη 
)
ηη 
{
ηη 

WorkflowId
ηη "
=
ηη# $
defaultWorkflow
ηη% 4
.
ηη4 5
Id
ηη5 7
,
ηη7 8
FromStatusId
ηη9 E
=
ηηF G
resolvedStatus
ηηH V
.
ηηV W
Id
ηηW Y
,
ηηY Z

ToStatusId
ηη[ e
=
ηηf g
closedStatus
ηηh t
.
ηηt u
Id
ηηu w
,
ηηw x
IsActiveηηy 
=ηη‚ ƒ
trueηη„ 
,ηη ‰
TransitionNameηη 
=ηη™ 
$strηη› Ά
,ηηΆ £%
RequiredPermissionKeyηη¤ Ή
=ηηΊ »#
PermissionConstantsηηΌ Ο
.ηηΟ Π
TicketCloseηηΠ Ϋ
}ηηά έ
,ηηέ ή
new
κκ 
(
κκ 
)
κκ 
{
κκ 

WorkflowId
κκ "
=
κκ# $
defaultWorkflow
κκ% 4
.
κκ4 5
Id
κκ5 7
,
κκ7 8
FromStatusId
κκ9 E
=
κκF G
closedStatus
κκH T
.
κκT U
Id
κκU W
,
κκW X

ToStatusId
κκY c
=
κκd e

openStatus
κκf p
.
κκp q
Id
κκq s
,
κκs t
IsActive
κκu }
=
κκ~ 
trueκκ€ „
,κκ„ …
TransitionNameκκ† ”
=κκ• –
$strκκ— §
,κκ§ ¨%
RequiredPermissionKeyκκ© Ύ
=κκΏ ΐ#
PermissionConstantsκκΑ Τ
.κκΤ Υ
TicketReopenκκΥ α
}κκβ γ
,κκγ δ
new
λλ 
(
λλ 
)
λλ 
{
λλ 

WorkflowId
λλ "
=
λλ# $
defaultWorkflow
λλ% 4
.
λλ4 5
Id
λλ5 7
,
λλ7 8
FromStatusId
λλ9 E
=
λλF G
closedStatus
λλH T
.
λλT U
Id
λλU W
,
λλW X

ToStatusId
λλY c
=
λλd e
inProgressStatus
λλf v
.
λλv w
Id
λλw y
,
λλy z
IsActiveλλ{ ƒ
=λλ„ …
trueλλ† 
,λλ ‹
TransitionNameλλ 
=λλ› 
$strλλ ±
,λλ± ²%
RequiredPermissionKeyλλ³ Θ
=λλΙ Κ#
PermissionConstantsλλΛ ή
.λλή ί
TicketReopenλλί λ
}λλμ ν
,λλν ξ
new
μμ 
(
μμ 
)
μμ 
{
μμ 

WorkflowId
μμ "
=
μμ# $
defaultWorkflow
μμ% 4
.
μμ4 5
Id
μμ5 7
,
μμ7 8
FromStatusId
μμ9 E
=
μμF G
closedStatus
μμH T
.
μμT U
Id
μμU W
,
μμW X

ToStatusId
μμY c
=
μμd e
onHoldStatus
μμf r
.
μμr s
Id
μμs u
,
μμu v
IsActive
μμw 
=μμ€ 
trueμμ‚ †
,μμ† ‡
TransitionNameμμ –
=μμ— 
$strμμ™ ¬
,μμ¬ ­%
RequiredPermissionKeyμμ® Γ
=μμΔ Ε#
PermissionConstantsμμΖ Ω
.μμΩ Ϊ
TicketReopenμμΪ ζ
}μμη θ
,μμθ ι
new
νν 
(
νν 
)
νν 
{
νν 

WorkflowId
νν "
=
νν# $
defaultWorkflow
νν% 4
.
νν4 5
Id
νν5 7
,
νν7 8
FromStatusId
νν9 E
=
ννF G
closedStatus
ννH T
.
ννT U
Id
ννU W
,
ννW X

ToStatusId
ννY c
=
ννd e
resolvedStatus
ννf t
.
ννt u
Id
ννu w
,
ννw x
IsActiveννy 
=νν‚ ƒ
trueνν„ 
,νν ‰
TransitionNameνν 
=νν™ 
$strνν› ―
,νν― °%
RequiredPermissionKeyνν± Ζ
=ννΗ Θ#
PermissionConstantsννΙ ά
.ννά έ
TicketReopenννέ ι
}ννκ λ
}
ξξ 
;
ξξ 
var
ππ  
currentTransitions
ππ "
=
ππ# $
await
ππ% *
_context
ππ+ 3
.
ππ3 4!
WorkflowTransitions
ππ4 G
.
ρρ 
Where
ρρ 
(
ρρ 
wt
ρρ 
=>
ρρ 
wt
ρρ 
.
ρρ  

WorkflowId
ρρ  *
==
ρρ+ -
defaultWorkflow
ρρ. =
.
ρρ= >
Id
ρρ> @
)
ρρ@ A
.
ςς 
ToListAsync
ςς 
(
ςς 
)
ςς 
;
ςς 
foreach
ττ 
(
ττ 
var
ττ 
dt
ττ 
in
ττ  
desiredTransitions
ττ 1
)
ττ1 2
{
υυ 
var
φφ 
exists
φφ 
=
φφ  
currentTransitions
φφ /
.
φφ/ 0
Any
φφ0 3
(
φφ3 4
wt
φφ4 6
=>
φφ7 9
wt
φφ: <
.
φφ< =
FromStatusId
φφ= I
==
φφJ L
dt
φφM O
.
φφO P
FromStatusId
φφP \
&&
φφ] _
wt
φφ` b
.
φφb c

ToStatusId
φφc m
==
φφn p
dt
φφq s
.
φφs t

ToStatusId
φφt ~
)
φφ~ 
;φφ €
if
χχ 
(
χχ 
!
χχ 
exists
χχ 
)
χχ 
{
ψψ 
_context
ωω 
.
ωω !
WorkflowTransitions
ωω 0
.
ωω0 1
Add
ωω1 4
(
ωω4 5
dt
ωω5 7
)
ωω7 8
;
ωω8 9
}
ϊϊ 
}
ϋϋ 
await
όό 
_context
όό 
.
όό 
SaveChangesAsync
όό +
(
όό+ ,
)
όό, -
;
όό- .
}
ύύ 	
var
ÿÿ !
existingTransitions
ÿÿ 
=
ÿÿ  !
await
ÿÿ" '
_context
ÿÿ( 0
.
ÿÿ0 1!
WorkflowTransitions
ÿÿ1 D
.
ÿÿD E
Where
ÿÿE J
(
ÿÿJ K
wt
ÿÿK M
=>
ÿÿN P
string
ÿÿQ W
.
ÿÿW X
IsNullOrEmpty
ÿÿX e
(
ÿÿe f
wt
ÿÿf h
.
ÿÿh i
TransitionName
ÿÿi w
)
ÿÿw x
)
ÿÿx y
.
ÿÿy z
ToListAsyncÿÿz …
(ÿÿ… †
)ÿÿ† ‡
;ÿÿ‡ 
if
€€ 

(
€€ !
existingTransitions
€€ 
.
€€  
Count
€€  %
>
€€& '
$num
€€( )
)
€€) *
{
 	
foreach
ƒƒ 
(
ƒƒ 
var
ƒƒ 
et
ƒƒ 
in
ƒƒ !
existingTransitions
ƒƒ 2
)
ƒƒ2 3
{
„„ 
if
…… 
(
…… 
(
…… 
et
…… 
.
…… 
FromStatusId
…… $
==
……% '
resolvedStatus
……( 6
?
……6 7
.
……7 8
Id
……8 :
||
……; =
et
……> @
.
……@ A
FromStatusId
……A M
==
……N P
closedStatus
……Q ]
?
……] ^
.
……^ _
Id
……_ a
)
……a b
&&
……c e
et
……f h
.
……h i

ToStatusId
……i s
==
……t v
inProgressStatus……w ‡
?……‡ 
.…… ‰
Id……‰ ‹
)……‹ 
{
†† 
et
‡‡ 
.
‡‡ 
TransitionName
‡‡ %
=
‡‡& '
$str
‡‡( 0
;
‡‡0 1
et
 
.
 #
RequiredPermissionKey
 ,
=
- .!
PermissionConstants
/ B
.
B C
TicketReopen
C O
;
O P
}
‰‰ 
else
 
{
‹‹ 
et
 
.
 
TransitionName
 %
=
& '
$str
( 1
;
1 2
}
 
}
 
await
 
_context
 
.
 
SaveChangesAsync
 +
(
+ ,
)
, -
;
- .
}
 	
}
‘‘ 
private
““ 
async
““ 
Task
““ $
SeedKnowledgeBaseAsync
““ -
(
““- .
)
““. /
{
”” 
if
–– 

(
–– 
!
–– 
await
–– 
_context
–– 
.
–– !
KnowledgeCategories
–– /
.
––/ 0
AnyAsync
––0 8
(
––8 9
)
––9 :
)
––: ;
{
—— 	
_context
 
.
 !
KnowledgeCategories
 (
.
( )
AddRange
) 1
(
1 2
new
™™ 
ItsTool
™™ 
.
™™ 
Domain
™™ "
.
™™" #
Entities
™™# +
.
™™+ ,
KnowledgeBase
™™, 9
.
™™9 :
KnowledgeCategory
™™: K
{
™™L M
Name
™™N R
=
™™S T
$str
™™U `
}
™™a b
,
™™b c
new
 
ItsTool
 
.
 
Domain
 "
.
" #
Entities
# +
.
+ ,
KnowledgeBase
, 9
.
9 :
KnowledgeCategory
: K
{
L M
Name
N R
=
S T
$str
U b
}
c d
,
d e
new
›› 
ItsTool
›› 
.
›› 
Domain
›› "
.
››" #
Entities
››# +
.
››+ ,
KnowledgeBase
››, 9
.
››9 :
KnowledgeCategory
››: K
{
››L M
Name
››N R
=
››S T
$str
››U g
}
››h i
)
 
;
 
await
 
_context
 
.
 
SaveChangesAsync
 +
(
+ ,
)
, -
;
- .
}
 	
if
   

(
   
!
   
await
   
_context
   
.
   
KnowledgeArticles
   -
.
  - .
AnyAsync
  . 6
(
  6 7
)
  7 8
)
  8 9
{
΅΅ 	
var
ΆΆ 
rehberlerCat
ΆΆ 
=
ΆΆ 
await
ΆΆ $
_context
ΆΆ% -
.
ΆΆ- .!
KnowledgeCategories
ΆΆ. A
.
ΆΆA B!
FirstOrDefaultAsync
ΆΆB U
(
ΆΆU V
c
ΆΆV W
=>
ΆΆX Z
c
ΆΆ[ \
.
ΆΆ\ ]
Name
ΆΆ] a
==
ΆΆb d
$str
ΆΆe p
)
ΆΆp q
;
ΆΆq r
var
££ 
prosedurlerCat
££ 
=
££  
await
££! &
_context
££' /
.
££/ 0!
KnowledgeCategories
££0 C
.
££C D!
FirstOrDefaultAsync
££D W
(
££W X
c
££X Y
=>
££Z \
c
££] ^
.
££^ _
Name
££_ c
==
££d f
$str
££g t
)
££t u
;
££u v
var
¤¤ 
	sistemCat
¤¤ 
=
¤¤ 
await
¤¤ !
_context
¤¤" *
.
¤¤* +!
KnowledgeCategories
¤¤+ >
.
¤¤> ?!
FirstOrDefaultAsync
¤¤? R
(
¤¤R S
c
¤¤S T
=>
¤¤U W
c
¤¤X Y
.
¤¤Y Z
Name
¤¤Z ^
==
¤¤_ a
$str
¤¤b t
)
¤¤t u
;
¤¤u v
var
¦¦ 
adminAuthor
¦¦ 
=
¦¦ 
await
¦¦ #
_context
¦¦$ ,
.
¦¦, -
Users
¦¦- 2
.
¦¦2 3!
FirstOrDefaultAsync
¦¦3 F
(
¦¦F G
u
¦¦G H
=>
¦¦I K
u
¦¦L M
.
¦¦M N
Username
¦¦N V
==
¦¦W Y
$str
¦¦Z a
)
¦¦a b
;
¦¦b c
if
¨¨ 
(
¨¨ 
adminAuthor
¨¨ 
!=
¨¨ 
null
¨¨ #
&&
¨¨$ &
rehberlerCat
¨¨' 3
!=
¨¨4 6
null
¨¨7 ;
&&
¨¨< >
prosedurlerCat
¨¨? M
!=
¨¨N P
null
¨¨Q U
&&
¨¨V X
	sistemCat
¨¨Y b
!=
¨¨c e
null
¨¨f j
)
¨¨j k
{
©© 
_context
ªª 
.
ªª 
KnowledgeArticles
ªª *
.
ªª* +
AddRange
ªª+ 3
(
ªª3 4
new
«« 
ItsTool
«« 
.
««  
Domain
««  &
.
««& '
Entities
««' /
.
««/ 0
KnowledgeBase
««0 =
.
««= >
KnowledgeArticle
««> N
{
¬¬ 
Title
­­ 
=
­­ 
$str
­­  6
,
­­6 7
Content
®® 
=
®®  !
$str®®" Α
,®®Α Β

CategoryId
―― "
=
――# $
rehberlerCat
――% 1
.
――1 2
Id
――2 4
,
――4 5
AuthorUserId
°° $
=
°°% &
adminAuthor
°°' 2
.
°°2 3
Id
°°3 5
,
°°5 6

Visibility
±± "
=
±±# $
ItsTool
±±% ,
.
±±, -
Domain
±±- 3
.
±±3 4
Entities
±±4 <
.
±±< =
KnowledgeBase
±±= J
.
±±J K
ArticleVisibility
±±K \
.
±±\ ]
Public
±±] c
,
±±c d
Status
²² 
=
²²  
ItsTool
²²! (
.
²²( )
Domain
²²) /
.
²²/ 0
Entities
²²0 8
.
²²8 9
KnowledgeBase
²²9 F
.
²²F G
ArticleStatus
²²G T
.
²²T U
	Published
²²U ^
,
²²^ _
	ViewCount
³³ !
=
³³" #
$num
³³$ &
}
΄΄ 
,
΄΄ 
new
µµ 
ItsTool
µµ 
.
µµ  
Domain
µµ  &
.
µµ& '
Entities
µµ' /
.
µµ/ 0
KnowledgeBase
µµ0 =
.
µµ= >
KnowledgeArticle
µµ> N
{
¶¶ 
Title
·· 
=
·· 
$str
··  <
,
··< =
Content
ΈΈ 
=
ΈΈ  !
$strΈΈ" Ξ
,ΈΈΞ Ο

CategoryId
ΉΉ "
=
ΉΉ# $
prosedurlerCat
ΉΉ% 3
.
ΉΉ3 4
Id
ΉΉ4 6
,
ΉΉ6 7
AuthorUserId
ΊΊ $
=
ΊΊ% &
adminAuthor
ΊΊ' 2
.
ΊΊ2 3
Id
ΊΊ3 5
,
ΊΊ5 6

Visibility
»» "
=
»»# $
ItsTool
»»% ,
.
»», -
Domain
»»- 3
.
»»3 4
Entities
»»4 <
.
»»< =
KnowledgeBase
»»= J
.
»»J K
ArticleVisibility
»»K \
.
»»\ ]
Public
»»] c
,
»»c d
Status
ΌΌ 
=
ΌΌ  
ItsTool
ΌΌ! (
.
ΌΌ( )
Domain
ΌΌ) /
.
ΌΌ/ 0
Entities
ΌΌ0 8
.
ΌΌ8 9
KnowledgeBase
ΌΌ9 F
.
ΌΌF G
ArticleStatus
ΌΌG T
.
ΌΌT U
	Published
ΌΌU ^
,
ΌΌ^ _
	ViewCount
½½ !
=
½½" #
$num
½½$ %
}
ΎΎ 
,
ΎΎ 
new
ΏΏ 
ItsTool
ΏΏ 
.
ΏΏ  
Domain
ΏΏ  &
.
ΏΏ& '
Entities
ΏΏ' /
.
ΏΏ/ 0
KnowledgeBase
ΏΏ0 =
.
ΏΏ= >
KnowledgeArticle
ΏΏ> N
{
ΐΐ 
Title
ΑΑ 
=
ΑΑ 
$str
ΑΑ  >
,
ΑΑ> ?
Content
ΒΒ 
=
ΒΒ  !
$strΒΒ" Ζ
,ΒΒΖ Η

CategoryId
ΓΓ "
=
ΓΓ# $
	sistemCat
ΓΓ% .
.
ΓΓ. /
Id
ΓΓ/ 1
,
ΓΓ1 2
AuthorUserId
ΔΔ $
=
ΔΔ% &
adminAuthor
ΔΔ' 2
.
ΔΔ2 3
Id
ΔΔ3 5
,
ΔΔ5 6

Visibility
ΕΕ "
=
ΕΕ# $
ItsTool
ΕΕ% ,
.
ΕΕ, -
Domain
ΕΕ- 3
.
ΕΕ3 4
Entities
ΕΕ4 <
.
ΕΕ< =
KnowledgeBase
ΕΕ= J
.
ΕΕJ K
ArticleVisibility
ΕΕK \
.
ΕΕ\ ]
Internal
ΕΕ] e
,
ΕΕe f
Status
ΖΖ 
=
ΖΖ  
ItsTool
ΖΖ! (
.
ΖΖ( )
Domain
ΖΖ) /
.
ΖΖ/ 0
Entities
ΖΖ0 8
.
ΖΖ8 9
KnowledgeBase
ΖΖ9 F
.
ΖΖF G
ArticleStatus
ΖΖG T
.
ΖΖT U
	Published
ΖΖU ^
,
ΖΖ^ _
	ViewCount
ΗΗ !
=
ΗΗ" #
$num
ΗΗ$ %
}
ΘΘ 
,
ΘΘ 
new
ΙΙ 
ItsTool
ΙΙ 
.
ΙΙ  
Domain
ΙΙ  &
.
ΙΙ& '
Entities
ΙΙ' /
.
ΙΙ/ 0
KnowledgeBase
ΙΙ0 =
.
ΙΙ= >
KnowledgeArticle
ΙΙ> N
{
ΚΚ 
Title
ΛΛ 
=
ΛΛ 
$str
ΛΛ  B
,
ΛΛB C
Content
ΜΜ 
=
ΜΜ  !
$strΜΜ" £
,ΜΜ£ ¤

CategoryId
ΝΝ "
=
ΝΝ# $
rehberlerCat
ΝΝ% 1
.
ΝΝ1 2
Id
ΝΝ2 4
,
ΝΝ4 5
AuthorUserId
ΞΞ $
=
ΞΞ% &
adminAuthor
ΞΞ' 2
.
ΞΞ2 3
Id
ΞΞ3 5
,
ΞΞ5 6

Visibility
ΟΟ "
=
ΟΟ# $
ItsTool
ΟΟ% ,
.
ΟΟ, -
Domain
ΟΟ- 3
.
ΟΟ3 4
Entities
ΟΟ4 <
.
ΟΟ< =
KnowledgeBase
ΟΟ= J
.
ΟΟJ K
ArticleVisibility
ΟΟK \
.
ΟΟ\ ]
Internal
ΟΟ] e
,
ΟΟe f
Status
ΠΠ 
=
ΠΠ  
ItsTool
ΠΠ! (
.
ΠΠ( )
Domain
ΠΠ) /
.
ΠΠ/ 0
Entities
ΠΠ0 8
.
ΠΠ8 9
KnowledgeBase
ΠΠ9 F
.
ΠΠF G
ArticleStatus
ΠΠG T
.
ΠΠT U
Draft
ΠΠU Z
,
ΠΠZ [
	ViewCount
ΡΡ !
=
ΡΡ" #
$num
ΡΡ$ %
}
ÒÒ 
)
ΣΣ 
;
ΣΣ 
await
ΤΤ 
_context
ΤΤ 
.
ΤΤ 
SaveChangesAsync
ΤΤ /
(
ΤΤ/ 0
)
ΤΤ0 1
;
ΤΤ1 2
}
ΥΥ 
}
ΦΦ 	
}
ΧΧ 
}ΩΩ ¥
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
 €
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
} ϋ"
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