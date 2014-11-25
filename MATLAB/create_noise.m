%this function takes in a string, and four other arguments
%b, a - quantized coefficients from fdatool
%B, A - non-quantized coefficients from fdatool
%sos - quantized SOS coefficients
%SOS - non-quantized SOS coefficients
function [] = create_noise(type)%, b, a, B, A, sos, SOS)

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
% Y = y(:,2);
% X = x;

%clear any existing figures
clf;

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
   
%     figure(2);
%     [h1, w1] = freqz(b, a, fs);
%     [H1, W1] = freqz(B, A, fs);
%     
%     %plot impulse response
%     subplot(3, 1, 1);
%     impz(b, a, [], fs); grid;
%     title('Direct form I - FIR Impulse Reponse');
%     xlabel('nT (Seconds)');
%     ylabel('Magnitude (dB)');
%     legend('Quantized Coefficients');
%     
%     %plot magnitude response
%     subplot(3, 1, 2);
%     hold on;
%     plot((w1*(fs/(2*pi)))/1e3, (20*log10(abs(h1)) - 50)); grid;
%     plot((W1*(fs/(2*pi)))/1e3, 20*log10(abs(H1)), 'r');
%     axis([0 8 -140 10]);
%     title('Direct form I - FIR Magnitude Response');
%     xlabel('Frequency (kHz)');
%     ylabel('Magnitude (dB)');
%     legend('Quantized Coefficients', 'Non-Quantized Coefficients');
%     
%     %plot phase response
%     subplot(3, 1, 3);
%     hold on;
%     plot((w1*(fs/(2*pi)))/1e3, unwrap(angle(h1))/2); grid;
%     plot((W1*(fs/(2*pi)))/1e3, unwrap(angle(H1))/2, 'r');
%     title('Direct form I - FIR Phase Response');
%     xlabel('Frequency (kHz)');
%     ylabel('Phase (radians)');
%     legend('Quantized Coefficients', 'Non-Quantized Coefficients');

elseif strcmp(type, 'IIR1')
    % estimate spectrum of unfiltered output
    [Px,f] = pwelch(x,1024,512,1024,fs);
    % estimate spectrum of filtered output
    [Py,f] = pwelch(y(:,2),1024,512,1024,fs);
    % plot spectra in dB with grid lines
    plot(f/1000,10*log10(Px),f/1000,10*log10(Py)); grid;
    title('Direct form II – IIR');
    xlabel('frequency (kHz)');
    ylabel('magnitude response (dB)');
    
    %now do some plotting
    figure(2);
    [h1, w1] = freqz(b, a, fs);
    [H1, W1] = freqz(B, A, fs);
    
    %plot impulse response
    subplot(3, 1, 1);
    impz(b, a, [], fs); grid;
    title('Direct form II - IIR Impulse Reponse');
    xlabel('nT (Seconds)');
    ylabel('Magnitude (dB)');
    legend('Quantized Coefficients');
    
    %plot magnitude response
    subplot(3, 1, 2);
    hold on;
    plot((w1*(fs/(2*pi)))/1e3, (20*log10(abs(h1)) - 50)); grid;
    plot((W1*(fs/(2*pi)))/1e3, 20*log10(abs(H1)), 'r');
    axis([0 8 -140 10]);
    title('Direct form II - IIR Magnitude Response');
    xlabel('Frequency (kHz)');
    ylabel('Magnitude (dB)');
    legend('Quantized Coefficients', 'Non-Quantized Coefficients');
    
    %plot phase response
    subplot(3, 1, 3);
    hold on;
    plot((w1*(fs/(2*pi)))/1e3, unwrap(angle(h1))/2);grid;
    plot((W1*(fs/(2*pi)))/1e3, unwrap(angle(H1))/2, 'r');
    title('Direct form II - IIR Phase Response');
    xlabel('Frequency (kHz)');
    ylabel('Phase (radians)');
    legend('Quantized Coefficients', 'Non-Quantized Coefficients');

elseif strcmp(type, 'IIR2')
    % estimate spectrum of unfiltered output
    [Px,f] = pwelch(x,1024,512,1024,fs);
    % estimate spectrum of filtered output
    [Py,f] = pwelch(y(:,2),1024,512,1024,fs);
    % plot spectra in dB with grid lines
    plot(f/1000,10*log10(Px),f/1000,10*log10(Py)); grid;
    title('Direct form II SOS – IIR');
    xlabel('frequency (kHz)');
    ylabel('magnitude response (dB)');
    
    %now do some plotting
    figure(2);
    [h1, w1] = freqz(sos, fs);
    [H1, W1] = freqz(SOS, fs);
    
    %plot impulse response
    subplot(3, 1, 1);
    impz(sos, [], fs); grid;
    title('Direct form II SOS - IIR Impulse Reponse');
    xlabel('nT (Seconds)');
    ylabel('Magnitude (dB)');
    legend('Quantized Coefficients');
    
    %plot magnitude response
    subplot(3, 1, 2);
    hold on;
    plot((w1*(fs/(2*pi)))/1e3, (20*log10(abs(h1))) - 65); grid;
    plot((W1*(fs/(2*pi)))/1e3, (20*log10(abs(H1)) - 65), 'r');
    axis([0 8 -140 10]);
    title('Direct form II SOS - IIR Magnitude Response');
    xlabel('Frequency (kHz)');
    ylabel('Magnitude (dB)');
    legend('Quantized Coefficients', 'Non-Quantized Coefficients');
    
    %plot phase response
    subplot(3, 1, 3);
    hold on;
    plot((w1*(fs/(2*pi)))/1e3, unwrap(angle(h1))/2);grid;
    plot((W1*(fs/(2*pi)))/1e3, unwrap(angle(H1))/2, 'r');
    title('Direct form II SOS - IIR Phase Response');
    xlabel('Frequency (kHz)');
    ylabel('Phase (radians)');
    legend('Quantized Coefficients', 'Non-Quantized Coefficients');
    
else
    disp('type not recognized, please provide FIR, IIR1, or IIR2 for type');
end

end