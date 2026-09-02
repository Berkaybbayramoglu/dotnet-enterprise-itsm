ô
V/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Services/SignalRPusher.cs
	namespace 	
ItsTool
 
. 
API 
. 
Services 
; 
public 
class 
SignalRPusher 
: 
ISignalRPusher +
{		 
private

 
readonly

 
IHubContext

  
<

  !
NotificationHub

! 0
>

0 1
_hubContext

2 =
;

= >
public 

SignalRPusher 
( 
IHubContext $
<$ %
NotificationHub% 4
>4 5

hubContext6 @
)@ A
{ 
_hubContext 
= 

hubContext  
;  !
} 
public 

async 
Task !
PushNotificationAsync +
(+ ,
int, /
userId0 6
,6 7
object8 >
payload? F
)F G
{ 
await 
_hubContext 
. 
Clients !
.! "
Group" '
(' (
$"( *
$str* /
{/ 0
userId0 6
}6 7
"7 8
)8 9
.9 :
	SendAsync: C
(C D
$strD Y
,Y Z
payload[ b
)b c
;c d
} 
} Î
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
} Ô∫
G/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Program.cs
var 

currentDir 
= 
	Directory 
. 
GetCurrentDirectory .
(. /
)/ 0
;0 1
var 
webRootPath 
= 
Path 
. 
Combine 
( 

currentDir )
,) *
$str+ 0
,0 1
$str2 ?
,? @
$strA J
)J K
;K L
if 
( 
! 
	Directory 
. 
Exists 
( 
webRootPath !
)! "
)" #
{ 
webRootPath 
= 
Path 
. 
Combine 
( 

currentDir )
,) *
$str+ /
,/ 0
$str1 >
,> ?
$str@ I
)I J
;J K
} 
var 
builder 
= 
WebApplication 
. 
CreateBuilder *
(* +
new+ .!
WebApplicationOptions/ D
{ 
Args 
=	 

args 
, 
WebRootPath 
= 
Path 
. 
GetFullPath "
(" #
webRootPath# .
). /
} 
) 
; 
builder 
. 
Services 
. 
AddControllers 
(  
)  !
;! "
builder   
.   
Services   
.   #
AddEndpointsApiExplorer   (
(  ( )
)  ) *
;  * +
builder!! 
.!! 
Services!! 
.!! 
AddSwaggerGen!! 
(!! 
)!!  
;!!  !
builder"" 
."" 
Services"" 
."" "
AddHttpContextAccessor"" '
(""' (
)""( )
;"") *
builder## 
.## 
Services## 
.## 

AddSignalR## 
(## 
)## 
;## 
builder%% 
.%% 
Services%% 
.%% 
	AddScoped%% 
<%% "
SystemAuditInterceptor%% 1
>%%1 2
(%%2 3
)%%3 4
;%%4 5
builder'' 
.'' 
Services'' 
.'' 
AddDbContext'' 
<'' 
ItsToolDbContext'' .
>''. /
(''/ 0
(''0 1
sp''1 3
,''3 4
options''5 <
)''< =
=>''> @
{(( 
options)) 
.)) 
	UseNpgsql)) 
()) 
builder)) 
.)) 
Configuration)) +
.))+ ,
GetConnectionString)), ?
())? @
$str))@ S
)))S T
)))T U
;))U V
var** 
interceptor** 
=** 
sp** 
.** 
GetRequiredService** +
<**+ ,"
SystemAuditInterceptor**, B
>**B C
(**C D
)**D E
;**E F
options++ 
.++ 
AddInterceptors++ 
(++ 
interceptor++ '
)++' (
;++( )
},, 
),, 
;,, 
builder.. 
... 
Services.. 
... 
	AddScoped.. 
<.. 

DataSeeder.. %
>..% &
(..& '
)..' (
;..( )
builder// 
.// 
Services// 
.// 
	AddScoped// 
<// 
ITokenService// (
,//( )
TokenService//* 6
>//6 7
(//7 8
)//8 9
;//9 :
builder00 
.00 
Services00 
.00 
	AddScoped00 
<00 !
IPermissionCalculator00 0
,000 1 
PermissionCalculator002 F
>00F G
(00G H
)00H I
;00I J
builder11 
.11 
Services11 
.11 
	AddScoped11 
<11 
IAuthService11 '
,11' (
AuthService11) 4
>114 5
(115 6
)116 7
;117 8
builder22 
.22 
Services22 
.22 
	AddScoped22 
(22 
typeof22 !
(22! "
IRepository22" -
<22- .
>22. /
)22/ 0
,220 1
typeof222 8
(228 9

Repository229 C
<22C D
>22D E
)22E F
)22F G
;22G H
builder55 
.55 
Services55 
.55 
	AddScoped55 
<55 
IDepartmentService55 -
,55- .
DepartmentService55/ @
>55@ A
(55A B
)55B C
;55C D
builder66 
.66 
Services66 
.66 
	AddScoped66 
<66 
IGroupService66 (
,66( )
GroupService66* 6
>666 7
(667 8
)668 9
;669 :
builder77 
.77 
Services77 
.77 
	AddScoped77 
<77 
IUserService77 '
,77' (
UserService77) 4
>774 5
(775 6
)776 7
;777 8
builder88 
.88 
Services88 
.88 
	AddScoped88 
<88 
IProjectService88 *
,88* +
ProjectService88, :
>88: ;
(88; <
)88< =
;88= >
builder99 
.99 
Services99 
.99 
	AddScoped99 
<99 
IRoleService99 '
,99' (
RoleService99) 4
>994 5
(995 6
)996 7
;997 8
builder<< 
.<< 
Services<< 
.<< 
	AddScoped<< 
<<< 
ICatalogService<< *
,<<* +
CatalogService<<, :
><<: ;
(<<; <
)<<< =
;<<= >
builder== 
.== 
Services== 
.== 
	AddScoped== 
<== 
IWorkflowService== +
,==+ ,
WorkflowService==- <
>==< =
(=== >
)==> ?
;==? @
builder>> 
.>> 
Services>> 
.>> 
	AddScoped>> 
<>> 
IDynamicFormService>> .
,>>. /
DynamicFormService>>0 B
>>>B C
(>>C D
)>>D E
;>>E F
builderAA 
.AA 
ServicesAA 
.AA 
	AddScopedAA 
<AA 
IFileStorageServiceAA .
,AA. /#
LocalFileStorageServiceAA0 G
>AAG H
(AAH I
)AAI J
;AAJ K
builderBB 
.BB 
ServicesBB 
.BB 
	AddScopedBB 
<BB 
ITicketServiceBB )
,BB) *
TicketServiceBB+ 8
>BB8 9
(BB9 :
)BB: ;
;BB; <
builderCC 
.CC 
ServicesCC 
.CC 
	AddScopedCC 
<CC 
IEmailServiceCC ,
>CC, -
(CC- .
spCC. 0
=>CC1 3
{DD 
varEE 
configEE 
=EE 
spEE 
.EE 
GetRequiredServiceEE *
<EE* +
IConfigurationEE+ 9
>EE9 :
(EE: ;
)EE; <
;EE< =
varFF 
hostFF 
=FF 
configFF 
[FF 
$strFF %
]FF% &
;FF& '
ifGG 

(GG 
!GG 
stringGG 
.GG 
IsNullOrEmptyGG !
(GG! "
hostGG" &
)GG& '
)GG' (
{HH 	
varII 
loggerII 
=II 
spII 
.II 
GetRequiredServiceII .
<II. /
ILoggerII/ 6
<II6 7
SmtpEmailServiceII7 G
>IIG H
>IIH I
(III J
)IIJ K
;IIK L
returnJJ 
newJJ 
SmtpEmailServiceJJ '
(JJ' (
configJJ( .
,JJ. /
loggerJJ0 6
)JJ6 7
;JJ7 8
}KK 	
returnLL 
newLL 
StubEmailServiceLL #
(LL# $
)LL$ %
;LL% &
}MM 
)MM 
;MM 
builderNN 
.NN 
ServicesNN 
.NN 
	AddScopedNN 
<NN "
IEmailIngestionServiceNN 5
,NN5 6!
EmailIngestionServiceNN7 L
>NNL M
(NNM N
)NNN O
;NNO P
builderOO 
.OO 
ServicesOO 
.OO 
AddSingletonOO !
<OO! "
IEmailQueueOO" -
,OO- .
InMemoryEmailQueueOO/ A
>OOA B
(OOB C
)OOC D
;OOD E
builderPP 
.PP 
ServicesPP 
.PP 
AddHostedServicePP %
<PP% &
ItsToolPP& -
.PP- .
InfrastructurePP. <
.PP< =
BackgroundServicesPP= O
.PPO P"
EmailBackgroundServicePPP f
>PPf g
(PPg h
)PPh i
;PPi j
builderQQ 
.QQ 
ServicesQQ 
.QQ 
	AddScopedQQ 
<QQ !
IEmailTemplateServiceQQ 4
,QQ4 5 
EmailTemplateServiceQQ6 J
>QQJ K
(QQK L
)QQL M
;QQM N
builderRR 
.RR 
ServicesRR 
.RR 
	AddScopedRR 
<RR 

ISlaEngineRR %
,RR% &
	SlaEngineRR' 0
>RR0 1
(RR1 2
)RR2 3
;RR3 4
builderSS 
.SS 
ServicesSS 
.SS 
	AddScopedSS 
<SS 
IAssignmentEngineSS ,
,SS, -
AssignmentEngineSS. >
>SS> ?
(SS? @
)SS@ A
;SSA B
builderTT 
.TT 
ServicesTT 
.TT 
AddHttpClientTT 
(TT 
)TT  
;TT  !
builderUU 
.UU 
ServicesUU 
.UU 
	AddScopedUU 
<UU 
IWebhookDispatcherUU -
,UU- .
WebhookDispatcherUU/ @
>UU@ A
(UUA B
)UUB C
;UUC D
builderVV 
.VV 
ServicesVV 
.VV 
	AddScopedVV 
<VV #
INotificationDispatcherVV 2
,VV2 3"
NotificationDispatcherVV4 J
>VVJ K
(VVK L
)VVL M
;VVM N
builderWW 
.WW 
ServicesWW 
.WW 
	AddScopedWW 
<WW  
INotificationServiceWW /
,WW/ 0
NotificationServiceWW1 D
>WWD E
(WWE F
)WWF G
;WWG H
builderXX 
.XX 
ServicesXX 
.XX 
	AddScopedXX 
<XX 
ISignalRPusherXX )
,XX) *
ItsToolXX+ 2
.XX2 3
APIXX3 6
.XX6 7
ServicesXX7 ?
.XX? @
SignalRPusherXX@ M
>XXM N
(XXN O
)XXO P
;XXP Q
builderYY 
.YY 
ServicesYY 
.YY 
	AddScopedYY 
<YY 
ISlaServiceYY *
,YY* +

SlaServiceYY, 6
>YY6 7
(YY7 8
)YY8 9
;YY9 :
builderZZ 
.ZZ 
ServicesZZ 
.ZZ 
AddHostedServiceZZ %
<ZZ% &
SlaCheckerServiceZZ& 7
>ZZ7 8
(ZZ8 9
)ZZ9 :
;ZZ: ;
builder]] 
.]] 
Services]] 
.]] 
	AddScoped]] 
<]] 
IDashboardService]] 0
,]]0 1
DashboardService]]2 B
>]]B C
(]]C D
)]]D E
;]]E F
builder^^ 
.^^ 
Services^^ 
.^^ 
	AddScoped^^ 
<^^ 
IReportService^^ -
,^^- .
ReportService^^/ <
>^^< =
(^^= >
)^^> ?
;^^? @
builder__ 
.__ 
Services__ 
.__ 
	AddScoped__ 
<__ !
IKnowledgeBaseService__ 4
,__4 5 
KnowledgeBaseService__6 J
>__J K
(__K L
)__L M
;__M N
builder`` 
.`` 
Services`` 
.`` 
	AddScoped`` 
