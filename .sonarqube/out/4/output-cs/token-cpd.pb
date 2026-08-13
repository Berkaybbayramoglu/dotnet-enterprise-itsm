Î
g/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Security/PermissionAuthorizationHandler.cs
	namespace 	
ItsTool
 
. 
API 
. 
Security 
; 
public 
class !
PermissionRequirement "
:# $%
IAuthorizationRequirement% >
{ 
public 

string 

Permission 
{ 
get "
;" #
}$ %
public 
!
PermissionRequirement  
(  !
string! '

permission( 2
)2 3
=>4 6

Permission7 A
=B C

permissionD N
;N O
}		 
public 
class *
PermissionAuthorizationHandler +
:, - 
AuthorizationHandler. B
<B C!
PermissionRequirementC X
>X Y
{ 
	protected 
override 
Task "
HandleRequirementAsync 2
(2 3'
AuthorizationHandlerContext3 N
contextO V
,V W!
PermissionRequirementX m
requirementn y
)y z
{ 
var 
hasPermission 
= 
context #
.# $
User$ (
.( )
HasClaim) 1
(1 2
c2 3
=>4 6
c 
. 
Type 
== 
$str "
&&# %
c& '
.' (
Value( -
==. 0
requirement1 <
.< =

Permission= G
)G H
;H I
if 

( 
hasPermission 
) 
{ 	
context 
. 
Succeed 
( 
requirement '
)' (
;( )
} 	
return 
Task 
. 
CompletedTask !
;! "
} 
} ßO
G/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Program.cs
var 
builder 
= 
WebApplication 
. 
CreateBuilder *
(* +
args+ /
)/ 0
;0 1
builder 
. 
Services 
. 
AddControllers 
(  
)  !
;! "
builder 
. 
Services 
. #
AddEndpointsApiExplorer (
(( )
)) *
;* +
builder 
. 
Services 
. 
AddSwaggerGen 
( 
)  
;  !
builder 
. 
Services 
. 
AddDbContext 
< 
ItsToolDbContext .
>. /
(/ 0
options0 7
=>8 :
options 
. 
	UseNpgsql 
( 
builder 
. 
Configuration +
.+ ,
GetConnectionString, ?
(? @
$str@ S
)S T
)T U
)U V
;V W
builder 
. 
Services 
. 
	AddScoped 
< 

DataSeeder %
>% &
(& '
)' (
;( )
builder 
. 
Services 
. 
	AddScoped 
< 
ITokenService (
,( )
TokenService* 6
>6 7
(7 8
)8 9
;9 :
builder 
. 
Services 
. 
	AddScoped 
< !
IPermissionCalculator 0
,0 1 
PermissionCalculator2 F
>F G
(G H
)H I
;I J
builder 
. 
Services 
. 
	AddScoped 
< 
IAuthService '
,' (
AuthService) 4
>4 5
(5 6
)6 7
;7 8
builder 
. 
Services 
. 
	AddScoped 
( 
typeof !
(! "
IRepository" -
<- .
>. /
)/ 0
,0 1
typeof2 8
(8 9

Repository9 C
<C D
>D E
)E F
)F G
;G H
builder 
. 
Services 
. 
	AddScoped 
< 
IDepartmentService -
,- .
DepartmentService/ @
>@ A
(A B
)B C
;C D
builder 
. 
Services 
. 
	AddScoped 
< 
IGroupService (
,( )
GroupService* 6
>6 7
(7 8
)8 9
;9 :
builder   
.   
Services   
.   
	AddScoped   
<   
IUserService   '
,  ' (
UserService  ) 4
>  4 5
(  5 6
)  6 7
;  7 8
builder!! 
.!! 
Services!! 
.!! 
	AddScoped!! 
<!! 
IProjectService!! *
,!!* +
ProjectService!!, :
>!!: ;
(!!; <
)!!< =
;!!= >
builder"" 
."" 
Services"" 
."" 
	AddScoped"" 
<"" 
IRoleService"" '
,""' (
RoleService"") 4
>""4 5
(""5 6
)""6 7
;""7 8
builder%% 
.%% 
Services%% 
.%% 
	AddScoped%% 
<%% 
ICatalogService%% *
,%%* +
CatalogService%%, :
>%%: ;
(%%; <
)%%< =
;%%= >
builder&& 
.&& 
Services&& 
.&& 
	AddScoped&& 
<&& 
IWorkflowService&& +
,&&+ ,
WorkflowService&&- <
>&&< =
(&&= >
)&&> ?
;&&? @
builder'' 
.'' 
Services'' 
.'' 
	AddScoped'' 
<'' 
IDynamicFormService'' .
,''. /
DynamicFormService''0 B
>''B C
(''C D
)''D E
;''E F
builder** 
.** 
Services** 
.** 
AddAuthentication** "
(**" #
JwtBearerDefaults**# 4
.**4 5 
AuthenticationScheme**5 I
)**I J
.++ 
AddJwtBearer++ 
(++ 
options++ 
=>++ 
{,, 
options-- 
.-- %
TokenValidationParameters-- )
=--* +
new--, /%
TokenValidationParameters--0 I
{.. 	
ValidateIssuer// 
=// 
true// !
,//! "
ValidateAudience00 
=00 
true00 #
,00# $
ValidateLifetime11 
=11 
true11 #
,11# $$
ValidateIssuerSigningKey22 $
=22% &
true22' +
,22+ ,
ValidIssuer33 
=33 
builder33 !
.33! "
Configuration33" /
[33/ 0
$str330 <
]33< =
,33= >
ValidAudience44 
=44 
builder44 #
.44# $
Configuration44$ 1
[441 2
$str442 @
]44@ A
,44A B
IssuerSigningKey55 
=55 
new55 " 
SymmetricSecurityKey55# 7
(557 8
Encoding558 @
.55@ A
UTF855A E
.55E F
GetBytes55F N
(55N O
builder55O V
.55V W
Configuration55W d
[55d e
$str55e q
]55q r
??55s u
$str	55v •
)
55• ¶
)
55¶ ß
}66 	
;66	 

}77 
)77 
;77 
builder99 
.99 
Services99 
.99 
AddSingleton99 
<99 !
IAuthorizationHandler99 3
,993 4*
PermissionAuthorizationHandler995 S
>99S T
(99T U
)99U V
;99V W
builder:: 
.:: 
Services:: 
.:: 
AddAuthorization:: !
(::! "
options::" )
=>::* ,
{;; 
foreach<< 
(<< 
var<< 
perm<< 
in<< 
PermissionConstants<< ,
.<<, -
AllPermissions<<- ;
)<<; <
{== 
options>> 
.>> 
	AddPolicy>> 
(>> 
$">> 
$str>> .
{>>. /
perm>>/ 3
}>>3 4
">>4 5
,>>5 6
policy>>7 =
=>>>> @
policy?? 
.?? 
Requirements?? 
.??  
Add??  #
(??# $
new??$ '!
PermissionRequirement??( =
(??= >
perm??> B
)??B C
)??C D
)??D E
;??E F
}@@ 
}AA 
)AA 
;AA 
varDD 
allowedOriginsDD 
=DD 
builderDD 
.DD 
ConfigurationDD *
.DD* +

GetSectionDD+ 5
(DD5 6
$strDD6 K
)DDK L
.DDL M
GetDDM P
<DDP Q
stringDDQ W
[DDW X
]DDX Y
>DDY Z
(DDZ [
)DD[ \
??EE 
ArrayEE 
.EE 	
EmptyEE	 
<EE 
stringEE 
>EE 
(EE 
)EE 
;EE 
builderGG 
.GG 
ServicesGG 
.GG 
AddCorsGG 
(GG 
optionsGG  
=>GG! #
{HH 
optionsII 
.II 
	AddPolicyII 
(II 
$strII &
,II& '
builderII( /
=>II0 2
{JJ 
builderKK 
.KK 
WithOriginsKK 
(KK 
allowedOriginsKK *
)KK* +
.LL 
AllowAnyMethodLL 
(LL 
)LL 
.MM 
AllowAnyHeaderMM 
(MM 
)MM 
;MM 
}NN 
)NN 
;NN 
}PP 
)PP 
;PP 
varRR 
appRR 
=RR 	
builderRR
 
.RR 
BuildRR 
(RR 
)RR 
;RR 
ifUU 
(UU 
appUU 
.UU 
EnvironmentUU 
.UU 
IsDevelopmentUU !
(UU! "
)UU" #
)UU# $
{VV 
appWW 
.WW 

UseSwaggerWW 
(WW 
)WW 
;WW 
appXX 
.XX 
UseSwaggerUIXX 
(XX 
)XX 
;XX 
}YY 
app[[ 
.[[ 
UseCors[[ 
([[ 
$str[[ 
)[[ 
;[[ 
app\\ 
.\\ 
UseHttpsRedirection\\ 
(\\ 
)\\ 
;\\ 
app^^ 
.^^ 
UseAuthentication^^ 
(^^ 
)^^ 
;^^ 
app__ 
.__ 
UseAuthorization__ 
(__ 
)__ 
;__ 
appaa 
.aa 
MapGetaa 

(aa
 
$straa 
,aa 
(aa 
)aa 
=>aa 
{bb 
returncc 

Resultscc 
.cc 
Okcc 
(cc 
newcc 
{dd 
statusee 
=ee 
$stree 
,ee 
serviceff 
=ff 
$strff 
,ff  
	timestampgg 
=gg 
DateTimegg 
.gg 
UtcNowgg #
}hh 
)hh 
;hh 
}ii 
)ii 
;ii 
appkk 
.kk 
MapControllerskk 
(kk 
)kk 
;kk 
awaitmm 
appmm 	
.mm	 

RunAsyncmm
 
(mm 
)mm 
;mm ÏP
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/WorkflowController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
[

 
	Authorize

 

(


 
Policy

 
=

 
$str

 5
)

5 6
]

6 7
public 
class 
WorkflowController 
:  !
ControllerBase" 0
{ 
private 
readonly 
IWorkflowService %
_service& .
;. /
public 

WorkflowController 
( 
IWorkflowService .
service/ 6
)6 7
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
WorkflowDto- 8
>8 9
)9 :
,: ;
StatusCodes< G
.G H
Status200OKH S
)S T
]T U
public 

async 
Task 
< 
IActionResult #
># $
GetWorkflows% 1
(1 2
[2 3
	FromQuery3 <
]< =
int> A
?A B
	projectIdC L
)L M
{ 
return 
Ok 
( 
await 
_service  
.  !
GetWorkflowsAsync! 2
(2 3
	projectId3 <
)< =
)= >
;> ?
} 
[ 
HttpPost 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
WorkflowDto! ,
), -
,- .
StatusCodes/ :
.: ;
Status201Created; K
)K L
]L M
public 

async 
Task 
< 
IActionResult #
># $
CreateWorkflow% 3
(3 4
[4 5
FromBody5 =
]= >
CreateWorkflowDto? P
dtoQ T
)T U
{ 
var 
result 
= 
await 
_service #
.# $
CreateWorkflowAsync$ 7
(7 8
dto8 ;
); <
;< =
return   
CreatedAtAction   
(   
nameof   %
(  % &
GetWorkflows  & 2
)  2 3
,  3 4
new  5 8
{  9 :
id  ; =
=  > ?
result  @ F
.  F G
Id  G I
}  J K
,  K L
result  M S
)  S T
;  T U
}!! 
[## 
HttpPut## 
(## 
$str## 
)## 
]## 
[$$  
ProducesResponseType$$ 
($$ 
StatusCodes$$ %
.$$% &
Status204NoContent$$& 8
)$$8 9
]$$9 :
[%%  
ProducesResponseType%% 
(%% 
StatusCodes%% %
.%%% &
Status404NotFound%%& 7
)%%7 8
]%%8 9
public&& 

async&& 
Task&& 
<&& 
IActionResult&& #
>&&# $
UpdateWorkflow&&% 3
(&&3 4
int&&4 7
id&&8 :
,&&: ;
[&&< =
FromBody&&= E
]&&E F
UpdateWorkflowDto&&G X
dto&&Y \
)&&\ ]
{'' 
try(( 
{(( 
await(( 
_service(( 
.(( 
UpdateWorkflowAsync(( 0
(((0 1
id((1 3
,((3 4
dto((5 8
)((8 9
;((9 :
return((; A
	NoContent((B K
(((K L
)((L M
;((M N
}((O P
catch)) 
())  
KeyNotFoundException)) #
)))# $
{))% &
return))' -
NotFound)). 6
())6 7
)))7 8
;))8 9
})): ;
}** 
[,, 

HttpDelete,, 
(,, 
$str,, 
),, 
],, 
[--  
ProducesResponseType-- 
(-- 
StatusCodes-- %
.--% &
Status204NoContent--& 8
)--8 9
]--9 :
public.. 

async.. 
Task.. 
<.. 
IActionResult.. #
>..# $
DeleteWorkflow..% 3
(..3 4
int..4 7
id..8 :
)..: ;
{// 
await00 
_service00 
.00 
DeleteWorkflowAsync00 *
(00* +
id00+ -
)00- .
;00. /
return000 6
	NoContent007 @
(00@ A
)00A B
;00B C
}11 
[33 
HttpGet33 
(33 
$str33 '
)33' (
]33( )
[44  
ProducesResponseType44 
(44 
typeof44  
(44  !
IEnumerable44! ,
<44, -!
WorkflowTransitionDto44- B
>44B C
)44C D
,44D E
StatusCodes44F Q
.44Q R
Status200OK44R ]
)44] ^
]44^ _
public55 

async55 
Task55 
<55 
IActionResult55 #
>55# $
GetTransitions55% 3
(553 4
int554 7

workflowId558 B
)55B C
{66 
return77 
Ok77 
(77 
await77 
_service77  
.77  !+
GetTransitionsByWorkflowIdAsync77! @
(77@ A

workflowId77A K
)77K L
)77L M
;77M N
}88 
[:: 
HttpPost:: 
(:: 
$str:: 
):: 
]:: 
[;;  
ProducesResponseType;; 
(;; 
typeof;;  
(;;  !!
WorkflowTransitionDto;;! 6
);;6 7
,;;7 8
StatusCodes;;9 D
.;;D E
Status201Created;;E U
);;U V
];;V W
[<<  
ProducesResponseType<< 
(<< 
StatusCodes<< %
.<<% &
Status400BadRequest<<& 9
)<<9 :
]<<: ;
public== 

async== 
Task== 
<== 
IActionResult== #
>==# $
CreateTransition==% 5
(==5 6
[==6 7
FromBody==7 ?
]==? @'
CreateWorkflowTransitionDto==A \
dto==] `
)==` a
{>> 
try?? 
{@@ 	
varAA 
resultAA 
=AA 
awaitAA 
_serviceAA '
.AA' (!
CreateTransitionAsyncAA( =
(AA= >
dtoAA> A
)AAA B
;AAB C
returnBB 
CreatedAtActionBB "
(BB" #
nameofBB# )
(BB) *
GetWorkflowsBB* 6
)BB6 7
,BB7 8
newBB9 <
{BB= >
idBB? A
=BBB C
resultBBD J
.BBJ K
IdBBK M
}BBN O
,BBO P
resultBBQ W
)BBW X
;BBX Y
}CC 	
catchDD 
(DD %
InvalidOperationExceptionDD (
exDD) +
)DD+ ,
{DD- .
returnDD/ 5

BadRequestDD6 @
(DD@ A
newDDA D
{DDE F
errorDDG L
=DDM N
exDDO Q
.DDQ R
MessageDDR Y
}DDZ [
)DD[ \
;DD\ ]
}DD^ _
}EE 
[GG 
HttpPutGG 
(GG 
$strGG 
)GG  
]GG  !
[HH  
ProducesResponseTypeHH 
(HH 
StatusCodesHH %
.HH% &
Status204NoContentHH& 8
)HH8 9
]HH9 :
[II  
ProducesResponseTypeII 
(II 
StatusCodesII %
.II% &
Status400BadRequestII& 9
)II9 :
]II: ;
[JJ  
ProducesResponseTypeJJ 
(JJ 
StatusCodesJJ %
.JJ% &
Status404NotFoundJJ& 7
)JJ7 8
]JJ8 9
publicKK 

asyncKK 
TaskKK 
<KK 
IActionResultKK #
>KK# $
UpdateTransitionKK% 5
(KK5 6
intKK6 9
idKK: <
,KK< =
[KK> ?
FromBodyKK? G
]KKG H'
UpdateWorkflowTransitionDtoKKI d
dtoKKe h
)KKh i
{LL 
tryMM 
{MM 
awaitMM 
_serviceMM 
.MM !
UpdateTransitionAsyncMM 2
(MM2 3
idMM3 5
,MM5 6
dtoMM7 :
)MM: ;
;MM; <
returnMM= C
	NoContentMMD M
(MMM N
)MMN O
;MMO P
}MMQ R
catchNN 
(NN  
KeyNotFoundExceptionNN #
)NN# $
{NN% &
returnNN' -
NotFoundNN. 6
(NN6 7
)NN7 8
;NN8 9
}NN: ;
catchOO 
(OO %
InvalidOperationExceptionOO (
exOO) +
)OO+ ,
{OO- .
returnOO/ 5

BadRequestOO6 @
(OO@ A
newOOA D
{OOE F
errorOOG L
=OOM N
exOOO Q
.OOQ R
MessageOOR Y
}OOZ [
)OO[ \
;OO\ ]
}OO^ _
}PP 
[RR 

HttpDeleteRR 
(RR 
$strRR "
)RR" #
]RR# $
[SS  
ProducesResponseTypeSS 
(SS 
StatusCodesSS %
.SS% &
Status204NoContentSS& 8
)SS8 9
]SS9 :
publicTT 

asyncTT 
TaskTT 
<TT 
IActionResultTT #
>TT# $
DeleteTransitionTT% 5
(TT5 6
intTT6 9
idTT: <
)TT< =
{UU 
awaitVV 
_serviceVV 
.VV !
DeleteTransitionAsyncVV ,
(VV, -
idVV- /
)VV/ 0
;VV0 1
returnVV2 8
	NoContentVV9 B
(VVB C
)VVC D
;VVD E
}WW 
}XX òG
[/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/UsersController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
[

 
	Authorize

 

(


 
Policy

 
=

 
$str

 4
)

4 5
]

5 6
public 
class 
UsersController 
: 
ControllerBase -
{ 
private 
readonly 
IUserService !
_service" *
;* +
public 

UsersController 
( 
IUserService '
service( /
)/ 0
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
UserDto- 4
>4 5
)5 6
,6 7
StatusCodes8 C
.C D
Status200OKD O
)O P
]P Q
public 

async 
Task 
< 
IActionResult #
># $
GetAll% +
(+ ,
), -
{ 
return 
Ok 
( 
await 
_service  
.  !
GetAllAsync! ,
(, -
)- .
). /
;/ 0
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
UserDto! (
)( )
,) *
StatusCodes+ 6
.6 7
Status200OK7 B
)B C
]C D
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status404NotFound& 7
)7 8
]8 9
public 

async 
Task 
< 
IActionResult #
># $
GetById% ,
(, -
int- 0
id1 3
)3 4
{ 
var   
user   
=   
await   
_service   !
.  ! "
GetByIdAsync  " .
(  . /
id  / 1
)  1 2
;  2 3
if!! 

(!! 
user!! 
==!! 
null!! 
)!! 
return!!  
NotFound!!! )
(!!) *
)!!* +
;!!+ ,
return"" 
Ok"" 
("" 
user"" 
)"" 
;"" 
}## 
[%% 
HttpPost%% 
]%% 
[&&  
ProducesResponseType&& 
(&& 
typeof&&  
(&&  !
UserDto&&! (
)&&( )
,&&) *
StatusCodes&&+ 6
.&&6 7
Status201Created&&7 G
)&&G H
]&&H I
public'' 

async'' 
Task'' 
<'' 
IActionResult'' #
>''# $
Create''% +
(''+ ,
['', -
FromBody''- 5
]''5 6
CreateUserDto''7 D
dto''E H
)''H I
{(( 
var)) 
created)) 
=)) 
await)) 
_service)) $
.))$ %
CreateAsync))% 0
())0 1
dto))1 4
)))4 5
;))5 6
return** 
CreatedAtAction** 
(** 
nameof** %
(**% &
GetById**& -
)**- .
,**. /
new**0 3
{**4 5
id**6 8
=**9 :
created**; B
.**B C
Id**C E
}**F G
,**G H
created**I P
)**P Q
;**Q R
}++ 
[-- 
HttpPut-- 
(-- 
$str-- 
)-- 
]-- 
[..  
ProducesResponseType.. 
(.. 
StatusCodes.. %
...% &
Status204NoContent..& 8
)..8 9
]..9 :
[//  
ProducesResponseType// 
(// 
StatusCodes// %
.//% &
Status404NotFound//& 7
)//7 8
]//8 9
public00 

