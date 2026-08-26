∆2
]/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/WebhookController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[ 
Route 
( 
$str 
) 
] 
[ 
	Authorize 

(
 
Policy 
= 
$str 5
)5 6
]6 7
public 
class 
WebhookController 
:  
ControllerBase! /
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

WebhookController 
( 
ItsToolDbContext -
context. 5
)5 6
{ 
_context 
= 
context 
; 
} 
[ 
HttpGet 
] 
public 

async 
Task 
< 
IActionResult #
># $
GetWebhooks% 0
(0 1
)1 2
{ 
var 
subs 
= 
await 
_context !
.! " 
WebhookSubscriptions" 6
.6 7
Where7 <
(< =
w= >
=>? A
!B C
wC D
.D E
	IsDeletedE N
)N O
.O P
ToListAsyncP [
([ \
)\ ]
;] ^
return 
Ok 
( 
subs 
) 
; 
} 
[   
HttpPost   
]   
public!! 

async!! 
Task!! 
<!! 
IActionResult!! #
>!!# $
CreateWebhook!!% 2
(!!2 3
[!!3 4
FromBody!!4 <
]!!< =
WebhookSubscription!!> Q
sub!!R U
)!!U V
{"" 
_context## 
.##  
WebhookSubscriptions## %
.##% &
Add##& )
(##) *
sub##* -
)##- .
;##. /
await$$ 
_context$$ 
.$$ 
SaveChangesAsync$$ '
($$' (
)$$( )
;$$) *
return%% 
Ok%% 
(%% 
sub%% 
)%% 
;%% 
}&& 
[(( 
HttpPut(( 
((( 
$str(( 
)(( 
](( 
public)) 

async)) 
Task)) 
<)) 
IActionResult)) #
>))# $
UpdateWebhook))% 2
())2 3
int))3 6
id))7 9
,))9 :
[)); <
FromBody))< D
]))D E
WebhookSubscription))F Y
sub))Z ]
)))] ^
{** 
var++ 
existing++ 
=++ 
await++ 
_context++ %
.++% & 
WebhookSubscriptions++& :
.++: ;
	FindAsync++; D
(++D E
id++E G
)++G H
;++H I
if,, 

(,, 
existing,, 
==,, 
null,, 
),, 
return,, $
NotFound,,% -
(,,- .
),,. /
;,,/ 0
existing.. 
... 
Url.. 
=.. 
sub.. 
... 
Url.. 
;.. 
existing// 
.// 
	EventsCsv// 
=// 
sub//  
.//  !
	EventsCsv//! *
;//* +
existing00 
.00 
Secret00 
=00 
sub00 
.00 
Secret00 $
;00$ %
existing11 
.11 
IsActive11 
=11 
sub11 
.11  
IsActive11  (
;11( )
await33 
_context33 
.33 
SaveChangesAsync33 '
(33' (
)33( )
;33) *
return44 
Ok44 
(44 
existing44 
)44 
;44 
}55 
[77 

HttpDelete77 
(77 
$str77 
)77 
]77 
public88 

async88 
Task88 
<88 
IActionResult88 #
>88# $
DeleteWebhook88% 2
(882 3
int883 6
id887 9
)889 :
{99 
var:: 
existing:: 
=:: 
await:: 
_context:: %
.::% & 
WebhookSubscriptions::& :
.::: ;
	FindAsync::; D
(::D E
id::E G
)::G H
;::H I
if;; 

(;; 
existing;; 
==;; 
null;; 
);; 
return;; $
NotFound;;% -
(;;- .
);;. /
;;;/ 0
existing== 
.== 
	IsDeleted== 
=== 
true== !
;==! "
await>> 
_context>> 
.>> 
SaveChangesAsync>> '
(>>' (
)>>( )
;>>) *
return?? 
	NoContent?? 
(?? 
)?? 
;?? 
}@@ 
[BB 
HttpPutBB 
(BB 
$strBB 
)BB 
]BB 
publicCC 

asyncCC 
TaskCC 
<CC 
IActionResultCC #
>CC# $
ToggleWebhookCC% 2
(CC2 3
intCC3 6
idCC7 9
)CC9 :
{DD 
varEE 
existingEE 
=EE 
awaitEE 
_contextEE %
.EE% & 
WebhookSubscriptionsEE& :
.EE: ;
	FindAsyncEE; D
(EED E
idEEE G
)EEG H
;EEH I
ifFF 

(FF 
existingFF 
==FF 
nullFF 
||FF 
existingFF  (
.FF( )
	IsDeletedFF) 2
)FF2 3
returnFF4 :
NotFoundFF; C
(FFC D
)FFD E
;FFE F
existingHH 
.HH 
IsActiveHH 
=HH 
!HH 
existingHH %
.HH% &
IsActiveHH& .
;HH. /
awaitII 
_contextII 
.II 
SaveChangesAsyncII '
(II' (
)II( )
;II) *
returnJJ 
	NoContentJJ 
(JJ 
)JJ 
;JJ 
}KK 
}LL œâ
G/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Program.cs
var 
builder 
= 
WebApplication 
. 
CreateBuilder *
(* +
args+ /
)/ 0
;0 1
builder 
. 
Services 
. 
AddControllers 
(  
)  !
;! "
builder 
. 
Services 
. #
AddEndpointsApiExplorer (
(( )
)) *
;* +
builder 
. 
Services 
. 
AddSwaggerGen 
( 
)  
;  !
builder 
. 
Services 
. "
AddHttpContextAccessor '
(' (
)( )
;) *
builder 
. 
Services 
. 
AddDbContext 
< 
ItsToolDbContext .
>. /
(/ 0
options0 7
=>8 :
options 
. 
	UseNpgsql 
( 
builder 
. 
Configuration +
.+ ,
GetConnectionString, ?
(? @
$str@ S
)S T
)T U
)U V
;V W
builder 
. 
Services 
. 
	AddScoped 
< 

DataSeeder %
>% &
(& '
)' (
;( )
builder 
. 
Services 
. 
	AddScoped 
< 
ITokenService (
,( )
TokenService* 6
>6 7
(7 8
)8 9
;9 :
builder 
. 
Services 
. 
	AddScoped 
< !
IPermissionCalculator 0
,0 1 
PermissionCalculator2 F
>F G
(G H
)H I
;I J
builder 
. 
Services 
. 
	AddScoped 
< 
IAuthService '
,' (
AuthService) 4
>4 5
(5 6
)6 7
;7 8
builder 
. 
Services 
. 
	AddScoped 
( 
typeof !
(! "
IRepository" -
<- .
>. /
)/ 0
,0 1
typeof2 8
(8 9

Repository9 C
<C D
>D E
)E F
)F G
;G H
builder   
.   
Services   
.   
	AddScoped   
<   
IDepartmentService   -
,  - .
DepartmentService  / @
>  @ A
(  A B
)  B C
;  C D
builder!! 
.!! 
Services!! 
.!! 
	AddScoped!! 
<!! 
IGroupService!! (
,!!( )
GroupService!!* 6
>!!6 7
(!!7 8
)!!8 9
;!!9 :
builder"" 
."" 
Services"" 
."" 
	AddScoped"" 
<"" 
IUserService"" '
,""' (
UserService"") 4
>""4 5
(""5 6
)""6 7
;""7 8
builder## 
.## 
Services## 
.## 
	AddScoped## 
<## 
IProjectService## *
,##* +
ProjectService##, :
>##: ;
(##; <
)##< =
;##= >
builder$$ 
.$$ 
Services$$ 
.$$ 
	AddScoped$$ 
<$$ 
IRoleService$$ '
,$$' (
RoleService$$) 4
>$$4 5
($$5 6
)$$6 7
;$$7 8
builder'' 
.'' 
Services'' 
.'' 
	AddScoped'' 
<'' 
ICatalogService'' *
,''* +
CatalogService'', :
>'': ;
(''; <
)''< =
;''= >
builder(( 
.(( 
Services(( 
.(( 
	AddScoped(( 
<(( 
IWorkflowService(( +
,((+ ,
WorkflowService((- <
>((< =
(((= >
)((> ?
;((? @
builder)) 
.)) 
Services)) 
.)) 
	AddScoped)) 
<)) 
IDynamicFormService)) .
,)). /
DynamicFormService))0 B
>))B C
())C D
)))D E
;))E F
builder,, 
.,, 
Services,, 
.,, 
	AddScoped,, 
<,, 
IFileStorageService,, .
,,,. /#
LocalFileStorageService,,0 G
>,,G H
(,,H I
),,I J
;,,J K
builder-- 
.-- 
Services-- 
.-- 
	AddScoped-- 
<-- 
ITicketService-- )
,--) *
TicketService--+ 8
>--8 9
(--9 :
)--: ;
;--; <
builder.. 
... 
Services.. 
... 
	AddScoped.. 
<.. 
IEmailService.. ,
>.., -
(..- .
sp... 0
=>..1 3
{// 
var00 
config00 
=00 
sp00 
.00 
GetRequiredService00 *
<00* +
IConfiguration00+ 9
>009 :
(00: ;
)00; <
;00< =
var11 
host11 
=11 
config11 
[11 
$str11 %
]11% &
;11& '
if22 

(22 
!22 
string22 
.22 
IsNullOrEmpty22 !
(22! "
host22" &
)22& '
)22' (
{33 	
var44 
logger44 
=44 
sp44 
.44 
GetRequiredService44 .
<44. /
ILogger44/ 6
<446 7
SmtpEmailService447 G
>44G H
>44H I
(44I J
)44J K
;44K L
return55 
new55 
SmtpEmailService55 '
(55' (
config55( .
,55. /
logger550 6
)556 7
;557 8
}66 	
return77 
new77 
StubEmailService77 #
(77# $
)77$ %
;77% &
}88 
)88 
;88 
builder99 
.99 
Services99 
.99 
	AddScoped99 
<99 "
IEmailIngestionService99 5
,995 6!
EmailIngestionService997 L
>99L M
(99M N
)99N O
;99O P
builder:: 
.:: 
Services:: 
.:: 
	AddScoped:: 
<:: 

ISlaEngine:: %
,::% &
	SlaEngine::' 0
>::0 1
(::1 2
)::2 3
;::3 4
builder;; 
.;; 
Services;; 
.;; 
	AddScoped;; 
<;; 
IAssignmentEngine;; ,
,;;, -
AssignmentEngine;;. >
>;;> ?
(;;? @
);;@ A
;;;A B
builder<< 
.<< 
Services<< 
.<< 
AddHttpClient<< 
(<< 
)<<  
;<<  !
builder== 
.== 
Services== 
.== 
	AddScoped== 
<== 
IWebhookDispatcher== -
,==- .
WebhookDispatcher==/ @
>==@ A
(==A B
)==B C
;==C D
builder>> 
.>> 
Services>> 
.>> 
	AddScoped>> 
<>> #
INotificationDispatcher>> 2
,>>2 3"
NotificationDispatcher>>4 J
>>>J K
(>>K L
)>>L M
;>>M N
builder?? 
.?? 
Services?? 
.?? 
	AddScoped?? 
<??  
INotificationService?? 3
,??3 4
NotificationService??5 H
>??H I
(??I J
)??J K
;??K L
builder@@ 
.@@ 
Services@@ 
.@@ 
	AddScoped@@ 
<@@ 
ISlaService@@ *
,@@* +

SlaService@@, 6
>@@6 7
(@@7 8
)@@8 9
;@@9 :
builderAA 
.AA 
ServicesAA 
.AA 
AddHostedServiceAA %
<AA% &
SlaCheckerServiceAA& 7
>AA7 8
(AA8 9
)AA9 :
;AA: ;
builderDD 
.DD 
ServicesDD 
.DD 
	AddScopedDD 
<DD 
IDashboardServiceDD 0
,DD0 1
DashboardServiceDD2 B
>DDB C
(DDC D
)DDD E
;DDE F
builderEE 
.EE 
ServicesEE 
.EE 
	AddScopedEE 
<EE 
IReportServiceEE -
,EE- .
ReportServiceEE/ <
>EE< =
(EE= >
)EE> ?
;EE? @
builderFF 
.FF 
ServicesFF 
.FF 
	AddScopedFF 
<FF !
IKnowledgeBaseServiceFF 4
,FF4 5 
KnowledgeBaseServiceFF6 J
>FFJ K
(FFK L
)FFL M
;FFM N
builderGG 
.GG 
ServicesGG 
.GG 
	AddScopedGG 
<GG 
ISystemAuditServiceGG 2
,GG2 3
SystemAuditServiceGG4 F
>GGF G
(GGG H
)GGH I
;GGI J
builderJJ 
.JJ 
ServicesJJ 
.JJ 
AddAuthenticationJJ "
(JJ" #
JwtBearerDefaultsJJ# 4
.JJ4 5 
AuthenticationSchemeJJ5 I
)JJI J
.KK 
AddJwtBearerKK 
(KK 
optionsKK 
=>KK 
{LL 
optionsMM 
.MM %
TokenValidationParametersMM )
=MM* +
newMM, /%
TokenValidationParametersMM0 I
{NN 	
ValidateIssuerOO 
=OO 
trueOO !
,OO! "
ValidateAudiencePP 
=PP 
truePP #
,PP# $
ValidateLifetimeQQ 
=QQ 
trueQQ #
,QQ# $$
ValidateIssuerSigningKeyRR $
=RR% &
trueRR' +
,RR+ ,
ValidIssuerSS 
=SS 
builderSS !
.SS! "
ConfigurationSS" /
[SS/ 0
$strSS0 <
]SS< =
,SS= >
ValidAudienceTT 
=TT 
builderTT #
.TT# $
ConfigurationTT$ 1
[TT1 2
$strTT2 @
]TT@ A
,TTA B
IssuerSigningKeyUU 
=UU 
newUU " 
SymmetricSecurityKeyUU# 7
(UU7 8
EncodingUU8 @
.UU@ A
UTF8UUA E
.UUE F
GetBytesUUF N
(UUN O
builderUUO V
.UUV W
ConfigurationUUW d
[UUd e
$strUUe q
]UUq r
??UUs u
$str	UUv •
)
UU• ¶
)
UU¶ ß
}VV 	
;VV	 

}WW 
)WW 
;WW 
builderYY 
.YY 
ServicesYY 
.YY 
AddSingletonYY 
<YY !
IAuthorizationHandlerYY 3
,YY3 4*
PermissionAuthorizationHandlerYY5 S
>YYS T
(YYT U
)YYU V
;YYV W
builderZZ 
.ZZ 
ServicesZZ 
.ZZ 
AddAuthorizationZZ !
(ZZ! "
optionsZZ" )
=>ZZ* ,
{[[ 
foreach\\ 
(\\ 
var\\ 
perm\\ 
in\\ 
PermissionConstants\\ ,
.\\, -
AllPermissions\\- ;
)\\; <
{]] 
options^^ 
.^^ 
	AddPolicy^^ 
(^^ 
$"^^ 
$str^^ .
{^^. /
perm^^/ 3
}^^3 4
"^^4 5
,^^5 6
policy^^7 =
=>^^> @
policy__ 
.__ 
Requirements__ 
.__  
Add__  #
(__# $
new__$ '!
PermissionRequirement__( =
(__= >
perm__> B
)__B C
)__C D
)__D E
;__E F
}`` 
optionsaa 
.aa 
	AddPolicyaa 
(aa 
$straa '
,aa' (
policyaa) /
=>aa0 2
policyaa3 9
.aa9 :
RequireClaimaa: F
(aaF G
$straaG S
,aaS T
$straaU `
)aa` a
)aaa b
;aab c
}bb 
)bb 
;bb 
varee 
allowedOriginsee 
=ee 
builderee 
.ee 
Configurationee *
.ee* +

GetSectionee+ 5
(ee5 6
$stree6 K
)eeK L
.eeL M
GeteeM P
<eeP Q
stringeeQ W
[eeW X
]eeX Y
>eeY Z
(eeZ [
)ee[ \
??ff 
Arrayff 
.ff 	
Emptyff	 
<ff 
stringff 
>ff 
(ff 
)ff 
;ff 
builderhh 
.hh 
Serviceshh 
.hh 
AddCorshh 
(hh 
optionshh  
=>hh! #
{ii 
optionsjj 
.jj 
	AddPolicyjj 
(jj 
$strjj &
,jj& '
builderjj( /
=>jj0 2
{kk 
builderll 
.ll 
WithOriginsll 
(ll 
allowedOriginsll *
)ll* +
.mm 
AllowAnyMethodmm 
(mm 
)mm 
.nn 
AllowAnyHeadernn 
(nn 
)nn 
;nn 
}oo 
)oo 
;oo 
}qq 
)qq 
;qq 
varss 
appss 
=ss 	
builderss
 
.ss 
Buildss 
(ss 
)ss 
;ss 
ifvv 
(vv 
appvv 
.vv 
Environmentvv 
.vv 
IsDevelopmentvv !
(vv! "
)vv" #
)vv# $
{ww 
appxx 
.xx 

UseSwaggerxx 
(xx 
)xx 
;xx 
appyy 
.yy 
UseSwaggerUIyy 
(yy 
)yy 
;yy 
}zz 
app|| 
.|| 
UseCors|| 
(|| 
$str|| 
)|| 
;|| 
app}} 
.}} 
UseHttpsRedirection}} 
(}} 
)}} 
;}} 
app 
. 
UseDefaultFiles 
( 
) 
; 
appÄÄ 
.
ÄÄ 
UseStaticFiles
ÄÄ 
(
ÄÄ 
)
ÄÄ 
;
ÄÄ 
appÇÇ 
.
ÇÇ 
UseAuthentication
ÇÇ 
(
ÇÇ 
)
ÇÇ 
;
ÇÇ 
appÉÉ 
.
ÉÉ 
UseAuthorization
ÉÉ 
(
ÉÉ 
)
ÉÉ 
;
ÉÉ 
appÖÖ 
.
ÖÖ 
MapGet
ÖÖ 

