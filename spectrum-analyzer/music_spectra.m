load('123-456-7890_40.mat');

oct = 12;
rep = 1;
fn = cell(2,rep*oct);
notes = {'A' 'A#' 'B' 'C' 'C#' 'D' 'D#' 'E' 'F' 'F#' 'G' 'G#'};

for l = 25:(2+rep)*oct
    fn{2,l-24} = 2^((l-49)/12)*440;
%     hold on, bar(i,fn{2,i-24},0.2);
end
% set(gca, 'YScale', 'log'), xlabel('Key #'), ylabel('Frequency (Hz)');
for m = 1:rep
    fn(1,1+(oct*(m-1)):oct*m) = notes;
end
% semilogy(25:(2+rep)*oct,cell2mat(fn(2,:)));

seq = cell2mat(fn(2,:));
fs = 8192;
bins = 12;
fo = min(seq);
fmax = max(seq);
Q = 1/(2^(1/bins)-1);
K = bins*ceil(log2(fmax/fo));
cq = zeros(1,K);

N = round(Q*fs/(fo*2^((K-1)/bins)));
sound(signal,fs);
h1 = figure;
hold on;
for g = 1:N:length(signal)-N
    for k = 1:K
        N = round(Q*fs/(fo*2^((k-1)/bins)));
        cq(k)= signal(1+g:N+g)*(hamming(N).*exp(-2*pi*i*Q*(0:N-1)'/N))/N;
        cq = cq./(max(cq));
    end
%     clf(h1);
%     h1 = bar(abs(cq));
%     drawnow;
end