async00 
Task00 
<00 
IActionResult00 #
>00# $
Update00% +
(00+ ,
int00, /
id000 2
,002 3
[004 5
FromBody005 =
]00= >
UpdateUserDto00? L
dto00M P
)00P Q
{11 
try22 
{33 	
await44 
_service44 
.44 
UpdateAsync44 &
(44& '
id44' )
,44) *
dto44+ .
)44. /
;44/ 0
return55 
	NoContent55 
(55 
)55 
;55 
}66 	
catch77 
(77  
KeyNotFoundException77 #
)77# $
{88 	
return99 
NotFound99 
(99 
)99 
;99 
}:: 	
};; 
[== 

HttpDelete== 
(== 
$str== 
)== 
]== 
[>>  
ProducesResponseType>> 
(>> 
StatusCodes>> %
.>>% &
Status204NoContent>>& 8
)>>8 9
]>>9 :
[??  
ProducesResponseType?? 
(?? 
StatusCodes?? %
.??% &
Status404NotFound??& 7
)??7 8
]??8 9
public@@ 

async@@ 
Task@@ 
<@@ 
IActionResult@@ #
>@@# $
Delete@@% +
(@@+ ,
int@@, /
id@@0 2
)@@2 3
{AA 
tryBB 
{CC 	
awaitDD 
_serviceDD 
.DD 
DeleteAsyncDD &
(DD& '
idDD' )
)DD) *
;DD* +
returnEE 
	NoContentEE 
(EE 
)EE 
;EE 
}FF 	
catchGG 
(GG  
KeyNotFoundExceptionGG #
)GG# $
{HH 	
returnII 
NotFoundII 
(II 
)II 
;II 
}JJ 	
}KK 
[MM 
HttpPostMM 
(MM 
$strMM #
)MM# $
]MM$ %
[NN  
ProducesResponseTypeNN 
(NN 
StatusCodesNN %
.NN% &
Status204NoContentNN& 8
)NN8 9
]NN9 :
publicOO 

