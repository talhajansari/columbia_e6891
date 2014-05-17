function vec = feature(cep)
cep = cep/max(cep(:));
d = deltas(cep);
dd = deltas(d);
mu = [mean(cep,2);mean(d,2);mean(dd,2)];
sd = [std(cep,0,2);std(d,0,2);std(dd,0,2)];
vec = [mu;sd];