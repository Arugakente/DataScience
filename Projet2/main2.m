#Program Parameters



%Data Loading
workspace = pwd();
csv = csvread(strcat(workspace,"/Dataset/dataset.csv")); 
txt = textread(strcat(workspace,"/Dataset/dataset.csv"),"%s"); %for titles

N = csv(2:size(csv)(1), 2:size(csv)(2)); %without columns and rows titles

lines = cell(size(N)(1),1);
cols = cell(size(N)(2),1);

cols = ostrsplit(txt(1){:}, ",")(2:size(N)(2)+1); %without row x column title
for i=2:size(txt)
  lines(i-1) = ostrsplit(txt(i){:}, ",")(1); %only take the row title
endfor

%disp(cols);


%Matrix processing
%AFC (chi)

%hand, foot and total
ni = sum(N,2);
nj = sum(N,1);
n = sum(sum(N,2),1);

U = (ni .* nj) / n;

chi = zeros(size(N)(2), 1);
for j=1:size(N)(2)
  chi(j) = sum(  (((N(:,j))-U(:,j))./sqrt(U(:,j))) .* (((N(:,j))-U(:,j))./sqrt(U(:,j)))  );
endfor
chi *= 1/(size(N)(1)-1)

figure(1);
bar(1:size(chi), chi);


X = (N-U) ./ sqrt(U); %X matrix for ACP computing
%disp(X);

%ACP

disp("ACP DEBUG HERE")

#for easier debug :
#X = X(:,[1:30]);
X = X(:,[2,3,8,1]);
#X = X(:,[2,6,7,8,5,1]);
#disp(X);

#calcul de la matrice variance/covariance:
moy = mean(X);

Etype = std(X);
disp(Etype)

figure(2)
scatter(X(:,1),X(:,2))
figure(3)
scatter(X(:,3),X(:,4))

for i=1:columns(X)
   X(:,i)=(X(:,i)-moy(i))/Etype(i);
endfor

#verification de la standardisation :
#calcul de la matrice variance/covariance:
disp("V")
#V=(1/rows(X)).*(X'*X);
V=cov(X);
disp(V);
disp("std dev");
disp(std(X));
disp("avg");
disp(mean(X));
disp("X standardized");
disp(X);

figure(4)
scatter(X(:,1),X(:,2))
figure(5)
scatter(X(:,3),X(:,4))

[E,D] = eig(V);
#V = E * ((D/rows(X)).^(1/2));
disp(columns(X))

infoTot = sum(diag(D));
percentInfo = (diag(D)/infoTot)*100;

disp(D);
figure(6);
bar(percentInfo);


figure(7)
scatter(X(:,1),X(:,2))
figure(8)
scatter(X(:,2),X(:,1))