asyncOO 
TaskOO 
<OO 
IActionResultOO #
>OO# $

AssignRoleOO% /
(OO/ 0
intOO0 3
idOO4 6
,OO6 7
intOO8 ;
roleIdOO< B
)OOB C
{PP 
awaitQQ 
_serviceQQ 
.QQ 
AssignRoleAsyncQQ &
(QQ& '
idQQ' )
,QQ) *
roleIdQQ+ 1
)QQ1 2
;QQ2 3
returnRR 
	NoContentRR 
(RR 
)RR 
;RR 
}SS 
[UU 

HttpDeleteUU 
(UU 
$strUU %
)UU% &
]UU& '
[VV  
ProducesResponseTypeVV 
(VV 
StatusCodesVV %
.VV% &
Status204NoContentVV& 8
)VV8 9
]VV9 :
publicWW 

asyncWW 
TaskWW 
<WW 
IActionResultWW #
>WW# $

RevokeRoleWW% /
(WW/ 0
intWW0 3
idWW4 6
,WW6 7
intWW8 ;
roleIdWW< B
)WWB C
{XX 
awaitYY 
_serviceYY 
.YY 
RevokeRoleAsyncYY &
(YY& '
idYY' )
,YY) *
roleIdYY+ 1
)YY1 2
;YY2 3
returnZZ 
	NoContentZZ 
(ZZ 
)ZZ 
;ZZ 
}[[ 
[]] 
HttpPost]] 
(]] 
$str]] /
)]]/ 0
]]]0 1
[^^  
ProducesResponseType^^ 
(^^ 
StatusCodes^^ %
.^^% &
Status204NoContent^^& 8
)^^8 9
]^^9 :
public__ 

