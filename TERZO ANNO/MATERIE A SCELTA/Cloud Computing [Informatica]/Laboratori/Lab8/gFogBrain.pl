:- discontiguous pue/2.
:- discontiguous energyProfile/3.
:- discontiguous totHW/2.
:- discontiguous node/4.
:- discontiguous energySourceMix/2.
:- discontiguous cost/2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% APPLICATION %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% application(AppId, [ServiceIds]).
application(lightsApp, [mlOptimiser, lightsDriver]).

% service(ServiceId, [SoftwareRequirements], HardwareRequirements, IoTRequirements).
service(mlOptimiser, [mySQL, python, ubuntu], 16, [gpu]).
service(lightsDriver, [ubuntu], 2, [videocamera, lightshub]).

% s2s(ServiceId1, ServiceId2, MaxLatency, MinBandwidth)
s2s(mlOptimiser, lightsDriver, 50, 0.5).
s2s(lightsDriver, mlOptimiser, 20, 16).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% INFRASTRUCTURE %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% node(NodeId, SoftwareCapabilities, FreeHW, TotHW, IoTCapabilities).
% totHW/2 is the total hardware, needed to compute load and energy consumption
% energyProfile/4 specifies the power source of the node and the possibly non-linear 
%                 function to compute consumption E based on load L
% pue/2 is the pue associated to a node, server, datacentre, etc.
node(privateCloud,[ubuntu, mySQL, python], 128, [gpu]).
    cost(privateCloud,0.0016).
    totHW(privateCloud,150).
    energyProfile(privateCloud,L,E) :- E is 0.1 + 0.01*log(L).
    pue(privateCloud,1.9).
    energySourceMix(privateCloud,[(0.3,solar), (0.7,coal)]).
node(accesspoint,[ubuntu, mySQL, python], 4, [lightshub, videocamera]).
    cost(accesspoint,0.003).
    totHW(accesspoint,6).
    energyProfile(accesspoint,L,E) :- E is 0.05 + 0.03*log(L).
    pue(accesspoint,1.5).
    energySourceMix(accesspoint,[(0.1,gas),(0.8,coal),(0.1,onshorewind)]).
node(edgenode,[ubuntu, python], 8, [gpu, lightshub, videocamera]).
    cost(edgenode,0.005).
    totHW(edgenode,12).
    energyProfile(edgenode,L,E) :- L =< 50 -> E is 0.08; E is 0.1.
    pue(edgenode,1.2).
    energySourceMix(edgenode,[(0.5,coal), (0.5,solar)]).

% emissions in CO2 kg/kWh
emissions(gas, 0.610).
emissions(coal, 1.1).
emissions(onshorewind, 0.0097).
emissions(offshorewind, 0.0165).
emissions(solar, 0.05). % https://solarbay.com.au/portfolio-item/how-much-emissions-does-solar-power-prevent/


% link(NodeId1, NodeId2, FeaturedLatency, FeaturedBandwidth).
link(privateCloud, accesspoint, 5, 1000).
link(accesspoint, privateCloud, 5, 1000).
link(accesspoint, edgenode, 5, 20).
link(edgenode, accesspoint, 5, 20).
link(privateCloud, edgenode, 15, 18).
link(edgenode, privateCloud, 15, 18).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% PLACER %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

placements(A,Placements) :-
   findall((C,Cost,E,P), (gFogBrain(A,P,E,C), hourlyCost(P,Cost)), Ps),
   sort(Ps,Placements).

hourlyCost([on(S,N)|P],NewCost) :- 
    hourlyCost(P,OldCost),
    service(S,_,HW,_), cost(N,C),
    NewCost is OldCost + C * HW.
hourlyCost([],0).

gFogBrain(A,P,Energy,Carbon) :- 
    application(A,Services), placement(Services,[],([],[]),P),
    allocatedResources(P,Alloc),
    footprint(P,Alloc,Energy,Carbon).

footprint(P,(AllocHW,AllocBW),Energy,Carbon) :-
    deploymentNodes(P,Nodes), 
    hardwareFootprint(Nodes,P,AllocHW,0,HWEnergy,0,HWCarbon),
    networkFootprint(AllocBW,BWEnergy,BWCarbon), 
    Energy is HWEnergy + BWEnergy,
    Carbon is HWCarbon + BWCarbon.

hardwareFootprint([(N,HW)|Ns],P,AllocHW,ECOld,ECNew,OldCarbon,NewCarbon) :-
    totHW(N,TotHW), pue(N,PUE), energySourceMix(N,Sources),
    OldL is 100 * (TotHW - HW) / TotHW, energyProfile(N,OldL,OldE), 
    findall(H,member((N,H),AllocHW),HWs), sum_list(HWs,PHW),
    NewL is 100 * (TotHW - HW + PHW) / TotHW, energyProfile(N,NewL,NewE), 
    EDiff is  (NewE - OldE) * PUE, emissions(Sources,EDiff,OldCarbon,CarbonTmp),
    ETmp is ECOld + EDiff, 
    hardwareFootprint(Ns,P,AllocHW,ETmp,ECNew,CarbonTmp,NewCarbon).