(
ÖÖ
 
$str
ÖÖ 
,
ÖÖ 
(
ÖÖ 
)
ÖÖ 
=>
ÖÖ 
{ÜÜ 
return
áá 

Results
áá 
.
áá 
Ok
áá 
(
áá 
new
áá 
{
àà 
status
ââ 
=
ââ 
$str
ââ 
,
ââ 
service
ää 
=
ää 
$str
ää 
,
ää  
	timestamp
ãã 
=
ãã 
DateTime
ãã 
.
ãã 
UtcNow
ãã #
}
åå 
)
åå 
;
åå 
}çç 
)
çç 
;
çç 
appèè 
.
èè 
MapControllers
èè 
(
èè 
)
èè 
;
èè 
ifëë 
(
ëë 
app
ëë 
.
ëë 
Environment
ëë 
.
ëë 
IsDevelopment
ëë !
(
ëë! "
)
ëë" #
&&
ëë$ &
builder
ëë' .
.
ëë. /
Configuration
ëë/ <
.
ëë< =
GetValue
ëë= E
<
ëëE F
bool
ëëF J
>
ëëJ K
(
ëëK L
$str
ëëL V
)
ëëV W
)
ëëW X
{íí 
using
ìì 	
var
ìì
 
scope
ìì 
=
ìì 
app
ìì 
.
ìì 
Services
ìì "
.
ìì" #
CreateScope
ìì# .
(
ìì. /
)
ìì/ 0
;
ìì0 1
var
îî 
context
îî 
=
îî 
scope
îî 
.
îî 
ServiceProvider
îî '
.
îî' ( 
GetRequiredService
îî( :
<
îî: ;
ItsTool
îî; B
.
îîB C
Infrastructure
îîC Q
.
îîQ R
Data
îîR V
.
îîV W
ItsToolDbContext
îîW g
>
îîg h
(
îîh i
)
îîi j
;
îîj k
await
ïï 	
context
ïï
 
.
ïï 
Database
ïï 
.
ïï 
MigrateAsync
ïï '
(
ïï' (
)
ïï( )
;
ïï) *
var
ññ 
seeder
ññ 
=
ññ 
new
ññ 
ItsTool
ññ 
.
ññ 
Infrastructure
ññ +
.
ññ+ ,
Data
ññ, 0
.
ññ0 1

DataSeeder
ññ1 ;
(
ññ; <
context
ññ< C
)
ññC D
;
ññD E
await
óó 	
seeder
óó
 
.
óó 
	SeedAsync
óó 
(
óó 
)
óó 
;
óó 
}òò 
awaitöö 
app
öö 	
.
öö	 

RunAsync
öö
 
(
öö 
)
öö 
;
öö £
`/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/HostedServices/SlaCheckerService.cs
	namespace		 	
ItsTool		
 
.		 
API		 
.		 
HostedServices		 $
;		$ %
public 
class 
SlaCheckerService 
:  
BackgroundService! 2
{ 
private 
readonly 
IServiceProvider %
	_services& /
;/ 0
private 
readonly 
ILogger 
< 
SlaCheckerService .
>. /
_logger0 7
;7 8
public 

SlaCheckerService 
( 
IServiceProvider -
services. 6
,6 7
ILogger8 ?
<? @
SlaCheckerService@ Q
>Q R
loggerS Y
)Y Z
{ 
	_services 
= 
services 
; 
_logger 
= 
logger 
; 
} 
	protected 
override 
async 
Task !
ExecuteAsync" .
(. /
CancellationToken/ @
stoppingTokenA N
)N O
{ 
_logger 
. 
LogInformation 
( 
$str =
)= >
;> ?
while 
( 
! 
stoppingToken 
. #
IsCancellationRequested 5
)5 6
{ 	
try 
{ 
using 
( 
var 
scope  
=! "
	_services# ,
., -
CreateScope- 8
(8 9
)9 :
): ;
{ 
var   
engine   
=    
scope  ! &
.  & '
ServiceProvider  ' 6
.  6 7
GetRequiredService  7 I
<  I J

ISlaEngine  J T
>  T U
(  U V
)  V W
;  W X
await!! 
engine!!  
.!!  !
CheckBreachesAsync!!! 3
(!!3 4
DateTime!!4 <
.!!< =
UtcNow!!= C
)!!C D
;!!D E
}"" 
}## 
catch$$ 
($$ 
	Exception$$ 
ex$$ 
)$$  
{%% 
_logger&& 
.&& 
LogError&&  
(&&  !
ex&&! #
,&&# $
$str&&% J
)&&J K
;&&K L
}'' 
await)) 
Task)) 
.)) 
Delay)) 
()) 
TimeSpan)) %
.))% &
FromMinutes))& 1
())1 2
$num))2 3
)))3 4
,))4 5
stoppingToken))6 C
)))C D
;))D E
}** 	
}++ 
},, ÏP
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
}XX Î
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
} ıL
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
]


 
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
[&& 
	Authorize&& 
(&& 
Policy&& 
=&& 
$str&& 8
)&&8 9
]&&9 :
[''  
ProducesResponseType'' 
('' 
typeof''  
(''  !
UserDto''! (
)''( )
,'') *
StatusCodes''+ 6
.''6 7
Status201Created''7 G
)''G H
]''H I
public(( 

async(( 
Task(( 
<(( 
IActionResult(( #
>((# $
Create((% +
(((+ ,
[((, -
FromBody((- 5
]((5 6
CreateUserDto((7 D
dto((E H
)((H I
{)) 
var** 
created** 
=** 
await** 
_service** $
.**$ %
CreateAsync**% 0
(**0 1
dto**1 4
)**4 5
;**5 6
return++ 
CreatedAtAction++ 
(++ 
nameof++ %
(++% &
GetById++& -
)++- .
,++. /
new++0 3
{++4 5
id++6 8
=++9 :
created++; B
.++B C
Id++C E
}++F G
,++G H
created++I P
)++P Q
;++Q R
},, 
[.. 
HttpPut.. 
(.. 
$str.. 
).. 
].. 
[// 
	Authorize// 
(// 
Policy// 
=// 
$str// 8
)//8 9
]//9 :
[00  
ProducesResponseType00 
(00 
StatusCodes00 %
.00% &
Status204NoContent00& 8
)008 9
]009 :
[11  
ProducesResponseType11 
(11 
StatusCodes11 %
.11% &
Status404NotFound11& 7
)117 8
]118 9
public22 

async22 
Task22 
<22 
IActionResult22 #
>22# $
Update22% +
(22+ ,
int22, /
id220 2
,222 3
[224 5
FromBody225 =
]22= >
UpdateUserDto22? L
dto22M P
)22P Q
{33 
try44 
{55 	
await66 
_service66 
.66 
UpdateAsync66 &
(66& '
id66' )
,66) *
dto66+ .
)66. /
;66/ 0
return77 
	NoContent77 
(77 
)77 
;77 
}88 	
catch99 
(99  
KeyNotFoundException99 #
)99# $
{:: 	
return;; 
NotFound;; 
(;; 
);; 
;;; 
}<< 	
}== 
[?? 

HttpDelete?? 
(?? 
$str?? 
)?? 
]?? 
[@@ 
	Authorize@@ 
(@@ 
Policy@@ 
=@@ 
$str@@ 8
)@@8 9
]@@9 :
[AA  
ProducesResponseTypeAA 
(AA 
StatusCodesAA %
.AA% &
Status204NoContentAA& 8
)AA8 9
]AA9 :
[BB  
ProducesResponseTypeBB 
(BB 
StatusCodesBB %
.BB% &
Status404NotFoundBB& 7
)BB7 8
]BB8 9
publicCC 

asyncCC 
TaskCC 
<CC 
IActionResultCC #
>CC# $
DeleteCC% +
(CC+ ,
intCC, /
idCC0 2
)CC2 3
{DD 
tryEE 
{FF 	
awaitGG 
_serviceGG 
.GG 
DeleteAsyncGG &
(GG& '
idGG' )
)GG) *
;GG* +
returnHH 
	NoContentHH 
(HH 
)HH 
;HH 
}II 	
catchJJ 
(JJ  
KeyNotFoundExceptionJJ #
)JJ# $
{KK 	
returnLL 
NotFoundLL 
(LL 
)LL 
;LL 
}MM 	
}NN 
[PP 
HttpPostPP 
(PP 
$strPP #
)PP# $
]PP$ %
[QQ 
	AuthorizeQQ 
(QQ 
PolicyQQ 
=QQ 
$strQQ 8
)QQ8 9
]QQ9 :
[RR  
ProducesResponseTypeRR 
(RR 
StatusCodesRR %
.RR% &
Status204NoContentRR& 8
)RR8 9
]RR9 :
publicSS 

asyncSS 
TaskSS 
<SS 
IActionResultSS #
>SS# $

AssignRoleSS% /
(SS/ 0
intSS0 3
idSS4 6
,SS6 7
intSS8 ;
roleIdSS< B
)SSB C
{TT 
awaitUU 
_serviceUU 
.UU 
AssignRoleAsyncUU &
(UU& '
idUU' )
,UU) *
roleIdUU+ 1
)UU1 2
;UU2 3
returnVV 
	NoContentVV 
(VV 
)VV 
;VV 
}WW 
[YY 

HttpDeleteYY 
(YY 
$strYY %
)YY% &
]YY& '
[ZZ 
	AuthorizeZZ 
(ZZ 
PolicyZZ 
=ZZ 
$strZZ 8
)ZZ8 9
]ZZ9 :
[[[  
ProducesResponseType[[ 
([[ 
StatusCodes[[ %
.[[% &
Status204NoContent[[& 8
)[[8 9
][[9 :
public\\ 

async\\ 
Task\\ 
<\\ 
IActionResult\\ #
>\\# $

RevokeRole\\% /
(\\/ 0
int\\0 3
id\\4 6
,\\6 7
int\\8 ;
roleId\\< B
)\\B C
{]] 
await^^ 
_service^^ 
.^^ 
RevokeRoleAsync^^ &
(^^& '
id^^' )
,^^) *
roleId^^+ 1
)^^1 2
;^^2 3
return__ 
	NoContent__ 
(__ 
)__ 
;__ 
}`` 
[bb 
HttpPostbb 
(bb 
$strbb /
)bb/ 0
]bb0 1
[cc 
	Authorizecc 
(cc 
Policycc 
=cc 
$strcc 8
)cc8 9
]cc9 :
[dd  
ProducesResponseTypedd 
(dd 
StatusCodesdd %
.dd% &
Status204NoContentdd& 8
)dd8 9
]dd9 :
publicee 

asyncee 
Taskee 
<ee 
IActionResultee #
>ee# $!
SetPermissionOverrideee% :
(ee: ;
intee; >
idee? A
,eeA B
inteeC F
permissionIdeeG S
,eeS T
[eeU V
	FromQueryeeV _
]ee_ `
booleea e
	isGrantedeef o
)eeo p
{ff 
awaitgg 
_servicegg 
.gg &
AddPermissionOverrideAsyncgg 1
(gg1 2
idgg2 4
,gg4 5
permissionIdgg6 B
,ggB C
	isGrantedggD M
)ggM N
;ggN O
returnhh 
	NoContenthh 
(hh 
)hh 
;hh 
}ii 
}jj »ƒ
\/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/TicketController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[

 
ApiController

 
]

 
[ 
Route 
( 
$str 
) 
] 
[ 
	Authorize 

]
 
public 
class 
TicketController 
: 
ControllerBase  .
{ 
private 
readonly 
ITicketService #
_service$ ,
;, -
public 

TicketController 
( 
ITicketService *
service+ 2
)2 3
{ 
_service 
= 
service 
; 
} 
private 
int 
GetCurrentUserId  
(  !
)! "
{ 
var 
idClaim 
= 
User 
. 
	FindFirst $
($ %

ClaimTypes% /
./ 0
NameIdentifier0 >
)> ?
?? @
.@ A
ValueA F
;F G
return 
int 
. 
TryParse 
( 
idClaim #
,# $
out% (
var) ,
id- /
)/ 0
?1 2
id3 5
:6 7
$num8 9
;9 :
} 
[ 
HttpPost 
] 
[ 
	Authorize 
( 
Policy 
= 
$str 9
)9 :
]: ;
[  
ProducesResponseType 
( 
typeof  
(  !
	TicketDto! *
)* +
,+ ,
StatusCodes- 8
.8 9
Status201Created9 I
)I J
]J K
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status400BadRequest& 9
)9 :
]: ;
public   