async__ 
Task__ 
<__ 
IActionResult__ #
>__# $!
SetPermissionOverride__% :
(__: ;
int__; >
id__? A
,__A B
int__C F
permissionId__G S
,__S T
[__U V
	FromQuery__V _
]___ `
bool__a e
	isGranted__f o
)__o p
{`` 
awaitaa 
_serviceaa 
.aa &
AddPermissionOverrideAsyncaa 1
(aa1 2
idaa2 4
,aa4 5
permissionIdaa6 B
,aaB C
	isGrantedaaD M
)aaM N
;aaN O
returnbb 
	NoContentbb 
(bb 
)bb 
;bb 
}cc 
}dd ”,
\/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/SystemController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[ 
Route 
( 
$str 
) 
] 
public		 
class		 
SystemController		 
:		 
ControllerBase		  .
{

 
private 
readonly 

DataSeeder 
_dataSeeder  +
;+ ,
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

SystemController 
( 

DataSeeder &

dataSeeder' 1
,1 2
ItsToolDbContext3 C
contextD K
)K L
{ 
_dataSeeder 
= 

dataSeeder  
;  !
_context 
= 
context 
; 
} 
public 

record 
SystemResponse  
(  !
string! '
Message( /
)/ 0
;0 1
public 

record 
SystemErrorResponse %
(% &
string& ,
Message- 4
,4 5
string6 <
Error= B
)B C
;C D
[ 
AllowAnonymous 
] 
[ 
HttpPost 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
SystemResponse! /
)/ 0
,0 1
StatusCodes2 =
.= >
Status200OK> I
)I J
]J K
[  
ProducesResponseType 
( 
typeof  
(  !
SystemErrorResponse! 4
)4 5
,5 6
StatusCodes7 B
.B C(
Status500InternalServerErrorC _
)_ `
]` a
public 

async 
Task 
< 
IActionResult #
># $
SeedDatabase% 1
(1 2
)2 3
{ 
try 
{ 	
if 
( 
_context 
. 
Users 
. 
Any "
(" #
)# $
)$ %
{   
return!! 
Ok!! 
(!! 
new!! 
SystemResponse!! ,
(!!, -
$str!!- G
)!!G H
)!!H I
;!!I J
}"" 
await$$ 
_dataSeeder$$ 
.$$ 
	SeedAsync$$ '
($$' (
)$$( )
;$$) *
return%% 
Ok%% 
(%% 
new%% 
SystemResponse%% (
(%%( )
$str%%) J
)%%J K
)%%K L
;%%L M
}&& 	
catch'' 
('' 
	Exception'' 
ex'' 
)'' 
{(( 	
return)) 

StatusCode)) 
()) 
$num)) !
,))! "
new))# &
SystemErrorResponse))' :
()): ;
$str)); ]
,))] ^
ex))_ a
.))a b
Message))b i
)))i j
)))j k
;))k l
}** 	
}++ 
[-- 
AllowAnonymous-- 
]-- 
[.. 
HttpGet.. 
(.. 
$str.. 
).. 
].. 
[//  
ProducesResponseType// 
(// 
typeof//  
(//  !
SystemResponse//! /
)/// 0
,//0 1
StatusCodes//2 =
.//= >
Status200OK//> I
)//I J
]//J K
[00  
ProducesResponseType00 
(00 
typeof00  
(00  !
SystemErrorResponse00! 4
)004 5
,005 6
StatusCodes007 B
.00B C(
Status500InternalServerError00C _
)00_ `
]00` a
public11 

IActionResult11 "
TestDatabaseConnection11 /
(11/ 0
)110 1
{22 
try33 
{44 	
bool55 

canConnect55 
=55 
_context55 &
.55& '
Database55' /
.55/ 0

CanConnect550 :
(55: ;
)55; <
;55< =
if66 
(66 

canConnect66 
)66 
{77 
int88 
	userCount88 
=88 
_context88  (
.88( )
Users88) .
.88. /
Count88/ 4
(884 5
)885 6
;886 7
return99 
Ok99 
(99 
new99 
SystemResponse99 ,
(99, -
$"99- /
$str99/ S
{99S T
	userCount99T ]
}99] ^
"99^ _
)99_ `
)99` a
;99a b
}:: 
return<< 

StatusCode<< 
(<< 
$num<< !
,<<! "
new<<# &
SystemResponse<<' 5
(<<5 6
$str<<6 W
)<<W X
)<<X Y
;<<Y Z
}== 	
catch>> 
(>> 
	Exception>> 
ex>> 
)>> 
{?? 	
return@@ 

StatusCode@@ 
(@@ 
$num@@ !
,@@! "
new@@# &
SystemErrorResponse@@' :
(@@: ;
$str@@; h
,@@h i
ex@@j l
.@@l m
Message@@m t
)@@t u
)@@u v
;@@v w
}AA 	
}BB 
}CC ·?
[/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/RolesController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
[

 
	Authorize

 

(


 
Policy

 
=

 
$str

 4
)

4 5
]

5 6
public 
class 
RolesController 
: 
ControllerBase -
{ 
private 
readonly 
IRoleService !
_service" *
;* +
public 

RolesController 
( 
IRoleService '
service( /
)/ 0
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
RoleDto- 4
>4 5
)5 6
,6 7
StatusCodes8 C
.C D
Status200OKD O
)O P
]P Q
public 

async 
Task 
< 
IActionResult #
># $
GetAll% +
(+ ,
), -
{ 
return 
Ok 
( 
await 
_service  
.  !
GetAllAsync! ,
(, -
)- .
). /
;/ 0
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
RoleDto! (
)( )
,) *
StatusCodes+ 6
.6 7
Status200OK7 B
)B C
]C D
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status404NotFound& 7
)7 8
]8 9
public 

async 
Task 
< 
IActionResult #
># $
GetById% ,
(, -
int- 0
id1 3
)3 4
{ 
var   
role   
=   
await   
_service   !
.  ! "
GetByIdAsync  " .
(  . /
id  / 1
)  1 2
;  2 3
if!! 

(!! 
role!! 
==!! 
null!! 
)!! 
return!!  
NotFound!!! )
(!!) *
)!!* +
;!!+ ,
return"" 
Ok"" 
("" 
role"" 
)"" 
;"" 
}## 
[%% 
HttpPost%% 
]%% 
[&&  
ProducesResponseType&& 
(&& 
typeof&&  
(&&  !
RoleDto&&! (
)&&( )
,&&) *
StatusCodes&&+ 6
.&&6 7
Status201Created&&7 G
)&&G H
]&&H I
public'' 

async'' 
Task'' 
<'' 
IActionResult'' #
>''# $
Create''% +
(''+ ,
['', -
FromBody''- 5
]''5 6
CreateRoleDto''7 D
dto''E H
)''H I
{(( 
var)) 
created)) 
=)) 
await)) 
_service)) $
.))$ %
CreateAsync))% 0
())0 1
dto))1 4
)))4 5
;))5 6
return** 
CreatedAtAction** 
(** 
nameof** %
(**% &
GetById**& -
)**- .
,**. /
new**0 3
{**4 5
id**6 8
=**9 :
created**; B
.**B C
Id**C E
}**F G
,**G H
created**I P
)**P Q
;**Q R
}++ 
[-- 
HttpPut-- 
(-- 
$str-- 
)-- 
]-- 
[..  
ProducesResponseType.. 
(.. 
StatusCodes.. %
...% &
Status204NoContent..& 8
)..8 9
]..9 :
[//  
ProducesResponseType// 
(// 
StatusCodes// %
.//% &
Status404NotFound//& 7
)//7 8
]//8 9
public00 

async00 
Task00 
<00 
IActionResult00 #
>00# $
Update00% +
(00+ ,
int00, /
id000 2
,002 3
[004 5
FromBody005 =
]00= >
UpdateRoleDto00? L
dto00M P
)00P Q
{11 
try22 
{33 	
await44 
_service44 
.44 
UpdateAsync44 &
(44& '
id44' )
,44) *
dto44+ .
)44. /
;44/ 0
return55 
	NoContent55 
(55 
)55 
;55 
}66 	
catch77 
(77  
KeyNotFoundException77 #
)77# $
{88 	
return99 
NotFound99 
(99 
)99 
;99 
}:: 	
};; 
[== 

HttpDelete== 
(== 
$str== 
)== 
]== 
[>>  
ProducesResponseType>> 
(>> 
StatusCodes>> %
.>>% &
Status204NoContent>>& 8
)>>8 9
]>>9 :
[??  
ProducesResponseType?? 
(?? 
StatusCodes?? %
.??% &
Status404NotFound??& 7
)??7 8
]??8 9
public@@ 

async@@ 
Task@@ 
<@@ 
IActionResult@@ #
>@@# $
Delete@@% +
(@@+ ,
int@@, /
id@@0 2
)@@2 3
{AA 
tryBB 
{CC 	
awaitDD 
_serviceDD 
.DD 
DeleteAsyncDD &
(DD& '
idDD' )
)DD) *
;DD* +
returnEE 
	NoContentEE 
(EE 
)EE 
;EE 
}FF 	
catchGG 
(GG  
KeyNotFoundExceptionGG #
)GG# $
{HH 	
returnII 
NotFoundII 
(II 
)II 
;II 
}JJ 	
}KK 
[MM 
HttpPostMM 
(MM 
$strMM /
)MM/ 0
]MM0 1
[NN  
ProducesResponseTypeNN 
(NN 
StatusCodesNN %
.NN% &
Status204NoContentNN& 8
)NN8 9
]NN9 :
publicOO 

asyncOO 
TaskOO 
<OO 
IActionResultOO #
>OO# $
AssignPermissionOO% 5
(OO5 6
intOO6 9
idOO: <
,OO< =
intOO> A
permissionIdOOB N
)OON O
{PP 
awaitQQ 
_serviceQQ 
.QQ !
AssignPermissionAsyncQQ ,
(QQ, -
idQQ- /
,QQ/ 0
permissionIdQQ1 =
)QQ= >
;QQ> ?
returnRR 
	NoContentRR 
(RR 
)RR 
;RR 
}SS 
[UU 

HttpDeleteUU 
(UU 
$strUU 1
)UU1 2
]UU2 3
[VV  
ProducesResponseTypeVV 
(VV 
StatusCodesVV %
.VV% &
Status204NoContentVV& 8
)VV8 9
]VV9 :
publicWW 

asyncWW 
TaskWW 
<WW 
IActionResultWW #
>WW# $
RevokePermissionWW% 5
(WW5 6
intWW6 9
idWW: <
,WW< =
intWW> A
permissionIdWWB N
)WWN O
{XX 
awaitYY 
_serviceYY 
.YY !
RevokePermissionAsyncYY ,
(YY, -
idYY- /
,YY/ 0
permissionIdYY1 =
)YY= >
;YY> ?
returnZZ 
	NoContentZZ 
(ZZ 
)ZZ 
;ZZ 
}[[ 
}\\ —?
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/ProjectsController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
[

 
	Authorize

 

(


 
Policy

 
=

 
$str

 4
)

4 5
]

5 6
public 
class 
ProjectsController 
:  !
ControllerBase" 0
{ 
private 
readonly 
IProjectService $
_service% -
;- .
public 

ProjectsController 
( 
IProjectService -
service. 5
)5 6
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -

ProjectDto- 7
>7 8
)8 9
,9 :
StatusCodes; F
.F G
Status200OKG R
)R S
]S T
public 

async 
Task 
< 
IActionResult #
># $
GetAll% +
(+ ,
), -
{ 
return 
Ok 
( 
await 
_service  
.  !
GetAllAsync! ,
(, -
)- .
). /
;/ 0
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !

ProjectDto! +
)+ ,
,, -
StatusCodes. 9
.9 :
Status200OK: E
)E F
]F G
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status404NotFound& 7
)7 8
]8 9
public 

async 
Task 
< 
IActionResult #
># $
GetById% ,
(, -
int- 0
id1 3
)3 4
{ 
var   
proj   
=   
await   
_service   !
.  ! "
GetByIdAsync  " .
(  . /
id  / 1
)  1 2
;  2 3
if!! 

(!! 
proj!! 
==!! 
null!! 
)!! 
return!!  
NotFound!!! )
(!!) *
)!!* +
;!!+ ,
return"" 
Ok"" 
("" 
proj"" 
)"" 
;"" 
}## 
[%% 
HttpPost%% 
]%% 
[&&  
ProducesResponseType&& 
(&& 
typeof&&  
(&&  !

ProjectDto&&! +
)&&+ ,
,&&, -
StatusCodes&&. 9
.&&9 :
Status201Created&&: J
)&&J K
]&&K L
public'' 

async'' 
Task'' 
<'' 
IActionResult'' #
>''# $
Create''% +
(''+ ,
['', -
FromBody''- 5
]''5 6
CreateProjectDto''7 G
dto''H K
)''K L
{(( 
var)) 
created)) 
=)) 
await)) 
_service)) $
.))$ %
CreateAsync))% 0
())0 1
dto))1 4
)))4 5
;))5 6
return** 
CreatedAtAction** 
(** 
nameof** %
(**% &
GetById**& -
)**- .
,**. /
new**0 3
{**4 5
id**6 8
=**9 :
created**; B
.**B C
Id**C E
}**F G
,**G H
created**I P
)**P Q
;**Q R
}++ 
[-- 
HttpPut-- 
(-- 
$str-- 
)-- 
]-- 
[..  
ProducesResponseType.. 
(.. 
StatusCodes.. %
...% &
Status204NoContent..& 8
)..8 9
]..9 :
[//  
ProducesResponseType// 
(// 
StatusCodes// %
.//% &
Status404NotFound//& 7
)//7 8
]//8 9
public00 

async00 
Task00 
<00 
IActionResult00 #
>00# $
Update00% +
(00+ ,
int00, /
id000 2
,002 3
[004 5
FromBody005 =
]00= >
UpdateProjectDto00? O
dto00P S
)00S T
{11 
try22 
{33 	
await44 
_service44 
.44 
UpdateAsync44 &
(44& '
id44' )
,44) *
dto44+ .
)44. /
;44/ 0
return55 
	NoContent55 
(55 
)55 
;55 
}66 	
catch77 
(77  
KeyNotFoundException77 #
)77# $
{88 	
return99 
NotFound99 
(99 
)99 
;99 
}:: 	
};; 
[== 

HttpDelete== 
(== 
$str== 
)== 
]== 
[>>  
ProducesResponseType>> 
(>> 
StatusCodes>> %
.>>% &
Status204NoContent>>& 8
)>>8 9
]>>9 :
[??  
ProducesResponseType?? 
(?? 
StatusCodes?? %
.??% &
Status404NotFound??& 7
)??7 8
]??8 9
public@@ 

async@@ 
Task@@ 
<@@ 
IActionResult@@ #
>@@# $
Delete@@% +
(@@+ ,
int@@, /
id@@0 2
)@@2 3
{AA 
tryBB 
{CC 	
awaitDD 
_serviceDD 
.DD 
DeleteAsyncDD &
(DD& '
idDD' )
)DD) *
;DD* +
returnEE 
	NoContentEE 
(EE 
)EE 
;EE 
}FF 	
catchGG 
(GG  
KeyNotFoundExceptionGG #
)GG# $
{HH 	
returnII 
NotFoundII 
(II 
)II 
;II 
}JJ 	
}KK 
[MM 
HttpPostMM 
(MM 
$strMM %
)MM% &
]MM& '
[NN  
ProducesResponseTypeNN 
(NN 
StatusCodesNN %
.NN% &
Status204NoContentNN& 8
)NN8 9
]NN9 :
publicOO 

asyncOO 
TaskOO 
<OO 
IActionResultOO #
>OO# $
	AddMemberOO% .
(OO. /
intOO/ 2
idOO3 5
,OO5 6
intOO7 :
userIdOO; A
)OOA B
{PP 
awaitQQ 
_serviceQQ 
.QQ 
AddMemberAsyncQQ %
(QQ% &
idQQ& (
,QQ( )
userIdQQ* 0
)QQ0 1
;QQ1 2
returnRR 
	NoContentRR 
(RR 
)RR 
;RR 
}SS 
[UU 

HttpDeleteUU 
(UU 
$strUU '
)UU' (
]UU( )
[VV  
ProducesResponseTypeVV 
(VV 
StatusCodesVV %
.VV% &
Status204NoContentVV& 8
)VV8 9
]VV9 :
publicWW 

asyncWW 
TaskWW 
<WW 
IActionResultWW #
>WW# $
RemoveMemberWW% 1
(WW1 2
intWW2 5
idWW6 8
,WW8 9
intWW: =
userIdWW> D
)WWD E
{XX 
awaitYY 
_serviceYY 
.YY 
RemoveMemberAsyncYY (
(YY( )
idYY) +
,YY+ ,
userIdYY- 3
)YY3 4
;YY4 5
returnZZ 
	NoContentZZ 
(ZZ 
)ZZ 
;ZZ 
}[[ 
}\\ ¿?
\/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/GroupsController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
[

 
	Authorize

 

(


 
Policy

 
=

 
$str

 4
)

4 5
]

5 6
public 
class 
GroupsController 
: 
ControllerBase  .
{ 
private 
readonly 
IGroupService "
_service# +
;+ ,
public 

GroupsController 
( 
IGroupService )
service* 1
)1 2
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
GroupDto- 5
>5 6
)6 7
,7 8
StatusCodes9 D
.D E
Status200OKE P
)P Q
]Q R
public 

async 
Task 
< 
IActionResult #
># $
GetAll% +
(+ ,
), -
{ 
return 
Ok 
( 
await 
_service  
.  !
GetAllAsync! ,
(, -
)- .
). /
;/ 0
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
GroupDto! )
)) *
,* +
StatusCodes, 7
.7 8
Status200OK8 C
)C D
]D E
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status404NotFound& 7
)7 8
]8 9
public 

async 
Task 
< 
IActionResult #
># $
GetById% ,
(, -
int- 0
id1 3
)3 4
{ 
var   
group   
=   
await   
_service   "
.  " #
GetByIdAsync  # /
(  / 0
id  0 2
)  2 3
;  3 4
if!! 

(!! 
group!! 
==!! 
null!! 
)!! 
return!! !
NotFound!!" *
(!!* +
)!!+ ,
;!!, -
return"" 
Ok"" 
("" 
group"" 
)"" 
;"" 
}## 
[%% 
HttpPost%% 
]%% 
[&&  
ProducesResponseType&& 
(&& 
typeof&&  
(&&  !
GroupDto&&! )
)&&) *
,&&* +
StatusCodes&&, 7
.&&7 8
Status201Created&&8 H
)&&H I
]&&I J
public'' 

async'' 
Task'' 
<'' 
IActionResult'' #
>''# $
Create''% +
(''+ ,
['', -
FromBody''- 5
]''5 6
CreateGroupDto''7 E
dto''F I
)''I J
{(( 
var)) 
created)) 
=)) 
await)) 
_service)) $
.))$ %
CreateAsync))% 0
())0 1
dto))1 4
)))4 5
;))5 6
return** 
CreatedAtAction** 
(** 
nameof** %
(**% &
GetById**& -
)**- .
,**. /
new**0 3
{**4 5
id**6 8
=**9 :
created**; B
.**B C
Id**C E
}**F G
,**G H
created**I P
)**P Q
;**Q R
}++ 
[-- 
HttpPut-- 
(-- 
$str-- 
)-- 
]-- 
[..  
ProducesResponseType.. 
(.. 
StatusCodes.. %
...% &
Status204NoContent..& 8
)..8 9
]..9 :
[//  
ProducesResponseType// 
(// 
StatusCodes// %
.//% &
Status404NotFound//& 7
)//7 8
]//8 9
public00 

async00 
Task00 
<00 
IActionResult00 #
>00# $
Update00% +
(00+ ,
int00, /
id000 2
,002 3
[004 5
FromBody005 =
]00= >
UpdateGroupDto00? M
dto00N Q
)00Q R
{11 
try22 
{33 	
await44 
_service44 
.44 
UpdateAsync44 &
(44& '
id44' )
,44) *
dto44+ .
)44. /
;44/ 0
return55 
	NoContent55 
(55 
)55 
;55 
}66 	
catch77 
(77  
KeyNotFoundException77 #
)77# $
{88 	
return99 
NotFound99 
(99 
)99 
;99 
}:: 	
};; 
[== 

HttpDelete== 
(== 
$str== 
)== 
]== 
[>>  
ProducesResponseType>> 
(>> 
StatusCodes>> %
.>>% &
Status204NoContent>>& 8
)>>8 9
]>>9 :
[??  
ProducesResponseType?? 
(?? 
StatusCodes?? %
.??% &
Status404NotFound??& 7
)??7 8
]??8 9
public@@ 

async@@ 
Task@@ 
<@@ 
IActionResult@@ #
>@@# $
Delete@@% +
(@@+ ,
int@@, /
id@@0 2
)@@2 3
{AA 
tryBB 
{CC 	
awaitDD 
_serviceDD 
.DD 
DeleteAsyncDD &
(DD& '
idDD' )
)DD) *
;DD* +
returnEE 
	NoContentEE 
(EE 
)EE 
;EE 
}FF 	
catchGG 
(GG  
KeyNotFoundExceptionGG #
)GG# $
{HH 	
returnII 
NotFoundII 
(II 
)II 
;II 
}JJ 	
}KK 
[MM 
HttpPostMM 
(MM 
$strMM %
)MM% &
]MM& '
[NN  
ProducesResponseTypeNN 
(NN 
StatusCodesNN %
.NN% &
Status204NoContentNN& 8
)NN8 9
]NN9 :
publicOO 

asyncOO 
TaskOO 
<OO 
IActionResultOO #
>OO# $
	AddMemberOO% .
(OO. /
intOO/ 2
idOO3 5
,OO5 6
intOO7 :
userIdOO; A
)OOA B
{PP 
awaitQQ 
_serviceQQ 
.QQ 
AddMemberAsyncQQ %
(QQ% &
idQQ& (
,QQ( )
userIdQQ* 0
)QQ0 1
;QQ1 2
returnRR 
	NoContentRR 
(RR 
)RR 
;RR 
}SS 
[UU 

HttpDeleteUU 
(UU 
$strUU '
)UU' (
]UU( )
[VV  
ProducesResponseTypeVV 
(VV 
StatusCodesVV %
.VV% &
Status204NoContentVV& 8
)VV8 9
]VV9 :
publicWW 

asyncWW 
TaskWW 
<WW 
IActionResultWW #
>WW# $
RemoveMemberWW% 1
(WW1 2
intWW2 5
idWW6 8
,WW8 9
intWW: =
userIdWW> D
)WWD E
{XX 
awaitYY 
_serviceYY 
.YY 
RemoveMemberAsyncYY (
(YY( )
idYY) +
,YY+ ,
userIdYY- 3
)YY3 4
;YY4 5
returnZZ 
	NoContentZZ 
(ZZ 
)ZZ 
;ZZ 
}[[ 
}\\ —|
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/DynamicFormController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
[

 
	Authorize

 

(


 
Policy

 
=

 
$str

 5
)

5 6
]

6 7
public 
class !
DynamicFormController "
:# $
ControllerBase% 3
{ 
private 
readonly 
IDynamicFormService (
_service) 1
;1 2
public 
!
DynamicFormController  
(  !
IDynamicFormService! 4
service5 <
)< =
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
FieldDefinitionDto- ?
>? @
)@ A
,A B
StatusCodesC N
.N O
Status200OKO Z
)Z [
][ \
public 

async 
Task 
< 
IActionResult #
># $
GetDefinitions% 3
(3 4
)4 5
=>6 8
Ok9 ;
(; <
await< A
_serviceB J
.J K$
GetFieldDefinitionsAsyncK c
(c d
)d e
)e f
;f g
[ 
HttpPost 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
FieldDefinitionDto! 3
)3 4
,4 5
StatusCodes6 A
.A B
Status201CreatedB R
)R S
]S T
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status400BadRequest& 9
)9 :
]: ;
public 

async 
Task 
< 
IActionResult #
># $
CreateDefinition% 5
(5 6
[6 7
FromBody7 ?
]? @$
CreateFieldDefinitionDtoA Y
dtoZ ]
)] ^
{ 
try 
{ 
var 
result 
= 
await  
_service! )
.) *&
CreateFieldDefinitionAsync* D
(D E
dtoE H
)H I
;I J
returnK Q
CreatedAtActionR a
(a b
nameofb h
(h i
GetDefinitionsi w
)w x
,x y
newz }
{~ 
id
Ä Ç
=
É Ñ
result
Ö ã
.
ã å
Id
å é
}
è ê
,
ê ë
result
í ò
)
ò ô
;
ô ö
}
õ ú
catch 
( %
InvalidOperationException (
ex) +
)+ ,
{- .
return/ 5

BadRequest6 @
(@ A
newA D
{E F
errorG L
=M N
exO Q
.Q R
MessageR Y
}Z [
)[ \
;\ ]
}^ _
} 
[!! 
HttpPut!! 
(!! 
$str!! 
)!!  
]!!  !
[""  
ProducesResponseType"" 
("" 
StatusCodes"" %
.""% &
Status204NoContent""& 8
)""8 9
]""9 :
[##  
ProducesResponseType## 
(## 
StatusCodes## %
.##% &
Status400BadRequest##& 9
)##9 :
]##: ;
[$$  
ProducesResponseType$$ 
($$ 
StatusCodes$$ %
.$$% &
Status404NotFound$$& 7
)$$7 8
]$$8 9
public%% 

async%% 
Task%% 
<%% 
IActionResult%% #
>%%# $
UpdateDefinition%%% 5
(%%5 6
int%%6 9
id%%: <
,%%< =
[%%> ?
FromBody%%? G
]%%G H$
UpdateFieldDefinitionDto%%I a
dto%%b e
)%%e f
{&& 
try'' 
{'' 
await'' 
_service'' 
.'' &
UpdateFieldDefinitionAsync'' 7
(''7 8
id''8 :
,'': ;
dto''< ?
)''? @
;''@ A
return''B H
	NoContent''I R
(''R S
)''S T
;''T U
}''V W
catch(( 
(((  
KeyNotFoundException(( #
)((# $
{((% &
return((' -
NotFound((. 6
(((6 7
)((7 8
;((8 9
}((: ;
catch)) 
()) %
InvalidOperationException)) (
ex))) +
)))+ ,
{))- .
return))/ 5

BadRequest))6 @
())@ A
new))A D
{))E F
error))G L
=))M N
ex))O Q
.))Q R
Message))R Y
}))Z [
)))[ \
;))\ ]
}))^ _
}** 
[,, 

HttpDelete,, 
(,, 
$str,, "
),," #
],,# $
[--  
ProducesResponseType-- 
(-- 
StatusCodes-- %
.--% &
Status204NoContent--& 8
)--8 9
]--9 :
public.. 

async.. 
Task.. 
<.. 
IActionResult.. #
>..# $
DeleteDefinition..% 5
(..5 6
int..6 9
id..: <
)..< =
{// 
await00 
_service00 
.00 &
DeleteFieldDefinitionAsync00 1
(001 2
id002 4
)004 5
;005 6
return007 =
	NoContent00> G
(00G H
)00H I
;00I J
}11 
[33 
HttpGet33 
(33 
$str33 '
)33' (
]33( )
[44  
ProducesResponseType44 
(44 
typeof44  
(44  !
IEnumerable44! ,
<44, -
FieldOptionDto44- ;
>44; <
)44< =
,44= >
StatusCodes44? J
.44J K
Status200OK44K V
)44V W
]44W X
public55 

async55 
Task55 
<55 
IActionResult55 #
>55# $

GetOptions55% /
(55/ 0
int550 3
id554 6
)556 7
=>558 :
Ok55; =
(55= >
await55> C
_service55D L
.55L M 
GetFieldOptionsAsync55M a
(55a b
id55b d
)55d e
)55e f
;55f g
[77 
HttpPost77 
(77 
$str77 
)77 
]77 
[88  
ProducesResponseType88 
(88 
typeof88  
(88  !
FieldOptionDto88! /
)88/ 0
,880 1
StatusCodes882 =
.88= >
Status201Created88> N
)88N O
]88O P
public99 

async99 
Task99 
<99 
IActionResult99 #
>99# $
CreateOption99% 1
(991 2
[992 3
FromBody993 ;
]99; < 
CreateFieldOptionDto99= Q
dto99R U
)99U V
{:: 
var;; 
result;; 
=;; 
await;; 
_service;; #
.;;# $"
CreateFieldOptionAsync;;$ :
(;;: ;
dto;;; >
);;> ?
;;;? @
return<< 
CreatedAtAction<< 
(<< 
nameof<< %
(<<% &
GetDefinitions<<& 4
)<<4 5
,<<5 6
new<<7 :
{<<; <
id<<= ?
=<<@ A
result<<B H
.<<H I
Id<<I K
}<<L M
,<<M N
result<<O U
)<<U V
;<<V W
}== 
[?? 
HttpPut?? 
(?? 
$str?? 
)?? 
]?? 
[@@  
ProducesResponseType@@ 
(@@ 
StatusCodes@@ %
.@@% &
Status204NoContent@@& 8
)@@8 9
]@@9 :
[AA  
ProducesResponseTypeAA 
(AA 
StatusCodesAA %
.AA% &
Status404NotFoundAA& 7
)AA7 8
]AA8 9
publicBB 

asyncBB 
TaskBB 
<BB 
IActionResultBB #
>BB# $
UpdateOptionBB% 1
(BB1 2
intBB2 5
idBB6 8
,BB8 9
[BB: ;
FromBodyBB; C
]BBC D 
UpdateFieldOptionDtoBBE Y
dtoBBZ ]
)BB] ^
{CC 
tryDD 
{DD 
awaitDD 
_serviceDD 
.DD "
UpdateFieldOptionAsyncDD 3
(DD3 4
idDD4 6
,DD6 7
dtoDD8 ;
)DD; <
;DD< =
returnDD> D
	NoContentDDE N
(DDN O
)DDO P
;DDP Q
}DDR S
catchEE 
(EE  
KeyNotFoundExceptionEE #
)EE# $
{EE% &
returnEE' -
NotFoundEE. 6
(EE6 7
)EE7 8
;EE8 9
}EE: ;
}FF 
[HH 

HttpDeleteHH 
(HH 
$strHH 
)HH 
]HH  
[II  
ProducesResponseTypeII 
(II 
StatusCodesII %
.II% &
Status204NoContentII& 8
)II8 9
]II9 :
publicJJ 

asyncJJ 
TaskJJ 
<JJ 
IActionResultJJ #
>JJ# $
DeleteOptionJJ% 1
(JJ1 2
intJJ2 5
idJJ6 8
)JJ8 9
{KK 
awaitLL 
_serviceLL 
.LL "
DeleteFieldOptionAsyncLL -
(LL- .
idLL. 0
)LL0 1
;LL1 2
returnLL3 9
	NoContentLL: C
(LLC D
)LLD E
;LLE F
}MM 
[OO 
HttpGetOO 
(OO 
$strOO 
)OO 
]OO 
[PP  
ProducesResponseTypePP 
(PP 
typeofPP  
(PP  !
IEnumerablePP! ,
<PP, -!
FormFieldPlacementDtoPP- B
>PPB C
)PPC D
,PPD E
StatusCodesPPF Q
.PPQ R
Status200OKPPR ]
)PP] ^
]PP^ _
publicQQ 

asyncQQ 
TaskQQ 
<QQ 
IActionResultQQ #
>QQ# $
GetPlacementsQQ% 2
(QQ2 3
[QQ3 4
	FromQueryQQ4 =
]QQ= >
intQQ? B
?QQB C
	projectIdQQD M
,QQM N
[QQO P
	FromQueryQQP Y
]QQY Z
intQQ[ ^
?QQ^ _

categoryIdQQ` j
,QQj k
[QQl m
	FromQueryQQm v
]QQv w
intQQx {
?QQ{ |
ticketTypeId	QQ} â
)
QQâ ä
{RR 
returnSS 
OkSS 
(SS 
awaitSS 
_serviceSS  
.SS  !
GetPlacementsAsyncSS! 3
(SS3 4
	projectIdSS4 =
,SS= >

categoryIdSS? I
,SSI J
ticketTypeIdSSK W
)SSW X
)SSX Y
;SSY Z
}TT 
[VV 
HttpPostVV 
(VV 
$strVV 
)VV 
]VV 
[WW  
ProducesResponseTypeWW 
(WW 
typeofWW  
(WW  !!
FormFieldPlacementDtoWW! 6
)WW6 7
,WW7 8
StatusCodesWW9 D
.WWD E
Status201CreatedWWE U
)WWU V
]WWV W
[XX  
ProducesResponseTypeXX 
(XX 
StatusCodesXX %
.XX% &
Status400BadRequestXX& 9
)XX9 :
]XX: ;
publicYY 

