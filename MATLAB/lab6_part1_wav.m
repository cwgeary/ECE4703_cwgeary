%this does the same thing as other lab 6 code but does with wav files
%instead

function [] = lab6_part1_wav(wav)

[s,fs] = audioread(wav);
recorder = audiorecorder(fs, 16, 2); % create a recorder object
sound(s,fs);pause((length(s)/fs)/2);record(recorder, ((length(s)/fs)/2) - 1); % play filtered noise, and record the response from DSK
pause((length(s)/fs)/2); % pause to let sound play and record record
y = getaudiodata(recorder); % grab audio data

set(gca, 'Ydir', 'reverse');

figure(1);
% S = fft(s);
% estimate spectrum of 'unknown' output
[Px,f] = pwelch(s,1024,512,1024,fs);
% estimate spectrum of filtered output
[Py,f] = pwelch(y(:,2),1024,512,1024,fs);
% [Py, f] = pwelch(y_nhat, 1024, 512, 1024, fs);
% plot spectra in dB with grid lines
z = ones(1, length(f));
% view(3);
% plot3(f/1000,z,10*log10(abs(Px)),f/1000,(z+1),10*log10(abs(Py)));
plot(f/1000, 10*log10(abs(Px)), f/1000, 10*log10(abs(Py))); grid;
title('Direct form I � FIR');
xlabel('frequency (kHz)');
zlabel('');
ylabel('magnitude response (dB)');
legend('unknown system', 'adapated filter');

figure(2);

S = fft(s);
freq = 0:fs/length(s):fs;

for i = 1:length(freq) - 1
    Freq(1,i) = freq(1,i);
end

plot(Freq, 10*log10(abs(S)));

end