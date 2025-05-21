% Author: Dalton H Bermudez (UW Madison)
% Accessment of beam profile symmetry of real clinical beam profiles,
% comparing proposed correlative symmetric index (CSI) with standard Point
% wise Quotient and Area based metrics
X1 = [-15
-14.8
-14.6
-14.4
-14.2
-14
-13.8
-13.6
-13.4
-13.2
-13
-12.8
-12.6
-12.4
-12.2
-12
-11.8
-11.6
-11.4
-11.2
-11
-10.8
-10.6
-10.4
-10.2
-10
-9.8
-9.6
-9.4
-9.2
-9
-8.8
-8.6
-8.4
-8.2
-8
-7.8
-7.6
-7.4
-7.2
-7
-6.8
-6.6
-6.4
-6.2
-6
-5.8
-5.6
-5.4
-5.2
-5
-4.8
-4.6
-4.4
-4.2
-4
-3.8
-3.6
-3.4
-3.2
-3
-2.8
-2.6
-2.4
-2.2
-2
-1.8
-1.6
-1.4
-1.2
-1
-0.8
-0.6
-0.4
-0.2
0
0.2
0.4
0.6
0.8
1
1.2
1.4
1.6
1.8
2
2.2
2.4
2.6
2.8
3
3.2
3.4
3.6
3.8
4
4.2
4.4
4.6
4.8
5
5.2
5.4
5.6
5.8
6
6.2
6.4
6.6
6.8
7
7.2
7.4
7.6
7.8
8
8.2
8.4
8.6
8.8
9
9.2
9.4
9.6
9.8
10
10.2
10.4
10.6
10.8
11
11.2
11.4
11.6
11.8
12
12.2
12.4
12.6
12.8
13
13.2
13.4
13.6
13.8
14
14.2
14.4
14.6
14.8
15];
X2 = [-16
-15.8
-15.6
-15.4
-15.2
-15
-14.8
-14.6
-14.4
-14.2
-14
-13.8
-13.6
-13.4
-13.2
-13
-12.8
-12.6
-12.4
-12.2
-12
-11.8
-11.6
-11.4
-11.2
-11
-10.8
-10.6
-10.4
-10.2
-10
-9.8
-9.6
-9.4
-9.2
-9
-8.8
-8.6
-8.4
-8.2
-8
-7.8
-7.6
-7.4
-7.2
-7
-6.8
-6.6
-6.4
-6.2
-6
-5.8
-5.6
-5.4
-5.2
-5
-4.8
-4.6
-4.4
-4.2
-4
-3.8
-3.6
-3.4
-3.2
-3
-2.8
-2.6
-2.4
-2.2
-2
-1.8
-1.6
-1.4
-1.2
-1
-0.8
-0.6
-0.4
-0.2
0
0.2
0.4
0.6
0.8
1
1.2
1.4
1.6
1.8
2
2.2
2.4
2.6
2.8
3
3.2
3.4
3.6
3.8
4
4.2
4.4
4.6
4.8
5
5.2
5.4
5.6
5.8
6
6.2
6.4
6.6
6.8
7
7.2
7.4
7.6
7.8
8
8.2
8.4
8.6
8.8
9
9.2
9.4
9.6
9.8
10
10.2
10.4
10.6
10.8
11
11.2
11.4
11.6
11.8
12
12.2
12.4
12.6
12.8
13
13.2
13.4
13.6
13.8
14
14.2
14.4
14.6
14.8
15
15.2
15.4
15.6
15.8
16];
X3= [-17
-16.8
-16.6
-16.4
-16.2
-16
-15.8
-15.6
-15.4
-15.2
-15
-14.8
-14.6
-14.4
-14.2
-14
-13.8
-13.6
-13.4
-13.2
-13
-12.8
-12.6
-12.4
-12.2
-12
-11.8
-11.6
-11.4
-11.2
-11
-10.8
-10.6
-10.4
-10.2
-10
-9.8
-9.6
-9.4
-9.2
-9
-8.8
-8.6
-8.4
-8.2
-8
-7.8
-7.6
-7.4
-7.2
-7
-6.8
-6.6
-6.4
-6.2
-6
-5.8
-5.6
-5.4
-5.2
-5
-4.8
-4.6
-4.4
-4.2
-4
-3.8
-3.6
-3.4
-3.2
-3
-2.8
-2.6
-2.4
-2.2
-2
-1.8
-1.6
-1.4
-1.2
-1
-0.8
-0.6
-0.4
-0.2
0
0.2
0.4
0.6
0.8
1
1.2
1.4
1.6
1.8
2
2.2
2.4
2.6
2.8
3
3.2
3.4
3.6
3.8
4
4.2
4.4
4.6
4.8
5
5.2
5.4
5.6
5.8
6
6.2
6.4
6.6
6.8
7
7.2
7.4
7.6
7.8
8
8.2
8.4
8.6
8.8
9
9.2
9.4
9.6
9.8
10
10.2
10.4
10.6
10.8
11
11.2
11.4
11.6
11.8
12
12.2
12.4
12.6
12.8
13
13.2
13.4
13.6
13.8
14
14.2
14.4
14.6
14.8
15
15.2
15.4
15.6
15.8
16
16.2
16.4
16.6
16.8
17];
PPD_1 = [0.029736486
0.031069132
0.032119685
0.033724697
0.035154616
0.036817992
0.03847164
0.039969651
0.042382032
0.044113499
0.045913057
0.048675622
0.051496552
0.054113207
0.057080046
0.060124705
0.063529274
0.067585576
0.07167106
0.077429647
0.087020807
0.104063111
0.154907931
0.316644456
0.547668842
0.775463751
0.915080299
0.953055845
0.966567124
0.972880169
0.976245829
0.981099773
0.983181425
0.985545169
0.986021809
0.987276636
0.987860276
0.987052907
0.988949739
0.988969194
0.99044775
0.990613114
0.990292112
0.98964038
0.989922473
0.990729843
0.990622842
0.989980837
0.989961382
0.989533379
0.987597638
0.987140453
0.985477078
0.984659981
0.984679435
0.983230061
0.981021955
0.980360495
0.980341041
0.980496678
0.981663959
0.981975234
0.980448041
0.980457769
0.981080319
0.979669854
0.979115395
0.977646567
0.976265284
0.976177738
0.976002646
0.975564915
0.97510773
0.973561083
0.973269263
0.974767273
0.976508468
0.976031828
0.978677665
0.980350768
0.980739862
0.983006333
0.984669708
0.983687246
0.98565217
0.984358433
0.986829178
0.987578184
0.984864255
0.986887542
0.987967277
0.988833011
0.989873836
0.990010019
0.992801766
0.991877669
0.995574059
0.996488429
0.995243329
0.997587619
0.998025349
0.998249078
1
0.999416359
0.999250995
0.99860899
0.998881356
0.997918349
0.998677081
0.998540899
0.99784053
0.998054531
0.9962647
0.994961237
0.996177154
0.995846425
0.992169489
0.991430211
0.988998376
0.986770814
0.982364328
0.976245829
0.965750027
0.939213836
0.835286908
0.622968201
0.38160365
0.187883622
0.113177631
0.09162184
0.080921763
0.074297443
0.069589409
0.065640108
0.062235538
0.058976878
0.056175403
0.053490657
0.050815638
0.048033618
0.045844966
0.043500676
0.041847028
0.039755649
0.037644816
0.036613717
0.034561248
0.033141056
0.031934866
0.030767585
0.029269574];
PPD_2 =[0.055071439
0.056627529
0.059060688
0.061748479
0.064068468
0.067109917
0.070108926
0.073447447
0.076842552
0.080124487
0.08360447
0.087706889
0.092403452
0.097184892
0.101839015
0.106974112
0.113113595
0.118956005
0.125873532
0.133781299
0.144433442
0.159244589
0.187112746
0.263700665
0.422718914
0.617187721
0.781666431
0.865369925
0.896208799
0.909633612
0.919903805
0.927104258
0.935549583
0.941406139
0.946017824
0.950304145
0.956217287
0.959400198
0.962526524
0.965907483
0.969472344
0.971863064
0.973277691
0.977705475
0.978243033
0.979332296
0.982600085
0.983533739
0.985981044
0.986065922
0.987820059
0.988131277
0.988838591
0.988824445
0.987947376
0.990083463
0.988286886
0.989673221
0.988782006
0.989616636
0.990521997
0.99005517
0.991144433
0.990960532
0.991073702
0.990451266
0.99305418
0.992587353
0.993521007
0.990352242
0.993379544
0.992559061
0.99210638
0.9926015
0.98982883
0.992063941
0.990097609
0.989036639
0.990224926
0.99077663
0.989729806
0.989984439
0.994143443
0.995657094
0.995345876
0.994836611
0.993676616
0.997708304
0.996534163
0.998245862
0.997807328
0.997453671
0.997920498
0.997411232
0.997764889
0.998472203
0.997340501
0.996901966
0.996222945
0.997637572
0.998458056
0.998755128
0.998231716
1
0.998175131
0.996916113
0.998528788
0.997340501
0.996831235
0.995317584
0.993040034
0.993506861
0.990804923
0.989376149
0.988541519
0.98649031
0.982925449
0.980704484
0.979120102
0.976686943
0.973008912
0.968694299
0.96614797
0.96292262
0.959725562
0.954491442
0.949497807
0.942608573
0.935054463
0.928250106
0.917498939
0.903904371
0.876290847
0.794313198
0.63013156
0.435082756
0.270391852
0.189446881
0.161720187
0.146046117
0.135266657
0.127118404
0.120384779
0.113453105
0.107539963
0.10261706
0.097821474
0.093294667
0.089008346
0.085075683
0.081510822
0.077394257
0.07404159
0.0705899
0.06770406
0.06520017
0.062823596
0.060107512
0.058042156
0.055566558
0.053402179];
PPD_3 = [0.090841469
0.094281729
0.09855881
0.10130172
0.10423059
0.107415156
0.111668991
0.115155742
0.120641562
0.125546258
0.129800093
0.135006974
0.139562994
0.144886099
0.15125523
0.156764296
0.164272431
0.171129707
0.178707578
0.187238494
0.19939563
0.216643422
0.250395165
0.337796374
0.481380753
0.640609019
0.764969781
0.823407717
0.84702464
0.862040911
0.873245002
0.881775918
0.887540679
0.894467689
0.90348675
0.908833101
0.914737331
0.920385867
0.924546722
0.929707113
0.933356578
0.938028824
0.943514644
0.945281265
0.950953045
0.95120874
0.956113436
0.957112971
0.961715481
0.964504881
0.966922362
0.969386332
0.972152487
0.973175267
0.974941887
0.978382148
0.978568108
0.980822873
0.979265458
0.983682008
0.981171548
0.983333333
0.983147373
0.986308694
0.988307764
0.987912599
0.991027429
0.990353324
0.991957229
0.992259414
0.993165969
0.993282194
0.994583914
0.994793119
0.991771269
0.994351464
0.99558345
0.996211065
0.994700139
0.992910274
0.993956299
0.992980009
0.991933984
0.994235239
0.994816364
0.995002325
0.993537889
0.994467689
0.99851232
0.995792655
0.996257555
0.99832636
0.99948861
0.999697815
0.9995351
0.997326825
1
0.997791725
0.99609484
0.994932589
0.994514179
0.99530451
0.994723384
0.993003254
0.991120409
0.992212924
0.992701069
0.990260344
0.989377034
0.988702929
0.987842864
0.987563924
0.987122269
0.982682473
0.983565783
0.979753603
0.981008833
0.975918178
0.972594142
0.969711762
0.967666202
0.967968387
0.962482566
0.960344026
0.955485821
0.951696885
0.949372385
0.94521153
0.941887494
0.938191539
0.931241283
0.926266853
0.922942817
0.917875407
0.911227336
0.903509995
0.897884705
0.891073919
0.880543933
0.871664342
0.861250581
0.843584379
0.808507671
0.715899582
0.569642027
0.408437936
0.286401674
0.230962343
0.207810321
0.194444444
0.184007438
0.175058113
0.168014877
0.160739191
0.153695955
0.147187355
0.142956764
0.136773594
0.132287308
0.128242678
0.122687122
0.117759182
0.113784286
0.109065551
0.106136681
0.102533705
0.09944212
0.09642027
0.092073454
0.089121339
0.086727104];
figure(1);
plot(X1,PPD_1,'LineWidth', 1.8);hold on;plot(X2,PPD_2,'LineWidth', 1.8);plot(X3,PPD_3,'LineWidth', 1.8);hold off
title('Measured PDD beam Profile At different Depths')
xlabel('X (cm)')
ylabel('PPD')
legend('PDD at Depth 1.5 cm', 'PDD at Depth 10 cm','PDD at Depth 20 cm')
left_area_1 = trapz(X1(X1 > -10), PPD_1(X1 > -10)); % Area on the left side
right_area_1 = trapz(X1(X1 <10 ), PPD_1(X1 < 10)); % Area on the right side