hardwareFootprint([],_,_,E,E,M,M).

emissions([(Prob,Src)|Srcs],Energy,OldCarbon,NewCarbon) :-
    emissions(Src,MU), 
    TmpCarbon is OldCarbon + Prob * MU * Energy,
    emissions(Srcs,Energy,TmpCarbon,NewCarbon).
emissions([],_,E,E).

networkFootprint(AllocBW,BWEnergy,BWCarbon) :-
    findall(BW, member((_,_,BW),AllocBW), Flows), sum_list(Flows,TotBW),
    kWhPerMB(K), BWEnergy is 450 * K * TotBW, 
    averageGCI(A), BWCarbon is A * BWEnergy.

deploymentNodes(P,Nodes) :-     
    findall((N,FreeHW), distinct( (member(on(_,N),P), node(N,_,FreeHW,_)) ), Nodes).


placement(A,P) :- 
    application(A,Services), placement(Services,[],([],[]),P),
    allocatedResources(P,Alloc), assert(deployment(A,P,Alloc)). 

placement([S|Ss],P,(AllocHW,AllocBW),Placement) :-
    nodeOk(S,N,P,AllocHW), linksOk(S,N,P,AllocBW), 
    placement(Ss,[on(S,N)|P],(AllocHW,AllocBW),Placement).
placement([],P,_,P).

nodeOk(S,N,P,AllocHW) :-
    service(S,SWReqs,HWReqs,IoTReqs),
    node(N,SWCaps,HWCaps,IoTCaps),
    swReqsOk(SWReqs,SWCaps),
    thingReqsOk(IoTReqs,IoTCaps),
    hwOk(N,HWCaps,HWReqs,P,AllocHW).

swReqsOk(SWReqs, SWCaps) :- subset(SWReqs, SWCaps).

thingReqsOk(TReqs, TCaps) :- subset(TReqs, TCaps).

hwOk(N,HWCaps,HWReqs,P,AllocHW) :-
    findall(HW,member((N,HW),AllocHW),HWs), sum_list(HWs, CurrAllocHW),
    findall(HW, (member(on(S1,N),P), service(S1,_,HW,_)), OkHWs), sum_list(OkHWs, NewAllocHW),  
    hwTh(T), HWCaps >= HWReqs + T - CurrAllocHW + NewAllocHW.

linksOk(S,N,P,AllocBW) :-
    findall((N1N2,ReqLat), distinct(relevant(S,N,P,N1N2,ReqLat)), N2Ns), latencyOk(N2Ns),
    findall(N1N2, distinct(member((N1N2,ReqLat),N2Ns)), N1N2s), bwOk(N1N2s, AllocBW, [on(S,N)|P]). 

latencyOk([((N1,N2),ReqLat)|N2Ns]) :- 
    link(N1,N2,FeatLat,_), FeatLat =< ReqLat, latencyOk(N2Ns).
latencyOk([]).

bwOk([(N1,N2)|N2Ns],AllocBW,P) :-
    link(N1,N2,_,FeatBW),
    findall(BW, member((N1,N2,BW),AllocBW), BWs), sum_list(BWs, CurrAllocBW), 
    findall(BW, s2sOnN1N2((N1,N2), P, BW), OkBWs), sum_list(OkBWs, OkAllocBw), 
    bwTh(T), FeatBW  >=  OkAllocBw - CurrAllocBW + T, 
    bwOk(N2Ns,AllocBW,P).
bwOk([],_,_).

relevant(S,N,P,(N,N2),L) :- s2s(S,S2,L,_), member(on(S2,N2),P), dif(N,N2).
relevant(S,N,P,(N1,N),L) :- s2s(S1,S,L,_), member(on(S1,N1),P), dif(N1,N).

s2sOnN1N2((N1,N2),P,B) :- s2s(S3,S4,_,B), member(on(S3,N1),P), member(on(S4,N2),P).

allocatedResources(P,(AllocHW,AllocBW)) :- 
    findall((N,HW), (member(on(S,N),P), service(S,_,HW,_)), AllocHW),
    findall((N1,N2,BW), n2n(P,N1,N2,BW), AllocBW).
n2n(P,N1,N2,ReqBW) :- s2s(S1,S2,_,ReqBW), member(on(S1,N1),P), member(on(S2,N2),P), dif(N1,N2).

hwTh(0.2). bwTh(0.2).

averageGCI(0.475). % 0.475 kgCO2/kWh, https://www.iea.org/reports/global-energy-co2-status-report-2019/emissions
kWhPerMB(0.00008). % https://docs.microsoft.com/it-it/learn/modules/sustainable-software-engineering-overview/8-network-efficiency 
