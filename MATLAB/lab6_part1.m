%this function takes in a matrix of coefficients representing an FIR filter
%and then creates a white noise signal fitlered using those coefficients
%then, it outputs the signal over the speaker line, while recording the 
%response from the microphone line
function [] = lab6_part1(coeff)

clf;

fs = 44100; % sampling frequency
T = 30; % duration in seconds (use higher number for lab testing)
x(1,:) = 2*rand(fs*T,1)-1; % zero-mean uniformly distributed noise
x = x*0.95; % reduce the amplitude of x to 95% of full scale
y_n = filter(coeff, 1, x); % filter noise to represent 'unknown' system

% -- COMMENTED OUT FOR TESTING -- %
recorder = audiorecorder(fs, 16, 2); % create a recorder object
sound(y_n, fs);pause(20);record(recorder, 5); % play filtered noise, and record the response from DSK
pause(6); % pause to let sound play and record record
y = getaudiodata(recorder); % grab audio data
% -- COMMENTED OUT FOR TESTING -- %

% mu = 0.1; %step size
% M = length(coeff); % start with order of passed "unknown" system for testing purposes
% b_adpt(1,:) = ones(1,M); % initialize adaptive filter
set(gca, 'Ydir', 'reverse');

% view(3);
%adapt dat filtah
% for lp = M:length(x)
%     xx = fliplr(x(lp-M+1:lp)); % flip into x[n], x[n-1], ... , x[n-(M-1)] format
%     yhat = b_adpt*xx.';
%     err = y_n(lp) - yhat;
%     b_adpt = b_adpt + (mu*err*xx);
%     hold on;
%     [H, a] = freqz(b_adpt, 512);
%     lp_v = ones(512, 1);  
%     if mod(lp, 9) == 0
%         plot3(a, lp_v*lp, 20*log10(abs(H)), 'Color', [0.2, lp/length(x), 0.6]);
%     end 
%     pause(0.005);
%  end

%and apply it sonn
% y_nhat = filter(b_adpt, 1, x);

figure(1);
% estimate spectrum of 'unknown' output
[Px,f] = pwelch(y_n,1024,512,1024,fs);
% estimate spectrum of filtered output
[Py,f] = pwelch(y(:,2),1024,512,1024,fs);
% [Py, f] = pwelch(y_nhat, 1024, 512, 1024, fs);
% plot spectra in dB with grid lines
z = ones(1, length(f));
% view(3);
% plot3(f/1000,z,10*log10(abs(Px)),f/1000,(z+1),10*log10(abs(Py)));
plot(f/1000, 10*log10(abs(Px)), f/1000, 10*log10(abs(Py))); grid;
title('Direct form I – FIR');
xlabel('frequency (kHz)');
ylabel('');
zlabel('magnitude response (dB)');
legend('unknown system', 'adapated filter');

end
