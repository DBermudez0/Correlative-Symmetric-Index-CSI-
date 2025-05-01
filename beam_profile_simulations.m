% Author: Dalton H Bermudez (UW Madison)
% Accessment of simulated beam profile symmetry of real clinical beam profiles,
% comparing proposed correlative symmetric index (CSI) with standard Point
% wise Quotient and Area based metrics

% Define parameters
x = linspace(-4, 6, 1000); % X-axis range and resolution
A1 = 1; % Amplitude of the sine function
A2 = 0.5; % Amplitude of the cosine function
k = 2 * pi / 10; % Wave number (frequency component)
phi = pi / 4; % Phase shift to break symmetry in the profile

% Generate the beam profile
beam_profile = A1 * sin(k * x + phi) + A2 * cos(k * x);
beam_profile_2 = beam_profile - min(beam_profile);
beam_profile_3 = beam_profile_2./max(beam_profile_2);

% Ensure the areas are symmetric
left_area = trapz(x(x < 0), beam_profile_3(x < 0)); % Area on the left side
right_area = trapz(x(x > 0), beam_profile_3(x > 0)); % Area on the right side
Area_quotint = (right_area-left_area)./(left_area+right_area );
% Adjust the profile to make areas symmetric
adjustment = (right_area - left_area) / (2 * sum(x > 0)); % Calculate adjustment factor
beam_profile_3(x > 0) = beam_profile_3(x > 0) - adjustment; % Adjust the right side

% Plot the beam profile
figure;
plot(x, beam_profile_3, 'LineWidth', 2);
hold on;
plot([0 0], [min(beam_profile_3) max(beam_profile_3)], 'k--', 'LineWidth', 1.8); % Center line
title('Non-Symmetric Beam Profile');
xlabel('Position');
ylabel('Normalized Dose');
grid on;
hold off;

%%
% Define parameters
x = linspace(-4, 6, 1000); % X-axis range and resolution
A1 = 1; % Amplitude of the sine function
A2 = 0.5; % Amplitude of the cosine function
k = 2 * pi / 10; % Wave number (frequency component)
phi = pi / 4; % Phase shift to break symmetry in the profile

% Generate the beam profile
beam_profile = A1 * sin(k * x + phi) + A2 * cos(k * x);
beam_profile_2 = beam_profile - min(beam_profile);
beam_profile_3 = beam_profile_2./max(beam_profile_2);

% Ensure the areas are symmetric
left_area = trapz(x(x > -2), beam_profile_3(x >-2)); % Area on the left side
right_area = trapz(x(x <2 ), beam_profile_3(x < 2));
Area_quotint_no_noise = (right_area-left_area)./(left_area+right_area );
% Adjust the profile to make areas symmetric
adjustment = (right_area - left_area) / (2 * sum(x > 0)); % Calculate adjustment factor
beam_profile_3(x > 0) = beam_profile_3(x > 0) - adjustment; % Adjust the right side

% Calculate pointwise difference quotient
left_side = beam_profile_3(x < 0);
right_side = beam_profile_3(x > 0);

% Ensure left_side and right_side are of equal length
min_length = min(length(left_side), length(right_side));
left_side = left_side(end-min_length+1:end);
right_side = right_side(1:min_length);
inverted_left_side = flip(left_side); % horizontally  invert the left side

difference_quotient = abs(right_side - inverted_left_side) ./ max([right_side,inverted_left_side]) ;
%difference_quotient_max = max((right_side - left_side) ./ left_side);


% Calculate cross-correlation
inverted_left_side = flip(left_side); % horizontally  invert the left side
[cross_corr,lags] = xcorr(right_side, inverted_left_side, 'biased');
cross_corr_2 = xcorr(right_side, inverted_left_side, 'coeff');
signal1_2d = reshape(right_side, 1, []);
signal2_2d = reshape(inverted_left_side, 1 ,[]);
ssimValue_nonoise= ssim(signal1_2d, signal2_2d , 'exp', [1,1, 1])
% Plot the beam profile
figure;
subplot(2,2,1);
plot(x, beam_profile_3, 'LineWidth', 2);
hold on;
plot([0 0], [min(beam_profile_3) max(beam_profile_3)], 'k--', 'LineWidth', 1.8); % Center line
title('Non-Symmetric Beam Profile with Symmetric Area');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;
hold off;

% Plot the pointwise difference quotient
subplot(2,2,2);
a = x(x > 0);
plot(a(1:400), difference_quotient, 'LineWidth', 2);
title('Pointwise Difference Quotient Between Left and Right Sides');
xlabel('Position (cm)');
ylabel('Difference Quotient');
grid on;