left_area_2 = trapz(X2(X2 > -11), PPD_2(X2 >-11)); % Area on the left side
right_area_2 = trapz(X2(X2 < 11), PPD_2(X2 < 11)); % Area on the right side

left_area_3 = trapz(X3(X3 > -13), PPD_3(X3 > -13)); % Area on the left side
right_area_3 = trapz(X3(X3 <13), PPD_3(X3 < 13)); % Area on the right side

left_side_1 = PPD_1(X1 < 0);
right_side_1 = PPD_1(X1 > 0);
inverted_left_side_1 = flip(left_side_1); % Vertically invert the left side
area_quotient_1 = (right_area_1-left_area_1)./(right_area_1+left_area_1);
difference_quotient_1 = (right_side_1 - inverted_left_side_1) ./ max([right_side_1, inverted_left_side_1]);
inverted_left_side_1 = flip(left_side_1); % Vertically invert the left side
[cross_corr_1,lag_1] = xcorr(right_side_1, inverted_left_side_1,'normalized');
[CSI_1,lags_1] = high_intensity_CSI(right_side_1, inverted_left_side_1, .80,length(X1(X1>0)))
C = cov(right_side_1,inverted_left_side_1, 1);
signal1_2d = reshape(right_side_1, 1, []);
signal2_2d = reshape(inverted_left_side_1, 1 ,[]);
ssimValue = ssim(signal1_2d, signal2_2d , 'exp', [1,1, 1])
%dist_1=KLDiv(inverted_left_side_1,right_side_1);
% Plot the beam profile
figure(2);
subplot(2,2,1);
plot(X1, PPD_1, 'LineWidth', 2);
hold on;
plot([0 0], [min(PPD_1) max(PPD_1)], 'k--', 'LineWidth', 1.8); % Center line
title('Symmetric Beam Profile at 1.5cm Depth with Symmetric Area');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;
hold off;

