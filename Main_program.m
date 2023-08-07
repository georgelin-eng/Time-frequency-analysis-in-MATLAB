clear, clc

% Load sound data
[data,Fs] = audioread("Audio_sweep.mp3");
data = data (:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% STFT Parameters

window_size = 4096;
FFT_size = window_size;
Overlap = 0.5;

% Aduio parameters
%   min_amplitude - sounds below this level(dB) are set to this value
%   freqMax - truncates values after this amount

min_amplitude = 50;
freqMax = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amplitude,freqVec,timeVec, del_freq] = spec(data, FFT_size, Fs, Overlap);

amplitude = 10 * log10(amplitude/min_amplitude);
amplitude(amplitude < -min_amplitude) = -min_amplitude;

if freqMax > 0
    cutoff = floor(freqMax / (Fs/2) * length(freqVec) + 1);
    freqVec = freqVec (1:cutoff);
    amplitude = amplitude(1:cutoff,:);
end

% Graphing data
colormap('jet')
imagesc(timeVec,flipud(freqVec), amplitude) 
title("My Spectrogram: \Delta f = " + del_freq + "Hz")
xlabel('Time (s)'); ylabel('Frequency (Hz)')
set(gca,'YDir','normal')

colorbar()
h = colorbar;
h.Label.String = "Amplitude (dB)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function definition
%   x  - Input data
%   NFFT  - FFT length
%   Fs - Sample frequency (Hz)
%   Overlap - buffer overlap 
%   Energy loss term - corrects for the energy lost due to windowing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function  [amp, freq, time, freq_increment] = spec(x, NFFT, Fs, Overlap)
    energy_loss_correction = 2;
    
    % Compute windows to analyze
    num_windows = floor((length(x) - NFFT) / (NFFT * (1 - Overlap)) + 1);

    w = hanning(NFFT);
    amp = zeros(NFFT/2, num_windows);

    for k = 1:num_windows
        start_value = 1 + floor((1-Overlap) * NFFT * (k-1));
        windowed_signal =  x(start_value:start_value + NFFT - 1) .* w;
        fft_output = abs(fft(windowed_signal)) * energy_loss_correction;
        amp(:,k) = fft_output(1:NFFT/2); % Take first half of the FFT output
    end
    
    max_freq = Fs/2;
    freq_increment = max_freq / (NFFT/2);
    freq = 1:freq_increment:max_freq;
    
    end_time = length(x)/Fs;
    time_increment = end_time/num_windows;
    time = 0:time_increment:end_time;
end