<`` 
ISystemAuditService`` 2
,``2 3
SystemAuditService``4 F
>``F G
(``G H
)``H I
;``I J
buildercc 
.cc 
Servicescc 
.cc 
AddAuthenticationcc "
(cc" #
JwtBearerDefaultscc# 4
.cc4 5 
AuthenticationSchemecc5 I
)ccI J
.dd 
AddJwtBearerdd 
(dd 
optionsdd 
=>dd 
{ee 
optionsff 
.ff %
TokenValidationParametersff )
=ff* +
newff, /%
TokenValidationParametersff0 I
{gg 	
ValidateIssuerhh 
=hh 
truehh !
,hh! "
ValidateAudienceii 
=ii 
trueii #
,ii# $
ValidateLifetimejj 
=jj 
truejj #
,jj# $$
ValidateIssuerSigningKeykk $
=kk% &
truekk' +
,kk+ ,
ValidIssuerll 
=ll 
builderll !
.ll! "
Configurationll" /
[ll/ 0
$strll0 <
]ll< =
,ll= >
ValidAudiencemm 
=mm 
buildermm #
.mm# $
Configurationmm$ 1
[mm1 2
$strmm2 @
]mm@ A
,mmA B
IssuerSigningKeynn 
=nn 
newnn " 
SymmetricSecurityKeynn# 7
(nn7 8
Encodingnn8 @
.nn@ A
UTF8nnA E
.nnE F
GetBytesnnF N
(nnN O
buildernnO V
.nnV W
ConfigurationnnW d
[nnd e
$strnne q
]nnq r
??nns u
$str	nnv •
)
nn• ¶
)
nn¶ ß
}oo 	
;oo	 

}pp 
)pp 
;pp 
builderrr 
.rr 
Servicesrr 
.rr 
AddSingletonrr 
<rr !
IAuthorizationHandlerrr 3
,rr3 4*
PermissionAuthorizationHandlerrr5 S
>rrS T
(rrT U
)rrU V
;rrV W
builderss 
.ss 
Servicesss 
.ss 
AddAuthorizationss !
(ss! "
optionsss" )
=>ss* ,
{tt 
foreachuu 
(uu 
varuu 
permuu 
inuu 
PermissionConstantsuu ,
.uu, -
AllPermissionsuu- ;
)uu; <
{vv 
optionsww 
.ww 
	AddPolicyww 
(ww 
$"ww 
$strww .
{ww. /
permww/ 3
}ww3 4
"ww4 5
,ww5 6
policyww7 =
=>ww> @
policyxx 
.xx 
Requirementsxx 
.xx  
Addxx  #
(xx# $
newxx$ '!
PermissionRequirementxx( =
(xx= >
permxx> B
)xxB C
)xxC D
)xxD E
;xxE F
}yy 
optionszz 
.zz 
	AddPolicyzz 
(zz 
$strzz '
,zz' (
policyzz) /
=>zz0 2
policyzz3 9
.zz9 :
RequireClaimzz: F
(zzF G
$strzzG S
,zzS T
$strzzU `
)zz` a
)zza b
;zzb c
}{{ 
){{ 
;{{ 
var~~ 
allowedOrigins~~ 
=~~ 
builder~~ 
.~~ 
Configuration~~ *
.~~* +

GetSection~~+ 5
(~~5 6
$str~~6 K
)~~K L
.~~L M
Get~~M P
<~~P Q
string~~Q W
[~~W X
]~~X Y
>~~Y Z
(~~Z [
)~~[ \
?? 
Array 
. 	
Empty	 
< 
string 
> 
( 
) 
; 
builderÅÅ 
.
ÅÅ 
Services
ÅÅ 
.
ÅÅ 
AddCors
ÅÅ 
(
ÅÅ 
options
ÅÅ  
=>
ÅÅ! #
{ÇÇ 
options
ÉÉ 
.
ÉÉ 
	AddPolicy
ÉÉ 
(
ÉÉ 
$str
ÉÉ &
,
ÉÉ& '
builder
ÉÉ( /
=>
ÉÉ0 2
{
ÑÑ 
builder
ÖÖ 
.
ÖÖ 
WithOrigins
ÖÖ 
(
ÖÖ 
allowedOrigins
ÖÖ *
)
ÖÖ* +
.
ÜÜ 
AllowAnyMethod
ÜÜ 
(
ÜÜ 
)
ÜÜ 
.
áá 
AllowAnyHeader
áá 
(
áá 
)
áá 
.
àà 
AllowCredentials
àà 
(
àà 
)
àà 
;
àà  
}
ââ 
)
ââ 
;
ââ 
}ãã 
)
ãã 
;
ãã 
varçç 
app
çç 
=
çç 	
builder
çç
 
.
çç 
Build
çç 
(
çç 
)
çç 
;
çç 
ifêê 
(
êê 
app
êê 
.
êê 
Environment
êê 
.
êê 
IsDevelopment
êê !
(
êê! "
)
êê" #
)
êê# $
{ëë 
app
íí 
.
íí 

UseSwagger
íí 
(
íí 
)
íí 
;
íí 
app
ìì 
.
ìì 
UseSwaggerUI
ìì 
(
ìì 
)
ìì 
;
ìì 
}îî 
appññ 
.
ññ 
UseCors
ññ 
(
ññ 
$str
ññ 
)
ññ 
;
ññ 
appóó 
.
óó !
UseHttpsRedirection
óó 
(
óó 
)
óó 
;
óó 
appôô 
.
ôô 
UseDefaultFiles
ôô 
(
ôô 
)
ôô 
;
ôô 
appöö 
.
öö 
UseStaticFiles
öö 
(
öö 
)
öö 
;
öö 
appúú 
.
úú 
UseAuthentication
úú 
(
úú 
)
úú 
;
úú 
appùù 
.
ùù 
UseAuthorization
ùù 
(
ùù 
)
ùù 
;
ùù 
appüü 
.
üü 
MapGet
üü 

(
üü
 
$str
üü 
,
üü 
(
üü 
)
üü 
=>
üü 
{†† 
return
°° 

Results
°° 
.
°° 
Ok
°° 
(
°° 
new
°° 
{
¢¢ 
status
££ 
=
££ 
$str
££ 
,
££ 
service
§§ 
=
§§ 
$str
§§ 
,
§§  
	timestamp
•• 
=
•• 
DateTime
•• 
.
•• 
UtcNow
•• #
}
¶¶ 
)
¶¶ 
;
¶¶ 
}ßß 
)
ßß 
;
ßß 
app©© 
.
©© 
MapControllers
©© 
(
©© 
)
©© 
;
©© 
app™™ 
.
™™ 
MapHub
™™ 

<
™™
 
NotificationHub
™™ 
>
™™ 
(
™™ 
$str
™™ 0
)
™™0 1
;
™™1 2
if¨¨ 
(
¨¨ 
app
¨¨ 
.
¨¨ 
Environment
¨¨ 
.
¨¨ 
IsDevelopment
¨¨ !
(
¨¨! "
)
¨¨" #
&&
¨¨$ &
builder
¨¨' .
.
¨¨. /
Configuration
¨¨/ <
.
¨¨< =
GetValue
¨¨= E
<
¨¨E F
bool
¨¨F J
>
¨¨J K
(
¨¨K L
$str
¨¨L V
)
¨¨V W
)
¨¨W X
{≠≠ 
using
ÆÆ 	
var
ÆÆ
 
scope
ÆÆ 
=
ÆÆ 
app
ÆÆ 
.
ÆÆ 
Services
ÆÆ "
.
ÆÆ" #
CreateScope
ÆÆ# .
(
ÆÆ. /
)
ÆÆ/ 0
;
ÆÆ0 1
var
ØØ 
context
ØØ 
=
ØØ 
scope
ØØ 
.
ØØ 
ServiceProvider
ØØ '
.
ØØ' ( 
GetRequiredService
ØØ( :
<
ØØ: ;
ItsTool
ØØ; B
.
ØØB C
Infrastructure
ØØC Q
.
ØØQ R
Data
ØØR V
.
ØØV W
ItsToolDbContext
ØØW g
>
ØØg h
(
ØØh i
)
ØØi j
;
ØØj k
await
∞∞ 	
context
∞∞
 
.
∞∞ 
Database
∞∞ 
.
∞∞ 
MigrateAsync
∞∞ '
(
∞∞' (
)
∞∞( )
;
∞∞) *
var
±± 
seeder
±± 
=
±± 
new
±± 
ItsTool
±± 
.
±± 
Infrastructure
±± +
.
±±+ ,
Data
±±, 0
.
±±0 1

DataSeeder
±±1 ;
(
±±; <
context
±±< C
)
±±C D
;
±±D E
await
≤≤ 	
seeder
≤≤
 
.
≤≤ 
	SeedAsync
≤≤ 
(
≤≤ 
)
≤≤ 
;
≤≤ 
}≥≥ 
using∂∂ 
(
∂∂ 
var
∂∂ 

scope
∂∂ 
=
∂∂ 
app
∂∂ 
.
∂∂ 
Services
∂∂ 
.
∂∂  
CreateScope
∂∂  +
(
∂∂+ ,
)
∂∂, -
)
∂∂- .
{∑∑ 
var
∏∏ 
ctx
∏∏ 
=
∏∏ 
scope
∏∏ 
.
∏∏ 
ServiceProvider
∏∏ #
.
∏∏# $ 
GetRequiredService
∏∏$ 6
<
∏∏6 7
ItsTool
∏∏7 >
.
∏∏> ?
Infrastructure
∏∏? M
.
∏∏M N
Data
∏∏N R
.
∏∏R S
ItsToolDbContext
∏∏S c
>
∏∏c d
(
∏∏d e
)
∏∏e f
;
∏∏f g
var
ππ !
orphanedAssignments
ππ 
=
ππ 
await
ππ #
ctx
ππ$ '
.
ππ' (
TicketAssignments
ππ( 9
.
∫∫ 	
Where
∫∫	 
(
∫∫ 
a
∫∫ 
=>
∫∫ 
a
∫∫ 
.
∫∫ 
AssignedGroupId
∫∫ %
.
∫∫% &
HasValue
∫∫& .
&&
∫∫/ 1
!
∫∫2 3
a
∫∫3 4
.
∫∫4 5
	IsDeleted
∫∫5 >
)
∫∫> ?
.
ªª 	
ToListAsync
ªª	 
(
ªª 
)
ªª 
;
ªª 
var
ΩΩ 
deletedGroupIds
ΩΩ 
=
ΩΩ 
await
ΩΩ 
ctx
ΩΩ  #
.
ΩΩ# $
Groups
ΩΩ$ *
.
ΩΩ* +
Where
ΩΩ+ 0
(
ΩΩ0 1
g
ΩΩ1 2
=>
ΩΩ3 5
g
ΩΩ6 7
.
ΩΩ7 8
	IsDeleted
ΩΩ8 A
)
ΩΩA B
.
ΩΩB C
Select
ΩΩC I
(
ΩΩI J
g
ΩΩJ K
=>
ΩΩL N
g
ΩΩO P
.
ΩΩP Q
Id
ΩΩQ S
)
ΩΩS T
.
ΩΩT U
ToListAsync
ΩΩU `
(
ΩΩ` a
)
ΩΩa b
;
ΩΩb c
foreach
øø 
(
øø 
var
øø 
a
øø 
in
øø !
orphanedAssignments
øø (
)
øø( )
{
¿¿ 
if
¡¡ 

(
¡¡ 
deletedGroupIds
¡¡ 
.
¡¡ 
Contains
¡¡ $
(
¡¡$ %
a
¡¡% &
.
¡¡& '
AssignedGroupId
¡¡' 6
.
¡¡6 7
Value
¡¡7 <
)
¡¡< =
)
¡¡= >
{
¬¬ 	
a
√√ 
.
√√ 
	IsDeleted
√√ 
=
√√ 
true
√√ 
;
√√ 
a
ƒƒ 
.
ƒƒ 
IsActive
ƒƒ 
=
ƒƒ 
false
ƒƒ 
;
ƒƒ 
}
≈≈ 	
}
∆∆ 
await
«« 	
ctx
««
 
.
«« 
SaveChangesAsync
«« 
(
«« 
)
««  
;
««  !
}»» 
await   
app
   	
.
  	 

RunAsync
  
 
(
   
)
   
;
   «
T/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Hubs/NotificationHub.cs
	namespace 	
ItsTool
 
. 
API 
. 
Hubs 
; 
[ 
	Authorize 

]
 
public		 
class		 
NotificationHub		 
:		 
Hub		 "
{

 
public 

override 
async 
Task 
OnConnectedAsync /
(/ 0
)0 1
{ 
var 
userId 
= 
Context 
. 
User !
?! "
." #
	FindFirst# ,
(, -

ClaimTypes- 7
.7 8
NameIdentifier8 F
)F G
?G H
.H I
ValueI N
;N O
if 

( 
! 
string 
. 
IsNullOrEmpty !
(! "
userId" (
)( )
)) *
{ 	
await 
Groups 
. 
AddToGroupAsync (
(( )
Context) 0
.0 1
ConnectionId1 =
,= >
$"? A
$strA F
{F G
userIdG M
}M N
"N O
)O P
;P Q
} 	
await 
base 
. 
OnConnectedAsync #
(# $
)$ %
;% &
} 
public 

override 
async 
Task 
OnDisconnectedAsync 2
(2 3
System3 9
.9 :
	Exception: C
?C D
	exceptionE N
)N O
{ 
var 
userId 
= 
Context 
. 
User !
?! "
." #
	FindFirst# ,
(, -

ClaimTypes- 7
.7 8
NameIdentifier8 F
)F G
?G H
.H I
ValueI N
;N O
if 

( 
! 
string 
. 
IsNullOrEmpty !
(! "
userId" (
)( )
)) *
{ 	
await 
Groups 
.  
RemoveFromGroupAsync -
(- .
Context. 5
.5 6
ConnectionId6 B
,B C
$"D F
$strF K
{K L
userIdL R
}R S
"S T
)T U
;U V
} 	
await 
base 
. 
OnDisconnectedAsync &
(& '
	exception' 0
)0 1
;1 2
} 
} £
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
}XX ∆2
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
}LL ıL
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
}jj Á∫
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
HttpGet55 
(55 
$str55 "
)55" #
]55# $
[66  
ProducesResponseType66 
(66 
typeof66  
(66  !
IEnumerable66! ,
<66, -
UserDto66- 4
>664 5
)665 6
,666 7
StatusCodes668 C
.66C D
Status200OK66D O
)66O P
]66P Q
public77 

async77 
Task77 
<77 
IActionResult77 #
>77# $
GetEligibleUsers77% 5
(775 6
int776 9
id77: <
)77< =
{88 
var99 
users99 
=99 
await99 
_service99 "
.99" #*
GetEligibleUsersForTicketAsync99# A
(99A B
id99B D
)99D E
;99E F
return:: 
Ok:: 
(:: 
users:: 
):: 
;:: 
};; 
[== 
HttpPut== 
(== 
$str== 
)== 
]== 
[>> 
	Authorize>> 
(>> 
Policy>> 
=>> 
$str>> 7
)>>7 8
]>>8 9
[??  
ProducesResponseType?? 
(?? 
StatusCodes?? %
.??% &
Status204NoContent??& 8
)??8 9
]??9 :
[@@  
ProducesResponseType@@ 
(@@ 
StatusCodes@@ %
.@@% &
Status404NotFound@@& 7
)@@7 8
]@@8 9
[AA  
ProducesResponseTypeAA 
(AA 
StatusCodesAA %
.AA% &
Status400BadRequestAA& 9
)AA9 :
]AA: ;
publicBB 

asyncBB 
TaskBB 
<BB 
IActionResultBB #
>BB# $
UpdateTicketBB% 1
(BB1 2
intBB2 5
idBB6 8
,BB8 9
[BB: ;
FromBodyBB; C
]BBC D
UpdateTicketDtoBBE T
dtoBBU X
)BBX Y
{CC 
tryDD 
{EE 	
awaitFF 
_serviceFF 
.FF 
UpdateTicketAsyncFF ,
(FF, -
idFF- /
,FF/ 0
dtoFF1 4
,FF4 5
GetCurrentUserIdFF6 F
(FFF G
)FFG H
)FFH I
;FFI J
returnGG 
	NoContentGG 
(GG 
)GG 
;GG 
}HH 	
catchII 
(II  
KeyNotFoundExceptionII #
)II# $
{II% &
returnII' -
NotFoundII. 6
(II6 7
)II7 8
;II8 9
}II: ;
catchJJ 
(JJ %
InvalidOperationExceptionJJ (
exJJ) +
)JJ+ ,
{JJ- .
returnJJ/ 5

BadRequestJJ6 @
(JJ@ A
newJJA D
{JJE F
errorJJG L
=JJM N
exJJO Q
.JJQ R
MessageJJR Y
}JJZ [
)JJ[ \
;JJ\ ]
}JJ^ _
}KK 
[MM 
HttpGetMM 
(MM 
$strMM '
)MM' (
]MM( )
[NN  
ProducesResponseTypeNN 
(NN 
StatusCodesNN %
.NN% &
Status200OKNN& 1
)NN1 2
]NN2 3
[OO  
ProducesResponseTypeOO 
(OO 
StatusCodesOO %
.OO% &
Status404NotFoundOO& 7
)OO7 8
]OO8 9
publicPP 

asyncPP 
TaskPP 
<PP 
IActionResultPP #
>PP# $!
GetAllowedTransitionsPP% :
(PP: ;
intPP; >
idPP? A
)PPA B
{QQ 
tryRR 
{SS 	
varTT 
transitionsTT 
=TT 
awaitTT #
_serviceTT$ ,
.TT, -&
GetAllowedTransitionsAsyncTT- G
(TTG H
idTTH J
,TTJ K
GetCurrentUserIdTTL \
(TT\ ]
)TT] ^
)TT^ _
;TT_ `
returnUU 
OkUU 
(UU 
transitionsUU !
)UU! "
;UU" #
}VV 	
catchWW 
(WW  
KeyNotFoundExceptionWW #
)WW# $
{XX 	
returnYY 
NotFoundYY 
(YY 
)YY 
;YY 
}ZZ 	
}[[ 
[]] 
HttpPost]] 
(]] 
$str]] 
)]] 
]]] 
[^^  
ProducesResponseType^^ 
(^^ 
StatusCodes^^ %
.^^% &
Status204NoContent^^& 8
)^^8 9
]^^9 :
[__  
ProducesResponseType__ 
(__ 
StatusCodes__ %
.__% &
Status404NotFound__& 7
)__7 8
]__8 9
[``  
ProducesResponseType`` 
(`` 
StatusCodes`` %
.``% &
Status400BadRequest``& 9
)``9 :
]``: ;
[aa  
ProducesResponseTypeaa 
(aa 
StatusCodesaa %
.aa% &!
Status401Unauthorizedaa& ;
)aa; <
]aa< =
publicbb 

asyncbb 
Taskbb 
<bb 
IActionResultbb #
>bb# $
ChangeStatusbb% 1
(bb1 2
intbb2 5
idbb6 8
,bb8 9
[bb: ;
FromBodybb; C
]bbC D
intbbE H
newStatusIdbbI T
)bbT U
{cc 
trydd 
{ee 	
varff 
dtoff 
=ff 
newff 
ChangeStatusDtoff )
(ff) *
newStatusIdff* 5
,ff5 6
GetCurrentUserIdff7 G
(ffG H
)ffH I
)ffI J
;ffJ K
awaitgg 
_servicegg 
.gg 
ChangeStatusAsyncgg ,
(gg, -
idgg- /
,gg/ 0
dtogg1 4
)gg4 5
;gg5 6
returnhh 
	NoContenthh 
(hh 
)hh 
;hh 
}ii 	
catchjj 
(jj  
KeyNotFoundExceptionjj #
)jj# $
{jj% &
returnjj' -
NotFoundjj. 6
(jj6 7
)jj7 8
;jj8 9
}jj: ;
catchkk 
(kk %
InvalidOperationExceptionkk (
exkk) +
)kk+ ,
{kk- .
returnkk/ 5

BadRequestkk6 @
(kk@ A
newkkA D
{kkE F
errorkkG L
=kkM N
exkkO Q
.kkQ R
MessagekkR Y
}kkZ [
)kk[ \
;kk\ ]
}kk^ _
catchll 
(ll '
UnauthorizedAccessExceptionll *
exll+ -
)ll- .
{ll/ 0
returnll1 7
Unauthorizedll8 D
(llD E
newllE H
{llI J
errorllK P
=llQ R
exllS U
.llU V
MessagellV ]
}ll^ _
)ll_ `
;ll` a
}llb c
}mm 
publicoo 

recordoo 
AssignTicketRequestoo %
(oo% &
Listoo& *
<oo* +
intoo+ .
>oo. /
UserIdsoo0 7
,oo7 8
Listoo9 =
<oo= >
intoo> A
>ooA B
GroupIdsooC K
,ooK L
intooM P
?ooP Q
ParentAssignmentIdooR d
=ooe f
nulloog k
)ook l
;ool m
[qq 
HttpPostqq 
(qq 
$strqq 
)qq 
]qq 
[rr  
ProducesResponseTyperr 
(rr 
StatusCodesrr %
.rr% &
Status204NoContentrr& 8
)rr8 9
]rr9 :
publicss 

asyncss 
Taskss 
<ss 
IActionResultss #
>ss# $
AssignTicketss% 1
(ss1 2
intss2 5
idss6 8
,ss8 9
[ss: ;
FromBodyss; C
]ssC D
AssignTicketRequestssE X
reqssY \
)ss\ ]
{tt 
tryuu 
{vv 	
varww 
dtoww 
=ww 
newww 
AssignTicketDtoww )
(ww) *
reqww* -
.ww- .
UserIdsww. 5
??ww6 8
newww9 <
Listww= A
<wwA B
intwwB E
>wwE F
(wwF G
)wwG H
,wwH I
reqwwJ M
.wwM N
GroupIdswwN V
??wwW Y
newwwZ ]
Listww^ b
<wwb c
intwwc f
>wwf g
(wwg h
)wwh i
,wwi j
GetCurrentUserIdwwk {
(ww{ |
)ww| }
,ww} ~
req	ww Ç
.
wwÇ É 
ParentAssignmentId
wwÉ ï
)
wwï ñ
;
wwñ ó
awaitxx 
_servicexx 
.xx 
AssignTicketAsyncxx ,
(xx, -
idxx- /
,xx/ 0
dtoxx1 4
)xx4 5
;xx5 6
returnyy 
	NoContentyy 
(yy 
)yy 
;yy 
}zz 	
catch{{ 
({{  
KeyNotFoundException{{ #
){{# $
{{{% &
return{{' -
NotFound{{. 6
({{6 7
){{7 8
;{{8 9
}{{: ;
catch|| 
(|| '
UnauthorizedAccessException|| *
ex||+ -
)||- .
{||/ 0
return||1 7
Unauthorized||8 D
(||D E
new||E H
{||I J
error||K P
=||Q R
ex||S U
.||U V
Message||V ]
}||^ _
)||_ `
;||` a
}||b c
}}} 
[ 
HttpGet 
( 
$str $
)$ %
]% &
[
ÄÄ "
ProducesResponseType
ÄÄ 
(
ÄÄ 
typeof
ÄÄ  
(
ÄÄ  !
IEnumerable
ÄÄ! ,
<
ÄÄ, -
TicketAssigneeDto
ÄÄ- >
>
ÄÄ> ?
)
ÄÄ? @
,
ÄÄ@ A
StatusCodes
ÄÄB M
.
ÄÄM N
Status200OK
ÄÄN Y
)
ÄÄY Z
]
ÄÄZ [
public
ÅÅ 

async
ÅÅ 
Task
ÅÅ 
<
ÅÅ 
IActionResult
ÅÅ #
>
ÅÅ# $
GetAssignmentTree
ÅÅ% 6
(
ÅÅ6 7
int
ÅÅ7 :
id
ÅÅ; =
)
ÅÅ= >
{
ÇÇ 
try
ÉÉ 
{
ÑÑ 	
var
ÖÖ 
tree
ÖÖ 
=
ÖÖ 
await
ÖÖ 
_service
ÖÖ %
.
ÖÖ% &$
GetAssignmentTreeAsync
ÖÖ& <
(
ÖÖ< =
id
ÖÖ= ?
)
ÖÖ? @
;
ÖÖ@ A
return
ÜÜ 
Ok
ÜÜ 
(
ÜÜ 
tree
ÜÜ 
)
ÜÜ 
;
ÜÜ 
}
áá 	
catch
àà 
(
àà "
KeyNotFoundException
àà #
)
àà# $
{
àà% &
return
àà' -
NotFound
àà. 6
(
àà6 7
)
àà7 8
;
àà8 9
}
àà: ;
}
ââ 
[
ãã 
HttpPost
ãã 
(
ãã 
$str
ãã 
)
ãã 
]
ãã 
[
åå "
ProducesResponseType
åå 
(
åå 
StatusCodes
åå %
.
åå% & 
Status204NoContent
åå& 8
)
åå8 9
]
åå9 :
public
çç 

async
çç 
Task
çç 
<
çç 
IActionResult
çç #
>
çç# $
TransferTicket
çç% 3
(
çç3 4
int
çç4 7
id
çç8 :
,
çç: ;
[
çç< =
FromBody
çç= E
]
ççE F
TransferTicketDto
ççG X
dto
ççY \
)
çç\ ]
{
éé 
try
èè 
{
êê 	
var
ëë 
transferDto
ëë 
=
ëë 
new
ëë !
TransferTicketDto
ëë" 3
(
ëë3 4
dto
ëë4 7
.
ëë7 8
	ProjectId
ëë8 A
,
ëëA B
dto
ëëC F
.
ëëF G
GroupId
ëëG N
,
ëëN O
GetCurrentUserId
ëëP `
(
ëë` a
)
ëëa b
)
ëëb c
;
ëëc d
await
íí 
_service
íí 
.
íí !
TransferTicketAsync
íí .
(
íí. /
id
íí/ 1
,
íí1 2
transferDto
íí3 >
)
íí> ?
;
íí? @
return
ìì 
	NoContent
ìì 
(
ìì 
)
ìì 
;
ìì 
}
îî 	
catch
ïï 
(
ïï "
KeyNotFoundException
ïï #
)
ïï# $
{
ïï% &
return
ïï' -
NotFound
ïï. 6
(
ïï6 7
)
ïï7 8
;
ïï8 9
}
ïï: ;
catch
ññ 
(
ññ )
UnauthorizedAccessException
ññ *
ex
ññ+ -
)
ññ- .
{
ññ/ 0
return
ññ1 7
Unauthorized
ññ8 D
(
ññD E
new
ññE H
{
ññI J
error
ññK P
=
ññQ R
ex
ññS U
.
ññU V
Message
ññV ]
}
ññ^ _
)
ññ_ `
;
ññ` a
}
ññb c
}
óó 
[
ôô 
HttpPost
ôô 
(
ôô 
$str
ôô 
)
ôô 
]
ôô 
[
öö "
ProducesResponseType
öö 
(
öö 
typeof
öö  
(
öö  !
TicketCommentDto
öö! 1
)
öö1 2
,
öö2 3
StatusCodes
öö4 ?
.
öö? @
Status201Created
öö@ P
)
ööP Q
]
ööQ R
public
õõ 

async
õõ 
Task
õõ 
<
õõ 
IActionResult
õõ #
>
õõ# $

AddComment
õõ% /
(
õõ/ 0
int
õõ0 3
id
õõ4 6
,
õõ6 7
[
õõ8 9
FromBody
õõ9 A
]
õõA B
CreateCommentDto
õõC S
dto
õõT W
)
õõW X
{
úú 
var
ùù 
	createDto
ùù 
=
ùù 
new
ùù 
CreateCommentDto
ùù ,
(
ùù, -
dto
ùù- 0
.
ùù0 1
Content
ùù1 8
,
ùù8 9
dto
ùù: =
.
ùù= >

IsInternal
ùù> H
,
ùùH I
GetCurrentUserId
ùùJ Z
(
ùùZ [
)
ùù[ \
,
ùù\ ]
dto
ùù^ a
.
ùùa b
ParentCommentId
ùùb q
,
ùùq r
dto
ùùs v
.
ùùv w
MentionedUserIdsùùw á
)ùùá à
;ùùà â
var
ûû 
result
ûû 
=
ûû 
await
ûû 
_service
ûû #
.
ûû# $
AddCommentAsync
ûû$ 3
(
ûû3 4
id
ûû4 6
,
ûû6 7
	createDto
ûû8 A
)
ûûA B
;
ûûB C
return
üü 
Ok
üü 
(
üü 
result
üü 
)
üü 
;
üü 
}
†† 
[
¢¢ 
HttpPut
¢¢ 
(
¢¢ 
$str
¢¢ (
)
¢¢( )
]
¢¢) *
[
££ "
ProducesResponseType
££ 
(
££ 
typeof
££  
(
££  !
TicketCommentDto
££! 1
)
££1 2
,
££2 3
StatusCodes
££4 ?
.
££? @
Status200OK
££@ K
)
££K L
]
££L M
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
§§# $
UpdateComment
§§% 2
(
§§2 3
int
§§3 6
id
§§7 9
,
§§9 :
int
§§; >
	commentId
§§? H
,
§§H I
[
§§J K
FromBody
§§K S
]
§§S T
UpdateCommentDto
§§U e
dto
§§f i
)
§§i j
{
•• 
bool
¶¶ 
hasEditPerm
¶¶ 
=
¶¶ 
User
¶¶ 
.
¶¶  
HasClaim
¶¶  (
(
¶¶( )
c
¶¶) *
=>
¶¶+ -
c
¶¶. /
.
¶¶/ 0
Type
¶¶0 4
==
¶¶5 7
$str
¶¶8 D
&&
¶¶E G
c
¶¶H I
.
¶¶I J
Value
¶¶J O
==
¶¶P R
$str
¶¶S h
)
¶¶h i
;
¶¶i j
try
ßß 
{
®® 	
var
©© 
result
©© 
=
©© 
await
©© 
_service
©© '
.
©©' ( 
UpdateCommentAsync
©©( :
(
©©: ;
id
©©; =
,
©©= >
	commentId
©©? H
,
©©H I
dto
©©J M
,
©©M N
GetCurrentUserId
©©O _
(
©©_ `
)
©©` a
,
©©a b
hasEditPerm
©©c n
)
©©n o
;
©©o p
return
™™ 
Ok
™™ 
(
™™ 
result
™™ 
)
™™ 
;
™™ 
}
´´ 	
catch
¨¨ 
(
¨¨ "
KeyNotFoundException
¨¨ #
)
¨¨# $
{
¨¨% &
return
¨¨' -
NotFound
¨¨. 6
(
¨¨6 7
)
¨¨7 8
;
¨¨8 9
}
¨¨: ;
catch
≠≠ 
(
≠≠ )
UnauthorizedAccessException
≠≠ *
ex
≠≠+ -
)
≠≠- .
{
≠≠/ 0
return
≠≠1 7
Unauthorized
≠≠8 D
(
≠≠D E
new
≠≠E H
{
≠≠I J
error
≠≠K P
=
≠≠Q R
ex
≠≠S U
.
≠≠U V
Message
≠≠V ]
}
≠≠^ _
)
≠≠_ `
;
≠≠` a
}
≠≠b c
}
ÆÆ 
[
∞∞ 

HttpDelete
∞∞ 
(
∞∞ 
$str
∞∞ +
)
∞∞+ ,
]
∞∞, -
[
±± "
ProducesResponseType
±± 
(
±± 
StatusCodes
±± %
.
±±% & 
Status204NoContent
±±& 8
)
±±8 9
]
±±9 :
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
≤≤# $
DeleteComment
≤≤% 2
(
≤≤2 3
int
≤≤3 6
id
≤≤7 9
,
≤≤9 :
int
≤≤; >
	commentId
≤≤? H
)
≤≤H I
{
≥≥ 
bool
¥¥ 
hasDeletePerm
¥¥ 
=
¥¥ 
User
¥¥ !
.
¥¥! "
HasClaim
¥¥" *
(
¥¥* +
c
¥¥+ ,
=>
¥¥- /
c
¥¥0 1
.
¥¥1 2
Type
¥¥2 6
==
¥¥7 9
$str
¥¥: F
&&
¥¥G I
c
¥¥J K
.
¥¥K L
Value
¥¥L Q
==
¥¥R T
$str
¥¥U l
)
¥¥l m
;
¥¥m n
try
µµ 
{
∂∂ 	
await
∑∑ 
_service
∑∑ 
.
∑∑  
DeleteCommentAsync
∑∑ -
(
∑∑- .
id
∑∑. 0
,
∑∑0 1
	commentId
∑∑2 ;
,
∑∑; <
GetCurrentUserId
∑∑= M
(
∑∑M N
)
∑∑N O
,
∑∑O P
hasDeletePerm
∑∑Q ^
)
∑∑^ _
;
∑∑_ `
return
∏∏ 
	NoContent
∏∏ 
(
∏∏ 
)
∏∏ 
;
∏∏ 
}
ππ 	
catch
∫∫ 
(
∫∫ "
KeyNotFoundException
∫∫ #
)
∫∫# $
{
∫∫% &
return
∫∫' -
NotFound
∫∫. 6
(
∫∫6 7
)
∫∫7 8
;
∫∫8 9
}
∫∫: ;
catch
ªª 
(
ªª )
UnauthorizedAccessException
ªª *
ex
ªª+ -
)
ªª- .
{
ªª/ 0
return
ªª1 7
Unauthorized
ªª8 D
(
ªªD E
new
ªªE H
{
ªªI J
error
ªªK P
=
ªªQ R
ex
ªªS U
.
ªªU V
Message
ªªV ]
}
ªª^ _
)
ªª_ `
;
ªª` a
}
ªªb c
}
ºº 
[
ææ 
HttpPost
ææ 
(
ææ 
$str
ææ 1
)
ææ1 2
]
ææ2 3
[
øø "
ProducesResponseType
øø 
(
øø 
StatusCodes
øø %
.
øø% & 
Status204NoContent
øø& 8
)
øø8 9
]
øø9 :
public
¿¿ 

async
¿¿ 
Task
¿¿ 
<
¿¿ 
IActionResult
¿¿ #
>
¿¿# $
RestoreComment
¿¿% 3
(
¿¿3 4
int
¿¿4 7
id
¿¿8 :
,
¿¿: ;
int
¿¿< ?
	commentId
¿¿@ I
)
¿¿I J
{
¡¡ 
bool
¬¬ 
hasDeletePerm
¬¬ 
=
¬¬ 
User
¬¬ !
.
¬¬! "
HasClaim
¬¬" *
(
¬¬* +
c
¬¬+ ,
=>
¬¬- /
c
¬¬0 1
.
¬¬1 2
Type
¬¬2 6
==
¬¬7 9
$str
¬¬: F
&&
¬¬G I
c
¬¬J K
.
¬¬K L
Value
¬¬L Q
==
¬¬R T
$str
¬¬U l
)
¬¬l m
;
¬¬m n
try
√√ 
{
ƒƒ 	
await
≈≈ 
_service
≈≈ 
.
≈≈ !
RestoreCommentAsync
≈≈ .
(
≈≈. /
id
≈≈/ 1
,
≈≈1 2
	commentId
≈≈3 <
,
≈≈< =
GetCurrentUserId
≈≈> N
(
≈≈N O
)
≈≈O P
,
≈≈P Q
hasDeletePerm
≈≈R _
)
≈≈_ `
;
≈≈` a
return
∆∆ 
	NoContent
∆∆ 
(
∆∆ 
)
∆∆ 
;
∆∆ 
}
«« 	
catch
»» 
(
»» "
KeyNotFoundException
»» #
)
»»# $
{
»»% &
return
»»' -
NotFound
»». 6
(
»»6 7
)
»»7 8
;
»»8 9
}
»»: ;
catch
…… 
(
…… )
UnauthorizedAccessException
…… *
ex
……+ -
)
……- .
{
……/ 0
return
……1 7
Unauthorized
……8 D
(
……D E
new
……E H
{
……I J
error
……K P
=
……Q R
ex
……S U
.
……U V
Message
……V ]
}
……^ _
)
……_ `
;
……` a
}
……b c
}
   
