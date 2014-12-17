%this function takes in a matrix of coefficients representing an FIR filter
%and then creates a white noise signal fitlered using those coefficients
%then, it outputs the signal over the speaker line, while recording the 
%response from the microphone line
function [] = lab6_part1(coeff)

clf;

fs = 44100; % sampling frequency
T = 5; % duration in seconds (use higher number for lab testing) 
x(1,:) = 2*rand(fs*T,1)-1; % zero-mean uniformly distributed noise
x = x*0.95; % reduce the amplitude of x to 95% of full scale


y_n(:,1) = x'; %put noise on left channel
y_n(:,2) = filter(coeff, 1, x)'; % filter noise to represent 'unknown' system on right channel

% -- COMMENTED OUT FOR TESTING -- %
recorder = audiorecorder(fs, 16, 2); % create a recorder object
sound(y_n, fs); %play y_n (noise on left channel, filtered noise "unknown system" on right channel)
record(recorder, T*.9); % record for half the time of output
pause(T); % pause to let sound finish playing, and recorder finish recording
y = getaudiodata(recorder); % grab audio data

T
length(y(:,1))/fs

% -- COMMENTED OUT FOR TESTING -- %


% set(gca, 'Ydir', 'reverse');
% z = ones(1, length(f));

figure(1);
% estimate spectrum of 'unknown' output
[Px,f] = pwelch(y_n(:,2),1024,512,1024,fs);
% estimate spectrum of filtered output
[Py,f] = pwelch(y(:,2),1024,512,1024,fs);
% [Py, f] = pwelch(y_nhat, 1024, 512, 1024, fs);
% plot spectra in dB with grid lines

% view(3);
% plot3(f/1000,z,10*log10(abs(Px)),f/1000,(z+1),10*log10(abs(Py)));
plot(f/1000, 10*log10(abs(Px)), f/1000, 10*log10(abs(Py))); grid;
title('Unknown System vs Adapted Filter Output');
xlabel('frequency (kHz)');
ylabel('magnitude response');
% zlabel('magnitude response (dB)');
legend('unknown system', 'adapated filter');

figure(2);
plot(y(:,1));
title('DAT ERRUR THO');

end
