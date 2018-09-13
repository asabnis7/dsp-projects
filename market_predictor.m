% Open, High, Low, Close
stock_raw = csvread('DJI.csv');
stock = stock_raw(1:end-10,4);
Y = length(stock);

p = 400;
X = zeros(Y-p,p);
x = zeros(Y-p,1);
year = 1;
for i = 1:Y-p
    for j = 1:p
        X(i,j) = stock(i+j-1);
    end
    x(i) = stock(i+j);
    
    if i > year*400
        a = -X\x;
        year = year+1;
    end
end

a = -X\x;
xhat = -X*a;
new_stock = stock;

for c = 1:10
    for i = 1:Y-p+1
        for j = 1:p
            X(i,j) = new_stock(i+j-1);
        end
    end
    xhat = -X*a;
    new_stock = [new_stock; xhat(end)];
    Y = length(new_stock);
end

hold on, plot(stock(400:end)), plot(xhat);
