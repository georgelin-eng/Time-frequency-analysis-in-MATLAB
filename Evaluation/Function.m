x = data;
NFFT = FFT_size;
w = hanning (NFFT);
noverlap = NFFT*0.50;

f = @()  spec(x, NFFT, Fs, Overlap);
s = @() spectrogram(x,hanning (NFFT),floor(NFFT*0.50),NFFT,Fs, 'yaxis');


t = timeit(s)

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