% Plot the pointwise difference quotient
subplot(2,2,2);
plot(X1(X1 > 0), difference_quotient_1, 'LineWidth', 2);
title('Pointwise Difference Quotient Between Left and Right Sides');
xlabel('Position (cm)');
ylabel('Difference Quotient');
grid on;

% Plot the cross-correlation
subplot(2,2,3);
plot(X1, CSI_1, 'LineWidth', 2);
title('Cross-Correlation Between Right Side and Horizontal Inverted Left Side');
xlabel('Position (cm)');
ylabel('Cross-Correlation');
grid on;
subplot(2,2,4);
plot(X1(X1 > 0), inverted_left_side_1, 'LineWidth', 2);
hold on
plot(X1(X1 > 0),right_side_1,'LineWidth', 2); hold off
title('inverted left vs right beam profile')
ylabel('Normalized Dose');
xlabel('Position (cm)');
grid on;

left_side_2 = PPD_2(X2 < 0);
right_side_2 = PPD_2(X2 > 0);
area_quotient_2 = (right_area_2-left_area_2)./(right_area_2+left_area_2); % area baed method
inverted_left_side_2 = flip(left_side_2); % horizontally invert the left side
difference_quotient_2 = abs(right_side_2 - inverted_left_side_2 ) ./ max([right_side_2,inverted_left_side_2 ]);
% Point wise quotient based method
inverted_left_side_2 = flip(left_side_2); % horizantally invert the left side
[cross_corr_2, lag_2] = xcorr(right_side_2, inverted_left_side_2,'normalized');
[CSI_2,lags_2] = high_intensity_CSI(right_side_2, inverted_left_side_2, .80,length(X2(X2>0)))
signal1_2d = reshape(right_side_2, 1, []);
signal2_2d = reshape(inverted_left_side_2, 1 ,[]);
ssimValue_2 = ssim(signal1_2d, signal2_2d , 'exp', [1,1, 1])
figure(3);
subplot(2,2,1);
plot(X2, PPD_2, 'LineWidth', 2);
hold on;
plot([0 0], [min(PPD_2) max(PPD_2)], 'k--', 'LineWidth', 1.8); % Center line
title('Symmetric Beam Profile at 10 cm Depth with Symmetric Area');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;
hold off;