asyncYY 
TaskYY 
<YY 
IActionResultYY #
>YY# $
CreatePlacementYY% 4
(YY4 5
[YY5 6
FromBodyYY6 >
]YY> ?'
CreateFormFieldPlacementDtoYY@ [
dtoYY\ _
)YY_ `
{ZZ 
try[[ 
{[[ 
var[[ 
result[[ 
=[[ 
await[[  
_service[[! )
.[[) * 
CreatePlacementAsync[[* >
([[> ?
dto[[? B
)[[B C
;[[C D
return[[E K
CreatedAtAction[[L [
([[[ \
nameof[[\ b
([[b c
GetDefinitions[[c q
)[[q r
,[[r s
new[[t w
{[[x y
id[[z |
=[[} ~
result	[[ Ö
.
[[Ö Ü
Id
[[Ü à
}
[[â ä
,
[[ä ã
result
[[å í
)
[[í ì
;
[[ì î
}
[[ï ñ
catch\\ 
(\\ %
InvalidOperationException\\ (
ex\\) +
)\\+ ,
{\\- .
return\\/ 5

BadRequest\\6 @
(\\@ A
new\\A D
{\\E F
error\\G L
=\\M N
ex\\O Q
.\\Q R
Message\\R Y
}\\Z [
)\\[ \
;\\\ ]
}\\^ _
}]] 
[__ 
HttpPut__ 
(__ 
$str__ 
)__ 
]__  
[``  
ProducesResponseType`` 
(`` 
StatusCodes`` %
.``% &
Status204NoContent``& 8
)``8 9
]``9 :
[aa  
ProducesResponseTypeaa 
(aa 
StatusCodesaa %
.aa% &
Status400BadRequestaa& 9
)aa9 :
]aa: ;
[bb  
ProducesResponseTypebb 
(bb 
StatusCodesbb %
.bb% &
Status404NotFoundbb& 7
)bb7 8
]bb8 9
publiccc 

asynccc 
Taskcc 
<cc 
IActionResultcc #
>cc# $
UpdatePlacementcc% 4
(cc4 5
intcc5 8
idcc9 ;
,cc; <
[cc= >
FromBodycc> F
]ccF G'
UpdateFormFieldPlacementDtoccH c
dtoccd g
)ccg h
{dd 
tryee 
{ee 
awaitee 
_serviceee 
.ee  
UpdatePlacementAsyncee 1
(ee1 2
idee2 4
,ee4 5
dtoee6 9
)ee9 :
;ee: ;
returnee< B
	NoContenteeC L
(eeL M
)eeM N
;eeN O
}eeP Q
catchff 
(ff  
KeyNotFoundExceptionff #
)ff# $
{ff% &
returnff' -
NotFoundff. 6
(ff6 7
)ff7 8
;ff8 9
}ff: ;
catchgg 
(gg %
InvalidOperationExceptiongg (
exgg) +
)gg+ ,
{gg- .
returngg/ 5

BadRequestgg6 @
(gg@ A
newggA D
{ggE F
errorggG L
=ggM N
exggO Q
.ggQ R
MessageggR Y
}ggZ [
)gg[ \
;gg\ ]
}gg^ _
}hh 
[jj 

HttpDeletejj 
(jj 
$strjj !
)jj! "
]jj" #
[kk  
ProducesResponseTypekk 
(kk 
StatusCodeskk %
.kk% &
Status204NoContentkk& 8
)kk8 9
]kk9 :
publicll 

asyncll 
Taskll 
<ll 
IActionResultll #
>ll# $
DeletePlacementll% 4
(ll4 5
intll5 8
idll9 ;
)ll; <
{mm 
awaitnn 
_servicenn 
.nn  
DeletePlacementAsyncnn +
(nn+ ,
idnn, .
)nn. /
;nn/ 0
returnnn1 7
	NoContentnn8 A
(nnA B
)nnB C
;nnC D
}oo 
}pp á3
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/DepartmentsController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
[

 
	Authorize

 

(


 
Policy

 
=

 
$str

 4
)

4 5
]

5 6
public 
class !
DepartmentsController "
:# $
ControllerBase% 3
{ 
private 
readonly 
IDepartmentService '
_service( 0
;0 1
public 
!
DepartmentsController  
(  !
IDepartmentService! 3
service4 ;
); <
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
DepartmentDto- :
>: ;
); <
,< =
StatusCodes> I
.I J
Status200OKJ U
)U V
]V W
public 

async 
Task 
< 
IActionResult #
># $
GetAll% +
(+ ,
), -
{ 
return 
Ok 
( 
await 
_service  
.  !
GetAllAsync! ,
(, -
)- .
). /
;/ 0
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
DepartmentDto! .
). /
,/ 0
StatusCodes1 <
.< =
Status200OK= H
)H I
]I J
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status404NotFound& 7
)7 8
]8 9
public 

async 
Task 
< 
IActionResult #
># $
GetById% ,
(, -
int- 0
id1 3
)3 4
{ 
var   
dept   
=   
await   
_service   !
.  ! "
GetByIdAsync  " .
(  . /
id  / 1
)  1 2
;  2 3
if!! 

(!! 
dept!! 
==!! 
null!! 
)!! 
return!!  
NotFound!!! )
(!!) *
)!!* +
;!!+ ,
return"" 
Ok"" 
("" 
dept"" 
)"" 
;"" 
}## 
[%% 
HttpPost%% 
]%% 
[&&  
ProducesResponseType&& 
(&& 
typeof&&  
(&&  !
DepartmentDto&&! .
)&&. /
,&&/ 0
StatusCodes&&1 <
.&&< =
Status201Created&&= M
)&&M N
]&&N O
public'' 

async'' 
Task'' 
<'' 
IActionResult'' #
>''# $
Create''% +
(''+ ,
['', -
FromBody''- 5
]''5 6
CreateDepartmentDto''7 J
dto''K N
)''N O
{(( 
var)) 
created)) 
=)) 
await)) 
_service)) $
.))$ %
CreateAsync))% 0
())0 1
dto))1 4
)))4 5
;))5 6
return** 
CreatedAtAction** 
(** 
nameof** %
(**% &
GetById**& -
)**- .
,**. /
new**0 3
{**4 5
id**6 8
=**9 :
created**; B
.**B C
Id**C E
}**F G
,**G H
created**I P
)**P Q
;**Q R
}++ 
[-- 
HttpPut-- 
(-- 
$str-- 
)-- 
]-- 
[..  
ProducesResponseType.. 
(.. 
StatusCodes.. %
...% &
Status204NoContent..& 8
)..8 9
]..9 :
[//  
ProducesResponseType// 
(// 
StatusCodes// %
.//% &
Status404NotFound//& 7
)//7 8
]//8 9
public00 

async00 
Task00 
<00 
IActionResult00 #
>00# $
Update00% +
(00+ ,
int00, /
id000 2
,002 3
[004 5
FromBody005 =
]00= >
UpdateDepartmentDto00? R
dto00S V
)00V W
{11 
try22 
{33 	
await44 
_service44 
.44 
UpdateAsync44 &
(44& '
id44' )
,44) *
dto44+ .
)44. /
;44/ 0
return55 
	NoContent55 
(55 
)55 
;55 
}66 	
catch77 
(77  
KeyNotFoundException77 #
)77# $
{88 	
return99 
NotFound99 
(99 
)99 
;99 
}:: 	
};; 
[== 

HttpDelete== 
(== 
$str== 
)== 
]== 
[>>  
ProducesResponseType>> 
(>> 
StatusCodes>> %
.>>% &
Status204NoContent>>& 8
)>>8 9
]>>9 :
[??  
ProducesResponseType?? 
(?? 
StatusCodes?? %
.??% &
Status404NotFound??& 7
)??7 8
]??8 9
public@@ 

async@@ 
Task@@ 
<@@ 
IActionResult@@ #
>@@# $
Delete@@% +
(@@+ ,
int@@, /
id@@0 2
)@@2 3
{AA 
tryBB 
{CC 	
awaitDD 
_serviceDD 
.DD 
DeleteAsyncDD &
(DD& '
idDD' )
)DD) *
;DD* +
returnEE 
	NoContentEE 
(EE 
)EE 
;EE 
}FF 	
catchGG 
(GG  
KeyNotFoundExceptionGG #
)GG# $
{HH 	
returnII 
NotFoundII 
(II 
)II 
;II 
}JJ 	
}KK 
}LL Ãã
]/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/CatalogController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
[

 
	Authorize

 

(


 
Policy

 
=

 
$str

 5
)

5 6
]

6 7
public 
class 
CatalogController 
:  
ControllerBase! /
{ 
private 
readonly 
ICatalogService $
_service% -
;- .
public 

CatalogController 
( 
ICatalogService ,
service- 4
)4 5
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
CategoryDto- 8
>8 9
)9 :
,: ;
StatusCodes< G
.G H
Status200OKH S
)S T
]T U
public 

async 
Task 
< 
IActionResult #
># $
GetCategories% 2
(2 3
[3 4
	FromQuery4 =
]= >
int? B
?B C
	projectIdD M
)M N
{ 
return 
Ok 
( 
await 
_service  
.  !
GetCategoriesAsync! 3
(3 4
	projectId4 =
)= >
)> ?
;? @
} 
[ 
HttpPost 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
CategoryDto! ,
), -
,- .
StatusCodes/ :
.: ;
Status201Created; K
)K L
]L M
public 

async 
Task 
< 
IActionResult #
># $
CreateCategory% 3
(3 4
[4 5
FromBody5 =
]= >
CreateCategoryDto? P
dtoQ T
)T U
{ 
var 
result 
= 
await 
_service #
.# $
CreateCategoryAsync$ 7
(7 8
dto8 ;
); <
;< =
return   
CreatedAtAction   
(   
nameof   %
(  % &
GetCategories  & 3
)  3 4
,  4 5
new  6 9
{  : ;
id  < >
=  ? @
result  A G
.  G H
Id  H J
}  K L
,  L M
result  N T
)  T U
;  U V
}!! 
[## 
HttpPut## 
(## 
$str## 
)## 
]##  
[$$  
ProducesResponseType$$ 
($$ 
StatusCodes$$ %
.$$% &
Status204NoContent$$& 8
)$$8 9
]$$9 :
[%%  
ProducesResponseType%% 
(%% 
StatusCodes%% %
.%%% &
Status404NotFound%%& 7
)%%7 8
]%%8 9
public&& 

async&& 
Task&& 
<&& 
IActionResult&& #
>&&# $
UpdateCategory&&% 3
(&&3 4
int&&4 7
id&&8 :
,&&: ;
[&&< =
FromBody&&= E
]&&E F
UpdateCategoryDto&&G X
dto&&Y \
)&&\ ]
{'' 
try(( 
{(( 
await(( 
_service(( 
.(( 
UpdateCategoryAsync(( 0
(((0 1
id((1 3
,((3 4
dto((5 8
)((8 9
;((9 :
return((; A
	NoContent((B K
(((K L
)((L M
;((M N
}((O P
catch)) 
())  
KeyNotFoundException)) #
)))# $
{))% &
return))' -
NotFound)). 6
())6 7
)))7 8
;))8 9
})): ;
}** 
[,, 

HttpDelete,, 
(,, 
$str,, !
),,! "
],," #
[--  
ProducesResponseType-- 
(-- 
StatusCodes-- %
.--% &
Status204NoContent--& 8
)--8 9
]--9 :
public.. 

async.. 
Task.. 
<.. 
IActionResult.. #
>..# $
DeleteCategory..% 3
(..3 4
int..4 7
id..8 :
)..: ;
{// 
await00 
_service00 
.00 
DeleteCategoryAsync00 *
(00* +
id00+ -
)00- .
;00. /
return000 6
	NoContent007 @
(00@ A
)00A B
;00B C
}11 
[33 
HttpGet33 
(33 
$str33 
)33 
]33 
[44  
ProducesResponseType44 
(44 
typeof44  
(44  !
IEnumerable44! ,
<44, -
TicketTypeDto44- :
>44: ;
)44; <
,44< =
StatusCodes44> I
.44I J
Status200OK44J U
)44U V
]44V W
public55 

async55 
Task55 
<55 
IActionResult55 #
>55# $
GetTicketTypes55% 3
(553 4
)554 5
=>556 8
Ok559 ;
(55; <
await55< A
_service55B J
.55J K
GetTicketTypesAsync55K ^
(55^ _
)55_ `
)55` a
;55a b
[77 
HttpPost77 
(77 
$str77 
)77 
]77 
[88  
ProducesResponseType88 
(88 
typeof88  
(88  !
TicketTypeDto88! .
)88. /
,88/ 0
StatusCodes881 <
.88< =
Status201Created88= M
)88M N
]88N O
public99 

async99 
Task99 
<99 
IActionResult99 #
>99# $
CreateTicketType99% 5
(995 6
[996 7
FromBody997 ?
]99? @
CreateTicketTypeDto99A T
dto99U X
)99X Y
{:: 
var;; 
result;; 
=;; 
await;; 
_service;; #
.;;# $!
CreateTicketTypeAsync;;$ 9
(;;9 :
dto;;: =
);;= >
;;;> ?
return<< 
CreatedAtAction<< 
(<< 
nameof<< %
(<<% &
GetTicketTypes<<& 4
)<<4 5
,<<5 6
new<<7 :
{<<; <
id<<= ?
=<<@ A
result<<B H
.<<H I
Id<<I K
}<<L M
,<<M N
result<<O U
)<<U V
;<<V W
}== 
[?? 
HttpPut?? 
(?? 
$str??  
)??  !
]??! "
[@@  
ProducesResponseType@@ 
(@@ 
StatusCodes@@ %
.@@% &
Status204NoContent@@& 8
)@@8 9
]@@9 :
[AA  
ProducesResponseTypeAA 
(AA 
StatusCodesAA %
.AA% &
Status404NotFoundAA& 7
)AA7 8
]AA8 9
publicBB 

asyncBB 
TaskBB 
<BB 
IActionResultBB #
>BB# $
UpdateTicketTypeBB% 5
(BB5 6
intBB6 9
idBB: <
,BB< =
[BB> ?
FromBodyBB? G
]BBG H
UpdateTicketTypeDtoBBI \
dtoBB] `
)BB` a
{CC 
tryDD 
{DD 
awaitDD 
_serviceDD 
.DD !
UpdateTicketTypeAsyncDD 2
(DD2 3
idDD3 5
,DD5 6
dtoDD7 :
)DD: ;
;DD; <
returnDD= C
	NoContentDDD M
(DDM N
)DDN O
;DDO P
}DDQ R
catchEE 
(EE  
KeyNotFoundExceptionEE #
)EE# $
{EE% &
returnEE' -
NotFoundEE. 6
(EE6 7
)EE7 8
;EE8 9
}EE: ;
}FF 
[HH 

HttpDeleteHH 
(HH 
$strHH #
)HH# $
]HH$ %
[II  
ProducesResponseTypeII 
(II 
StatusCodesII %
.II% &
Status204NoContentII& 8
)II8 9
]II9 :
publicJJ 

asyncJJ 
TaskJJ 
<JJ 
IActionResultJJ #
>JJ# $
DeleteTicketTypeJJ% 5
(JJ5 6
intJJ6 9
idJJ: <
)JJ< =
{KK 
awaitLL 
_serviceLL 
.LL !
DeleteTicketTypeAsyncLL ,
(LL, -
idLL- /
)LL/ 0
;LL0 1
returnLL2 8
	NoContentLL9 B
(LLB C
)LLC D
;LLD E
}MM 
[OO 
HttpGetOO 
(OO 
$strOO 
)OO 
]OO 
[PP  
ProducesResponseTypePP 
(PP 
typeofPP  
(PP  !
IEnumerablePP! ,
<PP, -
	StatusDtoPP- 6
>PP6 7
)PP7 8
,PP8 9
StatusCodesPP: E
.PPE F
Status200OKPPF Q
)PPQ R
]PPR S
publicQQ 

asyncQQ 
TaskQQ 
<QQ 
IActionResultQQ #
>QQ# $
GetStatusesQQ% 0
(QQ0 1
)QQ1 2
=>QQ3 5
OkQQ6 8
(QQ8 9
awaitQQ9 >
_serviceQQ? G
.QQG H
GetStatusesAsyncQQH X
(QQX Y
)QQY Z
)QQZ [
;QQ[ \
[SS 
HttpPostSS 
(SS 
$strSS 
)SS 
]SS 
[TT  
ProducesResponseTypeTT 
(TT 
typeofTT  
(TT  !
	StatusDtoTT! *
)TT* +
,TT+ ,
StatusCodesTT- 8
.TT8 9
Status201CreatedTT9 I
)TTI J
]TTJ K
publicUU 

asyncUU 
TaskUU 
<UU 
IActionResultUU #
>UU# $
CreateStatusUU% 1
(UU1 2
[UU2 3
FromBodyUU3 ;
]UU; <
CreateStatusDtoUU= L
dtoUUM P
)UUP Q
{VV 
varWW 
resultWW 
=WW 
awaitWW 
_serviceWW #
.WW# $
CreateStatusAsyncWW$ 5
(WW5 6
dtoWW6 9
)WW9 :
;WW: ;
returnXX 
CreatedAtActionXX 
(XX 
nameofXX %
(XX% &
GetStatusesXX& 1
)XX1 2
,XX2 3
newXX4 7
{XX8 9
idXX: <
=XX= >
resultXX? E
.XXE F
IdXXF H
}XXI J
,XXJ K
resultXXL R
)XXR S
;XXS T
}YY 
[[[ 
HttpPut[[ 
([[ 
$str[[ 
)[[ 
][[ 
[\\  
ProducesResponseType\\ 
(\\ 
StatusCodes\\ %
.\\% &
Status204NoContent\\& 8
)\\8 9
]\\9 :
[]]  
ProducesResponseType]] 
(]] 
StatusCodes]] %
.]]% &
Status404NotFound]]& 7
)]]7 8
]]]8 9
public^^ 

async^^ 
Task^^ 
<^^ 
IActionResult^^ #
>^^# $
UpdateStatus^^% 1
(^^1 2
int^^2 5
id^^6 8
,^^8 9
[^^: ;
FromBody^^; C
]^^C D
UpdateStatusDto^^E T
dto^^U X
)^^X Y
{__ 
try`` 
{`` 
await`` 
_service`` 
.`` 
UpdateStatusAsync`` .
(``. /
id``/ 1
,``1 2
dto``3 6
)``6 7
;``7 8
return``9 ?
	NoContent``@ I
(``I J
)``J K
;``K L
}``M N
catchaa 
(aa  
KeyNotFoundExceptionaa #
)aa# $
{aa% &
returnaa' -
NotFoundaa. 6
(aa6 7
)aa7 8
;aa8 9
}aa: ;
}bb 
[dd 

HttpDeletedd 
(dd 
$strdd 
)dd  
]dd  !
[ee  
ProducesResponseTypeee 
(ee 
StatusCodesee %
.ee% &
Status204NoContentee& 8
)ee8 9
]ee9 :
[ff  
ProducesResponseTypeff 
(ff 
StatusCodesff %
.ff% &
Status400BadRequestff& 9
)ff9 :
]ff: ;
publicgg 

asyncgg 
Taskgg 
<gg 
IActionResultgg #
>gg# $
DeleteStatusgg% 1
(gg1 2
intgg2 5
idgg6 8
)gg8 9
{hh 
tryii 
{ii 
awaitii 
_serviceii 
.ii 
DeleteStatusAsyncii .
(ii. /
idii/ 1
)ii1 2
;ii2 3
returnii4 :
	NoContentii; D
(iiD E
)iiE F
;iiF G
}iiH I
catchjj 
(jj %
InvalidOperationExceptionjj (
exjj) +
)jj+ ,
{jj- .
returnjj/ 5

BadRequestjj6 @
(jj@ A
newjjA D
{jjE F
errorjjG L
=jjM N
exjjO Q
.jjQ R
MessagejjR Y
}jjZ [
)jj[ \
;jj\ ]
}jj^ _
}kk 
[mm 
HttpGetmm 
(mm 
$strmm 
)mm 
]mm 
[nn  
ProducesResponseTypenn 
(nn 
typeofnn  
(nn  !
IEnumerablenn! ,
<nn, -
PriorityDtonn- 8
>nn8 9
)nn9 :
,nn: ;
StatusCodesnn< G
.nnG H
Status200OKnnH S
)nnS T
]nnT U
publicoo 

asyncoo 
Taskoo 
<oo 
IActionResultoo #
>oo# $
GetPrioritiesoo% 2
(oo2 3
)oo3 4
=>oo5 7
Okoo8 :
(oo: ;
awaitoo; @
_serviceooA I
.ooI J
GetPrioritiesAsyncooJ \
(oo\ ]
)oo] ^
)oo^ _
;oo_ `
[qq 
HttpPostqq 
(qq 
$strqq 
)qq 
]qq 
[rr  
ProducesResponseTyperr 
(rr 
typeofrr  
(rr  !
PriorityDtorr! ,
)rr, -
,rr- .
StatusCodesrr/ :
.rr: ;
Status201Createdrr; K
)rrK L
]rrL M
publicss 

