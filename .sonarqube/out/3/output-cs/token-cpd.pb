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
}`` ·U
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
await 
_repository %
.% &
GetAllAsync& 1
(1 2
)2 3
;3 4
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
u- .
.. /
Id/ 1
,1 2
u3 4
.4 5
Username5 =
,= >
u? @
.@ A
EmailA F
,F G
uH I
.I J
	FirstNameJ S
,S T
uU V
.V W
LastNameW _
,_ `
ua b
.b c
IsActivec k
,k l
um n
.n o
DepartmentIdo {
){ |
)| }
;} ~
} 
public 

async 
Task 
< 
UserDto 
? 
> 
GetByIdAsync  ,
(, -
int- 0
id1 3
)3 4
{ 
var 
user 
= 
await 
_repository $
.$ %
GetByIdAsync% 1
(1 2
id2 4
)4 5
;5 6
if 

( 
user 
== 
null 
) 
return  
null! %
;% &
return 
new 
UserDto 
( 
user 
.  
Id  "
," #
user$ (
.( )
Username) 1
,1 2
user3 7
.7 8
Email8 =
,= >
user? C
.C D
	FirstNameD M
,M N
userO S
.S T
LastNameT \
,\ ]
user^ b
.b c
IsActivec k
,k l
userm q
.q r
DepartmentIdr ~
)~ 
;	 Ä
}   
public"" 

async"" 
Task"" 
<"" 
UserDto"" 
>"" 
CreateAsync"" *
(""* +
CreateUserDto""+ 8
dto""9 <
)""< =
{## 
var$$ 
user$$ 
=$$ 
new$$ 
User$$ 
{%% 	
Username&& 
=&& 
dto&& 
.&& 
Username&& #
,&&# $
Email'' 
='' 
dto'' 
.'' 
Email'' 
,'' 
	FirstName(( 
=(( 
dto(( 
.(( 
	FirstName(( %
,((% &
LastName)) 
=)) 
dto)) 
.)) 
LastName)) #
,))# $
PasswordHash** 
=** 
BCrypt** !
.**! "
Net**" %
.**% &
BCrypt**& ,
.**, -
HashPassword**- 9
(**9 :
dto**: =
.**= >
Password**> F
)**F G
,**G H
DepartmentId++ 
=++ 
dto++ 
.++ 
DepartmentId++ +
},, 	
;,,	 

await-- 
_repository-- 
.-- 
AddAsync-- "
(--" #
user--# '
)--' (
;--( )
return.. 
new.. 
UserDto.. 
(.. 
user.. 
...  
Id..  "
,.." #
user..$ (
...( )
Username..) 1
,..1 2
user..3 7
...7 8
Email..8 =
,..= >
user..? C
...C D
	FirstName..D M
,..M N
user..O S
...S T
LastName..T \
,..\ ]
user..^ b
...b c
IsActive..c k
,..k l
user..m q
...q r
DepartmentId..r ~
)..~ 
;	.. Ä
}// 
public11 

async11 
Task11 
UpdateAsync11 !
(11! "
int11" %
id11& (
,11( )
UpdateUserDto11* 7
dto118 ;
)11; <
{22 
var33 
user33 
=33 
await33 
_repository33 $
.33$ %
GetByIdAsync33% 1
(331 2
id332 4
)334 5
;335 6
if44 

(44 
user44 
==44 
null44 
)44 
throw44 
new44  # 
KeyNotFoundException44$ 8
(448 9
$str449 I
)44I J
;44J K
user66 
.66 
Email66 
=66 
dto66 
.66 
Email66 
;66 
user77 
.77 
	FirstName77 
=77 
dto77 
.77 
	FirstName77 &
;77& '
user88 
.88 
LastName88 
=88 
dto88 
.88 
LastName88 $
;88$ %
user99 
.99 
IsActive99 
=99 
dto99 
.99 
IsActive99 $
;99$ %
user:: 
.:: 
DepartmentId:: 
=:: 
dto:: 
.::  
DepartmentId::  ,
;::, -
await;; 
_repository;; 
.;; 
UpdateAsync;; %
(;;% &
user;;& *
);;* +
;;;+ ,
}<< 
public>> 

async>> 
Task>> 
DeleteAsync>> !
(>>! "
int>>" %
id>>& (
)>>( )
{?? 
await@@ 
_repository@@ 
.@@ 
DeleteAsync@@ %
(@@% &
id@@& (
)@@( )
;@@) *
}AA 
publicCC 

asyncCC 
TaskCC 
AssignRoleAsyncCC %
(CC% &
intCC& )
userIdCC* 0
,CC0 1
intCC2 5
roleIdCC6 <
)CC< =
{DD 
varEE 
existsEE 
=EE 
awaitEE 
_contextEE #
.EE# $
	UserRolesEE$ -
.EE- .
AnyAsyncEE. 6
(EE6 7
urEE7 9
=>EE: <
urEE= ?
.EE? @
UserIdEE@ F
==EEG I
userIdEEJ P
&&EEQ S
urEET V
.EEV W
RoleIdEEW ]
==EE^ `
roleIdEEa g
)EEg h
;EEh i
ifFF 

(FF 
!FF 
existsFF 
)FF 
{GG 	
_contextHH 
.HH 
	UserRolesHH 
.HH 
AddHH "
(HH" #
newHH# &
UserRoleHH' /
{HH0 1
UserIdHH2 8
=HH9 :
userIdHH; A
,HHA B
RoleIdHHC I
=HHJ K
roleIdHHL R
}HHS T
)HHT U
;HHU V
awaitII 
_contextII 
.II 
SaveChangesAsyncII +
(II+ ,
)II, -
;II- .
}JJ 	
}KK 
publicMM 

asyncMM 
TaskMM 
RevokeRoleAsyncMM %
(MM% &
intMM& )
userIdMM* 0
,MM0 1
intMM2 5
roleIdMM6 <
)MM< =
{NN 
varOO 
urOO 
=OO 
awaitOO 
_contextOO 
.OO  
	UserRolesOO  )
.OO) *
FirstOrDefaultAsyncOO* =
(OO= >
xOO> ?
=>OO@ B
xOOC D
.OOD E
UserIdOOE K
==OOL N
userIdOOO U
&&OOV X
xOOY Z
.OOZ [
RoleIdOO[ a
==OOb d
roleIdOOe k
)OOk l
;OOl m
ifPP 

(PP 
urPP 
!=PP 
nullPP 
)PP 
{QQ 	
_contextRR 
.RR 
	UserRolesRR 
.RR 
RemoveRR %
(RR% &
urRR& (
)RR( )
;RR) *
awaitSS 
_contextSS 
.SS 
SaveChangesAsyncSS +
(SS+ ,
)SS, -
;SS- .
}TT 	
}UU 
publicWW 

asyncWW 
TaskWW &
AddPermissionOverrideAsyncWW 0
(WW0 1
intWW1 4
userIdWW5 ;
,WW; <
intWW= @
permissionIdWWA M
,WWM N
boolWWO S
	isGrantedWWT ]
)WW] ^
{XX 
varYY 
overYY 
=YY 
awaitYY 
_contextYY !
.YY! "#
UserPermissionOverridesYY" 9
.ZZ 
FirstOrDefaultAsyncZZ  
(ZZ  !
oZZ! "
=>ZZ# %
oZZ& '
.ZZ' (
UserIdZZ( .
==ZZ/ 1
userIdZZ2 8
&&ZZ9 ;
oZZ< =
.ZZ= >
PermissionIdZZ> J
==ZZK M
permissionIdZZN Z
)ZZZ [
;ZZ[ \
if\\ 

(\\ 
over\\ 
!=\\ 
null\\ 
)\\ 
{]] 	
over^^ 
.^^ 
	IsGranted^^ 
=^^ 
	isGranted^^ &
;^^& '
}__ 	
else`` 
{aa 	
_contextbb 
.bb #
UserPermissionOverridesbb ,
.bb, -
Addbb- 0
(bb0 1
newbb1 4"
UserPermissionOverridebb5 K
{cc 
UserIddd 
=dd 
userIddd 
,dd  
PermissionIdee 
=ee 
permissionIdee +
,ee+ ,
	IsGrantedff 
=ff 
	isGrantedff %
}gg 
)gg 
;gg 
}hh 	
awaitii 
_contextii 
.ii 
SaveChangesAsyncii '
(ii' (
)ii( )
;ii) *
}jj 
}kk ”ü
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
;* +
public 

TicketService 
( 
ItsToolDbContext )
context* 1
,1 2
IFileStorageService3 F
fileStorageG R
,R S!
IPermissionCalculatorT i 
permissionCalculatorj ~
,~ 

ISlaEngine
Ä ä
	slaEngine
ã î
)
î ï
{ 
_context 
= 
context 
; 
_fileStorage 
= 
fileStorage "
;" #!
_permissionCalculator 
=  
permissionCalculator  4
;4 5

_slaEngine 
= 
	slaEngine 
; 
} 
private 
async 
Task 
< 
string 
> %
GenerateTicketNumberAsync 8
(8 9
int9 <
	projectId= F
)F G
{ 
var   
project   
=   
await   
_context   $
.  $ %
Projects  % -
.  - .
	FindAsync  . 7
(  7 8
	projectId  8 A
)  A B
;  B C
if!! 

(!! 
project!! 
==!! 
null!! 
)!! 
throw!! "
new!!# & 
KeyNotFoundException!!' ;
(!!; <
$str!!< P
)!!P Q
;!!Q R
var## 
sequence## 
=## 
await## 
_context## %
.##% &
ProjectSequences##& 6
.##6 7
FirstOrDefaultAsync##7 J
(##J K
ps##K M
=>##N P
ps##Q S
.##S T
	ProjectId##T ]
==##^ `
	projectId##a j
)##j k
;##k l
if$$ 

($$ 
sequence$$ 
==$$ 
null$$ 
)$$ 
{%% 	
sequence&& 
=&& 
new&& 
ProjectSequence&& *
{&&+ ,
	ProjectId&&- 6
=&&7 8
	projectId&&9 B
,&&B C
CurrentValue&&D P
=&&Q R
$num&&S T
}&&U V
;&&V W
_context'' 
.'' 
ProjectSequences'' %
.''% &
Add''& )
('') *
sequence''* 2
)''2 3
;''3 4
}(( 	
else)) 
{** 	
sequence++ 
.++ 
CurrentValue++ !
++++! #
;++# $
},, 	
await.. 
_context.. 
... 
SaveChangesAsync.. '
(..' (
)..( )
;..) *
return// 
$"// 
{// 
project// 
.// 

ProjectKey// $
}//$ %
$str//% &
{//& '
sequence//' /
./// 0
CurrentValue//0 <
}//< =
"//= >
;//> ?
}00 
private22 
async22 
Task22 &
ValidateDynamicFieldsAsync22 1
(221 2
int222 5
	projectId226 ?
,22? @
int22A D

categoryId22E O
,22O P
int22Q T
typeId22U [
,22[ \

Dictionary22] g
<22g h
string22h n
,22n o
string22p v
>22v w
customFields	22x Ñ
)
22Ñ Ö
{33 
var44 

placements44 
=44 
await44 
_context44 '
.44' (
FormFieldPlacements44( ;
.55 
Include55 
(55 
p55 
=>55 
p55 
.55 
FieldDefinition55 +
)55+ ,
.66 
Where66 
(66 
p66 
=>66 
!66 
p66 
.66 
	IsDeleted66 $
&&66% '
p66( )
.66) *
IsActive66* 2
&&663 5
p666 7
.667 8
	ProjectId668 A
==66B D
	projectId66E N
&&66O Q
p66R S
.66S T

CategoryId66T ^
==66_ a

categoryId66b l
&&66m o
p66p q
.66q r
TicketTypeId66r ~
==	66 Å
typeId
66Ç à
)
66à â
.77 
ToListAsync77 
(77 
)77 
;77 
foreach99 
(99 
var99 
p99 
in99 

placements99 $
)99$ %
{:: 	
var;; 
def;; 
=;; 
p;; 
.;; 
FieldDefinition;; '
!;;' (
;;;( )
customFields<< 
.<< 
TryGetValue<< $
(<<$ %
def<<% (
.<<( )
Key<<) ,
,<<, -
out<<. 1
var<<2 5
val<<6 9
)<<9 :
;<<: ;!
ValidateRequiredField>> !
(>>! "
p>>" #
,>># $
def>>% (
,>>( )
val>>* -
)>>- .
;>>. /
if@@ 
(@@ 
!@@ 
string@@ 
.@@ 
IsNullOrWhiteSpace@@ *
(@@* +
val@@+ .
)@@. /
)@@/ 0
{AA 
ValidateRegexFormatBB #
(BB# $
defBB$ '
,BB' (
valBB) ,
)BB, -
;BB- .
awaitCC %
ValidateFieldOptionsAsyncCC /
(CC/ 0
defCC0 3
,CC3 4
valCC5 8
)CC8 9
;CC9 :
}DD 
}EE 	
}FF 
privateHH 
staticHH 
voidHH !
ValidateRequiredFieldHH -
(HH- .
FormFieldPlacementHH. @
	placementHHA J
,HHJ K
FieldDefinitionHHL [
defHH\ _
,HH_ `
stringHHa g
?HHg h
valHHi l
)HHl m
{II 
ifJJ 

(JJ 
	placementJJ 
.JJ 

IsRequiredJJ  
&&JJ! #
stringJJ$ *
.JJ* +
IsNullOrWhiteSpaceJJ+ =
(JJ= >
valJJ> A
)JJA B
)JJB C
throwKK 
newKK %
InvalidOperationExceptionKK /
(KK/ 0
$"KK0 2
$strKK2 8
{KK8 9
defKK9 <
.KK< =
LabelKK= B
}KKB C
$strKKC P
"KKP Q
)KKQ R
;KKR S
}LL 
privateNN 
staticNN 
voidNN 
ValidateRegexFormatNN +
(NN+ ,
FieldDefinitionNN, ;
defNN< ?
,NN? @
stringNNA G
valNNH K
)NNK L
{OO 
ifPP 

(PP 
!PP 
stringPP 
.PP 
IsNullOrWhiteSpacePP &
(PP& '
defPP' *
.PP* +
ValidationRegexPP+ :
)PP: ;
)PP; <
{QQ 	
tryRR 
{SS 
ifTT 
(TT 
!TT 
RegexTT 
.TT 
IsMatchTT "
(TT" #
valTT# &
,TT& '
defTT( +
.TT+ ,
ValidationRegexTT, ;
,TT; <
RegexOptionsTT= I
.TTI J
NoneTTJ N
,TTN O
TimeSpanTTP X
.TTX Y
FromSecondsTTY d
(TTd e
$numTTe f
)TTf g
)TTg h
)TTh i
throwUU 
newUU %
InvalidOperationExceptionUU 7
(UU7 8
$"UU8 :
$strUU: @
{UU@ A
defUUA D
.UUD E
LabelUUE J
}UUJ K
$strUUK ^
"UU^ _
)UU_ `
;UU` a
}VV 
catchWW 
(WW &
RegexMatchTimeoutExceptionWW -
)WW- .
{XX 
throwYY 
newYY %
InvalidOperationExceptionYY 3
(YY3 4
$"YY4 6
$strYY6 <
{YY< =
defYY= @
.YY@ A
LabelYYA F
}YYF G
$strYYG Z
"YYZ [
)YY[ \
;YY\ ]
}ZZ 
}[[ 	
}\\ 
private^^ 
async^^ 
Task^^ %
ValidateFieldOptionsAsync^^ 0
(^^0 1
FieldDefinition^^1 @
def^^A D
,^^D E
string^^F L
val^^M P
)^^P Q
{__ 
if`` 

(`` 
def`` 
.`` 
	FieldType`` 
==`` 
	FieldType`` &
.``& '
Dropdown``' /
||``0 2
def``3 6
.``6 7
	FieldType``7 @
==``A C
	FieldType``D M
.``M N
MultiSelect``N Y
)``Y Z
{aa 	
varbb 
optionsbb 
=bb 
awaitbb 
_contextbb  (
.bb( )
FieldOptionsbb) 5
.bb5 6
Wherebb6 ;
(bb; <
obb< =
=>bb> @
obbA B
.bbB C
FieldDefinitionIdbbC T
==bbU W
defbbX [
.bb[ \
Idbb\ ^
&&bb_ a
!bbb c
obbc d
.bbd e
	IsDeletedbbe n
)bbn o
.bbo p
Selectbbp v
(bbv w
obbw x
=>bby {
obb| }
.bb} ~
Value	bb~ É
)
bbÉ Ñ
.
bbÑ Ö
ToListAsync
bbÖ ê
(
bbê ë
)
bbë í
;
bbí ì
ifcc 
(cc 
!cc 
optionscc 
.cc 
Containscc !
(cc! "
valcc" %
)cc% &
)cc& '
throwdd 
newdd %
InvalidOperationExceptiondd 3
(dd3 4
$"dd4 6
$strdd6 <
{dd< =
defdd= @
.dd@ A
LabelddA F
}ddF G
$strddG `
"dd` a
)dda b
;ddb c
}ee 	
}ff 
publichh 

asynchh 
Taskhh 
<hh 
	TicketDtohh 
>hh  
CreateTicketAsynchh! 2
(hh2 3
CreateTicketDtohh3 B
dtohhC F
)hhF G
{ii 
varjj 
numberjj 
=jj 
awaitjj %
GenerateTicketNumberAsyncjj 4
(jj4 5
dtojj5 8
.jj8 9
	ProjectIdjj9 B
)jjB C
;jjC D
awaitkk &
ValidateDynamicFieldsAsynckk (
(kk( )
dtokk) ,
.kk, -
	ProjectIdkk- 6
,kk6 7
dtokk8 ;
.kk; <

CategoryIdkk< F
,kkF G
dtokkH K
.kkK L
TypeIdkkL R
,kkR S
dtokkT W
.kkW X
CustomFieldskkX d
)kkd e
;kke f
varnn 
defaultStatusnn 
=nn 
awaitnn !
_contextnn" *
.nn* +
Statusesnn+ 3
.nn3 4
FirstOrDefaultAsyncnn4 G
(nnG H
snnH I
=>nnJ L
snnM N
.nnN O
IsSystemDefaultnnO ^
&&nn_ a
!nnb c
snnc d
.nnd e
	IsDeletednne n
)nnn o
;nno p
ifoo 

(oo 
defaultStatusoo 
==oo 
nulloo !
)oo! "
throwoo# (
newoo) ,%
InvalidOperationExceptionoo- F
(ooF G
$strooG i
)ooi j
;ooj k
varqq 
tqq 
=qq 
newqq 
Ticketqq 
{rr 	
TicketNumberss 
=ss 
numberss !
,ss! "
Titlett 
=tt 
dtott 
.tt 
Titlett 
,tt 
Descriptionuu 
=uu 
dtouu 
.uu 
Descriptionuu )
,uu) *
	ProjectIdvv 
=vv 
dtovv 
.vv 
	ProjectIdvv %
,vv% &

CategoryIdww 
=ww 
dtoww 
.ww 

CategoryIdww '
,ww' (
TypeIdxx 
=xx 
dtoxx 
.xx 
TypeIdxx 
,xx  

PriorityIdyy 
=yy 
dtoyy 
.yy 

PriorityIdyy '
,yy' (
RequesterUserIdzz 
=zz 
dtozz !
.zz! "
RequesterUserIdzz" 1
,zz1 2
StatusId{{ 
={{ 
defaultStatus{{ $
.{{$ %
Id{{% '
}|| 	
;||	 

_context}} 
.}} 
Tickets}} 
.}} 
Add}} 
(}} 
t}} 
)}} 
;}}  
await~~ 
_context~~ 
.~~ 
SaveChangesAsync~~ '
(~~' (
)~~( )
;~~) *
foreach
ÄÄ 
(
ÄÄ 
var
ÄÄ 
kvp
ÄÄ 
in
ÄÄ 
dto
ÄÄ 
.
ÄÄ  
CustomFields
ÄÄ  ,
)
ÄÄ, -
{
ÅÅ 	
var
ÇÇ 
def
ÇÇ 
=
ÇÇ 
await
ÇÇ 
_context
ÇÇ $
.
ÇÇ$ %
FieldDefinitions
ÇÇ% 5
.
ÇÇ5 6!
FirstOrDefaultAsync
ÇÇ6 I
(
ÇÇI J
fd
ÇÇJ L
=>
ÇÇM O
fd
ÇÇP R
.
ÇÇR S
Key
ÇÇS V
==
ÇÇW Y
kvp
ÇÇZ ]
.
ÇÇ] ^
Key
ÇÇ^ a
)
ÇÇa b
;
ÇÇb c
if
ÉÉ 
(
ÉÉ 
def
ÉÉ 
!=
ÉÉ 
null
ÉÉ 
)
ÉÉ 
{
ÑÑ 
_context
ÖÖ 
.
ÖÖ 
TicketFieldValues
ÖÖ *
.
ÖÖ* +
Add
ÖÖ+ .
(
ÖÖ. /
new
ÖÖ/ 2
TicketFieldValue
ÖÖ3 C
{
ÜÜ 
TicketId
áá 
=
áá 
t
áá  
.
áá  !
Id
áá! #
,
áá# $
FieldDefinitionId
àà %
=
àà& '
def
àà( +
.
àà+ ,
Id
àà, .
,
àà. /
ValueString
ââ 
=
ââ  !
kvp
ââ" %
.
ââ% &
Value
ââ& +
}
ää 
)
ää 
;
ää 
}
ãã 
}
åå 	
_context
éé 
.
éé 
TicketHistories
éé  
.
éé  !
Add
éé! $
(
éé$ %
new
éé% (
TicketHistory
éé) 6
{
èè 	
TicketId
êê 
=
êê 
t
êê 
.
êê 
Id
êê 
,
êê 
Action
ëë 
=
ëë 
$str
ëë 
,
ëë 
	FieldName
íí 
=
íí 
$str
íí  
,
íí  !
NewValue
ìì 
=
ìì 
t
ìì 
.
ìì 
TicketNumber
ìì %
,
ìì% &
	CreatedBy
îî 
=
îî 
dto
îî 
.
îî 
RequesterUserId
îî +
.
îî+ ,
ToString
îî, 4
(
îî4 5
)
îî5 6
}
ïï 	
)
ïï	 

;
ïï
 
await
ññ 
_context
ññ 
.
ññ 
SaveChangesAsync
ññ '
(
ññ' (
)
ññ( )
;
ññ) *
await
òò 

_slaEngine
òò 
.
òò $
AttachSlaToTicketAsync
òò /
(
òò/ 0
t
òò0 1
.
òò1 2
Id
òò2 4
)
òò4 5
;
òò5 6
return
öö 
new
öö 
	TicketDto
öö 
(
öö 
t
öö 
.
öö 
Id
öö !
,
öö! "
t
öö# $
.
öö$ %
TicketNumber
öö% 1
,
öö1 2
t
öö3 4
.
öö4 5
Title
öö5 :
,
öö: ;
t
öö< =
.
öö= >
Description
öö> I
,
ööI J
t
ööK L
.
ööL M
	ProjectId
ööM V
,
ööV W
t
ööX Y
.
ööY Z

CategoryId
ööZ d
,
ööd e
t
ööf g
.
öög h
TypeId
ööh n
,
öön o
t
ööp q
.
ööq r
StatusId
öör z
,
ööz {
t
öö| }
.
öö} ~

PriorityIdöö~ à
,ööà â
tööä ã
.ööã å
RequesterUserIdööå õ
,ööõ ú
tööù û
.ööû ü
AssignedUserIdööü ≠
,öö≠ Æ
tööØ ∞
.öö∞ ±
AssignedGroupIdöö± ¿
)öö¿ ¡
;öö¡ ¬
}
õõ 
public
ùù 

async
ùù 
Task
ùù 
<
ùù 
	TicketDto
