%% Three-hump camel (x2 = 0): convolve with rect, fit & subtract a
%% linear background under the peaks so they level off on a flat baseline.
%
% Requires: Signal Processing Toolbox (findpeaks). A fallback peak finder
% is included in case the toolbox is not available.
%
% Produces a 1x3 figure:
%   (1) inputs: flipped-camel "signal" and the rect kernel
%   (2) convolved curve + sloped baseline + fitted background line
%   (3) background-subtracted result with peaks leveled on a flat baseline
function [x, f,corrected] = camel_baseline_workflow()
clear; clc; close all;

%% ---- Grid ----
dx = 0.002;
x  = (-2.5:dx:2.5).';          % column vector

%% ---- Three-hump camel slice at x2 = 0 ----
% g(x) = 2x^2 - 1.05x^4 + x^6/6   (three wells / minima)
g = 2*x.^2 - 1.05*x.^4 + (x.^6)/6;

% Flip to make upward peaks, then lift so the lowest point sits at 0
f = -g;
f = f - min(f);

%% ---- Rect kernel (narrow, to keep the humps resolved) ----
W    = 0.30;                              % rect width
rect = double(abs(x) <= W/2);

%% ---- Convolution (continuous approximation: * dx, keep same length) ----
conv_full = conv(f, rect, 'same') * dx;

% rescale so its height is comparable to f (purely cosmetic)
conv_curve = conv_full / max(conv_full) * max(f);

%% ---- Add a sloping linear background to emulate baseline drift ----
background_true = 0.6*x + 1.4;
signal = conv_curve + background_true;

%% ---- Detect peaks ----
if exist('findpeaks','file') == 2
    [~, pk_idx] = findpeaks(signal, 'MinPeakProminence', 0.05);
    [~, vl_idx] = findpeaks(-signal, 'MinPeakProminence', 0.02);
else
    pk_idx = localExtrema(signal,  1);   % maxima
    vl_idx = localExtrema(signal, -1);   % minima
end

%% ---- Fit a straight line to the background ----
% Anchor on the valleys (between/around peaks) plus the two endpoints.
anchor_idx = unique([1; vl_idx(:); numel(x)]);
p          = polyfit(x(anchor_idx), signal(anchor_idx), 1);   % [slope intercept]
bg_fit     = polyval(p, x);

%% ---- Subtract background ----
corrected = signal - bg_fit;

%% ---- Plot ----
figure('Position', [100 100 1400 420]);

subplot(1,3,1);
plot(x, f, 'LineWidth', 1.5); hold on;
plot(x, rect, 'r', 'LineWidth', 1.5);
yline(0, 'k'); grid on;
title('Inputs'); xlabel('x');
legend('flipped camel (3 humps)', sprintf('rect (W=%.2f)', W), 'Location','best');

subplot(1,3,2);
plot(x, signal, 'LineWidth', 2); hold on;
plot(x(pk_idx), signal(pk_idx), 'rv', 'MarkerSize', 10, 'MarkerFaceColor','r');
plot(x, bg_fit, '--', 'LineWidth', 1.6);
grid on; title('Convolved curve + fitted background'); xlabel('x');
legend('convolved + sloped baseline', 'peaks', 'fitted background line', 'Location','best');

subplot(1,3,3);
plot(x, corrected, 'LineWidth', 2); hold on;
plot(x(pk_idx), corrected(pk_idx), 'rv', 'MarkerSize', 10, 'MarkerFaceColor','r');
yline(0, 'k', 'LineWidth', 1);
grid on; title('After subtraction: peaks level off'); xlabel('x');
legend('background-subtracted', 'peaks', 'Location','best');

fprintf('Background line:  slope = %.4f, intercept = %.4f\n', p(1), p(2));
fprintf('Peaks at x = %s\n', mat2str(round(x(pk_idx).',3)));

%% ---- Fallback local-extrema finder (no toolbox needed) ----
function idx = localExtrema(y, s)
    % s = +1 for maxima, -1 for minima
    y = s*y(:);
    idx = find(y(2:end-1) > y(1:end-2) & y(2:end-1) > y(3:end)) + 1;
end
end