asyncss 
Taskss 
<ss 
IActionResultss #
>ss# $
CreatePriorityss% 3
(ss3 4
[ss4 5
FromBodyss5 =
]ss= >
CreatePriorityDtoss? P
dtossQ T
)ssT U
{tt 
varuu 
resultuu 
=uu 
awaituu 
_serviceuu #
.uu# $
CreatePriorityAsyncuu$ 7
(uu7 8
dtouu8 ;
)uu; <
;uu< =
returnvv 
CreatedAtActionvv 
(vv 
nameofvv %
(vv% &
GetPrioritiesvv& 3
)vv3 4
,vv4 5
newvv6 9
{vv: ;
idvv< >
=vv? @
resultvvA G
.vvG H
IdvvH J
}vvK L
,vvL M
resultvvN T
)vvT U
;vvU V
}ww 
[yy 
HttpPutyy 
(yy 
$stryy 
)yy 
]yy  
[zz  
ProducesResponseTypezz 
(zz 
StatusCodeszz %
.zz% &
Status204NoContentzz& 8
)zz8 9
]zz9 :
[{{  
ProducesResponseType{{ 
({{ 
StatusCodes{{ %
.{{% &
Status404NotFound{{& 7
){{7 8
]{{8 9
public|| 

async|| 
Task|| 
<|| 
IActionResult|| #
>||# $
UpdatePriority||% 3
(||3 4
int||4 7
id||8 :
,||: ;
[||< =
FromBody||= E
]||E F
UpdatePriorityDto||G X
dto||Y \
)||\ ]
{}} 
try~~ 
{~~ 
await~~ 
_service~~ 
.~~ 
UpdatePriorityAsync~~ 0
(~~0 1
id~~1 3
,~~3 4
dto~~5 8
)~~8 9
;~~9 :
return~~; A
	NoContent~~B K
(~~K L
)~~L M
;~~M N
}~~O P
catch 
(  
KeyNotFoundException #
)# $
{% &
return' -
NotFound. 6
(6 7
)7 8
;8 9
}: ;
}
ÄÄ 
[
ÇÇ 

HttpDelete
ÇÇ 
(
ÇÇ 
$str
ÇÇ !
)
ÇÇ! "
]
ÇÇ" #
[
ÉÉ "
ProducesResponseType
ÉÉ 
(
ÉÉ 
StatusCodes
ÉÉ %
.
ÉÉ% & 
Status204NoContent
ÉÉ& 8
)
ÉÉ8 9
]
ÉÉ9 :
public
ÑÑ 

async
ÑÑ 
Task
ÑÑ 
<
ÑÑ 
IActionResult
ÑÑ #
>
ÑÑ# $
DeletePriority
ÑÑ% 3
(
ÑÑ3 4
int
ÑÑ4 7
id
ÑÑ8 :
)
ÑÑ: ;
{
ÖÖ 
await
ÜÜ 
_service
ÜÜ 
.
ÜÜ !
DeletePriorityAsync
ÜÜ *
(
ÜÜ* +
id
ÜÜ+ -
)
ÜÜ- .
;
ÜÜ. /
return
ÜÜ0 6
	NoContent
ÜÜ7 @
(
ÜÜ@ A
)
ÜÜA B
;
ÜÜB C
}
áá 
}àà œ!
Z/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/AuthController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[		 
ApiController		 
]		 
[

 
Route

 
(

 
$str

 
)

 
]

 
public 
class 
AuthController 
: 
ControllerBase ,
{ 
private 
readonly 
IAuthService !
_authService" .
;. /
public 

AuthController 
( 
IAuthService &
authService' 2
)2 3
{ 
_authService 
= 
authService "
;" #
} 
[ 
AllowAnonymous 
] 
[ 
HttpPost 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
AuthResponseDto! 0
)0 1
,1 2
StatusCodes3 >
.> ?
Status200OK? J
)J K
]K L
[  
ProducesResponseType 
( 
StatusCodes %
.% &!
Status401Unauthorized& ;
); <
]< =
public 

async 
Task 
< 
IActionResult #
># $
Login% *
(* +
[+ ,
FromBody, 4
]4 5
LoginRequestDto6 E
requestF M
)M N
{ 
try 
{ 	
var 
result 
= 
await 
_authService +
.+ ,

LoginAsync, 6
(6 7
request7 >
)> ?
;? @
return 
Ok 
( 
result 
) 
; 
} 	
catch 
( '
UnauthorizedAccessException *
)* +
{   	
return!! 
Unauthorized!! 
(!!  
new!!  #
{!!$ %
message!!& -
=!!. /
$str!!0 F
}!!G H
)!!H I
;!!I J
}"" 	
}## 
[%% 
	Authorize%% 
]%% 
[&& 
HttpGet&& 
(&& 
$str&& 
)&& 
]&& 
[''  
ProducesResponseType'' 
('' 
typeof''  
(''  !
MeResponseDto''! .
)''. /
,''/ 0
StatusCodes''1 <
.''< =
Status200OK''= H
)''H I
]''I J
[((  
ProducesResponseType(( 
((( 
StatusCodes(( %
.((% &!
Status401Unauthorized((& ;
)((; <
]((< =
public)) 

async)) 
Task)) 
<)) 
IActionResult)) #
>))# $
GetMe))% *
())* +
)))+ ,
{** 
var++ 
	userIdStr++ 
=++ 
User++ 
.++ 
FindFirstValue++ +
(+++ ,

ClaimTypes++, 6
.++6 7
NameIdentifier++7 E
)++E F
;++F G
if,, 

(,, 
!,, 
int,, 
.,, 
TryParse,, 
(,, 
	userIdStr,, #
,,,# $
out,,% (
int,,) ,
userId,,- 3
),,3 4
),,4 5
{-- 	
return.. 
Unauthorized.. 
(..  
)..  !
;..! "
}// 	
try11 
{22 	
var33 
result33 
=33 
await33 
_authService33 +
.33+ ,

GetMeAsync33, 6
(336 7
userId337 =
)33= >
;33> ?
return44 
Ok44 
(44 
result44 
)44 
;44 
}55 	
catch66 
(66 '
UnauthorizedAccessException66 *
)66* +
{77 	
return88 
Unauthorized88 
(88  
)88  !
;88! "
}99 	
}:: 
};; 