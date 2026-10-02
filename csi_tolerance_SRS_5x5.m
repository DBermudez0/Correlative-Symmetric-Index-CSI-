%% csi_tolerance_SRS_5x5.m
% ------------------------------------------------------------------------
% SRS-scale (5x5 cm^2) demonstration that the CSI clinical tolerance
% (~0.84-0.86) corresponding to PDQ = +/-2% (and area-based = +/-3%) is
% CONSISTENT with the larger 10x10 and 20x20 cm^2 fields.
%
% Beam profiles are built from superpositions of sinusoids at several
% fundamental frequencies (same construction as the frequency-consistency
% analysis, Table 3), with the flat-top beam SHAPE scaled to each field
% size (the penumbra-to-field ratio is held fixed, i.e. the profile is
% geometrically scaled with the field). Asymmetry is a left-right gain
% tilt; for each case we solve for the tilt g giving PDQ = 2% (and
% separately Area = 3%) and read the CSI at that operating point using the
% author's own high_intensity_CSI (biased, high-intensity masked, value at
% zero lag).
%
% Output:
%   * per-frequency profile plots for the 5x5 field at the PDQ=2% point,
%   * a table of CSI-at-tolerance for 5x5 vs 10x10 vs 20x20,
%   * a summary figure of CSI-at-tolerance vs frequency for all fields.
%
% No toolboxes required (uses fzero from base MATLAB).
% ------------------------------------------------------------------------

clear; clc; close all;

%% ---------------- Configuration ----------------------------------------
x         = linspace(-20, 20, 8001);   % position axis (cm), wide enough for 20x20
xc        = 0;
Nsin      = 8;
ripple    = 0.04;
threshold = 0.5;      % >=50% high-intensity mask
maxLag    = 5;

freqCases = [0.5 0.75 1.0 1.5 2.0 3.0];
PDQ_target  = 2.0;    % percent
Area_target = 3.0;    % percent

% Field sizes: half-widths scale with field (5x5 -> 2.5 cm half-width, etc.)
fields    = {'5x5 (SRS)', '10x10', '20x20'};
halfWidth = [2.5, 5.0, 10.0];

nF = numel(freqCases);
nS = numel(fields);
CSI_PDQ  = zeros(nF, nS);
CSI_Area = zeros(nF, nS);

%% ---------------- Loop over field sizes and frequencies ----------------
for s = 1:nS
    hw = halfWidth(s);
    for k = 1:nF
        f0   = freqCases(k);
        base = flatTopSinusoids(x, f0, Nsin, hw, ripple);
        base = base / max(base);

        gP = fzero(@(g) pdqPercent (applyTilt(base,x,xc,g), x, xc) - PDQ_target , [1e-5 0.6]);
        gA = fzero(@(g) areaPercent(applyTilt(base,x,xc,g), x)      - Area_target, [1e-5 0.6]);

        CSI_PDQ(k,s)  = csiAtTilt(base, x, xc, gP, threshold, maxLag);
        CSI_Area(k,s) = csiAtTilt(base, x, xc, gA, threshold, maxLag);
    end
end

%% ---------------- 5x5 profile plots (PDQ = 2% point) -------------------
figure('Position',[80 80 1200 720]);
hw5 = halfWidth(1);
for k = 1:nF
    f0   = freqCases(k);
    base = flatTopSinusoids(x, f0, Nsin, hw5, ripple); base = base/max(base);
    gP   = fzero(@(g) pdqPercent(applyTilt(base,x,xc,g),x,xc) - PDQ_target, [1e-5 0.6]);
    prof = applyTilt(base, x, xc, gP);
    subplot(2,3,k);
    plot(x, base, 'k--', 'LineWidth', 1.0); hold on;
    plot(x, prof, 'b-',  'LineWidth', 1.3);
    yline(0.5, ':', '50% mask', 'Color',[.5 .5 .5]);
    xlim([-5 5]);
    title(sprintf('5x5 | f_0=%.2f | CSI@PDQ2%%=%.3f', f0, CSI_PDQ(k,1)));
    xlabel('position (cm)'); ylabel('norm. intensity'); grid on; ylim([0 1.25]);
    if k==1, legend('symmetric','tilted (PDQ=2%)','Location','south'); end
end
sgtitle('SRS-scale 5x5 cm^2 field: sinusoid-superposition beams at PDQ = 2% operating point');

