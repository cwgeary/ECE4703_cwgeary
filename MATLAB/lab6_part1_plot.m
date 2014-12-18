%can just copy-pasta memory contents from DSK memory viewer into B_adpt
%this script will fix it to be a row matrix so it works all nice and 
%fun like
function [] = lab6_part1_plot(B_supp, B_adpt)

clf;
fs = 44100;

B_adpt_fixed = reshape(B_adpt.', 1, []);

figure(1);
[h1, w1] = freqz(B_supp, 1, fs);
[H1, W1] = freqz(B_adpt_fixed, 1, fs);

%plot impulse response
subplot(2, 1, 1);
impz(B_supp, 1, [], fs); grid;
title('Impulse Response of "Unknown" System');
xlabel('nT (Seconds)');
ylabel('Magnitude (dB)');

subplot(2, 1, 2);
plot((w1*(fs/(2*pi)))/1e3, (20*log10(abs(h1)) - 50)); grid;
title('Magnitude of "Unknown" System');
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');

figure(2);

%plot magnitude response
subplot(2, 1, 1);
impz(B_adpt_fixed, 1, [], fs); grid;
title('Impulse Response of Adaptive Filter');
xlabel('nT (Seconds)');
ylabel('Magnitude (dB)');


subplot(2, 1, 2);
plot((W1*(fs/(2*pi)))/1e3, 20*log10(abs(H1)) - 50, 'r'); grid;
title('Magnitude of Adaptive Filter');
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');



end