% Plot the pointwise difference quotient
subplot(2,2,2);
plot(X2(X2>0), difference_quotient_2, 'LineWidth', 2);
title('Pointwise Difference Quotient Between Left and Right Sides');
xlabel('Position (cm)');
ylabel('Difference Quotient');
grid on;

% Plot the cross-correlation
subplot(2,2,3);
plot(X2, CSI_2, 'LineWidth', 2);
title('Cross-Correlation Between Right Side and Horizontal Inverted Left Side');
xlabel('Position (cm)');

ylabel('Cross-Correlation');
grid on;
subplot(2,2,4);
plot(X2(X2 > 0),inverted_left_side_2, 'LineWidth', 2);
hold on
plot(X2(X2 > 0),right_side_2,'LineWidth', 2); hold off
title('inverted left vs right beam profile')
ylabel('Normalized Dose');
xlabel('Position (cm)');
grid on;

left_side_3 = PPD_3(X3 < 0);
right_side_3 = PPD_3(X3 > 0);
inverted_left_side_3 = flip(left_side_3); % horizontally  invert the left side
area_quotient_3 = (right_area_3-left_area_3)./(right_area_3+left_area_3);
difference_quotient_3 = abs(right_side_3 - inverted_left_side_3) ./ max([right_side_3, inverted_left_side_3]);
inverted_left_side_3 = flip(left_side_3); % horizontally  invert the left side
[cross_corr_3, lag_3] = xcorr(right_side_3, inverted_left_side_3,'normalized');
[CSI_3,lags_3] = high_intensity_CSI(right_side_3, inverted_left_side_3, .80,length(X3(X3>0)))
signal1_2d = reshape(right_side_3, 1, []);
signal2_2d = reshape(inverted_left_side_3, 1 ,[]);
ssimValue_3 = ssim(signal1_2d, signal2_2d , 'exp', [1,1, 1])
figure(4);
subplot(2,2,1);
plot(X3, PPD_3, 'LineWidth', 2);
hold on;
plot([0 0], [min(PPD_3) max(PPD_3)], 'k--', 'LineWidth', 1.8); % Center line
title('Symmetric Beam Profile at 20 cm Depth with Symmetric Area');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;
hold off;

