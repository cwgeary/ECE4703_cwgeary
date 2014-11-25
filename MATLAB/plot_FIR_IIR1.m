%this plots things with theoretical coefficient values for nonSOS filters
function [] = plot_FIR_IIR1(type, b, a, B, A)

fs = 16000; % sampling frequency

%clear any existing figures
clf;

figure(1);

[h1, w1] = freqz(b, a, fs);
[H1, W1] = freqz(B, A, fs);

%plot magnitude response
hold on;
plot((w1*(fs/(2*pi)))/1e3, (20*log10(abs(h1))) - 50); grid;
plot((W1*(fs/(2*pi)))/1e3, 20*log10(abs(H1)), 'r');
if strcmp('FIR', type)
    title('Direct form I - FIR Magnitude Response');
    xlabel('Frequency (kHz)');
    ylabel('Magnitude (dB)');
    legend('Theoritical Quantized Coefficients', 'Theoretical Non-Quantized Coefficients');

elseif strcmp('IIR', type)
    axis([0 8 -140 10]);
    title('Direct form II - IIR Magnitude Response');
    xlabel('Frequency (kHz)');
    ylabel('Magnitude (dB)');
    legend('Theoritical Quantized Coefficients', 'Theoretical Non-Quantized Coefficients');
    
else
    disp('incorrect type. please specifiy "FIR" or "IIR" as type');
    
end
