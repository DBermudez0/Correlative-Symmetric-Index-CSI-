%% csi_shift_sensitivity.m
% ------------------------------------------------------------------------
% Sub-millimeter central-axis centering test.
%
% Takes a symmetric beam profile, shifts it by 0.1-1.0 mm, and shows that
% the Correlative Symmetric Index (CSI) is STABLE against a small centering
% error while PDQ and the area-based quotient degrade rapidly. This
% supports the manuscript's statement that CSI's shift-awareness comes from
% evaluating the cross-correlation at its most significant (peak) lag: a
% pure translation moves the correlation peak to the corresponding lag
% rather than registering as an artificial loss of symmetry.
%
% Beam model: realistic flat-top with erf (error-function) penumbra edges.
% Axis and shifts are in millimetres. CSI uses the author's own
% high_intensity_CSI (biased, high-intensity masked); here we report the
% PEAK value over the searched lags (see csiPeak), consistent with the
% methodology described in the manuscript.
%
% Metrics
%   PDQ  (TG-142 style): max over in-field (>=50%) matched mirror points of
%          |D(x) - D(-x)| / D(CAX) * 100%.
%   Area (half-max):     |A_L - A_R| / (0.5*(A_L + A_R)) * 100%.
%   CSI  : peak of high_intensity_CSI(right, mirroredLeft, 0.5, maxLag),
%          normalized to a correlation-coefficient form for interpretability.
%
% No toolboxes required (uses erf from base MATLAB and fzero not needed).
% ------------------------------------------------------------------------

clear; clc; close all;

%% ---------------- Configuration ----------------------------------------
dx        = 0.1;                 % sampling [mm] (fine enough for sub-mm shift)
x         = (-90:dx:90).';       % position axis [mm]
xc        = 0;                   % central axis
halfWidth = 50.0;                % field half-width [mm]  (10x10 cm^2 field)
penumbra  = 1.5;                 % penumbra sigma [mm]    (realistic 6 MV)
threshold = 0.5;                 % high-intensity mask (>=50% of max)
maxLag_mm = 3.0;                 % lag search window [mm]

shifts_mm = [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0];

% Clinical tolerances (for reference lines)
PDQ_tol  = 2.0;   % percent
Area_tol = 3.0;   % percent

%% ---------------- Symmetric base profile -------------------------------
base = erfFlatTop(x, halfWidth, penumbra);
base = base / max(base);

%% ---------------- Sweep the shift --------------------------------------
nS = numel(shifts_mm);
PDQ     = zeros(nS,1);
Area    = zeros(nS,1);
CSI     = zeros(nS,1);   % peak over lags
CSIz0   = zeros(nS,1);   % zero lag

for i = 1:nS
    p = shiftProfile(base, x, shifts_mm(i));
    PDQ(i)   = pdqPercent(p, x, xc);
    Area(i)  = areaPercent(p, x);
    [CSI(i), CSIz0(i)] = csiPeakAndZero(p, x, xc, threshold, maxLag_mm, dx);
end

%% ---------------- Results table ---------------------------------------
Shift_mm     = shifts_mm(:);
PDQ_pct      = PDQ;
Area_pct     = Area;
CSI_peak     = CSI;
CSI_zerolag  = CSIz0;
T = table(Shift_mm, PDQ_pct, Area_pct, CSI_peak, CSI_zerolag);
disp(' ');
disp('=== Metric response to sub-millimeter centering shift ===');
disp(T);

fprintf('CSI (peak over lags): min = %.4f, max = %.4f, range = %.4f\n', ...
        min(CSI), max(CSI), max(CSI)-min(CSI));
fprintf('CSI (zero lag)      : min = %.4f, max = %.4f, range = %.4f\n', ...
        min(CSIz0), max(CSIz0), max(CSIz0)-min(CSIz0));
fprintf('PDQ exceeds its %.0f%% tolerance by a shift of %.2f mm\n', ...
        PDQ_tol, firstCrossing(shifts_mm, PDQ, PDQ_tol));
fprintf('Area exceeds its %.0f%% tolerance by a shift of %.2f mm\n', ...
        Area_tol, firstCrossing(shifts_mm, Area, Area_tol));

writetable(T, 'csi_shift_sensitivity_table.csv');
fprintf('\nTable written to csi_shift_sensitivity_table.csv\n');

%% ---------------- Figure ----------------------------------------------
figure('Position',[100 100 1150 460]);

