% This script provides an example of System Identification
% using an adaptive filter (LMS algorithm)

clf;

% create a filter to serve as the unknowed system 
B_unk = fir1(10,0.3);       
M_unk = 11;    		% length of unknown filter
H_Bunk = freqz(B_unk,512);   % frequency response 

figure(1);
plot(20*log10(abs(H_Bunk)));grid
figure(2);

x = rands(1,400);  % create WGN input
d = filter(B_unk,1,x); % create output of Unknowed System

M = M_unk;   % start with M of correct order
	     % having M ~= M_unk affects amount of final error
mu = 0.4;    % adaptive step size

clear b_adpt   
b_adpt(1,:) = ones(1,M);  % initialize adaptive filter

jj = 1;
% In this loop I keep all the iterations of b_adpt, y hat and err
% in general you wouldn't do this. There is no need and it takes up memory
% A more practical loop would be ...
%
% for lp = M:length(x),
%    xx = fliplr(x(lp-M+1:lp));  % length M input history = x[n], x[n-1] ... x[n-(M-1)]
%    yhat = b_adpt * xx.';       % yhat = b_adpt dot transpose(xx)
%    err = d(lp)-yhat;           % find error
%    b_adpt = b_adpt + mu*err*xx;   % LMS update of b_adpt
%end
%
lp_v = ones(512,1);
view(3);
set(gca,'YDir','reverse');
grid;

xlabel('frequency');
ylabel('iterations');
zlabel('magnitude');

for lp = M:length(x),
  xx = fliplr(x(lp-M+1:lp));     % length M input history = x[n], x[n-1] ... x[n-(M-1)]
  yhat(lp) = b_adpt(jj,:)*xx.';  % yhat = b_adpt dot transpose(xx)
  err(lp) = d(lp)-yhat(lp);      % find error
  b_adpt(jj+1,:) = b_adpt(jj,:) + mu*err(lp)*xx;   % LMS update of b_adpt 
  jj=jj+1;
  
  hold on;
  [H_B_adpt, x_adpt] = freqz(b_adpt(jj,:), 512);
  lp_v = ones(512,1);
  
  if mod(lp, 9) == 0
    plot3(x_adpt, lp_v*lp, 20*log10(abs(H_B_adpt)), 'Color', [0.2, lp/length(x), .6]);
  end
  
  pause(0.005);
  
end