% Plot the pointwise difference quotient
subplot(2,2,2);
plot(X3(X3 > 0), difference_quotient_3, 'LineWidth', 2);
title('Pointwise Difference Quotient Between Left and Right Sides');
xlabel('Position (cm)');
ylabel('Difference Quotient');
grid on;

% Plot the cross-correlation
subplot(2,2,3);
plot(X3, CSI_3, 'LineWidth', 2);
title('Cross-Correlation Between Right Side and Horizontal Inverted Left Side');
xlabel('Position (cm)');

ylabel('Cross-Correlation');
grid on;
subplot(2,2,4);
plot(X3(X3 > 0),inverted_left_side_3, 'LineWidth', 2);
hold on
plot(X3(X3 > 0),right_side_3,'LineWidth', 2); hold off
xlabel('Position (cm)');
ylabel('Normalized Dose');
title('inverted left vs right beam profile')
grid on;
%% obtain tolerance for CSI
clc;
clear;
close all;

% Define beam profile size
profile_size = 200;
x = linspace(-100, 100, profile_size);

% Generate a symmetric Gaussian beam profile
sigma = 20;
center = 0;
beam_profile = exp(-((x-center).^2) / (2 * sigma^2));

% Introduce asymmetry for PDQ and area-based index
asymmetry_factor_pdq = 0.02;
asymmetry_factor_area = 0.062;%0.062
;

% Create a left and right profile
left_profile = beam_profile(1:profile_size/2);
right_profile = beam_profile(profile_size/2+1:end);

% Introduce PDQ asymmetry (2%)
left_profile = left_profile * (1 - asymmetry_factor_pdq);
right_profile = right_profile * (1 + asymmetry_factor_pdq);

% Introduce area-based asymmetry (3%)
left_area = sum(left_profile);
right_area = sum(right_profile);
scaling_factor = (1 + asymmetry_factor_area) * left_area / right_area;
right_profile = right_profile * scaling_factor;

% Combine left and right profiles
sym_profile = [left_profile, right_profile];

% Calculate PDQ
pdq = max(abs(left_profile - flip(right_profile))) / max(sym_profile) * 100;
fprintf('PDQ: %.2f%%\n', pdq);