% Left: metric values vs shift (PDQ/Area on left axis, CSI on right axis)
subplot(1,2,1);
yyaxis left;
plot(shifts_mm, PDQ,  'o-', 'LineWidth',1.7); hold on;
plot(shifts_mm, Area, 's-', 'LineWidth',1.7);
yline(PDQ_tol,  ':',  'PDQ tol 2%');
yline(Area_tol, '-.', 'Area tol 3%');
ylabel('PDQ / Area asymmetry (%)');
yyaxis right;
plot(shifts_mm, CSI,   '^-', 'LineWidth',1.8, 'MarkerFaceColor','auto'); hold on;
plot(shifts_mm, CSIz0, 'v--','LineWidth',1.4);
ylabel('CSI'); ylim([0.80 1.02]);
xlabel('Central-axis shift (mm)');
title('Metric response to sub-mm centering error');
legend('PDQ','Area','','','CSI (peak lag)','CSI (zero lag)','Location','east');
grid on;

% Right: illustrate the shifted profiles
subplot(1,2,2);
plot(x, base, 'k-', 'LineWidth',1.4); hold on;
plot(x, shiftProfile(base,x,0.5), 'b--', 'LineWidth',1.2);
plot(x, shiftProfile(base,x,1.0), 'r:',  'LineWidth',1.2);
xlim([-70 70]);
xlabel('position (mm)'); ylabel('norm. intensity');
title('Symmetric profile and shifted versions');
legend('symmetric (0 mm)','shift 0.5 mm','shift 1.0 mm','Location','south');
grid on;

saveas(gcf, 'csi_shift_sensitivity.png');

%% ======================================================================
%  Local functions
%% ======================================================================
function y = erfFlatTop(x, hw, pen)
% Flat-top beam with error-function penumbra edges at +/- hw.
    y = 0.5*( erf((x+hw)./(sqrt(2)*pen)) - erf((x-hw)./(sqrt(2)*pen)) );
    y(y < 0) = 0;
end

function p = shiftProfile(base, x, d_mm)
% Translate the profile by d_mm (positive = shift toward +x).
    p = interp1(x, base, x - d_mm, 'linear', 0);
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

function [valPeak, valZero] = csiPeakAndZero(p, x, xc, threshold, maxLag_mm, dx)
% Right half (A) vs mirrored left half (B). Returns the PEAK of
% high_intensity_CSI over the lag window (shift-aware) and the ZERO-LAG
% value (no lag search), both correlation-coefficient normalized.
    right = p(x >  xc);
    left  = p(x <  xc);
    Lmir  = flipud(left);
    n = min(numel(right), numel(Lmir));
    A = right(1:n); B = Lmir(1:n);
    maxLag = round(maxLag_mm / dx);
    [csi, lags] = high_intensity_CSI_norm(A, B, threshold, maxLag);
    valPeak = max(csi);                 % most significant (peak) lag
    valZero = csi(lags == 0);           % zero lag
end

%% ---- Author's CSI (biased, masked) with correlation-coefficient
%%      normalization so the peak value is bounded and interpretable.
%%      Zero-lag corrected to compare A vs B. ---------------------------
function [csi, lags] = high_intensity_CSI_norm(A, B, threshold_fraction, max_lag)
    if size(A) ~= size(B)
        error('Inputs A and B must be the same size');
    end
    A = A(:); B = B(:);
    threshold_A = threshold_fraction * max(A);
    threshold_B = threshold_fraction * max(B);
    combined_mask = (A >= threshold_A) & (B >= threshold_B);
    Ah = A(combined_mask);
    Bh = B(combined_mask);
    lags = -max_lag:max_lag;
    csi  = zeros(length(lags), 1);
    for i = 1:length(lags)
        lag = lags(i);
        if lag < 0
            a = Ah(1:end+lag);   b = Bh(-lag+1:end);
        elseif lag > 0
            a = Ah(lag+1:end);   b = Bh(1:end-lag);
        else
            a = Ah;              b = Bh;
        end
        if numel(a) < 3
            csi(i) = -Inf; continue;
        end
        num = sum(a .* b) / numel(a);
        den = sqrt( (sum(a.^2)/numel(a)) * (sum(b.^2)/numel(b)) );
        if den > 0, csi(i) = num/den; else, csi(i) = 0; end
    end
end

function xc = firstCrossing(shifts, vals, tol)
% First shift (mm) at which vals exceeds tol (linear interp); NaN if never.
    idx = find(vals(:).' > tol, 1, 'first');
    if isempty(idx), xc = NaN; return; end
    if idx == 1, xc = shifts(1); return; end
    x1 = shifts(idx-1); x2 = shifts(idx);
    y1 = vals(idx-1);   y2 = vals(idx);
    xc = x1 + (tol - y1) * (x2 - x1) / (y2 - y1);
end