% Plot the cross-correlation
subplot(2,2,3);
plot(lags/100, cross_corr, 'LineWidth', 2);
title('Cross-Correlation Between Right Side and Horizontal Inverted Left Side');
xlabel('Position (cm)');
ylabel('Cross-Correlation');
grid on;
subplot(2,2,4);
plot(a(1:400), inverted_left_side, 'LineWidth', 2);
hold on
plot(a(1:400), right_side, 'LineWidth', 2); hold off
title('inverted left vs right beam profile')
ylabel('Normalized Dose');
xlabel('Position (cm)');
grid on;
%% with Added noise 
% Define parameters
x = linspace(-4, 6, 1000); % X-axis range and resolution
A1 = 1; % Amplitude of the sine function
A2 = 0.5; % Amplitude of the cosine function
k = 2 * pi / 10; % Wave number (frequency component)
phi = pi / 4; % Phase shift to break symmetry in the profile
x1 = linspace(-4, 6, 1999);
% Generate the beam profile
cf1 = 250;         % central fq
bw = 0.25;          % bandwidth in octave
low_f1 = cf1 / 2 ^ (bw/2);      % lower limit of the fq range
high_f1 = cf1 * 2 ^ (bw/2);     % upper limit of the fq range
fs = 1000;          % sampling frequency
% geberate a gaussian white signal

% band pass the white noise to get the narrow band 
fv = linspace(0, 1, 2);                                % Normalised Frequencies
a = 1./(1 + fv*2);                                       % Amplitudes Of ‘1/f’
b = firls(42, fv, a);  
N = 1000;
ns = 0.3*rand(size(x));
invfn = filtfilt(b, 1, ns);                             % Create ‘1/f’ Noise
figure(2)
plot([0:N-1], invfn)                                    % Plot Noise In Time Domain
grid


Gaussian_noise = 0.3*rand(size(x));

beam_profile = A1 * sin(k * x + phi) + A2 * cos(k * x)+invfn;
beam_profile_2 = beam_profile - min(beam_profile);
beam_profile_3 = beam_profile_2./max(beam_profile_2);
plot(x,beam_profile)
ylim([-1 1])
% Ensure the areas are symmetric
left_area = trapz(x(x > -2), beam_profile_3(x >-2)); % Area on the left side
right_area = trapz(x(x <2 ), beam_profile_3(x < 2)); % Area on the right side
Area_quotint_noise = (right_area-left_area)./(left_area+right_area );
% Adjust the profile to make areas symmetric
inverted_left_side = flip(left_side); % Vertically invert the left side
adjustment = (right_area - left_area) / (2 * sum(x > 0)); % Calculate adjustment factor
beam_profile(x > 0) = beam_profile(x > 0) - adjustment; % Adjust the right side

% Calculate pointwise difference quotient
left_side = beam_profile_3(x < 0);
right_side = beam_profile_3(x > 0);

% Ensure left_side and right_side are of equal length
min_length = min(length(left_side), length(right_side));
left_side = left_side(end-min_length+1:end);
right_side = right_side(1:min_length);

difference_quotient = abs(right_side - inverted_left_side ) ./ max([right_side,inverted_left_side]);
difference_quotient_max = max(abs((right_side - left_side) ./ left_side));


% Calculate cross-correlation
inverted_left_side = flip(left_side); % Vertically invert the left side
[cross_corr, lags] = xcorr(right_side, inverted_left_side, 'biased');
cross_corr_2 = xcorr(right_side, inverted_left_side, 'biased');
signal1_2d = reshape(right_side, 1, []);
signal2_2d = reshape(inverted_left_side, 1 ,[]);
ssimValue_noise= ssim(signal1_2d, signal2_2d , 'exp', [1,1, 1])
% Plot the beam profile
figure;
subplot(2,2,1);
plot(x, beam_profile_3, 'LineWidth', 2);
hold on;
plot([0 0], [min(beam_profile_3) max(beam_profile_3)], 'k--', 'LineWidth', 1.8); % Center line
title('Non-Symmetric Beam Profile with Symmetric Area');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;
hold off;

% Plot the pointwise difference quotient
subplot(2,2,2);
a = x(x > 0);
plot(a(1:400), abs(difference_quotient), 'LineWidth', 2);
title('Pointwise Difference Quotient Between Left and Right Sides');
xlabel('Position (cm)');
ylabel('Difference Quotient');
grid on;

% Plot the cross-correlation
subplot(2,2,3);
plot(lags/100,  cross_corr, 'LineWidth', 2);
title('Cross-Correlation Between Right Side and Horizontal Inverted Left Side');
xlabel('Position (cm)');
ylabel('Cross-Correlation');
grid on;

subplot(2,2,4);
plot(a(1:400),inverted_left_side, 'LineWidth', 2);
hold on
plot(a(1:400), right_side, 'LineWidth', 2); hold off
title('inverted left vs right beam profile')
ylabel('Normalized Dose');
xlabel('Position (cm)');
grid on;
%%
% Define the time vector
t = -10:0.01:10;

% Define the rectangular function
rect = @(t) (abs(t) <= 1);  % Width of 2, centered at t = 0

% Define the cosine wave shifted and with minimum value zero
A = 1; % Amplitude of the cosine wave
f = 1; % Frequency of the cosine wave
cos_wave = @(t) A * cos(2 * pi * f * t) + A;  % Shifted cosine wave

% Compute the rectangular function
rect_t = rect(t);

% Compute the cosine wave
cos_t = cos_wave(t);