async   
Task   
<   
IActionResult   #
>  # $
CreateTicket  % 1
(  1 2
[  2 3
FromBody  3 ;
]  ; <
CreateTicketDto  = L
dto  M P
)  P Q
{!! 
try"" 
{## 	
var$$ 
result$$ 
=$$ 
await$$ 
_service$$ '
.$$' (
CreateTicketAsync$$( 9
($$9 :
dto$$: =
)$$= >
;$$> ?
return%% 
CreatedAtAction%% "
(%%" #
nameof%%# )
(%%) *
	GetTicket%%* 3
)%%3 4
,%%4 5
new%%6 9
{%%: ;
id%%< >
=%%? @
result%%A G
.%%G H
Id%%H J
}%%K L
,%%L M
result%%N T
)%%T U
;%%U V
}&& 	
catch'' 
('' %
InvalidOperationException'' (
ex'') +
)''+ ,
{''- .
return''/ 5

BadRequest''6 @
(''@ A
new''A D
{''E F
error''G L
=''M N
ex''O Q
.''Q R
Message''R Y
}''Z [
)''[ \
;''\ ]
}''^ _
}(( 
[** 
HttpGet** 
(** 
$str** 
)** 
]** 
[++ 
	Authorize++ 
(++ 
Policy++ 
=++ 
$str++ 7
)++7 8
]++8 9
[,,  
ProducesResponseType,, 
(,, 
typeof,,  
(,,  !
	TicketDto,,! *
),,* +
,,,+ ,
StatusCodes,,- 8
.,,8 9
Status200OK,,9 D
),,D E
],,E F
[--  
ProducesResponseType-- 
(-- 
StatusCodes-- %
.--% &
Status404NotFound--& 7
)--7 8
]--8 9
public.. 

async.. 
Task.. 
<.. 
IActionResult.. #
>..# $
	GetTicket..% .
(... /
int../ 2
id..3 5
)..5 6
{// 
var00 
t00 
=00 
await00 
_service00 
.00 
GetTicketByIdAsync00 1
(001 2
id002 4
)004 5
;005 6
if11 

(11 
t11 
==11 
null11 
)11 
return11 
NotFound11 &
(11& '
)11' (
;11( )
return22 
Ok22 
(22 
t22 
)22 
;22 
}33 
[55 
HttpPut55 
(55 
$str55 
)55 
]55 
[66 
	Authorize66 
(66 
Policy66 
=66 
$str66 7
)667 8
]668 9
[77  
ProducesResponseType77 
(77 
StatusCodes77 %
.77% &
Status204NoContent77& 8
)778 9
]779 :
[88  
ProducesResponseType88 
(88 
StatusCodes88 %
.88% &
Status404NotFound88& 7
)887 8
]888 9
[99  
ProducesResponseType99 
(99 
StatusCodes99 %
.99% &
Status400BadRequest99& 9
)999 :
]99: ;
public:: 

async:: 
Task:: 
<:: 
IActionResult:: #
>::# $
UpdateTicket::% 1
(::1 2
int::2 5
id::6 8
,::8 9
[::: ;
FromBody::; C
]::C D
UpdateTicketDto::E T
dto::U X
)::X Y
{;; 
try<< 
{== 	
await>> 
_service>> 
.>> 
UpdateTicketAsync>> ,
(>>, -
id>>- /
,>>/ 0
dto>>1 4
,>>4 5
GetCurrentUserId>>6 F
(>>F G
)>>G H
)>>H I
;>>I J
return?? 
	NoContent?? 
(?? 
)?? 
;?? 
}@@ 	
catchAA 
(AA  
KeyNotFoundExceptionAA #
)AA# $
{AA% &
returnAA' -
NotFoundAA. 6
(AA6 7
)AA7 8
;AA8 9
}AA: ;
catchBB 
(BB %
InvalidOperationExceptionBB (
exBB) +
)BB+ ,
{BB- .
returnBB/ 5

BadRequestBB6 @
(BB@ A
newBBA D
{BBE F
errorBBG L
=BBM N
exBBO Q
.BBQ R
MessageBBR Y
}BBZ [
)BB[ \
;BB\ ]
}BB^ _
}CC 
[EE 
HttpGetEE 
(EE 
$strEE '
)EE' (
]EE( )
[FF  
ProducesResponseTypeFF 
(FF 
StatusCodesFF %
.FF% &
Status200OKFF& 1
)FF1 2
]FF2 3
[GG  
ProducesResponseTypeGG 
(GG 
StatusCodesGG %
.GG% &
Status404NotFoundGG& 7
)GG7 8
]GG8 9
publicHH 

asyncHH 
TaskHH 
<HH 
IActionResultHH #
>HH# $!
GetAllowedTransitionsHH% :
(HH: ;
intHH; >
idHH? A
)HHA B
{II 
tryJJ 
{KK 	
varLL 
transitionsLL 
=LL 
awaitLL #
_serviceLL$ ,
.LL, -&
GetAllowedTransitionsAsyncLL- G
(LLG H
idLLH J
,LLJ K
GetCurrentUserIdLLL \
(LL\ ]
)LL] ^
)LL^ _
;LL_ `
returnMM 
OkMM 
(MM 
transitionsMM !
)MM! "
;MM" #
}NN 	
catchOO 
(OO  
KeyNotFoundExceptionOO #
)OO# $
{PP 	
returnQQ 
NotFoundQQ 
(QQ 
)QQ 
;QQ 
}RR 	
}SS 
[UU 
HttpPostUU 
(UU 
$strUU 
)UU 
]UU 
[VV  
ProducesResponseTypeVV 
(VV 
StatusCodesVV %
.VV% &
Status204NoContentVV& 8
)VV8 9
]VV9 :
[WW  
ProducesResponseTypeWW 
(WW 
StatusCodesWW %
.WW% &
Status404NotFoundWW& 7
)WW7 8
]WW8 9
[XX  
ProducesResponseTypeXX 
(XX 
StatusCodesXX %
.XX% &
Status400BadRequestXX& 9
)XX9 :
]XX: ;
[YY  
ProducesResponseTypeYY 
(YY 
StatusCodesYY %
.YY% &!
Status401UnauthorizedYY& ;
)YY; <
]YY< =
publicZZ 

asyncZZ 
TaskZZ 
<ZZ 
IActionResultZZ #
>ZZ# $
ChangeStatusZZ% 1
(ZZ1 2
intZZ2 5
idZZ6 8
,ZZ8 9
[ZZ: ;
FromBodyZZ; C
]ZZC D
intZZE H
newStatusIdZZI T
)ZZT U
{[[ 
try\\ 
{]] 	
var^^ 
dto^^ 
=^^ 
new^^ 
ChangeStatusDto^^ )
(^^) *
newStatusId^^* 5
,^^5 6
GetCurrentUserId^^7 G
(^^G H
)^^H I
)^^I J
;^^J K
await__ 
_service__ 
.__ 
ChangeStatusAsync__ ,
(__, -
id__- /
,__/ 0
dto__1 4
)__4 5
;__5 6
return`` 
	NoContent`` 
(`` 
)`` 
;`` 
}aa 	
catchbb 
(bb  
KeyNotFoundExceptionbb #
)bb# $
{bb% &
returnbb' -
NotFoundbb. 6
(bb6 7
)bb7 8
;bb8 9
}bb: ;
catchcc 
(cc %
InvalidOperationExceptioncc (
excc) +
)cc+ ,
{cc- .
returncc/ 5

BadRequestcc6 @
(cc@ A
newccA D
{ccE F
errorccG L
=ccM N
exccO Q
.ccQ R
MessageccR Y
}ccZ [
)cc[ \
;cc\ ]
}cc^ _
catchdd 
(dd '
UnauthorizedAccessExceptiondd *
exdd+ -
)dd- .
{dd/ 0
returndd1 7
Unauthorizeddd8 D
(ddD E
newddE H
{ddI J
errorddK P
=ddQ R
exddS U
.ddU V
MessageddV ]
}dd^ _
)dd_ `
;dd` a
}ddb c
}ee 
[gg 
HttpPostgg 
(gg 
$strgg 
)gg 
]gg 
[hh  
ProducesResponseTypehh 
(hh 
StatusCodeshh %
.hh% &
Status204NoContenthh& 8
)hh8 9
]hh9 :
publicii 

asyncii 
Taskii 
<ii 
IActionResultii #
>ii# $
AssignTicketii% 1
(ii1 2
intii2 5
idii6 8
,ii8 9
[ii: ;
FromBodyii; C
]iiC D
intiiE H
userIdiiI O
)iiO P
{jj 
trykk 
{ll 	
varmm 
dtomm 
=mm 
newmm 
AssignTicketDtomm )
(mm) *
userIdmm* 0
,mm0 1
GetCurrentUserIdmm2 B
(mmB C
)mmC D
)mmD E
;mmE F
awaitnn 
_servicenn 
.nn 
AssignTicketAsyncnn ,
(nn, -
idnn- /
,nn/ 0
dtonn1 4
)nn4 5
;nn5 6
returnoo 
	NoContentoo 
(oo 
)oo 
;oo 
}pp 	
catchqq 
(qq  
KeyNotFoundExceptionqq #
)qq# $
{qq% &
returnqq' -
NotFoundqq. 6
(qq6 7
)qq7 8
;qq8 9
}qq: ;
catchrr 
(rr '
UnauthorizedAccessExceptionrr *
exrr+ -
)rr- .
{rr/ 0
returnrr1 7
Unauthorizedrr8 D
(rrD E
newrrE H
{rrI J
errorrrK P
=rrQ R
exrrS U
.rrU V
MessagerrV ]
}rr^ _
)rr_ `
;rr` a
}rrb c
}ss 
[uu 
HttpPostuu 
(uu 
$struu 
)uu 
]uu 
[vv  
ProducesResponseTypevv 
(vv 
StatusCodesvv %
.vv% &
Status204NoContentvv& 8
)vv8 9
]vv9 :
publicww 

asyncww 
Taskww 
<ww 
IActionResultww #
>ww# $
TransferTicketww% 3
(ww3 4
intww4 7
idww8 :
,ww: ;
[ww< =
FromBodyww= E
]wwE F
TransferTicketDtowwG X
dtowwY \
)ww\ ]
{xx 
tryyy 
{zz 	
var{{ 
transferDto{{ 
={{ 
new{{ !
TransferTicketDto{{" 3
({{3 4
dto{{4 7
.{{7 8
	ProjectId{{8 A
,{{A B
dto{{C F
.{{F G
GroupId{{G N
,{{N O
GetCurrentUserId{{P `
({{` a
){{a b
){{b c
;{{c d
await|| 
_service|| 
.|| 
TransferTicketAsync|| .
(||. /
id||/ 1
,||1 2
transferDto||3 >
)||> ?
;||? @
return}} 
	NoContent}} 
(}} 
)}} 
;}} 
}~~ 	
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
}: ;
catch
ÄÄ 
(
ÄÄ )
UnauthorizedAccessException
ÄÄ *
ex
ÄÄ+ -
)
ÄÄ- .
{
ÄÄ/ 0
return
ÄÄ1 7
Unauthorized
ÄÄ8 D
(
ÄÄD E
new
ÄÄE H
{
ÄÄI J
error
ÄÄK P
=
ÄÄQ R
ex
ÄÄS U
.
ÄÄU V
Message
ÄÄV ]
}
ÄÄ^ _
)
ÄÄ_ `
;
ÄÄ` a
}
ÄÄb c
}
ÅÅ 
[
ÉÉ 
HttpPost
ÉÉ 
(
ÉÉ 
$str
ÉÉ 
)
ÉÉ 
]
ÉÉ 
[
ÑÑ "
ProducesResponseType
ÑÑ 
(
ÑÑ 
typeof
ÑÑ  
(
ÑÑ  !
TicketCommentDto
ÑÑ! 1
)
ÑÑ1 2
,
ÑÑ2 3
StatusCodes
ÑÑ4 ?
.
ÑÑ? @
Status201Created
ÑÑ@ P
)
ÑÑP Q
]
ÑÑQ R
public
ÖÖ 

async
ÖÖ 
Task
ÖÖ 
<
ÖÖ 
IActionResult
ÖÖ #
>
ÖÖ# $

AddComment
ÖÖ% /
(
ÖÖ/ 0
int
ÖÖ0 3
id
ÖÖ4 6
,
ÖÖ6 7
[
ÖÖ8 9
FromBody
ÖÖ9 A
]
ÖÖA B
CreateCommentDto
ÖÖC S
dto
ÖÖT W
)
ÖÖW X
{
ÜÜ 
var
áá 
	createDto
áá 
=
áá 
new
áá 
CreateCommentDto
áá ,
(
áá, -
dto
áá- 0
.
áá0 1
Content
áá1 8
,
áá8 9
dto
áá: =
.
áá= >

IsInternal
áá> H
,
ááH I
GetCurrentUserId
ááJ Z
(
ááZ [
)
áá[ \
)
áá\ ]
;
áá] ^
var
àà 
result
àà 
=
àà 
await
àà 
_service
àà #
.
àà# $
AddCommentAsync
àà$ 3
(
àà3 4
id
àà4 6
,
àà6 7
	createDto
àà8 A
)
ààA B
;
ààB C
return
ââ 
Ok
ââ 
(
ââ 
result
ââ 
)
ââ 
;
ââ 
}
ää 
[
åå 
HttpGet
åå 
(
åå 
$str
åå 
)
åå 
]
åå 
[
çç "
ProducesResponseType
çç 
(
çç 
typeof
çç  
(
çç  !
IEnumerable
çç! ,
<
çç, -
TicketCommentDto
çç- =
>
çç= >
)
çç> ?
,
çç? @
StatusCodes
ççA L
.
ççL M
Status200OK
ççM X
)
ççX Y
]
ççY Z
public
éé 

async
éé 
Task
éé 
<
éé 
IActionResult
éé #
>
éé# $
GetComments
éé% 0
(
éé0 1
int
éé1 4
id
éé5 7
)
éé7 8
{
èè 
bool
êê 
hasInternalPerm
êê 
=
êê 
User
êê #
.
êê# $
HasClaim
êê$ ,
(
êê, -
c
êê- .
=>
êê/ 1
c
êê2 3
.
êê3 4
Type
êê4 8
==
êê9 ;
$str
êê< H
&&
êêI K
c
êêL M
.
êêM N
Value
êêN S
==
êêT V
$str
êêW p
)
êêp q
;
êêq r
var
ëë 
result
ëë 
=
ëë 
await
ëë 
_service
ëë #
.
ëë# $
GetCommentsAsync
ëë$ 4
(
ëë4 5
id
ëë5 7
,
ëë7 8
hasInternalPerm
ëë9 H
)
ëëH I
;
ëëI J
return
íí 
Ok
íí 
(
íí 
result
íí 
)
íí 
;
íí 
}
ìì 
[
ïï 
HttpPost
ïï 
(
ïï 
$str
ïï  
)
ïï  !
]
ïï! "
[
ññ "
ProducesResponseType
ññ 
(
ññ 
typeof
ññ  
(
ññ  !!
TicketAttachmentDto
ññ! 4
)
ññ4 5
,
ññ5 6
StatusCodes
ññ7 B
.
ññB C
Status201Created
ññC S
)
ññS T
]
ññT U
[
óó "
ProducesResponseType
óó 
(
óó 
StatusCodes
óó %
.
óó% &!
Status400BadRequest
óó& 9
)
óó9 :
]
óó: ;
public
òò 

async
òò 
Task
òò 
<
òò 
IActionResult
òò #
>
òò# $
AddAttachment
òò% 2
(
òò2 3
int
òò3 6
id
òò7 9
,
òò9 :
	IFormFile
òò; D
file
òòE I
)
òòI J
{
ôô 
try
öö 
{
õõ 	
var
úú 
result
úú 
=
úú 
await
úú 
_service
úú '
.
úú' ( 
AddAttachmentAsync
úú( :
(
úú: ;
id
úú; =
,
úú= >
file
úú? C
,
úúC D
GetCurrentUserId
úúE U
(
úúU V
)
úúV W
)
úúW X
;
úúX Y
return
ùù 
Ok
ùù 
(
ùù 
result
ùù 
)
ùù 
;
ùù 
}
ûû 	
catch
üü 
(
üü '
InvalidOperationException
üü (
ex
üü) +
)
üü+ ,
{
üü- .
return
üü/ 5

BadRequest
üü6 @
(
üü@ A
new
üüA D
{
üüE F
error
üüG L
=
üüM N
ex
üüO Q
.
üüQ R
Message
üüR Y
}
üüZ [
)
üü[ \
;
üü\ ]
}
üü^ _
}
†† 
[
¢¢ 
HttpGet
¢¢ 
(
¢¢ 
$str
¢¢ 
)
¢¢  
]
¢¢  !
[
££ "
ProducesResponseType
££ 
(
££ 
typeof
££  
(
££  !
IEnumerable
££! ,
<
££, -!
TicketAttachmentDto
££- @
>
££@ A
)
££A B
,
££B C
StatusCodes
££D O
.
££O P
Status200OK
££P [
)
££[ \
]
££\ ]
public
§§ 

async
§§ 
Task
§§ 
<
§§ 
IActionResult
§§ #
>
§§# $
GetAttachments
§§% 3
(
§§3 4
int
§§4 7
id
§§8 :
)
§§: ;
{
•• 
return
¶¶ 
Ok
¶¶ 
(
¶¶ 
await
¶¶ 
_service
¶¶  
.
¶¶  !!
GetAttachmentsAsync
¶¶! 4
(
¶¶4 5
id
¶¶5 7
)
¶¶7 8
)
¶¶8 9
;
¶¶9 :
}
ßß 
[
©© 
HttpGet
©© 
(
©© 
$str
©© 
)
©© 
]
©© 
[
™™ "
ProducesResponseType
™™ 
(
™™ 
typeof
™™  
(
™™  !
IEnumerable
™™! ,
<
™™, -
TimelineEventDto
™™- =
>
™™= >
)
™™> ?
,
™™? @
StatusCodes
™™A L
.
™™L M
Status200OK
™™M X
)
™™X Y
]
™™Y Z
public
´´ 

async
´´ 
Task
´´ 
<
´´ 
IActionResult
´´ #
>
´´# $
GetTimeline
´´% 0
(
´´0 1
int
´´1 4
id
´´5 7
)
´´7 8
{
¨¨ 
bool
≠≠ 
hasInternalPerm
≠≠ 
=
≠≠ 
User
≠≠ #
.
≠≠# $
HasClaim
≠≠$ ,
(
≠≠, -
c
≠≠- .
=>
≠≠/ 1
c
≠≠2 3
.
≠≠3 4
Type
≠≠4 8
==
≠≠9 ;
$str
≠≠< H
&&
≠≠I K
c
≠≠L M
.
≠≠M N
Value
≠≠N S
==
≠≠T V
$str
≠≠W p
)
≠≠p q
;
≠≠q r
return
ÆÆ 
Ok
ÆÆ 
(
ÆÆ 
await
ÆÆ 
_service
ÆÆ  
.
ÆÆ  !
GetTimelineAsync
ÆÆ! 1
(
ÆÆ1 2
id
ÆÆ2 4
,
ÆÆ4 5
hasInternalPerm
ÆÆ6 E
)
ÆÆE F
)
ÆÆF G
;
ÆÆG H
}
ØØ 
[
±± 
HttpGet
±± 
(
±± 
$str
±± 
)
±± 
]
±± 
public
≤≤ 

async
≤≤ 
Task
≤≤ 
<
≤≤ 
IActionResult
≤≤ #
>
≤≤# $
Search
≤≤% +
(
≤≤+ ,
[
≤≤, -
	FromQuery
≤≤- 6
]
≤≤6 7#
TicketSearchFilterDto
≤≤8 M
filter
≤≤N T
)
≤≤T U
{
≥≥ 
var
¥¥ 
result
¥¥ 
=
¥¥ 
await
¥¥ 
_service
¥¥ #
.
¥¥# $ 
SearchTicketsAsync
¥¥$ 6
(
¥¥6 7
filter
¥¥7 =
,
¥¥= >
GetCurrentUserId
¥¥? O
(
¥¥O P
)
¥¥P Q
)
¥¥Q R
;
¥¥R S
return
µµ 
Ok
µµ 
(
µµ 
result
µµ 
)
µµ 
;
µµ 
}
∂∂ 
[
∏∏ 
HttpPost
∏∏ 
(
∏∏ 
$str
∏∏ 
)
∏∏ 
]
∏∏ 
[
ππ "
ProducesResponseType
ππ 
(
ππ 
typeof
ππ  
(
ππ  !
TicketSurveyDto
ππ! 0
)
ππ0 1
,
ππ1 2
StatusCodes
ππ3 >
.
ππ> ?
Status201Created
ππ? O
)
ππO P
]
ππP Q
[
∫∫ "
ProducesResponseType
∫∫ 
(
∫∫ 
StatusCodes
∫∫ %
.
∫∫% &!
Status400BadRequest
∫∫& 9
)
∫∫9 :
]
∫∫: ;
public
ªª 

async
ªª 
Task
ªª 
<
ªª 
IActionResult
ªª #
>
ªª# $
SubmitSurvey
ªª% 1
(
ªª1 2
int
ªª2 5
id
ªª6 8
,
ªª8 9
[
ªª: ;
FromBody
ªª; C
]
ªªC D#
SubmitTicketSurveyDto
ªªE Z
dto
ªª[ ^
)
ªª^ _
{
ºº 
try
ΩΩ 
{
ææ 	
var
øø 
result
øø 
=
øø 
await
øø 
_service
øø '
.
øø' (
SubmitSurveyAsync
øø( 9
(
øø9 :
id
øø: <
,
øø< =
dto
øø> A
,
øøA B
GetCurrentUserId
øøC S
(
øøS T
)
øøT U
)
øøU V
;
øøV W
return
¿¿ 
CreatedAtAction
¿¿ "
(
¿¿" #
nameof
¿¿# )
(
¿¿) *
	GetTicket
¿¿* 3
)
¿¿3 4
,
¿¿4 5
new
¿¿6 9
{
¿¿: ;
id
¿¿< >
=
¿¿? @
result
¿¿A G
.
¿¿G H
TicketId
¿¿H P
}
¿¿Q R
,
¿¿R S
result
¿¿T Z
)
¿¿Z [
;
¿¿[ \
}
¡¡ 	
catch
¬¬ 
(
¬¬ '
InvalidOperationException
¬¬ (
ex
¬¬) +
)
¬¬+ ,
{
¬¬- .
return
¬¬/ 5

BadRequest
¬¬6 @
(
¬¬@ A
new
¬¬A D
{
¬¬E F
error
¬¬G L
=
¬¬M N
ex
¬¬O Q
.
¬¬Q R
Message
¬¬R Y
}
¬¬Z [
)
¬¬[ \
;
¬¬\ ]
}
¬¬^ _
catch
√√ 
(
√√ )
UnauthorizedAccessException
√√ *
ex
√√+ -
)
√√- .
{
√√/ 0
return
√√1 7
Unauthorized
√√8 D
(
√√D E
new
√√E H
{
√√I J
error
√√K P
=
√√Q R
ex
√√S U
.
√√U V
Message
√√V ]
}
√√^ _
)
√√_ `
;
√√` a
}
√√b c
catch
ƒƒ 
(
ƒƒ "
KeyNotFoundException
ƒƒ #
)
ƒƒ# $
{
ƒƒ% &
return
ƒƒ' -
NotFound
ƒƒ. 6
(
ƒƒ6 7
)
ƒƒ7 8
;
ƒƒ8 9
}
ƒƒ: ;
}
≈≈ 
}∆∆ –5
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
[DD 
AllowAnonymousDD 
]DD 
[EE 
HttpPostEE 
(EE 
$strEE 
)EE 
]EE 
publicFF 

asyncFF 
TaskFF 
<FF 
IActionResultFF #
>FF# $
IngestEmailFF% 0
(FF0 1
[GG 	
FromServicesGG	 
]GG 
ItsToolGG 
.GG 
ApplicationGG *
.GG* +

InterfacesGG+ 5
.GG5 6"
IEmailIngestionServiceGG6 L
emailServiceGGM Y
,GGY Z
[HH 	
FromBodyHH	 
]HH 
ItsToolHH 
.HH 
ApplicationHH &
.HH& '
DTOsHH' +
.HH+ ,
EmailIngestionDtoHH, =
dtoHH> A
)HHA B
{II 
awaitJJ 
emailServiceJJ 
.JJ %
ProcessIncomingEmailAsyncJJ 4
(JJ4 5
dtoJJ5 8
)JJ8 9
;JJ9 :
returnKK 
OkKK 
(KK 
newKK 
SystemResponseKK $
(KK$ %
$strKK% 6
)KK6 7
)KK7 8
;KK8 9
}LL 
}MM ŒI
Y/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/SlaController.cs
	namespace		 	
ItsTool		
 
.		 
API		 
.		 
Controllers		 !
;		! "
[ 
ApiController 
] 
[ 
Route 
( 
$str 
) 
] 
[ 
	Authorize 

(
 
Policy 
= 
$str 2
)2 3
]3 4
public 
class 
SlaController 
: 
ControllerBase +
{ 
private 
readonly 
ISlaService  
_service! )
;) *
public 

SlaController 
( 
ISlaService $
service% ,
), -
{ 
_service 
= 
service 
; 
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
SlaPolicyDto- 9
>9 :
): ;
,; <
StatusCodes= H
.H I
Status200OKI T
)T U
]U V
public 

async 
Task 
< 
IActionResult #
># $
GetPolicies% 0
(0 1
[1 2
	FromQuery2 ;
]; <
int= @
?@ A
	projectIdB K
)K L
{ 
return 
Ok 
( 
await 
_service  
.  !
GetPoliciesAsync! 1
(1 2
	projectId2 ;
); <
)< =
;= >
} 
[ 
HttpPost 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
SlaPolicyDto! -
)- .
,. /
StatusCodes0 ;
.; <
Status201Created< L
)L M
]M N
public   

async   
Task   
<   
IActionResult   #
>  # $
CreatePolicy  % 1
(  1 2
[  2 3
FromBody  3 ;
]  ; <
CreateSlaPolicyDto  = O
dto  P S
)  S T
{!! 
var"" 
res"" 
="" 
await"" 
_service""  
.""  !
CreatePolicyAsync""! 2
(""2 3
dto""3 6
)""6 7
;""7 8
return## 
CreatedAtAction## 
(## 
nameof## %
(##% &
GetPolicies##& 1
)##1 2
,##2 3
new##4 7
{##8 9
id##: <
=##= >
res##? B
.##B C
Id##C E
}##F G
,##G H
res##I L
)##L M
;##M N
}$$ 
[&& 
HttpPut&& 
(&& 
$str&& 
)&& 
]&& 
[''  
ProducesResponseType'' 
('' 
StatusCodes'' %
.''% &
Status204NoContent''& 8
)''8 9
]''9 :
[((  
ProducesResponseType(( 
((( 
StatusCodes(( %
.((% &
Status404NotFound((& 7
)((7 8
]((8 9
public)) 

async)) 
Task)) 
<)) 
IActionResult)) #
>))# $
UpdatePolicy))% 1
())1 2
int))2 5
id))6 8
,))8 9
[)): ;
FromBody)); C
]))C D
UpdateSlaPolicyDto))E W
dto))X [
)))[ \
{** 
try++ 
{++ 
await++ 
_service++ 
.++ 
UpdatePolicyAsync++ .
(++. /
id++/ 1
,++1 2
dto++3 6
)++6 7
;++7 8
return++9 ?
	NoContent++@ I
(++I J
)++J K
;++K L
}++M N
catch,, 
(,, 
System,, 
.,, 
Collections,, !
.,,! "
Generic,," )
.,,) * 
KeyNotFoundException,,* >
),,> ?
{,,@ A
return,,B H
NotFound,,I Q
(,,Q R
),,R S
;,,S T
},,U V
}-- 
[// 

HttpDelete// 
(// 
$str// 
)//  
]//  !
[00  
ProducesResponseType00 
(00 
StatusCodes00 %
.00% &
Status204NoContent00& 8
)008 9
]009 :
public11 

async11 
Task11 
<11 
IActionResult11 #
>11# $
DeletePolicy11% 1
(111 2
int112 5
id116 8
)118 9
{22 
await33 
_service33 
.33 
DeletePolicyAsync33 (
(33( )
id33) +
)33+ ,
;33, -
return33. 4
	NoContent335 >
(33> ?
)33? @
;33@ A
}44 
[66 
HttpGet66 
(66 
$str66 $
)66$ %
]66% &
[77  
ProducesResponseType77 
(77 
typeof77  
(77  !
IEnumerable77! ,
<77, -
SlaTargetDto77- 9
>779 :
)77: ;
,77; <
StatusCodes77= H
.77H I
Status200OK77I T
)77T U
]77U V
public88 

async88 
Task88 
<88 
IActionResult88 #
>88# $

GetTargets88% /
(88/ 0
int880 3
id884 6
)886 7
{99 
return:: 
Ok:: 
(:: 
await:: 
_service::  
.::  !
GetTargetsAsync::! 0
(::0 1
id::1 3
)::3 4
)::4 5
;::5 6
};; 
[== 
HttpPost== 
(== 
$str== 
)== 
]== 
[>>  
ProducesResponseType>> 
(>> 
typeof>>  
(>>  !
SlaTargetDto>>! -
)>>- .
,>>. /
StatusCodes>>0 ;
.>>; <
Status201Created>>< L
)>>L M
]>>M N
public?? 

async?? 
Task?? 
<?? 
IActionResult?? #
>??# $
CreateTarget??% 1
(??1 2
[??2 3
FromBody??3 ;
]??; <
CreateSlaTargetDto??= O
dto??P S
)??S T
{@@ 
varAA 
resAA 
=AA 
awaitAA 
_serviceAA  
.AA  !
CreateTargetAsyncAA! 2
(AA2 3
dtoAA3 6
)AA6 7
;AA7 8
returnBB 
CreatedAtActionBB 
(BB 
nameofBB %
(BB% &
GetPoliciesBB& 1
)BB1 2
,BB2 3
newBB4 7
{BB8 9
idBB: <
=BB= >
resBB? B
.BBB C
IdBBC E
}BBF G
,BBG H
resBBI L
)BBL M
;BBM N
}CC 
[EE 
HttpPutEE 
(EE 
$strEE 
)EE 
]EE 
[FF  
ProducesResponseTypeFF 
(FF 
StatusCodesFF %
.FF% &
Status204NoContentFF& 8
)FF8 9
]FF9 :
[GG  
ProducesResponseTypeGG 
(GG 
StatusCodesGG %
.GG% &
Status404NotFoundGG& 7
)GG7 8
]GG8 9
publicHH 

asyncHH 
TaskHH 
<HH 
IActionResultHH #
>HH# $
UpdateTargetHH% 1
(HH1 2
intHH2 5
idHH6 8
,HH8 9
[HH: ;
FromBodyHH; C
]HHC D
UpdateSlaTargetDtoHHE W
dtoHHX [
)HH[ \
{II 
tryJJ 
{JJ 
awaitJJ 
_serviceJJ 
.JJ 
UpdateTargetAsyncJJ .
(JJ. /
idJJ/ 1
,JJ1 2
dtoJJ3 6
)JJ6 7
;JJ7 8
returnJJ9 ?
	NoContentJJ@ I
(JJI J
)JJJ K
;JJK L
}JJM N
catchKK 
(KK 
SystemKK 
.KK 
CollectionsKK !
.KK! "
GenericKK" )
.KK) * 
KeyNotFoundExceptionKK* >
)KK> ?
{KK@ A
returnKKB H
NotFoundKKI Q
(KKQ R
)KKR S
;KKS T
}KKU V
}LL 
[NN 

HttpDeleteNN 
(NN 
$strNN 
)NN 
]NN  
[OO  
ProducesResponseTypeOO 
(OO 
StatusCodesOO %
.OO% &
Status204NoContentOO& 8
)OO8 9
]OO9 :
publicPP 

asyncPP 
TaskPP 
<PP 
IActionResultPP #
>PP# $
DeleteTargetPP% 1
(PP1 2
intPP2 5
idPP6 8
)PP8 9
{QQ 
awaitRR 
_serviceRR 
.RR 
DeleteTargetAsyncRR (
(RR( )
idRR) +
)RR+ ,
;RR, -
returnRR. 4
	NoContentRR5 >
(RR> ?
)RR? @
;RR@ A
}SS 
}TT ç5
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/SavedFilterController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[ 
Route 
( 
$str 
) 
] 
[ 
	Authorize 

]
 
public 
class !
SavedFilterController "
:# $
ControllerBase% 3
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 
!
SavedFilterController  
(  !
ItsToolDbContext! 1
context2 9
)9 :
{ 
_context 
= 
context 
; 
} 
private 
int 
GetCurrentUserId  
(  !
)! "
{ 
var 
idClaim 
= 
User 
. 
	FindFirst $
($ %

ClaimTypes% /
./ 0
NameIdentifier0 >
)> ?
?? @
.@ A
ValueA F
;F G
return 
int 
. 
Parse 
( 
idClaim  
??! #
$str$ '
)' (
;( )
} 
[   
HttpGet   
]   
[!!  
ProducesResponseType!! 
(!! 
typeof!!  
(!!  !
IEnumerable!!! ,
<!!, -
SavedFilterDto!!- ;
>!!; <
)!!< =
,!!= >
$num!!? B
)!!B C
]!!C D
public"" 

async"" 
Task"" 
<"" 
IActionResult"" #
>""# $
GetMyFilters""% 1
(""1 2
)""2 3
{## 
var$$ 
userId$$ 
=$$ 
GetCurrentUserId$$ %
($$% &
)$$& '
;$$' (
var%% 
filters%% 
=%% 
await%% 
_context%% $
.%%$ %
SavedFilters%%% 1
.&& 
Where&& 
(&& 
f&& 
=>&& 
f&& 
.&& 
UserId&&  
==&&! #
userId&&$ *
&&&&+ -
!&&. /
f&&/ 0
.&&0 1
	IsDeleted&&1 :
)&&: ;
.'' 
ToListAsync'' 
('' 
)'' 
;'' 
return)) 
Ok)) 
()) 
filters)) 
.)) 
Select))  
())  !
f))! "
=>))# %
new))& )
SavedFilterDto))* 8
())8 9
f))9 :
.)): ;
Id)); =
,))= >
f))? @
.))@ A
UserId))A G
,))G H
f))I J
.))J K
Name))K O
,))O P
f))Q R
.))R S
	QueryJson))S \
)))\ ]
)))] ^
)))^ _
;))_ `
}** 
[,, 
HttpPost,, 
],, 
[--  
ProducesResponseType-- 
(-- 
typeof--  
(--  !
SavedFilterDto--! /
)--/ 0
,--0 1
$num--2 5
)--5 6
]--6 7
public.. 

async.. 
Task.. 
<.. 
IActionResult.. #
>..# $
CreateFilter..% 1
(..1 2
[..2 3
FromBody..3 ;
]..; < 
CreateSavedFilterDto..= Q
dto..R U
)..U V
{// 
var00 
userId00 
=00 
GetCurrentUserId00 %
(00% &
)00& '
;00' (
var11 
filter11 
=11 
new11 
SavedFilter11 $
{22 	
UserId33 
=33 
userId33 
,33 
Name44 
=44 
dto44 
.44 
Name44 
,44 
	QueryJson55 
=55 
dto55 
.55 
	QueryJson55 %
}66 	
;66	 

_context88 
.88 
SavedFilters88 
.88 
Add88 !
(88! "
filter88" (
)88( )
;88) *
await99 
_context99 
.99 
SaveChangesAsync99 '
(99' (
)99( )
;99) *
return;; 
CreatedAtAction;; 
(;; 
nameof;; %
(;;% &
GetMyFilters;;& 2
);;2 3
,;;3 4
new;;5 8
{;;9 :
id;;; =
=;;> ?
filter;;@ F
.;;F G
Id;;G I
};;J K
,;;K L
new;;M P
SavedFilterDto;;Q _
(;;_ `
filter;;` f
.;;f g
Id;;g i
,;;i j
filter;;k q
.;;q r
UserId;;r x
,;;x y
filter	;;z Ä
.
;;Ä Å
Name
;;Å Ö
,
;;Ö Ü
filter
;;á ç
.
;;ç é
	QueryJson
;;é ó
)
;;ó ò
)
;;ò ô
;
;;ô ö
}<< 
[>> 

HttpDelete>> 
(>> 
$str>> 
)>> 
]>> 
[??  
ProducesResponseType?? 
(?? 
$num?? 
)?? 
]?? 
public@@ 

async@@ 
Task@@ 
<@@ 
IActionResult@@ #
>@@# $
DeleteFilter@@% 1
(@@1 2
int@@2 5
id@@6 8
)@@8 9
{AA 
varBB 
userIdBB 
=BB 
GetCurrentUserIdBB %
(BB% &
)BB& '
;BB' (
varCC 
filterCC 
=CC 
awaitCC 
_contextCC #
.CC# $
SavedFiltersCC$ 0
.CC0 1
FirstOrDefaultAsyncCC1 D
(CCD E
fCCE F
=>CCG I
fCCJ K
.CCK L
IdCCL N
==CCO Q
idCCR T
&&CCU W
fCCX Y
.CCY Z
UserIdCCZ `
==CCa c
userIdCCd j
&&CCk m
!CCn o
fCCo p
.CCp q
	IsDeletedCCq z
)CCz {
;CC{ |
ifEE 

(EE 
filterEE 
==EE 
nullEE 
)EE 
returnEE "
NotFoundEE# +
(EE+ ,
)EE, -
;EE- .
filterGG 
.GG 
	IsDeletedGG 
=GG 
trueGG 
;GG  
awaitHH 
_contextHH 
.HH 
SaveChangesAsyncHH '
(HH' (
)HH( )
;HH) *
returnJJ 
	NoContentJJ 
(JJ 
)JJ 
;JJ 
}KK 
}LL ·?
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
}\\ ﬂ
]/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/ReportsController.cs
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
 
)

 
]

 
[ 
	Authorize 

]
 
public 
class 
ReportsController 
:  
ControllerBase! /
{ 
private 
readonly 
IReportService #
_reportService$ 2
;2 3
public 

ReportsController 
( 
IReportService +
reportService, 9
)9 :
{ 
_reportService 
= 
reportService &
;& '
} 
private 
int 
GetCurrentUserId  
(  !
)! "
=># %
int& )
.) *
Parse* /
(/ 0
User0 4
.4 5
	FindFirst5 >
(> ?
$str? G
)G H
?H I
.I J
ValueJ O
??P R
$strS V
)V W
;W X
[ 
HttpGet 
( 
$str 
) 
] 
public 

async 
Task 
< 
IActionResult #
># $
ExportTicketsCsv% 5
(5 6
[6 7
	FromQuery7 @
]@ A!
TicketSearchFilterDtoB W
filterX ^
)^ _
{ 
var 
stream 
= 
await 
_reportService )
.) *#
ExportTicketsToCsvAsync* A
(A B
filterB H
,H I
GetCurrentUserIdJ Z
(Z [
)[ \
)\ ]
;] ^
return 
File 
( 
stream 
, 
$str &
,& '
$"( *
$str* 9
{9 :
System: @
.@ A
DateTimeA I
.I J
UtcNowJ P
:P Q
$strQ `
}` a
$stra e
"e f
)f g
;g h
} 
} —?
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
}\\ É
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/PermissionsController.cs
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
]


 
public 
class !
PermissionsController "
:# $
ControllerBase% 3
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 
!
PermissionsController  
(  !
ItsToolDbContext! 1
context2 9
)9 :
{ 
_context 
= 
context 
; 
} 
[ 
HttpGet 
] 
public 

async 
Task 
< 
IActionResult #
># $
GetAll% +
(+ ,
), -
{ 
var 
perms 
= 
await 
_context "
." #
Permissions# .
.. /
Select/ 5
(5 6
p6 7
=>8 :
new; >
{? @
pA B
.B C
IdC E
,E F
pG H
.H I
KeyI L
,L M
pN O
.O P
NameP T
}U V
)V W
.W X
ToListAsyncX c
(c d
)d e
;e f
return 
Ok 
( 
perms 
) 
; 
} 
} ñ!
c/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/NotificationsController.cs
	namespace

 	
ItsTool


 
.

 
API

 
.

 
Controllers

 !
;

! "
[ 
ApiController 
] 
[ 
Route 
( 
$str 
) 
] 
[ 
	Authorize 

]
 
public 
class #
NotificationsController $
:% &
ControllerBase' 5
{ 
private 
readonly  
INotificationService )
_service* 2
;2 3
public 
#
NotificationsController "
(" # 
INotificationService# 7
service8 ?
)? @
{ 
_service 
= 
service 
; 
} 
private 
int 
GetCurrentUserId  
(  !
)! "
{ 
var 
idClaim 
= 
User 
. 
	FindFirst $
($ %

ClaimTypes% /
./ 0
NameIdentifier0 >
)> ?
?? @
.@ A
ValueA F
;F G
return 
int 
. 
TryParse 
( 
idClaim #
,# $
out% (
var) ,
id- /
)/ 0
?1 2
id3 5
:6 7
$num8 9
;9 :
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
NotificationDto- <
>< =
)= >
,> ?
StatusCodes@ K
.K L
Status200OKL W
)W X
]X Y
public   

async   
Task   
<   
IActionResult   #
>  # $
GetMyNotifications  % 7
(  7 8
)  8 9
{!! 
var"" 
userId"" 
="" 
GetCurrentUserId"" %
(""% &
)""& '
;""' (
return## 
Ok## 
(## 
await## 
_service##  
.##  !%
GetUserNotificationsAsync##! :
(##: ;
userId##; A
)##A B
)##B C
;##C D
}$$ 
[&& 
HttpPost&& 
(&& 
$str&& 
)&& 
]&& 
[''  
ProducesResponseType'' 
('' 
StatusCodes'' %
.''% &
Status204NoContent''& 8
)''8 9
]''9 :
public(( 

async(( 
Task(( 
<(( 
IActionResult(( #
>((# $

MarkAsRead((% /
(((/ 0
int((0 3
id((4 6
)((6 7
{)) 
var** 
userId** 
=** 
GetCurrentUserId** %
(**% &
)**& '
;**' (
await++ 
_service++ 
.++ 
MarkAsReadAsync++ &
(++& '
id++' )
,++) *
userId+++ 1
)++1 2
;++2 3
return,, 
	NoContent,, 
(,, 
),, 
;,, 
}-- 
[// 
HttpPost// 
(// 
$str// 
)// 
]// 
[00  
ProducesResponseType00 
(00 
StatusCodes00 %
.00% &
Status204NoContent00& 8
)008 9
]009 :
public11 

async11 
Task11 
<11 
IActionResult11 #
>11# $
MarkAllAsRead11% 2
(112 3
)113 4
{22 
var33 
userId33 
=33 
GetCurrentUserId33 %
(33% &
)33& '
;33' (
await44 
_service44 
.44 
MarkAllAsReadAsync44 )
(44) *
userId44* 0
)440 1
;441 2
return55 
	NoContent55 
(55 
)55 
;55 
}66 
}77 ∫
\/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/LookupController.cs
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
$str 
) 
] 
[		 
	Authorize		 

]		
 
public

 
class

 
LookupController

 
:

 
ControllerBase

  .
{ 
private 
readonly 
ICatalogService $
_catalogService% 4
;4 5
private 
readonly 
IProjectService $
_projectService% 4
;4 5
public 

LookupController 
( 
ICatalogService +
catalogService, :
,: ;
IProjectService< K
projectServiceL Z
)Z [
{ 
_catalogService 
= 
catalogService (
;( )
_projectService 
= 
projectService (
;( )
} 
[ 
HttpGet 
] 
public 

async 
Task 
< 
IActionResult #
># $

GetLookups% /
(/ 0
)0 1
{ 
var 
projects 
= 
await 
_projectService ,
., -
GetAllAsync- 8
(8 9
)9 :
;: ;
var 

categories 
= 
await 
_catalogService .
.. /
GetCategoriesAsync/ A
(A B
nullB F
)F G
;G H
var 
ticketTypes 
= 
await 
_catalogService  /
./ 0
GetTicketTypesAsync0 C
(C D
)D E
;E F
var 

priorities 
= 
await 
_catalogService .
.. /
GetPrioritiesAsync/ A
(A B
)B C
;C D
var 
statuses 
= 
await 
_catalogService ,
., -
GetStatusesAsync- =
(= >
)> ?
;? @
return 
Ok 
( 
new 
{ 	
projects   
,   

categories!! 
,!! 
ticketTypes"" 
,"" 

priorities## 
,## 
statuses$$ 
}%% 	
)%%	 

;%%
 
}&& 
}'' îB
c/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/KnowledgeBaseController.cs
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
 
)

 
]

 
[ 
	Authorize 

]
 
public 
class #
KnowledgeBaseController $
:% &
ControllerBase' 5
{ 
private 
readonly !
IKnowledgeBaseService *

_kbService+ 5
;5 6
public 
#
KnowledgeBaseController "
(" #!
IKnowledgeBaseService# 8
	kbService9 B
)B C
{ 

_kbService 
= 
	kbService 
; 
} 
private 
int 
GetCurrentUserId  
(  !
)! "
=># %
int& )
.) *
Parse* /
(/ 0
User0 4
.4 5
	FindFirst5 >
(> ?
$str? G
)G H
?H I
.I J
ValueJ O
??P R
$strS V
)V W
;W X
[ 
HttpGet 
( 
$str 
) 
] 
public 

async 
Task 
< 
IActionResult #
># $
GetCategories% 2
(2 3
)3 4
{ 
var 
result 
= 
await 

_kbService %
.% &
GetCategoriesAsync& 8
(8 9
)9 :
;: ;
return 
Ok 
( 
result 
) 
; 
} 
[ 
HttpPost 
( 
$str 
) 
] 
[ 
	Authorize 
( 
Policy 
= 
$str )
)) *
]* +
public   

async   
Task   
<   
IActionResult   #
>  # $
CreateCategory  % 3
(  3 4
CreateKbCategoryDto  4 G
dto  H K
)  K L
{!! 
var"" 
result"" 
="" 
await"" 

_kbService"" %
.""% &
CreateCategoryAsync""& 9
(""9 :
dto"": =
)""= >
;""> ?
return## 
Ok## 
(## 
result## 
)## 
;## 
}$$ 
[&& 
HttpPut&& 
(&& 
$str&& 
)&& 
]&&  
['' 
	Authorize'' 
('' 
Policy'' 
='' 
$str'' )
)'') *
]''* +
public(( 

async(( 
Task(( 
<(( 
IActionResult(( #
>((# $
UpdateCategory((% 3
(((3 4
int((4 7
id((8 :
,((: ;
CreateKbCategoryDto((< O
dto((P S
)((S T
{)) 
await** 

_kbService** 
.** 
UpdateCategoryAsync** ,
(**, -
id**- /
,**/ 0
dto**1 4
)**4 5
;**5 6
return++ 
	NoContent++ 
(++ 
)++ 
;++ 
},, 
[.. 

HttpDelete.. 
(.. 
$str.. !
)..! "
].." #
[// 
	Authorize// 
(// 
Policy// 
=// 
$str// )
)//) *
]//* +
public00 

async00 
Task00 
<00 
IActionResult00 #
>00# $
DeleteCategory00% 3
(003 4
int004 7
id008 :
)00: ;
{11 
await22 

_kbService22 
.22 
DeleteCategoryAsync22 ,
(22, -
id22- /
)22/ 0
;220 1
return33 
	NoContent33 
(33 
)33 
;33 
}44 
[66 
HttpGet66 
(66 
$str66 
)66 
]66 
public77 

async77 
Task77 
<77 
IActionResult77 #
>77# $
SearchArticles77% 3
(773 4
[774 5
	FromQuery775 >
]77> ?
string77@ F
?77F G
search77H N
,77N O
[77P Q
	FromQuery77Q Z
]77Z [
int77\ _
?77_ `
category77a i
)77i j
{88 
var99 
result99 
=99 
await99 

_kbService99 %
.99% &
SearchArticlesAsync99& 9
(999 :
GetCurrentUserId99: J
(99J K
)99K L
,99L M
search99N T
,99T U
category99V ^
)99^ _
;99_ `
return:: 
Ok:: 
(:: 
result:: 
):: 
;:: 
};; 
[== 
HttpGet== 
(== 
$str== 
)== 
]== 
public>> 

async>> 
Task>> 
<>> 
IActionResult>> #
>>># $

GetArticle>>% /
(>>/ 0
int>>0 3
id>>4 6
)>>6 7
{?? 
var@@ 
result@@ 
=@@ 
await@@ 

_kbService@@ %
.@@% &
GetArticleAsync@@& 5
(@@5 6
id@@6 8
,@@8 9
GetCurrentUserId@@: J
(@@J K
)@@K L
)@@L M
;@@M N
ifAA 

(AA 
resultAA 
==AA 
nullAA 
)AA 
returnAA "
NotFoundAA# +
(AA+ ,
)AA, -
;AA- .
returnBB 
OkBB 
(BB 
resultBB 
)BB 
;BB 
}CC 
[EE 
HttpPostEE 
(EE 
$strEE 
)EE 
]EE 
[FF 
	AuthorizeFF 
(FF 
PolicyFF 
=FF 
$strFF )
)FF) *
]FF* +
publicGG 

asyncGG 
TaskGG 
<GG 
IActionResultGG #
>GG# $
CreateArticleGG% 2
(GG2 3
CreateKbArticleDtoGG3 E
dtoGGF I
)GGI J
{HH 
varII 
resultII 
=II 
awaitII 

_kbServiceII %
.II% &
CreateArticleAsyncII& 8
(II8 9
dtoII9 <
,II< =
GetCurrentUserIdII> N
(IIN O
)IIO P
)IIP Q
;IIQ R
returnJJ 
OkJJ 
(JJ 
resultJJ 
)JJ 
;JJ 
}KK 
[MM 
HttpPutMM 
(MM 
$strMM 
)MM 
]MM 
[NN 
	AuthorizeNN 
(NN 
PolicyNN 
=NN 
$strNN )
)NN) *
]NN* +
publicOO 

asyncOO 
TaskOO 
<OO 
IActionResultOO #
>OO# $
UpdateArticleOO% 2
(OO2 3
intOO3 6
idOO7 9
,OO9 :
UpdateKbArticleDtoOO; M
dtoOON Q
)OOQ R
{PP 
awaitQQ 

_kbServiceQQ 
.QQ 
UpdateArticleAsyncQQ +
(QQ+ ,
idQQ, .
,QQ. /
dtoQQ0 3
)QQ3 4
;QQ4 5
returnRR 
	NoContentRR 
(RR 
)RR 
;RR 
}SS 
[UU 

HttpDeleteUU 
(UU 
$strUU 
)UU  
]UU  !
[VV 
	AuthorizeVV 
(VV 
PolicyVV 
=VV 
$strVV )
)VV) *
]VV* +
publicWW 

asyncWW 
TaskWW 
<WW 
IActionResultWW #
>WW# $
DeleteArticleWW% 2
(WW2 3
intWW3 6
idWW7 9
)WW9 :
{XX 
awaitYY 

_kbServiceYY 
.YY 
DeleteArticleAsyncYY +
(YY+ ,
idYY, .
)YY. /
;YY/ 0
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
}\\ ∆Ö
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
]


 
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
[ 
	Authorize 
( 
Policy 
= 
$str 9
)9 :
]: ;
[  
ProducesResponseType 
( 
typeof  
(  !
FieldDefinitionDto! 3
)3 4
,4 5
StatusCodes6 A
.A B
Status201CreatedB R
)R S
]S T
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status400BadRequest& 9
)9 :
]: ;
public 

async 
Task 
< 
IActionResult #
># $
CreateDefinition% 5
(5 6
[6 7
FromBody7 ?
]? @$
CreateFieldDefinitionDtoA Y
dtoZ ]
)] ^
{ 
try 
{ 
var 
result 
= 
await  
_service! )
.) *&
CreateFieldDefinitionAsync* D
(D E
dtoE H
)H I
;I J
returnK Q
CreatedAtActionR a
(a b
nameofb h
(h i
GetDefinitionsi w
)w x
,x y
newz }
{~ 
id
Ä Ç
=
É Ñ
result
Ö ã
.
ã å
Id
å é
}
è ê
,
ê ë
result
í ò
)
ò ô
;
ô ö
}
õ ú
catch 
( %
InvalidOperationException (
ex) +
)+ ,
{- .
return/ 5

BadRequest6 @
(@ A
newA D
{E F
errorG L
=M N
exO Q
.Q R
MessageR Y
}Z [
)[ \
;\ ]
}^ _
}   
["" 
HttpPut"" 
("" 
$str"" 
)""  
]""  !
[## 
	Authorize## 
(## 
Policy## 
=## 
$str## 9
)##9 :
]##: ;
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
Status400BadRequest%%& 9
)%%9 :
]%%: ;
[&&  
ProducesResponseType&& 
(&& 
StatusCodes&& %
.&&% &
Status404NotFound&&& 7
)&&7 8
]&&8 9
public'' 

async'' 
Task'' 
<'' 
IActionResult'' #
>''# $
UpdateDefinition''% 5
(''5 6
int''6 9
id'': <
,''< =
[''> ?
FromBody''? G
]''G H$
UpdateFieldDefinitionDto''I a
dto''b e
)''e f
{(( 
try)) 
{)) 
await)) 
_service)) 
.)) &
UpdateFieldDefinitionAsync)) 7
())7 8
id))8 :
,)): ;
dto))< ?
)))? @
;))@ A
return))B H
	NoContent))I R
())R S
)))S T
;))T U
}))V W
catch** 
(**  
KeyNotFoundException** #
)**# $
{**% &
return**' -
NotFound**. 6
(**6 7
)**7 8
;**8 9
}**: ;
catch++ 
(++ %
InvalidOperationException++ (
ex++) +
)+++ ,
{++- .
return++/ 5

BadRequest++6 @
(++@ A
new++A D
{++E F
error++G L
=++M N
ex++O Q
.++Q R
Message++R Y
}++Z [
)++[ \
;++\ ]
}++^ _
},, 
[.. 

HttpDelete.. 
(.. 
$str.. "
).." #
]..# $
[// 
	Authorize// 
(// 
Policy// 
=// 
$str// 9
)//9 :
]//: ;
[00  
ProducesResponseType00 
(00 
StatusCodes00 %
.00% &
Status204NoContent00& 8
)008 9
]009 :
public11 

async11 
Task11 
<11 
IActionResult11 #
>11# $
DeleteDefinition11% 5
(115 6
int116 9
id11: <
)11< =
{22 
await33 
_service33 
.33 &
DeleteFieldDefinitionAsync33 1
(331 2
id332 4
)334 5
;335 6
return337 =
	NoContent33> G
(33G H
)33H I
;33I J
}44 
[66 
HttpGet66 
(66 
$str66 '
)66' (
]66( )
[77  
ProducesResponseType77 
(77 
typeof77  
(77  !
IEnumerable77! ,
<77, -
FieldOptionDto77- ;
>77; <
)77< =
,77= >
StatusCodes77? J
.77J K
Status200OK77K V
)77V W
]77W X
public88 

async88 
Task88 
<88 
IActionResult88 #
>88# $

GetOptions88% /
(88/ 0
int880 3
id884 6
)886 7
=>888 :
Ok88; =
(88= >
await88> C
_service88D L
.88L M 
GetFieldOptionsAsync88M a
(88a b
id88b d
)88d e
)88e f
;88f g
[:: 
HttpPost:: 
(:: 
$str:: 
):: 
]:: 
[;; 
	Authorize;; 
(;; 
Policy;; 
=;; 
$str;; 9
);;9 :
];;: ;
[<<  
ProducesResponseType<< 
(<< 
typeof<<  
(<<  !
FieldOptionDto<<! /
)<</ 0
,<<0 1
StatusCodes<<2 =
.<<= >
Status201Created<<> N
)<<N O
]<<O P
public== 

async== 
Task== 
<== 
IActionResult== #
>==# $
CreateOption==% 1
(==1 2
[==2 3
FromBody==3 ;
]==; < 
CreateFieldOptionDto=== Q
dto==R U
)==U V
{>> 
var?? 
result?? 
=?? 
await?? 
_service?? #
.??# $"
CreateFieldOptionAsync??$ :
(??: ;
dto??; >
)??> ?
;??? @
return@@ 
CreatedAtAction@@ 
(@@ 
nameof@@ %
(@@% &
GetDefinitions@@& 4
)@@4 5
,@@5 6
new@@7 :
{@@; <
id@@= ?
=@@@ A
result@@B H
.@@H I
Id@@I K
}@@L M
,@@M N
result@@O U
)@@U V
;@@V W
}AA 
[CC 
HttpPutCC 
(CC 
$strCC 
)CC 
]CC 
[DD 
	AuthorizeDD 
(DD 
PolicyDD 
=DD 
$strDD 9
)DD9 :
]DD: ;
[EE  
ProducesResponseTypeEE 
(EE 
StatusCodesEE %
.EE% &
Status204NoContentEE& 8
)EE8 9
]EE9 :
[FF  
ProducesResponseTypeFF 
(FF 
StatusCodesFF %
.FF% &
Status404NotFoundFF& 7
)FF7 8
]FF8 9
publicGG 

asyncGG 
TaskGG 
<GG 
IActionResultGG #
>GG# $
UpdateOptionGG% 1
(GG1 2
intGG2 5
idGG6 8
,GG8 9
[GG: ;
FromBodyGG; C
]GGC D 
UpdateFieldOptionDtoGGE Y
dtoGGZ ]
)GG] ^
{HH 
tryII 
{II 
awaitII 
_serviceII 
.II "
UpdateFieldOptionAsyncII 3
(II3 4
idII4 6
,II6 7
dtoII8 ;
)II; <
;II< =
returnII> D
	NoContentIIE N
(IIN O
)IIO P
;IIP Q
}IIR S
catchJJ 
(JJ  
KeyNotFoundExceptionJJ #
)JJ# $
{JJ% &
returnJJ' -
NotFoundJJ. 6
(JJ6 7
)JJ7 8
;JJ8 9
}JJ: ;
}KK 
[MM 

HttpDeleteMM 
(MM 
$strMM 
)MM 
]MM  
[NN 
	AuthorizeNN 
(NN 
PolicyNN 
=NN 
$strNN 9
)NN9 :
]NN: ;
[OO  
ProducesResponseTypeOO 
(OO 
StatusCodesOO %
.OO% &
Status204NoContentOO& 8
)OO8 9
]OO9 :
publicPP 

asyncPP 
TaskPP 
<PP 
IActionResultPP #
>PP# $
DeleteOptionPP% 1
(PP1 2
intPP2 5
idPP6 8
)PP8 9
{QQ 
awaitRR 
_serviceRR 
.RR "
DeleteFieldOptionAsyncRR -
(RR- .
idRR. 0
)RR0 1
;RR1 2
returnRR3 9
	NoContentRR: C
(RRC D
)RRD E
;RRE F
}SS 
[UU 
HttpGetUU 
(UU 
$strUU 
)UU 
]UU 
[VV  
ProducesResponseTypeVV 
(VV 
typeofVV  
(VV  !
IEnumerableVV! ,
<VV, -!
FormFieldPlacementDtoVV- B
>VVB C
)VVC D
,VVD E
StatusCodesVVF Q
.VVQ R
Status200OKVVR ]
)VV] ^
]VV^ _
publicWW 

asyncWW 
TaskWW 
<WW 
IActionResultWW #
>WW# $
GetPlacementsWW% 2
(WW2 3
[WW3 4
	FromQueryWW4 =
]WW= >
intWW? B
?WWB C
	projectIdWWD M
,WWM N
[WWO P
	FromQueryWWP Y
]WWY Z
intWW[ ^
?WW^ _

categoryIdWW` j
,WWj k
[WWl m
	FromQueryWWm v
]WWv w
intWWx {
?WW{ |
ticketTypeId	WW} â
)
WWâ ä
{XX 
returnYY 
OkYY 
(YY 
awaitYY 
_serviceYY  
.YY  !
GetPlacementsAsyncYY! 3
(YY3 4
	projectIdYY4 =
,YY= >

categoryIdYY? I
,YYI J
ticketTypeIdYYK W
)YYW X
)YYX Y
;YYY Z
}ZZ 
[\\ 
HttpPost\\ 
(\\ 
$str\\ 
)\\ 
]\\ 
[]] 
	Authorize]] 
(]] 
Policy]] 
=]] 
$str]] 9
)]]9 :
]]]: ;
[^^  
ProducesResponseType^^ 
(^^ 
typeof^^  
(^^  !!
FormFieldPlacementDto^^! 6
)^^6 7
,^^7 8
StatusCodes^^9 D
.^^D E
Status201Created^^E U
)^^U V
]^^V W
[__  
ProducesResponseType__ 
(__ 
StatusCodes__ %
.__% &
Status400BadRequest__& 9
)__9 :
]__: ;
public`` 