ùù 
?
ùù  
>
ùù  ! 
GetTicketByIdAsync
ùù" 4
(
ùù4 5
int
ùù5 8
id
ùù9 ;
)
ùù; <
{
ûû 
var
üü 
t
üü 
=
üü 
await
üü 
_context
üü 
.
üü 
Tickets
üü &
.
üü& '!
FirstOrDefaultAsync
üü' :
(
üü: ;
x
üü; <
=>
üü= ?
x
üü@ A
.
üüA B
Id
üüB D
==
üüE G
id
üüH J
&&
üüK M
!
üüN O
x
üüO P
.
üüP Q
	IsDeleted
üüQ Z
)
üüZ [
;
üü[ \
if
†† 

(
†† 
t
†† 
==
†† 
null
†† 
)
†† 
return
†† 
null
†† "
;
††" #
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

PriorityId°°~ à
,°°à â
t°°ä ã
.°°ã å
RequesterUserId°°å õ
,°°õ ú
t°°ù û
.°°û ü
AssignedUserId°°ü ≠
,°°≠ Æ
t°°Ø ∞
.°°∞ ±
AssignedGroupId°°± ¿
)°°¿ ¡
;°°¡ ¬
}
¢¢ 
public
§§ 

async
§§ 
Task
§§ 
UpdateTicketAsync
§§ '
(
§§' (
int
§§( +
id
§§, .
,
§§. /
UpdateTicketDto
§§0 ?
dto
§§@ C
,
§§C D
int
§§E H
currentUserId
§§I V
)
§§V W
{
•• 
var
¶¶ 
t
¶¶ 
=
¶¶ 
await
¶¶ 
_context
¶¶ 
.
¶¶ 
Tickets
¶¶ &
.
¶¶& '!
FirstOrDefaultAsync
¶¶' :
(
¶¶: ;
x
¶¶; <
=>
¶¶= ?
x
¶¶@ A
.
¶¶A B
Id
¶¶B D
==
¶¶E G
id
¶¶H J
&&
¶¶K M
!
¶¶N O
x
¶¶O P
.
¶¶P Q
	IsDeleted
¶¶Q Z
)
¶¶Z [
;
¶¶[ \
if
ßß 

(
ßß 
t
ßß 
==
ßß 
null
ßß 
)
ßß 
throw
ßß 
new
ßß  "
KeyNotFoundException
ßß! 5
(
ßß5 6#
TicketNotFoundMessage
ßß6 K
)
ßßK L
;
ßßL M
await
©© (
ValidateDynamicFieldsAsync
©© (
(
©©( )
t
©©) *
.
©©* +
	ProjectId
©©+ 4
,
©©4 5
dto
©©6 9
.
©©9 :

CategoryId
©©: D
,
©©D E
t
©©F G
.
©©G H
TypeId
©©H N
,
©©N O
dto
©©P S
.
©©S T
CustomFields
©©T `
)
©©` a
;
©©a b
t
´´ 	
.
´´	 

Title
´´
 
=
´´ 
dto
´´ 
.
´´ 
Title
´´ 
;
´´ 
t
¨¨ 	
.
¨¨	 

Description
¨¨
 
=
¨¨ 
dto
¨¨ 
.
¨¨ 
Description
¨¨ '
;
¨¨' (
t
≠≠ 	
.
≠≠	 


CategoryId
≠≠
 
=
≠≠ 
dto
≠≠ 
.
≠≠ 

CategoryId
≠≠ %
;
≠≠% &
t
ÆÆ 	
.
ÆÆ	 


PriorityId
ÆÆ
 
=
ÆÆ 
dto
ÆÆ 
.
ÆÆ 

PriorityId
ÆÆ %
;
ÆÆ% &
await
≥≥ 
_context
≥≥ 
.
≥≥ 
SaveChangesAsync
≥≥ '
(
≥≥' (
)
≥≥( )
;
≥≥) *
}
¥¥ 
public
∂∂ 

async
∂∂ 
Task
∂∂ 
ChangeStatusAsync
∂∂ '
(
∂∂' (
int
∂∂( +
ticketId
∂∂, 4
,
∂∂4 5
ChangeStatusDto
∂∂6 E
dto
∂∂F I
)
∂∂I J
{
∑∑ 
var
∏∏ 
t
∏∏ 
=
∏∏ 
await
∏∏ 
_context
∏∏ 
.
∏∏ 
Tickets
∏∏ &
.
∏∏& '!
FirstOrDefaultAsync
∏∏' :
(
∏∏: ;
x
∏∏; <
=>
∏∏= ?
x
∏∏@ A
.
∏∏A B
Id
∏∏B D
==
∏∏E G
ticketId
∏∏H P
&&
∏∏Q S
!
∏∏T U
x
∏∏U V
.
∏∏V W
	IsDeleted
∏∏W `
)
∏∏` a
;
∏∏a b
if
ππ 

(
ππ 
t
ππ 
==
ππ 
null
ππ 
)
ππ 
throw
ππ 
new
ππ  "
KeyNotFoundException
ππ! 5
(
ππ5 6#
TicketNotFoundMessage
ππ6 K
)
ππK L
;
ππL M
if
ªª 

(
ªª 
t
ªª 
.
ªª 
StatusId
ªª 
==
ªª 
dto
ªª 
.
ªª 
NewStatusId
ªª )
)
ªª) *
return
ªª+ 1
;
ªª1 2
var
ææ 
wf
ææ 
=
ææ 
await
ææ 
_context
ææ 
.
ææ  
	Workflows
ææ  )
.
ææ) *!
FirstOrDefaultAsync
ææ* =
(
ææ= >
w
ææ> ?
=>
ææ@ B
(
ææC D
w
ææD E
.
ææE F
	ProjectId
ææF O
==
ææP R
t
ææS T
.
ææT U
	ProjectId
ææU ^
||
ææ_ a
w
ææb c
.
ææc d
	ProjectId
ææd m
==
ææn p
null
ææq u
)
ææu v
&&
ææw y
!
ææz {
w
ææ{ |
.
ææ| }
	IsDeletedææ} Ü
)ææÜ á
;ææá à
if
øø 

(
øø 
wf
øø 
==
øø 
null
øø 
)
øø 
throw
øø 
new
øø !'
InvalidOperationException
øø" ;
(
øø; <
$str
øø< \
)
øø\ ]
;
øø] ^
var
¡¡ 

transition
¡¡ 
=
¡¡ 
await
¡¡ 
_context
¡¡ '
.
¡¡' (!
WorkflowTransitions
¡¡( ;
.
¡¡; <!
FirstOrDefaultAsync
¡¡< O
(
¡¡O P
wt
¡¡P R
=>
¡¡S U
wt
¬¬ 
.
¬¬ 

WorkflowId
¬¬ 
==
¬¬ 
wf
¬¬ 
.
¬¬  
Id
¬¬  "
&&
¬¬# %
wt
¬¬& (
.
¬¬( )
FromStatusId
¬¬) 5
==
¬¬6 8
t
¬¬9 :
.
¬¬: ;
StatusId
¬¬; C
&&
¬¬D F
wt
¬¬G I
.
¬¬I J

ToStatusId
¬¬J T
==
¬¬U W
dto
¬¬X [
.
¬¬[ \
NewStatusId
¬¬\ g
&&
¬¬h j
!
¬¬k l
wt
¬¬l n
.
¬¬n o
	IsDeleted
¬¬o x
&&
¬¬y {
wt
¬¬| ~
.
¬¬~ 
IsActive¬¬ á
)¬¬á à
;¬¬à â
if
ƒƒ 

(
ƒƒ 

transition
ƒƒ 
==
ƒƒ 
null
ƒƒ 
)
ƒƒ 
throw
≈≈ 
new
≈≈ '
InvalidOperationException
≈≈ /
(
≈≈/ 0
$str
≈≈0 L
)
≈≈L M
;
≈≈M N
if
«« 

(
«« 
!
«« 
string
«« 
.
«« 
IsNullOrEmpty
«« !
(
««! "

transition
««" ,
.
««, -#
RequiredPermissionKey
««- B
)
««B C
)
««C D
{
»» 	
var
…… 
perms
…… 
=
…… 
await
…… #
_permissionCalculator
…… 3
.
……3 40
"CalculateEffectivePermissionsAsync
……4 V
(
……V W
dto
……W Z
.
……Z [
UserId
……[ a
)
……a b
;
……b c
if
   
(
   
!
   
perms
   
.
   
Contains
   
(
    

transition
    *
.
  * +#
RequiredPermissionKey
  + @
)
  @ A
)
  A B
throw
ÀÀ 
new
ÀÀ )
UnauthorizedAccessException
ÀÀ 5
(
ÀÀ5 6
$"
ÀÀ6 8
$str
ÀÀ8 U
{
ÀÀU V

transition
ÀÀV `
.
ÀÀ` a#
RequiredPermissionKey
ÀÀa v
}
ÀÀv w
"
ÀÀw x
)
ÀÀx y
;
ÀÀy z
}
ÃÃ 	
var
ŒŒ 
	oldStatus
ŒŒ 
=
ŒŒ 
t
ŒŒ 
.
ŒŒ 
StatusId
ŒŒ "
;
ŒŒ" #
t
œœ 	
.
œœ	 

StatusId
œœ
 
=
œœ 
dto
œœ 
.
œœ 
NewStatusId
œœ $
;
œœ$ %
_context
—— 
.
—— 
TicketHistories
——  
.
——  !
Add
——! $
(
——$ %
new
——% (
TicketHistory
——) 6
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
‘‘ 
=
‘‘ 
$str
‘‘ $
,
‘‘$ %
	FieldName
’’ 
=
’’ 
$str
’’ "
,
’’" #
OldValue
÷÷ 
=
÷÷ 
	oldStatus
÷÷  
.
÷÷  !
ToString
÷÷! )
(
÷÷) *
)
÷÷* +
,
÷÷+ ,
NewValue
◊◊ 
=
◊◊ 
dto
◊◊ 
.
◊◊ 
NewStatusId
◊◊ &
.
◊◊& '
ToString
◊◊' /
(
◊◊/ 0
)
◊◊0 1
,
◊◊1 2
	CreatedBy
ÿÿ 
=
ÿÿ 
dto
ÿÿ 
.
ÿÿ 
UserId
ÿÿ "
.
ÿÿ" #
ToString
ÿÿ# +
(
ÿÿ+ ,
)
ÿÿ, -
}
ŸŸ 	
)
ŸŸ	 

;
ŸŸ
 
await
€€ 
_context
€€ 
.
€€ 
SaveChangesAsync
€€ '
(
€€' (
)
€€( )
;
€€) *
await
›› 

_slaEngine
›› 
.
›› ,
ProcessTicketStatusChangeAsync
›› 7
(
››7 8
t
››8 9
.
››9 :
Id
››: <
,
››< =
	oldStatus
››> G
,
››G H
dto
››I L
.
››L M
NewStatusId
››M X
)
››X Y
;
››Y Z
}
ﬁﬁ 
public
‡‡ 

async
‡‡ 
Task
‡‡ 
AssignTicketAsync
‡‡ '
(
‡‡' (
int
‡‡( +
ticketId
‡‡, 4
,
‡‡4 5
AssignTicketDto
‡‡6 E
dto
‡‡F I
)
‡‡I J
{
·· 
var
‚‚ 
t
‚‚ 
=
‚‚ 
await
‚‚ 
_context
‚‚ 
.
‚‚ 
Tickets
‚‚ &
.
‚‚& '!
FirstOrDefaultAsync
‚‚' :
(
‚‚: ;
x
‚‚; <
=>
‚‚= ?
x
‚‚@ A
.
‚‚A B
Id
‚‚B D
==
‚‚E G
ticketId
‚‚H P
&&
‚‚Q S
!
‚‚T U
x
‚‚U V
.
‚‚V W
	IsDeleted
‚‚W `
)
‚‚` a
;
‚‚a b
if
„„ 

(
„„ 
t
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
„„5 6#
TicketNotFoundMessage
„„6 K
)
„„K L
;
„„L M
var
ÂÂ 
perms
ÂÂ 
=
ÂÂ 
await
ÂÂ #
_permissionCalculator
ÂÂ /
.
ÂÂ/ 00
"CalculateEffectivePermissionsAsync
ÂÂ0 R
(
ÂÂR S
dto
ÂÂS V
.
ÂÂV W
AssignerUserId
ÂÂW e
)
ÂÂe f
;
ÂÂf g
if
ÊÊ 

(
ÊÊ 
!
ÊÊ 
perms
ÊÊ 
.
ÊÊ 
Contains
ÊÊ 
(
ÊÊ 
$str
ÊÊ +
)
ÊÊ+ ,
)
ÊÊ, -
throw
ÊÊ. 3
new
ÊÊ4 7)
UnauthorizedAccessException
ÊÊ8 S
(
ÊÊS T
$str
ÊÊT w
)
ÊÊw x
;
ÊÊx y
var
ËË 
oldAssignee
ËË 
=
ËË 
t
ËË 
.
ËË 
AssignedUserId
ËË *
;
ËË* +
t
ÈÈ 	
.
ÈÈ	 

AssignedUserId
ÈÈ
 
=
ÈÈ 
dto
ÈÈ 
.
ÈÈ 
UserId
ÈÈ %
;
ÈÈ% &
_context
ÎÎ 
.
ÎÎ 
TicketHistories
ÎÎ  
.
ÎÎ  !
Add
ÎÎ! $
(
ÎÎ$ %
new
ÎÎ% (
TicketHistory
ÎÎ) 6
{
ÏÏ 	
TicketId
ÌÌ 
=
ÌÌ 
t
ÌÌ 
.
ÌÌ 
Id
ÌÌ 
,
ÌÌ 
Action
ÓÓ 
=
ÓÓ 
$str
ÓÓ 
,
ÓÓ  
	FieldName
ÔÔ 
=
ÔÔ 
$str
ÔÔ (
,
ÔÔ( )
OldValue
 
=
 
oldAssignee
 "
?
" #
.
# $
ToString
$ ,
(
, -
)
- .
,
. /
NewValue
ÒÒ 
=
ÒÒ 
dto
ÒÒ 
.
ÒÒ 
UserId
ÒÒ !
.
ÒÒ! "
ToString
ÒÒ" *
(
ÒÒ* +
)
ÒÒ+ ,
,
ÒÒ, -
	CreatedBy
ÚÚ 
=
ÚÚ 
dto
ÚÚ 
.
ÚÚ 
AssignerUserId
ÚÚ *
.
ÚÚ* +
ToString
ÚÚ+ 3
(
ÚÚ3 4
)
ÚÚ4 5
}
ÛÛ 	
)
ÛÛ	 

;
ÛÛ
 
await
ıı 
_context
ıı 
.
ıı 
SaveChangesAsync
ıı '
(
ıı' (
)
ıı( )
;
ıı) *
}
ˆˆ 
public
¯¯ 

async
¯¯ 
Task
¯¯ !
TransferTicketAsync
¯¯ )
(
¯¯) *
int
¯¯* -
ticketId
¯¯. 6
,
¯¯6 7
TransferTicketDto
¯¯8 I
dto
¯¯J M
)
¯¯M N
{
˘˘ 
var
˙˙ 
t
˙˙ 
=
˙˙ 
await
˙˙ 
_context
˙˙ 
.
˙˙ 
Tickets
˙˙ &
.
˙˙& '!
FirstOrDefaultAsync
˙˙' :
(
˙˙: ;
x
˙˙; <
=>
˙˙= ?
x
˙˙@ A
.
˙˙A B
Id
˙˙B D
==
˙˙E G
ticketId
˙˙H P
&&
˙˙Q S
!
˙˙T U
x
˙˙U V
.
˙˙V W
	IsDeleted
˙˙W `
)
˙˙` a
;
˙˙a b
if
˚˚ 

(
˚˚ 
t
˚˚ 
==
˚˚ 
null
˚˚ 
)
˚˚ 
throw
˚˚ 
new
˚˚  "
KeyNotFoundException
˚˚! 5
(
˚˚5 6#
TicketNotFoundMessage
˚˚6 K
)
˚˚K L
;
˚˚L M
var
˝˝ 
perms
˝˝ 
=
˝˝ 
await
˝˝ #
_permissionCalculator
˝˝ /
.
˝˝/ 00
"CalculateEffectivePermissionsAsync
˝˝0 R
(
˝˝R S
dto
˝˝S V
.
˝˝V W
TransferrerUserId
˝˝W h
)
˝˝h i
;
˝˝i j
if
˛˛ 

(
˛˛ 
!
˛˛ 
perms
˛˛ 
.
˛˛ 
Contains
˛˛ 
(
˛˛ 
$str
˛˛ -
)
˛˛- .
)
˛˛. /
throw
˛˛0 5
new
˛˛6 9)
UnauthorizedAccessException
˛˛: U
(
˛˛U V
$str
˛˛V {
)
˛˛{ |
;
˛˛| }
var
ÄÄ 
oldProj
ÄÄ 
=
ÄÄ 
t
ÄÄ 
.
ÄÄ 
	ProjectId
ÄÄ !
;
ÄÄ! "
var
ÅÅ 
oldGroup
ÅÅ 
=
ÅÅ 
t
ÅÅ 
.
ÅÅ 
AssignedGroupId
ÅÅ (
;
ÅÅ( )
if
ÉÉ 

(
ÉÉ 
dto
ÉÉ 
.
ÉÉ 
	ProjectId
ÉÉ 
.
ÉÉ 
HasValue
ÉÉ "
)
ÉÉ" #
t
ÉÉ$ %
.
ÉÉ% &
	ProjectId
ÉÉ& /
=
ÉÉ0 1
dto
ÉÉ2 5
.
ÉÉ5 6
	ProjectId
ÉÉ6 ?
.
ÉÉ? @
Value
ÉÉ@ E
;
ÉÉE F
if
ÑÑ 

(
ÑÑ 
dto
ÑÑ 
.
ÑÑ 
GroupId
ÑÑ 
.
ÑÑ 
HasValue
ÑÑ  
)
ÑÑ  !
t
ÑÑ" #
.
ÑÑ# $
AssignedGroupId
ÑÑ$ 3
=
ÑÑ4 5
dto
ÑÑ6 9
.
ÑÑ9 :
GroupId
ÑÑ: A
.
ÑÑA B
Value
ÑÑB G
;
ÑÑG H
_context
ÜÜ 
.
ÜÜ 
TicketHistories
ÜÜ  
.
ÜÜ  !
Add
ÜÜ! $
(
ÜÜ$ %
new
ÜÜ% (
TicketHistory
ÜÜ) 6
{
áá 	
TicketId
àà 
=
àà 
t
àà 
.
àà 
Id
àà 
,
àà 
Action
ââ 
=
ââ 
$str
ââ "
,
ââ" #
	FieldName
ää 
=
ää 
$str
ää "
,
ää" #
OldValue
ãã 
=
ãã 
$"
ãã 
$str
ãã 
{
ãã 
oldProj
ãã &
}
ãã& '
$str
ãã' ,
{
ãã, -
oldGroup
ãã- 5
}
ãã5 6
"
ãã6 7
,
ãã7 8
NewValue
åå 
=
åå 
$"
åå 
$str
åå 
{
åå 
t
åå  
.
åå  !
	ProjectId
åå! *
}
åå* +
$str
åå+ 0
{
åå0 1
t
åå1 2
.
åå2 3
AssignedGroupId
åå3 B
}
ååB C
"
ååC D
,
ååD E
	CreatedBy
çç 
=
çç 
dto
çç 
.
çç 
TransferrerUserId
çç -
.
çç- .
ToString
çç. 6
(
çç6 7
)
çç7 8
}
éé 	
)
éé	 

;
éé
 
await
êê 
_context
êê 
.
êê 
SaveChangesAsync
êê '
(
êê' (
)
êê( )
;
êê) *
}
ëë 
public
ìì 

async
ìì 
Task
ìì 
<
ìì 
TicketCommentDto
ìì &
>
ìì& '
AddCommentAsync
ìì( 7
(
ìì7 8
int
ìì8 ;
ticketId
ìì< D
,
ììD E
CreateCommentDto
ììF V
dto
ììW Z
)
ììZ [
{
îî 
var
ïï 
c
ïï 
=
ïï 
new
ïï 
TicketComment
ïï !
{
ññ 	
TicketId
óó 
=
óó 
ticketId
óó 
,
óó  
Content
òò 
=
òò 
dto
òò 
.
òò 
Content
òò !
,
òò! "

IsInternal
ôô 
=
ôô 
dto
ôô 
.
ôô 

IsInternal
ôô '
,
ôô' (
AuthorUserId
öö 
=
öö 
dto
öö 
.
öö 
AuthorUserId
öö +
}
õõ 	
;
õõ	 

_context
úú 
.
úú 
TicketComments
úú 
.
úú  
Add
úú  #
(
úú# $
c
úú$ %
)
úú% &
;
úú& '
_context
ûû 
.
ûû 
TicketHistories
ûû  
.
ûû  !
Add
ûû! $
(
ûû$ %
new
ûû% (
TicketHistory
ûû) 6
{
üü 	
TicketId
†† 
=
†† 
ticketId
†† 
,
††  
Action
°° 
=
°° 
$str
°° #
,
°°# $
	FieldName
¢¢ 
=
¢¢ 
$str
¢¢ !
,
¢¢! "
NewValue
££ 
=
££ 
c
££ 
.
££ 
Id
££ 
.
££ 
ToString
££ $
(
££$ %
)
££% &
,
££& '
	CreatedBy
§§ 
=
§§ 
dto
§§ 
.
§§ 
AuthorUserId
§§ (
.
§§( )
ToString
§§) 1
(
§§1 2
)
§§2 3
}
•• 	
)
••	 

;
••
 
await
ßß 
_context
ßß 
.
ßß 
SaveChangesAsync
ßß '
(
ßß' (
)
ßß( )
;
ßß) *
await
©© 

_slaEngine
©© 
.
©© '
ProcessTicketCommentAsync
©© 2
(
©©2 3
ticketId
©©3 ;
,
©©; <
dto
©©= @
.
©©@ A

IsInternal
©©A K
)
©©K L
;
©©L M
return
´´ 
new
´´ 
TicketCommentDto
´´ #
(
´´# $
c
´´$ %
.
´´% &
Id
´´& (
,
´´( )
c
´´* +
.
´´+ ,
TicketId
´´, 4
,
´´4 5
c
´´6 7
.
´´7 8
AuthorUserId
´´8 D
,
´´D E
c
´´F G
.
´´G H
Content
´´H O
,
´´O P
c
´´Q R
.
´´R S

IsInternal
´´S ]
,
´´] ^
c
´´_ `
.
´´` a
	CreatedAt
´´a j
)
´´j k
;
´´k l
}
¨¨ 
public
ÆÆ 

async
ÆÆ 
Task
ÆÆ 
<
ÆÆ 
IEnumerable
ÆÆ !
<
ÆÆ! "
TicketCommentDto
ÆÆ" 2
>
ÆÆ2 3
>
ÆÆ3 4
GetCommentsAsync
ÆÆ5 E
(
ÆÆE F
int
ÆÆF I
ticketId
ÆÆJ R
,
ÆÆR S
bool
ÆÆT X
includeInternal
ÆÆY h
)
ÆÆh i
{
ØØ 
var
∞∞ 
q
∞∞ 
=
∞∞ 
_context
∞∞ 
.
∞∞ 
TicketComments
∞∞ '
.
∞∞' (
Where
∞∞( -
(
∞∞- .
c
∞∞. /
=>
∞∞0 2
c
∞∞3 4
.
∞∞4 5
TicketId
∞∞5 =
==
∞∞> @
ticketId
∞∞A I
&&
∞∞J L
!
∞∞M N
c
∞∞N O
.
∞∞O P
	IsDeleted
∞∞P Y
)
∞∞Y Z
;
∞∞Z [
if
±± 

(
±± 
!
±± 
includeInternal
±± 
)
±± 
q
±± 
=
±±  !
q
±±" #
.
±±# $
Where
±±$ )
(
±±) *
c
±±* +
=>
±±, .
!
±±/ 0
c
±±0 1
.
±±1 2

IsInternal
±±2 <
)
±±< =
;
±±= >
var
≥≥ 
list
≥≥ 
=
≥≥ 
await
≥≥ 
q
≥≥ 
.
≥≥ 
OrderBy
≥≥ "
(
≥≥" #
c
≥≥# $
=>
≥≥% '
c
≥≥( )
.
≥≥) *
	CreatedAt
≥≥* 3
)
≥≥3 4
.
≥≥4 5
ToListAsync
≥≥5 @
(
≥≥@ A
)
≥≥A B
;
≥≥B C
return
¥¥ 
list
¥¥ 
.
¥¥ 
Select
¥¥ 
(
¥¥ 
c
¥¥ 
=>
¥¥ 
new
¥¥  #
TicketCommentDto
¥¥$ 4
(
¥¥4 5
c
¥¥5 6
.
¥¥6 7
Id
¥¥7 9
,
¥¥9 :
c
¥¥; <
.
¥¥< =
TicketId
¥¥= E
,
¥¥E F
c
¥¥G H
.
¥¥H I
AuthorUserId
¥¥I U
,
¥¥U V
c
¥¥W X
.
¥¥X Y
Content
¥¥Y `
,
¥¥` a
c
¥¥b c
.
¥¥c d

IsInternal
¥¥d n
,
¥¥n o
c
¥¥p q
.
¥¥q r
	CreatedAt
¥¥r {
)
¥¥{ |
)
¥¥| }
;
¥¥} ~
}
µµ 
public
∑∑ 

async
∑∑ 
Task
∑∑ 
<
∑∑ !
TicketAttachmentDto
∑∑ )
>
∑∑) * 
AddAttachmentAsync
∑∑+ =
(
∑∑= >
int
∑∑> A
ticketId
∑∑B J
,
∑∑J K
	IFormFile
∑∑L U
file
∑∑V Z
,
∑∑Z [
int
∑∑\ _
userId
∑∑` f
)
∑∑f g
{
∏∏ 
var
ππ 
path
ππ 
=
ππ 
await
ππ 
_fileStorage
ππ %
.
ππ% &
SaveFileAsync
ππ& 3
(
ππ3 4
file
ππ4 8
,
ππ8 9
ticketId
ππ: B
)
ππB C
;
ππC D
var
ªª 
a
ªª 
=
ªª 
new
ªª 
TicketAttachment
ªª $
{
ºº 	
TicketId
ΩΩ 
=
ΩΩ 
ticketId
ΩΩ 
,
ΩΩ  
FileName
ææ 
=
ææ 
file
ææ 
.
ææ 
FileName
ææ $
,
ææ$ %
FilePath
øø 
=
øø 
path
øø 
,
øø 
FileSize
¿¿ 
=
¿¿ 
file
¿¿ 
.
¿¿ 
Length
¿¿ "
,
¿¿" #
ContentType
¡¡ 
=
¡¡ 
file
¡¡ 
.
¡¡ 
ContentType
¡¡ *
,
¡¡* +
UploadedByUserId
¬¬ 
=
¬¬ 
userId
¬¬ %
}
√√ 	
;
√√	 

_context
ƒƒ 
.
ƒƒ 
TicketAttachments
ƒƒ "
.
ƒƒ" #
Add
ƒƒ# &
(
ƒƒ& '
a
ƒƒ' (
)
ƒƒ( )
;
ƒƒ) *
_context
∆∆ 
.
∆∆ 
TicketHistories
∆∆  
.
∆∆  !
Add
∆∆! $
(
∆∆$ %
new
∆∆% (
TicketHistory
∆∆) 6
{
«« 	
TicketId
»» 
=
»» 
ticketId
»» 
,
»»  
Action
…… 
=
…… 
$str
…… &
,
……& '
	FieldName
   
=
   
$str
   $
,
  $ %
NewValue
ÀÀ 
=
ÀÀ 
a
ÀÀ 
.
ÀÀ 
FileName
ÀÀ !
,
ÀÀ! "
	CreatedBy
ÃÃ 
=
ÃÃ 
userId
ÃÃ 
.
ÃÃ 
ToString
ÃÃ '
(
ÃÃ' (
)
ÃÃ( )
}
ÕÕ 	
)
ÕÕ	 

;
ÕÕ
 
await
œœ 
_context
œœ 
.
œœ 
SaveChangesAsync
œœ '
(
œœ' (
)
œœ( )
;
œœ) *
return
–– 
new
–– !
TicketAttachmentDto
–– &
(
––& '
a
––' (
.
––( )
Id
––) +
,
––+ ,
a
––- .
.
––. /
TicketId
––/ 7
,
––7 8
a
––9 :
.
––: ;
FileName
––; C
,
––C D
a
––E F
.
––F G
FilePath
––G O
,
––O P
a
––Q R
.
––R S
FileSize
––S [
,
––[ \
a
––] ^
.
––^ _
ContentType
––_ j
,
––j k
a
––l m
.
––m n
UploadedByUserId
––n ~
,
––~ 
a––Ä Å
.––Å Ç
	CreatedAt––Ç ã
)––ã å
;––å ç
}
—— 
public
”” 

async
”” 
Task
”” 
<
”” 
IEnumerable
”” !
<
””! "!
TicketAttachmentDto
””" 5
>
””5 6
>
””6 7!
GetAttachmentsAsync
””8 K
(
””K L
int
””L O
ticketId
””P X
)
””X Y
{
‘‘ 
var
’’ 
list
’’ 
=
’’ 
await
’’ 
_context
’’ !
.
’’! "
TicketAttachments
’’" 3
.
’’3 4
Where
’’4 9
(
’’9 :
a
’’: ;
=>
’’< >
a
’’? @
.
’’@ A
TicketId
’’A I
==
’’J L
ticketId
’’M U
&&
’’V X
!
’’Y Z
a
’’Z [
.
’’[ \
	IsDeleted
’’\ e
)
’’e f
.
’’f g
ToListAsync
’’g r
(
’’r s
)
’’s t
;
’’t u
return
÷÷ 
list
÷÷ 
.
÷÷ 
Select
÷÷ 
(
÷÷ 
a
÷÷ 
=>
÷÷ 
new
÷÷  #!
TicketAttachmentDto
÷÷$ 7
(
÷÷7 8
a
÷÷8 9
.
÷÷9 :
Id
÷÷: <
,
÷÷< =
a
÷÷> ?
.
÷÷? @
TicketId
÷÷@ H
,
÷÷H I
a
÷÷J K
.
÷÷K L
FileName
÷÷L T
,
÷÷T U
a
÷÷V W
.
÷÷W X
FilePath
÷÷X `
,
÷÷` a
a
÷÷b c
.
÷÷c d
FileSize
÷÷d l
,
÷÷l m
a
÷÷n o
.
÷÷o p
ContentType
÷÷p {
,
÷÷{ |
a
÷÷} ~
.
÷÷~ 
UploadedByUserId÷÷ è
,÷÷è ê
a÷÷ë í
.÷÷í ì
	CreatedAt÷÷ì ú
)÷÷ú ù
)÷÷ù û
;÷÷û ü
}
◊◊ 
public
ŸŸ 

async
ŸŸ 
Task
ŸŸ 
AddWatcherAsync
ŸŸ %
(
ŸŸ% &
int
ŸŸ& )
ticketId
ŸŸ* 2
,
ŸŸ2 3
int
ŸŸ4 7
userId
ŸŸ8 >
)
ŸŸ> ?
{
⁄⁄ 
var
€€ 
exists
€€ 
=
€€ 
await
€€ 
_context
€€ #
.
€€# $
TicketWatchers
€€$ 2
.
€€2 3
AnyAsync
€€3 ;
(
€€; <
w
€€< =
=>
€€> @
w
€€A B
.
€€B C
TicketId
€€C K
==
€€L N
ticketId
€€O W
&&
€€X Z
w
€€[ \
.
€€\ ]
UserId
€€] c
==
€€d f
userId
€€g m
&&
€€n p
!
€€q r
w
€€r s
.
€€s t
	IsDeleted
€€t }
)
€€} ~
;
€€~ 
if
‹‹ 

(
‹‹ 
!
‹‹ 
exists
‹‹ 
)
‹‹ 
{
›› 	
_context
ﬁﬁ 
.
ﬁﬁ 
TicketWatchers
ﬁﬁ #
.
ﬁﬁ# $
Add
ﬁﬁ$ '
(
ﬁﬁ' (
new
ﬁﬁ( +
TicketWatcher
ﬁﬁ, 9
{
ﬁﬁ: ;
TicketId
ﬁﬁ< D
=
ﬁﬁE F
ticketId
ﬁﬁG O
,
ﬁﬁO P
UserId
ﬁﬁQ W
=
ﬁﬁX Y
userId
ﬁﬁZ `
}
ﬁﬁa b
)
ﬁﬁb c
;
ﬁﬁc d
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
‡‡ 	
}
·· 
public
„„ 