[
ÃÃ 
HttpGet
ÃÃ 
(
ÃÃ 
$str
ÃÃ 
)
ÃÃ 
]
ÃÃ 
[
ÕÕ "
ProducesResponseType
ÕÕ 
(
ÕÕ 
typeof
ÕÕ  
(
ÕÕ  !
IEnumerable
ÕÕ! ,
<
ÕÕ, -
TicketCommentDto
ÕÕ- =
>
ÕÕ= >
)
ÕÕ> ?
,
ÕÕ? @
StatusCodes
ÕÕA L
.
ÕÕL M
Status200OK
ÕÕM X
)
ÕÕX Y
]
ÕÕY Z
public
ŒŒ 

async
ŒŒ 
Task
ŒŒ 
<
ŒŒ 
IActionResult
ŒŒ #
>
ŒŒ# $
GetComments
ŒŒ% 0
(
ŒŒ0 1
int
ŒŒ1 4
id
ŒŒ5 7
)
ŒŒ7 8
{
œœ 
bool
–– 
hasInternalPerm
–– 
=
–– 
User
–– #
.
––# $
HasClaim
––$ ,
(
––, -
c
––- .
=>
––/ 1
c
––2 3
.
––3 4
Type
––4 8
==
––9 ;
$str
––< H
&&
––I K
c
––L M
.
––M N
Value
––N S
==
––T V
$str
––W p
)
––p q
;
––q r
var
—— 
result
—— 
=
—— 
await
—— 
_service
—— #
.
——# $
GetCommentsAsync
——$ 4
(
——4 5
id
——5 7
,
——7 8
hasInternalPerm
——9 H
)
——H I
;
——I J
return
““ 
Ok
““ 
(
““ 
result
““ 
)
““ 
;
““ 
}
”” 
[
’’ 
HttpPost
’’ 
(
’’ 
$str
’’  
)
’’  !
]
’’! "
[
÷÷ "
ProducesResponseType
÷÷ 
(
÷÷ 
typeof
÷÷  
(
÷÷  !!
TicketAttachmentDto
÷÷! 4
)
÷÷4 5
,
÷÷5 6
StatusCodes
÷÷7 B
.
÷÷B C
Status201Created
÷÷C S
)
÷÷S T
]
÷÷T U
[
◊◊ "
ProducesResponseType
◊◊ 
(
◊◊ 
StatusCodes
◊◊ %
.
◊◊% &!
Status400BadRequest
◊◊& 9
)
◊◊9 :
]
◊◊: ;
public
ÿÿ 

