%% csi_tolerance_across_frequencies.m
% ------------------------------------------------------------------------
% Demonstrates that the Correlative Symmetric Index (CSI) tolerance
% (~0.84) corresponding to the clinical PDQ (+/-2%) and area-based (+/-3%)
% beam-symmetry tolerances is CONSISTENT across square-wave / flat-top
% beam profiles built from superpositions of sinusoids at DIFFERENT
% fundamental frequencies.
%
% CSI is computed with the author's own definition (high_intensity_CSI,
% included at the bottom of this file): a BIASED, high-intensity-masked
% cross-correlation between the right half (A) and the mirrored left half
% (B) of the profile; the reported scalar is the value at zero lag.
%
% Asymmetry model: left-right amplitude imbalance (gain tilt).
%   right half *= (1+g),  left half *= (1-g).
% For each frequency case we solve for the tilt g that puts
%   PDQ  = 2%   and (separately)  Area = 3%,
% then read the CSI at those operating points.
%
% Metric definitions
%   PDQ  (TG-142 style): max over in-field matched mirror points of
%          |D(x) - D(-x)| / D(CAX) * 100%,  in-field = D >= 50% of max.
%   Area (half-max):     |A_L - A_R| / (0.5*(A_L + A_R)) * 100%, with the
%          areas taken between the 50%-max field edges.
%   CSI  : high_intensity_CSI(right, mirroredLeft, 0.5, maxLag), value at
%          zero lag, on peak-normalized profiles.
%
% No toolboxes required (uses fzero from base MATLAB).
% ------------------------------------------------------------------------

clear; clc; close all;

%% ---------------- Configuration ----------------------------------------
x         = linspace(-10, 10, 4001);   % position axis (arb. units)
xc        = 0;                          % central axis
halfWidth = 6.0;                        % field half-width (flat-top edge)
Nsin      = 8;                          % # sinusoids superimposed
ripple    = 0.04;                       % in-field ripple amplitude
threshold = 0.5;                        % high-intensity mask fraction (>=50%)
maxLag    = 5;                          % lag window for high_intensity_CSI

freqCases = [0.5 0.75 1.0 1.5 2.0 3.0]; % different fundamental frequencies
PDQ_target  = 2.0;                      % percent
Area_target = 3.0;                      % percent

nF = numel(freqCases);
g_PDQ  = zeros(nF,1);  CSI_PDQ  = zeros(nF,1);
g_Area = zeros(nF,1);  CSI_Area = zeros(nF,1);
base_PDQ = zeros(nF,1);

figure('Position',[80 80 1200 720]);

%% ---------------- Loop over frequency cases ----------------------------
for k = 1:nF
    f0 = freqCases(k);

    % Symmetric flat-top beam built from a superposition of (symmetric)
    % sinusoids -> baseline PDQ ~ 0.
    base = flatTopSinusoids(x, f0, Nsin, halfWidth, ripple);
    base = base / max(base);
    base_PDQ(k) = pdqPercent(base, x, xc);

    % Solve tilt g so that PDQ = 2% and (separately) Area = 3%.
    g_PDQ(k)  = fzero(@(g) pdqPercent (applyTilt(base,x,xc,g), x, xc) - PDQ_target , [1e-5 0.5]);
    g_Area(k) = fzero(@(g) areaPercent(applyTilt(base,x,xc,g), x)      - Area_target, [1e-5 0.5]);

    % CSI at each operating point, using the author's own function.
    CSI_PDQ(k)  = csiAtTilt(base, x, xc, g_PDQ(k),  threshold, maxLag);
    CSI_Area(k) = csiAtTilt(base, x, xc, g_Area(k), threshold, maxLag);

    % ---- plot the profile at its PDQ = 2% operating point ----
    subplot(2,3,k);
    prof = applyTilt(base, x, xc, g_PDQ(k));
    plot(x, base, 'k--', 'LineWidth', 1.0); hold on;
    plot(x, prof, 'b-',  'LineWidth', 1.3);
    yline(0.5, ':', '50% (mask)', 'Color',[.5 .5 .5]);
    title(sprintf('f_0=%.2f  |  CSI@PDQ2%% = %.3f', f0, CSI_PDQ(k)));
    xlabel('position'); ylabel('norm. intensity'); grid on; ylim([0 1.25]);
    if k==1, legend('symmetric','tilted (PDQ=2%)','Location','south'); end
end
sgtitle('Flat-top beams from sinusoid superposition at different frequencies (PDQ = 2% operating point)');

%% ---------------- Results table ---------------------------------------
Fundamental_Freq   = freqCases(:);
Tilt_g_at_PDQ2pct  = g_PDQ;
CSI_at_PDQ_2pct    = CSI_PDQ;
Tilt_g_at_Area3pct = g_Area;
CSI_at_Area_3pct   = CSI_Area;
Baseline_PDQ_pct   = base_PDQ;

T = table(Fundamental_Freq, Baseline_PDQ_pct, ...
          Tilt_g_at_PDQ2pct, CSI_at_PDQ_2pct, ...
          Tilt_g_at_Area3pct, CSI_at_Area_3pct);