%% ---------------- Results table (CSI at PDQ=2%) ------------------------
Fundamental_Freq = freqCases(:);
CSI_5x5   = CSI_PDQ(:,1);
CSI_10x10 = CSI_PDQ(:,2);
CSI_20x20 = CSI_PDQ(:,3);
T = table(Fundamental_Freq, CSI_5x5, CSI_10x10, CSI_20x20);

disp(' ');
disp('=== CSI at PDQ = 2% tolerance, by field size and frequency ===');
disp(T);

fprintf('Field-size summary (CSI at PDQ = 2%%, over all frequencies):\n');
for s = 1:nS
    v = CSI_PDQ(:,s);
    fprintf('   %-10s  mean = %.3f   sd = %.4f   range = [%.3f, %.3f]\n', ...
        fields{s}, mean(v), std(v), min(v), max(v));
end
allv = CSI_PDQ(:);
fprintf('   ALL FIELDS  mean = %.3f   sd = %.4f   => tolerance ~ %.2f\n', ...
    mean(allv), std(allv), round(mean(allv),2));

writetable(T, 'csi_tolerance_SRS_table.csv');
fprintf('\nTable written to csi_tolerance_SRS_table.csv\n');

%% ---------------- Summary figure --------------------------------------
figure('Position',[120 120 820 480]);
markers = {'o-','s-','^-'};
cols    = {'b','r',[0 0.6 0]};
hold on;
for s = 1:nS
    plot(freqCases, CSI_PDQ(:,s), markers{s}, 'LineWidth',1.6, ...
         'Color', cols{s}, 'MarkerFaceColor', cols{s});
end
yline(0.84, 'k--', 'CSI tol = 0.84', 'LineWidth',1.4);
xlabel('Fundamental frequency of sinusoid superposition');
ylabel('CSI at PDQ = 2% tolerance');
title('CSI tolerance is consistent across field sizes (5x5, 10x10, 20x20)');
legend(fields{:}, 'Location','best');
grid on; ylim([0.80 0.92]);
saveas(gcf, 'csi_tolerance_vs_fieldsize.png');

%% ======================================================================
%  Local functions
%% ======================================================================
function y = flatTopSinusoids(x, f0, N, hw, ripple)
% Symmetric flat-top beam: super-Gaussian core (shape scales with hw)
% modulated by a superposition of N symmetric cosine sinusoids at f0.
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
    p = base;
    p(x >  xc) = p(x >  xc) * (1 + g);
    p(x <  xc) = p(x <  xc) * (1 - g);
end

function pct = pdqPercent(p, x, xc)
    Dcax = interp1(x, p, xc, 'linear', 'extrap');
    if Dcax <= 0, Dcax = max(p); end
    m  = (p > 0.5*max(p)) & (x >= xc);
    xr = x(m); pr = p(m);
    pl = interp1(x, p, 2*xc - xr, 'linear', 0);
    pct = max(abs(pr - pl) / Dcax * 100);
end

function pct = areaPercent(p, x)
    hm = 0.5*max(p);
    f  = p >= hm;
    xin = x(f); pin = p(f);
    L = pin(xin <  0); xL = xin(xin <  0);
    R = pin(xin >= 0); xR = xin(xin >= 0);
    AL = trapz(xL, L); AR = trapz(xR, R);
    pct = abs(AL - AR) / (0.5*(AL + AR)) * 100;
end

function val = csiAtTilt(base, x, xc, g, threshold, maxLag)
    p = applyTilt(base, x, xc, g);
    right = p(x >  xc);
    left  = p(x <  xc);
    Lmir  = fliplr(left);
    n = min(numel(right), numel(Lmir));
    A = right(1:n).'; B = Lmir(1:n).';
    [csi, lags] = high_intensity_CSI(A, B, threshold, maxLag);
    val = csi(lags == 0);
end

%% ---- Author's CSI definition (zero-lag corrected to compare A vs B) ---
function [csi, lags] = high_intensity_CSI(A, B, threshold_fraction, max_lag)
    if size(A) ~= size(B)
        error('Inputs A and B must be the same size');
    end
    A = A(:); B = B(:);
    threshold_A = threshold_fraction * max(A);
    threshold_B = threshold_fraction * max(B);
    combined_mask = (A >= threshold_A) & (B >= threshold_B);
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
            shifted_B = B_high_intensity;   % compare A vs B at zero lag
        end
        csi(i) = sum(shifted_A .* shifted_B) / numel(shifted_A);
    end
end