async
ÿÿ 
Task
ÿÿ 
<
ÿÿ 
IActionResult
ÿÿ #
>
ÿÿ# $
AddAttachment
ÿÿ% 2
(
ÿÿ2 3
int
ÿÿ3 6
id
ÿÿ7 9
,
ÿÿ9 :
	IFormFile
ÿÿ; D
file
ÿÿE I
)
ÿÿI J
{
ŸŸ 
try
⁄⁄ 
{
€€ 	
var
‹‹ 
result
‹‹ 
=
‹‹ 
await
‹‹ 
_service
‹‹ '
.
‹‹' ( 
AddAttachmentAsync
‹‹( :
(
‹‹: ;
id
‹‹; =
,
‹‹= >
file
‹‹? C
,
‹‹C D
GetCurrentUserId
‹‹E U
(
‹‹U V
)
‹‹V W
)
‹‹W X
;
‹‹X Y
return
›› 
Ok
›› 
(
›› 
result
›› 
)
›› 
;
›› 
}
ﬁﬁ 	
catch
ﬂﬂ 
(
ﬂﬂ '
InvalidOperationException
ﬂﬂ (
ex
ﬂﬂ) +
)
ﬂﬂ+ ,
{
ﬂﬂ- .
return
ﬂﬂ/ 5

BadRequest
ﬂﬂ6 @
(
ﬂﬂ@ A
new
ﬂﬂA D
{
ﬂﬂE F
error
ﬂﬂG L
=
ﬂﬂM N
ex
ﬂﬂO Q
.
ﬂﬂQ R
Message
ﬂﬂR Y
}
ﬂﬂZ [
)
ﬂﬂ[ \
;
ﬂﬂ\ ]
}
ﬂﬂ^ _
}
‡‡ 
[
‚‚ 
HttpGet
‚‚ 
(
‚‚ 
$str
‚‚ 
)
‚‚  
]
‚‚  !
[
„„ "
ProducesResponseType
„„ 
(
„„ 
typeof
„„  
(
„„  !
IEnumerable
„„! ,
<
„„, -!
TicketAttachmentDto
„„- @
>
„„@ A
)
„„A B
,
„„B C
StatusCodes
„„D O
.
„„O P
Status200OK
„„P [
)
„„[ \
]
„„\ ]
public
‰‰ 

async
‰‰ 
Task
‰‰ 
<
‰‰ 
IActionResult
‰‰ #
>
‰‰# $
GetAttachments
‰‰% 3
(
‰‰3 4
int
‰‰4 7
id
‰‰8 :
)
‰‰: ;
{
ÂÂ 
return
ÊÊ 
Ok
ÊÊ 
(
ÊÊ 
await
ÊÊ 
_service
ÊÊ  
.
ÊÊ  !!
GetAttachmentsAsync
ÊÊ! 4
(
ÊÊ4 5
id
ÊÊ5 7
)
ÊÊ7 8
)
ÊÊ8 9
;
ÊÊ9 :
}
ÁÁ 
[
ÈÈ 
AllowAnonymous
ÈÈ 
]
ÈÈ 
[
ÍÍ 
HttpGet
ÍÍ 
(
ÍÍ 
$str
ÍÍ 7
)
ÍÍ7 8
]
ÍÍ8 9
public
ÎÎ 

async
ÎÎ 
Task
ÎÎ 
<
ÎÎ 
IActionResult
ÎÎ #
>
ÎÎ# $ 
DownloadAttachment
ÎÎ% 7
(
ÎÎ7 8
int
ÎÎ8 ;
id
ÎÎ< >
,
ÎÎ> ?
int
ÎÎ@ C
attachmentId
ÎÎD P
)
ÎÎP Q
{
ÏÏ 
try
ÌÌ 
{
ÓÓ 	
var
ÔÔ 
(
ÔÔ 
filePath
ÔÔ 
,
ÔÔ 
contentType
ÔÔ &
,
ÔÔ& '
fileName
ÔÔ( 0
)
ÔÔ0 1
=
ÔÔ2 3
await
ÔÔ4 9
_service
ÔÔ: B
.
ÔÔB C(
GetAttachmentFileInfoAsync
ÔÔC ]
(
ÔÔ] ^
id
ÔÔ^ `
,
ÔÔ` a
attachmentId
ÔÔb n
)
ÔÔn o
;
ÔÔo p
if
 
(
 
!
 
System
 
.
 
IO
 
.
 
File
 
.
  
Exists
  &
(
& '
filePath
' /
)
/ 0
)
0 1
return
ÒÒ 
NotFound
ÒÒ 
(
ÒÒ  
)
ÒÒ  !
;
ÒÒ! "
return
ÛÛ 
PhysicalFile
ÛÛ 
(
ÛÛ  
System
ÛÛ  &
.
ÛÛ& '
IO
ÛÛ' )
.
ÛÛ) *
Path
ÛÛ* .
.
ÛÛ. /
GetFullPath
ÛÛ/ :
(
ÛÛ: ;
filePath
ÛÛ; C
)
ÛÛC D
,
ÛÛD E
contentType
ÛÛF Q
,
ÛÛQ R
fileName
ÛÛS [
)
ÛÛ[ \
;
ÛÛ\ ]
}
ÙÙ 	
catch
ıı 
(
ıı "
KeyNotFoundException
ıı #
)
ıı# $
{
ˆˆ 	
return
˜˜ 
NotFound
˜˜ 
(
˜˜ 
)
˜˜ 
;
˜˜ 
}
¯¯ 	
}
˘˘ 
[
˚˚ 

HttpDelete
˚˚ 
(
˚˚ 
$str
˚˚ 1
)
˚˚1 2
]
˚˚2 3
public
¸¸ 

async
¸¸ 
Task
¸¸ 
<
¸¸ 
IActionResult
¸¸ #
>
¸¸# $
DeleteAttachment
¸¸% 5
(
¸¸5 6
int
¸¸6 9
id
¸¸: <
,
¸¸< =
int
¸¸> A
attachmentId
¸¸B N
)
¸¸N O
{
˝˝ 
bool
˛˛ 
	hasManage
˛˛ 
=
˛˛ 
User
˛˛ 
.
˛˛ 
HasClaim
˛˛ &
(
˛˛& '
c
˛˛' (
=>
˛˛) +
c
˛˛, -
.
˛˛- .
Type
˛˛. 2
==
˛˛3 5
$str
˛˛6 B
&&
˛˛C E
c
˛˛F G
.
˛˛G H
Value
˛˛H M
==
˛˛N P
$str
˛˛Q `
)
˛˛` a
||
˛˛b d
User
ˇˇ 
.
ˇˇ 
HasClaim
ˇˇ &
(
ˇˇ& '
c
ˇˇ' (
=>
ˇˇ) +
c
ˇˇ, -
.
ˇˇ- .
Type
ˇˇ. 2
==
ˇˇ3 5

ClaimTypes
ˇˇ6 @
.
ˇˇ@ A
Role
ˇˇA E
&&
ˇˇF H
c
ˇˇI J
.
ˇˇJ K
Value
ˇˇK P
==
ˇˇQ S
$str
ˇˇT `
)
ˇˇ` a
;
ˇˇa b
try
ÄÄ 
{
ÅÅ 	
await
ÇÇ 
_service
ÇÇ 
.
ÇÇ #
DeleteAttachmentAsync
ÇÇ 0
(
ÇÇ0 1
id
ÇÇ1 3
,
ÇÇ3 4
attachmentId
ÇÇ5 A
,
ÇÇA B
GetCurrentUserId
ÇÇC S
(
ÇÇS T
)
ÇÇT U
,
ÇÇU V
	hasManage
ÇÇW `
)
ÇÇ` a
;
ÇÇa b
return
ÉÉ 
	NoContent
ÉÉ 
(
ÉÉ 
)
ÉÉ 
;
ÉÉ 
}
ÑÑ 	
catch
ÖÖ 
(
ÖÖ )
UnauthorizedAccessException
ÖÖ *
ex
ÖÖ+ -
)
ÖÖ- .
{
ÜÜ 	
return
áá 

StatusCode
áá 
(
áá 
$num
áá !
,
áá! "
new
áá# &
{
áá' (
error
áá) .
=
áá/ 0
ex
áá1 3
.
áá3 4
Message
áá4 ;
}
áá< =
)
áá= >
;
áá> ?
}
àà 	
catch
ââ 
(
ââ "
KeyNotFoundException
ââ #
ex
ââ$ &
)
ââ& '
{
ää 	
return
ãã 

StatusCode
ãã 
(
ãã 
$num
ãã !
,
ãã! "
new
ãã# &
{
ãã' (
error
ãã) .
=
ãã/ 0
ex
ãã1 3
.
ãã3 4
Message
ãã4 ;
}
ãã< =
)
ãã= >
;
ãã> ?
}
åå 	
}
çç 
[
èè 
HttpGet
èè 
(
èè 
$str
èè 
)
èè 
]
èè 
[
êê "
ProducesResponseType
êê 
(
êê 
typeof
êê  
(
êê  !
IEnumerable
êê! ,
<
êê, -
TimelineEventDto
êê- =
>
êê= >
)
êê> ?
,
êê? @
StatusCodes
êêA L
.
êêL M
Status200OK
êêM X
)
êêX Y
]
êêY Z
public
ëë 

async
ëë 
Task
ëë 
<
ëë 
IActionResult
ëë #
>
ëë# $
GetTimeline
ëë% 0
(
ëë0 1
int
ëë1 4
id
ëë5 7
)
ëë7 8
{
íí 
bool
ìì 
hasInternalPerm
ìì 
=
ìì 
User
ìì #
.
ìì# $
HasClaim
ìì$ ,
(
ìì, -
c
ìì- .
=>
ìì/ 1
c
ìì2 3
.
ìì3 4
Type
ìì4 8
==
ìì9 ;
$str
ìì< H
&&
ììI K
c
ììL M
.
ììM N
Value
ììN S
==
ììT V
$str
ììW p
)
ììp q
||
ììr t
User
îî #
.
îî# $
HasClaim
îî$ ,
(
îî, -
c
îî- .
=>
îî/ 1
c
îî2 3
.
îî3 4
Type
îî4 8
==
îî9 ;

ClaimTypes
îî< F
.
îîF G
Role
îîG K
&&
îîL N
c
îîO P
.
îîP Q
Value
îîQ V
==
îîW Y
$str
îîZ f
)
îîf g
;
îîg h
return
ïï 
Ok
ïï 
(
ïï 
await
ïï 
_service
ïï  
.
ïï  !
GetTimelineAsync
ïï! 1
(
ïï1 2
id
ïï2 4
,
ïï4 5
hasInternalPerm
ïï6 E
)
ïïE F
)
ïïF G
;
ïïG H
}
ññ 
[
òò 
HttpGet
òò 
(
òò 
$str
òò 
)
òò 
]
òò 
public
ôô 

async
ôô 
Task
ôô 
<
ôô 
IActionResult
ôô #
>
ôô# $
Search
ôô% +
(
ôô+ ,
[
ôô, -
	FromQuery
ôô- 6
]
ôô6 7#
TicketSearchFilterDto
ôô8 M
filter
ôôN T
)
ôôT U
{
öö 
var
õõ 
result
õõ 
=
õõ 
await
õõ 
_service
õõ #
.
õõ# $ 
SearchTicketsAsync
õõ$ 6
(
õõ6 7
filter
õõ7 =
,
õõ= >
GetCurrentUserId
õõ? O
(
õõO P
)
õõP Q
)
õõQ R
;
õõR S
return
úú 
Ok
úú 
(
úú 
result
úú 
)
úú 
;
úú 
}
ùù 
[
üü 
HttpPost
üü 
(
üü 
$str
üü 
)
üü 
]
üü 
[
†† "
ProducesResponseType
†† 
(
†† 
typeof
††  
(
††  !
TicketSurveyDto
††! 0
)
††0 1
,
††1 2
StatusCodes
††3 >
.
††> ?
Status201Created
††? O
)
††O P
]
††P Q
[
°° "
ProducesResponseType
°° 
(
°° 
StatusCodes
°° %
.
°°% &!
Status400BadRequest
°°& 9
)
°°9 :
]
°°: ;
public
¢¢ 

async
¢¢ 
Task
¢¢ 
<
¢¢ 
IActionResult
¢¢ #
>
¢¢# $
SubmitSurvey
¢¢% 1
(
¢¢1 2
int
¢¢2 5
id
¢¢6 8
,
¢¢8 9
[
¢¢: ;
FromBody
¢¢; C
]
¢¢C D#
SubmitTicketSurveyDto
¢¢E Z
dto
¢¢[ ^
)
¢¢^ _
{
££ 
try
§§ 
{
•• 	
var
¶¶ 
result
¶¶ 
=
¶¶ 
await
¶¶ 
_service
¶¶ '
.
¶¶' (
SubmitSurveyAsync
¶¶( 9
(
¶¶9 :
id
¶¶: <
,
¶¶< =
dto
¶¶> A
,
¶¶A B
GetCurrentUserId
¶¶C S
(
¶¶S T
)
¶¶T U
)
¶¶U V
;
¶¶V W
return
ßß 
CreatedAtAction
ßß "
(
ßß" #
nameof
ßß# )
(
ßß) *
	GetTicket
ßß* 3
)
ßß3 4
,
ßß4 5
new
ßß6 9
{
ßß: ;
id
ßß< >
=
ßß? @
result
ßßA G
.
ßßG H
TicketId
ßßH P
}
ßßQ R
,
ßßR S
result
ßßT Z
)
ßßZ [
;
ßß[ \
}
®® 	
catch
©© 
(
©© '
InvalidOperationException
©© (
ex
©©) +
)
©©+ ,
{
©©- .
return
©©/ 5

BadRequest
©©6 @
(
©©@ A
new
©©A D
{
©©E F
error
©©G L
=
©©M N
ex
©©O Q
.
©©Q R
Message
©©R Y
}
©©Z [
)
©©[ \
;
©©\ ]
}
©©^ _
catch
™™ 
(
™™ )
UnauthorizedAccessException
™™ *
ex
™™+ -
)
™™- .
{
™™/ 0
return
™™1 7
Unauthorized
™™8 D
(
™™D E
new
™™E H
{
™™I J
error
™™K P
=
™™Q R
ex
™™S U
.
™™U V
Message
™™V ]
}
™™^ _
)
™™_ `
;
™™` a
}
™™b c
catch
´´ 
(
´´ "
KeyNotFoundException
´´ #
)
´´# $
{
´´% &
return
´´' -
NotFound
´´. 6
(
´´6 7
)
´´7 8
;
´´8 9
}
´´: ;
}
¨¨ 
}≠≠ á
Z/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/TestController.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
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
class		 
TestController		 
:		 
ControllerBase		 ,
{		- .
private

 
readonly

 
IRoleService

 !
_roleService

" .
;

. /
public 

TestController 
( 
IRoleService &
roleService' 2
)2 3
{4 5
_roleService6 B
=C D
roleServiceE P
;P Q
}R S
[ 
HttpGet 
( 
$str 
) 
] 
[ 
AllowAnonymous 
] 
public 

async 
Task 
< 
IActionResult #
># $
GetRoles% -
(- .
). /
{0 1
var 
roles 
= 
await 
_roleService &
.& '
GetAllAsync' 2
(2 3
)3 4
;4 5
var 
str 
= 
string 
. 
Join 
( 
$str "
," #
roles$ )
.) *
Select* 0
(0 1
r1 2
=>3 5
$"6 8
{8 9
r9 :
.: ;
Name; ?
}? @
$str@ B
{B C
stringC I
.I J
JoinJ N
(N O
$strO R
,R S
rT U
.U V
PermissionsV a
??b d
Systeme k
.k l
Arrayl q
.q r
Emptyr w
<w x
stringx ~
>~ 
(	 Ä
)
Ä Å
)
Å Ç
}
Ç É
"
É Ñ
)
Ñ Ö
)
Ö Ü
;
Ü á
return 
Ok 
( 
str 
) 
; 
} 
} –5
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
}LL ì"
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
: 
CrudControllerBase 1
<1 2
RoleDto2 9
>9 :
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
} 
	protected 
