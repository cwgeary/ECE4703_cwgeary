%this function takes in a matrix of coefficients representing an FIR filter
%and then creates a white noise signal fitlered using those coefficients
%then, it outputs the signal over the speaker line, while recording the 
%response from the microphone line
function [] = lab6_part1(coeff)

fs = 44100; % sampling frequency
T = 10; % duration in seconds
x = 2*rand(fs*T,1)-1; % zero-mean uniformly distributed noise
x = x*0.95; % reduce the amplitude of x to 95% of full scale
X = filter(coeff, 1, x); % filter noise to represent 'unknown' system

recorder = audiorecorder(fs, 16, 2); % create a recorder object

sound(X, fs);record(recorder, 5); % play filtered noise, and record the response from DSK

pause(10); % pause to let sound play and record record

% now grab audio data
y = getaudiodata(recorder);

% estimate spectrum of 'unknown' output
[Px,f] = pwelch(X,1024,512,1024,fs);
% estimate spectrum of filtered output
[Py,f] = pwelch(y(:,2),1024,512,1024,fs);
% plot spectra in dB with grid lines
plot(f/1000,10*log10(Px),f/1000,10*log10(Py)); grid;
figure(1);
title('Direct form I – FIR');
xlabel('frequency (kHz)');
ylabel('magnitude response (dB)')


end
