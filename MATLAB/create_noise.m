function [] = create_noise(type, b, a)

fs = 16000; % sampling frequency
T = 10; % duration in seconds
x = 2*rand(fs*T,1)-1; % zero-mean uniformly distributed noise
x = x*0.95; % reduce the amplitude of x to 95% of full scale

recorder = audiorecorder(fs, 16, 2); % create a recorder object

sound(x, fs);record(recorder, 5);

%note, right channel is filtered
pause(15);

%grab sound from recorder object
y = getaudiodata(recorder);

if strcmp(type, 'FIR')
    % estimate spectrum of unfiltered output
    [Px,f] = pwelch(x,1024,512,1024,fs);
    % estimate spectrum of filtered output
    [Py,f] = pwelch(y(:,2),1024,512,1024,fs);
    % plot spectra in dB with grid lines
    plot(f/1000,10*log10(Px),f/1000,10*log10(Py)); grid;
    figure(1);
    title('Direct form I – FIR');
    xlabel('frequency (kHz)');
    ylabel('magnitude response (dB)');
   
    figure(2);
    %[h, t] = impz(b, a, [], fs);
    [h1, w1] = freqz(b, a, fs);
    
    subplot(3, 1, 1);
    impz(b, a, [], fs); grid;
    title('Direct form I - FIR Impulse Reponse');
    xlabel('nT (Seconds)');
    ylabel('Magnitude (dB)');
    subplot(3, 1, 2);
    plot((w1*(fs/(2*pi)))/1e3, 20*log10(abs(h1))); grid;
    title('Direct form I - FIR Magnitude Response');
    xlabel('Frequency (kHz)');
    ylabel('Magnitude (dB)');
    subplot(3, 1, 3);
    plot((w1*(fs/(2*pi)))/1e3, unwrap(angle(h1))/2);grid;
    title('Direct form I - FIR Phase Response');
    xlabel('Frequency (kHz)');
    ylabel('Phase (radians)');
   
end

if strcmp(type, 'IIR1')
    % estimate spectrum of unfiltered output
    [Px,f] = pwelch(x,1024,512,1024,fs);
    % estimate spectrum of filtered output
    [Py,f] = pwelch(y(:,2),1024,512,1024,fs);
    % plot spectra in dB with grid lines
    plot(f/1000,10*log10(Px),f/1000,10*log10(Py)); grid;
    title('Direct form II – IIR');
    xlabel('frequency (kHz)');
    ylabel('magnitude response (dB)');
end

if strcmp(type, 'IIR2')
    % estimate spectrum of unfiltered output
    [Px,f] = pwelch(x,1024,512,1024,fs);
    % estimate spectrum of filtered output
    [Py,f] = pwelch(y(:,2),1024,512,1024,fs);
    % plot spectra in dB with grid lines
    plot(f/1000,10*log10(Px),f/1000,10*log10(Py)); grid;
    title('Direct form II SOS – IIR');
    xlabel('frequency (kHz)');
    ylabel('magnitude response (dB)');
end

end