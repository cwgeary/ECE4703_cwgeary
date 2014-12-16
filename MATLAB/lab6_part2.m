%this take in a .WAV filename and then adds whitenoise to the left channel
%while providing the original noise on the right channel for the purposes
%of filtering

function [] = lab6_part2(wav)

clf;
T = 10;
Fs = 44100;
l = 0:1/Fs:T;
[s,fs] = audioread(wav, [1,T*Fs]);

%create additive noise
% w = 2*rand(fs*T,1)-1; % zero-mean uniformly distributed noise
% w = w*0.95; % reduce the amplitude of w to 95% of full scale
% b = fir1(50,0.3);
% w_p = filter(b, 1, w); %create correlated noise signal
w = sin(2*pi*5000*l);
w(:, length(s(:,1))) = [];
w = w * 0.25;
w = w';
w_p = w;


s(:,1) = s(:,1) + w_p;    % noisy music on left channel
s(:,2) = w;             % noise on right channel

recorder = audiorecorder(fs, 16, 2); % create a recorder object
sound(s,fs);pause((length(s)/fs)/2);record(recorder, ((length(s)/fs)/2) - 1); % play filtered noise, and record the response from DSK
pause((length(s)/fs)/2); % pause to let sound play and record
y = getaudiodata(recorder); % grab audio data

figure(1);
spectrogram(s(:,1), 1024, 512, 1024, fs/1000);
title('Spectrogram of Music and Correlated Noise');

figure(2)
spectrogram(y(:,2), 1024, 512, 1024, fs/1000);
title('Spectrogram of Music with Noise Filtered');

% set(gca, 'Ydir', 'reverse');
% 
% % S = fft(s);
% % estimate spectrum of 'unknown' output
% [Px,f] = pwelch(s(:,2),1024,512,1024,fs);
% % estimate spectrum of filtered output
% [Py,f] = pwelch(y(:,2),1024,512,1024,fs);
% 
% % plot spectra in dB with grid lines
% % z = ones(1, length(f));
% % view(3);
% % plot3(f/1000,z,10*log10(abs(Px)),f/1000,(z+1),10*log10(abs(Py)));
% figure(1);
% plot(f/1000, 10*log10(abs(Px)), f/1000, 10*log10(abs(Py))); grid;
% title('Direct form I – FIR');
% xlabel('frequency (kHz)');
% zlabel('');
% ylabel('magnitude response (dB)');
% legend('unknown system', 'adapated filter');


end