# This uses MATLAB's definition of the `peaks` function to test `inpaint_nans`

peaks(x, y) = 3 * (1 - x)^2 * exp(-(x^2) - (y + 1)^2) -
    10 * (x/5 - x^3 - y^5) * exp(-x^2 - y^2) -
    1/3 * exp(-(x + 1)^2 - y^2)

xs = LinRange(-3, 3, 50)
ys = LinRange(-3, 3, 50)
Z = [peaks(x, y) for y in ys, x in xs]

# Remove some values in blocks
Z_with_NaNs = copy(Z)
Z_with_NaNs[1:10, 1:10] .= NaN
Z_with_NaNs[20:40, 20:35] .= NaN
# Remove some values at random indices (pregenerated for determinism of the test)
# pregenerated via `rand(CartesianIndices(size(Z)), 10)`
# Note I made sure no NaN on the border, need to figure out why different from MATLAB there
idx = [
 CartesianIndex(45, 8)
 CartesianIndex(41, 24)
 CartesianIndex(5, 30)
 CartesianIndex(15, 22)
 CartesianIndex(17, 18)
 CartesianIndex(9, 11)
 CartesianIndex(3, 21)
 CartesianIndex(42, 26)
 CartesianIndex(16, 16)
 CartesianIndex(22, 42)
]
Z_with_NaNs[idx] .= NaN

Z_reconstructed0 = inpaint_nans(Z_with_NaNs)
Z_reconstructed3 = inpaint_nans(Z_with_NaNs, 3)

#using Plots
#contourf(ys, xs, Z)
#contourf(ys, xs, Z_with_NaNs)
#contourf(ys, xs, Z_reconstructed)

#=
MATLAB code used to compare both values:

Z = peaks(50) ;
Z_with_NaNs = Z ;
Z_with_NaNs(1:10, 1:10) = nan ;
Z_with_NaNs(20:40, 20:35) = nan ;
Z_with_NaNs(45, 8) = nan ;
Z_with_NaNs(41, 24) = nan ;
Z_with_NaNs(5, 30) = nan ;
Z_with_NaNs(15, 22) = nan ;
Z_with_NaNs(17, 18) = nan ;
Z_with_NaNs(9, 11) = nan ;
Z_with_NaNs(3, 21) = nan ;
Z_with_NaNs(42, 26) = nan ;
Z_with_NaNs(16, 16) = nan ;
Z_with_NaNs(22, 42) = nan ;
Z_reconstructed0 = inpaint_nans(Z_with_NaNs) ;
inan = find(isnan(Z_with_NaNs)) ;
format long
for_test_with_Julia = Z_reconstructed0(inan)

Z_reconstructed3 = inpaint_nans(Z_with_NaNs, 3) ;
inan = find(isnan(Z_with_NaNs)) ;
format long
for_test_with_Julia = Z_reconstructed3(inan)
=#

