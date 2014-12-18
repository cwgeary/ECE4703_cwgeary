%this does the same thing as other lab 6 code but does with wav files
%instead

function [] = lab6_part1_wav(wav)

clf;
[s,fs] = audioread(wav);
recorder = audiorecorder(fs, 16, 2); % create a recorder object
sound(s,fs);pause((length(s)/fs)/2);record(recorder, ((length(s)/fs)/2) - 1); % play filtered noise, and record the response from DSK
pause((length(s)/fs)/2); % pause to let sound play and record record, FILTER IS ON RIGHT CHANNEL!!!
y = getaudiodata(recorder); % grab audio data

set(gca, 'Ydir', 'reverse');

% S = fft(s);
% estimate spectrum of 'unknown' output
[Px,f] = pwelch(s(:,2),1024,512,1024,fs);
% estimate spectrum of filtered output
[Py,f] = pwelch(y(:,2),1024,512,1024,fs);


% Y = fft(y, 1024);
% plot(20*log10(abs(Y(:,1))));
% pause()
% figure(2);
% plot(20*log10(abs(Y(:,2))));
% pause();s



% [Py, f] = pwelch(y_nhat, 1024, 512, 1024, fs);
% plot spectra in dB with grid lines
% view(3);
% plot3(f/1000,z,10*log10(abs(Px)),f/1000,(z+1),10*log10(abs(Py)));
figure(1);
plot(f/1000, 10*log10(abs(Px)), f/1000, 10*log10(abs(Py))); grid;
title('Direct form I – FIR');
xlabel('frequency (kHz)');
ylabel('magnitude response (dB)');
legend('unknown system', 'adapated filter');

figure(2);
plot(y(:,1));
title('Time-Varying Error');
xlabel('samples');
ylabel('magnitude');

% figure(2);
% 
% S = fft(s);
% freq = 0:fs/length(s):fs;
% 
% for i = 1:length(freq) - 1
%     Freq(1,i) = freq(1,i);
% end
% 
% plot(Freq, 10*log10(abs(S(:,2))));

end