async
„„ 
Task
„„  
RemoveWatcherAsync
„„ (
(
„„( )
int
„„) ,
ticketId
„„- 5
,
„„5 6
int
„„7 :
userId
„„; A
)
„„A B
{
‰‰ 
var
ÂÂ 
w
ÂÂ 
=
ÂÂ 
await
ÂÂ 
_context
ÂÂ 
.
ÂÂ 
TicketWatchers
ÂÂ -
.
ÂÂ- .!
FirstOrDefaultAsync
ÂÂ. A
(
ÂÂA B
x
ÂÂB C
=>
ÂÂD F
x
ÂÂG H
.
ÂÂH I
TicketId
ÂÂI Q
==
ÂÂR T
ticketId
ÂÂU ]
&&
ÂÂ^ `
x
ÂÂa b
.
ÂÂb c
UserId
ÂÂc i
==
ÂÂj l
userId
ÂÂm s
&&
ÂÂt v
!
ÂÂw x
x
ÂÂx y
.
ÂÂy z
	IsDeletedÂÂz É
)ÂÂÉ Ñ
;ÂÂÑ Ö
if
ÊÊ 

(
ÊÊ 
w
ÊÊ 
!=
ÊÊ 
null
ÊÊ 
)
ÊÊ 
{
ÁÁ 	
_context
ËË 
.
ËË 
TicketWatchers
ËË #
.
ËË# $
Remove
ËË$ *
(
ËË* +
w
ËË+ ,
)
ËË, -
;
ËË- .
await
ÈÈ 
_context
ÈÈ 
.
ÈÈ 
SaveChangesAsync
ÈÈ +
(
ÈÈ+ ,
)
ÈÈ, -
;
ÈÈ- .
}
ÍÍ 	
}
ÎÎ 
public
ÌÌ 

async
ÌÌ 
Task
ÌÌ 
<
ÌÌ 
IEnumerable
ÌÌ !
<
ÌÌ! "
TicketWatcherDto
ÌÌ" 2
>
ÌÌ2 3
>
ÌÌ3 4
GetWatchersAsync
ÌÌ5 E
(
ÌÌE F
int
ÌÌF I
ticketId
ÌÌJ R
)
ÌÌR S
{
ÓÓ 
var
ÔÔ 
list
ÔÔ 
=
ÔÔ 
await
ÔÔ 
_context
ÔÔ !
.
ÔÔ! "
TicketWatchers
ÔÔ" 0
.
ÔÔ0 1
Where
ÔÔ1 6
(
ÔÔ6 7
w
ÔÔ7 8
=>
ÔÔ9 ;
w
ÔÔ< =
.
ÔÔ= >
TicketId
ÔÔ> F
==
ÔÔG I
ticketId
ÔÔJ R
&&
ÔÔS U
!
ÔÔV W
w
ÔÔW X
.
ÔÔX Y
	IsDeleted
ÔÔY b
)
ÔÔb c
.
ÔÔc d
ToListAsync
ÔÔd o
(
ÔÔo p
)
ÔÔp q
;
ÔÔq r
return
 
list
 
.
 
Select
 
(
 
w
 
=>
 
new
  #
TicketWatcherDto
$ 4
(
4 5
w
5 6
.
6 7
TicketId
7 ?
,
? @
w
A B
.
B C
UserId
C I
)
I J
)
J K
;
K L
}
ÒÒ 
public
ÛÛ 

async
ÛÛ 
Task
ÛÛ 
<
ÛÛ 
IEnumerable
ÛÛ !
<
ÛÛ! "
TimelineEventDto
ÛÛ" 2
>
ÛÛ2 3
>
ÛÛ3 4
GetTimelineAsync
ÛÛ5 E
(
ÛÛE F
int
ÛÛF I
ticketId
ÛÛJ R
,
ÛÛR S
bool
ÛÛT X
includeInternal
ÛÛY h
)
ÛÛh i
{
ÙÙ 
var
ıı 
events
ıı 
=
ıı 
new
ıı 
List
ıı 
<
ıı 
TimelineEventDto
ıı .
>
ıı. /
(
ıı/ 0
)
ıı0 1
;
ıı1 2
var
˜˜ 
	histories
˜˜ 
=
˜˜ 
await
˜˜ 
_context
˜˜ &
.
˜˜& '
TicketHistories
˜˜' 6
.
˜˜6 7
Where
˜˜7 <
(
˜˜< =
h
˜˜= >
=>
˜˜? A
h
˜˜B C
.
˜˜C D
TicketId
˜˜D L
==
˜˜M O
ticketId
˜˜P X
&&
˜˜Y [
!
˜˜\ ]
h
˜˜] ^
.
˜˜^ _
	IsDeleted
˜˜_ h
)
˜˜h i
.
˜˜i j
ToListAsync
˜˜j u
(
˜˜u v
)
˜˜v w
;
˜˜w x
events
¯¯ 
.
¯¯ 
AddRange
¯¯ 
(
¯¯ 
	histories
¯¯ !
.
¯¯! "
Select
¯¯" (
(
¯¯( )
h
¯¯) *
=>
¯¯+ -
new
¯¯. 1
TimelineEventDto
¯¯2 B
(
¯¯B C
$str
¯¯C L
,
¯¯L M
h
¯¯N O
.
¯¯O P
	CreatedAt
¯¯P Y
,
¯¯Y Z
h
¯¯[ \
)
¯¯\ ]
)
¯¯] ^
)
¯¯^ _
;
¯¯_ `
var
˙˙ 
comments
˙˙ 
=
˙˙ 
await
˙˙ 
_context
˙˙ %
.
˙˙% &
TicketComments
˙˙& 4
.
˙˙4 5
Where
˙˙5 :
(
˙˙: ;
c
˙˙; <
=>
˙˙= ?
c
˙˙@ A
.
˙˙A B
TicketId
˙˙B J
==
˙˙K M
ticketId
˙˙N V
&&
˙˙W Y
!
˙˙Z [
c
˙˙[ \
.
˙˙\ ]
	IsDeleted
˙˙] f
)
˙˙f g
.
˙˙g h
ToListAsync
˙˙h s
(
˙˙s t
)
˙˙t u
;
˙˙u v
if
˚˚ 

(
˚˚ 
!
˚˚ 
includeInternal
˚˚ 
)
˚˚ 
comments
˚˚ &
=
˚˚' (
comments
˚˚) 1
.
˚˚1 2
Where
˚˚2 7
(
˚˚7 8
c
˚˚8 9
=>
˚˚: <
!
˚˚= >
c
˚˚> ?
.
˚˚? @

IsInternal
˚˚@ J
)
˚˚J K
.
˚˚K L
ToList
˚˚L R
(
˚˚R S
)
˚˚S T
;
˚˚T U
events
¸¸ 
.
¸¸ 
AddRange
¸¸ 
(
¸¸ 
comments
¸¸  
.
¸¸  !
Select
¸¸! '
(
¸¸' (
c
¸¸( )
=>
¸¸* ,
new
¸¸- 0
TimelineEventDto
¸¸1 A
(
¸¸A B
$str
¸¸B K
,
¸¸K L
c
¸¸M N
.
¸¸N O
	CreatedAt
¸¸O X
,
¸¸X Y
c
¸¸Z [
)
¸¸[ \
)
¸¸\ ]
)
¸¸] ^
;
¸¸^ _
var
˛˛ 
attachments
˛˛ 
=
˛˛ 
await
˛˛ 
_context
˛˛  (
.
˛˛( )
TicketAttachments
˛˛) :
.
˛˛: ;
Where
˛˛; @
(
˛˛@ A
a
˛˛A B
=>
˛˛C E
a
˛˛F G
.
˛˛G H
TicketId
˛˛H P
==
˛˛Q S
ticketId
˛˛T \
&&
˛˛] _
!
˛˛` a
a
˛˛a b
.
˛˛b c
	IsDeleted
˛˛c l
)
˛˛l m
.
˛˛m n
ToListAsync
˛˛n y
(
˛˛y z
)
˛˛z {
;
˛˛{ |
events
ˇˇ 
.
ˇˇ 
AddRange
ˇˇ 
(
ˇˇ 
attachments
ˇˇ #
.
ˇˇ# $
Select
ˇˇ$ *
(
ˇˇ* +
a
ˇˇ+ ,
=>
ˇˇ- /
new
ˇˇ0 3
TimelineEventDto
ˇˇ4 D
(
ˇˇD E
$str
ˇˇE Q
,
ˇˇQ R
a
ˇˇS T
.
ˇˇT U
	CreatedAt
ˇˇU ^
,
ˇˇ^ _
a
ˇˇ` a
)
ˇˇa b
)
ˇˇb c
)
ˇˇc d
;
ˇˇd e
return
ÅÅ 
events
ÅÅ 
.
ÅÅ 
OrderBy
ÅÅ 
(
ÅÅ 
e
ÅÅ 
=>
ÅÅ  "
e
ÅÅ# $
.
ÅÅ$ %
	Timestamp
ÅÅ% .
)
ÅÅ. /
;
ÅÅ/ 0
}
ÇÇ 
public
ÑÑ 

async
ÑÑ 
Task
ÑÑ 
<
ÑÑ 
PagedResult
ÑÑ !
<
ÑÑ! "
	TicketDto
ÑÑ" +
>
ÑÑ+ ,
>
ÑÑ, - 
SearchTicketsAsync
ÑÑ. @
(
ÑÑ@ A#
TicketSearchFilterDto
ÑÑA V
filter
ÑÑW ]
,
ÑÑ] ^
int
ÑÑ_ b
userId
ÑÑc i
)
ÑÑi j
{
ÖÖ 
var
ÜÜ 
perms
ÜÜ 
=
ÜÜ 
await
ÜÜ #
_permissionCalculator
ÜÜ /
.
ÜÜ/ 00
"CalculateEffectivePermissionsAsync
ÜÜ0 R
(
ÜÜR S
userId
ÜÜS Y
)
ÜÜY Z
;
ÜÜZ [
var
àà 
query
àà 
=
àà 
_context
àà 
.
àà 
Tickets
àà $
.
ââ 
Include
ââ 
(
ââ 
t
ââ 
=>
ââ 
t
ââ 
.
ââ 
	TicketSla
ââ %
)
ââ% &
.
ää 
Where
ää 
(
ää 
t
ää 
=>
ää 
!
ää 
t
ää 
.
ää 
	IsDeleted
ää $
)
ää$ %
;
ää% &
if
çç 

(
çç 
!
çç 
perms
çç 
.
çç 
Contains
çç 
(
çç 
$str
çç )
)
çç) *
)
çç* +
{
éé 	
var
èè 
isAgent
èè 
=
èè 
perms
èè 
.
èè  
Contains
èè  (
(
èè( )
$str
èè) 8
)
èè8 9
||
èè: <
perms
èè= B
.
èèB C
Contains
èèC K
(
èèK L
$str
èèL [
)
èè[ \
;
èè\ ]
if
êê 
(
êê 
isAgent
êê 
)
êê 
{
ëë 
var
íí 
userGroupIds
íí  
=
íí! "
await
íí# (
_context
íí) 1
.
íí1 2
GroupMembers
íí2 >
.
ìì 
Where
ìì 
(
ìì 
gm
ìì 
=>
ìì  
gm
ìì! #
.
ìì# $
UserId
ìì$ *
==
ìì+ -
userId
ìì. 4
&&
ìì5 7
!
ìì8 9
gm
ìì9 ;
.
ìì; <
	IsDeleted
ìì< E
)
ììE F
.
îî 
Select
îî 
(
îî 
gm
îî 
=>
îî !
gm
îî" $
.
îî$ %
GroupId
îî% ,
)
îî, -
.
ïï 
ToListAsync
ïï  
(
ïï  !
)
ïï! "
;
ïï" #
query
óó 
=
óó 
query
óó 
.
óó 
Where
óó #
(
óó# $
t
óó$ %
=>
óó& (
t
óó) *
.
óó* +
AssignedUserId
óó+ 9
==
óó: <
userId
óó= C
||
óóD F
(
òò( )
t
òò) *
.
òò* +
AssignedGroupId
òò+ :
.
òò: ;
HasValue
òò; C
&&
òòD F
userGroupIds
òòG S
.
òòS T
Contains
òòT \
(
òò\ ]
t
òò] ^
.
òò^ _
AssignedGroupId
òò_ n
.
òòn o
Value
òòo t
)
òòt u
)
òòu v
||
òòw y
t
ôô( )
.
ôô) *
RequesterUserId
ôô* 9
==
ôô: <
userId
ôô= C
)
ôôC D
;
ôôD E
}
öö 
else
õõ 
{
úú 
query
ùù 
=
ùù 
query
ùù 
.
ùù 
Where
ùù #
(
ùù# $
t
ùù$ %
=>
ùù& (
t
ùù) *
.
ùù* +
RequesterUserId
ùù+ :
==
ùù; =
userId
ùù> D
)
ùùD E
;
ùùE F
}
ûû 
}
üü 	
if
°° 

(
°° 
filter
°° 
.
°° 
	ProjectId
°° 
.
°° 
HasValue
°° %
)
°°% &
query
°°' ,
=
°°- .
query
°°/ 4
.
°°4 5
Where
°°5 :
(
°°: ;
t
°°; <
=>
°°= ?
t
°°@ A
.
°°A B
	ProjectId
°°B K
==
°°L N
filter
°°O U
.
°°U V
	ProjectId
°°V _
.
°°_ `
Value
°°` e
)
°°e f
;
°°f g
if
¢¢ 

(
¢¢ 
filter
¢¢ 
.
¢¢ 

CategoryId
¢¢ 
.
¢¢ 
HasValue
¢¢ &
)
¢¢& '
query
¢¢( -
=
¢¢. /
query
¢¢0 5
.
¢¢5 6
Where
¢¢6 ;
(
¢¢; <
t
¢¢< =
=>
¢¢> @
t
¢¢A B
.
¢¢B C

CategoryId
¢¢C M
==
¢¢N P
filter
¢¢Q W
.
¢¢W X

CategoryId
¢¢X b
.
¢¢b c
Value
¢¢c h
)
¢¢h i
;
¢¢i j
if
££ 

(
££ 
filter
££ 
.
££ 
TypeId
££ 
.
££ 
HasValue
££ "
)
££" #
query
££$ )
=
££* +
query
££, 1
.
££1 2
Where
££2 7
(
££7 8
t
££8 9
=>
££: <
t
££= >
.
££> ?
TypeId
££? E
==
££F H
filter
££I O
.
££O P
TypeId
££P V
.
££V W
Value
££W \
)
££\ ]
;
££] ^
if
§§ 

(
§§ 
filter
§§ 
.
§§ 
StatusId
§§ 
.
§§ 
HasValue
§§ $
)
§§$ %
query
§§& +
=
§§, -
query
§§. 3
.
§§3 4
Where
§§4 9
(
§§9 :
t
§§: ;
=>
§§< >
t
§§? @
.
§§@ A
StatusId
§§A I
==
§§J L
filter
§§M S
.
§§S T
StatusId
§§T \
.
§§\ ]
Value
§§] b
)
§§b c
;
§§c d
if
•• 

