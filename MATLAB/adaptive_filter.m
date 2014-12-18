% This script provides an example of System Identification
% using an adaptive filter (LMS algorithm)

function [] = adaptive_filter(coeff, m_adpt, mu_t)

clf;
fs = 44100;
% create a filter to serve as the unknowed system 
B_unk = coeff;
M_unk = length(coeff);    		% length of unknown filter
H_Bunk = freqz(B_unk,512);   % frequency response 


length(coeff)

% figure(1);
% plot(20*log10(abs(H_Bunk)));grid
% figure(2);
clf;
x = rands(1,1024);  % create WGN input
d = filter(B_unk,1,x); % create output of Unknowed System

M = m_adpt;   % start with M of correct order
	     % having M ~= M_unk affects amount of final error
mu = mu_t;    % adaptive step size

clear b_adpt   
b_adpt(1,:) = ones(1,M);  % initialize adaptive filter

jj = 1;
% In this loop I keep all the iterations of b_adpt, y hat and err
% in general you wouldn't do this. There is no need and it takes up memory
% A more practical loop would be ...
%

for lp = M:length(x),
   xx = fliplr(x(lp-M+1:lp));  % length M input history = x[n], x[n-1] ... x[n-(M-1)]
   yhat = b_adpt * xx.';       % yhat = b_adpt dot transpose(xx)
   err = d(lp)-yhat;           % find error
   E(jj,:) = err;
   b_adpt = b_adpt + mu*err*xx;   % LMS update of b_adpt
   
   jj = jj + 1;
end

figure(1);
subplot(2,1,1);
impz(b_adpt, 1, [], fs); grid;
subplot(2,1,2);
[h, w] = freqz(b_adpt, 1, fs);
plot((w*(fs/(2*pi)))/1e3, 20*log10(abs(h))); grid;
title('Frequency Response of Adapted Filter');
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');

figure(2)
plot(E); grid;
title('Error');
xlabel('Samples');
ylabel('Magnitude');


%
% lp_v = ones(512,1);
% view(3);
% set(gca,'YDir','reverse');
% grid;
% 
% xlabel('frequency');
% ylabel('iterations');
% zlabel('magnitude');
% 
% for lp = M:length(x),
%   xx = fliplr(x(lp-M+1:lp));     % length M input history = x[n], x[n-1] ... x[n-(M-1)]
%   yhat(lp) = b_adpt(jj,:)*xx.';  % yhat = b_adpt dot transpose(xx)
%   err(lp) = d(lp)-yhat(lp);      % find error
%   b_adpt(jj+1,:) = b_adpt(jj,:) + mu*err(lp)*xx;   % LMS update of b_adpt 
%   jj=jj+1;
%   
%   hold on;
%   [H_B_adpt, x_adpt] = freqz(b_adpt(jj,:), 512);
%   lp_v = ones(512,1);
%   
%   if mod(lp, 9) == 0
%     plot3(x_adpt, lp_v*lp, 20*log10(abs(H_B_adpt)), 'Color', [0.2, lp/length(x), .6]);
%   end
%   
%   pause(0.005);
%   
% end

end