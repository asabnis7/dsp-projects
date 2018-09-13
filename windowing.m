
% ECE 4270 - HW5 - Windowing
% Question 1

% Part (a)
M = 45;
A = 60;
% Since A > 50, we use the below formula:
beta = 0.1102*(A-8.7); % ---> beta = 5.6533
 
% Part (b)
wc1 = pi/3; wc2 = 2*pi/3;
n = 0:1:M-1;
m = n - (M-1)/2 + eps;
hn1 = sin(wc1.*m)./(pi*m);  
hn2 = sin(wc2.*m)./(pi*m);
hn3 = sin(pi.*m)./(pi*m);
hdn = hn1 - hn2 + hn3;
stem(n, hdn); title('Ideal Impulse Response'); ylabel('h_d[n]'); xlabel('\itn');
 
% Part (c)
wn = kaiser(M, beta);
stem(n, wn); title('Kaiser Window, M=45'); ylabel('w[n]'); xlabel('\itn');
 
% Part (d)
hn = hdn .* wn';
stem(hn); title('Actual Impulse Response'); ylabel('h[n]'); xlabel('\itn');
 
% Part (e)
[H,W] = freqz(hn,1);
plot(W,20*log10(abs(H))); axis([0 pi -100 5]);
title('Frequency Response'); ylabel('Amplitude (dB)'); xlabel('\omega (Normalized)');

% Question 2, Part (b)
M = 21;
n = 0:1:M-1;
m = n - (M-1)/2;
hdn = cos(pi*m)./m; hdn((M-1)/2+1) = 0;
stem(n, hdn); title('Ideal Impulse Response'); ylabel('h_d[n]'); xlabel('\itn');

% Part (c)
wn = hamming(M);
stem(n, wn); title('Hamming Window, M=21'); ylabel('w[n]'); xlabel('\itn');

% Part (d)
hn = hdn .* wn';
stem(n,hn); title('Actual Impulse Response'); ylabel('h[n]'); xlabel('\itn');

% Part (e)
[H,W] = freqz(hn,1);
plot(W,angle(H)); title('Phase Response'); ylabel('Angle(rad)'); xlabel('\omega (Normalized)');

% Part (f)
plot(W,abs(H)); title('Frequency Response'); ylabel('Amplitude'); xlabel('\omega (Normalized)');