override 
Task 
< 
IEnumerable '
<' (
RoleDto( /
>/ 0
>0 1
GetAllEntitiesAsync2 E
(E F
)F G
=>H J
_serviceK S
.S T
GetAllAsyncT _
(_ `
)` a
;a b
	protected 
override 
Task 
< 
RoleDto #
?# $
>$ %
GetEntityByIdAsync& 8
(8 9
int9 <
id= ?
)? @
=>A C
_serviceD L
.L M
GetByIdAsyncM Y
(Y Z
idZ \
)\ ]
;] ^
	protected 
override 
Task 
DeleteEntityAsync -
(- .
int. 1
id2 4
)4 5
=>6 8
_service9 A
.A B
DeleteAsyncB M
(M N
idN P
)P Q
;Q R
[ 
HttpPost 
] 
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status201Created& 6
)6 7
]7 8
public 

async 
Task 
< 
IActionResult #
># $
Create% +
(+ ,
[, -
FromBody- 5
]5 6
CreateRoleDto7 D
dtoE H
)H I
{ 
var 
created 
= 
await 
_service $
.$ %
CreateAsync% 0
(0 1
dto1 4
)4 5
;5 6
return 
CreatedAtAction 
( 
nameof %
(% &
GetById& -
)- .
,. /
new0 3
{4 5
id6 8
=9 :
created; B
.B C
IdC E
}F G
,G H
createdI P
)P Q
;Q R
} 
[   
HttpPut   
(   
$str   
)   
]   
[!!  
ProducesResponseType!! 
(!! 
StatusCodes!! %
.!!% &
Status204NoContent!!& 8
)!!8 9
]!!9 :
[""  
ProducesResponseType"" 
("" 
StatusCodes"" %
.""% &
Status404NotFound""& 7
)""7 8
]""8 9
public## 