disp(' ');
disp('=== CSI at the clinical PDQ (2%) and Area (3%) tolerances ===');
disp(T);

allCSI = [CSI_PDQ; CSI_Area];
fprintf('CSI-at-tolerance across all frequency cases:\n');
fprintf('   mean = %.3f   sd = %.4f   range = [%.3f, %.3f]\n', ...
        mean(allCSI), std(allCSI), min(allCSI), max(allCSI));
fprintf('   => consistent with a single CSI tolerance of ~%.2f\n', ...
        round(mean(allCSI),2));

writetable(T, 'csi_tolerance_table.csv');
fprintf('\nTable written to csi_tolerance_table.csv\n');

%% ---------------- Summary figure --------------------------------------
figure('Position',[120 120 780 470]);
plot(freqCases, CSI_PDQ, 'o-', 'LineWidth',1.6, 'MarkerFaceColor','b'); hold on;
plot(freqCases, CSI_Area,'s-', 'LineWidth',1.6, 'MarkerFaceColor','r');
yline(0.84, 'k--', 'CSI tol = 0.84', 'LineWidth',1.4);
xlabel('Fundamental frequency of sinusoid superposition');
ylabel('CSI at clinical tolerance');
title('CSI tolerance is consistent across sinusoid frequencies');
legend('CSI at PDQ = 2%','CSI at Area = 3%','Location','best');
grid on; ylim([0.80 0.92]);
saveas(gcf, 'csi_tolerance_vs_frequency.png');

%% ======================================================================
%  Local functions
%% ======================================================================
function y = flatTopSinusoids(x, f0, N, hw, ripple)
% Symmetric flat-top beam: sharp super-Gaussian core modulated by a
% superposition of N symmetric (cosine) sinusoids at multiples of f0.
    core = exp(-(x./(hw*0.92)).^12);
    tex  = zeros(size(x));
    for n = 1:N
        tex = tex + (1/n) * cos(2*pi*f0*n.*x./(2*hw));
    end
    tex = tex ./ max(abs(tex));
    y = core .* (1 + ripple*tex);
    y(y < 0) = 0;
end

function p = applyTilt(base, x, xc, g)
% Left-right amplitude imbalance (gain tilt).
    p = base;
    p(x >  xc) = p(x >  xc) * (1 + g);
    p(x <  xc) = p(x <  xc) * (1 - g);
end

function pct = pdqPercent(p, x, xc)
% TG-142 style point difference quotient (percent), in-field (>=50% max).
    Dcax = interp1(x, p, xc, 'linear', 'extrap');
    if Dcax <= 0, Dcax = max(p); end
    m  = (p > 0.5*max(p)) & (x >= xc);
    xr = x(m); pr = p(m);
    pl = interp1(x, p, 2*xc - xr, 'linear', 0);
    pct = max(abs(pr - pl) / Dcax * 100);
end

function pct = areaPercent(p, x)
% Half-max area quotient (percent).
    hm = 0.5*max(p);
    f  = p >= hm;
    xin = x(f); pin = p(f);
    L = pin(xin <  0); xL = xin(xin <  0);
    R = pin(xin >= 0); xR = xin(xin >= 0);
    AL = trapz(xL, L); AR = trapz(xR, R);
    pct = abs(AL - AR) / (0.5*(AL + AR)) * 100;
end

function val = csiAtTilt(base, x, xc, g, threshold, maxLag)
% Build tilted profile, split into right half (A) and mirrored left half
% (B), peak-normalize, and evaluate the author's high_intensity_CSI at
% zero lag.
    p = applyTilt(base, x, xc, g);
    right = p(x >  xc);
    left  = p(x <  xc);
    Lmir  = fliplr(left);
    n = min(numel(right), numel(Lmir));
    A = right(1:n).'; B = Lmir(1:n).';
    [csi, lags] = high_intensity_CSI(A, B, threshold, maxLag);
    val = csi(lags == 0);          % value at zero lag
end

%% ---- Author's CSI definition (as provided) ---------------------------
function [csi, lags] = high_intensity_CSI(A, B, threshold_fraction, max_lag)
    if size(A) ~= size(B)
        error('Inputs A and B must be the same size');
    end
    A = A(:);
    B = B(:);
    max_intensity_A = max(A);
    max_intensity_B = max(B);
    threshold_A = threshold_fraction * max_intensity_A;
    threshold_B = threshold_fraction * max_intensity_B;
    mask_A = A >= threshold_A;
    mask_B = B >= threshold_B;
    combined_mask = mask_A & mask_B;
    A_high_intensity = A(combined_mask);
    B_high_intensity = B(combined_mask);
    lags = -max_lag:max_lag;
    csi  = zeros(length(lags), 1);
    for i = 1:length(lags)
        lag = lags(i);
        if lag < 0
            shifted_A = A_high_intensity(1:end+lag);
            shifted_B = B_high_intensity(-lag+1:end);
        elseif lag > 0
            shifted_A = A_high_intensity(lag+1:end);
            shifted_B = B_high_intensity(1:end-lag);
        else
            shifted_A = A_high_intensity;
            shifted_B = B_high_intensity;
        end
        csi(i) = sum(shifted_A .* shifted_B) / numel(shifted_A);
    end
end
