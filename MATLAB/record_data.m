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

% estimate spectrum of unfiltered output
[Px,f] = pwelch(x,1024,512,1024,fs);
% estimate spectrum of filtered output
[Py,f] = pwelch(y(:,2),1024,512,1024,fs);