async## 
Task## 
<## 
IActionResult## #
>### $
Update##% +
(##+ ,
int##, /
id##0 2
,##2 3
[##4 5
FromBody##5 =
]##= >
UpdateRoleDto##? L
dto##M P
)##P Q
{$$ 
try%% 
{&& 	
await'' 
_service'' 
.'' 
UpdateAsync'' &
(''& '
id''' )
,'') *
dto''+ .
)''. /
;''/ 0
return(( 
	NoContent(( 
((( 
)(( 
;(( 
})) 	
catch** 
(**  
KeyNotFoundException** #
)**# $
{++ 	
return,, 
NotFound,, 
(,, 
),, 
;,, 
}-- 	
}.. 
}00 ﬂ
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
} ô/
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
:  !
CrudControllerBase" 4
<4 5

ProjectDto5 ?
>? @
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
} 
	protected 
override 
Task 
< 
IEnumerable '
<' (

ProjectDto( 2
>2 3
>3 4
GetAllEntitiesAsync5 H
(H I
)I J
=>K M
_serviceN V
.V W
GetAllAsyncW b
(b c
)c d
;d e
	protected 
override 
Task 
< 

ProjectDto &
?& '
>' (
GetEntityByIdAsync) ;
(; <
int< ?
id@ B
)B C
=>D F
_serviceG O
.O P
GetByIdAsyncP \
(\ ]
id] _
)_ `
;` a
	protected 
override 
Task 
DeleteEntityAsync -
(- .
int. 1
id2 4
)4 5
=>6 8
_service9 A
.A B
DeleteAsyncB M
(M N
idN P
)P Q
;Q R
[ 
HttpPost 
] 
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status201Created& 6
)6 7
]7 8
public 

async 
Task 
< 
IActionResult #
># $
Create% +
(+ ,
[, -
FromBody- 5
]5 6
CreateProjectDto7 G
dtoH K
)K L
{ 
var 
created 
= 
await 
_service $
.$ %
CreateAsync% 0
(0 1
dto1 4
)4 5
;5 6
return 
CreatedAtAction 
( 
nameof %
(% &
GetById& -
)- .
,. /
new0 3
{4 5
id6 8
=9 :
created; B
.B C
IdC E
}F G
,G H
createdI P
)P Q
;Q R
} 
[   
HttpPut   
(   
$str   
)   
]   
[!!  
ProducesResponseType!! 
(!! 
StatusCodes!! %
.!!% &
Status204NoContent!!& 8
)!!8 9
]!!9 :
[""  
ProducesResponseType"" 
("" 
StatusCodes"" %
.""% &
Status404NotFound""& 7
)""7 8
]""8 9
public## 

async## 
Task## 
<## 
IActionResult## #
>### $
Update##% +
(##+ ,
int##, /
id##0 2
,##2 3
[##4 5
FromBody##5 =
]##= >
UpdateProjectDto##? O
dto##P S
)##S T
{$$ 
try%% 
{&& 	
await'' 
_service'' 
.'' 
UpdateAsync'' &
(''& '
id''' )
,'') *
dto''+ .
)''. /
;''/ 0
return(( 
	NoContent(( 
((( 
)(( 
;(( 
})) 	
catch** 
(**  
KeyNotFoundException** #
)**# $
{++ 	
return,, 
NotFound,, 
(,, 
),, 
;,, 
}-- 	
}.. 
[00 
HttpPost00 
(00 
$str00 %
)00% &
]00& '
[11  
ProducesResponseType11 
(11 
StatusCodes11 %
.11% &
Status204NoContent11& 8
)118 9
]119 :
public22 

async22 
Task22 
<22 
IActionResult22 #
>22# $
	AddMember22% .
(22. /
int22/ 2
id223 5
,225 6
int227 :
userId22; A
)22A B
{33 
await44 
_service44 
.44 
AddMemberAsync44 %
(44% &
id44& (
,44( )
userId44* 0
)440 1
;441 2
return55 
	NoContent55 
(55 
)55 
;55 
}66 
[88 

HttpDelete88 
(88 
$str88 '
)88' (
]88( )
[99  
ProducesResponseType99 
(99 
StatusCodes99 %
.99% &
Status204NoContent99& 8
)998 9
]999 :
public:: 

async:: 
Task:: 
<:: 
IActionResult:: #
>::# $
RemoveMember::% 1
(::1 2
int::2 5
id::6 8
,::8 9
int::: =
userId::> D
)::D E
{;; 
await<< 
_service<< 
.<< 
RemoveMemberAsync<< (
(<<( )
id<<) +
,<<+ ,
userId<<- 3
)<<3 4
;<<4 5
return== 
	NoContent== 
(== 
)== 
;== 
}>> 
}?? ƒW
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/PermissionsController.cs
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
class !
PermissionsController "
:# $
ControllerBase% 3
{ 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
private 
readonly !
IPermissionCalculator *!
_permissionCalculator+ @
;@ A
public 
!
PermissionsController  
(  !
ItsToolDbContext! 1
context2 9
,9 :!
IPermissionCalculator; P 
permissionCalculatorQ e
)e f
{ 
_context 
= 
context 
; !
_permissionCalculator 
=  
permissionCalculator  4
;4 5
} 
private 
async 
Task #
EnforceAdminAccessAsync .
(. /
int/ 2
userId3 9
)9 :
{ 
var 
perms 
= 
await !
_permissionCalculator /
./ 0.
"CalculateEffectivePermissionsAsync0 R
(R S
userIdS Y
)Y Z
;Z [
if 

( 
! 
perms 
. 
Contains 
( 
$str *
)* +
)+ ,
throw 
new '
UnauthorizedAccessException 1
(1 2
$str2 \
)\ ]
;] ^
} 
[!! 
HttpGet!! 
]!! 
public"" 

async"" 
Task"" 
<"" 
IActionResult"" #
>""# $
GetAll""% +
(""+ ,
)"", -
{## 
var$$ 
perms$$ 
=$$ 
await$$ 
_context$$ "
.$$" #
Permissions$$# .
.$$. /
Select$$/ 5
($$5 6
p$$6 7
=>$$8 :
new$$; >
PermissionDto$$? L
($$L M
p$$M N
.$$N O
Id$$O Q
,$$Q R
p$$S T
.$$T U
Name$$U Y
,$$Y Z
p$$[ \
.$$\ ]
Key$$] `
,$$` a
p$$b c
.$$c d
Description$$d o
)$$o p
)$$p q
.$$q r
ToListAsync$$r }
($$} ~
)$$~ 
;	$$ Ä
return%% 
Ok%% 
(%% 
perms%% 
)%% 
;%% 
}&& 
[(( 
HttpGet(( 
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
>))# $
GetById))% ,
()), -
int))- 0
id))1 3
)))3 4
{** 
var++ 
p++ 
=++ 
await++ 
_context++ 
.++ 
Permissions++ *
.++* +
	FindAsync+++ 4
(++4 5
id++5 7
)++7 8
;++8 9
if,, 

(,, 
p,, 
==,, 
null,, 
),, 
return,, 
NotFound,, &
(,,& '
),,' (
;,,( )
return-- 
Ok-- 
(-- 
new-- 
PermissionDto-- #
(--# $
p--$ %
.--% &
Id--& (
,--( )
p--* +
.--+ ,
Name--, 0
,--0 1
p--2 3
.--3 4
Key--4 7
,--7 8
p--9 :
.--: ;
Description--; F
)--F G
)--G H
;--H I
}.. 
[00 
HttpPost00 
]00 
public11 

async11 
Task11 
<11 
IActionResult11 #
>11# $
Create11% +
(11+ ,
[11, -
FromBody11- 5
]115 6
CreatePermissionDto117 J
dto11K N
)11N O
{22 
try33 
{44 	
var55 
userId55 
=55 
int55 
.55 
Parse55 "
(55" #
User55# '
.55' (
	FindFirst55( 1
(551 2
System552 8
.558 9
Security559 A
.55A B
Claims55B H
.55H I

ClaimTypes55I S
.55S T
NameIdentifier55T b
)55b c
?55c d
.55d e
Value55e j
??55k m
$str55n q
)55q r
;55r s
await66 #
EnforceAdminAccessAsync66 )
(66) *
userId66* 0
)660 1
;661 2
var88 
p88 
=88 
new88 

Permission88 "
{88# $
Name88% )
=88* +
dto88, /
.88/ 0
Name880 4
,884 5
Key886 9
=88: ;
dto88< ?
.88? @
Key88@ C
,88C D
Description88E P
=88Q R
dto88S V
.88V W
Description88W b
}88c d
;88d e
_context99 
.99 
Permissions99  
.99  !
Add99! $
(99$ %
p99% &
)99& '
;99' (
await:: 
_context:: 
.:: 
SaveChangesAsync:: +
(::+ ,
)::, -
;::- .
return;; 
Ok;; 
(;; 
new;; 
PermissionDto;; '
(;;' (
p;;( )
.;;) *
Id;;* ,
,;;, -
p;;. /
.;;/ 0
Name;;0 4
,;;4 5
p;;6 7
.;;7 8
Key;;8 ;
,;;; <
p;;= >
.;;> ?
Description;;? J
);;J K
);;K L
;;;L M
}<< 	
catch== 
(== '
UnauthorizedAccessException== *
ex==+ -
)==- .
{==/ 0
return==1 7
Forbid==8 >
(==> ?
ex==? A
.==A B
Message==B I
)==I J
;==J K
}==L M
}>> 
[@@ 
HttpPut@@ 
(@@ 
$str@@ 
)@@ 
]@@ 
publicAA 

asyncAA 
TaskAA 
<AA 
IActionResultAA #
>AA# $
UpdateAA% +
(AA+ ,
intAA, /
idAA0 2
,AA2 3
[AA4 5
FromBodyAA5 =
]AA= >
UpdatePermissionDtoAA? R
dtoAAS V
)AAV W
{BB 
tryCC 
{DD 	
varEE 
userIdEE 
=EE 
intEE 
.EE 
ParseEE "
(EE" #
UserEE# '
.EE' (
	FindFirstEE( 1
(EE1 2
SystemEE2 8
.EE8 9
SecurityEE9 A
.EEA B
ClaimsEEB H
.EEH I

ClaimTypesEEI S
.EES T
NameIdentifierEET b
)EEb c
?EEc d
.EEd e
ValueEEe j
??EEk m
$strEEn q
)EEq r
;EEr s
awaitFF #
EnforceAdminAccessAsyncFF )
(FF) *
userIdFF* 0
)FF0 1
;FF1 2
varHH 
pHH 
=HH 
awaitHH 
_contextHH "
.HH" #
PermissionsHH# .
.HH. /
	FindAsyncHH/ 8
(HH8 9
idHH9 ;
)HH; <
;HH< =
ifII 
(II 
pII 
==II 
nullII 
)II 
returnII !
NotFoundII" *
(II* +
)II+ ,
;II, -
pKK 
.KK 
NameKK 
=KK 
dtoKK 
.KK 
NameKK 
;KK 
pLL 
.LL 
KeyLL 
=LL 
dtoLL 
.LL 
KeyLL 
;LL 
pMM 
.MM 
DescriptionMM 
=MM 
dtoMM 
.MM  
DescriptionMM  +
;MM+ ,
awaitNN 
_contextNN 
.NN 
SaveChangesAsyncNN +
(NN+ ,
)NN, -
;NN- .
returnOO 
OkOO 
(OO 
newOO 
PermissionDtoOO '
(OO' (
pOO( )
.OO) *
IdOO* ,
,OO, -
pOO. /
.OO/ 0
NameOO0 4
,OO4 5
pOO6 7
.OO7 8
KeyOO8 ;
,OO; <
pOO= >
.OO> ?
DescriptionOO? J
)OOJ K
)OOK L
;OOL M
}PP 	
catchQQ 
(QQ '
UnauthorizedAccessExceptionQQ *
exQQ+ -
)QQ- .
{QQ/ 0
returnQQ1 7
ForbidQQ8 >
(QQ> ?
exQQ? A
.QQA B
MessageQQB I
)QQI J
;QQJ K
}QQL M
}RR 
[TT 

HttpDeleteTT 
(TT 
$strTT 
)TT 
]TT 
publicUU 