[csi, lag]  = high_intensity_CSI(flip(left_profile), right_profile, .80, 100)
fprintf('CSI: %.2f%%\n', csi(lag==0));

ssimValue_2 = ssim(left_profile,  flip(right_profile), 'exp', [1,1, 1])

% Calculate Area-Based Symmetry Index
area_left = sum(left_profile);
area_right = sum(right_profile);
area_symmetry = abs(area_left - area_right) / (area_left + area_right) * 100;
fprintf('Area-Based Symmetry Index: %.2f%%\n', area_symmetry);

% Plot the final beam profile
figure;
plot(x, sym_profile, 'LineWidth', 2);
hold on;
plot(x(1:profile_size/2), left_profile, '--', 'LineWidth', 1.5);
plot(x(profile_size/2+1:end), right_profile, '--', 'LineWidth', 1.5);
hold off;
title(sprintf('Beam Profile (PDQ = %.2f%%, Area-Based = %.2f%%, CSI=%.2f%%)', pdq, area_symmetry,csi(lag==0)));
xlabel('Position');
ylabel('Intensity');
legend('Combined Profile', 'Left Profile', 'Right Profile');
grid on;

%%
clc;
clear;
close all;

% Define beam profile parameters
profile_size = 200;
x = linspace(-100, 100, profile_size);

% Create a symmetric Gaussian beam profile as the base
sigma = 20;
center = 0;
beam_profile = exp(-((x-center).^2) / (2 * sigma^2));

% Split the profile into left and right halves
left_profile = beam_profile(1:profile_size/2);
right_profile = beam_profile(profile_size/2+1:end);

% Adjust the right profile to achieve the exact area and PDQ metrics
target_pdq = 0.05;
target_area = 0.062;

% Apply PDQ asymmetry (2%)
max_intensity = max(beam_profile);
left_profile = left_profile * (1 - target_pdq);
right_profile = right_profile * (1 + target_pdq);

% Calculate current areas
area_left = sum(left_profile);
area_right = sum(right_profile);

% Scale right side to achieve the exact area difference
scaling_factor = (1 + target_area) * area_left / area_right;
right_profile = right_profile * scaling_factor;

% Recombine the profiles
final_profile = [left_profile, right_profile];

% Calculate actual PDQ
pdq_actual = max(abs(left_profile - flip(right_profile))) / max(final_profile) * 100;

% Calculate actual Area-Based Symmetry Index
area_left_final = sum(left_profile);
area_right_final = sum(right_profile);
area_symmetry_actual = abs(area_left_final - area_right_final) / (area_left_final + area_right_final) * 100;

% Print the results
fprintf('Target PDQ: %.2f%%, Actual PDQ: %.2f%%\n', target_pdq*100, pdq_actual);
fprintf('Target Area Symmetry: %.2f%%, Actual Area Symmetry: %.2f%%\n', target_area*100, area_symmetry_actual);

% Plot the final beam profile
figure;
plot(x, final_profile, 'LineWidth', 2);
hold on;
plot(x(1:profile_size/2), left_profile, '--', 'LineWidth', 1.5);
plot(x(profile_size/2+1:end), right_profile, '--', 'LineWidth', 1.5);
hold off;
title(sprintf('Beam Profile (PDQ = %.2f%%, Area = %.2f%%)', pdq_actual, area_symmetry_actual));
xlabel('Position');
ylabel('Intensity');
legend('Combined Profile', 'Left Profile', 'Right Profile');
grid on;
%%
clc;
clear;
close all;

% Define beam profile parameters
profile_size = 200;
x = linspace(-100, 100, profile_size);
sigma = 20;
center = 0;

% Create a symmetric Gaussian beam profile as the initial guess
initial_profile = exp(-((x-center).^2) / (2 * sigma^2));
initial_profile = initial_profile / max(initial_profile);  % Normalize

% Target PDQ and area-based metrics
target_pdq = 0.02;
target_area = 0.03;

% Create a Gaussian kernel
gaussian_kernel = exp(-((x-center).^2) / (2 * sigma^2));
gaussian_kernel = gaussian_kernel / sum(gaussian_kernel);

% Create a rectangular function to simulate a flattened top
rect_width = 100;
rect_kernel = zeros(1, profile_size);
rect_kernel(abs(x) < rect_width / 2) = 1;
rect_kernel = rect_kernel / sum(rect_kernel);