async`` 
Task`` 
<`` 
IActionResult`` #
>``# $
CreatePlacement``% 4
(``4 5
[``5 6
FromBody``6 >
]``> ?'
CreateFormFieldPlacementDto``@ [
dto``\ _
)``_ `
{aa 
trybb 
{bb 
varbb 
resultbb 
=bb 
awaitbb  
_servicebb! )
.bb) * 
CreatePlacementAsyncbb* >
(bb> ?
dtobb? B
)bbB C
;bbC D
returnbbE K
CreatedAtActionbbL [
(bb[ \
nameofbb\ b
(bbb c
GetDefinitionsbbc q
)bbq r
,bbr s
newbbt w
{bbx y
idbbz |
=bb} ~
result	bb Ö
.
bbÖ Ü
Id
bbÜ à
}
bbâ ä
,
bbä ã
result
bbå í
)
bbí ì
;
bbì î
}
bbï ñ
catchcc 
(cc %
InvalidOperationExceptioncc (
excc) +
)cc+ ,
{cc- .
returncc/ 5

BadRequestcc6 @
(cc@ A
newccA D
{ccE F
errorccG L
=ccM N
exccO Q
.ccQ R
MessageccR Y
}ccZ [
)cc[ \
;cc\ ]
}cc^ _
}dd 
[ff 
HttpPutff 
(ff 
$strff 
)ff 
]ff  
[gg 
	Authorizegg 
(gg 
Policygg 
=gg 
$strgg 9
)gg9 :
]gg: ;
[hh  
ProducesResponseTypehh 
(hh 
StatusCodeshh %
.hh% &
Status204NoContenthh& 8
)hh8 9
]hh9 :
[ii  
ProducesResponseTypeii 
(ii 
StatusCodesii %
.ii% &
Status400BadRequestii& 9
)ii9 :
]ii: ;
[jj  
ProducesResponseTypejj 
(jj 
StatusCodesjj %
.jj% &
Status404NotFoundjj& 7
)jj7 8
]jj8 9
publickk 

asynckk 
Taskkk 
<kk 
IActionResultkk #
>kk# $
UpdatePlacementkk% 4
(kk4 5
intkk5 8
idkk9 ;
,kk; <
[kk= >
FromBodykk> F
]kkF G'
UpdateFormFieldPlacementDtokkH c
dtokkd g
)kkg h
{ll 
trymm 
{mm 
awaitmm 
_servicemm 
.mm  
UpdatePlacementAsyncmm 1
(mm1 2
idmm2 4
,mm4 5
dtomm6 9
)mm9 :
;mm: ;
returnmm< B
	NoContentmmC L
(mmL M
)mmM N
;mmN O
}mmP Q
catchnn 
(nn  
KeyNotFoundExceptionnn #
)nn# $
{nn% &
returnnn' -
NotFoundnn. 6
(nn6 7
)nn7 8
;nn8 9
}nn: ;
catchoo 
(oo %
InvalidOperationExceptionoo (
exoo) +
)oo+ ,
{oo- .
returnoo/ 5

BadRequestoo6 @
(oo@ A
newooA D
{ooE F
errorooG L
=ooM N
exooO Q
.ooQ R
MessageooR Y
}ooZ [
)oo[ \
;oo\ ]
}oo^ _
}pp 
[rr 

HttpDeleterr 
(rr 
$strrr !
)rr! "
]rr" #
[ss 
	Authorizess 
(ss 
Policyss 
=ss 
$strss 9
)ss9 :
]ss: ;
[tt  
ProducesResponseTypett 
(tt 
StatusCodestt %
.tt% &
Status204NoContenttt& 8
)tt8 9
]tt9 :
publicuu 

asyncuu 
Taskuu 
<uu 
IActionResultuu #
>uu# $
DeletePlacementuu% 4
(uu4 5
intuu5 8
iduu9 ;
)uu; <
{vv 
awaitww 
_serviceww 
.ww  
DeletePlacementAsyncww +
(ww+ ,
idww, .
)ww. /
;ww/ 0
returnww1 7
	NoContentww8 A
(wwA B
)wwB C
;wwC D
}xx 
}yy á3
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
}LL  %
_/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/DashboardController.cs
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
]


 
public 
class 
DashboardController  
:! "
ControllerBase# 1
{ 
private 
readonly 
IDashboardService &
_dashboardService' 8
;8 9
public 

DashboardController 
( 
IDashboardService 0
dashboardService1 A
)A B
{ 
_dashboardService 
= 
dashboardService ,
;, -
} 
private 
int 
GetCurrentUserId  
(  !
)! "
=># %
int& )
.) *
Parse* /
(/ 0
User0 4
.4 5
	FindFirst5 >
(> ?
System? E
.E F
SecurityF N
.N O
ClaimsO U
.U V

ClaimTypesV `
.` a
NameIdentifiera o
)o p
?p q
.q r
Valuer w
??x z
$str{ ~
)~ 
;	 Ä
[ 
HttpGet 
( 
$str 
) 
] 
public 

async 
Task 
< 
IActionResult #
># $
GetOverview% 0
(0 1
)1 2
{ 
var 
result 
= 
await 
_dashboardService ,
., -
GetOverviewAsync- =
(= >
GetCurrentUserId> N
(N O
)O P
)P Q
;Q R
return 
Ok 
( 
result 
) 
; 
} 
[ 
HttpGet 
( 
$str 
) 
] 
public 

async 
Task 
< 
IActionResult #
># $
GetDistributions% 5
(5 6
)6 7
{ 
var   
result   
=   
await   
_dashboardService   ,
.  , -!
GetDistributionsAsync  - B
(  B C
GetCurrentUserId  C S
(  S T
)  T U
)  U V
;  V W
return!! 
Ok!! 
(!! 
result!! 
)!! 
;!! 
}"" 
[$$ 
HttpGet$$ 
($$ 
$str$$ "
)$$" #
]$$# $
public%% 

async%% 
Task%% 
<%% 
IActionResult%% #
>%%# $!
GetDepartmentWorkload%%% :
(%%: ;
)%%; <
{&& 
var'' 
result'' 
='' 
await'' 
_dashboardService'' ,
.'', -&
GetDepartmentWorkloadAsync''- G
(''G H
GetCurrentUserId''H X
(''X Y
)''Y Z
)''Z [
;''[ \
return(( 
Ok(( 
((( 
result(( 
)(( 
;(( 
})) 
[++ 
HttpGet++ 
(++ 
$str++ 
)++ 
]++ 
public,, 

async,, 
Task,, 
<,, 
IActionResult,, #
>,,# $
GetSlaCompliance,,% 5
(,,5 6
),,6 7
{-- 
var.. 
result.. 
=.. 
await.. 
_dashboardService.. ,
..., -!
GetSlaComplianceAsync..- B
(..B C
GetCurrentUserId..C S
(..S T
)..T U
)..U V
;..V W
return// 
Ok// 
(// 
result// 
)// 
;// 
}00 
[22 
HttpGet22 
(22 
$str22 
)22 
]22 
public33 

async33 
Task33 
<33 
IActionResult33 #
>33# $
GetRecentSurveys33% 5
(335 6
)336 7
{44 
var55 
result55 
=55 
await55 
_dashboardService55 ,
.55, -!
GetRecentSurveysAsync55- B
(55B C
GetCurrentUserId55C S
(55S T
)55T U
)55U V
;55V W
return66 
Ok66 
(66 
result66 
)66 
;66 
}77 
}88 ⁄'
`/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/CategoriesController.cs
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
CategoriesController !
:" #
ControllerBase$ 2
{ 
private 
readonly 
ICatalogService $
_service% -
;- .
public 
 
CategoriesController 
(  
ICatalogService  /
service0 7
)7 8
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
] 
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
}22 Ãã
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
};; £`
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/AuditLogController.cs
	namespace		 	
ItsTool		
 
.		 
API		 
.		 
Controllers		 !
;		! "
[ 
ApiController 
] 
[ 
Route 
( 
$str 
) 
] 
[ 
	Authorize 

(
 
Policy 
= 
$str 2
)2 3
]3 4
public 
class 
AuditLogController 
:  !
ControllerBase" 0
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

AuditLogController 
( 
ItsToolDbContext .
context/ 6
)6 7
{ 
_context 
= 
context 
; 
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  ! 
PaginatedAuditLogDto! 5
)5 6
,6 7
$num8 ;
); <
]< =
public 

async 
Task 
< 
IActionResult #
># $
GetAuditLogs% 1
(1 2
[2 3
	FromQuery3 <
]< =
AuditLogFilterDto> O
filterP V
)V W
{ 
var 
ticketQuery 
= 
_context "
." #
TicketHistories# 2
.2 3
AsQueryable3 >
(> ?
)? @
;@ A
var 
systemQuery 
= 
_context "
." #
SystemAuditLogs# 2
.2 3
AsQueryable3 >
(> ?
)? @
;@ A
bool 
isTicketFiltered 
= 
false  %
;% &
if   

(   
!   
string   
.   
IsNullOrEmpty   !
(  ! "
filter  " (
.  ( )
Ticket  ) /
)  / 0
)  0 1
{!! 	
var"" 
	ticketStr"" 
="" 
filter"" "
.""" #
Ticket""# )
."") *
Trim""* .
("". /
)""/ 0
.""0 1
ToUpper""1 8
(""8 9
)""9 :
;"": ;
if## 
(## 
	ticketStr## 
.## 

StartsWith## $
(##$ %
$str##% +
)##+ ,
)##, -
{$$ 
if%% 
(%% 
int%% 
.%% 
TryParse%%  
(%%  !
	ticketStr%%! *
.%%* +
AsSpan%%+ 1
(%%1 2
$num%%2 3
)%%3 4
,%%4 5
out%%6 9
int%%: =
parsedId%%> F
)%%F G
)%%G H
{&& 
ticketQuery'' 
=''  !
ticketQuery''" -
.''- .
Where''. 3
(''3 4
h''4 5
=>''6 8
h''9 :
.'': ;
TicketId''; C
==''D F
parsedId''G O
)''O P
;''P Q
isTicketFiltered(( $
=((% &
true((' +
;((+ ,
})) 
}** 
else++ 
if++ 
(++ 
int++ 
.++ 
TryParse++ !
(++! "
	ticketStr++" +
,+++ ,
out++- 0
int++1 4
parsedId++5 =
)++= >
)++> ?
{,, 
ticketQuery-- 
=-- 
ticketQuery-- )
.--) *
Where--* /
(--/ 0
h--0 1
=>--2 4
h--5 6
.--6 7
TicketId--7 ?
==--@ B
parsedId--C K
)--K L
;--L M
isTicketFiltered..  
=..! "
true..# '
;..' (
}// 
}00 	
if22 

(22 
!22 
string22 
.22 
IsNullOrEmpty22 !
(22! "
filter22" (
.22( )
Action22) /
)22/ 0
)220 1
{33 	
ticketQuery44 
=44 
ticketQuery44 %
.44% &
Where44& +
(44+ ,
h44, -
=>44. 0
h441 2
.442 3
Action443 9
==44: <
filter44= C
.44C D
Action44D J
)44J K
;44K L
systemQuery55 
=55 
systemQuery55 %
.55% &
Where55& +
(55+ ,
h55, -
=>55. 0
h551 2
.552 3
Action553 9
==55: <
filter55= C
.55C D
Action55D J
)55J K
;55K L
}66 	
if88 

(88 
filter88 
.88 
UserId88 
.88 
HasValue88 "
)88" #
{99 	
var:: 
	userIdStr:: 
=:: 
filter:: "
.::" #
UserId::# )
.::) *
Value::* /
.::/ 0
ToString::0 8
(::8 9
)::9 :
;::: ;
ticketQuery;; 
=;; 
ticketQuery;; %
.;;% &
Where;;& +
(;;+ ,
h;;, -
=>;;. 0
h;;1 2
.;;2 3
	CreatedBy;;3 <
==;;= ?
	userIdStr;;@ I
);;I J
;;;J K
systemQuery<< 
=<< 
systemQuery<< %
.<<% &
Where<<& +
(<<+ ,
h<<, -
=><<. 0
h<<1 2
.<<2 3
	CreatedBy<<3 <
==<<= ?
	userIdStr<<@ I
)<<I J
;<<J K
}== 	
if?? 

(?? 
filter?? 
.?? 
FromDate?? 
.?? 
HasValue?? $
)??$ %
{@@ 	
ticketQueryAA 
=AA 
ticketQueryAA %
.AA% &
WhereAA& +
(AA+ ,
hAA, -
=>AA. 0
hAA1 2
.AA2 3
	CreatedAtAA3 <
>=AA= ?
filterAA@ F
.AAF G
FromDateAAG O
.AAO P
ValueAAP U
)AAU V
;AAV W
systemQueryBB 
=BB 
systemQueryBB %
.BB% &
WhereBB& +
(BB+ ,
hBB, -
=>BB. 0
hBB1 2
.BB2 3
	CreatedAtBB3 <
>=BB= ?
filterBB@ F
.BBF G
FromDateBBG O
.BBO P
ValueBBP U
)BBU V
;BBV W
}CC 	
ifEE 

(EE 
filterEE 
.EE 
ToDateEE 
.EE 
HasValueEE "
)EE" #
{FF 	
ticketQueryGG 
=GG 
ticketQueryGG %
.GG% &
WhereGG& +
(GG+ ,
hGG, -
=>GG. 0
hGG1 2
.GG2 3
	CreatedAtGG3 <
<=GG= ?
filterGG@ F
.GGF G
ToDateGGG M
.GGM N
ValueGGN S
)GGS T
;GGT U
systemQueryHH 
=HH 
systemQueryHH %
.HH% &
WhereHH& +
(HH+ ,
hHH, -
=>HH. 0
hHH1 2
.HH2 3
	CreatedAtHH3 <
<=HH= ?
filterHH@ F
.HHF G
ToDateHHG M
.HHM N
ValueHHN S
)HHS T
;HHT U
}II 	
varKK 
ticketCountKK 
=KK 
awaitKK 
ticketQueryKK  +
.KK+ ,

CountAsyncKK, 6
(KK6 7
)KK7 8
;KK8 9
varLL 
systemCountLL 
=LL 
isTicketFilteredLL *
?LL+ ,
$numLL- .
:LL/ 0
awaitLL1 6
systemQueryLL7 B
.LLB C

CountAsyncLLC M
(LLM N
)LLN O
;LLO P
varMM 

totalCountMM 
=MM 
ticketCountMM $
+MM% &
systemCountMM' 2
;MM2 3
varOO 
ticketItemsOO 
=OO 
awaitOO 
ticketQueryOO  +
.PP 
OrderByDescendingPP 
(PP 
hPP  
=>PP! #
hPP$ %
.PP% &
	CreatedAtPP& /
)PP/ 0
.QQ 
TakeQQ 
(QQ 
filterQQ 
.QQ 
PageSizeQQ !
*QQ" #
filterQQ$ *
.QQ* +
PageQQ+ /
)QQ/ 0
.RR 
SelectRR 
(RR 
hRR 
=>RR 
newRR 
AuditLogItemDtoRR ,
(RR, -
hSS 
.SS 
IdSS 
,SS 
hTT 
.TT 
TicketIdTT 
,TT 
hUU 
.UU 
ActionUU 
,UU 
hVV 
.VV 
	FieldNameVV 
,VV 
hWW 
.WW 
OldValueWW 
,WW 
hXX 
.XX 
NewValueXX 
,XX 
hYY 
.YY 
	CreatedByYY 
??YY 
$strYY '
,YY' (
hZZ 
.ZZ 
	CreatedAtZZ 
,ZZ 
null[[ 
,[[ 
null\\ 
)]] 
)]] 
.^^ 
ToListAsync^^ 
(^^ 
)^^ 
;^^ 
var`` 
systemItems`` 
=`` 
new`` 
System`` $
.``$ %
Collections``% 0
.``0 1
Generic``1 8
.``8 9
List``9 =
<``= >
AuditLogItemDto``> M
>``M N
(``N O
)``O P
;``P Q
ifaa 

(aa 
!aa 
isTicketFilteredaa 
)aa 
{bb 	
systemItemscc 
=cc 
awaitcc 
systemQuerycc  +
.dd 
OrderByDescendingdd "
(dd" #
hdd# $
=>dd% '
hdd( )
.dd) *
	CreatedAtdd* 3
)dd3 4
.ee 
Takeee 
(ee 
filteree 
.ee 
PageSizeee %
*ee& '
filteree( .
.ee. /
Pageee/ 3
)ee3 4
.ff 
Selectff 
(ff 
hff 
=>ff 
newff  
AuditLogItemDtoff! 0
(ff0 1
hgg 
.gg 
Idgg 
,gg 
nullhh 
,hh 
hii 
.ii 
Actionii 
,ii 
hjj 
.jj 
	FieldNamejj 
??jj  "
$strjj# %
,jj% &
hkk 
.kk 
OldValuekk 
,kk 
hll 
.ll 
NewValuell 
,ll 
hmm 
.mm 
	CreatedBymm 
??mm  "
$strmm# +
,mm+ ,
hnn 
.nn 
	CreatedAtnn 
,nn  
hoo 
.oo 

EntityNameoo  
,oo  !
hpp 
.pp 
EntityIdpp 
)qq 
)qq 
.rr 
ToListAsyncrr 
(rr 
)rr 
;rr 
}ss 	
varuu 
itemsuu 
=uu 
ticketItemsuu 
.uu  
Concatuu  &
(uu& '
systemItemsuu' 2
)uu2 3
.vv 
OrderByDescendingvv 
(vv 
hvv  
=>vv! #
hvv$ %
.vv% &
	CreatedAtvv& /
)vv/ 0
.ww 
Skipww 
(ww 
(ww 
filterww 
.ww 
Pageww 
-ww  
$numww! "
)ww" #
*ww$ %
filterww& ,
.ww, -
PageSizeww- 5
)ww5 6
.xx 
Takexx 
(xx 
filterxx 
.xx 
PageSizexx !
)xx! "
.yy 
ToListyy 
(yy 
)yy 
;yy 
return{{ 
Ok{{ 
({{ 
new{{  
PaginatedAuditLogDto{{ *
({{* +
items{{+ 0
,{{0 1

totalCount{{2 <
,{{< =
filter{{> D
.{{D E
Page{{E I
,{{I J
filter{{K Q
.{{Q R
PageSize{{R Z
){{Z [
){{[ \
;{{\ ]
}|| 
}}} Ëo
d/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/AssignmentRuleController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
[ 
ApiController 
] 
[ 
Route 
( 
$str 
) 
] 
[ 
	Authorize 

(
 
Policy 
= 
$str 5
)5 6
]6 7
public 
class $
AssignmentRuleController %
:& '
ControllerBase( 6
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly 
ISystemAuditService (
_auditService) 6
;6 7
private 
const 
string 

EntityName #
=$ %
$str& 6
;6 7
public 
$
AssignmentRuleController #
(# $
ItsToolDbContext$ 4
context5 <
,< =
ISystemAuditService> Q
auditServiceR ^
)^ _
{ 
_context 
= 
context 
; 
_auditService 
= 
auditService $
;$ %
} 
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
typeof  
(  !
IEnumerable! ,
<, -
AssignmentRuleDto- >
>> ?
)? @
,@ A
$numB E
)E F
]F G
public 

async 
Task 
< 
IActionResult #
># $
GetRules% -
(- .
). /
{   
var!! 
rules!! 
=!! 
await!! 
_context!! "
.!!" #
AssignmentRules!!# 2
."" 
Where"" 
("" 
r"" 
=>"" 
!"" 
r"" 
."" 
	IsDeleted"" $
)""$ %
.## 
OrderBy## 
(## 
r## 
=>## 
r## 
.## 
	SortOrder## %
)##% &
.$$ 
ToListAsync$$ 
($$ 
)$$ 
;$$ 
var&& 
dtos&& 
=&& 
rules&& 
.&& 
Select&& 
(&&  
r&&  !
=>&&" $
new&&% (
AssignmentRuleDto&&) :
(&&: ;
r'' 
.'' 
Id'' 
,'' 
r'' 
.'' 
Name'' 
,'' 
r'' 
.'' 
	ProjectId'' %
,''% &
r''' (
.''( )

CategoryId'') 3
,''3 4
r''5 6
.''6 7
TicketTypeId''7 C
,''C D
r''E F
.''F G

PriorityId''G Q
,''Q R
r''S T
.''T U
TargetGroupId''U b
,''b c
r''d e
.''e f
TargetUserId''f r
,''r s
r''t u
.''u v
	SortOrder''v 
,	'' Ä
r
''Å Ç
.
''Ç É
IsActive
''É ã
)
''ã å
)
''å ç
;
''ç é
return)) 
Ok)) 
()) 
dtos)) 
))) 
;)) 
}** 
[,, 
HttpPost,, 
],, 
[--  
ProducesResponseType-- 
(-- 
typeof--  
(--  !
AssignmentRuleDto--! 2
)--2 3
,--3 4
$num--5 8
)--8 9
]--9 :
public.. 

async.. 
Task.. 
<.. 
IActionResult.. #
>..# $

CreateRule..% /
(../ 0
[..0 1
FromBody..1 9
]..9 :#
CreateAssignmentRuleDto..; R
dto..S V
)..V W
{// 
var00 
rule00 
=00 
new00 
AssignmentRule00 %
{11 	
Name22 
=22 
dto22 
.22 
Name22 
,22 
	ProjectId33 
=33 
dto33 
.33 
	ProjectId33 %
,33% &

CategoryId44 
=44 
dto44 
.44 

CategoryId44 '
,44' (
TicketTypeId55 
=55 
dto55 
.55 
TicketTypeId55 +
,55+ ,

PriorityId66 
=66 
dto66 
.66 

PriorityId66 '
,66' (
TargetGroupId77 
=77 
dto77 
.77  
TargetGroupId77  -
,77- .
TargetUserId88 
=88 
dto88 
.88 
TargetUserId88 +
,88+ ,
	SortOrder99 
=99 
dto99 
.99 
	SortOrder99 %
,99% &
IsActive:: 
=:: 
dto:: 
.:: 
IsActive:: #
};; 	
;;;	 

_context== 
.== 
AssignmentRules==  
.==  !
Add==! $
(==$ %
rule==% )
)==) *
;==* +
await>> 
_context>> 
.>> 
SaveChangesAsync>> '
(>>' (
)>>( )
;>>) *
await@@ 
_auditService@@ 
.@@ 
LogAuditAsync@@ )
(@@) *

EntityName@@* 4
,@@4 5
rule@@6 :
.@@: ;
Id@@; =
.@@= >
ToString@@> F
(@@F G
)@@G H
,@@H I
$str@@J S
,@@S T
$str@@U [
,@@[ \
null@@] a
,@@a b
rule@@c g
.@@g h
Name@@h l
)@@l m
;@@m n
varBB 
responseDtoBB 
=BB 
newBB 
AssignmentRuleDtoBB /
(BB/ 0
ruleCC 
.CC 
IdCC 
,CC 
ruleCC 
.CC 
NameCC 
,CC 
ruleCC  $
.CC$ %
	ProjectIdCC% .
,CC. /
ruleCC0 4
.CC4 5

CategoryIdCC5 ?
,CC? @
ruleCCA E
.CCE F
TicketTypeIdCCF R
,CCR S
ruleCCT X
.CCX Y

PriorityIdCCY c
,CCc d
ruleCCe i
.CCi j
TargetGroupIdCCj w
,CCw x
ruleCCy }
.CC} ~
TargetUserId	CC~ ä
,
CCä ã
rule
CCå ê
.
CCê ë
	SortOrder
CCë ö
,
CCö õ
rule
CCú †
.
CC† °
IsActive
CC° ©
)
CC© ™
;
CC™ ´
returnEE 
CreatedAtActionEE 
(EE 
nameofEE %
(EE% &
GetRulesEE& .
)EE. /
,EE/ 0
newEE1 4
{EE5 6
idEE7 9
=EE: ;
ruleEE< @
.EE@ A
IdEEA C
}EED E
,EEE F
responseDtoEEG R
)EER S
;EES T
}FF 
[HH 
HttpPutHH 
(HH 
$strHH 
)HH 
]HH 
[II  
ProducesResponseTypeII 
(II 
$numII 
)II 
]II 
publicJJ 

asyncJJ 
TaskJJ 
<JJ 
IActionResultJJ #
>JJ# $

UpdateRuleJJ% /
(JJ/ 0
intJJ0 3
idJJ4 6
,JJ6 7
[JJ8 9
FromBodyJJ9 A
]JJA B#
UpdateAssignmentRuleDtoJJC Z
dtoJJ[ ^
)JJ^ _
{KK 
varLL 
ruleLL 
=LL 
awaitLL 
_contextLL !
.LL! "
AssignmentRulesLL" 1
.LL1 2
FirstOrDefaultAsyncLL2 E
(LLE F
rLLF G
=>LLH J
rLLK L
.LLL M
IdLLM O
==LLP R
idLLS U
&&LLV X
!LLY Z
rLLZ [
.LL[ \
	IsDeletedLL\ e
)LLe f
;LLf g
ifMM 

(MM 
ruleMM 
==MM 
nullMM 
)MM 
returnMM  
NotFoundMM! )
(MM) *
)MM* +
;MM+ ,
ruleOO 
.OO 
NameOO 
=OO 
dtoOO 
.OO 
NameOO 
;OO 
rulePP 
.PP 
	ProjectIdPP 
=PP 
dtoPP 
.PP 
	ProjectIdPP &
;PP& '
ruleQQ 
.QQ 

CategoryIdQQ 
=QQ 
dtoQQ 
.QQ 

CategoryIdQQ (
;QQ( )
ruleRR 
.RR 
TicketTypeIdRR 
=RR 
dtoRR 
.RR  
TicketTypeIdRR  ,
;RR, -
ruleSS 
.SS 

PriorityIdSS 
=SS 
dtoSS 
.SS 

PriorityIdSS (
;SS( )
ruleTT 
.TT 
TargetGroupIdTT 
=TT 
dtoTT  
.TT  !
TargetGroupIdTT! .
;TT. /
ruleUU 
.UU 
TargetUserIdUU 
=UU 
dtoUU 
.UU  
TargetUserIdUU  ,
;UU, -
ruleVV 
.VV 
	SortOrderVV 
=VV 
dtoVV 
.VV 
	SortOrderVV &
;VV& '
ruleWW 
.WW 
IsActiveWW 
=WW 
dtoWW 
.WW 
IsActiveWW $
;WW$ %
awaitYY 
_contextYY 
.YY 
SaveChangesAsyncYY '
(YY' (
)YY( )
;YY) *
awaitZZ 
_auditServiceZZ 
.ZZ 
LogAuditAsyncZZ )
(ZZ) *

EntityNameZZ* 4
,ZZ4 5
ruleZZ6 :
.ZZ: ;
IdZZ; =
.ZZ= >
ToStringZZ> F
(ZZF G
)ZZG H
,ZZH I
$strZZJ S
,ZZS T
$strZZU [
,ZZ[ \
nullZZ] a
,ZZa b
ruleZZc g
.ZZg h
NameZZh l
)ZZl m
;ZZm n
return[[ 
	NoContent[[ 
([[ 
)[[ 
;[[ 
}\\ 
[^^ 

HttpDelete^^ 
(^^ 
$str^^ 
)^^ 
]^^ 
[__  
ProducesResponseType__ 
(__ 
$num__ 
)__ 
]__ 
public`` 

async`` 
Task`` 
<`` 
IActionResult`` #
>``# $

DeleteRule``% /
(``/ 0
int``0 3
id``4 6
)``6 7
{aa 
varbb 
rulebb 
=bb 
awaitbb 
_contextbb !
.bb! "
AssignmentRulesbb" 1
.bb1 2
FirstOrDefaultAsyncbb2 E
(bbE F
rbbF G
=>bbH J
rbbK L
.bbL M
IdbbM O
==bbP R
idbbS U
&&bbV X
!bbY Z
rbbZ [
.bb[ \
	IsDeletedbb\ e
)bbe f
;bbf g
ifcc 

(cc 
rulecc 
==cc 
nullcc 
)cc 
returncc  
NotFoundcc! )
(cc) *
)cc* +
;cc+ ,
ruleee 
.ee 
	IsDeletedee 
=ee 
trueee 
;ee 
awaitff 
_contextff 
.ff 
SaveChangesAsyncff '
(ff' (
)ff( )
;ff) *
awaitgg 
_auditServicegg 
.gg 
LogAuditAsyncgg )
(gg) *

EntityNamegg* 4
,gg4 5
rulegg6 :
.gg: ;
Idgg; =
.gg= >
ToStringgg> F
(ggF G
)ggG H
,ggH I
$strggJ S
,ggS T
$strggU [
,gg[ \
rulegg] a
.gga b
Nameggb f
,ggf g
nullggh l
)ggl m
;ggm n
returnhh 
	NoContenthh 
(hh 
)hh 
;hh 
}ii 
[kk 
HttpPutkk 
(kk 
$strkk 
)kk 
]kk 
[ll  
ProducesResponseTypell 
(ll 
$numll 
)ll 
]ll 
publicmm 

asyncmm 
Taskmm 
<mm 
IActionResultmm #
>mm# $

ToggleRulemm% /
(mm/ 0
intmm0 3
idmm4 6
)mm6 7
{nn 
varoo 
ruleoo 
=oo 
awaitoo 
_contextoo !
.oo! "
AssignmentRulesoo" 1
.oo1 2
FirstOrDefaultAsyncoo2 E
(ooE F
rooF G
=>ooH J
rooK L
.ooL M
IdooM O
==ooP R
idooS U
&&ooV X
!ooY Z
rooZ [
.oo[ \
	IsDeletedoo\ e
)ooe f
;oof g
ifpp 

(pp 
rulepp 
==pp 
nullpp 
)pp 
returnpp  
NotFoundpp! )
(pp) *
)pp* +
;pp+ ,
varrr 
	oldStatusrr 
=rr 
rulerr 
.rr 
IsActiverr %
.rr% &
ToStringrr& .
(rr. /
)rr/ 0
;rr0 1
ruless 
.ss 
IsActivess 
=ss 
!ss 
ruless 
.ss 
IsActivess &
;ss& '
vartt 
	newStatustt 
=tt 
rulett 
.tt 
IsActivett %
.tt% &
ToStringtt& .
(tt. /
)tt/ 0
;tt0 1
awaitvv 
_contextvv 
.vv 
SaveChangesAsyncvv '
(vv' (
)vv( )
;vv) *
awaitww 
_auditServiceww 
.ww 
LogAuditAsyncww )
(ww) *

EntityNameww* 4
,ww4 5
ruleww6 :
.ww: ;
Idww; =
.ww= >
ToStringww> F
(wwF G
)wwG H
,wwH I
$strwwJ S
,wwS T
$strwwU _
,ww_ `
	oldStatuswwa j
,wwj k
	newStatuswwl u
)wwu v
;wwv w
returnxx 
	NoContentxx 
(xx 
)xx 
;xx 
}yy 
}zz 