asyncUU 
TaskUU 
<UU 
IActionResultUU #
>UU# $
DeleteUU% +
(UU+ ,
intUU, /
idUU0 2
)UU2 3
{VV 
tryWW 
{XX 	
varYY 
userIdYY 
=YY 
intYY 
.YY 
ParseYY "
(YY" #
UserYY# '
.YY' (
	FindFirstYY( 1
(YY1 2
SystemYY2 8
.YY8 9
SecurityYY9 A
.YYA B
ClaimsYYB H
.YYH I

ClaimTypesYYI S
.YYS T
NameIdentifierYYT b
)YYb c
?YYc d
.YYd e
ValueYYe j
??YYk m
$strYYn q
)YYq r
;YYr s
awaitZZ #
EnforceAdminAccessAsyncZZ )
(ZZ) *
userIdZZ* 0
)ZZ0 1
;ZZ1 2
var\\ 
p\\ 
=\\ 
await\\ 
_context\\ "
.\\" #
Permissions\\# .
.\\. /
	FindAsync\\/ 8
(\\8 9
id\\9 ;
)\\; <
;\\< =
if]] 
(]] 
p]] 
==]] 
null]] 
)]] 
return]] !
NotFound]]" *
(]]* +
)]]+ ,
;]], -
_context__ 
.__ 
Permissions__  
.__  !
Remove__! '
(__' (
p__( )
)__) *
;__* +
await`` 
_context`` 
.`` 
SaveChangesAsync`` +
(``+ ,
)``, -
;``- .
returnaa 
	NoContentaa 
(aa 
)aa 
;aa 
}bb 	
catchcc 
(cc '
UnauthorizedAccessExceptioncc *
excc+ -
)cc- .
{cc/ 0
returncc1 7
Forbidcc8 >
(cc> ?
excc? A
.ccA B
MessageccB I
)ccI J
;ccJ K
}ccL M
}dd 
}ee ¸.
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
[88 

HttpDelete88 
(88 
$str88 
)88 
]88 
[99  
ProducesResponseType99 
(99 
StatusCodes99 %
.99% &
Status204NoContent99& 8
)998 9
]999 :
public:: 

async:: 
Task:: 
<:: 
IActionResult:: #
>::# $
DeleteNotification::% 7
(::7 8
int::8 ;
id::< >
)::> ?
{;; 
var<< 
userId<< 
=<< 
GetCurrentUserId<< %
(<<% &
)<<& '
;<<' (
await== 
_service== 
.== #
DeleteNotificationAsync== .
(==. /
id==/ 1
,==1 2
userId==3 9
)==9 :
;==: ;
return>> 
	NoContent>> 
(>> 
)>> 
;>> 
}?? 
[AA 

HttpDeleteAA 
(AA 
$strAA 
)AA 
]AA 
[BB  
ProducesResponseTypeBB 
(BB 
StatusCodesBB %
.BB% &
Status204NoContentBB& 8
)BB8 9
]BB9 :
publicCC 

asyncCC 
TaskCC 
<CC 
IActionResultCC #
>CC# $"
DeleteAllNotificationsCC% ;
(CC; <
)CC< =
{DD 
varEE 
userIdEE 
=EE 
GetCurrentUserIdEE %
(EE% &
)EE& '
;EE' (
awaitFF 
_serviceFF 
.FF '
DeleteAllNotificationsAsyncFF 2
(FF2 3
userIdFF3 9
)FF9 :
;FF: ;
returnGG 
	NoContentGG 
(GG 
)GG 
;GG 
}HH 
}II •K
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
)! "
{ 
var 
claim 
= 
User 
. 
	FindFirst "
(" #
System# )
.) *
Security* 2
.2 3
Claims3 9
.9 :

ClaimTypes: D
.D E
NameIdentifierE S
)S T
??U W
UserX \
.\ ]
	FindFirst] f
(f g
$strg o
)o p
;p q
return 
claim 
!= 
null 
&& 
int  #
.# $
TryParse$ ,
(, -
claim- 2
.2 3
Value3 8
,8 9
out: =
int> A
idB D
)D E
?F G
idH J
:K L
$numM N
;N O
} 
[ 
HttpGet 
( 
$str 
) 
] 
public 

async 
Task 
< 
IActionResult #
># $
GetCategories% 2
(2 3
)3 4
{ 
var 
result 
= 
await 

_kbService %
.% &
GetCategoriesAsync& 8
(8 9
)9 :
;: ;
return 
Ok 
( 
result 
) 
; 
}   
["" 
HttpPost"" 
("" 
$str"" 
)"" 
]"" 
[## 
	Authorize## 
(## 
Policy## 
=## 
$str## )
)##) *
]##* +
public$$ 

async$$ 
Task$$ 
<$$ 
IActionResult$$ #
>$$# $
CreateCategory$$% 3
($$3 4
CreateKbCategoryDto$$4 G
dto$$H K
)$$K L
{%% 
var&& 
result&& 
=&& 
await&& 

_kbService&& %
.&&% &
CreateCategoryAsync&&& 9
(&&9 :
dto&&: =
)&&= >
;&&> ?
return'' 
Ok'' 
('' 
result'' 
)'' 
;'' 
}(( 
[** 
HttpPut** 
(** 
$str** 
)** 
]**  
[++ 
	Authorize++ 
(++ 
Policy++ 
=++ 
$str++ )
)++) *
]++* +
public,, 

async,, 
Task,, 
<,, 
IActionResult,, #
>,,# $
UpdateCategory,,% 3
(,,3 4
int,,4 7
id,,8 :
,,,: ;
CreateKbCategoryDto,,< O
dto,,P S
),,S T
{-- 
await.. 

_kbService.. 
... 
UpdateCategoryAsync.. ,
(.., -
id..- /
,../ 0
dto..1 4
)..4 5
;..5 6
return// 
	NoContent// 
(// 
)// 
;// 
}00 
[22 

HttpDelete22 
(22 
$str22 !
)22! "
]22" #
[33 
	Authorize33 
(33 
Policy33 
=33 
$str33 )
)33) *
]33* +
public44 

async44 
Task44 
<44 
IActionResult44 #
>44# $
DeleteCategory44% 3
(443 4
int444 7
id448 :
)44: ;
{55 
await66 

_kbService66 
.66 
DeleteCategoryAsync66 ,
(66, -
id66- /
)66/ 0
;660 1
return77 
	NoContent77 
(77 
)77 
;77 
}88 
[:: 
HttpGet:: 
(:: 
$str:: 
):: 
]:: 
public;; 

async;; 
Task;; 
<;; 
IActionResult;; #
>;;# $
SearchArticles;;% 3
(;;3 4
[;;4 5
	FromQuery;;5 >
];;> ?
string;;@ F
?;;F G
search;;H N
,;;N O
[;;P Q
	FromQuery;;Q Z
];;Z [
int;;\ _
?;;_ `
category;;a i
);;i j
{<< 
var== 
result== 
=== 
await== 

_kbService== %
.==% &
SearchArticlesAsync==& 9
(==9 :
GetCurrentUserId==: J
(==J K
)==K L
,==L M
search==N T
,==T U
category==V ^
)==^ _
;==_ `
return>> 
Ok>> 
(>> 
result>> 
)>> 
;>> 
}?? 
[AA 
HttpGetAA 
(AA 
$strAA 
)AA 
]AA 
publicBB 

asyncBB 
TaskBB 
<BB 
IActionResultBB #
>BB# $

GetArticleBB% /
(BB/ 0
intBB0 3
idBB4 6
)BB6 7
{CC 
varDD 
resultDD 
=DD 
awaitDD 

_kbServiceDD %
.DD% &
GetArticleAsyncDD& 5
(DD5 6
idDD6 8
,DD8 9
GetCurrentUserIdDD: J
(DDJ K
)DDK L
)DDL M
;DDM N
ifEE 

(EE 
resultEE 
==EE 
nullEE 
)EE 
returnEE "
NotFoundEE# +
(EE+ ,
)EE, -
;EE- .
returnFF 
OkFF 
(FF 
resultFF 
)FF 
;FF 
}GG 
[II 
HttpPostII 
(II 
$strII 
)II 
]II 
publicJJ 

asyncJJ 
TaskJJ 
<JJ 
IActionResultJJ #
>JJ# $
CreateArticleJJ% 2
(JJ2 3
CreateKbArticleDtoJJ3 E
dtoJJF I
)JJI J
{KK 
varLL 
resultLL 
=LL 
awaitLL 

_kbServiceLL %
.LL% &
CreateArticleAsyncLL& 8
(LL8 9
dtoLL9 <
,LL< =
GetCurrentUserIdLL> N
(LLN O
)LLO P
)LLP Q
;LLQ R
returnMM 
OkMM 
(MM 
resultMM 
)MM 
;MM 
}NN 
[PP 
HttpPutPP 
(PP 
$strPP 
)PP 
]PP 
publicQQ 

asyncQQ 
TaskQQ 
<QQ 
IActionResultQQ #
>QQ# $
UpdateArticleQQ% 2
(QQ2 3
intQQ3 6
idQQ7 9
,QQ9 :
UpdateKbArticleDtoQQ; M
dtoQQN Q
)QQQ R
{RR 
awaitSS 

_kbServiceSS 
.SS 
UpdateArticleAsyncSS +
(SS+ ,
idSS, .
,SS. /
dtoSS0 3
,SS3 4
GetCurrentUserIdSS5 E
(SSE F
)SSF G
)SSG H
;SSH I
returnTT 
	NoContentTT 
(TT 
)TT 
;TT 
}UU 
[WW 
HttpPostWW 
(WW 
$strWW $
)WW$ %
]WW% &
[XX 
	AuthorizeXX 
(XX 
PolicyXX 
=XX 
$strXX )
)XX) *
]XX* +
publicYY 

