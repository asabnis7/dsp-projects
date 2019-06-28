# Arjun Sabnis
# Market predictor algorithm

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

aapl_raw = pd.read_csv('WIKI-AAPL.csv');
aapl_raw = aapl_raw[::-1];
aapl_df = aapl_raw.loc[:,('Date','Adj. Close')];
aapl_np = aapl_df.loc[:,'Adj. Close'].to_numpy();

start = 9200
end = 9398

aapl_close = aapl_np[start:end].reshape(end-start,1);

N = len(aapl_close);
p = 40;

X = np.zeros((N-p, p));
x = np.zeros((N-p, 1));

year = 1;

for i in range(0,N-p):
    for j in range(0,p):
        X[i,j] = aapl_close[i+j];

    x[i] = aapl_close[i+j+1];
    
    if (i > year*p):
        a = np.matmul(-np.linalg.pinv(X), x);
        year += 1;

a = np.matmul(-np.linalg.pinv(X), x);
xhat = np.matmul(-X, a);
aapl_new = aapl_close;
xhat_new = xhat;

#for i in range(0,N-p):
#    for j in range(0,p):
#        X[i,j] = aapl_new[i+j+c];
#xhat = np.matmul(-X,a);
#xhat_new = np.append(xhat_new, xhat[-1,:]);
#aapl_new = np.append(aapl_new, xhat[-1,:]);
#aapl_new = np.append(aapl_new, aapl_np[end+1+c]);

for c in range(0,5):
    xhat = -np.dot(a.T, np.flip(aapl_new[N-p:N]))
    xhat_new = np.concatenate((xhat_new, xhat));
    aapl_new = np.concatenate((aapl_new, xhat));
    N = len(aapl_new);

plt.plot(xhat_new, label='Prediction');
plt.plot(aapl_df.iloc[start+p-1:end].loc[:,'Adj. Close'].to_numpy(), label='AAPL Data');
plt.legend();
plt.show();
