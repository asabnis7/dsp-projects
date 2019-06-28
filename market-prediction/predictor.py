import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

aapl_raw = pd.read_csv('WIKI-AAPL.csv');
aapl_raw = aapl_raw[::-1];
aapl_df = aapl_raw.loc[:,('Date','Adj. Close')];
aapl_np = aapl_df.loc[:,'Adj. Close'].to_numpy();

start = 9000
end = 9397

aapl_close = aapl_np[start:end].reshape(end-start,1);

Y = len(aapl_close);
p = 20;

X = np.zeros((Y-p, p));
x = np.zeros((Y-p, 1));

year = 1;

for i in range(0, Y-p):
    for j in range(0, p):
        X[i,j] = aapl_close[i+j-1];

    x[i] = aapl_close[i+j];
    
    if (i > year*p):
        a = np.matmul(-np.linalg.pinv(X), x);
        year += 1;

a = np.matmul(-np.linalg.pinv(X), x);
xhat = np.matmul(-X, a);
aapl_new = aapl_close;
xhat_new = xhat;

for c in range(0,3):
    for i in range(0, Y-p):
        for j in range(0,p):
            X[i,j] = aapl_new[i+j+c];
    
    xhat = np.matmul(-X,a);
    xhat_new = np.append(xhat_new, xhat[-1,:]);
    #aapl_new = np.append(aapl_new, aapl_np[end+1+c]);
    aapl_new = np.append(aapl_new, xhat[-1,:]);

plt.plot(xhat_new, label='Prediction');
plt.plot(aapl_df.iloc[start+p-2:end].loc[:,'Adj. Close'].to_numpy(), label='AAPL Stock');
#plt.plot(aapl_new[p-c:-3], label='AAPL Stock');
plt.legend();
plt.show();