asyncYY 
TaskYY 
<YY 
IActionResultYY #
>YY# $
ReviewArticleYY% 2
(YY2 3
intYY3 6
idYY7 9
,YY9 :
ReviewKbArticleDtoYY; M
dtoYYN Q
)YYQ R
{ZZ 
await[[ 

_kbService[[ 
.[[ 
ReviewArticleAsync[[ +
([[+ ,
id[[, .
,[[. /
dto[[0 3
,[[3 4
GetCurrentUserId[[5 E
([[E F
)[[F G
)[[G H
;[[H I
return\\ 
	NoContent\\ 
(\\ 
)\\ 
;\\ 
}]] 
[__ 

HttpDelete__ 
(__ 
$str__ 
)__  
]__  !
public`` 

async`` 
Task`` 
<`` 
IActionResult`` #
>``# $
DeleteArticle``% 2
(``2 3
int``3 6
id``7 9
)``9 :
{aa 
awaitbb 

_kbServicebb 
.bb 
DeleteArticleAsyncbb +
(bb+ ,
idbb, .
,bb. /
GetCurrentUserIdbb0 @
(bb@ A
)bbA B
)bbB C
;bbC D
returncc 
	NoContentcc 
(cc 
)cc 
;cc 
}dd 
}ee À
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
;4 5
private 
readonly 
IDepartmentService '
_departmentService( :
;: ;
public 

LookupController 
( 
ICatalogService +
catalogService, :
,: ;
IProjectService< K
projectServiceL Z
,Z [
IDepartmentService\ n
departmentService	o Ä
)
Ä Å
{ 
_catalogService 
= 
catalogService (
;( )
_projectService 
= 
projectService (
;( )
_departmentService 
= 
departmentService .
;. /
} 
[ 
HttpGet 
] 
public 

async 
Task 
< 
IActionResult #
># $

GetLookups% /
(/ 0
)0 1
{ 
var 
projects 
= 
await 
_projectService ,
., -
GetAllAsync- 8
(8 9
)9 :
;: ;
var 

categories 
= 
await 
_catalogService .
.. /
GetCategoriesAsync/ A
(A B
nullB F
)F G
;G H
var 
ticketTypes 
= 
await 
_catalogService  /
./ 0
GetTicketTypesAsync0 C
(C D
)D E
;E F
var 

priorities 
= 
await 
_catalogService .
.. /
GetPrioritiesAsync/ A
(A B
)B C
;C D
var 
statuses 
= 
await 
_catalogService ,
., -
GetStatusesAsync- =
(= >
)> ?
;? @
var 
departments 
= 
await 
_departmentService  2
.2 3
GetAllAsync3 >
(> ?
)? @
;@ A
return!! 
Ok!! 
(!! 
new!! 
{"" 	
projects## 
,## 

categories$$ 
,$$ 
ticketTypes%% 
,%% 

priorities&& 
,&& 
statuses'' 
,'' 
departments(( 
})) 	
)))	 

;))
 
}** 
}++ Ö/
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
: 
CrudControllerBase  2
<2 3
GroupDto3 ;
>; <
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
} 
	protected 
override 
Task 
< 
IEnumerable '
<' (
GroupDto( 0
>0 1
>1 2
GetAllEntitiesAsync3 F
(F G
)G H
=>I K
_serviceL T
.T U
GetAllAsyncU `
(` a
)a b
;b c
	protected 
override 
Task 
< 
GroupDto $
?$ %
>% &
GetEntityByIdAsync' 9
(9 :
int: =
id> @
)@ A
=>B D
_serviceE M
.M N
GetByIdAsyncN Z
(Z [
id[ ]
)] ^
;^ _
	protected 
override 
Task 
DeleteEntityAsync -
(- .
int. 1
id2 4
)4 5
=>6 8
_service9 A
.A B
DeleteAsyncB M
(M N
idN P
)P Q
;Q R
[ 
HttpPost 
] 
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status201Created& 6
)6 7
]7 8
public 

async 
Task 
< 
IActionResult #
># $
Create% +
(+ ,
[, -
FromBody- 5
]5 6
CreateGroupDto7 E
dtoF I
)I J
{ 
var 
created 
= 
await 
_service $
.$ %
CreateAsync% 0
(0 1
dto1 4
)4 5
;5 6
return 
CreatedAtAction 
( 
nameof %
(% &
GetById& -
)- .
,. /
new0 3
{4 5
id6 8
=9 :
created; B
.B C
IdC E
}F G
,G H
createdI P
)P Q
;Q R
} 
[   
HttpPut   
(   
$str   
)   
]   
[!!  
ProducesResponseType!! 
(!! 
StatusCodes!! %
.!!% &
Status204NoContent!!& 8
)!!8 9
]!!9 :
[""  
ProducesResponseType"" 
("" 
StatusCodes"" %
.""% &
Status404NotFound""& 7
)""7 8
]""8 9
public## 

async## 
Task## 
<## 
IActionResult## #
>### $
Update##% +
(##+ ,
int##, /
id##0 2
,##2 3
[##4 5
FromBody##5 =
]##= >
UpdateGroupDto##? M
dto##N Q
)##Q R
{$$ 
try%% 
{&& 	
await'' 
_service'' 
.'' 
UpdateAsync'' &
(''& '
id''' )
,'') *
dto''+ .
)''. /
;''/ 0
return(( 
	NoContent(( 
((( 
)(( 
;(( 
})) 	
catch** 
(**  
KeyNotFoundException** #
)**# $
{++ 	
return,, 
NotFound,, 
(,, 
),, 
;,, 
}-- 	
}.. 
[00 
HttpPost00 
(00 
$str00 %
)00% &
]00& '
[11  
ProducesResponseType11 
(11 
StatusCodes11 %
.11% &
Status204NoContent11& 8
)118 9
]119 :
public22 

async22 
Task22 
<22 
IActionResult22 #
>22# $
	AddMember22% .
(22. /
int22/ 2
id223 5
,225 6
int227 :
userId22; A
)22A B
{33 
await44 
_service44 
.44 
AddMemberAsync44 %
(44% &
id44& (
,44( )
userId44* 0
)440 1
;441 2
return55 
	NoContent55 
(55 
)55 
;55 
}66 
[88 

HttpDelete88 
(88 
$str88 '
)88' (
]88( )
[99  
ProducesResponseType99 
(99 
StatusCodes99 %
.99% &
Status204NoContent99& 8
)998 9
]999 :
public:: 

async:: 
Task:: 
<:: 
IActionResult:: #
>::# $
RemoveMember::% 1
(::1 2
int::2 5
id::6 8
,::8 9
int::: =
userId::> D
)::D E
{;; 
await<< 
_service<< 
.<< 
RemoveMemberAsync<< (
(<<( )
id<<) +
,<<+ ,
userId<<- 3
)<<3 4
;<<4 5
return== 
	NoContent== 
(== 
)== 
;== 
}>> 
}?? ∆Ö
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
}88 ‹
^/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.API/Controllers/CrudControllerBase.cs
	namespace 	
ItsTool
 
. 
API 
. 
Controllers !
;! "
public 
abstract 
class 
CrudControllerBase (
<( )
TDto) -
>- .
:/ 0
ControllerBase1 ?
where@ E
TDtoF J
:K L
classM R
{ 
	protected 
abstract 
Task 
< 
IEnumerable '
<' (
TDto( ,
>, -
>- .
GetAllEntitiesAsync/ B
(B C
)C D
;D E
	protected 
abstract 
Task 
< 
TDto  
?  !
>! "
GetEntityByIdAsync# 5
(5 6
int6 9
id: <
)< =
;= >
	protected		 
abstract		 
Task		 
DeleteEntityAsync		 -
(		- .
int		. 1
id		2 4
)		4 5
;		5 6
[ 
HttpGet 
] 
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status200OK& 1
)1 2
]2 3
public 

async 
Task 
< 
IActionResult #
># $
GetAll% +
(+ ,
), -
{ 
return 
Ok 
( 
await 
GetAllEntitiesAsync +
(+ ,
), -
)- .
;. /
} 
[ 
HttpGet 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status200OK& 1
)1 2
]2 3
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status404NotFound& 7
)7 8
]8 9
public 

async 
Task 
< 
IActionResult #
># $
GetById% ,
(, -
int- 0
id1 3
)3 4
{ 
var 
entity 
= 
await 
GetEntityByIdAsync -
(- .
id. 0
)0 1
;1 2
if 

( 
entity 
== 
null 
) 
return "
NotFound# +
(+ ,
), -
;- .
return 
Ok 
( 
entity 
) 
; 
} 
[ 

HttpDelete 
( 
$str 
) 
] 
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status204NoContent& 8
)8 9
]9 :
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status404NotFound& 7
)7 8
]8 9
public 

async 
Task 
< 
IActionResult #
># $
Delete% +
(+ ,
int, /
id0 2
)2 3
{   
try!! 
{"" 	
await## 
DeleteEntityAsync## #
(### $
id##$ &
)##& '
;##' (
return$$ 
	NoContent$$ 
($$ 
)$$ 
;$$ 
}%% 	
catch&& 
(&&  
KeyNotFoundException&& #
)&&# $
{'' 	
return(( 
NotFound(( 
((( 
)(( 
;(( 
})) 	
}** 
}++ „"
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
 4
)

4 5
]

5 6
public 
class  
CategoriesController !
:" #
CrudControllerBase$ 6
<6 7
CategoryDto7 B
>B C
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
} 
	protected 
override 
Task 
< 
IEnumerable '
<' (
CategoryDto( 3
>3 4
>4 5
GetAllEntitiesAsync6 I
(I J
)J K
=>L N
_serviceO W
.W X
GetCategoriesAsyncX j
(j k
)k l
;l m
	protected 
override 
Task 
< 
CategoryDto '
?' (
>( )
GetEntityByIdAsync* <
(< =
int= @
idA C
)C D
=>E G
_serviceH P
.P Q 
GetCategoryByIdAsyncQ e
(e f
idf h
)h i
;i j
	protected 
override 
Task 
DeleteEntityAsync -
(- .
int. 1
id2 4
)4 5
=>6 8
_service9 A
.A B
DeleteCategoryAsyncB U
(U V
idV X
)X Y
;Y Z
[ 
HttpPost 
] 
[  
ProducesResponseType 
( 
StatusCodes %
.% &
Status201Created& 6
)6 7
]7 8
public 

async 
Task 
< 
IActionResult #
># $
Create% +
(+ ,
[, -
FromBody- 5
]5 6
CreateCategoryDto7 H
dtoI L
)L M
{ 
var 
created 
= 
await 
_service $
.$ %
CreateCategoryAsync% 8
(8 9
dto9 <
)< =
;= >
return 
CreatedAtAction 
( 
nameof %
(% &
GetById& -
)- .
,. /
new0 3
{4 5
id6 8
=9 :
created; B
.B C
IdC E
}F G
,G H
createdI P
)P Q
;Q R
} 
[   
HttpPut   
(   
$str   
)   
]   
[!!  
ProducesResponseType!! 
(!! 
StatusCodes!! %
.!!% &
Status204NoContent!!& 8
)!!8 9
]!!9 :
[""  
ProducesResponseType"" 
("" 
StatusCodes"" %
.""% &
Status404NotFound""& 7
)""7 8
]""8 9
public## 

async## 
Task## 
<## 
IActionResult## #
>### $
Update##% +
(##+ ,
int##, /
id##0 2
,##2 3
[##4 5
FromBody##5 =
]##= >
UpdateCategoryDto##? P
dto##Q T
)##T U
{$$ 
try%% 
{&& 	
await'' 
_service'' 
.'' 
UpdateCategoryAsync'' .
(''. /
id''/ 1
,''1 2
dto''3 6
)''6 7
;''7 8
return(( 
	NoContent(( 
((( 
)(( 
;(( 
})) 	
catch** 
(**  
KeyNotFoundException** #
)**# $
{++ 	
return,, 
NotFound,, 
(,, 
),, 
;,, 
}-- 	
}.. 
}00 Ãã
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
};; ±b
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
$str[[ 
,[[ 
$str\\ 
+\\ 
h\\ 
.\\ 
TicketId\\ #
,\\# $
h]] 
.]] 
TicketId]] 
.]] 
ToString]] #
(]]# $
)]]$ %
)^^ 
)^^ 
.__ 
ToListAsync__ 
(__ 
)__ 
;__ 
varaa 
systemItemsaa 
=aa 
newaa 
Systemaa $
.aa$ %
Collectionsaa% 0
.aa0 1
Genericaa1 8
.aa8 9
Listaa9 =
<aa= >
AuditLogItemDtoaa> M
>aaM N
(aaN O
)aaO P
;aaP Q
ifbb 

(bb 
!bb 
isTicketFilteredbb 
)bb 
{cc 	
systemItemsdd 
=dd 
awaitdd 
systemQuerydd  +
.ee 
OrderByDescendingee "
(ee" #
hee# $
=>ee% '
hee( )
.ee) *
	CreatedAtee* 3
)ee3 4
.ff 
Takeff 
(ff 
filterff 
.ff 
PageSizeff %
*ff& '
filterff( .
.ff. /
Pageff/ 3
)ff3 4
.gg 
Selectgg 
(gg 
hgg 
=>gg 
newgg  
AuditLogItemDtogg! 0
(gg0 1
hhh 
.hh 
Idhh 
,hh 
nullii 
,ii 
hjj 
.jj 
Actionjj 
,jj 
hkk 
.kk 
	FieldNamekk 
??kk  "
$strkk# %
,kk% &
hll 
.ll 
OldValuell 
,ll 
hmm 
.mm 
NewValuemm 
,mm 
hnn 
.nn 
	CreatedBynn 
??nn  "
$strnn# +
,nn+ ,
hoo 
.oo 
	CreatedAtoo 
,oo  
hpp 
.pp 

EntityTypepp  
,pp  !
hqq 
.qq 

EntityNameqq  
,qq  !
hrr 
.rr 
EntityIdrr 
)ss 
)ss 
.tt 
ToListAsynctt 
(tt 
)tt 
;tt 
}uu 	
varww 
itemsww 
=ww 
ticketItemsww 
.ww  
Concatww  &
(ww& '
systemItemsww' 2
)ww2 3
.xx 
OrderByDescendingxx 
(xx 
hxx  
=>xx! #
hxx$ %
.xx% &
	CreatedAtxx& /
)xx/ 0
.yy 
Skipyy 
(yy 
(yy 
filteryy 
.yy 
Pageyy 
-yy  
$numyy! "
)yy" #
*yy$ %
filteryy& ,
.yy, -
PageSizeyy- 5
)yy5 6
.zz 
Takezz 
(zz 
filterzz 
.zz 
PageSizezz !
)zz! "
.{{ 
ToList{{ 
({{ 
){{ 
;{{ 
return}} 
Ok}} 
(}} 
new}}  
PaginatedAuditLogDto}} *
(}}* +
items}}+ 0
,}}0 1

totalCount}}2 <
,}}< =
filter}}> D
.}}D E
Page}}E I
,}}I J
filter}}K Q
.}}Q R
PageSize}}R Z
)}}Z [
)}}[ \
;}}\ ]
}~~ 
} Ïp
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
(@@) *
$str@@* 0
,@@0 1

EntityName@@2 <
,@@< =
rule@@> B
.@@B C
Id@@C E
.@@E F
ToString@@F N
(@@N O
)@@O P
,@@P Q
$str@@R [
,@@[ \
$str@@] c
,@@c d
null@@e i
,@@i j
rule@@k o
.@@o p
Name@@p t
)@@t u
;@@u v
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
(ZZ) *
$strZZ* 0
,ZZ0 1

EntityNameZZ2 <
,ZZ< =
ruleZZ> B
.ZZB C
IdZZC E
.ZZE F
ToStringZZF N
(ZZN O
)ZZO P
,ZZP Q
$strZZR [
,ZZ[ \
$strZZ] c
,ZZc d
nullZZe i
,ZZi j
ruleZZk o
.ZZo p
NameZZp t
)ZZt u
;ZZu v
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
(gg) *
$strgg* 0
,gg0 1

EntityNamegg2 <
,gg< =
rulegg> B
.ggB C
IdggC E
.ggE F
ToStringggF N
(ggN O
)ggO P
,ggP Q
$strggR [
,gg[ \
$strgg] c
,ggc d
rulegge i
.ggi j
Nameggj n
,ggn o
nullggp t
)ggt u
;ggu v
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
(ww) *
$strww* 0
,ww0 1

EntityNameww2 <
,ww< =
ruleww> B
.wwB C
IdwwC E
.wwE F
ToStringwwF N
(wwN O
)wwO P
,wwP Q
$strwwR [
,ww[ \
$strww] g
,wwg h
	oldStatuswwi r
,wwr s
	newStatuswwt }
)ww} ~
;ww~ 
returnxx 
	NoContentxx 
(xx 
)xx 
;xx 
}yy 
}zz 