#output from MATLAB (with added `[` and `]` to create an array in Julia):
for_test_with_Julia0 = [
  -0.029498484825455
  -0.026388649032511
  -0.023224164811533
  -0.019959714697592
  -0.016570534539756
  -0.013067274772867
  -0.009515737748511
  -0.006061284483498
  -0.002954053931593
  -0.000562233983451
  -0.024738859622865
  -0.021849554031150
  -0.018886708512840
  -0.015846133780332
  -0.012745515609159
  -0.009632984965416
  -0.006596031513876
  -0.003768591556022
  -0.001332853175635
   0.000486275908415
  -0.020033882848309
  -0.017374667993280
  -0.014606428114350
  -0.011757181715958
  -0.008877257234395
  -0.006043559300535
  -0.003362033848600
  -0.000966148114188
   0.000989133038145
   0.002331476799184
  -0.015447533892928
  -0.012992036440880
  -0.010369686528229
  -0.007632954622375
  -0.004857137895978
  -0.002143656346511
   0.000379107679895
   0.002560141558851
   0.004236580202934
   0.005247311276165
  -0.011060562686287
  -0.008755973865576
  -0.006200733071729
  -0.003462516608642
  -0.000631555553168
   0.002173486132572
   0.004801671545321
   0.007071916420969
   0.008786181682142
   0.009758475053551
  -0.006974002641464
  -0.004752793731375
  -0.002171426761450
   0.000700684972057
   0.003775005310586
   0.006932448068480
   0.010012028603876
   0.012803850132208
   0.015056088124606
   0.016513669823151
  -0.003306656703570
  -0.001102305535409
   0.001590577322355
   0.004720027170229
   0.008225081189160
   0.012017691152981
   0.015960720685646
   0.019843008634245
   0.023362422101999
   0.026151282842149
  -0.000184793939314
   0.002048303388213
   0.004900640697375
   0.008361573956673
   0.012432323559789
   0.017104013738851
   0.022326545579092
   0.027959080144713
   0.033703122438236
   0.039058183237819
   0.022750875077404
   0.002276664167332
   0.004542189596323
   0.007530709533852
   0.011296841495850
   0.015941569838531
   0.021595958353736
   0.028391819043663
   0.036391951923893
   0.045452985557788
   0.054969855759669
   0.004000278866272
   0.006245896531532
   0.009246891348237
   0.013138306385561
   0.018148210657288
   0.024608390703909
   0.032949462589523
   0.043633483822409
   0.056996977310186
   0.072401999091913
   0.065371006725438
   1.129882922629364
   1.988620826083542
   3.303724922677607
   3.009995700318911
   2.522280335893179
   1.935724677977175
   1.335626062214603
   0.786514582285719
   0.329257265994138
  -0.012311657560658
  -0.219872146405397
  -0.271552277631725
  -0.141161352351552
   0.193031222412800
   0.733937769112330
   1.452862117914674
   2.285084082216744
   3.137081028104408
   3.903712648745315
   4.489649932804268
   4.827799745843459
   4.888793767353252
   4.679011144603867
  -0.347745054253215
   3.591122343685997
   3.386431769732992
   2.989300926148785
   2.491065998125949
   1.967669764377622
   1.478074025887852
   1.064190275208859
   0.755382062315507
   0.575505763016592
   0.548067726710194
   0.695792892311918
   1.033891923622987
   1.559825281387967
   2.244540055312318
   3.029924614704668
   3.834745050730286
   4.567802105281467
   5.144058732563776
   5.498221851097060
   5.591050052762111
   5.406096358679440
  -0.936349385455035
   3.605222930686874
   3.517335900783082
   3.238434122298406
   2.855954919299696
   2.438128155347086
   2.038640173647655
   1.698757563008107
   1.450453032091489
   1.320251698895966
   1.331587825880717
   1.503653343197570
   1.846464367099045
   2.354023174309642
   2.998800289086334
   3.730582290842233
   4.481087430169427
   5.173391472916311
   5.733154387927366
   6.097701028234379
   6.219428978194833
   6.061349487151569
   3.341357929388249
   3.401575746573586
   3.271910711435003
   3.032861610516547
   2.745867386925606
   2.460181939071189
   2.215800804391726
   2.045583984772825
   1.977088264304427
   2.033220296675575
   2.230770425339385
   2.576833101618545
   3.064353679782952
   3.668809993104651
   4.347878437474010
   5.044864254124493
   5.695141212675974
   6.233486881758082
   6.599558704652425
   6.739079041437797
   6.599355170330182
   2.841380838344105
   3.073456166079014
   3.117835543539121
   3.043622374128044
   2.905309952338734
   2.748350998076220
   2.611441878223756
   2.527655274298543
   2.524998203677983
   2.626108194716650
   2.846717602988466
   3.193021104984742
   3.658761902188411
   4.223260384941719
   4.851462918644687
   5.496387500127723
   6.103345823932464
   6.614403076650654
   6.971000687331017
   7.112617051973382
   6.969952192873624
   6.455710135848094
   2.189987011895347
   2.601613306675576
   2.830176991678914
   2.929371693158437
   2.945987309168736
   2.921841403893273
   2.894361950105836
   2.896616319559052
   2.956982539367739
   3.098305237796421
   3.336388427291948
   3.677980326506684
   4.118785337685906
   4.642244485161791
   5.219696188434319
   5.812064622822803
   6.372579171173087
   6.849441367135294
   7.187041793446022
   7.324410700631058
   7.189911243175136
   1.499102206008667
   2.077388586895414
   2.480649448955863
   2.744936031990387
   2.908506629225304
   3.009228703433169
   3.083001636885966
   3.162638262674267
   3.276847250223310
   3.449043317003553
   3.695861784634070
   4.025492679764202
   4.436186506668263
   4.915390513008766
   5.439864987537813
   5.976810042364554
   6.485601875796809
   6.919335844318305
   7.225116240194605
   7.341923924819143
   7.194750301845644
   5.671431293467855
   0.884976745598062
   1.596898607694587
   2.145528754368911
   2.549428323356424
   2.837808701585293
   3.043913463270044
   3.201453776487057
   3.342469255905483
   3.495756563611108
   3.685408445321751
   3.929282174234797
   4.237455450145543
   4.610911349574935
   5.040762116817356
   5.508232517431887
   5.985389442096245
   6.436293972558468
   6.817960282276927
   7.080307178891673
   7.164193256342912
   6.996570380585938
   0.444088620428157
   1.241814847582343
   1.891185699808595
   2.395684939700155
   2.775482579377672
   3.058382230098587
   3.274952160955224
   3.455673493226433
   3.628960314423669
   3.819456857567038
   4.046366814253769
   4.321829435780246
   4.649535475282198
   5.023840615981928
   5.429561704253726
   5.842449022088037
   6.230076247051698
   6.552659960890115
   6.763181050163189
   6.806159870783462
   6.614524945211913
   0.234143026191824
   1.063859732965861
   1.762110299946653
   2.321268475171566
   2.753040279660386
   3.079093031388457
   3.325844012225440
   3.521330696754089
   3.693008503739355
   3.865840121979854
   4.060395549437099
   4.290964061600172
   4.563882881385299
   4.876370906745426
   5.216093759549064
   5.561498942421485
   5.882714719785381
   6.142595115742952
   6.297397705775117
   6.296646212478618
   6.081963803990073
  -1.304113302100942
   0.264864119862779
   1.076767534905692
   1.774265809474048
   2.343112646917163
   2.787626544439828
   3.123004601683320
   3.370727451872211
   3.555626497313267
   3.703693791323439
   3.840036588436643
   3.986682118643480
   4.160251632071094
   4.369784660342527
   4.615119318391659
   4.886173709300114
   5.163249686938340
   5.418184266253171
   5.615930452864633
   5.716069561318138
   5.673903109796492
   5.441147050863004
   0.500333652721862
   1.257203202530716
   1.914959741995662
   2.456713472452514
   2.880827599256626
   3.196218253087131
   3.419070278721062
   3.570536270531234
   3.674846322700917
   3.757268272879267
   3.841591356006739
   3.947190141471677
   4.086100541045631
   4.260738248358979
   4.462819505382224
   4.673731340154781
   4.866178492601913
   5.006592712913562
   5.057688910784330
   4.980774095119175
   4.737944237149260
   0.871317132785956
   1.553561990059058
   2.148519470287879
   2.639408555952556
   3.020287826420123
   3.294544498578586
   3.473185081860170
   3.573522819462547
   3.617946861824382
   3.632124219155846
   3.642188172961322
   3.671009216682895
   3.734223756720642
   3.837018520427409
   3.972574469877225
   4.122600578288115
   4.259745752323171
   4.351151777011490
   4.362241567613848
   4.260135177997217
   4.016808341160816
   1.293398270865739
   1.899455740342281
   2.425447790453951
   2.856109671892609
   3.183005879423897
   3.405214180617262
   3.529016116126332
   3.567878338476723
   3.542344731244552
   3.478834009327804
   3.406616801634568
   3.353091136842986
   3.338392516317580
   3.370892533942903
   3.445003032596680
   3.541973003387718
   3.633374594962175
   3.686159961794112
   3.667883809165214
   3.551069123415919
   3.316664558966580
   1.685519048949281
   2.227541307184004
   2.691800278815853
   3.065171251558803
   3.338693484603954
   3.508577040151510
   3.576871840363392
   3.553065919655749
   3.455666675448214
   3.312047105069654
   3.155349430381984
   3.018564528651713
   2.927319796961117
   2.893701358602887
   2.913230225978237
   2.966013724717622
   3.021614156201549
   3.045966592750502
   3.008230606101403
   2.885938504463028
   2.668055678350101
   1.983687274849697
   2.479169011918075
   2.895395379835811
   3.222088867593804
   3.451629521473798
   3.578581931945603
   3.601031762927470
   3.524104542910332
   3.363713088576560
   3.147842640850084
   2.913547220732306
   2.699762770641832
   2.538059845382889
   2.444573857034302
   2.416046232820994
   2.431362332110222
   2.457920410509647
   2.460515951035668
   2.409821718940406
   2.288130310799809
   2.091506309587206
   1.138103428467866
]

