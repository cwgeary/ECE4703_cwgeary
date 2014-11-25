%this plots things with theoretical SOS filter coefficients
function [] = plot_IIR_SOS(sos, SOS)

fs = 16000; % sampling frequency

%clear any existing figures
clf;

figure(1);

[h1, w1] = freqz(sos, fs);
[H1, W1] = freqz(SOS, fs);

%plot magnitude response
hold on;
plot((w1*(fs/(2*pi)))/1e3, (20*log10(abs(h1))) - 65); grid;
plot((W1*(fs/(2*pi)))/1e3, (20*log10(abs(H1)) - 65), 'r');

title('Direct form II SOS - IIR Magnitude Response');
axis([0 8 -120 10]);
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');
legend('Theoritical Quantized Coefficients', 'Theoretical Non-Quantized Coefficients');


end