(
•• 
filter
•• 
.
•• 

PriorityId
•• 
.
•• 
HasValue
•• &
)
••& '
query
••( -
=
••. /
query
••0 5
.
••5 6
Where
••6 ;
(
••; <
t
••< =
=>
••> @
t
••A B
.
••B C

PriorityId
••C M
==
••N P
filter
••Q W
.
••W X

PriorityId
••X b
.
••b c
Value
••c h
)
••h i
;
••i j
if
¶¶ 

(
¶¶ 
filter
¶¶ 
.
¶¶ 
AssigneeUserId
¶¶ !
.
¶¶! "
HasValue
¶¶" *
)
¶¶* +
query
¶¶, 1
=
¶¶2 3
query
¶¶4 9
.
¶¶9 :
Where
¶¶: ?
(
¶¶? @
t
¶¶@ A
=>
¶¶B D
t
¶¶E F
.
¶¶F G
AssignedUserId
¶¶G U
==
¶¶V X
filter
¶¶Y _
.
¶¶_ `
AssigneeUserId
¶¶` n
.
¶¶n o
Value
¶¶o t
)
¶¶t u
;
¶¶u v
if
ßß 

(
ßß 
filter
ßß 
.
ßß 
RequesterUserId
ßß "
.
ßß" #
HasValue
ßß# +
)
ßß+ ,
query
ßß- 2
=
ßß3 4
query
ßß5 :
.
ßß: ;
Where
ßß; @
(
ßß@ A
t
ßßA B
=>
ßßC E
t
ßßF G
.
ßßG H
RequesterUserId
ßßH W
==
ßßX Z
filter
ßß[ a
.
ßßa b
RequesterUserId
ßßb q
.
ßßq r
Value
ßßr w
)
ßßw x
;
ßßx y
if
®® 

(
®® 
filter
®® 
.
®® 
FromDate
®® 
.
®® 
HasValue
®® $
)
®®$ %
query
®®& +
=
®®, -
query
®®. 3
.
®®3 4
Where
®®4 9
(
®®9 :
t
®®: ;
=>
®®< >
t
®®? @
.
®®@ A
	CreatedAt
®®A J
>=
®®K M
filter
®®N T
.
®®T U
FromDate
®®U ]
.
®®] ^
Value
®®^ c
)
®®c d
;
®®d e
if
©© 

(
©© 
filter
©© 
.
©© 
ToDate
©© 
.
©© 
HasValue
©© "
)
©©" #
query
©©$ )
=
©©* +
query
©©, 1
.
©©1 2
Where
©©2 7
(
©©7 8
t
©©8 9
=>
©©: <
t
©©= >
.
©©> ?
	CreatedAt
©©? H
<=
©©I K
filter
©©L R
.
©©R S
ToDate
©©S Y
.
©©Y Z
Value
©©Z _
)
©©_ `
;
©©` a
if
´´ 

(
´´ 
!
´´ 
string
´´ 
.
´´  
IsNullOrWhiteSpace
´´ &
(
´´& '
filter
´´' -
.
´´- .
Keyword
´´. 5
)
´´5 6
)
´´6 7
{
¨¨ 	
var
≠≠ 
kw
≠≠ 
=
≠≠ 
filter
≠≠ 
.
≠≠ 
Keyword
≠≠ #
.
≠≠# $
ToLower
≠≠$ +
(
≠≠+ ,
)
≠≠, -
;
≠≠- .
query
ÆÆ 
=
ÆÆ 
query
ÆÆ 
.
ÆÆ 
Where
ÆÆ 
(
ÆÆ  
t
ÆÆ  !
=>
ÆÆ" $
t
ØØ 
.
ØØ 
TicketNumber
ØØ 
.
ØØ 
ToLower
ØØ &
(
ØØ& '
)
ØØ' (
.
ØØ( )
Contains
ØØ) 1
(
ØØ1 2
kw
ØØ2 4
)
ØØ4 5
||
ØØ6 8
t
∞∞ 
.
∞∞ 
Title
∞∞ 
.
∞∞ 
ToLower
∞∞ 
(
∞∞  
)
∞∞  !
.
∞∞! "
Contains
∞∞" *
(
∞∞* +
kw
∞∞+ -
)
∞∞- .
||
∞∞/ 1
t
±± 
.
±± 
Description
±± 
.
±± 
ToLower
±± %
(
±±% &
)
±±& '
.
±±' (
Contains
±±( 0
(
±±0 1
kw
±±1 3
)
±±3 4
)
±±4 5
;
±±5 6
}
≤≤ 	
if
¥¥ 

(
¥¥ 
!
¥¥ 
string
¥¥ 
.
¥¥  
IsNullOrWhiteSpace
¥¥ &
(
¥¥& '
filter
¥¥' -
.
¥¥- .
	SlaStatus
¥¥. 7
)
¥¥7 8
)
¥¥8 9
{
µµ 	
var
∂∂ 
s
∂∂ 
=
∂∂ 
filter
∂∂ 
.
∂∂ 
	SlaStatus
∂∂ $
.
∂∂$ %
ToLower
∂∂% ,
(
∂∂, -
)
∂∂- .
;
∂∂. /
if
∑∑ 
(
∑∑ 
s
∑∑ 
==
∑∑ 
$str
∑∑ 
)
∑∑  
query
∏∏ 
=
∏∏ 
query
∏∏ 
.
∏∏ 
Where
∏∏ #
(
∏∏# $
t
∏∏$ %
=>
∏∏& (
t
∏∏) *
.
∏∏* +
	TicketSla
∏∏+ 4
!=
∏∏5 7
null
∏∏8 <
&&
∏∏= ?
(
∏∏@ A
t
∏∏A B
.
∏∏B C
	TicketSla
∏∏C L
.
∏∏L M#
FirstResponseBreached
∏∏M b
||
∏∏c e
t
∏∏f g
.
∏∏g h
	TicketSla
∏∏h q
.
∏∏q r!
ResolutionBreached∏∏r Ñ
)∏∏Ñ Ö
)∏∏Ö Ü
;∏∏Ü á
else
ππ 
if
ππ 
(
ππ 
s
ππ 
==
ππ 
$str
ππ #
)
ππ# $
query
∫∫ 
=
∫∫ 
query
∫∫ 
.
∫∫ 
Where
∫∫ #
(
∫∫# $
t
∫∫$ %
=>
∫∫& (
t
∫∫) *
.
∫∫* +
	TicketSla
∫∫+ 4
!=
∫∫5 7
null
∫∫8 <
&&
∫∫= ?
(
∫∫@ A
t
∫∫A B
.
∫∫B C
	TicketSla
∫∫C L
.
∫∫L M!
FirstResponseWarned
∫∫M `
||
∫∫a c
t
∫∫d e
.
∫∫e f
	TicketSla
∫∫f o
.
∫∫o p
ResolutionWarned∫∫p Ä
)∫∫Ä Å
&&∫∫Ç Ñ
!∫∫Ö Ü
(∫∫Ü á
t∫∫á à
.∫∫à â
	TicketSla∫∫â í
.∫∫í ì%
FirstResponseBreached∫∫ì ®
||∫∫© ´
t∫∫¨ ≠
.∫∫≠ Æ
	TicketSla∫∫Æ ∑
.∫∫∑ ∏"
ResolutionBreached∫∫∏  
)∫∫  À
)∫∫À Ã
;∫∫Ã Õ
else
ªª 
if
ªª 
(
ªª 
s
ªª 
==
ªª 
$str
ªª #
)
ªª# $
query
ºº 
=
ºº 
query
ºº 
.
ºº 
Where
ºº #
(
ºº# $
t
ºº$ %
=>
ºº& (
t
ºº) *
.
ºº* +
	TicketSla
ºº+ 4
!=
ºº5 7
null
ºº8 <
&&
ºº= ?
!
ºº@ A
t
ººA B
.
ººB C
	TicketSla
ººC L
.
ººL M!
FirstResponseWarned
ººM `
&&
ººa c
!
ººd e
t
ººe f
.
ººf g
	TicketSla
ººg p
.
ººp q
ResolutionWarnedººq Å
&&ººÇ Ñ
!ººÖ Ü
tººÜ á
.ººá à
	TicketSlaººà ë
.ººë í%
FirstResponseBreachedººí ß
&&ºº® ™
!ºº´ ¨
tºº¨ ≠
.ºº≠ Æ
	TicketSlaººÆ ∑
.ºº∑ ∏"
ResolutionBreachedºº∏  
)ºº  À
;ººÀ Ã
}
ΩΩ 	
query
¿¿ 
=
¿¿ 
filter
¿¿ 
.
¿¿ 
SortDescending
¿¿ %
?
¡¡ 
query
¡¡ 
.
¡¡ 
OrderByDescending
¡¡ %
(
¡¡% &
e
¡¡& '
=>
¡¡( *
EF
¡¡+ -
.
¡¡- .
Property
¡¡. 6
<
¡¡6 7
object
¡¡7 =
>
¡¡= >
(
¡¡> ?
e
¡¡? @
,
¡¡@ A
filter
¡¡B H
.
¡¡H I
SortBy
¡¡I O
??
¡¡P R
$str
¡¡S ^
)
¡¡^ _
)
¡¡_ `
:
¬¬ 
query
¬¬ 
.
¬¬ 
OrderBy
¬¬ 
(
¬¬ 
e
¬¬ 
=>
¬¬  
EF
¬¬! #
.
¬¬# $
Property
¬¬$ ,
<
¬¬, -
object
¬¬- 3
>
¬¬3 4
(
¬¬4 5
e
¬¬5 6
,
¬¬6 7
filter
¬¬8 >
.
¬¬> ?
SortBy
¬¬? E
??
¬¬F H
$str
¬¬I T
)
¬¬T U
)
¬¬U V
;
¬¬V W
var
ƒƒ 

totalCount
ƒƒ 
=
ƒƒ 
await
ƒƒ 
query
ƒƒ $
.
ƒƒ$ %

CountAsync
ƒƒ% /
(
ƒƒ/ 0
)
ƒƒ0 1
;
ƒƒ1 2
var
∆∆ 
tickets
∆∆ 
=
∆∆ 
await
∆∆ 
query
∆∆ !
.
«« 
Skip
«« 
(
«« 
(
«« 
filter
«« 
.
«« 
Page
«« 
-
««  
$num
««! "
)
««" #
*
««$ %
filter
««& ,
.
««, -
PageSize
««- 5
)
««5 6
.
»» 
Take
»» 
(
»» 
filter
»» 
.
»» 
PageSize
»» !
)
»»! "
.
…… 
Select
…… 
(
…… 
t
…… 
=>
…… 
new
…… 
	TicketDto
…… &
(
……& '
t
……' (
.
……( )
Id
……) +
,
……+ ,
t
……- .
.
……. /
TicketNumber
……/ ;
,
……; <
t
……= >
.
……> ?
Title
……? D
,
……D E
t
……F G
.
……G H
Description
……H S
,
……S T
t
……U V
.
……V W
	ProjectId
……W `
,
……` a
t
……b c
.
……c d

CategoryId
……d n
,
……n o
t
……p q
.
……q r
TypeId
……r x
,
……x y
t
……z {
.
……{ |
StatusId……| Ñ
,……Ñ Ö
t……Ü á
.……á à

PriorityId……à í
,……í ì
t……î ï
.……ï ñ
RequesterUserId……ñ •
,……• ¶
t……ß ®
.……® ©
AssignedUserId……© ∑
,……∑ ∏
t……π ∫
.……∫ ª
AssignedGroupId……ª  
)……  À
)……À Ã
.
   
ToListAsync
   
(
   
)
   
;
   
return
ÃÃ 
new
ÃÃ 
PagedResult
ÃÃ 
<
ÃÃ 
	TicketDto
ÃÃ (
>
ÃÃ( )
{
ÕÕ 	
Items
ŒŒ 
=
ŒŒ 
tickets
ŒŒ 
,
ŒŒ 

TotalCount
œœ 
=
œœ 

totalCount
œœ #
,
œœ# $
Page
–– 
=
–– 
filter
–– 
.
–– 
Page
–– 
,
–– 
PageSize
—— 
=
—— 
filter
—— 
.
—— 
PageSize
—— &
}
““ 	
;
““	 

}
”” 
}‘‘ π	
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
} âd
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
}tt ˝‚
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
;0 1
public 

	SlaEngine 
( 
ItsToolDbContext %
context& -
,- .
IEmailService/ <
emailService= I
)I J
{ 
_context 
= 
context 
; 
_emailService 
= 
emailService $
;$ %
} 
private 
async 
Task 
< 
DateTime 
>  !
CalculateDueTimeAsync! 6
(6 7
DateTime7 ?
startTimeUtc@ L
,L M
intN Q
minutesToAddR ^
)^ _
{ 
var 
holidays 
= 
await 
_context %
.% &
Holidays& .
.. /
ToListAsync/ :
(: ;
); <
;< =
var 
businessHours 
= 
await !
_context" *
.* +
BusinessHours+ 8
.8 9
ToListAsync9 D
(D E
)E F
;F G
var 
currentTime 
= 
startTimeUtc &
;& '
var 
minutesRemaining 
= 
minutesToAdd +
;+ ,
while!! 
(!! 
minutesRemaining!! 
>!!  !
$num!!" #
)!!# $
{"" 	
if## 
(## 
!## 
IsWorkingDay## 
(## 
currentTime## )
,##) *
holidays##+ 3
,##3 4
businessHours##5 B
)##B C
)##C D
{$$ 
currentTime%% 
=%% 
currentTime%% )
.%%) *
Date%%* .
.%%. /
AddDays%%/ 6
(%%6 7
$num%%7 8
)%%8 9
;%%9 :
continue&& 
;&& 
}'' 
var)) 
bh)) 
=)) 
GetWorkingWindow)) %
())% &
currentTime))& 1
,))1 2
businessHours))3 @
)))@ A
;))A B
var** 
(** 
newTime** 
,** 
	remaining** #
)**# $
=**% &#
ConsumeMinutesWithinDay**' >
(**> ?
currentTime**? J
,**J K
minutesRemaining**L \
,**\ ]
bh**^ `
.**` a
	StartTime**a j
,**j k
bh**l n
.**n o
EndTime**o v
)**v w
;**w x
currentTime,, 
=,, 
newTime,, !
;,,! "
minutesRemaining-- 
=-- 
	remaining-- (
;--( )
}.. 	
return00 
currentTime00 
;00 
}11 
public33 

static33 
bool33 
IsWorkingDay33 #
(33# $
DateTime33$ ,
date33- 1
,331 2
List333 7
<337 8
Holiday338 ?
>33? @
holidays33A I
,33I J
List33K O
<33O P
BusinessHour33P \
>33\ ]
businessHours33^ k
)33k l
{44 
if55 

(55 
holidays55 
.55 
Any55 
(55 
h55 
=>55 
h55 
.55  
Date55  $
.55$ %
Date55% )
==55* ,
date55- 1
.551 2
Date552 6
)556 7
)557 8
return559 ?
false55@ E
;55E F
var66 
bh66 
=66 
businessHours66 
.66 
FirstOrDefault66 -
(66- .
b66. /
=>660 2
b663 4
.664 5
	DayOfWeek665 >
==66? A
date66B F
.66F G
	DayOfWeek66G P
)66P Q
;66Q R
return77 
bh77 
!=77 
null77 
&&77 
bh77 
.77  
IsWorkingDay77  ,
;77, -
}88 
public:: 

static:: 
BusinessHour:: 
GetWorkingWindow:: /
(::/ 0
DateTime::0 8
date::9 =
,::= >
List::? C
<::C D
BusinessHour::D P
>::P Q
businessHours::R _
)::_ `
{;; 
return<< 
businessHours<< 
.<< 
First<< "
(<<" #
b<<# $
=><<% '
b<<( )
.<<) *
	DayOfWeek<<* 3
==<<4 6
date<<7 ;
.<<; <
	DayOfWeek<<< E
)<<E F
;<<F G
}== 
public?? 

static?? 
(?? 
DateTime?? 
newTime?? #
,??# $
int??% (
minutesRemaining??) 9
)??9 :#
ConsumeMinutesWithinDay??; R
(??R S
DateTime??S [
currentTime??\ g
,??g h
int??i l
minutesRemaining??m }
,??} ~
TimeSpan	?? á
	startTime
??à ë
,
??ë í
TimeSpan
??ì õ
endTime
??ú £
)
??£ §
{@@ 
varAA 
currentDayTimeAA 
=AA 
currentTimeAA (
.AA( )
	TimeOfDayAA) 2
;AA2 3
ifCC 

(CC 
currentDayTimeCC 
<CC 
	startTimeCC &
)CC& '
{DD 	
returnEE 
(EE 
currentTimeEE 
.EE  
DateEE  $
.EE$ %
AddEE% (
(EE( )
	startTimeEE) 2
)EE2 3
,EE3 4
minutesRemainingEE5 E
)EEE F
;EEF G
}FF 	
ifHH 

(HH 
currentDayTimeHH 
>=HH 
endTimeHH %
)HH% &
{II 	
returnJJ 
(JJ 
currentTimeJJ 
.JJ  
DateJJ  $
.JJ$ %
AddDaysJJ% ,
(JJ, -
$numJJ- .
)JJ. /
,JJ/ 0
minutesRemainingJJ1 A
)JJA B
;JJB C
}KK 	
varMM 
minutesToEoDMM 
=MM 
(MM 
intMM 
)MM  
(MM  !
endTimeMM! (
-MM) *
currentDayTimeMM+ 9
)MM9 :
.MM: ;
TotalMinutesMM; G
;MMG H
ifOO 

(OO 
minutesRemainingOO 
<=OO 
minutesToEoDOO  ,
)OO, -
{PP 	
returnQQ 
(QQ 
currentTimeQQ 
.QQ  

AddMinutesQQ  *
(QQ* +
minutesRemainingQQ+ ;
)QQ; <
,QQ< =
$numQQ> ?
)QQ? @
;QQ@ A
}RR 	
returnTT 
(TT 
currentTimeTT 
.TT 
DateTT  
.TT  !
AddDaysTT! (
(TT( )
$numTT) *
)TT* +
.TT+ ,
AddTT, /
(TT/ 0
	startTimeTT0 9
)TT9 :
,TT: ;
minutesRemainingTT< L
-TTM N
minutesToEoDTTO [
)TT[ \
;TT\ ]
}UU 
publicWW 

asyncWW 
TaskWW "
AttachSlaToTicketAsyncWW ,
(WW, -
intWW- 0
ticketIdWW1 9
)WW9 :
{XX 
varYY 
ticketYY 
=YY 
awaitYY 
_contextYY #
.YY# $
TicketsYY$ +
.YY+ ,
	FindAsyncYY, 5
(YY5 6
ticketIdYY6 >
)YY> ?
;YY? @
ifZZ 

(ZZ 
ticketZZ 
==ZZ 
nullZZ 
)ZZ 
returnZZ "
;ZZ" #
var\\ 
policy\\ 
=\\ 
await\\ 
_context\\ #
.\\# $
SlaPolicies\\$ /
.]] 
FirstOrDefaultAsync]]  
(]]  !
p]]! "
=>]]# %
p]]& '
.]]' (
IsActive]]( 0
&&]]1 3
(]]4 5
p]]5 6
.]]6 7
	ProjectId]]7 @
==]]A C
ticket]]D J
.]]J K
	ProjectId]]K T
||]]U W
p]]X Y
.]]Y Z
	ProjectId]]Z c
==]]d f
null]]g k
)]]k l
)]]l m
;]]m n
if__ 

(__ 
policy__ 
==__ 
null__ 
)__ 
return__ "
;__" #
varaa 
targetaa 
=aa 
awaitaa 
_contextaa #
.aa# $