% Perform the convolution
conv_result = conv(rect_t, cos_t, 'same') * 0.01; % Scaling factor to match the time step

% Plot the original signals
figure;
subplot(3,1,1);
plot(t, rect_t);
title('Rectangular Function');
xlabel('Position (cm)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(t, cos_t);
title('Shifted Cosine Wave');
xlabel('Position (cm)');
ylabel('Amplitude');
grid on;

% Plot the convolution result
subplot(3,1,3);
plot(t, conv_result);
title('Convolution of Rectangular Function with Shifted Cosine Wave');
xlabel('Position (cm)');
ylabel('Amplitude');
grid on;
%%
% Define the time vector
t = -10:0.01:10;

% Define the rectangular function
rect = @(t) (abs(t) <= 1);  % Width of 2, centered at t = 0

% Define the cosine wave shifted with minimum value zero
A = 1/100; % Amplitude of the cosine wave
f = 1/16; % Frequency of the cosine wave
t2 = -0.97:0.01:1;
cos_wave = @(t2) A * sin(2 * pi * f * t2) + A;  % Shifted cosine wave
t3 = -0.97:0.001:0.5;
y = -0.3*t3+0.4;
% Define the Gaussian function
sigma = 1; % Standard deviation of the Gaussian
gaussian = @(t) exp(-t.^2 / (2 * sigma^2));

% Compute the rectangular function
rect_t = rect(t);

% Compute the cosine wave
cos_t = cos_wave(t);
gauss_t = gaussian(t);
conv_cos_gauss = conv(y, gauss_t, 'same') * 0.01; % Scaling factor to match the time step
% Perform the convolution of the rectangular function with the cosine wave
conv_rect_cos = conv(rect_t, conv_cos_gauss, 'same') * 0.01; % Scaling factor to match the time step

% Compute the Gaussian function
%gauss_t = gaussian(t);

% Perform the convolution of the previous result with the Gaussian function
%conv_result = conv(conv_rect_cos, gauss_t, 'same') * 0.01; % Scaling factor to match the time step

% Plot the original signals
figure(1);
subplot(2,2,1);
plot(t, rect_t,'LineWidth', 2);
title('Rectangular Function');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;

subplot(2,2,2);
plot(t3, y,'LineWidth', 2);
title('linear function');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;

subplot(2,2,3);
plot(t3, conv_cos_gauss,'LineWidth', 2);
title('Convolution of Rectangular Function with linear function');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;


subplot(2,2,4);
plot(t, conv_rect_cos./max(conv_rect_cos),'LineWidth', 2);
title('Convolution Result with Gaussian');
ylabel('Normalized Dose');
xlabel('Position (cm)');
grid on;

beam_profile_wedge = conv_rect_cos./max(conv_rect_cos);

left_side_wedge = beam_profile_wedge(t < 0);
right_side_wedge = beam_profile_wedge(t > 0);
inverted_left_side_wedge = flip(left_side_wedge);
 
difference_quotient = (right_side_wedge - inverted_left_side_wedge) ./ max([right_side_wedge,inverted_left_side_wedge]);

left_area = trapz(t((0 > t)& (t > -7.5)), beam_profile_wedge( (0 > t) & (t>-7.5))); % Area on the left side
right_area = trapz(t((0 < t)& (t <7) ), beam_profile_wedge((0 < t) & (t < 7))); % Area on the right side

Area_quotint_wedge = (right_area-left_area)./(left_area+right_area );
inverted_left_side_wedge = flip(left_side_wedge); % Vertically invert the left side
[cross_corr_wedge, lags] =  xcorr(right_side_wedge, inverted_left_side_wedge, 'biased');
C1 = cov(right_side_wedge,inverted_left_side_wedge, 1);
signal1_2d = reshape(right_side_wedge, 1, []);
signal2_2d = reshape(inverted_left_side_wedge, 1 ,[]);
ssimValue_2 = ssim(signal1_2d, signal2_2d , 'exp', [1,1, 1])
figure(2);
subplot(2,2,1);
plot(t, conv_rect_cos./max(conv_rect_cos),'LineWidth', 2);
title('Convolution Result with Gaussian');
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;
% Plot the pointwise difference quotient
subplot(2,2,2);
plot(t(t > 0), abs(difference_quotient), 'LineWidth', 2);
title('Pointwise Difference Quotient Between Left and Right Sides');
xlabel('Position (cm)');
ylabel('Difference Quotient');
grid on;

% Plot the cross-correlation
subplot(2,2,3);
plot(lags/100,  cross_corr_wedge, 'LineWidth', 2);
title('Cross-Correlation Between Right Side and Horizontal Inverted Left Side');
xlabel('Position (cm)');
ylabel('Cross-Correlation');
grid on;

subplot(2,2,4);
plot(t(t > 0),inverted_left_side_wedge, 'LineWidth', 2);
hold on
plot(t(t > 0), right_side_wedge,'LineWidth', 2); hold off
title('inverted left vs right beam profile')
xlabel('Position (cm)');
ylabel('Normalized Dose');
grid on;

