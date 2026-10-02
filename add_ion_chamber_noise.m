function [y, noise, info] = add_ion_chamber_noise(x, varargin)
%ADD_ION_CHAMBER_NOISE  Add physically-modeled ionization-chamber noise to a signal.
%
%   [y, noise, info] = add_ion_chamber_noise(x, 'Name', Value, ...)
%
%   Models ion-chamber / electrometer noise as a WHITE floor (Johnson-Nyquist
%   thermal + shot noise) plus a 1/f (flicker) component that dominates below a
%   knee frequency:   S(f) = S0 + k/f ,   k = S0 * f_knee.
%   Gaussian white noise is shaped by a zero-phase FIR filter to this spectrum,
%   scaled to a requested level, and added to x. The realized SNR is returned.
%
%   INPUT
%     x            : input signal (vector). NaNs are treated as 0 for power calc.
%
%   NAME-VALUE PARAMETERS (all optional)
%     'Fs'         : sampling rate [Hz]           (default 1000)
%     'S0'         : white PSD floor [arb^2/Hz]   (default 1.0)
%     'Fknee'      : 1/f knee frequency [Hz]      (default 5.0)
%                    Below Fknee the 1/f term dominates; above it, white.
%     'FIRorder'   : FIR shaping-filter order      (default 200)
%     'Level'      : how to set the noise magnitude (default 'snr')
%                       'snr'  -> scale noise to hit 'TargetSNR' (dB)
%                       'rms'  -> set noise RMS to 'NoiseRMS'
%                       'raw'  -> use the filter's natural scale (no rescale)
%     'TargetSNR'  : desired SNR in dB (used if Level='snr')  (default 20)
%     'NoiseRMS'   : noise RMS in signal units (used if Level='rms') (default 0.1)
%     'Seed'       : RNG seed for reproducibility (default [] = don't set)
%     'Plot'       : true/false, show signal/noise/PSD figure (default false)
%
%   OUTPUT
%     y     : x + noise  (same shape as x)
%     noise : the colored noise that was added
%     info  : struct with fields:
%               .SNR_dB, .SNR_linear   - realized signal-to-noise ratio
%               .signal_power, .noise_power
%               .Fs, .S0, .Fknee, .k, .b (filter taps), .params
%
%   EXAMPLES
%     y = add_ion_chamber_noise(sig, 'TargetSNR', 15);           % 15 dB SNR
%     [y,n,info] = add_ion_chamber_noise(sig, 'Level','rms', 'NoiseRMS', 0.05);
%     add_ion_chamber_noise(sig, 'Fknee', 10, 'Plot', true);     % inspect

    % ---------- parse inputs ----------
    p = inputParser;
    p.addRequired('x', @(v) isnumeric(v) && isvector(v));
    p.addParameter('Fs', 1000, @(v) isscalar(v) && v>0);
    p.addParameter('S0', 1.0,  @(v) isscalar(v) && v>0);
    p.addParameter('Fknee', 5.0, @(v) isscalar(v) && v>=0);
    p.addParameter('FIRorder', 200, @(v) isscalar(v) && v>=4);
    p.addParameter('Level', 'snr', @(s) any(strcmpi(s,{'snr','rms','raw'})));
    p.addParameter('TargetSNR', 20, @isscalar);
    p.addParameter('NoiseRMS', 0.1, @(v) isscalar(v) && v>=0);
    p.addParameter('Seed', [], @(v) isempty(v) || isscalar(v));
    p.addParameter('Plot', false, @islogical);
    p.parse(x, varargin{:});
    R = p.Results;

    if ~isempty(R.Seed), rng(R.Seed); end
    xrow = x(:).';                 % work as row; remember orientation
    was_col = iscolumn(x);
    N  = numel(xrow);
    Fs = R.Fs;

    % ---------- design zero-phase FIR shaping filter to sqrt(S(f)) ----------
    % filtfilt applies |H|^2, so target A = S^(1/4) makes realized POWER ~ S(f).
    Nf   = max(256, 2*R.FIRorder);
    f    = linspace(0, Fs/2, Nf);
    fpos = f; fpos(1) = f(2);                 % avoid /0 at DC
    if R.Fknee > 0
        k = R.S0 * R.Fknee;                   % 1/f strength
        Spow = R.S0 + k ./ fpos;
    else
        k = 0;
        Spow = R.S0 * ones(size(fpos));       % pure white if Fknee=0
    end
    A  = Spow.^(0.25);
    A  = A / max(A);
    fn = f / (Fs/2);
    b  = firls(R.FIRorder, fn, A);

    % ---------- generate & shape Gaussian noise ----------
    ns    = randn(1, N);                       % zero-mean Gaussian (NOT rand)
    noise = filtfilt(b, 1, ns);                % zero-phase colored noise
    if std(noise) > 0, noise = noise - mean(noise); end

    % ---------- scale noise to requested level ----------
    xclean = xrow; xclean(isnan(xclean)) = 0;
    signal_power = mean(xclean.^2);            % mean-square (power)

    switch lower(R.Level)
        case 'snr'
            % choose noise power so that 10*log10(Psig/Pnoise) = TargetSNR
            target_np = signal_power / (10^(R.TargetSNR/10));
            cur_np    = mean(noise.^2);
            if cur_np > 0
                noise = noise * sqrt(target_np / cur_np);
            end
        case 'rms'
            cur_rms = std(noise);
            if cur_rms > 0
                noise = noise * (R.NoiseRMS / cur_rms);
            end
        case 'raw'
            % leave as-is (filter's natural amplitude)
    end

    % ---------- add & compute realized SNR ----------
    y = xrow + noise;
    noise_power = mean(noise.^2);
    if noise_power > 0
        snr_lin = signal_power / noise_power;
    else
        snr_lin = Inf;
    end
    snr_db = 10*log10(snr_lin);

    % restore original orientation
    if was_col, y = y(:); noise = noise(:); end

    % ---------- pack info ----------
    info = struct();
    info.SNR_dB        = snr_db;
    info.SNR_linear    = snr_lin;
    info.signal_power  = signal_power;
    info.noise_power   = noise_power;
    info.Fs            = Fs;
    info.S0            = R.S0;
    info.Fknee         = R.Fknee;
    info.k             = k;
    info.b             = b;
    info.params        = R;

    fprintf('add_ion_chamber_noise: Fknee=%.2f Hz, S0=%.3g, level=%s -> SNR = %.2f dB (%.3g linear)\n', ...
            R.Fknee, R.S0, R.Level, snr_db, snr_lin);

    % ---------- optional plot ----------
    if R.Plot
        t = (0:N-1)/Fs;
        figure('Color','w','Position',[100 100 1150 700]);
        BLUE=[0.094 0.408 0.651]; RED=[0.639 0.176 0.176]; GRAY=[0.5 0.5 0.5];

        subplot(2,2,1);
        plot(t, xclean, 'Color', GRAY, 'LineWidth',1); grid on;
        xlabel('Time (s)'); ylabel('Amplitude'); title('Clean signal');

        subplot(2,2,2);
        plot(t, y, 'Color', BLUE, 'LineWidth',0.8); grid on;
        xlabel('Time (s)'); ylabel('Amplitude');
        title(sprintf('Signal + ion-chamber noise (SNR = %.1f dB)', snr_db));

        subplot(2,2,3);
        plot(t, noise, 'Color', RED, 'LineWidth',0.8); grid on;
        xlabel('Time (s)'); ylabel('Amplitude'); title('Added noise');

        subplot(2,2,4);
        seg = min(N, max(256, 2^floor(log2(N/8))));
        [pxx, fpxx] = pwelch(noise, hamming(seg), [], [], Fs);
        loglog(fpxx, pxx, 'Color', BLUE, 'LineWidth',1.2); hold on;
        m = fpxx>0; tgt = R.S0 + k./fpxx(m); tgt = tgt*(median(pxx(m))/median(tgt));
        loglog(fpxx(m), tgt, '--', 'Color', RED, 'LineWidth',1.4);
        if R.Fknee>0, xline(R.Fknee, ':', 'Color', GRAY, 'LineWidth',1); end
        grid on; xlabel('Frequency (Hz)'); ylabel('PSD');
        title('Noise PSD: white + 1/f'); legend({'realized','target S_0+k/f','f_{knee}'},'Location','southwest');

        sgtitle('add\_ion\_chamber\_noise');
    end
end
