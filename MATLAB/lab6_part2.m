%this take in a .WAV filename and then adds whitenoise to the left channel
%while providing the original noise on the right channel for the purposes
%of filtering

function [] = lab6_part2(wav, coeff)

clf;
T = 20;
Fs = 44100;
[s,fs] = audioread(wav, [1,T*Fs]);

%create additive noise
% w = 2*rand(fs*T,1)-1; % zero-mean uniformly distributed noise
% w = w*0.15; % reduce the amplitude of w to 95% of full scale
% w_p = filter(coeff, 1, w); %create correlated noise signal
% 
% s(:,1) = s(:,1) + w_p;      % noisy music on left channel
% s(:,2) = w_p;                 % noise on right channel
s(:,1) = s(:,1) * 0.75; % adjust amplitude to avoid clipping
s(:,2) = s(:,2) * 0.75;

recorder = audiorecorder(fs, 16, 2); % create a recorder object
sound(s,fs);
pause(T/8);
record(recorder, T*0.9); % play filtered noise, and record the response from DSK
pause(T); % pause to let sound play and record
y = getaudiodata(recorder); % grab audio data

figure(1);
spectrogram(s(:,1), 1024, 512, 1024, fs/1000);
title('Spectrogram of Music and Correlated Noise');
view(-90,90);
set(gca, 'ydir', 'reverse');
colorbar;

figure(2);
spectrogram(y(:,2), 1024, 512, 1024, fs/1000);
title('Spectrogram of Music with Noise Filtered');
view(-90,90);
set(gca, 'ydir', 'reverse');
colorbar;

figure(3);
plot(y(:,1));
title('Time-Varying Error');
xlabel('samples');
ylabel('magnitude'); 


end