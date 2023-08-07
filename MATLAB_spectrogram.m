clear, clc

% Load data
[data,Fs] = audioread('Audio_sweep.mp3');
data = data (:,1);

NFFT = 4096;
window = 4096;
overlap = floor(window * 0.5);

[sg,fsg,tsg] = spectrogram(data,hanning(NFFT),floor(NFFT*0.50),NFFT,Fs, 'yaxis');

min_amplitude = 50;
amplitude = 10 * log10(abs(sg)/min_amplitude);
amplitude(amplitude < -min_amplitude) = -min_amplitude;

del_freq = fsg(2) - fsg(1);

% plots spectrogram
colormap jet
imagesc(tsg,fsg,amplitude); %time, frequency, colourS
axis('xy');
xlabel('Time (s)');ylabel('Frequency (Hz)');
title("MATLAB Spectrogram: \Delta f = " + del_freq + "Hz")

colorbar('vert');
colorbar()
h = colorbar;
h.Label.String = "Amplitude (dB)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";