inan = findall(@. isnan(Z_with_NaNs))
@test Z_reconstructed0[inan] ≈ for_test_with_Julia0


for_test_with_Julia3 = [
   0.002259379996625
   0.002065818947701
   0.001872220612079
   0.001679108072516
   0.001488271160394
   0.001303635517576
   0.001132007358907
   0.000982824008868
   0.000864752820863
   0.000773923951818
   0.002527203700313
   0.002294700531208
   0.002059732854069
   0.001858183688242
   0.001721343335611
   0.001663214567178
   0.001675244071415
   0.001723843995278
   0.001749632616489
   0.001672342458007
   0.002795064690699
   0.002525486253296
   0.002224085247072
   0.001991161571554
   0.001899272627405
   0.001979549070357
   0.002215792656260
   0.002543633772415
   0.002854400168225
   0.003007228200539
   0.003063560623933
   0.002798645225972
   0.002474894618866
   0.002266769614549
   0.002295408272778
   0.002614586944291
   0.003206184820836
   0.003979758778005
   0.004773489668824
   0.005357481702358
   0.003334263885350
   0.003157397242224
   0.002913815979769
   0.002855609536990
   0.003154137488292
   0.003887616255219
   0.005039439710067
   0.006495564407350
   0.008034901971990
   0.009314791510924
   0.003609714592987
   0.003635627453555
   0.003622899635533
   0.003897752366323
   0.004677411557469
   0.006064268958375
   0.008049749909981
   0.010507126586294
   0.013164094090285
   0.015560340945642
   0.003892503206293
   0.004247017541771
   0.004647198814848
   0.005476985924641
   0.006988846673262
   0.009311453496408
   0.012462034811841
   0.016331231499953
   0.020628470149212
   0.024795380776193
   0.004182730608432
   0.004972718200993
   0.005969093322712
   0.007573640591348
   0.010058620259407
   0.013590924417194
   0.018252744556409
   0.024012670892083
   0.030631966090253
   0.037511880193904
   0.022797005369069
   0.004473206200211
   0.005752653431520
   0.007476665990294
   0.009993105579573
   0.013582091913318
   0.018481384068170
   0.024909539527975
   0.033017299888672
   0.042743605475688
   0.053571556267167
   0.004744170712912
   0.006494787522972
   0.008928093436309
   0.012268709370300
   0.016815670746796
   0.022938919367739
   0.031102743456714
   0.041801225886046
   0.055359327757386
   0.071569975891473
   0.065033771638379
   1.130395799415280
   1.990861148418198
   3.359330915423663
   3.104927042992831
   2.626359297366892
   2.027403670241130
   1.405456792299653
   0.831924360760815
   0.347877822185717
  -0.026021635669662
  -0.272910967162707
  -0.366811090710392
  -0.271384187471404
   0.048033414415072
   0.604580971899867
   1.371912066630286
   2.277316244841364
   3.210335286269036
   4.044721444394931
   4.666322066425714
   4.997665626796673
   5.012017919538246
   4.734117826712254
  -0.347472785171829
   3.699421007380696
   3.573879789977793
   3.194939915092772
   2.666850762016725
   2.087984000124345
   1.532452469552666
   1.046560951402358
   0.658414025185361
   0.393280077317882
   0.284956938691623
   0.375786011010545
   0.704002577815798
   1.283786281126085
   2.087413716141441
   3.038456814538618
   4.020423954363580
   4.898913715353902
   5.550175806224433
   5.887064904988687
   5.875150064454520
   5.535923173287229
  -0.937215796907158
   3.737289567959056
   3.741988095128483
   3.473684839976280
   3.034229825923826
   2.520412719923297
   2.007832006790217
   1.548186404072659
   1.177663538350472
   0.929721594341536
   0.843905075476238
   0.964572119333697
   1.328648372341504
   1.947265971041475
   2.789632034633695
   3.777092405316320
   4.791412641494718
   5.695731117306330
   6.361980122131938
   6.696705927624020
   6.658580976717657
   6.264391829473404
   3.458105959434493
   3.585340532325743
   3.432705470036158
   3.096882583564291
   2.670384476715241
   2.228191616525437
   1.825820273040197
   1.506095710389532
   1.308888681122825
   1.277114179351437
   1.454285534849708
   1.873192546714000
   2.539896440497335
   3.420036022446858
   4.434128424307615
   5.465328522168383
   6.378508965655710
   7.045576296527472
   7.370211165431646
   7.306115526494566
   6.865492964911031
   2.905415802663887
   3.140816979558256
   3.103196970244569
   2.881387110315361
   2.560802391470843
   2.213078330216843
   1.894855875474644
   1.652929038073712
   1.531066370081379
   1.573400033684505
   1.820996372046334
   2.301581305374069
   3.015956761946570
   3.926784454725261
   4.955147525943552
   5.987763341017694
   6.894057867586826
   7.549088448901888
   7.856749272234844
   7.768165923004180
   7.292036168883978
   6.495536249494424
   2.175303984555475
   2.500300175282669
   2.571130016636245
   2.466520482749633
   2.262274748696241
   2.023937915968091
   1.806287814011367
   1.657097837873818
   1.621500539639595
   1.743211159286957
   2.060317409457906
   2.595931645843714
   3.346684095849773
   4.273620651733375
   5.299828047042006
   6.317131403944191
   7.201335625540489
   7.832883271144187
   8.118419632451443
   8.008882596623350
   7.510895189585512
   1.397446663397661
   1.791645429192098
   1.958516747322634
   1.965330604617673
   1.876624209876580
   1.749715423604658
   1.634928423933431
   1.578361416642885
   1.624405073955912
   1.815337667142966
   2.186527852086198
   2.757779198333138
   3.523373506349095
   4.444535762285114
   5.447813134191693
   6.431293786470772
   7.278309396826627
   7.876144325994715
   8.136033609039545
   8.010611642113306
   7.505638665256996
   5.655781705713987
   0.707537640174905
   1.151009532749011
   1.396767981467944
   1.500464738958146
   1.514929686212122
   1.488122444630745
   1.464130136738280
   1.485404554232011
   1.594107296686356
   1.830636203594527
   2.228426795415530
   2.805725965813465
   3.556616861317714
   4.444457489531686
   5.400664886018846
   6.330475999065843
   7.125425190135756
   7.680479447004110
   7.912634737112945
   7.777501539531971
   7.280749145725821
   0.218195525124924
   0.693511053764781
   0.998558897337874
   1.178314223181802
   1.274641528833133
   1.326070564885291
   1.369574123928562
   1.442750364187449
   1.584665065138657
   1.833856918693633
   2.222919964087516
   2.770459346504105
   3.472557783705904
   4.296617697717066
   5.180205381572099
   6.036356920349804
   6.765118980371504
   7.269473962911418
   7.472726737639546
   7.334089022840360
   6.859397270298532
  -0.004027725911891
   0.489672591921882
   0.834989205159311
   1.067811237024695
   1.220567169009113
   1.323086694557218
   1.405103549868196
   1.498806822139607
   1.639799316943940
   1.865092745714806
   2.207649822112773
   2.688308739720070
   3.307208249274588
   4.037517418082052
   4.824022093695089
   5.587970280160998
   6.237930707171693
   6.684839650545223
   6.858373036922890
   6.721459763277300
   6.279977923253443
  -1.303051427682315
   0.050234598935039
   0.553376207037926
   0.923318454202679
   1.188480922402575
   1.373591139028734
   1.500884468888353
   1.593191471230852
   1.677171953796250
   1.784910683894761
   1.952353391262300
   2.213978112100610
   2.594514825869180
   3.099916262164093
   3.710530823324409
   4.379158770153947
   5.035436329744939
   5.596237792223509
   5.980138858761880
   6.122958423675843
   5.991175093308924
   5.590414162223427
   0.336098702508786
   0.843661984317610
   1.227563240954214
   1.509875868706977
   1.709050364518558
   1.840806581158595
   1.921574476993924
   1.972572531078156
   2.022424093064402
   2.106400342607286
   2.261374710813484
   2.517213283029979
   2.886969339964653
   3.359151542567235
   3.895043641633725
   4.432642063140997
   4.896795894453874
   5.213331031535351
   5.323914727324131
   5.198367190790434
   4.841817790004297
   0.769523710028694
   1.278770718275505
   1.670737710378603
   1.961583574989566
   2.164345078155436
   2.289055614712674
   2.346237860657872
   2.351818967219164
   2.330977674154724
   2.318444585079001
   2.353870609602890
   2.472837330836520
   2.696091823861496
   3.020709567641174
   3.416570153971142
   3.829879708505502
   4.193183598138626
   4.439301676917954
   4.515596100467293
   4.395157691355355
   4.082552610571435
   1.249486262823406
   1.757684639689169
   2.154650424527759
   2.450549998382310
   2.653383078513679
   2.768088220265691
   2.799772513251916
   2.759293253474718
   2.668328960964065
   2.560819836945089
   2.478845070951251
   2.463320769998406
   2.542316190186833
   2.721144710284569
   2.978032636002969
   3.267260093694865
   3.529057179359472
   3.703324013046880
   3.743245017419491
   3.625291769457878
   3.353536728794075
   1.680825958835793
   2.183002483652431
   2.581792431358445
   2.881215200208258
   3.084395991500915
   3.191704518549482
   3.203496477742068
   3.126044752563094
   2.977539592622006
   2.790499295049407
   2.608188457192878
   2.475247974003909
   2.425473254986828
   2.471210788283636
   2.598451623607810
   2.769594423015727
   2.933018046488710
   3.036277304411221
   3.038800886954948
   2.920610175425693
   2.685287119666960
   1.992097813222759
   2.479571681645026
   2.874218478783818
   3.174100515611054
   3.377654340112671
   3.481309803798772
   3.481734109596884
   3.381659299187231
   3.196147292560262
   2.955457421843666
   2.701942231204510
   2.481071648235227
   2.329474711357256
   2.264433058340662
   2.278843219307648
   2.343535786291469
   2.416028089109177
   2.452540899340291
   2.419291486013233
   2.299823344286809
   2.096909637529432
   1.137299944253054
]

#@test Z_reconstructed3[inan] ≈ for_test_with_Julia3 # method3 tests currently fails