SlaTargetsaa$ .
.bb 
FirstOrDefaultAsyncbb  
(bb  !
tbb! "
=>bb# %
tbb& '
.bb' (
SlaPolicyIdbb( 3
==bb4 6
policybb7 =
.bb= >
Idbb> @
&&bbA C
tbbD E
.bbE F

PriorityIdbbF P
==bbQ S
ticketbbT Z
.bbZ [

PriorityIdbb[ e
&&bbf h
(cc& '
tcc' (
.cc( )
TicketTypeIdcc) 5
==cc6 8
ticketcc9 ?
.cc? @
TypeIdcc@ F
||ccG I
tccJ K
.ccK L
TicketTypeIdccL X
==ccY [
nullcc\ `
)cc` a
)cca b
;ccb c
ifee 

(ee 
targetee 
==ee 
nullee 
)ee 
returnee "
;ee" #
vargg 
nowgg 
=gg 
DateTimegg 
.gg 
UtcNowgg !
;gg! "
varhh 
firstResponseDuehh 
=hh 
awaithh $!
CalculateDueTimeAsynchh% :
(hh: ;
nowhh; >
,hh> ?
targethh@ F
.hhF G 
FirstResponseMinuteshhG [
)hh[ \
;hh\ ]
varii 
resolutionDueii 
=ii 
awaitii !!
CalculateDueTimeAsyncii" 7
(ii7 8
nowii8 ;
,ii; <
targetii= C
.iiC D
ResolutionMinutesiiD U
)iiU V
;iiV W
varkk 
slakk 
=kk 
newkk 
	TicketSlakk 
{ll 	
TicketIdmm 
=mm 
ticketmm 
.mm 
Idmm  
,mm  !
FirstResponseDueAtnn 
=nn  
firstResponseDuenn! 1
,nn1 2
ResolutionDueAtoo 
=oo 
resolutionDueoo +
}pp 	
;pp	 

_contextrr 
.rr 

TicketSlasrr 
.rr 
Addrr 
(rr  
slarr  #
)rr# $
;rr$ %
awaitss 
_contextss 
.ss 
SaveChangesAsyncss '
(ss' (
)ss( )
;ss) *
}tt 
publicvv 

asyncvv 
Taskvv *
ProcessTicketStatusChangeAsyncvv 4
(vv4 5
intvv5 8
ticketIdvv9 A
,vvA B
intvvC F
oldStatusIdvvG R
,vvR S
intvvT W
newStatusIdvvX c
)vvc d
{ww 
varxx 
slaxx 
=xx 
awaitxx 
_contextxx  
.xx  !

TicketSlasxx! +
.xx+ ,
FirstOrDefaultAsyncxx, ?
(xx? @
sxx@ A
=>xxB D
sxxE F
.xxF G
TicketIdxxG O
==xxP R
ticketIdxxS [
)xx[ \
;xx\ ]
ifyy 

(yy 
slayy 
==yy 
nullyy 
)yy 
returnyy 
;yy  
if{{ 

({{ 
sla{{ 
.{{ 
FirstResponseMetAt{{ "
=={{# %
null{{& *
){{* +
sla|| 
.|| 
FirstResponseMetAt|| "
=||# $
DateTime||% -
.||- .
UtcNow||. 4
;||4 5
var~~ 
	oldStatus~~ 
=~~ 
await~~ 
_context~~ &
.~~& '
Statuses~~' /
.~~/ 0
	FindAsync~~0 9
(~~9 :
oldStatusId~~: E
)~~E F
;~~F G
var 
	newStatus 
= 
await 
_context &
.& '
Statuses' /
./ 0
	FindAsync0 9
(9 :
newStatusId: E
)E F
;F G
if
ÄÄ 

(
ÄÄ 
	oldStatus
ÄÄ 
==
ÄÄ 
null
ÄÄ 
||
ÄÄ  
	newStatus
ÄÄ! *
==
ÄÄ+ -
null
ÄÄ. 2
)
ÄÄ2 3
return
ÄÄ4 :
;
ÄÄ: ;
var
ÇÇ 
now
ÇÇ 
=
ÇÇ 
DateTime
ÇÇ 
.
ÇÇ 
UtcNow
ÇÇ !
;
ÇÇ! "
if
ÑÑ 

(
ÑÑ 
!
ÑÑ 
	oldStatus
ÑÑ 
.
ÑÑ 
	PausesSla
ÑÑ  
&&
ÑÑ! #
	newStatus
ÑÑ$ -
.
ÑÑ- .
	PausesSla
ÑÑ. 7
)
ÑÑ7 8
{
ÖÖ 	

ApplyPause
ÜÜ 
(
ÜÜ 
sla
ÜÜ 
,
ÜÜ 
now
ÜÜ 
)
ÜÜ  
;
ÜÜ  !
}
áá 	
else
àà 
if
àà 
(
àà 
	oldStatus
àà 
.
àà 
	PausesSla
àà $
&&
àà% '
!
àà( )
	newStatus
àà) 2
.
àà2 3
	PausesSla
àà3 <
&&
àà= ?
sla
àà@ C
.
ààC D
PausedAt
ààD L
.
ààL M
HasValue
ààM U
)
ààU V
{
ââ 	
await
ää 
ApplyResumeAsync
ää "
(
ää" #
sla
ää# &
,
ää& '
now
ää( +
)
ää+ ,
;
ää, -
}
ãã 	
if
çç 

(
çç 
	newStatus
çç 
.
çç 
IsClosedStatus
çç $
&&
çç% '
sla
çç( +
.
çç+ ,
ResolutionMetAt
çç, ;
==
çç< >
null
çç? C
)
ççC D
sla
éé 
.
éé 
ResolutionMetAt
éé 
=
éé  !
now
éé" %
;
éé% &
await
êê 
_context
êê 
.
êê 
SaveChangesAsync
êê '
(
êê' (
)
êê( )
;
êê) *
}
ëë 
private
ìì 
static
ìì 
void
ìì 

ApplyPause
ìì "
(
ìì" #
	TicketSla
ìì# ,
sla
ìì- 0
,
ìì0 1
DateTime
ìì2 :
now
ìì; >
)
ìì> ?
{
îî 
sla
ïï 
.
ïï 
PausedAt
ïï 
=
ïï 
now
ïï 
;
ïï 
}
ññ 
private
òò 
async
òò 
Task
òò 
ApplyResumeAsync
òò '
(
òò' (
	TicketSla
òò( 1
sla
òò2 5
,
òò5 6
DateTime
òò7 ?
now
òò@ C
)
òòC D
{
ôô 
if
öö 

(
öö 
!
öö 
sla
öö 
.
öö 
PausedAt
öö 
.
öö 
HasValue
öö "
)
öö" #
return
öö$ *
;
öö* +
var
úú 
pausedDuration
úú 
=
úú 
now
úú  
-
úú! "
sla
úú# &
.
úú& '
PausedAt
úú' /
.
úú/ 0
Value
úú0 5
;
úú5 6
sla
ùù 
.
ùù  
TotalPausedMinutes
ùù 
+=
ùù !
(
ùù" #
int
ùù# &
)
ùù& '
pausedDuration
ùù' 5
.
ùù5 6
TotalMinutes
ùù6 B
;
ùùB C
if
üü 

(
üü 
sla
üü 
.
üü  
FirstResponseDueAt
üü "
.
üü" #
HasValue
üü# +
)
üü+ ,
sla
†† 
.
††  
FirstResponseDueAt
†† "
=
††# $
await
††% *#
CalculateDueTimeAsync
††+ @
(
††@ A
now
††A D
,
††D E
(
††F G
int
††G J
)
††J K
(
††K L
sla
††L O
.
††O P 
FirstResponseDueAt
††P b
.
††b c
Value
††c h
-
††i j
sla
††k n
.
††n o
PausedAt
††o w
.
††w x
Value
††x }
)
††} ~
.
††~ 
TotalMinutes†† ã
)††ã å
;††å ç
if
¢¢ 

(
¢¢ 
sla
¢¢ 
.
¢¢ 
ResolutionDueAt
¢¢ 
.
¢¢  
HasValue
¢¢  (
)
¢¢( )
sla
££ 
.
££ 
ResolutionDueAt
££ 
=
££  !
await
££" '#
CalculateDueTimeAsync
££( =
(
££= >
now
££> A
,
££A B
(
££C D
int
££D G
)
££G H
(
££H I
sla
££I L
.
££L M
ResolutionDueAt
££M \
.
££\ ]
Value
££] b
-
££c d
sla
££e h
.
££h i
PausedAt
££i q
.
££q r
Value
££r w
)
££w x
.
££x y
TotalMinutes££y Ö
)££Ö Ü
;££Ü á
sla
•• 
.
•• 
PausedAt
•• 
=
•• 
null
•• 
;
•• 
}
¶¶ 
public
®® 

async
®® 
Task
®® '
ProcessTicketCommentAsync
®® /
(
®®/ 0
int
®®0 3
ticketId
®®4 <
,
®®< =
bool
®®> B

isInternal
®®C M
)
®®M N
{
©© 
if
™™ 

(
™™ 

isInternal
™™ 
)
™™ 
return
™™ 
;
™™ 
var
¨¨ 
sla
¨¨ 
=
¨¨ 
await
¨¨ 
_context
¨¨  
.
¨¨  !

TicketSlas
¨¨! +
.
¨¨+ ,!
FirstOrDefaultAsync
¨¨, ?
(
¨¨? @
s
¨¨@ A
=>
¨¨B D
s
¨¨E F
.
¨¨F G
TicketId
¨¨G O
==
¨¨P R
ticketId
¨¨S [
)
¨¨[ \
;
¨¨\ ]
if
≠≠ 

(
≠≠ 
sla
≠≠ 
!=
≠≠ 
null
≠≠ 
&&
≠≠ 
sla
≠≠ 
.
≠≠  
FirstResponseMetAt
≠≠ 1
==
≠≠2 4
null
≠≠5 9
)
≠≠9 :
{
ÆÆ 	
sla
ØØ 
.
ØØ  
FirstResponseMetAt
ØØ "
=
ØØ# $
DateTime
ØØ% -
.
ØØ- .
UtcNow
ØØ. 4
;
ØØ4 5
await
∞∞ 
_context
∞∞ 
.
∞∞ 
SaveChangesAsync
∞∞ +
(
∞∞+ ,
)
∞∞, -
;
∞∞- .
}
±± 	
}
≤≤ 
public
¥¥ 

async
¥¥ 
Task
¥¥  
CheckBreachesAsync
¥¥ (
(
¥¥( )
DateTime
¥¥) 1
nowUtc
¥¥2 8
)
¥¥8 9
{
µµ 
var
∂∂ 

activeSlas
∂∂ 
=
∂∂ 
await
∂∂ 
_context
∂∂ '
.
∂∂' (

TicketSlas
∂∂( 2
.
∑∑ 
Include
∑∑ 
(
∑∑ 
s
∑∑ 
=>
∑∑ 
s
∑∑ 
.
∑∑ 
Ticket
∑∑ "
)
∑∑" #
.
∏∏ 
Where
∏∏ 
(
∏∏ 
s
∏∏ 
=>
∏∏ 
s
∏∏ 
.
∏∏ 
PausedAt
∏∏ "
==
∏∏# %
null
∏∏& *
&&
∏∏+ -
(
∏∏. /
!
∏∏/ 0
s
∏∏0 1
.
∏∏1 2
ResolutionMetAt
∏∏2 A
.
∏∏A B
HasValue
∏∏B J
||
∏∏K M
!
∏∏N O
s
∏∏O P
.
∏∏P Q 
FirstResponseMetAt
∏∏Q c
.
∏∏c d
HasValue
∏∏d l
)
∏∏l m
)
∏∏m n
.
ππ 
ToListAsync
ππ 
(
ππ 
)
ππ 
;
ππ 
foreach
ªª 
(
ªª 
var
ªª 
sla
ªª 
in
ªª 

activeSlas
ªª &
)
ªª& '
{
ºº 	
if
ΩΩ 
(
ΩΩ 
sla
ΩΩ 
.
ΩΩ 
Ticket
ΩΩ 
==
ΩΩ 
null
ΩΩ "
)
ΩΩ" #
continue
ΩΩ$ ,
;
ΩΩ, -
var
ææ 
targetUserId
ææ 
=
ææ 
sla
ææ "
.
ææ" #
Ticket
ææ# )
.
ææ) *
AssignedUserId
ææ* 8
??
ææ9 ;
sla
ææ< ?
.
ææ? @
Ticket
ææ@ F
.
ææF G
RequesterUserId
ææG V
;
ææV W
await
¿¿ %
CheckFirstResponseAsync
¿¿ )
(
¿¿) *
sla
¿¿* -
,
¿¿- .
targetUserId
¿¿/ ;
,
¿¿; <
nowUtc
¿¿= C
)
¿¿C D
;
¿¿D E
await
¡¡ "
CheckResolutionAsync
¡¡ &
(
¡¡& '
sla
¡¡' *
,
¡¡* +
targetUserId
¡¡, 8
,
¡¡8 9
nowUtc
¡¡: @
)
¡¡@ A
;
¡¡A B
}
¬¬ 	
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
«« %
CheckFirstResponseAsync
«« .
(
««. /
	TicketSla
««/ 8
sla
««9 <
,
««< =
int
««> A
targetUserId
««B N
,
««N O
DateTime
««P X
nowUtc
««Y _
)
««_ `
{
»» 
if
…… 

(
…… 
sla
…… 
.
……  
FirstResponseMetAt
…… "
.
……" #
HasValue
……# +
||
……, .
!
……/ 0
sla
……0 3
.
……3 4 
FirstResponseDueAt
……4 F
.
……F G
HasValue
……G O
)
……O P
return
……Q W
;
……W X
var
ÀÀ 
(
ÀÀ 
warn
ÀÀ 
,
ÀÀ 
breach
ÀÀ 
)
ÀÀ 
=
ÀÀ 
EvaluateMetric
ÀÀ +
(
ÀÀ+ ,
sla
ÀÀ, /
.
ÀÀ/ 0 
FirstResponseDueAt
ÀÀ0 B
.
ÀÀB C
Value
ÀÀC H
,
ÀÀH I
sla
ÀÀJ M
.
ÀÀM N!
FirstResponseWarned
ÀÀN a
,
ÀÀa b
sla
ÀÀc f
.
ÀÀf g#
FirstResponseBreached
ÀÀg |
,
ÀÀ| }
nowUtcÀÀ~ Ñ
)ÀÀÑ Ö
;ÀÀÖ Ü
if
ÕÕ 

(
ÕÕ 
breach
ÕÕ 
)
ÕÕ 
{
ŒŒ 	
sla
œœ 
.
œœ #
FirstResponseBreached
œœ %
=
œœ& '
true
œœ( ,
;
œœ, -
await
–– %
CreateNotificationAsync
–– )
(
––) *
targetUserId
––* 6
,
––6 7
sla
––8 ;
.
––; <
TicketId
––< D
,
––D E
$str
––F T
,
––T U
$str
––V t
)
––t u
;
––u v
}
—— 	
else
““ 
if
““ 
(
““ 
warn
““ 
)
““ 
{
”” 	
sla
‘‘ 
.
‘‘ !
FirstResponseWarned
‘‘ #
=
‘‘$ %
true
‘‘& *
;
‘‘* +
await
’’ %
CreateNotificationAsync
’’ )
(
’’) *
targetUserId
’’* 6
,
’’6 7
sla
’’8 ;
.
’’; <
TicketId
’’< D
,
’’D E
$str
’’F S
,
’’S T
$str
’’U }
)
’’} ~
;
’’~ 
}
÷÷ 	
}
◊◊ 
private
ŸŸ 
async
ŸŸ 
Task
ŸŸ "
CheckResolutionAsync
ŸŸ +
(
ŸŸ+ ,
	TicketSla
ŸŸ, 5
sla
ŸŸ6 9
,
ŸŸ9 :
int
ŸŸ; >
targetUserId
ŸŸ? K
,
ŸŸK L
DateTime
ŸŸM U
nowUtc
ŸŸV \
)
ŸŸ\ ]
{
⁄⁄ 
if
€€ 

(
€€ 
sla
€€ 
.
€€ 
ResolutionMetAt
€€ 
.
€€  
HasValue
€€  (
||
€€) +
!
€€, -
sla
€€- 0
.
€€0 1
ResolutionDueAt
€€1 @
.
€€@ A
HasValue
€€A I
)
€€I J
return
€€K Q
;
€€Q R
var
›› 
(
›› 
warn
›› 
,
›› 
breach
›› 
)
›› 
=
›› 
EvaluateMetric
›› +
(
››+ ,
sla
››, /
.
››/ 0
ResolutionDueAt
››0 ?
.
››? @
Value
››@ E
,
››E F
sla
››G J
.
››J K
ResolutionWarned
››K [
,
››[ \
sla
››] `
.
››` a 
ResolutionBreached
››a s
,
››s t
nowUtc
››u {
)
››{ |
;
››| }
if
ﬂﬂ 

(
ﬂﬂ 
breach
ﬂﬂ 
)
ﬂﬂ 
{
‡‡ 	
sla
·· 
.
··  
ResolutionBreached
·· "
=
··# $
true
··% )
;
··) *
await
‚‚ %
CreateNotificationAsync
‚‚ )
(
‚‚) *
targetUserId
‚‚* 6
,
‚‚6 7
sla
‚‚8 ;
.
‚‚; <
TicketId
‚‚< D
,
‚‚D E
$str
‚‚F T
,
‚‚T U
$str
‚‚V p
)
‚‚p q
;
‚‚q r
}
„„ 	
else
‰‰ 
if
‰‰ 
(
‰‰ 
warn
‰‰ 
)
‰‰ 
{
ÂÂ 	
sla
ÊÊ 
.
ÊÊ 
ResolutionWarned
ÊÊ  
=
ÊÊ! "
true
ÊÊ# '
;
ÊÊ' (
await
ÁÁ %
CreateNotificationAsync
ÁÁ )
(
ÁÁ) *
targetUserId
ÁÁ* 6
,
ÁÁ6 7
sla
ÁÁ8 ;
.
ÁÁ; <
TicketId
ÁÁ< D
,
ÁÁD E
$str
ÁÁF S
,
ÁÁS T
$str
ÁÁU y
)
ÁÁy z
;
ÁÁz {
}
ËË 	
}
ÈÈ 
private
ÎÎ 
static
ÎÎ 
(
ÎÎ 
bool
ÎÎ 
warn
ÎÎ 
,
ÎÎ 
bool
ÎÎ #
breach
ÎÎ$ *
)
ÎÎ* +
EvaluateMetric
ÎÎ, :
(
ÎÎ: ;
DateTime
ÎÎ; C
dueAt
ÎÎD I
,
ÎÎI J
bool
ÎÎK O
warned
ÎÎP V
,
ÎÎV W
bool
ÎÎX \
breached
ÎÎ] e
,
ÎÎe f
DateTime
ÎÎg o
now
ÎÎp s
)
ÎÎs t
{
ÏÏ 
var
ÌÌ 
timeRemaining
ÌÌ 
=
ÌÌ 
(
ÌÌ 
dueAt
ÌÌ "
-
ÌÌ# $
now
ÌÌ% (
)
ÌÌ( )
.
ÌÌ) *
TotalMinutes
ÌÌ* 6
;
ÌÌ6 7
if
ÔÔ 

(
ÔÔ 
timeRemaining
ÔÔ 
<=
ÔÔ 
$num
ÔÔ 
&&
ÔÔ !
!
ÔÔ" #
breached
ÔÔ# +
)
ÔÔ+ ,
return
 
(
 
false
 
,
 
true
 
)
  
;
  !
if
ÚÚ 

(
ÚÚ 
timeRemaining
ÚÚ 
>
ÚÚ 
$num
ÚÚ 
&&
ÚÚ  
timeRemaining
ÚÚ! .
<=
ÚÚ/ 1
$num
ÚÚ2 5
&&
ÚÚ6 8
!
ÚÚ9 :
warned
ÚÚ: @
)
ÚÚ@ A
return
ÛÛ 
(
ÛÛ 
true
ÛÛ 
,
ÛÛ 
false
ÛÛ 
)
ÛÛ  
;
ÛÛ  !
return
ıı 
(
ıı 
false
ıı 
,
ıı 
false
ıı 
)
ıı 
;
ıı 
}
ˆˆ 
private
¯¯ 
async
¯¯ 
Task
¯¯ %
CreateNotificationAsync
¯¯ .
(
¯¯. /
int
¯¯/ 2
userId
¯¯3 9
,
¯¯9 :
int
¯¯; >
ticketId
¯¯? G
,
¯¯G H
string
¯¯I O
title
¯¯P U
,
¯¯U V
string
¯¯W ]
message
¯¯^ e
)
¯¯e f
{
˘˘ 
_context
˙˙ 
.
˙˙ 
Notifications
˙˙ 
.
˙˙ 
Add
˙˙ "
(
˙˙" #
new
˙˙# &
Notification
˙˙' 3
{
˚˚ 	
UserId
¸¸ 
=
¸¸ 
userId
¸¸ 
,
¸¸ 
Title
˝˝ 
=
˝˝ 
title
˝˝ 
,
˝˝ 
Message
˛˛ 
=
˛˛ 
message
˛˛ 
,
˛˛ 
RelatedEntityId
ˇˇ 
=
ˇˇ 
ticketId
ˇˇ &
,
ˇˇ& '
RelatedEntityType
ÄÄ 
=
ÄÄ 
$str
ÄÄ  (
}
ÅÅ 	
)
ÅÅ	 

;
ÅÅ
 
var
ÑÑ 
user
ÑÑ 
=
ÑÑ 
await
ÑÑ 
_context
ÑÑ !
.
ÑÑ! "
Users
ÑÑ" '
.
ÑÑ' (
	FindAsync
ÑÑ( 1
(
ÑÑ1 2
userId
ÑÑ2 8
)
ÑÑ8 9
;
ÑÑ9 :
if
ÖÖ 

(
ÖÖ 
user
ÖÖ 
!=
ÖÖ 
null
ÖÖ 
)
ÖÖ 
{
ÜÜ 	
await
áá 
_emailService
áá 
.
áá  
SendEmailAsync
áá  .
(
áá. /
user
áá/ 3
.
áá3 4
Email
áá4 9
,
áá9 :
title
áá; @
,
áá@ A
message
ááB I
)
ááI J
;
ááJ K
}
àà 	
}
ââ 
}ää Î9
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
}JJ Æñ
a/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/ReportService.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Services! )
;) *
public 
class 
ReportService 
: 
IReportService +
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

ReportService 
( 
ItsToolDbContext )
context* 1
,1 2!
IPermissionCalculator3 H 
permissionCalculatorI ]
)] ^
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
< 
Stream 
> #
ExportTicketsToCsvAsync 5
(5 6!
TicketSearchFilterDto6 K
filterL R
,R S
intT W
userIdX ^
)^ _
{ 
var 
perms 
= 
await !
_permissionCalculator /
./ 0.
"CalculateEffectivePermissionsAsync0 R
(R S
userIdS Y
)Y Z
;Z [
var 
query 
= 
_context 
. 
Tickets $
. 
Include 
( 
t 
=> 
t 
. 
Project #
)# $
. 
Include 
( 
t 
=> 
t 
. 
Category $
)$ %
. 
Include 
( 
t 
=> 
t 
. 
Type  
)  !
.   
Include   
(   
t   
=>   
t   
.   
Status   "
)  " #
.!! 
Include!! 
(!! 
t!! 
=>!! 
t!! 
.!! 
Priority!! $
)!!$ %
."" 
Include"" 
("" 
t"" 
=>"" 
t"" 
."" 
RequesterUser"" )
)"") *
.## 
Include## 
(## 
t## 
=>## 
t## 
.## 
AssignedUser## (
)##( )
.$$ 
Include$$ 
($$ 
t$$ 
=>$$ 
t$$ 
.$$ 
	TicketSla$$ %
)$$% &
.%% 
Where%% 
(%% 
t%% 
=>%% 
!%% 
t%% 
.%% 
	IsDeleted%% $
)%%$ %
;%%% &
if(( 

((( 
!(( 
perms(( 
.(( 
Contains(( 
((( 
$str(( )
)(() *
)((* +
{)) 	
var** 
isAgent** 
=** 
perms** 
.**  
Contains**  (
(**( )
$str**) 8
)**8 9
||**: <
perms**= B
.**B C
Contains**C K
(**K L
$str**L [
)**[ \
;**\ ]
if++ 
(++ 
isAgent++ 
)++ 
{,, 
var-- 
userGroupIds--  
=--! "
await--# (
_context--) 1
.--1 2
GroupMembers--2 >
... 
Where.. 
(.. 
gm.. 
=>..  
gm..! #
...# $
UserId..$ *
==..+ -
userId... 4
&&..5 7
!..8 9
gm..9 ;
...; <
	IsDeleted..< E
)..E F
.// 
Select// 
(// 
gm// 
=>// !
gm//" $
.//$ %
GroupId//% ,
)//, -
.00 
ToListAsync00  
(00  !
)00! "
;00" #
query22 
=22 
query22 
.22 
Where22 #
(22# $
t22$ %
=>22& (
t22) *
.22* +
AssignedUserId22+ 9
==22: <
userId22= C
||22D F
(33( )
t33) *
.33* +
AssignedGroupId33+ :
.33: ;
HasValue33; C
&&33D F
userGroupIds33G S
.33S T
Contains33T \
(33\ ]
t33] ^
.33^ _
AssignedGroupId33_ n
.33n o
Value33o t
)33t u
)33u v
||33w y
t44( )
.44) *
RequesterUserId44* 9
==44: <
userId44= C
)44C D
;44D E
}55 
else66 
{77 
query88 
=88 
query88 
.88 
Where88 #
(88# $
t88$ %
=>88& (
t88) *
.88* +
RequesterUserId88+ :
==88; =
userId88> D
)88D E
;88E F
}99 
}:: 	
if== 

(== 
filter== 
.== 
	ProjectId== 
.== 
HasValue== %
)==% &
query==' ,
===- .
query==/ 4
.==4 5
Where==5 :
(==: ;
t==; <
=>=== ?
t==@ A
.==A B
	ProjectId==B K
====L N
filter==O U
.==U V
	ProjectId==V _
.==_ `
Value==` e
)==e f
;==f g
if>> 

(>> 
filter>> 
.>> 

CategoryId>> 
.>> 
HasValue>> &
)>>& '
query>>( -
=>>. /
query>>0 5
.>>5 6
Where>>6 ;
(>>; <
t>>< =
=>>>> @
t>>A B
.>>B C

CategoryId>>C M
==>>N P
filter>>Q W
.>>W X

CategoryId>>X b
.>>b c
Value>>c h
)>>h i
;>>i j
if?? 

(?? 
filter?? 
.?? 
TypeId?? 
.?? 
HasValue?? "
)??" #
query??$ )
=??* +
query??, 1
.??1 2
Where??2 7
(??7 8
t??8 9
=>??: <
t??= >
.??> ?
TypeId??? E
==??F H
filter??I O
.??O P
TypeId??P V
.??V W
Value??W \
)??\ ]
;??] ^
if@@ 

(@@ 
filter@@ 
.@@ 
StatusId@@ 
.@@ 
HasValue@@ $
)@@$ %
query@@& +
=@@, -
query@@. 3
.@@3 4
Where@@4 9
(@@9 :
t@@: ;
=>@@< >
t@@? @
.@@@ A
StatusId@@A I
==@@J L
filter@@M S
.@@S T
StatusId@@T \
.@@\ ]
Value@@] b
)@@b c
;@@c d
ifAA 

(AA 
filterAA 
.AA 

PriorityIdAA 
.AA 
HasValueAA &
)AA& '
queryAA( -
=AA. /
queryAA0 5
.AA5 6
WhereAA6 ;
(AA; <
tAA< =
=>AA> @
tAAA B
.AAB C

PriorityIdAAC M
==AAN P
filterAAQ W
.AAW X

PriorityIdAAX b
.AAb c
ValueAAc h
)AAh i
;AAi j
ifBB 

(BB 
filterBB 
.BB 
AssigneeUserIdBB !
.BB! "
HasValueBB" *
)BB* +
queryBB, 1
=BB2 3
queryBB4 9
.BB9 :
WhereBB: ?
(BB? @
tBB@ A
=>BBB D
tBBE F
.BBF G
AssignedUserIdBBG U
==BBV X
filterBBY _
.BB_ `
AssigneeUserIdBB` n
.BBn o
ValueBBo t
)BBt u
;BBu v
ifCC 

(CC 
filterCC 
.CC 
RequesterUserIdCC "
.CC" #
HasValueCC# +
)CC+ ,
queryCC- 2
=CC3 4
queryCC5 :
.CC: ;
WhereCC; @
(CC@ A
tCCA B
=>CCC E
tCCF G
.CCG H
RequesterUserIdCCH W
==CCX Z
filterCC[ a
.CCa b
RequesterUserIdCCb q
.CCq r
ValueCCr w
)CCw x
;CCx y
ifDD 

(DD 
filterDD 
.DD 
FromDateDD 
.DD 
HasValueDD $
)DD$ %
queryDD& +
=DD, -
queryDD. 3
.DD3 4
WhereDD4 9
(DD9 :
tDD: ;
=>DD< >
tDD? @
.DD@ A
	CreatedAtDDA J
>=DDK M
filterDDN T
.DDT U
FromDateDDU ]
.DD] ^
ValueDD^ c
)DDc d
;DDd e
ifEE 

(EE 
filterEE 
.EE 
ToDateEE 
.EE 
HasValueEE "
)EE" #
queryEE$ )
=EE* +
queryEE, 1
.EE1 2
WhereEE2 7
(EE7 8
tEE8 9
=>EE: <
tEE= >
.EE> ?
	CreatedAtEE? H
<=EEI K
filterEEL R
.EER S
ToDateEES Y
.EEY Z
ValueEEZ _
)EE_ `
;EE` a
ifGG 

(GG 
!GG 
stringGG 
.GG 
IsNullOrWhiteSpaceGG &
(GG& '
filterGG' -
.GG- .
KeywordGG. 5
)GG5 6
)GG6 7
{HH 	
varII 
kwII 
=II 
filterII 
.II 
KeywordII #
.II# $
ToLowerII$ +
(II+ ,
)II, -
;II- .
queryJJ 
=JJ 
queryJJ 
.JJ 
WhereJJ 
(JJ  
tJJ  !
=>JJ" $
tKK 
.KK 
TicketNumberKK 
.KK 
ToLowerKK &
(KK& '
)KK' (
.KK( )
ContainsKK) 1
(KK1 2
kwKK2 4
)KK4 5
||KK6 8
tLL 
.LL 
TitleLL 
.LL 
ToLowerLL 
(LL  
)LL  !
.LL! "
ContainsLL" *
(LL* +
kwLL+ -
)LL- .
||LL/ 1
tMM 
.MM 
DescriptionMM 
.MM 
ToLowerMM %
(MM% &
)MM& '
.MM' (
ContainsMM( 0
(MM0 1
kwMM1 3
)MM3 4
)MM4 5
;MM5 6
}NN 	
ifPP 

(PP 
!PP 
stringPP 
.PP 
IsNullOrWhiteSpacePP &
(PP& '
filterPP' -
.PP- .
	SlaStatusPP. 7
)PP7 8
)PP8 9
{QQ 	
varRR 
sRR 
=RR 
filterRR 
.RR 
	SlaStatusRR $
.RR$ %
ToLowerRR% ,
(RR, -
)RR- .
;RR. /
ifSS 
(SS 
sSS 
==SS 
$strSS 
)SS  
queryTT 
=TT 
queryTT 
.TT 
WhereTT #
(TT# $
tTT$ %
=>TT& (
tTT) *
.TT* +
	TicketSlaTT+ 4
!=TT5 7
nullTT8 <
&&TT= ?
(TT@ A
tTTA B
.TTB C
	TicketSlaTTC L
.TTL M!
FirstResponseBreachedTTM b
||TTc e
tTTf g
.TTg h
	TicketSlaTTh q
.TTq r
ResolutionBreached	TTr Ñ
)
TTÑ Ö
)
TTÖ Ü
;
TTÜ á
elseUU 
ifUU 
(UU 
sUU 
==UU 
$strUU #
)UU# $
queryVV 
=VV 
queryVV 
.VV 
WhereVV #
(VV# $
tVV$ %
=>VV& (
tVV) *
.VV* +
	TicketSlaVV+ 4
!=VV5 7
nullVV8 <
&&VV= ?
(VV@ A
tVVA B
.VVB C
	TicketSlaVVC L
.VVL M
FirstResponseWarnedVVM `
||VVa c
tVVd e
.VVe f
	TicketSlaVVf o
.VVo p
ResolutionWarned	VVp Ä
)
VVÄ Å
&&
VVÇ Ñ
!
VVÖ Ü
(
VVÜ á
t
VVá à
.
VVà â
	TicketSla
VVâ í
.
VVí ì#
FirstResponseBreached
VVì ®
||
VV© ´
t
VV¨ ≠
.
VV≠ Æ
	TicketSla
VVÆ ∑
.
VV∑ ∏ 
ResolutionBreached
VV∏  
)
VV  À
)
VVÀ Ã
;
VVÃ Õ
elseWW 
ifWW 
(WW 
sWW 
==WW 
$strWW #
)WW# $
queryXX 
=XX 
queryXX 
.XX 
WhereXX #
(XX# $
tXX$ %
=>XX& (
tXX) *
.XX* +
	TicketSlaXX+ 4
!=XX5 7
nullXX8 <
&&XX= ?
!XX@ A
tXXA B
.XXB C
	TicketSlaXXC L
.XXL M
FirstResponseWarnedXXM `
&&XXa c
!XXd e
tXXe f
.XXf g
	TicketSlaXXg p
.XXp q
ResolutionWarned	XXq Å
&&
XXÇ Ñ
!
XXÖ Ü
t
XXÜ á
.
XXá à
	TicketSla
XXà ë
.
XXë í#
FirstResponseBreached
XXí ß
&&
XX® ™
!
XX´ ¨
t
XX¨ ≠
.
XX≠ Æ
	TicketSla
XXÆ ∑
.
XX∑ ∏ 
ResolutionBreached
XX∏  
)
XX  À
;
XXÀ Ã
}YY 	
query\\ 
=\\ 
query\\ 
.\\ 
OrderByDescending\\ '
(\\' (
t\\( )
=>\\* ,
t\\- .
.\\. /
	CreatedAt\\/ 8
)\\8 9
;\\9 :
var__ 
tickets__ 
=__ 
await__ 
query__ !
.__! "
Take__" &
(__& '
$num__' ,
)__, -
.__- .
ToListAsync__. 9
(__9 :
)__: ;
;__; <
varaa 
msaa 
=aa 
newaa 
MemoryStreamaa !
(aa! "
)aa" #
;aa# $
varbb 
swbb 
=bb 
newbb 
StreamWriterbb !
(bb! "
msbb" $
,bb$ %
Encodingbb& .
.bb. /
UTF8bb/ 3
)bb3 4
;bb4 5
awaitee 
swee 
.ee 
WriteLineAsyncee 
(ee  
$str	ee  Ç
)
eeÇ É
;
eeÉ Ñ
foreachgg 
(gg 
vargg 
tgg 
ingg 
ticketsgg !
)gg! "
{hh 	
varii 
	slaStatusii 
=ii 
$strii &
;ii& '
ifjj 
(jj 
tjj 
.jj 
	TicketSlajj 
!=jj 
nulljj #
)jj# $
{kk 
ifll 
(ll 
tll 
.ll 
	TicketSlall 
.ll  !
FirstResponseBreachedll  5
||ll6 8
tll9 :
.ll: ;
	TicketSlall; D
.llD E
ResolutionBreachedllE W
)llW X
	slaStatusllY b
=llc d
$strlle o
;llo p
elsemm 
ifmm 
(mm 
tmm 
.mm 
	TicketSlamm $
.mm$ %
FirstResponseWarnedmm% 8
||mm9 ;
tmm< =
.mm= >
	TicketSlamm> G
.mmG H
ResolutionWarnedmmH X
)mmX Y
	slaStatusmmZ c
=mmd e
$strmmf o
;mmo p
}nn 
varpp 
linepp 
=pp 
$"pp 
$strpp 
{pp 
	EscapeCsvpp %
(pp% &
tpp& '
.pp' (
TicketNumberpp( 4
)pp4 5
}pp5 6
$strpp6 ;
{pp; <
	EscapeCsvpp< E
(ppE F
tppF G
.ppG H
TitleppH M
)ppM N
}ppN O
$strppO T
{ppT U
	EscapeCsvppU ^
(pp^ _
tpp_ `
.pp` a
Projectppa h
?pph i
.ppi j
Nameppj n
)ppn o
}ppo p
$strppp u
{ppu v
	EscapeCsvppv 
(	pp Ä
t
ppÄ Å
.
ppÅ Ç
Category
ppÇ ä
?
ppä ã
.
ppã å
Name
ppå ê
)
ppê ë
}
ppë í
$str
ppí ó
{
ppó ò
	EscapeCsv
ppò °
(
pp° ¢
t
pp¢ £
.
pp£ §
Type
pp§ ®
?
pp® ©
.
pp© ™
Name
pp™ Æ
)
ppÆ Ø
}
ppØ ∞
$str
pp∞ µ
{
ppµ ∂
	EscapeCsv
pp∂ ø
(
ppø ¿
t
pp¿ ¡
.
pp¡ ¬
Status
pp¬ »
?
pp» …
.
pp…  
Name
pp  Œ
)
ppŒ œ
}
ppœ –
$str
pp– ’
{
pp’ ÷
	EscapeCsv
pp÷ ﬂ
(
ppﬂ ‡
t
pp‡ ·
.
pp· ‚
Priority
pp‚ Í
?
ppÍ Î
.
ppÎ Ï
Name
ppÏ 
)
pp Ò
}
ppÒ Ú
$str
ppÚ ˜
{
pp˜ ¯
	EscapeCsv
pp¯ Å
(
ppÅ Ç
t
ppÇ É
.
ppÉ Ñ
RequesterUser
ppÑ ë
?
ppë í
.
ppí ì
	FirstName
ppì ú
+
ppù û
$str
ppü ¢
+
pp£ §
t
pp• ¶
.
pp¶ ß
RequesterUser
ppß ¥
?
pp¥ µ
.
ppµ ∂
LastName
pp∂ æ
)
ppæ ø
}
ppø ¿
$str
pp¿ ≈
{
pp≈ ∆
	EscapeCsv
pp∆ œ
(
ppœ –
t
pp– —
.
pp— “
AssignedUser
pp“ ﬁ
?
ppﬁ ﬂ
.
ppﬂ ‡
	FirstName
pp‡ È
+
ppÍ Î
$str
ppÏ Ô
+
pp Ò
t
ppÚ Û
.
ppÛ Ù
AssignedUser
ppÙ Ä
?
ppÄ Å
.
ppÅ Ç
LastName
ppÇ ä
)
ppä ã
}
ppã å
$str
ppå ë
{
ppë í
t
ppí ì
.
ppì î
	CreatedAt
ppî ù
:
ppù û
$str
ppû ±
}
pp± ≤
$str
pp≤ ∑
{
pp∑ ∏
	slaStatus
pp∏ ¡
}
pp¡ ¬
$str
pp¬ ƒ
"
ppƒ ≈
;
pp≈ ∆
awaitqq 
swqq 
.qq 
WriteLineAsyncqq #
(qq# $
lineqq$ (
)qq( )
;qq) *
}rr 	
awaittt 
swtt 
.tt 

FlushAsynctt 
(tt 
)tt 
;tt 
msuu 

.uu
 
Positionuu 
=uu 
$numuu 
;uu 
returnvv 
msvv 
;vv 
}ww 
privateyy 
stringyy 
	EscapeCsvyy 
(yy 
stringyy #
?yy# $
fieldyy% *
)yy* +
{zz 
if{{ 

({{ 
string{{ 
.{{ 
IsNullOrEmpty{{  
({{  !
field{{! &
){{& '
){{' (
return{{) /
$str{{0 2
;{{2 3
return|| 
field|| 
.|| 
Replace|| 
(|| 
$str|| !
,||! "
$str||# )
)||) *
;||* +
}}} 
}~~ èA
b/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Services/ProjectService.cs
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
ProjectService		 
:		 
IProjectService		 -
{

 
private 
readonly 
IRepository  
<  !
Project! (
>( )
_repository* 5
;5 6
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 

ProjectService 
( 
IRepository %
<% &
Project& -
>- .

repository/ 9
,9 :
ItsToolDbContext; K
contextL S
)S T
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
<! "

ProjectDto" ,
>, -
>- .
GetAllAsync/ :
(: ;
); <
{ 
var 
projects 
= 
await 
_repository (
.( )
GetAllAsync) 4
(4 5
)5 6
;6 7
return 
projects 
. 
Select 
( 
p  
=>! #
new$ '

ProjectDto( 2
(2 3
p3 4
.4 5
Id5 7
,7 8
p9 :
.: ;
Name; ?
,? @
pA B
.B C

ProjectKeyC M
,M N
pO P
.P Q
DescriptionQ \
,\ ]
p^ _
._ `
IsActive` h
)h i
)i j
;j k
} 
public 

async 
Task 
< 

ProjectDto  
?  !
>! "
GetByIdAsync# /
(/ 0
int0 3
id4 6
)6 7
{ 
var 
p 
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
p 
== 
null 
) 
return 
null "
;" #
return 
new 

ProjectDto 
( 
p 
.  
Id  "
," #
p$ %
.% &
Name& *
,* +
p, -
.- .

ProjectKey. 8
,8 9
p: ;
.; <
Description< G
,G H
pI J
.J K
IsActiveK S
)S T
;T U
} 
public!! 

async!! 
Task!! 
<!! 

ProjectDto!!  
>!!  !
CreateAsync!!" -
(!!- .
CreateProjectDto!!. >
dto!!? B
)!!B C
{"" 
var## 
p## 
=## 
new## 
Project## 
{$$ 	
Name%% 
=%% 
dto%% 
.%% 
Name%% 
,%% 

ProjectKey&& 
=&& 
dto&& 
.&& 

ProjectKey&& '
,&&' (
Description'' 
='' 
dto'' 
.'' 
Description'' )
}(( 	
;((	 

await)) 
_repository)) 
.)) 
AddAsync)) "
())" #
p))# $
)))$ %
;))% &
return** 
new** 

ProjectDto** 
(** 
p** 
.**  
Id**  "
,**" #
p**$ %
.**% &
Name**& *
,*** +
p**, -
.**- .

ProjectKey**. 8
,**8 9
p**: ;
.**; <
Description**< G
,**G H
p**I J
.**J K
IsActive**K S
)**S T
;**T U
}++ 
public-- 

async-- 
Task-- 
UpdateAsync-- !
(--! "
int--" %
id--& (
,--( )
UpdateProjectDto--* :
dto--; >
)--> ?
{.. 
var// 
p// 
=// 
await// 
_repository// !
.//! "
GetByIdAsync//" .
(//. /
id/// 1
)//1 2
;//2 3
if00 

(00 
p00 
==00 
null00 
)00 
throw00 
new00   
KeyNotFoundException00! 5
(005 6
$str006 I
)00I J
;00J K
p22 	
.22	 

Name22
 
=22 
dto22 
.22 
Name22 
;22 
p33 	
.33	 


ProjectKey33
 
=33 
dto33 
.33 

ProjectKey33 %
;33% &
p44 	
.44	 

Description44
 
=44 
dto44 
.44 
Description44 '
;44' (
p55 	
.55	 

IsActive55
 
=55 
dto55 
.55 
IsActive55 !
;55! "
await66 
_repository66 
.66 
UpdateAsync66 %
(66% &
p66& '
)66' (
;66( )
}77 
public99 

async99 
Task99 
DeleteAsync99 !
(99! "
int99" %
id99& (
)99( )
{:: 
await;; 
_repository;; 
.;; 
DeleteAsync;; %
(;;% &
id;;& (
);;( )
;;;) *
}<< 
public>> 

async>> 
Task>> 
AddMemberAsync>> $
(>>$ %
int>>% (
	projectId>>) 2
,>>2 3
int>>4 7
userId>>8 >
)>>> ?
{?? 
var@@ 
exists@@ 
=@@ 
await@@ 
_context@@ #
.@@# $
ProjectMembers@@$ 2
.@@2 3
AnyAsync@@3 ;
(@@; <
pm@@< >
=>@@? A
pm@@B D
.@@D E
	ProjectId@@E N
==@@O Q
	projectId@@R [
&&@@\ ^
pm@@_ a
.@@a b
UserId@@b h
==@@i k
userId@@l r
)@@r s
;@@s t
ifAA 

(AA 
!AA 
existsAA 
)AA 
{BB 	
_contextCC 
.CC 
ProjectMembersCC #
.CC# $
AddCC$ '
(CC' (
newCC( +
ProjectMemberCC, 9
{CC: ;
	ProjectIdCC< E
=CCF G
	projectIdCCH Q
,CCQ R
UserIdCCS Y
=CCZ [
userIdCC\ b
}CCc d
)CCd e
;CCe f
awaitDD 
_contextDD 
.DD 
SaveChangesAsyncDD +
(DD+ ,
)DD, -
;DD- .
}EE 	
}FF 
publicHH 

asyncHH 
TaskHH 
RemoveMemberAsyncHH '
(HH' (
intHH( +
	projectIdHH, 5
,HH5 6
intHH7 :
userIdHH; A
)HHA B
{II 
varJJ 
pmJJ 
=JJ 
awaitJJ 
_contextJJ 
.JJ  
ProjectMembersJJ  .
.JJ. /
FirstOrDefaultAsyncJJ/ B
(JJB C
xJJC D
=>JJE G
xJJH I
.JJI J
	ProjectIdJJJ S
==JJT V
	projectIdJJW `
&&JJa c
xJJd e
.JJe f
UserIdJJf l
==JJm o
userIdJJp v
)JJv w
;JJw x
ifKK 

(KK 
pmKK 
!=KK 
nullKK 
)KK 
{LL 	
_contextMM 
.MM 
ProjectMembersMM #
.MM# $
RemoveMM$ *
(MM* +
pmMM+ -
)MM- .
;MM. /
awaitNN 
_contextNN 
.NN 
SaveChangesAsyncNN +
(NN+ ,
)NN, -
;NN- .
}OO 	
}PP 
}QQ ƒ1
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
IsActiveK S
)S T
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
.  !

Permission! +
)+ ,
. 
Where 
( 
p 
=> 
p 
!= 
null !
&&" $
p% &
.& '
IsActive' /
)/ 0
. 
Select 
( 
p 
=> 
p 
! 
. 
Key 
)  
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
userId&&& ,
)&&, -
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
.**  !
RoleId**! '
)**' (
.++ 
Join++ 
(++ 
_context++ 
.++ 
RolePermissions++ *
,++* +
roleId,, 
=>,, 
roleId,, "
,,," #
rp-- 
=>-- 
rp-- 
.-- 
RoleId-- !
,--! "
(.. 
roleId.. 
,.. 
rp.. 
).. 
=>.. !
rp.." $
...$ %

Permission..% /
)../ 0
.// 
Where// 
(// 
p// 
=>// 
p// 
!=// 
null// !
&&//" $
p//% &
.//& '
IsActive//' /
)/// 0
.00 
Select00 
(00 
p00 
=>00 
p00 
!00 
.00 
Key00 
)00  
.11 
ToListAsync11 
(11 
)11 
;11 
foreach33 
(33 
var33 
p33 
in33 
groupRolePerms33 (
)33( )
{44 	
permissions55 
.55 
Add55 
(55 
p55 
)55 
;55 
}66 	
var99 
	overrides99 
=99 
await99 
_context99 &
.99& '#
UserPermissionOverrides99' >
.:: 
Include:: 
(:: 
o:: 
=>:: 
o:: 
.:: 

Permission:: &
)::& '
.;; 
Where;; 
(;; 
o;; 
=>;; 
o;; 
.;; 
UserId;;  
==;;! #
userId;;$ *
&&;;+ -
o;;. /
.;;/ 0
	IsGranted;;0 9
&&;;: <
o;;= >
.;;> ?

Permission;;? I
!=;;J L
null;;M Q
&&;;R T
o;;U V
.;;V W

Permission;;W a
.;;a b
IsActive;;b j
);;j k
.<< 
Select<< 
(<< 
o<< 
=><< 
o<< 
.<< 

Permission<< %
!<<% &
.<<& '
Key<<' *
)<<* +
.== 
ToListAsync== 
(== 
)== 
;== 
foreach?? 
(?? 
var?? 
p?? 
in?? 
	overrides?? #
)??# $
{@@ 	
permissionsAA 
.AA 
AddAA 
(AA 
pAA 
)AA 
;AA 
}BB 	
returnDD 
permissionsDD 
;DD 
}EE 
}FF «%
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
}11 Ç$
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
}22 ©î
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
)==X Y
;==Y Z
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
.SS 
ToLowerSS $
(SS$ %
)SS% &
;SS& '
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
.TT, -
ToLowerTT- 4
(TT4 5
)TT5 6
.TT6 7
ContainsTT7 ?
(TT? @
kwTT@ B
)TTB C
||TTD F
aTTG H
.TTH I
ContentTTI P
.TTP Q
ToLowerTTQ X
(TTX Y
)TTY Z
.TTZ [
ContainsTT[ c
(TTc d
kwTTd f
)TTf g
)TTg h
;TTh i
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
)``X Y
;``Y Z
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
}OO ∫¬
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
}77 ±ß
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
.$ %
Include% ,
(, -
t- .
=>/ 1
t2 3
.3 4
	TicketSla4 =
)= >
.> ?
Where? D
(D E
tE F
=>G I
!J K
tK L
.L M
	IsDeletedM V
)V W
;W X
if 

( 
perms 
. 
Contains 
( 
$str (
)( )
)) *
{ 	
return   
query   
;   
}!! 	
var## 
isAgent## 
=## 
perms## 
.## 
Contains## $
(##$ %
$str##% 4
)##4 5
||##6 8
perms##9 >
.##> ?
Contains##? G
(##G H
$str##H W
)##W X
;##X Y
if$$ 

($$ 
isAgent$$ 
)$$ 
{%% 	
var&& 
userGroupIds&& 
=&& 
await&& $
_context&&% -
.&&- .
GroupMembers&&. :
.'' 
Where'' 
('' 
gm'' 
=>'' 
gm'' 
.''  
UserId''  &
==''' )
userId''* 0
&&''1 3
!''4 5
gm''5 7
.''7 8
	IsDeleted''8 A
)''A B
.(( 
Select(( 
((( 
gm(( 
=>(( 
gm((  
.((  !
GroupId((! (
)((( )
.)) 
ToListAsync)) 
()) 
))) 
;)) 
return++ 
query++ 
.++ 
Where++ 
(++ 
t++  
=>++! #
t++$ %
.++% &
AssignedUserId++& 4
==++5 7
userId++8 >
||++? A
(,,$ %
t,,% &
.,,& '
AssignedGroupId,,' 6
.,,6 7
HasValue,,7 ?
&&,,@ B
userGroupIds,,C O
.,,O P
Contains,,P X
(,,X Y
t,,Y Z
.,,Z [
AssignedGroupId,,[ j
.,,j k
Value,,k p
),,p q
),,q r
||,,s u
t--$ %
.--% &
RequesterUserId--& 5
==--6 8
userId--9 ?
)--? @
;--@ A
}.. 	
return11 
query11 
.11 
Where11 
(11 
t11 
=>11 
t11  !
.11! "
RequesterUserId11" 1
==112 4
userId115 ;
)11; <
;11< =
}22 
public44 

async44 
Task44 
<44  
DashboardOverviewDto44 *
>44* +
GetOverviewAsync44, <
(44< =
int44= @
userId44A G
)44G H
{55 
var66 
query66 
=66 
await66 &
GetScopedTicketsQueryAsync66 4
(664 5
userId665 ;
)66; <
;66< =
var88 
openTicketsCount88 
=88 
await88 $
query88% *
.88* +

CountAsync88+ 5
(885 6
t886 7
=>888 :
t88; <
.88< =
Status88= C
!=88D F
null88G K
&&88L N
!88O P
t88P Q
.88Q R
Status88R X
.88X Y
IsClosedStatus88Y g
)88g h
;88h i
var99  
criticalTicketsCount99  
=99! "
await99# (
query99) .
.99. /

CountAsync99/ 9
(999 :
t99: ;
=>99< >
t99? @
.99@ A
Priority99A I
!=99J L
null99M Q
&&99R T
t99U V
.99V W
Priority99W _
.99_ `
SeverityLevel99` m
==99n p
$num99q r
&&99s u
t99v w
.99w x
Status99x ~
!=	99 Å
null
99Ç Ü
&&
99á â
!
99ä ã
t
99ã å
.
99å ç
Status
99ç ì
.
99ì î
IsClosedStatus
99î ¢
)
99¢ £
;
99£ §
var:: 
slaBreachedCount:: 
=:: 
await:: $
query::% *
.::* +

CountAsync::+ 5
(::5 6
t::6 7
=>::8 :
t::; <
.::< =
	TicketSla::= F
!=::G I
null::J N
&&::O Q
(::R S
t::S T
.::T U
	TicketSla::U ^
.::^ _!
FirstResponseBreached::_ t
||::u w
t::x y
.::y z
	TicketSla	::z É
.
::É Ñ 
ResolutionBreached
::Ñ ñ
)
::ñ ó
&&
::ò ö
t
::õ ú
.
::ú ù
Status
::ù £
!=
::§ ¶
null
::ß ´
&&
::¨ Æ
!
::Ø ∞
t
::∞ ±
.
::± ≤
Status
::≤ ∏
.
::∏ π
IsClosedStatus
::π «
)
::« »
;
::» …
var;; 
slaRiskCount;; 
=;; 
await;;  
query;;! &
.;;& '

CountAsync;;' 1
(;;1 2
t;;2 3
=>;;4 6
t;;7 8
.;;8 9
	TicketSla;;9 B
!=;;C E
null;;F J
&&;;K M
(;;N O
t;;O P
.;;P Q
	TicketSla;;Q Z
.;;Z [
FirstResponseWarned;;[ n
||;;o q
t;;r s
.;;s t
	TicketSla;;t }
.;;} ~
ResolutionWarned	;;~ é
)
;;é è
&&
;;ê í
!
;;ì î
(
;;î ï
t
;;ï ñ
.
;;ñ ó
	TicketSla
;;ó †
.
;;† °#
FirstResponseBreached
;;° ∂
||
;;∑ π
t
;;∫ ª
.
;;ª º
	TicketSla
;;º ≈
.
;;≈ ∆ 
ResolutionBreached
;;∆ ÿ
)
;;ÿ Ÿ
&&
;;⁄ ‹
t
;;› ﬁ
.
;;ﬁ ﬂ
Status
;;ﬂ Â
!=
;;Ê Ë
null
;;È Ì
&&
;;Ó 
!
;;Ò Ú
t
;;Ú Û
.
;;Û Ù
Status
;;Ù ˙
.
;;˙ ˚
IsClosedStatus
;;˚ â
)
;;â ä
;
;;ä ã
var<< 
unassignedCount<< 
=<< 
await<< #
query<<$ )
.<<) *

CountAsync<<* 4
(<<4 5
t<<5 6
=><<7 9
t<<: ;
.<<; <
AssignedUserId<<< J
==<<K M
null<<N R
&&<<S U
t<<V W
.<<W X
Status<<X ^
!=<<_ a
null<<b f
&&<<g i
!<<j k
t<<k l
.<<l m
Status<<m s
.<<s t
IsClosedStatus	<<t Ç
)
<<Ç É
;
<<É Ñ
return>> 
new>>  
DashboardOverviewDto>> '
(>>' (
openTicketsCount>>( 8
,>>8 9 
criticalTicketsCount>>: N
,>>N O
slaBreachedCount>>P `
,>>` a
slaRiskCount>>b n
,>>n o
unassignedCount>>p 
)	>> Ä
;
>>Ä Å
}?? 
publicAA 

asyncAA 
TaskAA 
<AA %
DashboardDistributionsDtoAA /
>AA/ 0!
GetDistributionsAsyncAA1 F
(AAF G
intAAG J
userIdAAK Q
)AAQ R
{BB 
varCC 
queryCC 
=CC 
awaitCC &
GetScopedTicketsQueryAsyncCC 4
(CC4 5
userIdCC5 ;
)CC; <
;CC< =
varEE 
byStatusEE 
=EE 
awaitEE 
queryEE "
.FF 
WhereFF 
(FF 
tFF 
=>FF 
tFF 
.FF 
StatusFF  
!=FF! #
nullFF$ (
)FF( )
.GG 
GroupByGG 
(GG 
tGG 
=>GG 
tGG 
.GG 
StatusGG "
!GG" #
.GG# $
NameGG$ (
)GG( )
.HH 
SelectHH 
(HH 
gHH 
=>HH 
newHH !
TicketDistributionDtoHH 2
(HH2 3
gHH3 4
.HH4 5
KeyHH5 8
,HH8 9
gHH: ;
.HH; <
CountHH< A
(HHA B
)HHB C
)HHC D
)HHD E
.II 
ToListAsyncII 
(II 
)II 
;II 
varKK 

byPriorityKK 
=KK 
awaitKK 
queryKK $
.LL 
WhereLL 
(LL 
tLL 
=>LL 
tLL 
.LL 
PriorityLL "
!=LL# %
nullLL& *
)LL* +
.MM 
GroupByMM 
(MM 
tMM 
=>MM 
tMM 
.MM 
PriorityMM $
!MM$ %
.MM% &
NameMM& *
)MM* +
.NN 
SelectNN 
(NN 
gNN 
=>NN 
newNN !
TicketDistributionDtoNN 2
(NN2 3
gNN3 4
.NN4 5
KeyNN5 8
,NN8 9
gNN: ;
.NN; <
CountNN< A
(NNA B
)NNB C
)NNC D
)NND E
.OO 
ToListAsyncOO 
(OO 
)OO 
;OO 
varQQ 
	byProjectQQ 
=QQ 
awaitQQ 
queryQQ #
.RR 
WhereRR 
(RR 
tRR 
=>RR 
tRR 
.RR 
ProjectRR !
!=RR" $
nullRR% )
)RR) *
.SS 
GroupBySS 
(SS 
tSS 
=>SS 
tSS 
.SS 
ProjectSS #
!SS# $
.SS$ %
NameSS% )
)SS) *
.TT 
SelectTT 
(TT 
gTT 
=>TT 
newTT !
TicketDistributionDtoTT 2
(TT2 3
gTT3 4
.TT4 5
KeyTT5 8
,TT8 9
gTT: ;
.TT; <
CountTT< A
(TTA B
)TTB C
)TTC D
)TTD E
.UU 
ToListAsyncUU 
(UU 
)UU 
;UU 
varWW 

byCategoryWW 
=WW 
awaitWW 
queryWW $
.XX 
WhereXX 
(XX 
tXX 
=>XX 
tXX 
.XX 
CategoryXX "
!=XX# %
nullXX& *
)XX* +
.YY 
GroupByYY 
(YY 
tYY 
=>YY 
tYY 
.YY 
CategoryYY $
!YY$ %
.YY% &
NameYY& *
)YY* +
.ZZ 
SelectZZ 
(ZZ 
gZZ 
=>ZZ 
newZZ !
TicketDistributionDtoZZ 2
(ZZ2 3
gZZ3 4
.ZZ4 5
KeyZZ5 8
,ZZ8 9
gZZ: ;
.ZZ; <
CountZZ< A
(ZZA B
)ZZB C
)ZZC D
)ZZD E
.[[ 
ToListAsync[[ 
([[ 
)[[ 
;[[ 
return]] 
new]] %
DashboardDistributionsDto]] ,
(]], -
byStatus]]- 5
,]]5 6

byPriority]]7 A
,]]A B
	byProject]]C L
,]]L M

byCategory]]N X
)]]X Y
;]]Y Z
}^^ 
public`` 

async`` 
Task`` 
<`` 
IEnumerable`` !
<``! "
AgentWorkloadDto``" 2
>``2 3
>``3 4!
GetAgentWorkloadAsync``5 J
(``J K
int``K N
userId``O U
)``U V
{aa 
varbb 
querybb 
=bb 
awaitbb &
GetScopedTicketsQueryAsyncbb 4
(bb4 5
userIdbb5 ;
)bb; <
;bb< =
vardd 
workloaddd 
=dd 
awaitdd 
querydd "
.ee 
Whereee 
(ee 
tee 
=>ee 
tee 
.ee 
AssignedUserIdee (
!=ee) +
nullee, 0
&&ee1 3
tee4 5
.ee5 6
Statusee6 <
!=ee= ?
nullee@ D
&&eeE G
!eeH I
teeI J
.eeJ K
StatuseeK Q
.eeQ R
IsClosedStatuseeR `
)ee` a
.ff 
GroupByff 
(ff 
tff 
=>ff 
newff 
{ff 
tff  !
.ff! "
AssignedUserIdff" 0
,ff0 1
tff2 3
.ff3 4
AssignedUserff4 @
!ff@ A
.ffA B
	FirstNameffB K
,ffK L
tffM N
.ffN O
AssignedUserffO [
!ff[ \
.ff\ ]
LastNameff] e
}fff g
)ffg h
.gg 
Selectgg 
(gg 
ggg 
=>gg 
newgg 
AgentWorkloadDtogg -
(gg- .
ggg. /
.gg/ 0
Keygg0 3
.gg3 4
AssignedUserIdgg4 B
!ggB C
.ggC D
ValueggD I
,ggI J
$"ggK M
{ggM N
gggN O
.ggO P
KeyggP S
.ggS T
	FirstNameggT ]
}gg] ^
$strgg^ _
{gg_ `
ggg` a
.gga b
Keyggb e
.gge f
LastNameggf n
}ggn o
"ggo p
,ggp q
gggr s
.ggs t
Countggt y
(ggy z
)ggz {
)gg{ |
)gg| }
.hh 
ToListAsynchh 
(hh 
)hh 
;hh 
returnjj 
workloadjj 
.jj 
OrderByDescendingjj )
(jj) *
wjj* +
=>jj, .
wjj/ 0
.jj0 1
OpenTicketCountjj1 @
)jj@ A
;jjA B
}kk 
publicmm 

asyncmm 
Taskmm 
<mm 
SlaComplianceDtomm &
>mm& '!
GetSlaComplianceAsyncmm( =
(mm= >
intmm> A
userIdmmB H
)mmH I
{nn 
varoo 
queryoo 
=oo 
awaitoo &
GetScopedTicketsQueryAsyncoo 4
(oo4 5
userIdoo5 ;
)oo; <
;oo< =
varqq 
ticketsWithSlaqq 
=qq 
awaitqq "
queryqq# (
.rr 
Whererr 
(rr 
trr 
=>rr 
trr 
.rr 
	TicketSlarr #
!=rr$ &
nullrr' +
)rr+ ,
.ss 
Selectss 
(ss 
tss 
=>ss 
newss 
{ss 
ttt 
.tt 
	TicketSlatt 
!tt 
.tt 
FirstResponseDueAttt /
,tt/ 0
tuu 
.uu 
	TicketSlauu 
.uu 
FirstResponseMetAtuu .
,uu. /
tvv 
.vv 
	TicketSlavv 
.vv 
ResolutionDueAtvv +
,vv+ ,
tww 
.ww 
	TicketSlaww 
.ww 
ResolutionMetAtww +
,ww+ ,
txx 
.xx 
	TicketSlaxx 
.xx !
FirstResponseBreachedxx 1
,xx1 2
tyy 
.yy 
	TicketSlayy 
.yy 
ResolutionBreachedyy .
,yy. /
	CreatedAtzz 
=zz 
tzz 
.zz 
	CreatedAtzz '
,zz' (

ResolvedAt{{ 
={{ 
t{{ 
.{{ 
Status{{ %
!={{& (
null{{) -
&&{{. 0
t{{1 2
.{{2 3
Status{{3 9
.{{9 :
IsClosedStatus{{: H
?{{I J
t{{K L
.{{L M
	TicketSla{{M V
.{{V W
ResolutionMetAt{{W f
??{{g i
DateTime{{j r
.{{r s
UtcNow{{s y
:{{z {
({{| }
DateTime	{{} Ö
?
{{Ö Ü
)
{{Ü á
null
{{á ã
}|| 
)|| 
.}} 
ToListAsync}} 
(}} 
)}} 
;}} 
if 

( 
! 
ticketsWithSla 
. 
Any 
(  
)  !
)! "
return# )
new* -
SlaComplianceDto. >
(> ?
$num? B
,B C
$numD G
,G H
$numI J
)J K
;K L
var
ÅÅ #
firstResponseEligible
ÅÅ !
=
ÅÅ" #
ticketsWithSla
ÅÅ$ 2
.
ÅÅ2 3
Where
ÅÅ3 8
(
ÅÅ8 9
t
ÅÅ9 :
=>
ÅÅ; =
t
ÅÅ> ?
.
ÅÅ? @ 
FirstResponseDueAt
ÅÅ@ R
!=
ÅÅS U
null
ÅÅV Z
)
ÅÅZ [
.
ÅÅ[ \
ToList
ÅÅ\ b
(
ÅÅb c
)
ÅÅc d
;
ÅÅd e
var
ÇÇ 
frCompliant
ÇÇ 
=
ÇÇ #
firstResponseEligible
ÇÇ /
.
ÇÇ/ 0
Count
ÇÇ0 5
(
ÇÇ5 6
t
ÇÇ6 7
=>
ÇÇ8 :
!
ÇÇ; <
t
ÇÇ< =
.
ÇÇ= >#
FirstResponseBreached
ÇÇ> S
)
ÇÇS T
;
ÇÇT U
var
ÉÉ 
frRate
ÉÉ 
=
ÉÉ #
firstResponseEligible
ÉÉ *
.
ÉÉ* +
Any
ÉÉ+ .
(
ÉÉ. /
)
ÉÉ/ 0
?
ÉÉ1 2
(
ÉÉ3 4
frCompliant
ÉÉ4 ?
/
ÉÉ@ A
(
ÉÉB C
double
ÉÉC I
)
ÉÉI J#
firstResponseEligible
ÉÉJ _
.
ÉÉ_ `
Count
ÉÉ` e
)
ÉÉe f
*
ÉÉg h
$num
ÉÉi l
:
ÉÉm n
$num
ÉÉo r
;
ÉÉr s
var
ÖÖ 
resEligible
ÖÖ 
=
ÖÖ 
ticketsWithSla
ÖÖ (
.
ÖÖ( )
Where
ÖÖ) .
(
ÖÖ. /
t
ÖÖ/ 0
=>
ÖÖ1 3
t
ÖÖ4 5
.
ÖÖ5 6
ResolutionDueAt
ÖÖ6 E
!=
ÖÖF H
null
ÖÖI M
)
ÖÖM N
.
ÖÖN O
ToList
ÖÖO U
(
ÖÖU V
)
ÖÖV W
;
ÖÖW X
var
ÜÜ 
resCompliant
ÜÜ 
=
ÜÜ 
resEligible
ÜÜ &
.
ÜÜ& '
Count
ÜÜ' ,
(
ÜÜ, -
t
ÜÜ- .
=>
ÜÜ/ 1
!
ÜÜ2 3
t
ÜÜ3 4
.
ÜÜ4 5 
ResolutionBreached
ÜÜ5 G
)
ÜÜG H
;
ÜÜH I
var
áá 
resRate
áá 
=
áá 
resEligible
áá !
.
áá! "
Any
áá" %
(
áá% &
)
áá& '
?
áá( )
(
áá* +
resCompliant
áá+ 7
/
áá8 9
(
áá: ;
double
áá; A
)
ááA B
resEligible
ááB M
.
ááM N
Count
ááN S
)
ááS T
*
ááU V
$num
ááW Z
:
áá[ \
$num
áá] `
;
áá` a
var
ââ 
resolvedTickets
ââ 
=
ââ 
ticketsWithSla
ââ ,
.
ââ, -
Where
ââ- 2
(
ââ2 3
t
ââ3 4
=>
ââ5 7
t
ââ8 9
.
ââ9 :

ResolvedAt
ââ: D
!=
ââE G
null
ââH L
)
ââL M
.
ââM N
ToList
ââN T
(
ââT U
)
ââU V
;
ââV W
var
ää 
avgTime
ää 
=
ää 
resolvedTickets
ää %
.
ää% &
Any
ää& )
(
ää) *
)
ää* +
?
ää, -
resolvedTickets
ää. =
.
ää= >
Average
ää> E
(
ääE F
t
ääF G
=>
ääH J
(
ääK L
t
ääL M
.
ääM N

ResolvedAt
ääN X
!
ääX Y
.
ääY Z
Value
ääZ _
-
ää` a
t
ääb c
.
ääc d
	CreatedAt
ääd m
)
ääm n
.
ään o
TotalMinutes
ääo {
)
ää{ |
:
ää} ~
$numää Ç
;ääÇ É
return
åå 
new
åå 
SlaComplianceDto
åå #
(
åå# $
frRate
åå$ *
,
åå* +
resRate
åå, 3
,
åå3 4
avgTime
åå5 <
)
åå< =
;
åå= >
}
çç 
}éé ´≈
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
}•• †D
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
var 
user 
= 
await 
_context !
.! "
Users" '
. 
FirstOrDefaultAsync  
(  !
u! "
=># %
u& '
.' (
Username( 0
==1 3
request4 ;
.; <
Username< D
&&E G
uH I
.I J
IsActiveJ R
&&S U
!V W
uW X
.X Y
	IsDeletedY b
)b c
;c d
if!! 

(!! 
user!! 
==!! 
null!! 
||!! 
!!! 
BCrypt!! #
.!!# $
Net!!$ '
.!!' (
BCrypt!!( .
.!!. /
Verify!!/ 5
(!!5 6
request!!6 =
.!!= >
Password!!> F
,!!F G
user!!H L
.!!L M
PasswordHash!!M Y
)!!Y Z
)!!Z [
{"" 	
throw## 
new## '
UnauthorizedAccessException## 1
(##1 2
$str##2 H
)##H I
;##I J
}$$ 	
var&& 
roles&& 
=&& 
await&& 
_context&& "
.&&" #
	UserRoles&&# ,
.'' 
Where'' 
('' 
ur'' 
=>'' 
ur'' 
.'' 
UserId'' "
==''# %
user''& *
.''* +
Id''+ -
&&''. 0
ur''1 3
.''3 4
Role''4 8
!=''9 ;
null''< @
&&''A C
ur''D F
.''F G
Role''G K
.''K L
IsActive''L T
)''T U
.(( 
Select(( 
((( 
ur(( 
=>(( 
ur(( 
.(( 
Role(( !
!((! "
.((" #
Name((# '
)((' (
.)) 
ToListAsync)) 
()) 
))) 
;)) 
var++ 
permissions++ 
=++ 
await++ !
_permissionCalculator++  5
.++5 6.
"CalculateEffectivePermissionsAsync++6 X
(++X Y
user++Y ]
.++] ^
Id++^ `
)++` a
;++a b
var-- 
token-- 
=-- 
_tokenService-- !
.--! "
GenerateToken--" /
(--/ 0
user--0 4
.--4 5
Id--5 7
,--7 8
user--9 =
.--= >
Username--> F
,--F G
roles--H M
,--M N
permissions--O Z
)--Z [
;--[ \
var// 
expiryMinutes// 
=// 
double// "
.//" #
Parse//# (
(//( )
_configuration//) 7
[//7 8
$str//8 K
]//K L
??//M O
$str//P U
)//U V
;//V W
return11 
new11 
AuthResponseDto11 "
(11" #
Token22 
:22 
token22 
,22 
	ExpiresAt33 
:33 
DateTime33 
.33  
UtcNow33  &
.33& '

AddMinutes33' 1
(331 2
expiryMinutes332 ?
)33? @
,33@ A
Username44 
:44 
user44 
.44 
Username44 #
,44# $
Roles55 
:55 
roles55 
,55 
Permissions66 
:66 
permissions66 $
)77 	
;77	 

}88 
public:: 

async:: 
Task:: 
<:: 
MeResponseDto:: #
>::# $

GetMeAsync::% /
(::/ 0
int::0 3
userId::4 :
)::: ;
{;; 
var<< 
user<< 
=<< 
await<< 
_context<< !
.<<! "
Users<<" '
.== 
FirstOrDefaultAsync==  
(==  !
u==! "
=>==# %
u==& '
.==' (
Id==( *
====+ -
userId==. 4
&&==5 7
u==8 9
.==9 :
IsActive==: B
&&==C E
!==F G
u==G H
.==H I
	IsDeleted==I R
)==R S
;==S T
if?? 

(?? 
user?? 
==?? 
null?? 
)?? 
throw@@ 
new@@ '
UnauthorizedAccessException@@ 1
(@@1 2
$str@@2 C
)@@C D
;@@D E
varBB 
rolesBB 
=BB 
awaitBB 
_contextBB "
.BB" #
	UserRolesBB# ,
.CC 
WhereCC 
(CC 
urCC 
=>CC 
urCC 
.CC 
UserIdCC "
==CC# %
userCC& *
.CC* +
IdCC+ -
&&CC. 0
urCC1 3
.CC3 4
RoleCC4 8
!=CC9 ;
nullCC< @
&&CCA C
urCCD F
.CCF G
RoleCCG K
.CCK L
IsActiveCCL T
)CCT U
.DD 
SelectDD 
(DD 
urDD 
=>DD 
urDD 
.DD 
RoleDD !
!DD! "
.DD" #
NameDD# '
)DD' (
.EE 
ToListAsyncEE 
(EE 
)EE 
;EE 
varGG 
groupsGG 
=GG 
awaitGG 
_contextGG #
.GG# $
GroupMembersGG$ 0
.HH 
WhereHH 
(HH 
gmHH 
=>HH 
gmHH 
.HH 
UserIdHH "
==HH# %
userHH& *
.HH* +
IdHH+ -
&&HH. 0
gmHH1 3
.HH3 4
GroupHH4 9
!=HH: <
nullHH= A
&&HHB D
gmHHE G
.HHG H
GroupHHH M
.HHM N
IsActiveHHN V
)HHV W
.II 
SelectII 
(II 
gmII 
=>II 
gmII 
.II 
GroupII "
!II" #
.II# $
NameII$ (
)II( )
.JJ 
ToListAsyncJJ 
(JJ 
)JJ 
;JJ 
varLL 
permissionsLL 
=LL 
awaitLL !
_permissionCalculatorLL  5
.LL5 6.
"CalculateEffectivePermissionsAsyncLL6 X
(LLX Y
userLLY ]
.LL] ^
IdLL^ `
)LL` a
;LLa b
returnNN 
newNN 
MeResponseDtoNN  
(NN  !
IdOO 
:OO 
userOO 
.OO 
IdOO 
,OO 
UsernamePP 
:PP 
userPP 
.PP 
UsernamePP #
,PP# $
EmailQQ 
:QQ 
userQQ 
.QQ 
EmailQQ 
,QQ 
GroupsRR 
:RR 
groupsRR 
,RR 
RolesSS 
:SS 
rolesSS 
,SS 
PermissionsTT 
:TT 
permissionsTT $
)UU 	
;UU	 

}VV 
}WW Ö"
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
}44 ¸
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
}˛˛ •
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
} àÑ
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
}>> åS
`/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/ItsToolDbContext.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
;% &
public 
class 
ItsToolDbContext 
: 
	DbContext  )
{ 
public 

ItsToolDbContext 
( 
DbContextOptions ,
<, -
ItsToolDbContext- =
>= >
options? F
)F G
:H I
baseJ N
(N O
optionsO V
)V W
{ 
} 
public 

DbSet 
< 

Department 
> 
Departments (
=>) +
Set, /
</ 0

Department0 :
>: ;
(; <
)< =
;= >
public 

DbSet 
< 
Group 
> 
Groups 
=> !
Set" %
<% &
Group& +
>+ ,
(, -
)- .
;. /
public 

DbSet 
< 
User 
> 
Users 
=> 
Set  #
<# $
User$ (
>( )
() *
)* +
;+ ,
public 

DbSet 
< 
GroupMember 
> 
GroupMembers *
=>+ -
Set. 1
<1 2
GroupMember2 =
>= >
(> ?
)? @
;@ A
public 

DbSet 
< 
Role 
> 
Roles 
=> 
Set  #
<# $
Role$ (
>( )
() *
)* +
;+ ,
public 

DbSet 
< 

Permission 
> 
Permissions (
=>) +
Set, /
</ 0

Permission0 :
>: ;
(; <
)< =
;= >
public 

DbSet 
< 
RolePermission 
>  
RolePermissions! 0
=>1 3
Set4 7
<7 8
RolePermission8 F
>F G
(G H
)H I
;I J
public 

DbSet 
< 
UserRole 
> 
	UserRoles $
=>% '
Set( +
<+ ,
UserRole, 4
>4 5
(5 6
)6 7
;7 8
public   

DbSet   
<   
	GroupRole   
>   

GroupRoles   &
=>  ' )
Set  * -
<  - .
	GroupRole  . 7
>  7 8
(  8 9
)  9 :
;  : ;
public!! 

DbSet!! 
<!! "
UserPermissionOverride!! '
>!!' (#
UserPermissionOverrides!!) @
=>!!A C
Set!!D G
<!!G H"
UserPermissionOverride!!H ^
>!!^ _
(!!_ `
)!!` a
;!!a b
public$$ 

DbSet$$ 
<$$ 
Project$$ 
>$$ 
Projects$$ "
=>$$# %
Set$$& )
<$$) *
Project$$* 1
>$$1 2
($$2 3
)$$3 4
;$$4 5
public%% 

DbSet%% 
<%% 
ProjectMember%% 
>%% 
ProjectMembers%%  .
=>%%/ 1
Set%%2 5
<%%5 6
ProjectMember%%6 C
>%%C D
(%%D E
)%%E F
;%%F G
public(( 

DbSet(( 
<(( 

TicketType(( 
>(( 
TicketTypes(( (
=>(() +
Set((, /
<((/ 0

TicketType((0 :
>((: ;
(((; <
)((< =
;((= >
public)) 

DbSet)) 
<)) 
Category)) 
>)) 

Categories)) %
=>))& (
Set))) ,
<)), -
Category))- 5
>))5 6
())6 7
)))7 8
;))8 9
public** 

DbSet** 
<** 
Status** 
>** 
Statuses** !
=>**" $
Set**% (
<**( )
Status**) /
>**/ 0
(**0 1
)**1 2
;**2 3
public++ 

DbSet++ 
<++ 
Priority++ 
>++ 

Priorities++ %
=>++& (
Set++) ,
<++, -
Priority++- 5
>++5 6
(++6 7
)++7 8
;++8 9
public,, 

DbSet,, 
<,, 
Ticket,, 
>,, 
Tickets,,  
=>,,! #
Set,,$ '
<,,' (
Ticket,,( .
>,,. /
(,,/ 0
),,0 1
;,,1 2
public-- 

DbSet-- 
<-- 
TicketHistory-- 
>-- 
TicketHistories--  /
=>--0 2
Set--3 6
<--6 7
TicketHistory--7 D
>--D E
(--E F
)--F G
;--G H
public.. 

DbSet.. 
<.. 
Workflow.. 
>.. 
	Workflows.. $
=>..% '
Set..( +
<..+ ,
Workflow.., 4
>..4 5
(..5 6
)..6 7
;..7 8
public// 

DbSet// 
<// 
WorkflowTransition// #
>//# $
WorkflowTransitions//% 8
=>//9 ;
Set//< ?
<//? @
WorkflowTransition//@ R
>//R S
(//S T
)//T U
;//U V
public00 

DbSet00 
<00 
TicketComment00 
>00 
TicketComments00  .
=>00/ 1
Set002 5
<005 6
TicketComment006 C
>00C D
(00D E
)00E F
;00F G
public11 

DbSet11 
<11 
TicketAttachment11 !
>11! "
TicketAttachments11# 4
=>115 7
Set118 ;
<11; <
TicketAttachment11< L
>11L M
(11M N
)11N O
;11O P
public22 

DbSet22 
<22 
TicketWatcher22 
>22 
TicketWatchers22  .
=>22/ 1
Set222 5
<225 6
TicketWatcher226 C
>22C D
(22D E
)22E F
;22F G
public33 

DbSet33 
<33 
ProjectSequence33  
>33  !
ProjectSequences33" 2
=>333 5
Set336 9
<339 :
ProjectSequence33: I
>33I J
(33J K
)33K L
;33L M
public66 

DbSet66 
<66 
FieldDefinition66  
>66  !
FieldDefinitions66" 2
=>663 5
Set666 9
<669 :
FieldDefinition66: I
>66I J
(66J K
)66K L
;66L M
public77 

DbSet77 
<77 
FieldOption77 
>77 
FieldOptions77 *
=>77+ -
Set77. 1
<771 2
FieldOption772 =
>77= >
(77> ?
)77? @
;77@ A
public88 

DbSet88 
<88 
FormFieldPlacement88 #
>88# $
FormFieldPlacements88% 8
=>889 ;
Set88< ?
<88? @
FormFieldPlacement88@ R
>88R S
(88S T
)88T U
;88U V
public99 

DbSet99 
<99 
TicketFieldValue99 !
>99! "
TicketFieldValues99# 4
=>995 7
Set998 ;
<99; <
TicketFieldValue99< L
>99L M
(99M N
)99N O
;99O P
public<< 

DbSet<< 
<<< 
	SlaPolicy<< 
><< 
SlaPolicies<< '
=><<( *
Set<<+ .
<<<. /
	SlaPolicy<</ 8
><<8 9
(<<9 :
)<<: ;
;<<; <
public== 

DbSet== 
<== 
	SlaTarget== 
>== 

SlaTargets== &
=>==' )
Set==* -
<==- .
	SlaTarget==. 7
>==7 8
(==8 9
)==9 :
;==: ;
public>> 

DbSet>> 
<>> 
BusinessHour>> 
>>> 
BusinessHours>> ,
=>>>- /
Set>>0 3
<>>3 4
BusinessHour>>4 @
>>>@ A
(>>A B
)>>B C
;>>C D
public?? 

DbSet?? 
<?? 
Holiday?? 
>?? 
Holidays?? "
=>??# %
Set??& )
<??) *
Holiday??* 1
>??1 2
(??2 3
)??3 4
;??4 5
public@@ 

DbSet@@ 
<@@ 
	TicketSla@@ 
>@@ 

TicketSlas@@ &
=>@@' )
Set@@* -
<@@- .
	TicketSla@@. 7
>@@7 8
(@@8 9
)@@9 :
;@@: ;
publicCC 

DbSetCC 
<CC 
NotificationRuleCC !
>CC! "
NotificationRulesCC# 4
=>CC5 7
SetCC8 ;
<CC; <
NotificationRuleCC< L
>CCL M
(CCM N
)CCN O
;CCO P
publicDD 

DbSetDD 
<DD 
NotificationDD 
>DD 
NotificationsDD ,
=>DD- /
SetDD0 3
<DD3 4
NotificationDD4 @
>DD@ A
(DDA B
)DDB C
;DDC D
publicGG 

DbSetGG 
<GG 
KnowledgeCategoryGG "
>GG" #
KnowledgeCategoriesGG$ 7
=>GG8 :
SetGG; >
<GG> ?
KnowledgeCategoryGG? P
>GGP Q
(GGQ R
)GGR S
;GGS T
publicHH 

DbSetHH 
<HH 
KnowledgeArticleHH !
>HH! "
KnowledgeArticlesHH# 4
=>HH5 7
SetHH8 ;
<HH; <
KnowledgeArticleHH< L
>HHL M
(HHM N
)HHN O
;HHO P
	protectedJJ 
overrideJJ 
voidJJ 
OnModelCreatingJJ +
(JJ+ ,
ModelBuilderJJ, 8
modelBuilderJJ9 E
)JJE F
{KK 
baseLL 
.LL 
OnModelCreatingLL 
(LL 
modelBuilderLL )
)LL) *
;LL* +
modelBuilderMM 
.MM +
ApplyConfigurationsFromAssemblyMM 4
(MM4 5
AssemblyMM5 =
.MM= > 
GetExecutingAssemblyMM> R
(MMR S
)MMS T
)MMT U
;MMU V
}NN 
}OO ˚"
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
}00 °	
g/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/ItsToolDbContextFactory.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
;% &
public 
class #
ItsToolDbContextFactory $
:% &'
IDesignTimeDbContextFactory' B
<B C
ItsToolDbContextC S
>S T
{ 
public 

ItsToolDbContext 
CreateDbContext +
(+ ,
string, 2
[2 3
]3 4
args5 9
)9 :
{		 
var

 
optionsBuilder

 
=

 
new

  #
DbContextOptionsBuilder

! 8
<

8 9
ItsToolDbContext

9 I
>

I J
(

J K
)

K L
;

L M
optionsBuilder 
. 
	UseNpgsql  
(  !
$str! m
)m n
;n o
return 
new 
ItsToolDbContext #
(# $
optionsBuilder$ 2
.2 3
Options3 :
): ;
;; <
} 
} ÚÇ
Z/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Infrastructure/Data/DataSeeder.cs
	namespace 	
ItsTool
 
. 
Infrastructure  
.  !
Data! %
;% &
public		 
class		 

DataSeeder		 
{

 
private 
readonly 
ItsToolDbContext %
_context& .
;. /
public 


DataSeeder 
( 
ItsToolDbContext &
context' .
). /
{ 
_context 
= 
context 
; 
} 
public 

async 
Task 
	SeedAsync 
(  
)  !
{ 
if 

( 
_context 
. 
TicketTypes  
.  !
Any! $
($ %
)% &
||' )
_context* 2
.2 3
Users3 8
.8 9
Any9 <
(< =
)= >
)> ?
{ 	
return 
; 
} 	
var 
incident 
= 
new 

TicketType %
{& '
Name( ,
=- .
$str/ 9
}: ;
;; <
var 
serviceRequest 
= 
new  

TicketType! +
{, -
Name. 2
=3 4
$str5 F
}G H
;H I
_context 
. 
TicketTypes 
. 
AddRange %
(% &
incident& .
,. /
serviceRequest0 >
)> ?
;? @
var 
open 
= 
new 
Status 
{ 
Name  $
=% &
$str' -
,- .
	SortOrder/ 8
=9 :
$num; <
,< =
IsSystemDefault> M
=N O
trueP T
}U V
;V W
var   

inProgress   
=   
new   
Status   #
{  $ %
Name  & *
=  + ,
$str  - ;
,  ; <
	SortOrder  = F
=  G H
$num  I J
}  K L
;  L M
var!! 
pending!! 
=!! 
new!! 
Status!!  
{!!! "
Name!!# '
=!!( )
$str!!* 5
,!!5 6
	SortOrder!!7 @
=!!A B
$num!!C D
,!!D E
	PausesSla!!F O
=!!P Q
true!!R V
}!!W X
;!!X Y
var"" 
resolved"" 
="" 
new"" 
Status"" !
{""" #
Name""$ (
="") *
$str""+ 4
,""4 5
	SortOrder""6 ?
=""@ A
$num""B C
,""C D
IsClosedStatus""E S
=""T U
true""V Z
}""[ \
;""\ ]
var## 
closed## 
=## 
new## 
Status## 
{##  !
Name##" &
=##' (
$str##) 4
,##4 5
	SortOrder##6 ?
=##@ A
$num##B C
,##C D
IsClosedStatus##E S
=##T U
true##V Z
}##[ \
;##\ ]
_context$$ 
.$$ 
Statuses$$ 
.$$ 
AddRange$$ "
($$" #
open$$# '
,$$' (

inProgress$$) 3
,$$3 4
pending$$5 <
,$$< =
resolved$$> F
,$$F G
closed$$H N
)$$N O
;$$O P
var'' 
critical'' 
='' 
new'' 
Priority'' #
{''$ %
Name''& *
=''+ ,
$str''- 5
,''5 6
Weight''7 =
=''> ?
$num''@ C
,''C D
SeverityLevel''E R
=''S T
$num''U V
}''W X
;''X Y
var(( 
high(( 
=(( 
new(( 
Priority(( 
{((  !
Name((" &
=((' (
$str(() 1
,((1 2
Weight((3 9
=((: ;
$num((< >
,((> ?
SeverityLevel((@ M
=((N O
$num((P Q
}((R S
;((S T
var)) 
medium)) 
=)) 
new)) 
Priority)) !
{))" #
Name))$ (
=))) *
$str))+ 1
,))1 2
Weight))3 9
=)): ;
$num))< >
,))> ?
SeverityLevel))@ M
=))N O
$num))P Q
}))R S
;))S T
var** 
low** 
=** 
new** 
Priority** 
{**  
Name**! %
=**& '
$str**( /
,**/ 0
Weight**1 7
=**8 9
$num**: <
,**< =
SeverityLevel**> K
=**L M
$num**N O
}**P Q
;**Q R
_context++ 
.++ 

Priorities++ 
.++ 
AddRange++ $
(++$ %
critical++% -
,++- .
high++/ 3
,++3 4
medium++5 ;
,++; <
low++= @
)++@ A
;++A B
var.. 
itDept.. 
=.. 
new.. 

Department.. #
{..$ %
Name..& *
=..+ ,
$str..- B
}..C D
;..D E
var// 
hrDept// 
=// 
new// 

Department// #
{//$ %
Name//& *
=//+ ,
$str//- ?
}//@ A
;//A B
_context00 
.00 
Departments00 
.00 
AddRange00 %
(00% &
itDept00& ,
,00, -
hrDept00. 4
)004 5
;005 6
var33 
helpdesk33 
=33 
new33 
Group33  
{33! "
Name33# '
=33( )
$str33* :
,33: ;

Department33< F
=33G H
itDept33I O
}33P Q
;33Q R
var44 

sysNetwork44 
=44 
new44 
Group44 "
{44# $
Name44% )
=44* +
$str44, D
,44D E

Department44F P
=44Q R
itDept44S Y
}44Z [
;44[ \
_context55 
.55 
Groups55 
.55 
AddRange55  
(55  !
helpdesk55! )
,55) *

sysNetwork55+ 5
)555 6
;556 7
var88 
superAdminRole88 
=88 
new88  
Role88! %
{88& '
Name88( ,
=88- .
$str88/ ;
}88< =
;88= >
_context99 
.99 
Roles99 
.99 
Add99 
(99 
superAdminRole99 )
)99) *
;99* +
if;; 

(;; 
!;; 
_context;; 
.;; 
Permissions;; !
.;;! "
Any;;" %
(;;% &
);;& '
);;' (
{<< 	
var== 
permissions== 
=== 
ItsTool== %
.==% &
Application==& 1
.==1 2
	Constants==2 ;
.==; <
PermissionConstants==< O
.==O P
AllPermissions==P ^
.>> 
Select>> 
(>> 
p>> 
=>>> 
new>>  

Permission>>! +
{>>, -
Name>>. 2
=>>3 4
p>>5 6
,>>6 7
Key>>8 ;
=>>< =
p>>> ?
}>>@ A
)>>A B
.?? 
ToList?? 
(?? 
)?? 
;?? 
_context@@ 
.@@ 
Permissions@@  
.@@  !
AddRange@@! )
(@@) *
permissions@@* 5
)@@5 6
;@@6 7
awaitCC 
_contextCC 
.CC 
SaveChangesAsyncCC +
(CC+ ,
)CC, -
;CC- .
foreachEE 
(EE 
varEE 
pEE 
inEE 
permissionsEE )
)EE) *
{FF 
_contextGG 
.GG 
RolePermissionsGG (
.GG( )
AddGG) ,
(GG, -
newGG- 0
RolePermissionGG1 ?
{GG@ A
RoleIdGGB H
=GGI J
superAdminRoleGGK Y
.GGY Z
IdGGZ \
,GG\ ]
PermissionIdGG^ j
=GGk l
pGGm n
.GGn o
IdGGo q
}GGr s
)GGs t
;GGt u
}HH 
}II 	
varLL 
	adminUserLL 
=LL 
newLL 
UserLL  
{MM 	
UsernameNN 
=NN 
$strNN 
,NN 
EmailOO 
=OO 
$strOO &
,OO& '
	FirstNamePP 
=PP 
$strPP  
,PP  !
LastNameQQ 
=QQ 
$strQQ 
,QQ 

DepartmentRR 
=RR 
itDeptRR 
,RR  
PasswordHashSS 
=SS 
BCryptSS !
.SS! "
NetSS" %
.SS% &
BCryptSS& ,
.SS, -
HashPasswordSS- 9
(SS9 :
$strSS: E
)SSE F
}TT 	
;TT	 

_contextUU 
.UU 
UsersUU 
.UU 
AddUU 
(UU 
	adminUserUU $
)UU$ %
;UU% &
awaitXX 
_contextXX 
.XX 
SaveChangesAsyncXX '
(XX' (
)XX( )
;XX) *
_context[[ 
.[[ 
	UserRoles[[ 
.[[ 
Add[[ 
([[ 
new[[ "
UserRole[[# +
{\\ 	
UserId]] 
=]] 
	adminUser]] 
.]] 
Id]] !
,]]! "
RoleId^^ 
=^^ 
superAdminRole^^ #
.^^# $
Id^^$ &
}__ 	
)__	 

;__
 
varbb 
p1bb 
=bb 
newbb 
ItsToolbb 
.bb 
Domainbb #
.bb# $
Entitiesbb$ ,
.bb, -
Projectbb- 4
.bb4 5
Projectbb5 <
{bb= >
Namebb? C
=bbD E
$strbbF Q
,bbQ R

ProjectKeybbS ]
=bb^ _
$strbb` e
}bbf g
;bbg h
varcc 
p2cc 
=cc 
newcc 
ItsToolcc 
.cc 
Domaincc #
.cc# $
Entitiescc$ ,
.cc, -
Projectcc- 4
.cc4 5
Projectcc5 <
{cc= >
Namecc? C
=ccD E
$strccF X
,ccX Y

ProjectKeyccZ d
=cce f
$strccg k
}ccl m
;ccm n
vardd 
p3dd 
=dd 
newdd 
ItsTooldd 
.dd 
Domaindd #
.dd# $
Entitiesdd$ ,
.dd, -
Projectdd- 4
.dd4 5
Projectdd5 <
{dd= >
Namedd? C
=ddD E
$strddF Z
,ddZ [

ProjectKeydd\ f
=ddg h
$strddi n
}ddo p
;ddp q
varee 
p4ee 
=ee 
newee 
ItsToolee 
.ee 
Domainee #
.ee# $
Entitiesee$ ,
.ee, -
Projectee- 4
.ee4 5
Projectee5 <
{ee= >
Nameee? C
=eeD E
$streeF X
,eeX Y

ProjectKeyeeZ d
=eee f
$streeg l
}eem n
;een o
varff 
p5ff 
=ff 
newff 
ItsToolff 
.ff 
Domainff #
.ff# $
Entitiesff$ ,
.ff, -
Projectff- 4
.ff4 5
Projectff5 <
{ff= >
Nameff? C
=ffD E
$strffF ^
,ff^ _

ProjectKeyff` j
=ffk l
$strffm r
}ffs t
;fft u
_contextgg 
.gg 
Projectsgg 
.gg 
AddRangegg "
(gg" #
p1gg# %
,gg% &
p2gg' )
,gg) *
p3gg+ -
,gg- .
p4gg/ 1
,gg1 2
p5gg3 5
)gg5 6
;gg6 7
varjj 
policyjj 
=jj 
newjj 
	SlaPolicyjj "
{jj# $
Namejj% )
=jj* +
$strjj, @
,jj@ A
DescriptionjjB M
=jjN O
$strjjP w
}jjx y
;jjy z
_contextkk 
.kk 
SlaPolicieskk 
.kk 
Addkk  
(kk  !
policykk! '
)kk' (
;kk( )
awaitmm 
_contextmm 
.mm 
SaveChangesAsyncmm '
(mm' (
)mm( )
;mm) *
_contextoo 
.oo 

SlaTargetsoo 
.oo 
AddRangeoo $
(oo$ %
newpp 
	SlaTargetpp 
{pp 
SlaPolicyIdpp '
=pp( )
policypp* 0
.pp0 1
Idpp1 3
,pp3 4

PriorityIdpp5 ?
=pp@ A
criticalppB J
.ppJ K
IdppK M
,ppM N 
FirstResponseMinutesppO c
=ppd e
$numppf h
,pph i
ResolutionMinutesppj {
=pp| }
$num	pp~ Å
}
ppÇ É
,
ppÉ Ñ
newqq 
	SlaTargetqq 
{qq 
SlaPolicyIdqq '
=qq( )
policyqq* 0
.qq0 1
Idqq1 3
,qq3 4

PriorityIdqq5 ?
=qq@ A
highqqB F
.qqF G
IdqqG I
,qqI J 
FirstResponseMinutesqqK _
=qq` a
$numqqb e
,qqe f
ResolutionMinutesqqg x
=qqy z
$numqq{ 
}
qqÄ Å
,
qqÅ Ç
newrr 
	SlaTargetrr 
{rr 
SlaPolicyIdrr '
=rr( )
policyrr* 0
.rr0 1
Idrr1 3
,rr3 4

PriorityIdrr5 ?
=rr@ A
mediumrrB H
.rrH I
IdrrI K
,rrK L 
FirstResponseMinutesrrM a
=rrb c
$numrrd g
,rrg h
ResolutionMinutesrri z
=rr{ |
$num	rr} Å
}
rrÇ É
,
rrÉ Ñ
newss 
	SlaTargetss 
{ss 
SlaPolicyIdss '
=ss( )
policyss* 0
.ss0 1
Idss1 3
,ss3 4

PriorityIdss5 ?
=ss@ A
lowssB E
.ssE F
IdssF H
,ssH I 
FirstResponseMinutesssJ ^
=ss_ `
$numssa e
,sse f
ResolutionMinutesssg x
=ssy z
$numss{ 
}
ssÄ Å
)tt 	
;tt	 

forvv 
(vv 
intvv 
ivv 
=vv 
$numvv 
;vv 
ivv 
<=vv 
$numvv 
;vv 
ivv  !
++vv! #
)vv# $
{ww 	
_contextxx 
.xx 
BusinessHoursxx "
.xx" #
Addxx# &
(xx& '
newxx' *
BusinessHourxx+ 7
{yy 
	DayOfWeekzz 
=zz 
(zz 
	DayOfWeekzz &
)zz& '
izz' (
,zz( )
	StartTime{{ 
={{ 
new{{ 
TimeSpan{{  (
({{( )
$num{{) *
,{{* +
$num{{, -
,{{- .
$num{{/ 0
){{0 1
,{{1 2
EndTime|| 
=|| 
new|| 
TimeSpan|| &
(||& '
$num||' )
,||) *
$num||+ ,
,||, -
$num||. /
)||/ 0
,||0 1
IsWorkingDay}} 
=}} 
true}} #
}~~ 
)~~ 
;~~ 
} 	
_context
ÄÄ 
.
ÄÄ 
BusinessHours
ÄÄ 
.
ÄÄ 
Add
ÄÄ "
(
ÄÄ" #
new
ÄÄ# &
BusinessHour
ÄÄ' 3
{
ÄÄ4 5
	DayOfWeek
ÄÄ6 ?
=
ÄÄ@ A
	DayOfWeek
ÄÄB K
.
ÄÄK L
Saturday
ÄÄL T
,
ÄÄT U
IsWorkingDay
ÄÄV b
=
ÄÄc d
false
ÄÄe j
}
ÄÄk l
)
ÄÄl m
;
ÄÄm n
_context
ÅÅ 
.
ÅÅ 
BusinessHours
ÅÅ 
.
ÅÅ 
Add
ÅÅ "
(
ÅÅ" #
new
ÅÅ# &
BusinessHour
ÅÅ' 3
{
ÅÅ4 5
	DayOfWeek
ÅÅ6 ?
=
ÅÅ@ A
	DayOfWeek
ÅÅB K
.
ÅÅK L
Sunday
ÅÅL R
,
ÅÅR S
IsWorkingDay
ÅÅT `
=
ÅÅa b
false
ÅÅc h
}
ÅÅi j
)
ÅÅj k
;
ÅÅk l
await
ÉÉ 
_context
ÉÉ 
.
ÉÉ 
SaveChangesAsync
ÉÉ '
(
ÉÉ' (
)
ÉÉ( )
;
ÉÉ) *
}
ÑÑ 
}ÖÖ 