% Convolve to create a realistic beam shape constraint
target_shape = conv(gaussian_kernel, rect_kernel, 'same');
target_shape = target_shape / max(target_shape);

% Objective function: Minimize deviation from target PDQ and area-based metric
function cost = beam_cost(profile, target_pdq, target_area, target_shape)
    n = length(profile);
    left_profile = profile(1:n/2);
    right_profile = profile(n/2+1:end);

    % PDQ calculation
    pdq_actual = max(abs(left_profile - flip(right_profile))) / max(profile) * 100;
    
    % Area-based symmetry calculation
    area_left = sum(left_profile);
    area_right = sum(right_profile);
    area_symmetry_actual = abs(area_left - area_right) / (area_left + area_right) * 100;
    
    % Shape similarity constraint
    shape_similarity = sum((profile - target_shape).^2);
    
    % Cost as squared deviation from target with shape penalty
    cost = 50*(pdq_actual - target_pdq * 100)^2 + ...
           50*(area_symmetry_actual - target_area * 100)^2 + ...
           100 * shape_similarity;
end

% Optimization settings
options = optimoptions('fmincon', 'Display', 'iter', 'MaxFunctionEvaluations', 5000, 'Algorithm', 'interior-point');
lb = zeros(profile_size, 1);   % Minimum intensity (zero)
ub = ones(profile_size, 1);    % Maximum intensity (normalized)

% Run the optimization
[optimized_profile, final_cost] = fmincon(@(p) beam_cost(p, target_pdq, target_area, target_shape), ...
                                           initial_profile, [], [], [], [], lb, ub, [], options);

% Calculate final metrics
left_final = optimized_profile(1:profile_size/2);
right_final = optimized_profile(profile_size/2+1:end);
final_pdq = max(abs(left_final - flip(right_final))) / max(optimized_profile) * 100;
final_area = abs(sum(left_final) - sum(right_final)) / (sum(left_final) + sum(right_final)) * 100;

% Print results
fprintf('Final PDQ: %.2f%% (Target: %.2f%%)\n', final_pdq, target_pdq * 100);
fprintf('Final Area-Based Symmetry: %.2f%% (Target: %.2f%%)\n', final_area, target_area * 100);

% Plot the optimized beam profile
figure;
plot(x, optimized_profile, 'LineWidth', 2);
hold on;
plot(x, target_shape, '--', 'LineWidth', 1.5);
hold off;
title(sprintf('Optimized Beam Profile (PDQ = %.2f%%, Area = %.2f%%)', final_pdq, final_area));
xlabel('Position');
ylabel('Intensity');
legend('Optimized Profile', 'Target Shape');
grid on;



function [csi, lags] = high_intensity_CSI(A, B, threshold_fraction,max_lag)
    % Ensure A and B are the same size
    if size(A) ~= size(B)
        error('Inputs A and B must be the same size');
    end
    
    % Flatten the inputs for 1D correlation
    A = A(:);
    B = B(:);
    
    % Calculate the 50% of maximum intensity threshold
    max_intensity_A = max(A);
    max_intensity_B = max(B);
    threshold_A = threshold_fraction * max_intensity_A;
    threshold_B = threshold_fraction * max_intensity_B;
    
    % Create masks for the central high-intensity regions
    mask_A = A >= threshold_A;
    mask_B = B >= threshold_B;
    combined_mask = mask_A & mask_B;
    
    % Apply the mask to focus on high-intensity regions
    A_high_intensity = A(combined_mask);
    B_high_intensity = B(combined_mask);

    % Define lag range
    lags = -max_lag:max_lag;
    bcc = zeros(length(lags), 1);
    
    % Calculate biased cross-correlation for each lag
    for i = 1:length(lags)
        lag = lags(i);
        
        if lag < 0
            % Shift B to the left
            shifted_A= A_high_intensity(1:end+lag);
            shifted_B = B_high_intensity(-lag+1:end);
        elseif lag > 0
            % Shift B to the right
            shifted_A = A_high_intensity(lag+1:end);
            shifted_B = B_high_intensity(1:end-lag);
        else
            % No shift
            shifted_A = A_high_intensity;
            shifted_B = A_high_intensity;
        end
        
    
    % Subtract the mean
    A_centered = A_high_intensity;
    B_centered = B_high_intensity;
    
    % Calculate the biased cross-correlation
    csi(i) = sum(shifted_A .* shifted_B) / numel(shifted_A);
    end
end

